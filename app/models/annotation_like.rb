class AnnotationLike < ApplicationRecord
  belongs_to :user
  belongs_to :annotation

  validates :user_id, uniqueness: {scope: :annotation_id}
end
