# Class: webmin_1_890_unauthenticated_remote_code_execution::install
#
#
class webmin_1_890_unauthenticated_remote_code_execution::install {
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }
  $user = 'webminusr'
  # Intall dependancies - perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python unzip
  package { 'perl':
    ensure => installed,
    notify => Package['libnet-ssleay-perl'],
  }
  package { 'libnet-ssleay-perl':
    ensure  => installed,
    require => Package['perl'],
    notify  => Package['openssl'],
  }
  package { 'openssl':
    ensure  => installed,
    require => Package['libnet-ssleay-perl'],
    notify  => Package['libauthen-pam-perl'],
  }
  package { 'libauthen-pam-perl':
    ensure  => installed,
    require => Package['openssl'],
    notify  => Package['libpam-runtime'],
  }
  package { 'libpam-runtime':
    ensure  => installed,
    require => Package['libauthen-pam-perl'],
    notify  => Package['libio-pty-perl'],
  }
  package { 'libio-pty-perl':
    ensure  => installed,
    require => Package['libpam-runtime'],
    notify  => Package['apt-show-versions'],
  }
  package { 'apt-show-versions':
    ensure  => installed,
    require => Package['libio-pty-perl'],
    notify  => Package['python'],
  }
  package { 'python':
    ensure  => installed,
    require => Package['apt-show-versions'],
    notify  => Package['unzip'],
  }
  package { 'unzip':
    ensure  => installed,
    require => Package['python'],
    notify  => User[$user],
  }
  # Create folder /opt/Webmin_1.890
  file { '/opt/Webmin_1.890/':
    ensure  => 'directory',
    owner   => $user,
    mode    => '0755',
    require => User[$user],
    notify  => File['/opt/Webmin_1.890/webmin-1.890.tar.gz'],
  }
  # Move tar ball to /opt/Webmin_1.890
  file { '/opt/Webmin_1.890/webmin-1.890.tar.gz':
    owner   => $user,
    mode    => '0755',
    source  => 'puppet:///modules/webmin_1_890_unauthenticated_remote_code_execution/webmin-1.890.tar.gz',
    require => File['/opt/Webmin_1.890/'],
    notify  => Exec['mellow-file'],
  }
  # Extract tar ball
  exec { 'mellow-file':
    command => 'sudo tar -zvxf webmin-1.890.tar.gz',
    cwd     => '/opt/Webmin_1.890/',
    creates => '/opt/Webmin_1.890/webmin-1.890/',
    require => File['/opt/Webmin_1.890/webmin-1.890.tar.gz'],
    notify  => Exec['setup'],
  }

  # Run setup
  exec { 'setup':
    command => 'sudo ./setup.sh /usr/local/webmin',
    cwd     => '/opt/Webmin_1.890/webmin-1.890/',
    require => Exec['mellow-file'],
    notify  => Cron['start-webmin-cron'],
  }
}