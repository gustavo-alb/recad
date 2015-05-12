# -*- encoding : utf-8 -*-
class Disciplina
	def columns
		self.fields
	end
	include Mongoid::Document
	include Mongoid::Timestamps
	field :nome, type: String
	field :codigo, type: String
	has_many :funcionarios,inverse_of: :disciplina_concurso
	has_many :funcionarios_atuando,:class_name=>"Funcionario",inverse_of: :disciplina_atuacao
end
