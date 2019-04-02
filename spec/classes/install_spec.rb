require 'spec_helper'

describe 'atlantis::install' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          'download_source' => 'https://github.com/runatlantis/atlantis/releases/download/v0.6.0/atlantis_linux_amd64.zip',
          'version'         => 'v0.6.0',
          'proxy'           => :undef,
          'user'            => 'atlantis',
          'group'           => 'atlantis',
          'manage_user'     => true,
          'manage_group'    => true,
        }
      end
      let(:pre_condition) do
        # Fake assert_private function from stdlib to not fail within this test
        'function assert_private () { }'
      end

      it { is_expected.to compile }
    end
  end
end
