class Funcionario
  include Mongoid::Document
  field :nome, type: String
  field :cpf, type: String
  field :cadastro, type: String
  field :classe, type: String
  field :padrao, type: Integer
  field :carga_horaria, type: String
  field :ambiente, type: String
  field :formacao, type: String
  field :ch_em_sala,type: Integer
  belongs_to :local
  belongs_to :disciplina
end
