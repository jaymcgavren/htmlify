require File.join(File.dirname(__FILE__), 'spec_helper')
require 'htmlify/htmlifier'

class Widget
  attr_accessor :name, :id, :width
  def no_args
  end
  def one_arg(first)
  end
  def two_args(first, second)
  end
end

describe HTMLify::HTMLifier do
  
  subject do
    HTMLify::HTMLifier.new
  end  
  
  describe "#specify_method_html" do
    it "takes a method name and a block that returns an HTML string" do
      subject.specify_method_html(:name=) do |widget|
        %Q{<input name="name" type="text" value="#{widget.name}"/>}
      end
      widget = Widget.new
      widget.name = "me"
      subject.htmlify(widget).should =~ %r{<input name="name" type="text" value="me"/>}
    end
  end
  
  describe "#with_parameter" do
    it "takes parameter name and a block to pass parameter value to" do
      subject.with_parameter("name") do |widget, value|
        widget.name = value
      end
      widget = Widget.new
      subject.apply_parameters(widget, {"name" => "me"})
      widget.name.should == "me"
    end
    it "allows conversion to Integer" do
      subject.with_parameter("id") do |widget, value|
        widget.id = value.to_i
      end
      widget = Widget.new
      subject.apply_parameters(widget, {"id" => "1"})
      widget.id.should == 1
    end
    it "allows conversion to Float"
    it "allows conversion to boolean"
    it "allows YAML deserialization"
    it "allows JSON deserialization"
  end
  
  describe "#scan_method" do
    it "makes no-arg methods available as submit buttons" do
      widget = Widget.new
      subject.scan_method(widget, :no_args)
      subject.htmlify(widget).should =~ %r{<input name="no_args" value="no_args" type="submit"/>}
      widget.should_receive(:no_args)
      subject.apply_parameters(widget, {"no_args" => "no_args"})
    end
    it "makes methods with one argument available as inputs" do
      widget = Widget.new
      subject.scan_method(widget, :one_arg)
      subject.htmlify(widget).should =~ %r{<input.*name="one_arg".*/>}
      widget.should_receive(:one_arg).with('argument')
      subject.apply_parameters(widget, {"one_arg" => "argument"})
    end
    it "uses a text field by default for each argument type" do
      widget = Widget.new
      subject.scan_method(widget, :one_arg)
      subject.htmlify(widget).should =~ %r{<input.*name="one_arg".*type="text"/>}
    end
    it "allows text as a field type" do
      widget = Widget.new
      subject.scan_method(widget, :one_arg, :type => 'text')
      subject.htmlify(widget).should =~ %r{<input.*name="one_arg".*type="text"/>}
    end
    it "allows select as a field type" do
      widget = Widget.new
      subject.scan_method(widget, :one_arg, :type => 'select', :options => [['cheap', 'Honda'], ['expensive', 'Mercedes']])
      match = %r{<select.*</select>}.match(subject.htmlify(widget))
      match.should_not be_nil
      select = match[0]
      select.should =~ %r{<option.*value="Honda".*>cheap</option>}
      select.should =~ %r{<option.*value="Mercedes".*>expensive</option>}
    end
    it "allows radio buttons as a field type"
    it "allows a check box as a field type"
    it "fills in setter field defaults from corresponding getters"
    it "displays getters with no corresponding setters as static text"
  end
  # [].methods.map{|m| method = a.method(m); "#{method.name}: #{method.arity}"}
  # ["inspect: 0", "to_s: 0", "to_a: 0", "to_ary: 0", "frozen?: 0", "==: 1", "eql?: 1", "hash: 0", "[]: -1", "[]=: -1", "at: 1", "fetch: -1", "first: -1", "last: -1", "concat: 1", "<<: 1", "push: -1", "pop: -1", "shift: -1", "unshift: -1", "insert: -1", "each: 0", "each_index: 0", "reverse_each: 0", "length: 0", "size: 0", "empty?: 0", "find_index: -1", "index: -1", "rindex: -1", "join: -1", "reverse: 0", "reverse!: 0", "rotate: -1", "rotate!: -1", "sort: 0", "sort!: 0", "sort_by!: 0", "collect: 0", "collect!: 0", "map: 0", "map!: 0", "select: 0", "select!: 0", "keep_if: 0", "values_at: -1", "delete: 1", "delete_at: 1", "delete_if: 0", "reject: 0", "reject!: 0", "zip: -1", "transpose: 0", "replace: 1", "clear: 0", "fill: -1", "include?: 1", "<=>: 1", "slice: -1", "slice!: -1", "assoc: 1", "rassoc: 1", "+: 1", "*: 1", "-: 1", "&: 1", "|: 1", "uniq: 0", "uniq!: 0", "compact: 0", "compact!: 0", "flatten: -1", "flatten!: -1", "count: -1", "shuffle!: 0", "shuffle: 0", "sample: -1", "cycle: -1", "permutation: -1", "combination: 1", "repeated_permutation: 1", "repeated_combination: 1", "product: -1", "take: 1", "take_while: 0", "drop: 1", "drop_while: 0", "pack: 1", "entries: -1", "sort_by: 0", "grep: 1", "find: -1", "detect: -1", "find_all: 0", "flat_map: 0", "collect_concat: 0", "inject: -1", "reduce: -1", "partition: 0", "group_by: 0", "all?: 0", "any?: 0", "one?: 0", "none?: 0", "min: 0", "max: 0", "minmax: 0", "min_by: 0", "max_by: 0", "minmax_by: 0", "member?: 1", "each_with_index: -1", "each_entry: -1", "each_slice: 1", "each_cons: 1", "each_with_object: 1", "chunk: -1", "slice_before: -1", "interesting_methods: 0", "nil?: 0", "===: 1", "=~: 1", "!~: 1", "class: 0", "singleton_class: 0", "clone: 0", "dup: 0", "initialize_dup: 1", "initialize_clone: 1", "taint: 0", "tainted?: 0", "untaint: 0", "untrust: 0", "untrusted?: 0", "trust: 0", "freeze: 0", "methods: -1", "singleton_methods: -1", "protected_methods: -1", "private_methods: -1", "public_methods: -1", "instance_variables: 0", "instance_variable_get: 1", "instance_variable_set: 2", "instance_variable_defined?: 1", "instance_of?: 1", "kind_of?: 1", "is_a?: 1", "tap: 0", "send: -1", "public_send: -1", "respond_to?: -1", "respond_to_missing?: 2", "extend: -1", "display: -1", "method: 1", "public_method: 1", "define_singleton_method: -1", "__id__: 0", "object_id: 0", "to_enum: -1", "enum_for: -1", "equal?: 1", "!: 0", "!=: 1", "instance_eval: -1", "instance_exec: -1", "__send__: -1"]
  
  describe "#scan_methods" do
    it "takes an array of method names to scan"
    it "scans all methods if none specified"
  end
  
  describe "#remove_method_html" do
    it "removes a method from the HTML form"
  end
  
  describe "#submit_url" do
    it "is used as a target for the HTML form"
  end
  
  describe "form submission" do
    it "calls each method for which arguments were specified"
    it "calls only methods for which arguments were specified"
    it "displays the server response"
  end
  
end


# require 'rubygems'
# require 'rack'
# 
# class Object
#   def webapp
#     class << self
#        define_method :call do |env|
#          func, *attrs = env['PATH_INFO'].split('/').reject(&:empty?)
#          [200, {}, HTMLifier.htmlify(send(func, *attrs))]
#        end
#     end
#     self
#   end
# end
# 
# Rack::Handler::Thin.run [].webapp, :Port => 9292
