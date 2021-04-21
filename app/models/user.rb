class User < ApplicationRecord
  has_secure_password
  #passwordとpassword_confirmationのデータベースカラムに対応しない属性2つを追加
  
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  
  has_many :questions, dependent: :destroy
  #ユーザーが削除された場合紐付く質問も削除される
  has_many :answers, dependent: :destroy
  #ユーザーが削除された場合紐付く回答も削除される
  
  mount_uploader :avatar, AvatarUploader
  #User.imageとAvatarUploaderを紐付け
end
