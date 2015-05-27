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
  field :documento, type: String
  field :diretor_ou_secretario,type: Boolean,default: false
  field :componente_curricular
  scope :do_quadro, ->(quadro) { where(:quadro => quadro) }
  scope :do_cargo, ->(cargo) { where(:cargo => cargo) }
  belongs_to :local
  belongs_to :usuario
  belongs_to :disciplina_concurso,:class_name=>"Disciplina",:inverse_of=>:funcionarios
  belongs_to :disciplina_atuacao,:class_name=>"Disciplina",:inverse_of=>:funcionarios_atuando
  belongs_to :municipio_concurso,:class_name=>"Municipio"
  validate :validar_local
  validates_presence_of :nome,:cpf,:cargo,:carga_horaria,:quadro,message: "Informação necessária"
  validates_presence_of :classe,:municipio_concurso,:situacao,:concurso,if:  Proc.new { |a| self.quadro=="Estadual"},message: "Informação necessária"
  validates_presence_of :disciplina_concurso,if:  Proc.new { |a| a.cargo=="Professor" and (self.quadro=="Estadual" or self.quadro=="Federal")},message: "Informação necessária"
  validates_presence_of :disciplina_atuacao,:turmas,:ch_em_sala,if:  Proc.new { |a| a.ambiente=="Sala de Aula" and a.situacao=="Ativo" and !a.local.escola?}
  validates_presence_of :programa,if:  Proc.new { |a| a.cargo.include?("Programa") and a.situacao=="Ativo" },message: "Informação necessária"
  validate :validate_cadastro
  validate :cpf_valido
  validate :validate_ambiente,if: Proc.new { |a| a.local and a.local.escola}
  delegate :nome, to: :local, prefix: true, :allow_nil => true

  #Validaçoes antigas
  #validates_presence_of :cadastro,if:  Proc.new { |a| !a.quadro=="Contrato Administrativo"},message: "Informação necessária"
  #validates_presence_of :ambiente,message: "Informação necessária",:if=>Proc.new{|a|a.ambiente_nao_docente.blank? or (a.situacao.include?("Ativo") or a.situacao.include?("Acompanhado"))}
  
  validates_uniqueness_of :cadastro,scope: :local,:if=>Proc.new { |a|!a.quadro.include?("Contrato")},message: "Já está cadastrado"
  validates_uniqueness_of :cpf,scope: :cadastro,:if=>Proc.new { |a|!a.quadro.include?("Contrato")},message: "Já está cadastrado"
  validates_uniqueness_of :cpf,:if=>Proc.new { |a|a.quadro.include?("Contrato")},message: "Já está cadastrado"
  before_save :pos_ambiente
  before_save :nome_maiusculo

  def cpf_valido
    cpf = Cpf.new(self.cpf)
    if !cpf.valido?
     errors.add(:cpf, "não é valido")
   end
 end

 def validar_local
  if self.local.nil?
    errors.add(:local_nome, "Informação necessária")
  end
 end

 def validate_ambiente
  if self.cargo!="Professor" and self.ambiente_nao_docente.blank? and (self.situacao=="Ativo" or self.situacao=="Acompanhado pela Casa do Professor" or self.situacao=="Ativo mas em sala ambiente perante perícia médica")
    errors.add(:ambiente_nao_docente, "Informação necessária")
  elsif self.cargo=="Professor" and self.ambiente.blank? and (self.situacao=="Ativo" or self.situacao=="Acompanhado pela Casa do Professor" or self.situacao=="Ativo mas em sala ambiente perante perícia médica")
     errors.add(:ambiente, "Informação necessária")
  end
end

def validate_cadastro
  if self.cadastro.blank? and !self.quadro.include?("Contrato")
    errors.add(:cadastro, "Informação necessária")
  end
end

def pos_ambiente
  if !self.ambiente_nao_docente.blank? and self.cargo!="Professor"
    self.ambiente = self.ambiente_nao_docente
  elsif self.ambiente_nao_docente.blank? and self.cargo!="Professor"
    self.ambiente = ""
  end
end

def nome_maiusculo
  if !self.nome.blank?
    self.nome = self.nome.upcase
  end
end


end
