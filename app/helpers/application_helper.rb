module ApplicationHelper
	def objeto_valor(obj)
		if !obj.blank?
			if obj.respond_to?(:nome) and !obj.nome.blank?
				return obj.nome
			elsif obj.respond_to?(:codigo) and !obj.codigo.blank?
				return obj.codigo
			elsif (obj.is_a?(String) or obj.is_a?(Integer)) and !obj.blank?
				return obj
			elsif !obj.blank? and (obj.is_a?(Boolean))
				return "Sim"
			else
				return "Nada Cadastrado"
			end
		elsif obj.blank? and (obj.is_a?(Boolean))
			return "Não"
		else
			return "Nada Cadastrado"
		end
	end
	def sortable(column, model, default, title = nil)
		title ||= column.titleize
		css_class = column == sort_column(model, default) ? "current #{sort_direction}" : nil
		direction = column == sort_column(model, default) && sort_direction == "asc" ? "desc" : "asc"
		link_to title, {:sort => column, :direction => direction}, {:class => css_class}
	end 

	def ambiente(obj)
		if !obj.blank? and obj.ambiente and obj.ambiente.include?("Programa")
			return "#{obj.ambiente}/#{obj.programa}"
		elsif !obj.blank? and obj.ambiente and !obj.ambiente.include?("Programa")
			return "#{obj.ambiente}"
		else
			return "Nada Cadastrado"
		end
	end
end
