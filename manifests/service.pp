# @api private
class atlantis::service (
  $user,
  $group,
  $repo_config,
  $add_net_bind_caps,
){

  assert_private()

  if !empty($repo_config) {
    $_repo_config_file = '/etc/atlantis/repos.yaml'
  } else {
    $_repo_config_file = undef
  }

  file { 'atlantis_service_unit':
    ensure  => file,
    path    => '/etc/systemd/system/atlantis.service',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('atlantis/atlantis.service.epp', {
      'environment_file'  => '/etc/atlantis/env',
      'config_file'       => '/etc/atlantis/config.yaml',
      'repo_config_file'  => $_repo_config_file,
      'user'              => $user,
      'group'             => $group,
      'add_net_bind_caps' => $add_net_bind_caps,
    }),
    notify  => Exec['atlantis_systemd_daemon-reload'],
  }

  exec { 'atlantis_systemd_daemon-reload':
    command     => '/usr/bin/systemctl daemon-reload',
    refreshonly => true,
  }

  service { 'atlantis':
    ensure    => running,
    enable    => true,
    subscribe => Exec['atlantis_systemd_daemon-reload'],
  }

}
