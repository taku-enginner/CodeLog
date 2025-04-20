class Tag < ApplicationRecord
  has_many :annotation_tags, dependent: :destroy
  has_many :annotations, through: :annotation_tags

  def to_param
    name
  end
end
