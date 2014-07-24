require 'chef/mash'

module EcomDev
  class SharedData
    def initialize
      @storage = Mash.new
    end

    def has(namespace, group, key)
      return false unless @storage.key?(namespace)
      return false unless @storage[namespace].key?(group)
      return false unless @storage[namespace][group].key?(key)
      true
    end

    def set(namespace, group, key, value)
      @storage[namespace] ||= {}
      @storage[namespace][group] ||= {}
      @storage[namespace][group][key] = value
    end

    def get(namespace, group, key)
      unless has(namespace, group, key)
        raise ArgumentError, 'Storage does not have ' + [namespace.to_s, group.to_s, key.to_s].join('/')
      end
      @storage[namespace][group][key]
    end


    class << self
      def instance(instance)
        @instance = instance
      end

      def set(*args)
        @instance.set(*args)
      end

      def get(*args)
        @instance.get(*args)
      end

      def has(*args)
        @instance.has(*args)
      end
    end

    module DSL
      def shared_data(namespace, group, key, value = nil)
        if value.nil?
          return EcomDev::SharedData.get(namespace, group, key)
        end
        EcomDev::SharedData.set(namespace, group, key, value)
        self
      end

      def shared_data?(namespace, group, key)
        EcomDev::SharedData.has(namespace, group, key)
      end
    end
  end
end

EcomDev::SharedData.instance(EcomDev::SharedData.new)
Chef::Node.send(:include, EcomDev::SharedData::DSL)

