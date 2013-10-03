# = LocalizedLanguageSelect
#
# View helper for displaying select list with languages:
#
#     localized_language_select(:user, :language)
#
# Works just like the default Rails' +country_select+ plugin, but stores languages as
# language *codes*, not *names*, in the database.
#
# You can easily translate language codes in your application like this:
#     <%= I18n.t @user.language, :scope => 'languages' %>
#
# Uses the Rails internationalization framework (I18n) for translating the names of languages.
#
# Use Rake task <tt>rake import:language_select 'de'</tt> for importing language names
# from Unicode.org's CLDR repository (http://www.unicode.org/cldr/data/charts/summary/root.html)
#
# The code borrows heavily from the LocalizedCountrySelect plugin.
# See http://github.com/karmi/localized_country_select
#

# require 'localized_language_select/i18n'

module LocalizedLanguageSelect
  class << self
    # Returns array with codes and localized language names (according to <tt>I18n.locale</tt>)
    # for <tt><option></tt> tags
    def localized_languages_array options = {}
      res = []
      list = I18n.translate(:languages).each do |key, value|
        res << [value, key.to_s] if include_language?(key.to_s, options)
      end
      res.sort_by { |country| country.first.parameterize }
    end

    def include_language?(key, options)
      if options[:only]
        return options[:only].include?(key)
      end
      if options[:except]
        return !options[:except].include?(key)
      end
      true
    end


    # Return array with codes and localized language names for array of language codes passed as argument
    # == Example
    #   priority_languages_array([:de, :fr, :en])
    #   # => [ ['German', 'de'], ['French', 'fr'], ['English', 'en'] ]
    def priority_languages_array(language_codes=[])
      languages = I18n.translate(:languages)
      language_codes.map { |code| [languages[code.to_sym], code.to_s] }
    end
  end
end
require "localized_language/action_view_select"
