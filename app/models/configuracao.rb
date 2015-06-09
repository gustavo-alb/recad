class Configuracao
	include Mongoid::Document
	field :periodo_inicio, type: DateTime
	field :periodo_fim, type: DateTime
	field :aberto_escolas, type: Mongoid::Boolean
	field :aberto_departamento, type: Mongoid::Boolean
	field :aberto_escolas_rurais,type: Mongoid::Boolean
	field :ativa,type: Mongoid::Boolean
end
