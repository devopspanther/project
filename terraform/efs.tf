resource "aws_efs_file_system" "efs-storage" {
  #checkov:skip=CKV_AWS_184:No backup is needed for these volumes
  creation_token = "${local.cluster_name}-efs-storage"
  encrypted      = true
  tags = {
    Name = "${local.cluster_name}-efs-storage"
  }
}

resource "aws_efs_mount_target" "efs-storage-1" {
  file_system_id  = aws_efs_file_system.efs-storage.id
  subnet_id       = element(module.vpc.private_subnets, 0)
  security_groups = [aws_security_group.nfs_eks_efs.id]
}

resource "aws_efs_mount_target" "efs-storage-2" {
  file_system_id  = aws_efs_file_system.efs-storage.id
  subnet_id       = element(module.vpc.private_subnets, 1)
  security_groups = [aws_security_group.nfs_eks_efs.id]
}

resource "kubernetes_storage_class" "efs-ci" {
  metadata {
    name = "efs-ci"
  }
  storage_provisioner = "efs.csi.aws.com"
  reclaim_policy      = "Retain"
}

resource "aws_efs_access_point" "sde-1" {
  file_system_id = aws_efs_file_system.efs-storage.id
  posix_user {
    uid = "0"
    gid = "0"
  }
}
resource "kubernetes_persistent_volume" "sde-1" {
  metadata {
    name = "sde-1"
  }
  spec {
    storage_class_name               = "efs-ci"
    persistent_volume_reclaim_policy = "Retain"
    capacity = {
      storage = "30Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = "${aws_efs_file_system.efs-storage.id}::${aws_efs_access_point.sde-1.id}"
      }
    }
  }
}

resource "aws_efs_access_point" "sde-2" {
  file_system_id = aws_efs_file_system.efs-storage.id
  posix_user {
    uid = "0"
    gid = "0"
  }
}
resource "kubernetes_persistent_volume" "sde-2" {
  metadata {
    name = "sde-2"
  }
  spec {
    storage_class_name               = "efs-ci"
    persistent_volume_reclaim_policy = "Retain"
    capacity = {
      storage = "2Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = "${aws_efs_file_system.efs-storage.id}::${aws_efs_access_point.sde-2.id}"
      }
    }
  }
}

resource "aws_efs_access_point" "sde-3" {
  file_system_id = aws_efs_file_system.efs-storage.id
  posix_user {
    uid = "0"
    gid = "0"
  }
}
resource "kubernetes_persistent_volume" "sde-3" {
  metadata {
    name = "sde-3"
  }
  spec {
    storage_class_name               = "efs-ci"
    persistent_volume_reclaim_policy = "Retain"
    capacity = {
      storage = "2Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = "${aws_efs_file_system.efs-storage.id}::${aws_efs_access_point.sde-3.id}"
      }
    }
  }
}

resource "aws_efs_access_point" "sde-4" {
  file_system_id = aws_efs_file_system.efs-storage.id
  posix_user {
    uid = "0"
    gid = "0"
  }
}
resource "kubernetes_persistent_volume" "sde-4" {
  metadata {
    name = "sde-4"
  }
  spec {
    storage_class_name               = "efs-ci"
    persistent_volume_reclaim_policy = "Retain"
    capacity = {
      storage = "2Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = "${aws_efs_file_system.efs-storage.id}::${aws_efs_access_point.sde-4.id}"
      }
    }
  }
}

resource "aws_efs_access_point" "sde-5" {
  file_system_id = aws_efs_file_system.efs-storage.id
  posix_user {
    uid = "0"
    gid = "0"
  }
}
resource "kubernetes_persistent_volume" "sde-5" {
  metadata {
    name = "sde-5"
  }
  spec {
    storage_class_name               = "efs-ci"
    persistent_volume_reclaim_policy = "Retain"
    capacity = {
      storage = "4Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = "${aws_efs_file_system.efs-storage.id}::${aws_efs_access_point.sde-5.id}"
      }
    }
  }
}

resource "aws_efs_access_point" "sde-6" {
  file_system_id = aws_efs_file_system.efs-storage.id
  posix_user {
    uid = "0"
    gid = "0"
  }
}
resource "kubernetes_persistent_volume" "sde-6" {
  metadata {
    name = "sde-6"
  }
  spec {
    storage_class_name               = "efs-ci"
    persistent_volume_reclaim_policy = "Retain"
    capacity = {
      storage = "4Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = "${aws_efs_file_system.efs-storage.id}::${aws_efs_access_point.sde-6.id}"
      }
    }
  }
}

