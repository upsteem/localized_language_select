module ActionView
  module Helpers

    module FormOptionsHelper

      # Return select and option tags for the given object and method, using +localized_language_options_for_select+
      # to generate the list of option tags. Uses <b>language code</b>, not name as option +value+.
      # Language codes listed as an array of symbols in +priority_languages+ argument will be listed first
      # TODO : Implement pseudo-named args with a hash, not the "somebody said PHP?" multiple args sillines
      def localized_language_select(object, method, priority_languages = nil, options = {}, html_options = {})
        CountrySelect.new(object, method, self, options).
          to_localized_language_select_tag(priority_languages, options, html_options)
      end
      alias_method :language_select, :localized_language_select

      # Return "named" select and option tags according to given arguments.
      # Use +selected_value+ for setting initial value
      # It behaves likes older object-binded brother +localized_language_select+ otherwise
      # TODO : Implement pseudo-named args with a hash, not the "somebody said PHP?" multiple args sillines
      def localized_language_select_tag(name, selected_value = nil, priority_languages = nil, html_options = {})
        content_tag :select,
                    localized_language_options_for_select(selected_value, priority_languages).html_safe,
                    { "name" => name, "id" => name }.update(html_options.stringify_keys)
      end
      alias_method :language_select_tag, :localized_language_select_tag

      # Returns a string of option tags for languages according to locale. Supply the language code in lower-case ('en', 'de')
      # as +selected+ to have it marked as the selected option tag.
      # Language codes listed as an array of symbols in +priority_languages+ argument will be listed first
      def localized_language_options_for_select(selected = nil, priority_languages = nil, options = {})
        language_options = ""
        if priority_languages
          language_options += options_for_select(LocalizedLanguageSelect::priority_languages_array(priority_languages), selected)
          language_options += "<option value=\"\" disabled=\"disabled\">-------------</option>\n"
        end
        return language_options + options_for_select(LocalizedLanguageSelect::localized_languages_array(options), selected)
      end
      alias_method :language_options_for_select, :localized_language_options_for_select

    end

    class CountrySelect < Tags::Base
      def to_localized_language_select_tag(priority_languages, options, html_options)
        html_options = html_options.stringify_keys
        add_default_name_and_id(html_options)
        value = value(object)
        content_tag("select",
          add_options(
            localized_language_options_for_select(value, priority_languages, options).html_safe,
            options, value
          ), html_options
        )
      end
    end

    class FormBuilder
      def localized_language_select(method, priority_languages = nil, options = {}, html_options = {})
        @template.localized_language_select(@object_name, method, priority_languages, options.merge(:object => @object), html_options)
      end
      alias_method :language_select, :localized_language_select
    end

  end
end
