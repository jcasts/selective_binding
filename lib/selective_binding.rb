##
# Create a selective binding. Useful for controlling ERB builds.
# The following will allow MyObj instances to provide a binding that will only
# expose MyObj#my_attr and MyObj#get_some_value:
#
#   require 'selective_binding'
#
#   class MyObj
#     attr_accessor :my_attr
#
#     def modify_something
#       # Don't want this exposed in binding!
#     end
#
#     def get_some_value
#       # Want this exposed in binding.
#       "some value"
#     end
#
#     def get_binding
#       selective_binding :my_attr, :get_some_value
#     end
#   end
#
#   my_obj = MyObj.new
#
#   eval "get_some_value", my_obj.get_binding
#   #=> "some value"
#
#   eval "modify_something", my_obj.get_binding
#   #=> NameError: undefined local variable or method `modify_something'
#
# Additionally, a block can be passed to selective bindings to fill the role of
# a default value, or method_missing.

class SelectiveBinding

  # Gem Version
  VERSION = '1.0.0'

  ##
  # Creates a new selective binding with the target object to
  # create a binding to.

  def initialize target
    @target = target
  end


  ##
  # Set the binding instance variable and accessor method.
  #   selective_binding.set :server_name, "blah.com"

  def set key, value=nil, &block
    value ||= block if block_given?

    instance_variable_set("@#{key}", value)

    eval_str = <<-STR
      undef #{key} if defined?(#{key})
      def #{key}(*args, &block)
        if Proc === @#{key}
          @#{key}.call(*args, &block)
        else
          @#{key}
        end
      end
    STR

    instance_eval eval_str, __FILE__, __LINE__ + 1
  end


  ##
  # Takes a hash and assign each hash key/value as an attribute:
  #   selective_binding.import_hash :attr1 => "value1",
  #                                 :attr2 => "value2"

  def import_hash hash
    hash.each{|k, v| self.set(k, v)}
  end


  ##
  # Forward a method to the object instance.
  #   binder.forward :method1, :method2, ...

  def forward *method_names
    method_names.each do |method_name|
      instance_eval <<-STR, __FILE__, __LINE__ + 1
      undef #{method_name} if defined?(#{method_name})
      def #{method_name}(*args, &block)
        @target.send(#{method_name.to_sym.inspect}, *args, &block)
      end
      STR
    end
  end


  ##
  # Sets the default value for undefined attributes or methods.

  def set_default value=nil, &block
    set :method_missing, value, &block if value || block_given?
  end


  ##
  # Retrieve the object's binding.

  def get_binding
    binding
  end
end


class Object

  ##
  # Creates a selective binding instance for self and returns
  # the newly created binding:
  #
  #   selective_binding :attr1, :method1
  #   #=> <#Binding>
  #
  # Passing a hash as the last argument allows for setting custom attributes.
  # These override any previously defined forwarded methods:
  #
  #   selective_binding :attr1 => "custom value"
  #   #=> <#Binding>
  #
  # Passing a block is also supported to set the default value for undefined
  # attributes or methods:
  #
  #   selective_binding do
  #     "default value"
  #   end
  #   #=> <#Binding>

  def selective_binding *methods, &block
    hash_attrib = methods.delete_at(-1) if Hash === methods.last

    binder = SelectiveBinding.new self

    binder.forward(*methods)       unless methods.empty?
    binder.import_hash hash_attrib if hash_attrib
    binder.set_default(&block)     if block_given?
    binder.get_binding
  end
end
