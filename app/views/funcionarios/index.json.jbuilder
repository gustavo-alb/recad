json.array!(@funcionarios) do |funcionario|
  json.extract! funcionario, :id, :nome, :cpf, :cadastro, :classe, :padrao, :carga_horaria
  json.url funcionario_url(funcionario, format: :json)
end
