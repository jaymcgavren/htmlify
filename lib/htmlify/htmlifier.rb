module HTMLify
  
class HTMLifier

  def initialize
    @html_converters = {}
    @parameter_converters = {}
  end

  def specify_method_html(name, &converter)
    @html_converters[name.to_s] = converter
    self
  end
  
  def with_parameters(*names, &converter)
    @parameter_converters[names] = converter
    self
  end
  
  def htmlify(object)
    inputs = @html_converters.map {|method, converter| converter.call(object)}
    <<-EOD
<html>
  <body>
    <pre>#{object.to_s}</pre>
    <form action="http://localhost:9292" method="post">
      #{inputs.join("\n")}
      <input type="submit"/>
    </form>
  </body>
</html>
EOD
  end

  def apply_parameters(object, parameters)
    @parameter_converters.each do |names, converter|
      name_strings = names.map{|n| n.to_s}
      converter.call(object, *parameters.values_at(*name_strings))
    end
    object
  end
  
  def scan_method(object, name, options = {})
    options[:type] ||= 'text'
    target_method = object.method(name.to_sym) or raise "method #{name} not found on #{object}"
    argument_count = target_method.arity
    if argument_count == 0
      specify_method_html(name) {|object| %Q{<input name="#{name}" value="#{name}" type="submit"/>}}
      with_parameters(name) {|object, value| object.send(name.to_sym)}
    elsif argument_count == 1 and options[:type] == 'select'
      specify_method_html(name) {|object| make_select(name, options[:options])}
      with_parameters(name) {|object, value| object.send(name.to_sym, value) unless value == ""}
    elsif argument_count == 1
      specify_method_html(name) {|object| %Q{<input name="#{name}" type="#{options[:type]}"/>}}
      with_parameters(name) {|object, value| object.send(name.to_sym, value) unless value == ""}
    elsif argument_count >= 2
      parameter_names = (0..(argument_count - 1)).map{|index| "#{name}[#{index}]"}
      specify_method_html(name) do |object|
        inputs = ""
        parameter_names.each do |parameter_name|
          inputs << %Q{<input name="#{parameter_name}" type="#{options[:type]}"/>}
        end
        inputs
      end
      #Watch the splat before *parameter_names: with_parameters should be called with a group of arguments, not a single array!
      with_parameters(*parameter_names) {|object, *values| object.send(name.to_sym, *values)}
    elsif argument_count == -1
      warn "#{object}.#{name} method takes a variable number of arguments; please call specify_method_html and with_parameters manually"
    else
      raise "Invalid options: #{options}"
    end
  end
  
  def scan_methods(object)
    object.methods.each{|m| scan_method(object, m)}
  end
  
  private
  
    def make_select(name, choices)
      tag =  %Q{<select name="#{name}>"}
      choices.each do |choice|
        tag << %Q{<option value="#{choice[1]}">#{choice[0]}</option>}
      end
      tag << %Q{</select>}
    end
  
end
  
end
