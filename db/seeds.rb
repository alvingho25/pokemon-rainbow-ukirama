require 'csv'

puts "Seeding Table pokedexes and pokemons"
pokedex_path = "#{Rails.root}/db/pokedexes.csv"
pokedex = CSV.open pokedex_path , headers: true, header_converters: :symbol
pokedex.each do |line|
    pokedex = Pokedex.create!(
        name: line[:name],
        base_health_point: line[:base_health_point],
        base_attack: line[:base_attack],
        base_defence: line[:base_defence],
        base_speed: line[:base_speed],
        element_type: line[:element_type],
        image_url: line[:image_url]
    )
    Pokemon.create!(
        pokedex_id: pokedex.id,
        name: line[:name],
        max_health_point: line[:base_health_point],
        current_health_point: line[:base_health_point],
        attack: line[:base_attack],
        defence: line[:base_defence],
        speed: line[:base_speed]
    )
end
puts "Seeding pokedexes and pokemons Completed"

puts "Seeding Table skills"
skill_path = "#{Rails.root}/db/skills.csv"
skill = CSV.open skill_path, headers: true, header_converters: :symbol
skill.each do |line|
    Skill.create!(
        name: line[:name],
        power: line[:power],
        max_pp: line[:max_pp],
        element_type: line[:element_type]
    )
end
puts "Seeding skills Completed"

puts "Seeding table evolution_lists"
evolution_list_path = "#{Rails.root}/db/list_evolution.csv"
evolution_list = CSV.open evolution_list_path, headers: true, header_converters: :symbol
evolution_list.each do |line|
    EvolutionList.create!(
        pokedex_from_name: line[:pokedex_from_name],
        pokedex_to_name: line[:pokedex_to_name],
        level: line[:minimum_level]
    )
end
puts "Seeding evolution_lists Completed"
