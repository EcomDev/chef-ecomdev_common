require 'spec_helper'
require_relative '../../libraries/shared_data'

describe EcomDev::SharedData do
  let (:shared_data) { described_class.new }

  describe 'self.get' do
    it 'should proxy call to instance' do
      double = double('instance')
      expect(double).to receive(:get).with('argument1', 'argument2').and_return('value1')
      described_class.instance(double)
      expect(described_class.get('argument1', 'argument2')).to eq('value1')
    end
  end

  describe 'self.set' do
    it 'should proxy call to instance' do
      double = double('instance')
      expect(double).to receive(:set).with('argument1', 'argument2').and_return('value1')
      described_class.instance(double)
      expect(described_class.set('argument1', 'argument2')).to eq('value1')
    end
  end

  describe 'self.has' do
    it 'should proxy call to instance' do
      double = double('instance')
      expect(double).to receive(:has).with('argument1', 'argument2').and_return('value1')
      described_class.instance(double)
      expect(described_class.has('argument1', 'argument2')).to eq('value1')
    end
  end

  describe '#initialize' do
    it 'should set storage variable' do
      expect(shared_data.instance_variable_get(:@storage)).to be_instance_of(Mash).and be_empty
    end
  end

  describe '#has' do
    it 'should return false if namespace is not set' do
      expect(shared_data.has(:namespace, :group, :key)).to eq(false)
    end

    it 'should return false if group is not set' do
      shared_data.instance_variable_set(:@storage, Mash.new(namespace: {}))
      expect(shared_data.has(:namespace, :group, :key)).to eq(false)
    end

    it 'should return false if key is not set' do
      shared_data.instance_variable_set(:@storage, Mash.new(namespace: {group: {}}))
      expect(shared_data.has(:namespace, :group, :key)).to eq(false)
    end

    it 'should return true if namespace, group and key is set' do
      shared_data.instance_variable_set(:@storage, Mash.new(namespace: {group: {key: 'value'}}))
      expect(shared_data.has(:namespace, :group, :key)).to eq(true)
    end
  end

  describe '#set' do
    it 'should set storage by path' do
      shared_data.set(:namespace, :group, :key, 'value')
      expect(shared_data.instance_variable_get(:@storage)).to eq(Mash.new(namespace: {group: {key:'value'}}))
    end
  end

  describe '#get' do
    it 'should raise an exception if storage key does not exists' do
      expect(shared_data).to receive(:has).with(:namespace, :group, :key).and_return(false)
      expect {shared_data.get(:namespace, :group, :key)}.to raise_error(ArgumentError, 'Storage does not have namespace/group/key')
    end

    it 'should retrieve value if path exists' do
      shared_data.set(:namespace, :group, :key, 'value')
      expect(shared_data.get(:namespace, :group, :key)).to eq('value')
    end
  end

  context 'DSL' do
    describe '#shared_data' do
      it 'should call get method of storage instance' do
        expect(described_class).to receive(:get).with(:namespace, :group, :key).and_return('value')
        dsl_module = described_class::DSL
        klass = Class.new do
          include dsl_module
        end
        expect(klass.new.shared_data(:namespace, :group, :key)).to eq('value')
      end

      it 'should call set method of storage instance if value arg is specified' do
        expect(described_class).to receive(:set).with(:namespace, :group, :key, 'value')
        dsl_module = described_class::DSL
        klass = Class.new do
          include dsl_module
        end
        expect(klass.new.shared_data(:namespace, :group, :key, 'value')).to be_instance_of(klass)
      end
    end

    describe '#shared_data?' do
      it 'should call has method of storage instance' do
        expect(described_class).to receive(:has).with(:namespace, :group, :key).and_return(true)
        dsl_module = described_class::DSL
        klass = Class.new do
          include dsl_module
        end
        expect(klass.new.shared_data?(:namespace, :group, :key)).to eq(true)
      end
    end
  end
end
