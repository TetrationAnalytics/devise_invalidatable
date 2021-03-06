require 'devise' unless defined?(Devise)

Devise.add_module(:invalidatable, model: 'devise_invalidatable/model')

module DeviseInvalidatable
end

if defined?(ActiveRecord)
  class UserSession < ActiveRecord::Base
    def self.deactivate(session_id)
      where(session_id: session_id).delete_all
    end
  end
end
