class AdministracaoController < ApplicationController
  include ApplicationHelper
  before_action :dados,:gestores,:mudar_senha
  autocomplete :local, :nome, full: true
  def get_autocomplete_items(parameters)
    searchterm = params[:term]
    items = Local.secretarias.any_of({nome: Regexp.new(searchterm,Regexp::IGNORECASE) },{codigo: Regexp.new(searchterm,Regexp::IGNORECASE) })
  end

  def listagem_funcionarios
    if current_usuario.editor?
      @q = Funcionario.where(:usuario=>current_usuario).ransack(params[:q])
    else
      @q = Funcionario.ransack(params[:q])
    end
    @q.sorts = "nome asc" if @q.sorts.empty?
    @funcionarios = @q.result(distinct: true).asc.paginate(:page=>params[:page],:per_page=>10)
  end

  def relatorio_quantitativo
    @discs = Disciplina.all.asc(:nome)
    @cargos = ["Cuidador","Intérprete","Agente de Portaria","Auxiliar Operacional de Serviços Diversos" ,"Especialista em Educaçao","Pedagogo","Auxiliar Educacional","Professor","Agente Administrativo","Datilógrafo","Auxiliar Administrativo"].sort
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "relatorio_quantitativo"   # Excluding ".pdf" extension.
      end
    end
  end

  def relatorio_quantitativo_em_sala
    @discs = Disciplina.all.asc(:nome)
    report = ODFReport::Report.new("#{Rails.root}/app/relatorios/relatorio_quantitativo.odt") do |r|

      r.add_field "USER", current_usuario.nome
      r.add_field "DATA", Date.today.to_s_br
      r.add_field "HORA", Time.now.strftime("%H:%M:%S")


      r.add_table("AMBIENTE", (@ambientes+["Sala de Aula"]), :header=>true) do |t|
        t.add_column(:AMBIENTE) { |a| "#{a.upcase}" }
        t.add_column(:EST) { |d| "#{Funcionario.where(:ambiente=>d,:quadro=>"Estadual")}.count" }
        t.add_column(:FED) { |d| "#{d.funcionarios_atuando.where(:quadro=>'Federal').count}" }
        t.add_column(:CONT) { |d| "#{d.funcionarios_atuando.where(:quadro=>'Contrato Administrativo').count}" }
        t.add_column(:TOTDISC) {|d|"#{d.funcionarios_atuando.count}"}
      end

      r.add_table("disciplinas", @discs, :header=>true) do |t|
        t.add_column(:DISCIPLINA) { |d| "#{d.nome.upcase}" }
        t.add_column(:EST) { |d| "#{d.funcionarios_atuando.where(:quadro=>'Estadual').count}" }
        t.add_column(:FED) { |d| "#{d.funcionarios_atuando.where(:quadro=>'Federal').count}" }
        t.add_column(:CONT) { |d| "#{d.funcionarios_atuando.where(:quadro=>'Contrato Administrativo').count}" }
        t.add_column(:TOTDISC) {|d|"#{d.funcionarios_atuando.count}"}
        r.add_field "TOTEST",Funcionario.where(:cargo=>"Professor",:disciplina_atuacao.ne=>nil,:quadro=>"Estadual").count
        r.add_field "TOTFED",Funcionario.where(:cargo=>"Professor",:disciplina_atuacao.ne=>nil,:quadro=>"Federal").count
        r.add_field "TOTCONT",Funcionario.where(:cargo=>"Professor",:disciplina_atuacao.ne=>nil,:quadro=>"Contrato Administrativo").count
        r.add_field "TOTPROF",Funcionario.where(:cargo=>"Professor").count
      end
    end
    send_data report.generate, type: 'application/vnd.oasis.opendocument.text',
    disposition: 'attachment',
    filename: "Resumo Quantitativo Geral.odt"
  end






  def relatorio_nominal_em_sala
   @professores_em_sala_estadual = Funcionario.where(:cargo=>"Professor",:quadro=>"Estadual",:ambiente=>"Sala de Aula").asc(:nome)
   @professores_fora_de_sala_estadual = Funcionario.where(:cargo=>"Professor",:quadro=>"Estadual",:ambiente.in=>@ambientes,:ambiente.ne=>"Sala de Aula").asc(:nome)
   @professores_fora_de_sala_contrato = Funcionario.where(:cargo=>"Professor",:quadro=>"Contrato Administrativo",:ambiente.in=>@ambientes,:ambiente.ne=>"Sala de Aula").asc(:nome)
   @nao_docente_estadual = Funcionario.where(:cargo.ne=>"Professor",:quadro=>"Estadual").asc(:nome)
   @nao_docente_contrato = Funcionario.where(:cargo.ne=>"Professor",:quadro=>"Contrato Administrativo").asc(:nome)
   @nao_docente_federal = Funcionario.where(:cargo.ne=>"Professor",:quadro=>"Federal").asc(:nome)
   respond_to do |format|
    format.xlsx
  end
