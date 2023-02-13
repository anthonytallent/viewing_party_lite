class User < ApplicationRecord
  has_many :user_parties
  has_many :parties, through: :user_parties

  validates_uniqueness_of :email
  validates_presence_of :name, :email, :password

  has_secure_password

  def hosted_parties
    parties.where(user_parties: {is_host: true})
  end

  def invited_parties
    parties.where(user_parties: {is_host: false})
  end
end
