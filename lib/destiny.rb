class Destiny
  include HTTParty
  require_relative 'person'
  require_relative 'character'
  format :json
  # Set the base URI
  base_uri 'www.bungie.net/Platform'
  caches_api_responses :key_name => "dragoons", :expire_in => 3600

  def initialize()
		api_token = Rails.application.secrets.bungie_api_token
    HTTParty::HTTPCache.redis = $redis
    @headers = { 'X-API-Key' => api_token, 'Content-Type' => 'application/json' }
  end

  def query(uri, query = {}, short_response = true)

    raw_results = self.class.get(
      uri,
      headers: @headers,
      query: query
    )

    ## Do we want to return everything, or skip to results?
    if short_response
      return_results = raw_results["Response"]["results"]
    else
      return_results = raw_results
    end
    Rails.logger.debug "Results: #{return_results}"

    return return_results
  end

  def clan_info(clan_id)
    self.query("/Group/#{clan_id}", {}, false)['Response']['detail']
  end

  def get_platform_int(platform_str)
    if platform_str.is_a?
      return platform_str
    elsif platform_str == 'xbl'
      return 1
    elsif platform_str == 'psn'
      return 2
    end
  end

  def get_platform_str(platform_int)
    platform_int = platform_int.to_i
    if platform_int == 1
      return 'xbl'
    elsif platform_int == 2
      return 'psn'
    end
  end

  def clan_members(clan_id)
    params = {
      'currentPage' => 1,
      'itemsPerPage' => 50
    }
    self.query("/Group/#{clan_id}/MembersV3/", params)
  end

	def get_membership_id(membership_type, username)
		uri = "/Destiny/#{membership_type}/Stats/GetMembershipIdByDisplayName/#{username}"
    return self.query(
      uri,
      {},
      false
    )['Response']
	end

	def get_account(membership_type, username)
		membership_id = self.get_membership_id(membership_type, username)
    return self.query("/User/GetBungieAccount/#{membership_id}/#{membership_type}", {}, false)['Response']
	end
end
