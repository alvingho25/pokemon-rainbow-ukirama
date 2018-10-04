require 'csv'

pokedex = CSV.open Rails.root + "db/pokedexes.csv", headers: true, header_converters: :symbol
pokedex.each do |line|
    Pokedex.create!(
        name: line[:name],
        base_health_point: line[:base_health_point],
        base_attack: line[:base_attack],
        base_defence: line[:base_defence],
        base_speed: line[:base_speed],
        element_type: line[:element_type],
        image_url: line[:image_url]
    )
end

skill = CSV.open Rails.root + "db/skills.csv", headers: true, header_converters: :symbol
skill.each do |line|
    Skill.create!(
        name: line[:name],
        power: line[:power],
        max_pp: line[:max_pp],
        element_type: line[:element_type]
    )
end