class Question < ApplicationRecord
  validates :title, presence: true, length: { maximum: 30 }
  validates :body, presence: true

  belongs_to :user
  has_many :answers, dependent: :destroy
  #質問が削除された場合紐付く回答も削除される
end
