require "open-uri"
class Url < ActiveRecord::Base
    @count =0
    # has_may :users
    def self.add_count_shorten_times
        @count += 1
    end
    
    def self.count_shorten_times
        @count
    end
    
    belongs_to :user, foreign_key: :user_id 

    @base58 ="123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz".scan(/./)
    
    def self.get_short_url
        @base58.sample(4).join("")
    end

    def self.generate_url(url)
        url = "https://om-url-shortener.herokuapp.com/url/" + "#{url}"
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
            return false
        end
    end     
end