class AdministracaoController < ApplicationController
	before_action :dados,:admin
  def listagem_funcionarios
  	@q = Funcionario.ransack(params[:q])
    @q.sorts = "nome asc" if @q.sorts.empty?
    @funcionarios = @q.result(distinct: true).asc.paginate(:page=>params[:page],:per_page=>10)
  end

  def relatorio_quantitativo_professor
  	@disciplinas = Disciplina.asc(:nome)
    workbook = RubyXL::Parser.parse("#{Rails.root}/app/relatorios/relatorio_quantitativo_docente.xlsx")
    worksheet = workbook[0]
    @disciplinas.each.with_index(1) do |disciplina,i|
      if i.even?
        cor = "cccccc"
      else
        cor = "ffffff"
      end 
      worksheet.add_cell(i, 0, disciplina.nome)
      worksheet.add_cell(i, 1, disciplina.funcionarios.do_quadro("Estadual").count)
      worksheet.add_cell(i, 2, disciplina.funcionarios.do_quadro("Federal").count)
      worksheet.add_cell(i, 3, disciplina.funcionarios.do_quadro("Contrato Administrativo").count)
      worksheet.add_cell(i, 4, disciplina.funcionarios.do_quadro("Contrato Horista").count)
      worksheet.sheet_data[i][0].change_fill(cor)
      worksheet.sheet_data[i][1].change_fill(cor)
      worksheet.sheet_data[i][2].change_fill(cor)
      worksheet.sheet_data[i][3].change_fill(cor)
      worksheet.sheet_data[i][4].change_fill(cor)
      0.upto(4).each do |c|
        worksheet.sheet_data[i][c].change_border(:top, 'thin')
        worksheet.sheet_data[i][c].change_border(:left, 'thin')
        worksheet.sheet_data[i][c].change_border(:bottom, 'thin')
        worksheet.sheet_data[i][c].change_border(:right, 'thin')
     end
   end

   send_data workbook.stream.string,filename: "Relatório de Professores por Disciplina.xlsx" 
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