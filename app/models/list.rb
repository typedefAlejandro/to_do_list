class List < ApplicationRecord
  belongs_to :user
  belongs_to :folder, optional: true
  has_many :tasks, dependent: :destroy
end
