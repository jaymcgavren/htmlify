module HTMLify
  
  class FormBuilder
    def self.generate_form(object)
      builder = FormBuilder.new object
      builder.begin_form
      yield(builder)
      builder.submit_tag
      builder.end_form
      builder.to_s
    end
    
    def initialize(object)
      @object = object
      @form_pieces = []
    end
    
    def begin_form
      @form_pieces << "<form action='/#{object_class_name}s'>"
    end
    
    def end_form
      @form_pieces << "</form>"
    end
    
    def input_for(method)
      @form_pieces << %(  <label for='#{object_class_name}[#{method}]'>#{method.to_s.capitalize}:</label> <input type='text' name='#{object_class_name}[#{method}]' value='#{@object.send(method)}'/>)
    end

    def submit_tag
      @form_pieces << "  <input type='submit' value='Save'/>"
    end
    
    def to_s
      @form_pieces.join "\n"
    end
    
    private
    def object_class_name
      @object.class.to_s.downcase
    end
    
    
    
    
  end
  
end