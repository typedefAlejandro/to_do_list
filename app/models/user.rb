class User < ApplicationRecord
  has_many :lists, dependent: :destroy
  has_many :folders, dependent: :destroy
  has_many :tasks, through: :lists

  validates :name, presence: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :timeoutable
end
