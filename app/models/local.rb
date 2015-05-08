class Local
  include Mongoid::Document
  field :nome, type: String
  field :sigla, type: String
  field :codigo, type: String
  field :escola, type: Boolean,:default=>false
  belongs_to :municipio
  has_many :usuarios
  has_many :funcionarios
end
