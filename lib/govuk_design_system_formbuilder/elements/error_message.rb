module GOVUKDesignSystemFormBuilder
  module Elements
    class ErrorMessage < GOVUKDesignSystemFormBuilder::Base
      def initialize(builder, object_name, attribute_name)
        super(builder, object_name, attribute_name)
      end

      def html
        return nil unless has_errors?

        @builder.content_tag('span', class: 'govuk-error-message', id: error_id) do
          @builder.safe_join(
            [
              @builder.tag.span('Error: ', class: 'govuk-visually-hidden'),
              message
            ]
          )
        end
      end

      def message
        @builder.object.errors.messages.dig(@attribute_name)
      end
    end
  end
end
