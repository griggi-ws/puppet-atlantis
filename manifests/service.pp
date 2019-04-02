# @api private
class atlantis::service (
  $user,
  $group,
  $add_net_bind_caps,
){

  assert_private()

  file { 'atlantis_service_unit':
    ensure  => file,
    path    => '/etc/systemd/system/atlantis.service',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('atlantis/atlantis.service.epp', {
      'environment_file'  => '/etc/atlantis/env',
      'config_file'       => '/etc/atlantis/config.yaml',
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
