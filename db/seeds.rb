# coding: utf-8

SystemAdmin.find_or_create_by(email: 'aki.with.smiles@gmail.com') do |user|
  user.password = 'p@ssw0rd'
  user.password_confirmation = 'p@ssw0rd'
  user.name = '柏木 あき'
  user.role = 1
end
