Pokedex.create!(name:  "Bulbasaur",
    base_health_point: 45,
    base_attack: 49,
    base_defence: 49,
    base_speed: 45,
    element_type: "Grass",
    image_url: "https://img.pokemondb.net/artwork/bulbasaur.jpg")

Pokedex.create!(name:  "Charmander",
    base_health_point: 39,
    base_attack: 52,
    base_defence: 43,
    base_speed: 65,
    element_type: "Fire",
    image_url: "https://img.pokemondb.net/artwork/charmander.jpg")

Pokedex.create!(name:  "Squirtle",
    base_health_point: 44,
    base_attack: 48,
    base_defence: 65,
    base_speed: 43,
    element_type: "Water",
    image_url: "https://img.pokemondb.net/artwork/squirtle.jpg")
    
Pokedex.create!(name:  "Zapdos",
    base_health_point: 90,
    base_attack: 90,
    base_defence: 85,
    base_speed: 100,
    element_type: "Electric",
    image_url: "https://img.pokemondb.net/artwork/zapdos.jpg")

Pokedex.create!(name:  "Moltres",
    base_health_point: 90,
    base_attack: 100,
    base_defence: 90,
    base_speed: 90,
    element_type: "Flying",
    image_url: "https://img.pokemondb.net/artwork/moltres.jpg")

Pokedex.create!(name:  "Pikachu",
    base_health_point: 35,
    base_attack: 55,
    base_defence: 40,
    base_speed: 90,
    element_type: "Electric",
    image_url: "https://img.pokemondb.net/artwork/pikachu.jpg")

Pokedex.create!(name:  "Rattata",
    base_health_point: 30,
    base_attack: 56,
    base_defence: 35,
    base_speed: 72,
    element_type: "Normal",
    image_url: "https://img.pokemondb.net/artwork/rattata.jpg")


Skill.create!(name: "Tackle",
    power: 40,
    max_pp: 5,
    element_type: "Normal")

Skill.create!(name: "Vine Whip",
    power: 45,
    max_pp: 5,
    element_type: "Grass")

Skill.create!(name: "Ember",
    power: 40,
    max_pp: 5,
    element_type: "Fire")

Skill.create!(name: "Slash",
    power: 70,
    max_pp: 5,
    element_type: "Normal")

Skill.create!(name: "Water Gun",
    power: 40,
    max_pp: 5,
    element_type: "Water")

Skill.create!(name: "Water Pulse",
    power: 60,
    max_pp: 5,
    element_type: "Water")

Skill.create!(name: "Knock Off",
    power: 65,
    max_pp: 5,
    element_type: "Dark")