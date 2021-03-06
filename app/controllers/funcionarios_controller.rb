class FuncionariosController < ApplicationController
  before_action :set_funcionario, only: [:show, :edit, :update, :destroy]
  before_action :mudar_senha
  before_filter :dados
  before_filter :redir_editores
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
      if @funcionario.save
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
      params.require(:funcionario).permit([:componente_curricular,:nome, :cpf, :cadastro, :classe, :padrao, :turmas, :carga_horaria, :ambiente,:ambiente_nao_docente, :formacao, :ch_em_sala, :cargo, :quadro, :concurso, :area_concurso, :programa, :situacao, :local_id,:local, :disciplina_concurso, :disciplina_atuacao, :municipio_concurso])
    end
end
