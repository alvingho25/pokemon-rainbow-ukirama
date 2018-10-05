require 'csv'

puts "Seeding Database pokedex"
pokedex_path = "#{Rails.root}db/pokedexes.csv"
pokedex = CSV.open pokedex_path , headers: true, header_converters: :symbol
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

puts "Seeding Database skill"
skill_path = "#{Rails.root}db/skills.csv"
skill = CSV.open skill_path, headers: true, header_converters: :symbol
skill.each do |line|
    Skill.create!(
        name: line[:name],
        power: line[:power],
        max_pp: line[:max_pp],
        element_type: line[:element_type]
    )
end