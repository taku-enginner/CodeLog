class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :repositories, dependent: :destroy
  has_many :annotations, dependent: :destroy
  has_many :annotation_likes, dependent: :destroy
end
