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
  
  def with_parameter(name, &converter)
    @parameter_converters[name.to_s] = converter
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
    parameters.each do |parameter, value|
      converter = @parameter_converters[parameter] or raise "no parameter converter available for #{parameter}"
      converter.call(object, value)
    end
    object
  end
  
  def scan_method(object, name, options = {})
    options[:type] ||= 'text'
    target_method = object.method(name.to_sym) or raise "method #{name} not found on #{object}"
    argument_count = target_method.arity
    if argument_count == 0
      specify_method_html(name) {|object| %Q{<input name="#{name}" value="#{name}" type="submit"/>}}
      with_parameter(name) {|object, value| object.send(name.to_sym)}
    elsif argument_count >= 1 and options[:type] == 'select'
      specify_method_html(name) {|object| make_select(name, options[:options])}
      with_parameter(name) {|object, value| object.send(name.to_sym, value)}
    elsif argument_count >= 1
      specify_method_html(name) {|object| %Q{<input name="#{name}" type="#{options[:type]}"/>}}
      with_parameter(name) {|object, value| object.send(name.to_sym, value)}
    else
      raise "Invalid options: #{options}"
    end
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
