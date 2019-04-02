require 'spec_helper'

describe 'atlantis::config' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          'config'      => {},
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
    end
  end
end
