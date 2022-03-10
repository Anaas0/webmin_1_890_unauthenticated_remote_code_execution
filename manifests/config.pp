# Class: webmin_1_890_unauthenticated_remote_code_execution::config
#
#
class webmin_1_890_unauthenticated_remote_code_execution::config {
  # resources
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }
  $user = 'webminusr'
  $user_home = "/home/${user}"

  user { $user:
    ensure     => 'present',
    uid        => '666',
    gid        => 'root',#
    home       => $user_home,
    password   => 'Password123',
    managehome => true,
    require    => Package['unzip'],
    notify     => File['/opt/Webmin_1.890/'],
  }

  cron { 'start-webmin-cron':
    command => 'sudo /etc/webmin/start',
    special => 'reboot',
    require => Exec['setup'],
  }
}
