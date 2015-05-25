class AdministracaoController < ApplicationController
	before_action :dados,:admin
  def listagem_funcionarios
  	@q = Funcionario.ransack(params[:q])
    @q.sorts = "nome asc" if @q.sorts.empty?
    @funcionarios = @q.result(distinct: true).asc.paginate(:page=>params[:page],:per_page=>10)
  end

  def relatorio_quantitativo_professor
  	@disciplinas = Disciplina.asc(:nome)
    respond_to do |format|
      format.pdf { 
        send_data render_to_string, filename: 'foo.pdf', type: 'application/pdf', disposition: 'attachment'
      }
    end
  end

  def relatorio_quantitativo_nao_docente
   @funcionarios = Funcionario.where(:cargo.ne=>"Professor")
   respond_to do |format| 
     format.xlsx {render xlsx: 'relatorio_quantitativo_nao_docente',filename: "Relatório de Funcionários não docentes.xlsx"}
   end
 end

 def relatorio_nominal
 end
end