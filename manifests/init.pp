# A description of what this class does
#
# @summary This class installs and configures Atlantis (https://www.runatlantis.io).
#
# @example
#   include atlantis
#
# @note For full list of Atlantis config options that can be passed via the config hash, run the atlantis command with --help:
#   atlantis server --help
#
# @param config
#   Specifies a Hash of configuration options. These options are place in a YAML configuration file that Atlantis reads on startup.
#
# @param repo_config
#   Specifies a Hash of server-side repo configuration options. These options are place in a YAML configuration file that Atlantis reads on startup.
#
# @param environment
#   Specifices an Array of `KEY=VALUE` pairs. These environment variables are passed to Atlantis on startup and are useful for modifying Atlantis behavior and setting environment variables for use in Terraform code at a global level.
#
# @param user
#   Specifies the user to run Atlantis under.
#
# @param group
#   Specifies the state of the Atlantis service. Defaults to 'running'.
#
# @param service_ensure
#   Specifies the group to run Atlantis under.
#
# @param manage_user
#   Specifies whether to manage the user resource for the value of the `user` parameter.
#
# @param manage_group
#   Specifies whether to manage the group resource for the value of the `group` parameter.
#
# @param version
#   Specifies the version of Atlantis to install.
#
# @param download_source
#   Specifies a specific URL for downloading Atlantis. This is needed if downloading Atlantis from a non-standard location.
#
# @param proxy
#   Specifies a proxy server to use for external network access if required. If set, this value is also used to inject `*_PROXY` environment variables into the Atlantis process environment.
#
# @param no_proxy
#   Specifies a value for the `NO_PROXY` environment variable for injection into the Atlantis process environment.
#
class atlantis (
  Hash $config = {},
  Hash $repo_config = {},
  Array $environment = [],
  String $user = 'atlantis',
  String $group = 'atlantis',
  Optional[Variant[String,Boolean]] $service_ensure = 'running',
  Boolean $manage_user = true,
  Boolean $manage_group = true,
  String $version = 'v0.6.0',
  String $download_source = "https://github.com/runatlantis/atlantis/releases/download/${version}/atlantis_linux_amd64.zip",
  Optional[String] $proxy = undef,
  Optional[String] $no_proxy = undef,
){

  $_default_config = {
    'atlantis-url' => "http://${facts['fqdn']}:4141",
    'port'         => 4141,
  }
  $_final_config = $_default_config + $config

  if $proxy {
    $_proxy_env = [
      "HTTP_PROXY=${proxy}",
      "HTTPS_PROXY=${proxy}",
      "http_proxy=${proxy}",
      "https_proxy=${proxy}",
    ]
  } else {
    $_proxy_env = []
  }

  if $no_proxy {
    $_no_proxy_env = [
      "NO_PROXY=${no_proxy}",
    ]
  } else {
    $_no_proxy_env = []
  }
  $_final_environment = unique($_proxy_env + $_no_proxy_env + $environment)

  $_add_net_bind_caps = (Integer($_final_config['port']) < 1024)

  class { 'atlantis::install':
    proxy           => $proxy,
    version         => $version,
    download_source => $download_source,
    user            => $user,
    group           => $group,
    manage_user     => $manage_user,
    manage_group    => $manage_group,
  }
  contain atlantis::install

  class { 'atlantis::config':
    config      => $_final_config,
    repo_config => $repo_config,
    environment => $_final_environment,
    user        => $user,
    group       => $group,
  }
  contain atlantis::config

  if $::atlantis::service_ensure {
    class { 'atlantis::service':
      user              => $user,
      group             => $group,
      repo_config       => $repo_config,
      service_ensure    => $service_ensure,
      add_net_bind_caps => $_add_net_bind_caps,
    }
    contain atlantis::service

    Class['atlantis::config'] ~> Class['atlantis::service']
  }

  Class['atlantis::install']
  -> Class['atlantis::config']

}
