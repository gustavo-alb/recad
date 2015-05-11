module FuncionariosHelper
	def objeto_valor(obj)
		if !obj.blank?
			if obj.respond_to?(:nome) and !obj.nome.blank?
				return obj.nome
			elsif obj.respond_to?(:codigo) and !obj.codigo.blank?
				return obj.codigo
			elsif (obj.is_a?(String) or obj.is_a?(Integer)) and !obj.blank?
				return obj
			else
				return "Nada Cadastrado"
			end
		else
			return "Nada Cadastrado"
		end
	end

	def carga_horaria(obj)
		if (obj.is_a?(String) or obj.is_a?(Integer)) and !obj.blank?
			return "#{obj} Horas"
		else
			return "Nada Cadastrado"
		end
	end
end
