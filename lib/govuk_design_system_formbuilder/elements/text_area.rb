module GOVUKDesignSystemFormBuilder
  module Elements
    class TextArea < Base
      def initialize(builder, object_name, attribute_name, hint_text:, label:, rows:, max_words:, max_chars:, threshold:, **extra_args)
        super(builder, object_name, attribute_name)
        @label      = label
        @hint_text  = hint_text
        @extra_args = extra_args
        @max_words  = max_words
        @max_chars  = max_chars
        @threshold  = threshold
        @rows       = rows
      end

      def html
        Containers::CharacterCount.new(@builder, max_words: @max_words, max_chars: @max_chars, threshold: @threshold).html do
          Containers::FormGroup.new(@builder, @object_name, @attribute_name).html do
            @builder.safe_join(
              [
                [label_element, hint_element, error_element].map(&:html),
                @builder.text_area(
                  @attribute_name,
                  id: field_id(link_errors: true),
                  class: govuk_textarea_classes,
                  aria: { describedby: described_by(hint_element.hint_id, error_element.error_id) },
                  **@extra_args.merge(rows: @rows)
                ),
                character_count_info
              ].flatten.compact
            )
          end
        end
      end

    private

      def govuk_textarea_classes
        %w(govuk-textarea).tap do |classes|
          classes.push('govuk-textarea--error') if has_errors?
          classes.push('js-character-count') if limit?
        end
      end

      def character_count_info
        return nil unless limit?

        @builder.tag.span(
          "You can enter up to #{character_count_description}",
          class: %w(govuk-hint govuk-character-count__message),
          aria: { live: 'polite' }
        )
      end

      def character_count_description
        if @max_words
          "#{@max_words} words"
        elsif @max_chars
          "#{@max_chars} characters"
        end
      end

      def limit?
        @max_words || @max_chars
      end
    end
  end
end
