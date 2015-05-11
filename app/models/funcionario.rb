class Funcionario
  include Mongoid::Document
  field :nome, type: String
  field :cpf, type: String
  field :cadastro, type: String
  field :classe, type: String
  field :padrao, type: Integer
  field :turmas, type: Integer
  field :carga_horaria, type: String
  field :ambiente, type: String
  field :formacao, type: String
  field :ch_em_sala,type: Integer
  field :cargo, type: String
  field :quadro, type: String
  field :concurso, type: String
  field :area_concurso, type: String
  field :programa, type: String
  field :situacao, type: String
  belongs_to :local
  belongs_to :disciplina_concurso,:class_name=>"Disciplina",:inverse_of=>:funcionarios
  belongs_to :disciplina_atuacao,:class_name=>"Disciplina",:inverse_of=>:funcionarios_atuando
  belongs_to :municipio_concurso,:class_name=>"Municipio"
  validates_presence_of :nome,:cpf,:cadastro,:cargo,:carga_horaria,:ambiente,:quadro,message: "Informação necessária"
  validates_presence_of :classe,:padrao,:municipio_concurso,:situacao,:concurso,if:  Proc.new { |a| self.quadro=="Estadual"},message: "Informação necessária"
  validates_presence_of :disciplina_concurso,if:  Proc.new { |a| a.cargo=="Professor" and (self.quadro=="Estadual" or self.quadro=="Federal")},message: "Informação necessária"
  validates_presence_of :disciplina_atuacao,:numero_turmos,:ch_em_sala,if:  Proc.new { |a| a.ambiente=="Sala de Aula" }
  validates_presence_of :programa,if:  Proc.new { |a| a.cargo.include?("Programa") },message: "Informação necessária"

end
