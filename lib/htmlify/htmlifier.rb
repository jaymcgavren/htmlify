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
  
  def scan_method(object, name)
    argument_count = object.method(name.to_sym).arity
    case
    when argument_count == 0
      specify_method_html(name) {|object| %Q{<input type="submit" name="#{name}" value="#{name}"/>}}
      with_parameter(name) {|object, value| object.send(name.to_sym)}
    when argument_count >= 1
    end
  end
  
end
  
end
