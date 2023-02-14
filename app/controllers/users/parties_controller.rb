class Users::PartiesController < ApplicationController
  before_action :validate_user_movie_show, only: :new
  def new
    @potential_guests = User.where.not(id: session[:user_id])
    @movie = MovieFacade.find_movie(params[:movie_id])
  end

  def create
    party = Party.new(party_params)
    if party.save
      party.create_user_parties(params, session[:user_id])
      redirect_to dashboard_path
    else
      redirect_to new_movie_party_path(params[:movie_id])
      flash[:error] = 'Please fill in all fields accurately'
    end
  end

  private

  def party_params
    params.permit(:duration, :start_time, :movie_id)
  end
end
