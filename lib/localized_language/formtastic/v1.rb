module Formtastic
  module Inputs
    class LanguageInput
      include Base

      def to_html
        raise "To use the :language input, please install a language_select plugin, like this one: https://github.com/jeanmartin/localized_language_select/blob/master/lib/localized_language_select.rb" unless builder.respond_to?(:language_select)
        input_wrapping do
          label_html <<
          builder.language_select(method, priority_languages, input_options, input_html_options)
        end
      end

      def priority_languages
        options[:priority_languages] || []#builder.priority_languages
      end
    end
  end
end
