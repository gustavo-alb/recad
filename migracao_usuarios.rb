f = File.open("migracao.csv")
a = f.readlines
a.each do |linha|
user = linha.gsub("\n","")
Usuario.create!(inep:user, :local=>Local.find_by(:codigo=>user),:password=>user,:password_confirmation=>user)
end