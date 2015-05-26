class Local
  include Mongoid::Document
  field :nome, type: String
  field :codigo, type: String
  field :escola, type: Boolean,:default=>false
  field :setorial, type: Boolean,:default=>false
  field :secretaria, type: Boolean,:default=>false


  belongs_to :municipio
  belongs_to :local_pai,:class_name=>"Local"
  has_many :locais_filhos,:class_name=>"Local"
  has_many :usuarios
  has_many :funcionarios
  scope :secretarias, -> do where(:secretaria => true) end

   def nome_sigla
    "#{self.nome} - #{self.codigo}"
  end
end
