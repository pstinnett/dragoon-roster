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

  def statistic
		@clan = Clan.find(params[:clan_id])
    members = @clan.members
    @target_stats = {}
    members.each do |member|
      label = member.username
      @target_stats[label] = {}
      @target_stats[label]['member'] = member
      stat = member.account_stats[params[:statistic_type]]['allTime'][params[:statistic]]
      @target_stats[label]['stat'] = stat

      if @target_stats[label]['stat'].has_key?('pga')
        @target_stats_sorted = @target_stats.sort_by{|_key, value| value['stat']['pga']['value']}
        @show_pga = true
      else
        @target_stats_sorted = @target_stats.sort_by{|_key, value| value['stat']['basic']['value']}
        @show_pga = false
      end
      @target_stats_sorted.reverse!
    end

  end

  private
    def clan_params
      params.require(:clan).permit(:clan_id)
    end

end
