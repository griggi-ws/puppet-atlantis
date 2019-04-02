
# atlantis

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with atlantis](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with atlantis](#beginning-with-atlantis)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)

## Description

This module installs and configures Atlantis (https://www.runatlantis.io). Atlantis is a central automation server for Terraform focused on source code pull requests.

## Setup

### Setup Requirements

This module installs and configures Atlantis, and expects that any Atlantis prerequisites have already been met. As an example, this module will not download Terraform and place it in the $PATH. A good list of these prerequisites may be found at https://www.runatlantis.io/guide/testing-locally.html

### Beginning with atlantis

You should have installed Terraform and made it available in the Atlantis user's $PATH as well as set up any webhook secrets, webhooks, and access tokens required. Atlantis configuration parameters are set as key/value pairs in the module's `config` parameter.

Any command line options may be set as keys in the `config` parameter (minus the leading `--`). For a full list of the available parameters, run `atlantis server --help`.

## Usage

Once prerequisites are met, the relevant config data may be passed in the module's config hash.

Example github config:

```
class { '::atlantis':
  config       => {
    'gh-user'           => 'myuser',
    'gh-token'          => 'token',
    'gh-webhook-secret' => 's3cr3t',
    'repo-whitelist'    => 'github.com/runatlantis/atlantis',
    'require-approval'  => true,
  },
}
```

## Limitations

Supported Puppet versions and OS versions are listed in `metadata.json`.

