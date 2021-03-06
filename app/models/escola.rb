# -*- encoding : utf-8 -*-
class Escola
  include Mongoid::Document
  include Mongoid::Timestamps
  field :codigo, type: String
  field :nome, type: String
  field :cnpj, type: String
  field :endereco, type: String
  field :numero, type: String
  field :bairro, type: String
  field :complemento, type: String
  field :cep, type: String
  field :email, type: String
  field :telefone, type: String
  field :fax, type: String
  field :celular, type: String
  belongs_to :municipio

  def nome_municipio
    return self.municipio.nome if self.municipio
  end
end
