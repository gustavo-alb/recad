# -*- encoding : utf-8 -*-
class Disciplina
  include Mongoid::Document
  include Mongoid::Timestamps
  field :nome, type: String
  field :codigo, type: String
  has_many :funcionarios
end
