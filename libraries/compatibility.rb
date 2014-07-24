# Before 11.12.0 chef client version, there were no to_hash and to_a methods on node attributes
# Added for correct functionality of the recipes
minVersion = Chef::VersionConstraint.new('>= 11.12.0')
unless minVersion.include?(Chef::VERSION.to_s.gsub(/^(\d+\.\d+\.\d+)(.*)$/, '\1'))
  class Chef
    class Node
      class ImmutableArray
        def to_a
          a = Array.new
          each do |v|
            a <<
              case v
                when ImmutableArray
                  v.to_a
                when ImmutableMash
                  v.to_hash
                else
                  v
              end
          end
          a
        end
      end
      class ImmutableMash
        def to_hash
          h = Hash.new
          each_pair do |k, v|
            h[k] =
              case v
                when ImmutableMash
                  v.to_hash
                when ImmutableArray
                  v.to_a
                else
                  v
              end
          end
          h
        end
      end
    end
  end
end