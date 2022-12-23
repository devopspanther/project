    MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="//"

--//
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
set -xe

# Install newer Amazon supported kernel
amazon-linux-extras install -y kernel-ng
yum install -y amazon-ssm-agent
yum update -y
 
TOKEN="$(curl -X PUT -H "X-aws-ec2-metadata-token-ttl-seconds: 600" "http://169.254.169.254/latest/api/token")"
INSTANCE_LIFECYCLE="$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/instance-life-cycle)"
INSTANCE_ID="$(curl -H "X-aws-ec2-metadata-token: $TOKEN" --silent http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .instanceId -r)"
REGION="$(curl -H "X-aws-ec2-metadata-token: $TOKEN" --silent http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region -r)"
LAUNCH_TEMPLATE_VERSION="$(aws ec2 describe-tags --region "$REGION" --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=tag-key,Values=aws:ec2launchtemplate:version" --query 'Tags[0].Value')"
LAUNCH_TEMPLATE_ID="$(aws ec2 describe-tags --region "$REGION" --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=tag-key,Values=aws:ec2launchtemplate:id" --query 'Tags[0].Value')"
NODEGROUP="$(aws ec2 describe-tags --region "$REGION" --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=tag-key,Values=eks:nodegroup-name" --query 'Tags[0].Value')"

# AMI ID is passed by the default MNG launch template, but node joins the cluster without it also. 
# Also as we have just updated the kernel, ami id would need to be queried from somewhere.
# eks.amazonaws.com/nodegroup-image=ami-05cd1e07212dd719a

# TODO: dynamic eks.amazonaws.com/capacityType=ON_DEMAND from INSTANCE_LIFECYCLE
EKS_MNG_LABELS="eks.amazonaws.com/sourceLaunchTemplateVersion=$LAUNCH_TEMPLATE_VERSION,eks.amazonaws.com/capacityType=ON_DEMAND,eks.amazonaws.com/sourceLaunchTemplateId=$LAUNCH_TEMPLATE_ID,eks.amazonaws.com/nodegroup=$NODEGROUP"

# https://github.com/awslabs/amazon-eks-ami/blob/0a96824d7b60d0930c846f5d6841d1c10ff411d2/files/bootstrap.sh#L273
K8S_CLUSTER_DNS_IP=172.20.0.10

# Userdata is only executed at the first boot of an EC2 instance.
# Prepare bootstrap instructions which will be executed at the second boot.
cat >/etc/rc.d/rc.local <<EOF
#!/bin/bash
set -xe

# Bootstrap and join the cluster
# https://github.com/awslabs/amazon-eks-ami/blob/master/files/bootstrap.sh
/etc/eks/bootstrap.sh \
  --b64-cluster-ca '${cluster_auth_base64}' \
  --apiserver-endpoint '${endpoint}' \
  --dns-cluster-ip "$K8S_CLUSTER_DNS_IP" \
  ${bootstrap_extra_args} \
  --kubelet-extra-args '--node-labels=${k8s_labels} --node-labels=$EKS_MNG_LABELS' \
  '${cluster_name}'

touch /var/lock/subsys/local
EOF

chmod +x /etc/rc.d/rc.local
systemctl enable rc-local.service

# Start again with the new kernel
reboot

--//--