# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Category.destroy_all
Event.destroy_all

categories = Category.create!([
  { name: 'Saúde' },
  { name: 'Estudo' },
  { name: 'Trabalho' },
  { name: 'Lazer' },
  { name: 'Rotina Diária' }
])

puts "Criadas #{categories.size} categorias."

events = Event.create!([
  { name: 'Bebeu 250ml de água', category: categories[0], timestamp: Time.now - 2.hours, observation: 'Importante para manter a hidratação' },
  { name: 'Estudou Matemática', category: categories[1], timestamp: Time.now - 1.day, observation: 'Revisão de álgebra' },
  { name: 'Reunião de trabalho', category: categories[2], timestamp: Time.now - 3.hours, observation: 'Discussão sobre o próximo projeto' },
  { name: 'Leu um livro', category: categories[3], timestamp: Time.now - 5.hours, observation: 'Leitura de ficção para relaxar' },
  { name: 'Fez uma caminhada de 30 minutos', category: categories[4], timestamp: Time.now - 1.day, observation: 'Parte da rotina matinal' },
  { name: 'Estudou Ruby on Rails', category: categories[1], timestamp: Time.now - 3.days, observation: 'Aprimoramento das habilidades em desenvolvimento web' },
  { name: 'Organizou o escritório', category: categories[2], timestamp: Time.now - 2.days, observation: 'Limpeza e organização dos materiais' },
  { name: 'Assistiu a uma palestra online', category: categories[3], timestamp: Time.now - 7.days, observation: 'Conteúdo sobre produtividade' }
])

puts "Criados #{events.size} eventos."
