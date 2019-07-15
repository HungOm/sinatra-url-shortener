class History < ActiveRecord::Base
    belongs_to :url,foreign_key: :url_id
    belongs_to :user, foreign_key: :user_id 
end