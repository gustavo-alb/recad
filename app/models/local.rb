class Local
  include Mongoid::Document
  field :nome, type: String
  field :sigla, type: String
  field :codigo, type: String
  field :escola, type: Boolean,:default=>false
  belongs_to :municipio
  belongs_to :departamento_pai,:class_name=>"Local"
  has_many :usuarios
  has_many :funcionarios
end
