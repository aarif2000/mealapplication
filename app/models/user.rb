class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable

         devise :database_authenticatable,
         :jwt_authenticatable,
         :registerable,
         jwt_revocation_strategy: JwtDenylist

        #  email_regex = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

          validates :name, presence: true, length: { minimum: 3 }
          validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 7 }
          validates :age, presence: true
          validates :weight, presence: true
end
