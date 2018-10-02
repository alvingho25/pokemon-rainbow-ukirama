class Pokemon < ApplicationRecord
    belongs_to :pokedex

    validates :name, length: { maximum: 45 }, presence: true, uniqueness: true
end
