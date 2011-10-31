class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable
  #  and :omniauthable :recoverable,:trackable,:validatable, :database_authenticatable
  devise :registerable, :rememberable

  has_many :social_connections, :dependent => :destroy
  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me
end

