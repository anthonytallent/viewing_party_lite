class Party < ApplicationRecord
  has_many :user_parties
  has_many :users, through: :user_parties

  validates_presence_of :duration, :start_time

  def movie
    MovieFacade.find_movie(movie_id)
  end

  def host
    userparty = UserParty.where(party_id: id, is_host: true).first
    User.where(id: userparty.user_id)[0].name
  end

  def create_user_parties(params, user_id)
    potential_guests = User.where.not(id: user_id)

    UserParty.create!(user_id: user_id, party_id: id, is_host: true)

    potential_guests.each do |guest|
      UserParty.create!(user_id: guest.id, party_id: id, is_host: false) if params[guest.id.to_s.to_sym] == '1'
    end
  end
end
