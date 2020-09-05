# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# coding: utf-8

SystemAdmin.find_or_create_by(email: 'aki.with.smiles@gmail.com') do |user|
  user.password = 'p@ssw0rd'
  user.password_confirmation = 'p@ssw0rd'
  user.name = '柏木 あき'
  user.role = 1
end
