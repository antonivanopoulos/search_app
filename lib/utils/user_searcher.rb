require_relative 'searcher'

class UserSearcher
  include Searcher

  class << self
    def model_name
      'User'
    end

    def searchable_fields
      %w(
        _id
        url
        external_id
        name
        alias
        created_at
        active
        verified
        shared
        locale
        timezone
        last_login_at
        email
        phone
        signature
        organization_id
        tags
        suspended
        role
      )
    end

    def array_fields
      %w(
        tags
      )
    end
  end
end

