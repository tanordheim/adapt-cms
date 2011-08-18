# Google Webmaster Tools filter
# Embeds the Google Webmaster Tools site verification code.

module GoogleWebmasterToolsFilter

  def google_site_verification(code)
    "<meta name=\"google-site-verification\" content=\"#{h(code)}\" />"
  end

end
