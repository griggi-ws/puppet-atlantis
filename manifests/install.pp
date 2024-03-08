# @api private
class atlantis::install (
  Optional[String] $download_source,
  Optional[String] $version,
  Optional[String] $proxy,
  Optional[String] $user,
  Optional[String] $group,
  Optional[Boolean] $manage_user,
  Optional[Boolean] $manage_group,
) {
  assert_private()

  $_file = basename($download_source)

  file { "/tmp/atlantis-${version}":
    ensure => directory,
  }

  archive { "/tmp/atlantis-${version}/${_file}":
    ensure       => present,
    extract      => true,
    extract_path => "/tmp/atlantis-${version}",
    source       => $download_source,
    creates      => "/tmp/atlantis-${version}/atlantis",
    cleanup      => true,
    proxy_server => $proxy,
    require      => File["/tmp/atlantis-${version}"],
  }

  exec { 'cp_atlantis_binary':
    command   => "cp /tmp/atlantis-${version}/atlantis /usr/local/bin/atlantis-${version}",
    path      => '/bin:/sbin:/usr/bin:/usr/sbin',
    creates   => "/usr/local/bin/atlantis-${version}",
    subscribe => Archive["/tmp/atlantis-${version}/${_file}"],
  }

  file { '/usr/local/bin/atlantis':
    ensure  => link,
    target  => "/usr/local/bin/atlantis-${version}",
    require => Exec['cp_atlantis_binary'],
  }

  if $manage_user {
    user { $user:
      ensure     => present,
      gid        => $group,
      managehome => true,
    }
  }

  if $manage_group {
    group { $group:
      ensure => present,
    }
  }
}
