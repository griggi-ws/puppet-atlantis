require 'spec_helper'

describe 'atlantis::service' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          'user'              => 'atlantis',
          'group'             => 'atlantis',
          'add_net_bind_caps' => false,
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
