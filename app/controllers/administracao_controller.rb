class AdministracaoController < ApplicationController
	before_action :dados,:admin
  def listagem_funcionarios
  	@q = Funcionario.ransack(params[:q])
    @funcionarios = @q.result(distinct: true).asc(:nome).paginate(:page=>params[:page],:per_page=>10)
  end

  def relatorio_quantitativo
  end

  def relatorio_nominal
  end
end
