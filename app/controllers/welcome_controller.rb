require 'destiny'
class WelcomeController < ApplicationController

  def index

    ## TODO:  Be smarter about which clan to display on the front page
    ## For now, just use the first clan in the db
    @clan = Clan.first
    @members = @clan.members
    @characters = []
    @members.each do |member|
      member.characters.each do |character|
        @characters << character
      end
    end

    @characters_sorted = @characters.sort_by{|c| c.api_info['data']['characterBase']['powerLevel']}
    @characters_sorted.reverse!
    @characters_sorted = @characters_sorted.take(10)

  end

end
