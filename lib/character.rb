require_relative 'destiny'
require_relative 'person'
class Character < Destiny

  def initialize(membership_type, username, character_id)
    super()
    @membership_id = self.get_membership_id(membership_type, username)
		@membership_type = membership_type
		@username = username
		@character_id = character_id
    @api_info = self.query("/Destiny/#{@membership_type}/Account/#{@membership_id}/Character/#{@character_id}", {}, false)['Response']
		class_hash = @api_info['data']['characterBase']['classHash']
    Rails.logger.debug "Class hash is #{class_hash}"
		@classname = self.query("/Destiny/Manifest/3/#{class_hash}", {}, false)['Response']['data']['classDefinition']['className']
    Rails.logger.debug "Name Junk: #{@classname}"
  end

  def username
    return @username
  end

  def person
      Person.new(@membership_type, @username)
  end

  def classname
    return @classname
  end

  def name
    "Waldo"
  end

  def api_info
    return @api_info
  end

	def progressions
    progressions = {}
		progressions_raw = self.query(
      "/Destiny/#{@membership_type}/Account/#{@membership_id}/Character/#{@character_id}/Progression",
      {'definitions' => 'true'},
      false
    )['Response']['data']['progressions']
    
    progressions_raw.each do |progression_raw|
      progression_info = self.query("/Destiny/Manifest/7/#{progression_raw['progressionHash']}", {}, false)['Response']['data']
      Rails.logger.debug "Progress: #{progression_info}"
      progressions[progression_info['progression']['name']] = {
        'level' => progression_raw['level'],
        'currentProgress' => progression_raw['currentProgress'],
        'progressToNextLevel' => progression_raw['progressToNextLevel'],
        'nextLevelAt' => progression_raw['nextLevelAt'],
        'name' => progression_info['progression']['name'].gsub("faction_pvp", "").gsub("_", " ").upcase,
        'pointsToNextLevel' => progression_raw['nextLevelAt'] - progression_raw['progressToNextLevel']
      }
    end
    return progressions

	end

end
