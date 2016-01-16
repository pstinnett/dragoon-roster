require 'destiny'
class ClansController < ApplicationController
  def new
    @clan = Clan.new
  end

	def index
		@clans = Clan.all
	end

  def show
		@clan = Clan.find(params[:id])
  end

  def create
		@clan = Clan.new(clan_params)
 
    if @clan.save
      redirect_to @clan
    else
      render 'new'
    end
  end

  private
    def clan_params
      params.require(:clan).permit(:clan_id)
    end

end
