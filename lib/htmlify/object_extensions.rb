class Object
  def html_attributes
    (instance_variables.map{|v| v.sub('@', '')} & methods).map {|m| m.to_sym }
  end
end