# -*- encoding : utf-8 -*-
class Departamento
  include Mongoid::Document
  belongs_to :departamento_pai,:class_name=>"Departamento"

  field :nome, type: String
  field :sigla, type: String
  field :hierarquia, type: String
  scope :departamento, lambda { |q| where(:nome=> /.*#{q}.*/i) }
  scope :sigla_igual, lambda { |sigla| where( {:sigla => /.*#{sigla}.*/i }) }


  
end
