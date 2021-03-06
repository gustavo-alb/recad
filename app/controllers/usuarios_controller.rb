class UsuariosController < ApplicationController
  before_action :set_usuario, only: [:show, :edit, :update, :destroy]
  before_action :dados
  before_action :admin
   autocomplete :local, :nome, full: true
   def get_autocomplete_items(parameters)
    searchterm = params[:term]
    items = Local.any_of({nome: Regexp.new(searchterm,Regexp::IGNORECASE) },{codigo: Regexp.new(searchterm,Regexp::IGNORECASE) })
  end
  # GET /usuarios
  # GET /usuarios.json
  def index
  @q = Usuario.ransack(params[:q])
  @usuarios = @q.result(distinct: true).asc(:nome).paginate(:page=>params[:page],:per_page=>10)
  end

  # GET /usuarios/1
  # GET /usuarios/1.json
  def show
  end

  # GET /usuarios/new
  def new
    @usuario = Usuario.new
    @caminho = admin_usuarios_path
  end

  # GET /usuarios/1/edit
  def edit
    @caminho = admin_usuario_path(@usuario)
  end

  # POST /usuarios
  # POST /usuarios.json
  def create
    @usuario = Usuario.new(usuario_params)
    @caminho = admin_usuarios_path
    respond_to do |format|
      if @usuario.save
        format.html { redirect_to admin_usuario_path(@usuario), notice: 'Usuario was successfully created.' }
        format.json { render :show, status: :created, location: @usuario }
      else
        format.html { render :new }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /usuarios/1
  # PATCH/PUT /usuarios/1.json
  def update
    @caminho = admin_usuario_path(@usuario)
    if @usuario.password.blank? and @usuario.password_confirmation.blank?
      params[:usuario].delete(:password)
      params[:usuario].delete(:password_confirmation)
    end
    respond_to do |format|
      if @usuario.update(usuario_params)
        format.html { redirect_to admin_usuario_path(@usuario), notice: 'Usuario was successfully updated.' }
        format.json { render :show, status: :ok, location: @usuario }
      else
        format.html { render :edit }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /usuarios/1
  # DELETE /usuarios/1.json
  def destroy
    @usuario.destroy
    respond_to do |format|
      format.html { redirect_to admin_usuarios_url, notice: 'Usuario was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_usuario
      @usuario = Usuario.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def usuario_params
      params.require(:usuario).permit([:aberto,:ativo,:editor,:gestor_setorial,:nome,:cpf,:local_id,:mudar_senha,:admin,:password,:password_confirmation,:gestor_seed])
    end

    def dados
      @locais = Local.asc(:nome).collect{|l|["#{l.nome.upcase} - #{l.codigo}",l.id]}
    end
  end
