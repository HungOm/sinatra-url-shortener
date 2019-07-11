require "open-uri"
class Url < ActiveRecord::Base
    # has_may :users
    
    belongs_to :user, foreign_key: :user_id 

    @base58 ="123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz".scan(/./)
    
    def self.get_short_url
        @base58.sample(4).join("")
    end

    def self.generate_url(url)
        url = "http://127.0.0.1:9393/url/" + "#{url}"
        url
    end

    def self.url_opener(url)
        url = "https://"+url 
        url
    end

    def self.valid_url?(url)
        n = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix
        reslt = (url=~n)
        if reslt == 0
            return true
        else
            false
        end
    end     
end