require 'spec_helper'

describe 'atlantis' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_class('atlantis::install') }
      it { is_expected.to contain_class('atlantis::config') }
      it { is_expected.to contain_class('atlantis::service') }

      context 'with default parameter values' do
        let(:node) { 'foo.example.com' }

        it do
          is_expected.to contain_class('atlantis::config').with(
            'environment' => [],
            'config'      => {
              'atlantis-url' => 'http://foo.example.com:4141',
              'port'         => 4141,
            },
          )
        end
      end

      context 'with proxy and custom env set' do
        let(:params) do
          {
            'proxy'       => 'http://proxy.example.org',
            'no_proxy'    => 'mydomain.com',
            'environment' => [
              'MYVAR=myvalue',
            ],
          }
        end

        it do
          is_expected.to contain_class('atlantis::config').with(
            'environment' => [
              'HTTP_PROXY=http://proxy.example.org',
              'HTTPS_PROXY=http://proxy.example.org',
              'http_proxy=http://proxy.example.org',
              'https_proxy=http://proxy.example.org',
              'NO_PROXY=mydomain.com',
              'MYVAR=myvalue',
            ],
          )
        end
      end

      context 'listening on a priviledged port' do
        let(:params) { { 'config' => { 'port' => 443 } } }

        it do
          is_expected.to contain_class('atlantis::service').with(
            'add_net_bind_caps' => true,
          )
        end
      end

      context 'listening on an unpriviledged port' do
        let(:params) { { 'config' => { 'port' => 1443 } } }

        it do
          is_expected.to contain_class('atlantis::service').with(
            'add_net_bind_caps' => false,
          )
        end
      end
    end
  end
end