resource "aws_efs_access_point" "sde-7" {
  file_system_id = aws_efs_file_system.efs-storage.id
  posix_user {
    uid = "0"
    gid = "0"
  }
}
resource "kubernetes_persistent_volume" "sde-7" {
  metadata {
    name = "sde-7"
  }
  spec {
    storage_class_name               = "efs-ci"
    persistent_volume_reclaim_policy = "Retain"
    capacity = {
      storage = "10Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = "${aws_efs_file_system.efs-storage.id}::${aws_efs_access_point.sde-7.id}"
      }
    }
  }
}

resource "aws_efs_access_point" "sde-8" {
  file_system_id = aws_efs_file_system.efs-storage.id
  posix_user {
    uid = "0"
    gid = "0"
  }
}
resource "kubernetes_persistent_volume" "sde-8" {
  metadata {
    name = "sde-8"
  }
  spec {
    storage_class_name               = "efs-ci"
    persistent_volume_reclaim_policy = "Retain"
    capacity = {
      storage = "10Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = "${aws_efs_file_system.efs-storage.id}::${aws_efs_access_point.sde-8.id}"
      }
    }
  }
}

resource "aws_efs_access_point" "sde-9" {
  file_system_id = aws_efs_file_system.efs-storage.id
  posix_user {
    uid = "0"
    gid = "0"
  }
}
resource "kubernetes_persistent_volume" "sde-9" {
  metadata {
    name = "sde-9"
  }
  spec {
    storage_class_name               = "efs-ci"
    persistent_volume_reclaim_policy = "Retain"
    capacity = {
      storage = "10Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = "${aws_efs_file_system.efs-storage.id}::${aws_efs_access_point.sde-9.id}"
      }
    }
  }
}

resource "aws_efs_access_point" "sde-10" {
  file_system_id = aws_efs_file_system.efs-storage.id
  posix_user {
    uid = "0"
    gid = "0"
  }
}
resource "kubernetes_persistent_volume" "sde-10" {
  metadata {
    name = "sde-10"
  }
  spec {
    storage_class_name               = "efs-ci"
    persistent_volume_reclaim_policy = "Retain"
    capacity = {
      storage = "10Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = "${aws_efs_file_system.efs-storage.id}::${aws_efs_access_point.sde-10.id}"
      }
    }
  }
}

resource "aws_efs_access_point" "sde-11" {
  file_system_id = aws_efs_file_system.efs-storage.id
  posix_user {
    uid = "0"
    gid = "0"
  }
}
resource "kubernetes_persistent_volume" "sde-11" {
  metadata {
    name = "sde-11"
  }
  spec {
    storage_class_name               = "efs-ci"
    persistent_volume_reclaim_policy = "Retain"
    capacity = {
      storage = "30Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = "${aws_efs_file_system.efs-storage.id}::${aws_efs_access_point.sde-11.id}"
      }
    }
  }
}

resource "aws_efs_access_point" "sde-12" {
  file_system_id = aws_efs_file_system.efs-storage.id
  posix_user {
    uid = "0"
    gid = "0"
  }
}
resource "kubernetes_persistent_volume" "sde-12" {
  metadata {
    name = "sde-12"
  }
  spec {
    storage_class_name               = "efs-ci"
    persistent_volume_reclaim_policy = "Retain"
    capacity = {
      storage = "2Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = "${aws_efs_file_system.efs-storage.id}::${aws_efs_access_point.sde-12.id}"
      }
    }
  }
}

resource "aws_efs_access_point" "sde-13" {
  file_system_id = aws_efs_file_system.efs-storage.id
  posix_user {
    uid = "0"
    gid = "0"
  }
}
resource "kubernetes_persistent_volume" "sde-13" {
  metadata {
    name = "sde-13"
  }
  spec {
    storage_class_name               = "efs-ci"
    persistent_volume_reclaim_policy = "Retain"
    capacity = {
      storage = "2Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = "${aws_efs_file_system.efs-storage.id}::${aws_efs_access_point.sde-13.id}"
      }
    }
  }
}

resource "aws_efs_access_point" "sde-14" {
  file_system_id = aws_efs_file_system.efs-storage.id
  posix_user {
    uid = "0"
    gid = "0"
  }
}
resource "kubernetes_persistent_volume" "sde-14" {
  metadata {
    name = "sde-14"
  }
  spec {
    storage_class_name               = "efs-ci"
    persistent_volume_reclaim_policy = "Retain"
    capacity = {
      storage = "2Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = "${aws_efs_file_system.efs-storage.id}::${aws_efs_access_point.sde-14.id}"
      }
    }
  }
}

