module FuncionariosHelper
	def carga_horaria(obj)
		if (obj.is_a?(String) or obj.is_a?(Integer)) and !obj.blank?
			return "#{obj} Horas"
		else
			return "Nada Cadastrado"
		end
	end

	def ambiente_alerta(obj)
		if obj.local.escola and obj.ambiente.blank? and (obj.situacao=="Ativo" or obj.situacao=="Acompanhado pela Casa do Professor" or obj.situacao=="Ativo mas em sala ambiente perante perícia médica")
			return raw "<b style='color: red;'>Nada cadastrado</b>"
		elsif !obj.ambiente.blank?
			return obj.ambiente
			else
				return "Nada Cadastrado"
		end
	end
end
