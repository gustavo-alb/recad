json.array!(@configuracaos) do |configuracao|
  json.extract! configuracao, :id, :periodo_inicio, :periodo_fim, :aberto_escolas, :aberto_departamento
  json.url configuracao_url(configuracao, format: :json)
end
