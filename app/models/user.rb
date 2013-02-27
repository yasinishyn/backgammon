class User < ActiveRecord::Base
  # relations
  #has_many :first_user_desks, :class_name => "Desk", :foreign_key => :first_player_id
  #has_many :second_user_desks, :class_name => "Desk", :foreign_key => :second_player_id
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username
  # attr_accessible :title, :body
end
