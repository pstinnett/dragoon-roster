require_relative 'destiny'
require_relative 'character'
class Person < Destiny

  def initialize(membership_type, username)
    super()
    membership_id = self.get_membership_id(membership_type, username)
    @membership_type = membership_type
    @username = username
    @api_info = self.query("/User/GetBungieAccount/#{membership_id}/#{membership_type}", {}, false)['Response']
    @characters = self.get_characters()
  end

  def username
    return @username
  end

  def url
    return "/people/#{@membership_type}/#{@username}"
  end

  def api_info
    return @api_info
  end


  def get_characters
    all = []
    self.destiny_account['characters'].each do |character_info|
      all << Character.new(2, @username, character_info['characterId'])
    end
    return all
  end

  def characters
    return @characters
  end

  def info
    return @info
  end

  def destiny_account
    return @api_info['destinyAccounts'].last
  end

end
