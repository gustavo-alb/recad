module ConfiguracaosHelper
	def aberto
		config = Configuracao.where(:periodo_inicio.lt=>Time.now,:periodo_fim.gte=>Time.now)
		local = current_usuario.local
		tipo = 'escola' if local.escola?
		tipo = 'setorial' if !local.escola?
		tipo = 'escola_rural' if local.escola? and local.municipio and local.municipio.nome!="Macapá" and local.municipio.nome!="Santana"
		if !config.none? and config.where(:aberto_escolas=>true).any? and tipo=='escola'
			return true
		elsif !config.none? and config.where(:aberto_escolas_rurais=>true).any? and tipo=='escola_rural'
			return true
		elsif !config.none? and config.where(:aberto_departamento=>true).any? and tipo=="setorial"
			return true
		elsif current_usuario.aberto?
			return true
		else 
			return false
		end
	end
end
