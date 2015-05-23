a = File.open("/home/udes/Documentos/relatorio.csv",'w')
a.puts "NOME;CPF;CADASTRO;QUADRO;DISCIPLINA DE CONCURSO;MUNICIPIO DE CONCURSO;JORNADA;DISCIPLINA DE ATUAÇAO;HORAS EM SALA;Nº DE TURMAS;LOTAÇAO;MUNICIPIO DE LOTAÇAO;SITUACAO"
Funcionario.asc(:nome).where(:ambiente=>"Sala de Aula").each do |f|
a.puts "#{f.nome};#{f.cpf};#{f.cadastro};#{f.quadro};#{helper.objeto_valor(f.disciplina_concurso)};#{helper.objeto_valor(f.municipio_concurso)};#{helper.objeto_valor(f.carga_horaria)};#{helper.objeto_valor(f.disciplina_atuacao)};#{helper.objeto_valor(f.ch_em_sala)};#{helper.objeto_valor(f.turmas)};#{helper.objeto_valor(f.local)};#{helper.objeto_valor(f.local.municipio)};#{helper.objeto_valor(f.situacao)};"
end
a.close

a = File.open("/home/udes/Documentos/relatorio_prof_fora_de_sala.csv",'w')
a.puts "NOME;CPF;CADASTRO;QUADRO;DISCIPLINA DE CONCURSO;MUNICIPIO DE CONCURSO;JORNADA;AMBIENTE;LOTAÇAO;AMBIENTE;MUNICIPIO DE LOTAÇAO;SITUACAO"
Funcionario.asc(:nome).where(:ambiente.ne=>"Sala de Aula",:cargo=>"Professor").each do |f|
a.puts "#{f.nome};#{f.cpf};#{f.cadastro};#{f.quadro};#{helper.objeto_valor(f.disciplina_concurso)};#{helper.objeto_valor(f.municipio_concurso)};#{helper.objeto_valor(f.carga_horaria)};#{helper.objeto_valor(f.local)};#{helper.objeto_valor(f.ambiente)};#{helper.objeto_valor(f.local.municipio)};#{helper.objeto_valor(f.situacao)};"
end
a.close

a = File.open("/home/udes/Documentos/relatorio_nao_docente.csv",'w')
a.puts "NOME;CPF;CADASTRO;QUADRO;MUNICIPIO DE CONCURSO;JORNADA;LOTAÇAO;AMBIENTE;MUNICIPIO DE LOTAÇAO;SITUACAO"
Funcionario.asc(:nome).where(:cargo.ne=>"Professor").each do |f|
a.puts "#{f.nome};#{f.cpf};#{f.cadastro};#{f.quadro};#{helper.objeto_valor(f.municipio_concurso)};#{helper.objeto_valor(f.carga_horaria)};#{helper.objeto_valor(f.local)};#{helper.objeto_valor(f.ambiente)};#{helper.objeto_valor(f.local.municipio)};#{helper.objeto_valor(f.situacao)};"
end
a.close



a = []
b = []
Local.where(:escola=>true).each do |l|
e = Escola.where(:codigo=>l.codigo).first
if e and !e.municipio.blank?
l.municipio = Municipio.find_by(:nome=>e.municipio.nome)
l.save
a << l.nome
else
b << l.nome
end
end


f = File.open("/home/udes/Documentos/cadastro.csv")
a = f.readlines
a.each do |u|
user = Usuario.new
u = u.split(';')
user.nome = u[0]
user.cpf = Cpf.new(u[1]).numero
user.password = user.password_confirmation = u[1]
user.gestor_setorial = true
user.save(:validate=>false)
end

array
f = File.open("/home/udes/Documentos/cadastro.csv")
a = f.readlines
a.each do |u|
u = u.split(";")
if u[1].length!=11
array << u[1]
end
end