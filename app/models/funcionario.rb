class Funcionario
  include Mongoid::Document
  field :nome, type: String
  field :cpf, type: String
  field :cadastro, type: String
  field :classe, type: String
  field :padrao, type: Integer
  field :carga_horaria, type: String
  field :ambiente, type: String
  belongs_to :local
end
