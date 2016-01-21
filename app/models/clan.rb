require 'destiny'
require 'person'
class Clan < ActiveRecord::Base
  validates :clan_id, presence: true, numericality: { only_integer: true }, uniqueness: true

  def info
    @d = Destiny.new
    logger.debug "Checking clan id #{self.clan_id}"
    results = @d.clan_info(self.clan_id)
    logger.debug "Results #{results}"
    return results
  end

  def members
    @d = Destiny.new
    raw_members = @d.clan_members(self.clan_id)
    members = []
    raw_members.each do |raw_member|
      logger.debug "Looking up #{raw_member['user']['displayName']}"
      begin
        members << Person.new(2, raw_member['user']['displayName'])
      rescue
        Rails.logger.debug "Coudn't turn #{raw_member} in to a valid user"
      end
    end
    return members
  end

end
