# == Schema Information
#
# Table name: users
#
#  id                             :integer          not null, primary key
#  comments_count                 :integer
#  email                          :string           default(""), not null
#  encrypted_password             :string           default(""), not null
#  likes_count                    :integer
#  own_photos_count               :integer
#  private                        :boolean
#  received_follow_requests_count :integer
#  remember_created_at            :datetime
#  reset_password_sent_at         :datetime
#  reset_password_token           :string
#  sent_follow_requests_count     :integer
#  username                       :string
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable

  #Validations
  validates :username, presence: true
  validates :username, uniqueness: true

  #Direct Associations
  has_many  :likes, class_name: "Like", foreign_key: "fan_id", dependent: :destroy
  has_many  :comments, class_name: "Comment", foreign_key: "author_id", dependent: :destroy
  has_many  :sent_follow_requests, class_name: "FollowRequest", foreign_key: "sender_id", dependent: :destroy
  #has_many  :accepted_sent_follow_requests => {accepted}, class_name: "FollowRequest", foreign_key: "sender_id", dependent: :destroy
  has_many :accepted_sent_follow_requests, -> { where({ :status => 'accepted' }) }, :class_name => "FollowRequest", :foreign_key => "sender_id", :dependent => :destroy 

  has_many  :received_follow_requests, class_name: "FollowRequest", foreign_key: "recipient_id", dependent: :destroy
  has_many  :own_photos, class_name: "Photo", foreign_key: "owner_id", dependent: :destroy

  #Indirect Associations
  has_many :following, through: :accepted_sent_follow_requests, source: :recipient
  has_many :followers, through: :received_follow_requests, source: :sender
  has_many :liked_photos, through: :likes, source: :photo
  has_many :feed, through: :following, source: :own_photos
  has_many :activity, through: :following, source: :liked_photos

  #Instance Methods

  # def accepted_followers

  #   accepted = self.sent_follow_requests.where(sender_id: self.id, status: "accepted")

  #   accepted_feed = []

  #   accepted.each do |a_follower|

  #     feed_photo = Photo.where(owner_id: a_follower.id)

  #   return accepted

  # end

  # def accepted_followers_feed

  #   accepted_feed = Photo.where(owner_id: self.accepted_followers)

  #   return accepted_feed

  # end
    
end
