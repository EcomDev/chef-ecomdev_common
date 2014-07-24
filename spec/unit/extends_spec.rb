require 'spec_helper'

describe 'ecomdev_common::extends' do
  let (:chef_run) { chef_run_proxy.instance.converge(described_recipe) }

  it 'includes automatically chef-sugar gem' do
    chef_run
    expect(Chef::Sugar).to be_instance_of(Module)
  end

  it 'it uses shared data storage' do
    allow_recipe('ecomdev_common::_shared_data')
    chef_run_proxy.before(:converge, false) do |runner|
      runner.node.set[:test_shared_data] = 'test_value'
    end
    expect(chef_run).to include_recipe('ecomdev_common::_shared_data')
    expect(EcomDev::SharedData.has(:namespace, :group, :key)).to eq(true)
    expect(EcomDev::SharedData.get(:namespace, :group, :key)).to eq('test_value')
  end
end