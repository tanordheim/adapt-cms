# Google Javascript filter
# Includes javascripts from Google Libraries API.

module GoogleJavascriptFilter

  TYPE_FILENAME_MAPPING = {
    'chrome-frame' => 'CFInstall.min.js',
    'dojo' => 'dojo.xd.js',
    'ext-core' => 'ext-core.js',
    'jquery' =>'jquery.min.js',
    'jqueryui' =>'jquery-ui.min.js',
    'mootools' => 'mootools-yui-compressed.js',
    'prototype' => 'prototype.js',
    'scriptaculous' => 'scriptaculous.js',
    'swfobject' =>'swfobject.js',
    'yui' => 'yui-min.js',
    'webfont' => 'webfont.js'
  }

  # Returns the javascript include tag for the specified javascript from the
  # Google Libraries API.
  #
  # Javascript filenames have the format <type>.<version>, for instance:
  #  - chrome-frame.1.0.2
  #  - jquery.1.6.2
  def google_javascript(input)

    return nil if input.blank?
    type,version = input.split('.', 2)

    filename = TYPE_FILENAME_MAPPING[type]
    return nil if filename.blank? # We weren't able to identify the type

    uri = "https://ajax.googleapis.com/ajax/libs/#{type}/#{version}/#{filename}"
    "<script type=\"text/javascript\" src=\"#{h(uri)}\"></script>"

  end

end
