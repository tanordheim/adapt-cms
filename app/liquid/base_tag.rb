class BaseTag < Liquid::Tag

  Syntax = /(#{::Liquid::QuotedFragment}+)/

  def initialize(tag_name, markup, tokens)

    if markup =~ Syntax

      @argument = $1
      @params = {}

      markup.scan(Liquid::TagAttributes) do |key, value|
        @params[key] = value
      end
      
    else
      raise Liquid::SyntaxError.new("Syntax error in '#{self.class.name.underscore.gsub(/_tag$/, '')}'")
    end

    super

  end
  
end
