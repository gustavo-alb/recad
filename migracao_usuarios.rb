f = File.open("migracao.csv")
a = f.readlines
a.each do |linha|
user = linha.gsub("\n","").split(',')
Usuario.create!(:nome=>user[0],:cpf=>user[1],:local=>Local.find_by(:codigo=>user[2]),:password=>user[2],:password_confirmation=>user[2])
end