end

def relatorio_sem_cadastro
 @escolas = []
 @setoriais = []
 Local.where(:escola=>true).asc(:nome).each do |e|
  if e.funcionarios.none?
    @escolas << e
  end
end
Local.where(:local_pai_id.ne=>nil).asc(:nome).each do |d|
  if d.funcionarios.none?
    @setoriais << d
  end
end

report = ODFReport::Report.new("#{Rails.root}/app/relatorios/locais_sem_cadastro.odt") do |r|

  r.add_field "USER", current_usuario.nome
  r.add_field "DATA", Date.today.to_s_br
  r.add_field "HORA", Time.now.strftime("%H:%M:%S")

  r.add_table("escolas", @escolas, :header=>true) do |t|
    t.add_column(:NOME) { |local| "#{local.nome.upcase}" }
    t.add_column(:CODIGO) { |local| "#{local.codigo}" }
  end

  r.add_table("setoriais", @setoriais, :header=>true) do |t|
    t.add_column(:NOME) { |local| "#{local.nome.upcase}" }
    t.add_column(:CODIGO) { |local| "#{local.codigo}" }
  end
end
send_data report.generate, type: 'application/vnd.oasis.opendocument.text',
disposition: 'attachment',
filename: "Resumo da escola #{objeto_valor(@escola)}"
end

def criar_funcionario
  @funcionario = Funcionario.new
  @titulo = "Cadastrar Funcionário"
  @caminho = administracao_salvar_funcionario_path
  render "editor"
end

def editar_funcionario
  @funcionario = Funcionario.find(params[:funcionario_id])
  @titulo = "Editar Funcionário"
  @caminho = administracao_atualizar_funcionario_path(:funcionario_id=>params[:funcionario_id])
  render "editor"
end

def salvar_funcionario
 funcionario_params.delete(:local_nome)
 @funcionario = Funcionario.new(funcionario_params)
 @titulo = "Cadastrar Funcionário"
 @caminho = administracao_salvar_funcionario_path
 respond_to do |format|
  if @funcionario.save
    format.html { redirect_to administracao_detalhes_funcionario_path(:funcionario_id=>@funcionario), notice: 'Funcionário cadastrado com sucesso' }
    format.json { render :show, status: :created, location: @funcionario }
  else
    format.html { render :editor }
    format.json { render json: @funcionario.errors, status: :unprocessable_entity }
  end
end
end

def atualizar_funcionario
  @funcionario = Funcionario.find(params[:funcionario_id])
  titulo = "Editar Funcionário"
  @caminho = administracao_atualizar_funcionario_path(:funcionario_id=>params[:funcionario_id])
  respond_to do |format|
    if @funcionario.update(funcionario_params)
      format.html { redirect_to administracao_detalhes_funcionario_path(:funcionario_id=>@funcionario.id), notice: 'Funcionário atualizado.' }
      format.json { render :show, status: :ok, location: @funcionario }
    else
      format.html { render :edit,:alert=>"Erros no cadastro, favor checar" }
      format.json { render json: @funcionario.errors, status: :unprocessable_entity }
    end
  end
end

def detalhes_funcionario
  @funcionario = Funcionario.find(params[:funcionario_id])
end
def funcionario_params
  params.require(:funcionario).permit([:documento,:usuario_id,:componente_curricular,:nome, :cpf, :cadastro, :classe, :padrao, :turmas, :carga_horaria, :ambiente,:ambiente_nao_docente, :formacao, :ch_em_sala, :cargo, :quadro, :concurso, :area_concurso, :programa, :situacao, :local_id,:local, :disciplina_concurso, :disciplina_atuacao, :municipio_concurso])
end

end