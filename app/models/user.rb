class User < ActiveRecord::Base
  has_many :urls
  validates_presence_of :name, :email
  validates :email, uniqueness: true
  include BCrypt

  def password
    @password ||= Password.new(password_hash)


  end


  def password=(new_password)
    @password = Password.create(new_password)
    # byebug
    self.password_hash = @password
  end
end