class FuncionariosController < ApplicationController
  before_action :set_funcionario, only: [:show, :edit, :update, :destroy]
  before_action :mudar_senha
  before_filter :dados
  #autocomplete :local,:nome,:full=>true

  # GET /funcionarios
  # GET /funcionarios.json
  def index
    @usuario = current_usuario
    @funcionarios = @usuario.local.funcionarios.asc(:nome)
  end

  # GET /funcionarios/1
  # GET /funcionarios/1.json
  def show
  end

  # GET /funcionarios/new
  def new
    @funcionario = Funcionario.new
  end

  # GET /funcionarios/1/edit
  def edit
  end

  # POST /funcionarios
  # POST /funcionarios.json
  def create
    @funcionario = Funcionario.new(funcionario_params)
    respond_to do |format|
      if @funcionario.save!
        format.html { redirect_to @funcionario, notice: 'Funcionário cadastrado com sucesso' }
        format.json { render :show, status: :created, location: @funcionario }
      else
        format.html { render :new }
        format.json { render json: @funcionario.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /funcionarios/1
  # PATCH/PUT /funcionarios/1.json
  def update
    respond_to do |format|
      if @funcionario.update(funcionario_params)
        format.html { redirect_to @funcionario, notice: 'Funcionário atualizado.' }
        format.json { render :show, status: :ok, location: @funcionario }
      else
        format.html { render :edit,:alert=>"Erros no cadastro, favor checar" }
        format.json { render json: @funcionario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /funcionarios/1
  # DELETE /funcionarios/1.json
  def destroy
    @funcionario.destroy
    respond_to do |format|
      format.html { redirect_to funcionarios_url, notice: 'Funcionário apagado.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_funcionario
      @funcionario = Funcionario.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def funcionario_params
      params.require(:funcionario).permit([:nome, :cpf, :cadastro, :classe, :padrao, :turmas, :carga_horaria, :ambiente,:ambiente_nao_docente, :formacao, :ch_em_sala, :cargo, :quadro, :concurso, :area_concurso, :programa, :situacao, :local_id,:local, :disciplina_concurso, :disciplina_atuacao, :municipio_concurso])
    end

    def dados
      @classes = ["A","B","C","D","E","F","S","GAB","3ª"].sort
      @padroes = ((1.upto(25).to_a)+[202,302,303,401,402,103]).sort
      @locais = Local.asc(:nome).collect{|l|["#{l.nome.upcase} - #{l.codigo}",l.id]}
      @ambientesprof = ["Portaria","Oficina de Artes","Laboratório de Ciências","Espaço Multimídia","TV Escola","Assessoria de Direção", "Biblioteca", "Coordenação Pedagógica - Assessor Pedagógico", "Coordenação Pedagógica - Orientação", "Coordenação Pedagógica - Supervisão", "Coordenação de Programa Estadual","Coordenação de Programa Federal", "LIED", "Sala de Aula", "Sala de Leitura", "Secretaria Escolar ","Sistema Modular de Ensino Médio","Sistema Modular de Ensino Fundamental","Sistema Modular de Ensino Médio Indígena","Sistema Modular de Ensino Fundamental Indígena","Atendimento de Ensino Especial"].sort
      @ambientes = ["Portaria","Oficina de Artes","Laboratório de Ciências","Espaço Multimídia","TV Escola","Assessoria de Direção", "Biblioteca", "Coordenação Pedagógica - Assessor Pedagógico", "Coordenação Pedagógica - Orientação", "Coordenação Pedagógica - Supervisão", "Coordenação de Programa Estadual","Coordenação de Programa Federal", "LIED", "Sala de Leitura", "Secretaria Escolar","Atendimento de Ensino Especial"].sort
      @disciplinas = Disciplina.asc(:nome).collect{|d|[d.nome,d.id]}
      @formacoes = []
      @cargas_horarias = ["20 Horas","40 Horas"]
      @cargos = ["Cuidador","Intérprete","Agente de Portaria","Auxiliar Operacional de Serviços Diversos" ,"Especialista em Educaçao","Pedagogo","Auxiliar Educacional","Professor","Agente Administrativo","Datilógrafo","Auxiliar Administrativo"].sort
      @quadros = ["Estadual","Federal","Contrato Administrativo","Contrato Horista"]
      @concursos = ["Antes de 1989","1989","1992","1993","1994","1996","2000 (Ex-Ipesap)","2005","2012"]
      @municipios = Municipio.asc(:nome).collect{|m|[m.nome,m.id]}
      @situacoes = ["Ativo","Acompanhado pela Casa do Professor","Ativo mas em sala ambiente perante perícia médica","Licença Sem Vencimento","Licença Maternidade","Licença Médica (Junta Médica/AMPREV)","Licença para Estudos","Licença Prêmio Especial"]
    end
end
