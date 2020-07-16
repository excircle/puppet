node /^kmaster.node.io/ {
     class { 'selinux':
       mode => 'permissive',
     }
     exec { 'swapoff':
       command => 'swapoff -a',
       path    => [ '/usr/sbin/']
     }
     exec { 'nf_calls':
       command => 'sysctl net.bridge.bridge-nf-call-iptables=1',
       path    => [ '/usr/sbin/']
     }
     yumrepo { 'docker':
       ensure => 'present',
       descr => 'Docker Community Edition repository for CentOS',
       gpgkey => 'https://download.docker.com/linux/centos/gpg',
       baseurl => 'https://download.docker.com/linux/centos/7/x86_64/stable',
       enabled => 'true'
     }
     yumrepo { 'kubernetes':
       ensure => 'present',
       descr => 'Kubernetes Official Repository',
       gpgkey => 'https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg',
       baseurl => 'https://packages.cloud.google.com/yum/repos/kubernetes-el7-$basearch',
       enabled => 'true',
       gpgcheck => 'true',
       repo_gpgcheck => 'true'
     }
     package { 'docker-ce':
         ensure  => "installed",
     }
     file { '/etc/docker/':
       ensure => 'directory',
       owner  => 'root',
       group  => 'root',
       mode   => '0755',
     }
     exec { '/etc/docker/daemon.json':
       command => 'wget https://raw.githubusercontent.com/akalaj/saltstack/master/daemon.json -O /etc/docker/daemon.json',
       path    => [ '/usr/bin/']
     }
     file { '/etc/systemd/system/docker.service.d':
       ensure => 'directory',
       owner  => 'root',
       group  => 'root',
       mode   => '0755',
     }
     exec { 'daemon-reload':
       command => 'systemctl daemon-reload',
       path    => [ '/usr/bin/']
     }
     exec { 'daemon-restart':
       command => 'systemctl restart docker',
       path    => [ '/usr/bin/']
     }
     service { 'docker':
         ensure => running,
     enable => true
     }
     package { 'kubelet':
         ensure  => "installed",
     }
     package { 'kubeadm':
         ensure  => "installed",
     }
     package { 'kubectl':
         ensure  => "installed",
     }
     service { 'kubelet':
         ensure => running,
     enable => true
     }
 }
