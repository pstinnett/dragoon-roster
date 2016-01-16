require 'destiny'
class PeopleController < ApplicationController
  def show
    d = Destiny.new
    @username = params[:username]
		@account = d.get_account(params[:membership_type], params[:username])
    @person = Person.new(params[:membership_type], params[:username])
  end

  def factionstats
    d = Destiny.new
    @username = params[:username]
		@account = d.get_account(params[:membership_type], params[:username])
    @person = Person.new(params[:membership_type], params[:username])
		action_factions = [
    	'faction_pvp_dead_orbit',
    	'faction_pvp_future_war_cult',
    	'faction_pvp_new_monarchy',
		]
    faction_info = {}
    @person.characters.each do |character|

      progressions = character.progressions
      keys = progressions.keys
      keys.sort!

      keys.each do |faction_title|
        if action_factions.include? faction_title
          label = "#{faction_title} #{character}"
          
          ## Tack the character in the hash too
          progressions[faction_title]['character'] = character.api_info['data']

          faction_info[label] = progressions[faction_title]
        end
      end

    end

    @factions_sorted = faction_info.sort_by{|_key,value| value['pointsToNextLevel']}
  end
end
