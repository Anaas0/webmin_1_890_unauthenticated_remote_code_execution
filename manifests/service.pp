# Class: webmin_1_890_unauthenticated_remote_code_execution::service
#
#
class webmin_1_890_unauthenticated_remote_code_execution::service {
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }
  # resources

}
