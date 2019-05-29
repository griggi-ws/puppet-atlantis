require 'spec_helper'

describe 'atlantis::config' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          'config'      => {},
          'repo_config' => {},
          'environment' => [],
          'user'        => 'atlantis',
          'group'       => 'atlantis',
        }
      end
      let(:pre_condition) do
        # Fake assert_private function from stdlib to not fail within this test
        'function assert_private () { }'
      end

      it { is_expected.to compile }
      it { is_expected.not_to contain_file('/etc/atlantis/repos.yaml') }

      context 'with server-side repo config' do
        let(:params) do
          {
            'config'      => {},
            'environment' => [],
            'user'        => 'atlantis',
            'group'       => 'atlantis',
            'repo_config' => {
              'repos' => [{
                'id' => '/.*/',
                'apply_requirements' => ['approved', 'mergeable'],
                'workflow' => 'custom',
                'allowed_overrides' => ['apply_requirements', 'workflow'],
                'allow_custom_workflows' => true,
              }],
            },
          }
        end

        it { is_expected.to contain_file('/etc/atlantis/repos.yaml') }
      end
    end
  end
end
