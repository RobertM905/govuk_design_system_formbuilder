describe GOVUKDesignSystemFormBuilder::FormBuilder do
  include_context 'setup builder'

  let(:method) { :govuk_text_area }
  let(:attribute) { :cv }
  let(:label_text) { 'A brief list of your achievements' }
  let(:hint_text) { 'Keep it to a page, nobody will read it anyway' }
  let(:args) { [method, attribute] }
  let(:field_type) { 'textarea' }
  subject { builder.send(*args) }

  specify 'should output a form group containing a textarea' do
    expect(subject).to have_tag('div', with: { class: 'govuk-form-group' }) do |fg|
      expect(fg).to have_tag('textarea')
    end
  end

  it_behaves_like 'a field that supports labels', 'textarea'

  it_behaves_like 'a field that supports hints' do
    let(:aria_described_by_target) { 'textarea' }
  end

  it_behaves_like 'a field that supports errors' do
    let(:object) { Person.new(cv: 'a' * 50) } # max length is 30
    let(:aria_described_by_target) { 'textarea' }

    let(:error_message) { /too long/ }
    let(:error_class) { 'govuk-textarea--error' }
    let(:error_identifier) { 'person-cv-error' }
  end

  specify 'should have the correct classes' do
    expect(subject).to have_tag('textarea', with: { class: 'govuk-textarea' })
  end

  describe 'limits' do
    context 'max words' do
      let(:max_words) { 20 }
      subject { builder.send(*args.push(max_words: max_words)) }

      specify 'should wrap the form group inside a character count tag' do
        expect(subject).to have_tag(
          'div',
          with: {
            class: 'govuk-character-count',
            'data-module' => 'character-count',
            'data-maxwords' => max_words
          }
        )
      end

      specify 'should add js-character-count class to the textarea' do
        expect(subject).to have_tag('textarea', with: { class: 'js-character-count' })
      end

      specify 'should add a character count message' do
        expect(subject).to have_tag(
          'span',
          with: { class: 'govuk-character-count__message' },
          text: "You can enter up to #{max_words} words"
        )
      end
    end

    context 'max chars' do
      let(:max_chars) { 35 }
      subject { builder.send(*args.push(max_chars: max_chars)) }

      specify 'should wrap the form group inside a character count tag' do
        expect(subject).to have_tag(
          'div',
          with: {
            class: 'govuk-character-count',
            'data-module' => 'character-count',
            'data-maxlength' => max_chars
          }
        )
      end

      specify 'should add js-character-count class to the textarea' do
        expect(subject).to have_tag('textarea', with: { class: 'js-character-count' })
      end

      specify 'should add a character count message' do
        expect(subject).to have_tag(
          'span',
          with: { class: 'govuk-character-count__message' },
          text: "You can enter up to #{max_chars} characters"
        )
      end
    end

    context 'max chars and max words' do
      subject { builder.send(*args.push(max_chars: 5, max_words: 5)) }

      specify 'should raise an error' do
        expect { subject }.to raise_error(ArgumentError, 'limit can be words or chars')
      end
    end

    context 'thresholds' do
      let(:threshold) { 60 }
      let(:max_chars) { 35 }
      subject { builder.send(*args.push(max_chars: max_chars, threshold: threshold)) }

      specify 'should wrap the form group inside a character count tag with a threshold' do
        expect(subject).to have_tag(
          'div',
          with: {
            class: 'govuk-character-count',
            'data-module' => 'character-count',
            'data-maxlength' => max_chars,
            'data-threshold' => threshold
          }
        )
      end
    end
  end

  context 'rows' do
    context 'defaults' do
      specify 'should default to 5' do
        expect(subject).to have_tag('textarea', with: { rows: 5 })
      end
    end

    context 'overriding' do
      let(:rows) { 8 }
      subject { builder.send(method, attribute, rows: rows) }

      specify 'should have the overriden number of rows' do
        expect(subject).to have_tag('textarea', with: { rows: rows })
      end
    end
  end

  describe 'extra arguments' do
    let(:placeholder) { 'Once upon a time…' }
    subject { builder.send(*args.push(placeholder: placeholder, required: true)) }

    specify 'should add the extra attributes to the textarea' do
      expect(subject).to have_tag(
        'textarea',
        with: {
          placeholder: placeholder,
          required: 'required'
        }
      )
    end
  end
end
