# Defines the Liquid file system for design includes.
class IncludeTemplateFileSystem

  def initialize(design)
    @design = design
  end

  def read_template_file(template_name)

    template = @design.include_templates.select { |f| f.filename == template_name }.first
    raise Liquid::FileSystemError.new("No such template: #{template_name}") if template.blank?

    template.markup

  end

end
