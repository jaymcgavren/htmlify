require File.join(File.dirname(__FILE__), 'spec_helper')
require 'htmlify'

describe Object, '#html_attributes' do
  it "returns attributes where the name and attr_reader exist" do
    object = Object.new
    object.instance_variable_set('@name', 'Joe')
    def object.name
      @name
    end
    object.html_attributes.should == [:name]
  end
  
  it "does not return instance variables with no attr_reader" do
    pending
    object = Object.new
    object.instance_variable_set('@name', 'Joe')
    object.html_attributes.should == []
  end

  it "does not return attr_readers with no instance variable" do
    pending
    object = Object.new
    def object.name
      @name
    end
    object.html_attributes.should == []
  end
end

describe HTMLify::HTMLifier do
  class Person
    attr_accessor :name

    def initialize(name)
      @name = name
    end
  end
  
  subject do
    HTMLify::HTMLifier.new
  end
  
  describe "acceptance test" do
    it "generates an HTML form from a Ruby object" do
      html_form = <<END
<form action='/persons'>
  <label for='person[name]'>Name:</label> <input type='text' name='person[name]' value='Jay'/>
  <input type='submit' value='Save'/>
</form>
END
      person = Person.new 'Jay'
      subject.htmlify(person).should == html_form.rstrip
    end
  end  
  
  describe "#specify_method_html" do
    # it "takes a block that specifies the input string" do
    #   pending
    #   subject.specify_method_html(:name=) do |object|
    #     %Q{<label for='#{object.class.to_s.downcase}[#{method_name}]'>Name:</label> <input type='text' name='person[name]' value='#{object.name}'/>}        EOD
    #   end
    # end
    it "allows text as a field type"
    it "allows select as a field type"
    it "allows radio buttons as a field type"
    it "allows a check box as a field type"
    it "allows conversion to String"
    it "allows conversion to Integer"
    it "allows conversion to Float"
    it "allows conversion to boolean"
    it "allows YAML deserialization"
    it "allows JSON deserialization"
  end
  it "fills in setter field defaults from corresponding getters"
  it "displays getters with no corresponding setters as static text"

  describe "#scan_methods" do
    it "makes each method available as a form field"
    it "uses a text field by default for each argument type"
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
# Rack::Handler::Mongrel.run [].webapp, :Port => 9292
