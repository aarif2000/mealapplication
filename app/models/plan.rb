class Plan < ApplicationRecord

        has_many :active_plans
        
        has_many :days 
    
        validates :name, presence: true
        validates :plan_duration, presence: true, numericality: { only_integer: true }
        validates :plan_cost, presence: true, numericality: { only_integer: true }
end
