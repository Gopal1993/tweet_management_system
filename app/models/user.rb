class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum user_type: [:AdminUser, :NonAdminUser]

  validates :user_type, :presence => true
  validates :name, :presence => true
  has_many :tweets, dependent: :destroy

def generate_password_token!
 self.reset_password_token = generate_token
 self.reset_password_sent_at = Time.now
 save!
end

def password_token_valid?
 (self.reset_password_sent_at + 6.hours) > Time.now
end

def reset_password!(password)
 self.reset_password_token = nil
 self.password = password
 save!
end

private

def generate_token
 SecureRandom.hex(10)
end



  #doorkeeper authenticate (class) method for token generation

  class << self
   def authenticate(email, password)
     user = User.find_for_authentication(email: email)
     user.try(:valid_password?, password) ? user : nil
   end
 end

end
