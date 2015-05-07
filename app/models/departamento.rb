# -*- encoding : utf-8 -*-
class Departamento
  include Mongoid::Document
  include ScopedSearch::Model
  #default_scope where(:responsavel => User.current_user.pessoa.id)
  include Colunas
  belongs_to :departamento_pai,:class_name=>"Departamento"
  belongs_to :orgao
  has_many :departamentos_filhos,:class_name=>"Departamento" ,:inverse_of=>:departamento_pai 
  has_one :responsavel,:class_name=>"User", :as=>:departamento
  has_many :funcionarios,:as=>:departamento
  has_many :cargos_comissionados,:class_name=>'CargoComissionado'

  field :nome, type: String
  field :sigla, type: String
  field :hierarquia, type: String
  scope :departamento, lambda { |q| where(:nome=> /.*#{q}.*/i) }
  scope :sigla_igual, lambda { |sigla| where( {:sigla => /.*#{sigla}.*/i }) }
  scoped_order :hierarquia, :nome,:sigla
  has_many :tramitacoes,:as=>:destino
  has_many :tramitacoes,:as=>:origem
  has_many :requisitos,:as=>:destino
  has_many :requisitos,:as=>:origem
  has_many :solicitacoes,:as=>:departamento

  def cargo_responsavel
    responsavel = self.cargos_comissionados.where(:responsavel=>true).first
    if !responsavel.nil? and responsavel.ocupante[1].nil?
      return responsavel,nil
    elsif !responsavel.nil? and !responsavel.ocupante[1].nil?
      return responsavel,responsavel.ocupante[1]
    end
  end


  
end
