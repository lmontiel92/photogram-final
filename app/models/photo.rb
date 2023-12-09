# == Schema Information
#
# Table name: photos
#
#  id             :integer          not null, primary key
#  caption        :string
#  comments_count :integer
#  image          :string
#  likes_count    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  owner_id       :integer
#
class Photo < ApplicationRecord

  #Validations:
  validates :owner_id, presence: true
  validates :image, presence: true

  #Direct Associations:
  belongs_to :owner, required: true, class_name: "User", foreign_key: "owner_id", counter_cache: :own_photos_count
  has_many  :likes, class_name: "Like", foreign_key: "photo_id", dependent: :destroy
  has_many  :comments, class_name: "Comment", foreign_key: "photo_id", dependent: :destroy

  #Indirect Associations:
  has_many :fans, through: :likes, source: :user
  has_many :followers, through: :owner, source: :following
  has_many :fan_followers, through: :fans, source: :following

  #Instance Methods:

  def creation
    require "date"

    created_year = self.created_at.year.to_i
    created_day = self.created_at.day.to_i
    created_month = self.created_at.month.to_i
    created_date = Date.new(created_year,created_month,created_day)
    today = Date.today

    days_since_creation = (today - created_date).to_i
    years_since_creation = (days_since_creation/365.0).to_f
    fractional_years = years_since_creation.round(2)
    whole_years = years_since_creation.round(0)
    year_fraction = fractional_years-whole_years

    if year_fraction < 0
      response = "almost #{whole_years} years ago"

    elsif year_fraction <=0.25
      response = "about #{whole_years} years ago"

    elsif year_fraction <=0.75
      response = "over #{whole_years} years ago"

    else
      response = "almost #{whole_years} years ago"

    end
    
    return response

  end
  

  

end
