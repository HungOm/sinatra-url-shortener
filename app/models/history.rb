class Url < ActiveRecord::Base
    belongs_to :url
    belongs_to :user, foreign_key: :user_id 
end