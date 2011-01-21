require File.join(File.dirname(__FILE__), 'spec_helper')
require 'htmlify/htmlifier'

describe HTMLify::HTMLifier do
  
  subject do
    HTMLify::HTMLifier.new
  end
  # describe "An array containing 1, 2, 3, 3" do
  #   subject { [1, 2, 3, 3] }
  #   its(:size) { should == 4 }
  # end
  # describe Array do
  #   it "is empty" do
  #     subject.should be_empty
  #   end
  # end
  
  
  describe "#specify_method_html" do
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
