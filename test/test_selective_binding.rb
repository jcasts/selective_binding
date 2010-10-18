require "test/unit"
require "selective_binding"

class TestSelectiveBinding < Test::Unit::TestCase

  class MockObj
    attr_accessor :obj_attr1, :obj_attr2, :obj_attr3
  end


  def setup
    @obj = MockObj.new
    @obj.obj_attr1 = "value1"
    @obj.obj_attr2 = "value2"
    @obj.obj_attr3 = "value3"
    @binder = SelectiveBinding.new @obj
  end


  def test_set
    @binder.set :other_attr, "my_value"
    assert_binding_value @binder, :other_attr => "my_value"
  end


  def test_set_block
    @binder.set :other_attr do
      "something else"
    end

    assert_binding_value @binder, :other_attr => "something else"
  end


  def test_set_value_block
    @binder.set :other_attr, "thing" do
      "block value"
    end

    assert_binding_value @binder, :other_attr => "thing"
  end


  def test_import_hash
    @binder.import_hash :attr1 => "val1",
                        :attr2 => "val2"

    assert_binding_value @binder, :attr1 => "val1",
                                  :attr2 => "val2"
  end


  def test_forward
    @binder.forward :obj_attr1, :obj_attr2

    assert_binding_value @binder, :obj_attr1 => @obj.obj_attr1,
                                  :obj_attr2 => @obj.obj_attr2

    assert_not_binding_value @binder, :obj_attr3

    @binder.forward :obj_attr3
    assert_binding_value @binder, :obj_attr3 => @obj.obj_attr3
  end


  def test_set_default
    @binder.forward :obj_attr1, :obj_attr2
    @binder.set_default "DEFAULT VALUE!"

    assert_binding_value @binder, :undefined => "DEFAULT VALUE!",
                                  :obj_attr1 => @obj.obj_attr1,
                                  :obj_attr2 => @obj.obj_attr2
  end


  def test_set_default_block
    @binder.forward :obj_attr1, :obj_attr2

    @binder.set_default do
      "NEW DEFAULT VALUE!"
    end

    assert_binding_value @binder, :undefined => "NEW DEFAULT VALUE!",
                                  :obj_attr1 => @obj.obj_attr1,
                                  :obj_attr2 => @obj.obj_attr2
  end


  def test_obj_selective_binding
    b = selective_binding :forwarded_method
    assert_binding_value b, :forwarded_method => forwarded_method
    assert_not_binding_value b, :not_forwarded
  end


  def test_obj_selective_binding_hash
    b = selective_binding :forwarded_method, :forwarded_method => "custom attr"

    assert_binding_value b, :forwarded_method => "custom attr"

    assert_not_binding_value b, :not_forwarded
  end


  def test_obj_selective_binding_block
    b = selective_binding do
          "DEFAULT VALUE!"
        end

    assert_binding_value b, :forwarded_method => "DEFAULT VALUE!"
  end


  private

  def not_forwarded
    raise "This method should not be accessible from the binding"
  end


  def forwarded_method
    "FORWARDED METHOD"
  end


  def assert_binding_value binding, hash
    binding = binding.get_binding if SelectiveBinding === binding
    hash.each do |key, value|
      assert_equal eval("#{key}", binding), value
    end
  end


  def assert_not_binding_value binding, *keys
    binding = binding.get_binding if SelectiveBinding === binding
    keys.each do |key|
      assert_raises NameError do
        eval("#{key}", binding)
      end
    end
  end
end
