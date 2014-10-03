require 'spec_helper'

describe 'pe_server::puppetdb::whitelist', :type => :define do
  #let :pre_condition do
  #end

  let :title do
    'freddy'
  end

  context 'when called with default params' do
    it do should contain_file_line('freddy_puppetdb_whitelist').with(
      'line'  => 'freddy',
      'match' => 'freddy',
    )
    end
  end

  context 'when called with a specified certname param' do
    let :params do { :certname => 'nemo.denver.tld' } end
    it do should contain_file_line('freddy_puppetdb_whitelist').with(
      'line' => 'nemo.denver.tld',
    )
    end
  end
end
