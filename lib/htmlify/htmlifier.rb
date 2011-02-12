module HTMLify
  
  class HTMLifier
    def htmlify(object)
      FormBuilder.generate_form(object) do |form|
        object.html_attributes.each {|a| form.input_for(a) }
      end
    end
  end
  
end
