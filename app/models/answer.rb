class Answer < ApplicationRecord
  validates :body, presence: true, length: { maximum: 1000 }
  
  belongs_to :user
  belongs_to :question
end
