class User < ApplicationRecord
  # has_person_name
  attr_accessor :login

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts
  validates :username, uniqueness: true
  validates :email, uniqueness: true

  def self.find_for_database_authentication(warden_condition)
    conditions = warden_condition.dup
    login = conditions.delete(:login)
    where(conditions).where(
      ['lower(username) = :value OR lower(email) = :value',
       { value: login.strip.downcase }]
    ).first
  end
end
