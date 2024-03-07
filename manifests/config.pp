# @api private
class atlantis::config (
  Hash $config,
  Hash $repo_config,
  Array $environment,
  String $user,
  String $group,
) {
  assert_private()

  file { '/etc/atlantis':
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0750',
  }

  file { '/etc/atlantis/env':
    ensure  => file,
    owner   => $user,
    group   => $group,
    mode    => '0640',
    content => inline_epp('<% $arr.each |$item| { %><%= "${item}\n" %><% } %>', { 'arr' => $environment }),
  }

  file { '/etc/atlantis/config.yaml':
    ensure  => file,
    owner   => $user,
    group   => $group,
    mode    => '0640',
    content => to_yaml($config),
  }

  if ! empty($repo_config) {
    file { '/etc/atlantis/repos.yaml':
      ensure  => file,
      owner   => $user,
      group   => $group,
      mode    => '0640',
      content => to_yaml($repo_config),
    }
  }
}
