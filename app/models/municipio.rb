# -*- encoding : utf-8 -*-
class Municipio
  include Mongoid::Document
  include Mongoid::Timestamps
  field :nome, type: String
  field :cep, type: String
  field :sigla, type: String
  has_many :funcionarios
end
