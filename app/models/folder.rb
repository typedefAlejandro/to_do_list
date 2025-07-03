class Folder < ApplicationRecord
  belongs_to :user
  has_many :lists, dependent: :nullify
end
