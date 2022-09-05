class Recipe < ApplicationRecord
has_many :meals 
    validates :name, presence: true
    validates :description, presence: true
    validates :ingredients, presence: true 
end
