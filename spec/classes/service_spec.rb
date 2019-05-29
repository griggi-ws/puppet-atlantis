require 'spec_helper'

describe 'atlantis::service' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          'user'              => 'atlantis',
          'group'             => 'atlantis',
          'repo_config'       => {},
          'add_net_bind_caps' => false,
        }
      end
      let(:pre_condition) do
        # Fake assert_private function from stdlib to not fail within this test
        'function assert_private () { }'
      end

      it { is_expected.to compile }
      it { is_expected.not_to contain_file('atlantis_service_unit').with_content(%r{--repo-config}) }

      context 'with server-side repo config' do
        let(:params) do
          {
            'user'              => 'atlantis',
            'group'             => 'atlantis',
            'add_net_bind_caps' => false,
            'repo_config'       => {
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

        it { is_expected.to contain_file('atlantis_service_unit').with_content(%r{--repo-config}) }
      end
    end
  end
end
