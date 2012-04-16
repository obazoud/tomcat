
class Chef
  class Resource
    class Tomcat < Chef::Resource
      module OptionsCollector
        # def options
        #   @options ||= {}
        # end
        
        def method_missing(method_sym, value=nil, &block)
          super
        rescue NameError
          value ||= block
          method_sym = method_sym.to_s.chomp('=').to_sym
          options[method_sym] = value if value
          options[method_sym] ||= nil
        end
      end
      
      module Utils
        class JvmOptionsBlock
          include Chef::Resource::Tomcat::OptionsCollector
          
          def initialize
            @options = {}
          end

          attr_accessor :options
        
          def xms(arg=nil)
            @options[:xms] = arg ? arg : '128m'
          end
          
          def xmx(arg=nil)
            @options[:xmx] = arg ? arg : '512m'
          end

          def max_perm_size(arg=nil)
            @options[:max_perm_size] =  arg ? arg : '256m'
          end

          def xx_opts(opts=nil, &block)
            @options[:xx_opts].update(options_block(opts, &block))
          end
          
          def d_opts(opts=nil, &block)
            @options[:d_opts].update(options_block(opts, &block))
          end

          def additional_opts(opts=nil, &block)
            @options[:xx_opts].update(options_block(opts, &block))
          end

        end

        class PortOptionsBlock
          include Chef::Resource::Tomcat::OptionsCollector
          
          def http(arg=nil)
            @options ||= {}
            @options[:http] = arg ? arg : '8080'
          end

          def https(arg=nil)
            @options ||= {}
            @options[:https] = arg ? arg : nil
          end

          def ajp(arg=nil)
            @options ||= {}
            @options[:ajp] = arg ? arg : '8009'
          end

          def shutdown(arg=nil)
            @options ||= {}
            @options[:shutdown] = arg ? arg : '8005'
          end
          
        end
        
        def jvm_options_block(options=nil, &block)
          options ||= {}
          if options.empty?
            collector = JvmOptionsBlock.new
            collector.xms
            collector.xmx
            collector.max_perm_size
            collector.instance_eval(&block) if block
            options.update(collector.options)
          end
          # require 'pry'
          # binding.pry
          options
        end

        def port_options_block(options=nil, &block)
          options ||= {}
          collector = PortOptionsBlock.new
          populate_defaults_if_missing collector, %w{ http https ajp shutdown }
          collector.instance_eval(&block) if block
          options.update(collector.options)
          options
        end
        
        def options_block(options=nil, &block)
          options ||= {}
          if block
            collector = OptionsBlock.new
            collector.instance_eval(&block)
            options.update(collector.options)
          end
          options
        end

        def populate_defaults_if_missing(options, defaults)
          defaults.each do |default|
            require 'pry'
            binding.pry
            unless options.include? default
              options.call(default)
            end
          end
        end
      end
    end
  end
end
