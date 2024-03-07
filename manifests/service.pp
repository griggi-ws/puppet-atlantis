# @api private
class atlantis::service (
  $user,
  $group,
  Optional[Variant[String,Boolean]] $service_ensure = 'running',
  $repo_config,
  $add_net_bind_caps,
) {
  assert_private()

  if !empty($repo_config) {
    $_repo_config_file = '/etc/atlantis/repos.yaml'
  } else {
    $_repo_config_file = undef
  }

  systemd::unit_file { 'atlantis.service':
    content => epp('atlantis/atlantis.service.epp', {
        'environment_file'  => '/etc/atlantis/env',
        'config_file'       => '/etc/atlantis/config.yaml',
        'repo_config_file'  => $_repo_config_file,
        'user'              => $user,
        'group'             => $group,
        'add_net_bind_caps' => $add_net_bind_caps,
    }),
    enable  => true,
    active  => true,
  }
}
