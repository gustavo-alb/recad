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
  field :ambiente_nao_docente, type: String
  field :formacao, type: String
  field :ch_em_sala,type: Integer
  field :cargo, type: String
  field :quadro, type: String
  field :concurso, type: String
  field :area_concurso, type: String
  field :programa, type: String
  field :situacao, type: String
  field :diretor_ou_secretario,type: Boolean,default: false
  belongs_to :local
  belongs_to :disciplina_concurso,:class_name=>"Disciplina",:inverse_of=>:funcionarios
  belongs_to :disciplina_atuacao,:class_name=>"Disciplina",:inverse_of=>:funcionarios_atuando
  belongs_to :municipio_concurso,:class_name=>"Municipio"
  validates_presence_of :nome,:cpf,:cadastro,:cargo,:carga_horaria,:quadro,message: "Informação necessária"
  validates_presence_of :classe,:padrao,:municipio_concurso,:situacao,:concurso,if:  Proc.new { |a| self.quadro=="Estadual"},message: "Informação necessária"
  validates_presence_of :disciplina_concurso,if:  Proc.new { |a| a.cargo=="Professor" and (self.quadro=="Estadual" or self.quadro=="Federal")},message: "Informação necessária"
  validates_presence_of :disciplina_atuacao,:turmas,:ch_em_sala,if:  Proc.new { |a| a.ambiente=="Sala de Aula" }
  validates_presence_of :programa,if:  Proc.new { |a| a.cargo.include?("Programa") },message: "Informação necessária"
  validate :cpf_valido
  #validates_presence_of :ambiente,message: "Informação necessária"

  def cpf_valido
    cpf = Cpf.new(self.cpf)
    if !cpf.valido?
     errors.add(:cpf, "não é valido")
    end
  end

end
