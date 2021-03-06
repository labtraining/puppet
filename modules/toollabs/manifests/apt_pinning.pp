# This class holds all the apt pinning for key packages in the Toolforge cluster

class toollabs::apt_pinning {

    #
    # linux kernel
    #
    # virtual meta-package, they usually have 3 levels of indirection:
    # linux-meta -> linux-meta-4.9 -> linux-image-4.9-xx
    # trusty is a bit different, only 2 levels but different 'flavours'
    $linux_meta_pkg = $facts['lsbdistcodename'] ? {
        'trusty'  => 'linux-image-generic',
        'jessie'  => 'linux-meta*',
        'stretch' => 'linux-image-amd64',
    }
    $linux_meta_pkg_version = $facts['lsbdistcodename'] ? {
        'trusty'  => 'version 3.13.0.141.151',
        'jessie'  => 'version 1.16',
        'stretch' => 'version 4.9+80+deb9u3',
    }
    apt::pin { 'toolforge-linux-meta-pinning':
        package  => $linux_meta_pkg,
        pin      => $linux_meta_pkg_version,
        priority => '1001',
    }
    # actual kernel package. Pinning only this is not enough, given that the meta-package
    # could be upgraded pointing to another version and then you would have a pending reboot
    $linux_pkg = $facts['lsbdistcodename'] ? {
        'trusty'  => 'linux-image-3.13.0-141-generic',
        'jessie'  => 'linux-image-4.9.0-0.bpo.5-amd64',
        'stretch' => 'linux-image-4.9.0-5-amd64',
    }
    $linux_pkg_version = $facts['lsbdistcodename'] ? {
        'trusty'  => 'version 3.13.0-141.190',
        'jessie'  => 'version 4.9.65-3+deb9u1~bpo8+2',
        'stretch' => 'version 4.9.65-3+deb9u2',
    }
    apt::pin { 'toolforge-linux-pinning':
        package  => $linux_pkg,
        pin      => $linux_pkg_version,
        priority => '1001',
    }

    #
    # pam libs and related packages
    #
    $libpam_pkg_version = $facts['lsbdistcodename'] ? {
        'trusty'  => 'version 1.1.8-1ubuntu2.2',
        'jessie'  => 'version 1.1.8-3.1+deb8u1*',
        'stretch' => 'version 1.1.8-3.6',
    }
    apt::pin { 'toolforge-libpam-pinning':
        package  => 'libpam-runtime libpam-modules* libpam0g',
        pin      => $libpam_pkg_version,
        priority => '1001',
    }
    $libpam_ldapd_pkg_version = $facts['lsbdistcodename'] ? {
        'trusty'  => 'version 0.8.13-3ubuntu1',
        'jessie'  => 'version 0.9.4-3+deb8u1',
        'stretch' => 'version 0.9.7-2',
    }
    apt::pin { 'toolforge-libpam-ldapd-pinning':
        package  => 'libpam-ldapd nslcd*',
        pin      => $libpam_ldapd_pkg_version,
        priority => '1001',
    }

    #
    # kubernetes stuff
    #
    # main k8s
    if os_version('debian == jessie') or os_version('ubuntu == trusty') {
        apt::pin { 'toolforge-kubernetes-node-pinning':
            package  => 'kubernetes-node',
            pin      => 'version 1.4.6-6',
            priority => '2000',
        }
        apt::pin { 'toolforge-kubernetes-master-pinning':
            package  => 'kubernetes-master',
            pin      => 'version 1.4.6-6',
            priority => '2000',
        }
        apt::pin { 'toolforge-kubernetes-client-pinning':
            package  => 'kubernetes-client',
            pin      => 'version 1.4.6-3',
            priority => '2000',
        }
    }
    # paws
    if os_version('debian == stretch') {
        apt::pin { 'toolforge-kubeadm-pinning':
            package  => 'kubeadm',
            pin      => 'version 1.9.1-00',
            priority => '1001',
        }
        apt::pin { 'toolforge-kubelet-pinning':
            package  => 'kubelet',
            pin      => 'version 1.9.1-00',
            priority => '1001',
        }
        apt::pin { 'toolforge-kubectl-pinning':
            package  => 'kubectl',
            pin      => 'version 1.9.1-00',
            priority => '1001',
        }
        apt::pin { 'toolforge-kubernetes-cni-pinning':
            package  => 'kubernetes-cni',
            pin      => 'version 0.6.0-00',
            priority => '1001',
        }
    }

    #
    # nginx stuff
    #
    if os_version('debian == jessie') {
        apt::pin { 'toolforge-libnginx-mod-pinning':
            package  => 'libnginx-mod*',
            pin      => 'version 1.13.6-2+wmf1~jessie1',
            priority => '1001',
        }
    }
    if os_version('debian == jessie') or os_version('ubuntu == trusty') {
        $nginx_pkg_version = $facts['lsbdistcodename'] ? {
            'trusty'  => 'version 1.4.6-1ubuntu3.8',
            'jessie'  => 'version 1.13.6-2+wmf1~jessie1',
        }
        apt::pin { 'toolforge-nginx-pinning':
            package  => 'nginx-*',
            pin      => $nginx_pkg_version,
            priority => '1001',
        }
    }
}
