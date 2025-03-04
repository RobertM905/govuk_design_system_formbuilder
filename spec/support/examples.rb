class Person
  include ActiveModel::Model
  attr_accessor(:name, :born_on, :gender, :over_18, :favourite_colour, :favourite_colour_reason)
  attr_accessor(:projects, :project_responsibilities)
  attr_accessor(:cv)
  attr_accessor(:photo)

  validates :name, presence: { message: 'Enter a name' }
  validates :favourite_colour, presence: { message: 'Choose a favourite colour' }
  validates :projects, presence: { message: 'Select at least one project' }
  validates :cv, length: { maximum: 30 }

  validate :born_on_must_be_in_the_past, if: -> { born_on.present? }
  validate :photo_must_be_jpeg, if: -> { photo.present? }

  def self.valid_example
    new(
      name: 'Milhouse van Houten',
      favourite_colour: 'blue',
      projects: [1, 2, 3],
      cv: 'Excellent vocabulary',
      born_on: Date.new(1980, 7, 1)
    )
  end

private

  def born_on_must_be_in_the_past
    errors.add(:born_on, 'Your date of birth must be in the past') unless born_on < Date.today
  end

  def photo_must_be_jpeg
    errors.add(:photo, 'Must be a JPEG') unless photo.end_with?('.jpeg')
  end
end

class Project
  include ActiveModel::Model
  attr_accessor(:id, :name, :description)
end