resource "aws_efs_access_point" "sde-15" {
  file_system_id = aws_efs_file_system.efs-storage.id
  posix_user {
    uid = "0"
    gid = "0"
  }
}
resource "kubernetes_persistent_volume" "sde-15" {
  metadata {
    name = "sde-15"
  }
  spec {
    storage_class_name               = "efs-ci"
    persistent_volume_reclaim_policy = "Retain"
    capacity = {
      storage = "4Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = "${aws_efs_file_system.efs-storage.id}::${aws_efs_access_point.sde-15.id}"
      }
    }
  }
}

resource "aws_efs_access_point" "sde-16" {
  file_system_id = aws_efs_file_system.efs-storage.id
  posix_user {
    uid = "0"
    gid = "0"
  }
}
resource "kubernetes_persistent_volume" "sde-16" {
  metadata {
    name = "sde-16"
  }
  spec {
    storage_class_name               = "efs-ci"
    persistent_volume_reclaim_policy = "Retain"
    capacity = {
      storage = "4Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = "${aws_efs_file_system.efs-storage.id}::${aws_efs_access_point.sde-16.id}"
      }
    }
  }
}

resource "aws_efs_access_point" "sde-17" {
  file_system_id = aws_efs_file_system.efs-storage.id
  posix_user {
    uid = "0"
    gid = "0"
  }
}
resource "kubernetes_persistent_volume" "sde-17" {
  metadata {
    name = "sde-17"
  }
  spec {
    storage_class_name               = "efs-ci"
    persistent_volume_reclaim_policy = "Retain"
    capacity = {
      storage = "10Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = "${aws_efs_file_system.efs-storage.id}::${aws_efs_access_point.sde-17.id}"
      }
    }
  }
}

resource "aws_efs_access_point" "sde-18" {
  file_system_id = aws_efs_file_system.efs-storage.id
  posix_user {
    uid = "0"
    gid = "0"
  }
}
resource "kubernetes_persistent_volume" "sde-18" {
  metadata {
    name = "sde-18"
  }
  spec {
    storage_class_name               = "efs-ci"
    persistent_volume_reclaim_policy = "Retain"
    capacity = {
      storage = "10Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = "${aws_efs_file_system.efs-storage.id}::${aws_efs_access_point.sde-18.id}"
      }
    }
  }
}

resource "aws_efs_access_point" "sde-19" {
  file_system_id = aws_efs_file_system.efs-storage.id
  posix_user {
    uid = "0"
    gid = "0"
  }
}
resource "kubernetes_persistent_volume" "sde-19" {
  metadata {
    name = "sde-19"
  }
  spec {
    storage_class_name               = "efs-ci"
    persistent_volume_reclaim_policy = "Retain"
    capacity = {
      storage = "10Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = "${aws_efs_file_system.efs-storage.id}::${aws_efs_access_point.sde-19.id}"
      }
    }
  }
}

resource "aws_efs_access_point" "sde-20" {
  file_system_id = aws_efs_file_system.efs-storage.id
  posix_user {
    uid = "0"
    gid = "0"
  }
}
resource "kubernetes_persistent_volume" "sde-20" {
  metadata {
    name = "sde-20"
  }
  spec {
    storage_class_name               = "efs-ci"
    persistent_volume_reclaim_policy = "Retain"
    capacity = {
      storage = "10Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = "${aws_efs_file_system.efs-storage.id}::${aws_efs_access_point.sde-20.id}"
      }
    }
  }
}

resource "aws_efs_access_point" "sde-21" {
  file_system_id = aws_efs_file_system.efs-storage.id
  posix_user {
    uid = "0"
    gid = "0"
  }
}
resource "kubernetes_persistent_volume" "sde-21" {
  metadata {
    name = "sde-21"
  }
  spec {
    storage_class_name               = "efs-ci"
    persistent_volume_reclaim_policy = "Retain"
    capacity = {
      storage = "10Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = "${aws_efs_file_system.efs-storage.id}::${aws_efs_access_point.sde-21.id}"
      }
    }
  }
}

resource "aws_efs_access_point" "sde-22" {
  file_system_id = aws_efs_file_system.efs-storage.id
  posix_user {
    uid = "0"
    gid = "0"
  }
}
resource "kubernetes_persistent_volume" "sde-22" {
  metadata {
    name = "sde-22"
  }
  spec {
    storage_class_name               = "efs-ci"
    persistent_volume_reclaim_policy = "Retain"
    capacity = {
      storage = "10Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = "${aws_efs_file_system.efs-storage.id}::${aws_efs_access_point.sde-22.id}"
      }
    }
  }
}
