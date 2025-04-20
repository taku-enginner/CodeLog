class Annotation < ApplicationRecord
  belongs_to :repository
  belongs_to :user
  has_many :annotation_tags, dependent: :destroy
  has_many :tags, through: :annotation_tags
  has_many :annotation_likes, dependent: :destroy
  
  def tag_list
    tags.pluck(:name)
  end

  def tag_list=(names)
    name_array = names.split(",") # カンマ区切りの文字列を配列に
    self.tags = name_array.map(&:strip).reject(&:blank?).map do |name|
      Tag.find_or_create_by(name: name)
    end
  end
  

end
