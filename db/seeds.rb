# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#Local.create(:nome=>"Polo Universitário Equador - Universidade Aberta do Brasil",:codigo=>"AP01054860")
Usuario.create(:inep=>"AP01054860",:password=>"AP01054860",:password_confirmation=>"AP01054860",:local=>Local.find_by(:codigo=>"AP01054860"))