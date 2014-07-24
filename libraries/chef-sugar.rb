# A very dirty hack for chef-sugar gem inclusion, since no other option is available
module EcomDev
  class CookbookCompiler
    class << self
      include Chef::Mixin::ShellOut

      def install_chef_sugar
        require 'rubygems'
        begin
          gem 'chef-sugar'
        rescue Gem::LoadError
          gem_bin = RbConfig::CONFIG['bindir'] + '/gem'
          shell_out!("#{gem_bin} install -q --no-rdoc --no-ri chef-sugar", :env => nil)
          Gem.clear_paths
        end

        require 'chef/sugar'
      end
    end
  end
end

class Chef
  class RunContext
    class CookbookCompiler

      unless method_defined?(:ecomdev_common_compile_attributes)
        alias_method :ecomdev_common_compile_attributes, :compile_attributes
      end

      def compile_attributes(*args)
        EcomDev::CookbookCompiler.install_chef_sugar
        ecomdev_common_compile_attributes(*args)
      end
    end
  end
end

