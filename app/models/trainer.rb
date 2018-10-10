class Trainer < ApplicationRecord
    before_save   :downcase_email
    has_many :pokemon_trainers, dependent: :destroy
    has_many :pokemons, through: :pokemon_trainers

    has_secure_password
    validates :email, uniqueness: { case_sensitive: false }, presence: true
    validates :name, presence: true

    def downcase_email
        self.email = email.downcase
    end
end
