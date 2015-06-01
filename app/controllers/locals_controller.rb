 class LocalsController < ApplicationController
  include ApplicationHelper
  before_action :set_local, only: [:show, :edit, :update, :destroy]
  before_action :dados,:admin

  # GET /locals
  # GET /locals.json
  def index
    @q = Local.ransack(params[:q])
    @locals = @q.result(distinct: true).asc(:nome).paginate(:page=>params[:page],:per_page=>10)
  end

  # GET /locals/1
  # GET /locals/1.json
  def show
  end

  def resumo_escola
   @escola = Local.find(params[:local_id])
   @funcionarios = @escola.funcionarios.where(:cargo.ne=>"Professor").asc(:nome)
   @professores = @escola.funcionarios.where(:cargo=>"Professor").asc(:nome)
   report = ODFReport::Report.new("#{Rails.root}/app/relatorios/resumo_escola.odt") do |r|

    r.add_field "USER", current_usuario.nome
    r.add_field "DATA", Date.today.to_s_br
    r.add_field "HORA", Time.now.strftime("%H:%M:%S")
    r.add_field "ESC", @escola.nome

    r.add_table("docentes", @professores, :header=>true) do |t|
      t.add_column(:NOME) { |funcionario| "#{funcionario.nome}" }
      t.add_column(:CAD) { |funcionario| "#{funcionario.cadastro}" }
      t.add_column(:QUADRO) { |funcionario| "#{funcionario.quadro}/#{funcionario.carga_horaria}" }
      t.add_column(:DISCORIG) { |funcionario| "#{objeto_valor(funcionario.disciplina_concurso)}" }
      t.add_column(:AMBIENTE) { |funcionario| "#{ambiente(funcionario)}" }
      t.add_column(:DISCATUACAO) { |funcionario| "#{objeto_valor(funcionario.disciplina_atuacao)}" }
      t.add_column(:TURMAS) { |funcionario| "#{objeto_valor(funcionario.turmas)}" }
      t.add_column(:HORASAULA) { |funcionario| "#{objeto_valor(funcionario.ch_em_sala)}" }
      t.add_column(:SITUACAO) { |funcionario| "#{objeto_valor(funcionario.situacao)}" }
    end
    r.add_table("nao_docentes", @funcionarios, :header=>true) do |t|
      t.add_column(:NOME) { |funcionario| "#{funcionario.nome}" }
      t.add_column(:CAD) { |funcionario| "#{funcionario.cadastro}" }
      t.add_column(:QUADRO) { |funcionario| "#{funcionario.quadro}/#{funcionario.carga_horaria}" }
      t.add_column(:CARGO) { |funcionario| "#{funcionario.cargo}" }
      t.add_column(:AMBIENTE) { |funcionario| "#{ambiente(funcionario)}" }
      t.add_column(:SITUACAO) { |funcionario| "#{objeto_valor(funcionario.situacao)}" }
    end

  end
  send_data report.generate, type: 'application/vnd.oasis.opendocument.text',
  disposition: 'attachment',
  filename: "Resumo da escola #{objeto_valor(@escola)}.odt"
end


  # GET /locals/new
  def new
    @local = Local.new
    @caminho = admin_locals_path
  end

  # GET /locals/1/edit
  def edit
   @caminho = admin_local_path(@local)
 end

  # POST /locals
  # POST /locals.json
  def create
    @local = Local.new(local_params)
    @caminho = admin_locals_path

    respond_to do |format|
      if @local.save
        format.html { redirect_to admin_local_path(@local), notice: 'Local was successfully created.' }
        format.json { render :show, status: :created, location: @local }
      else
        format.html { render :new }
        format.json { render json: @local.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locals/1
  # PATCH/PUT /locals/1.json
  def update
   @caminho = admin_local_path(@local)
   respond_to do |format|
    if @local.update(local_params)
      format.html { redirect_to admin_local_path(@local), notice: 'Local was successfully updated.' }
      format.json { render :show, status: :ok, location: @local }
    else
      format.html { render :edit }
      format.json { render json: @local.errors, status: :unprocessable_entity }
    end
  end
end

  # DELETE /locals/1
  # DELETE /locals/1.json
  def destroy
    @local.destroy
    respond_to do |format|
      format.html { redirect_to admin_locals_url, notice: 'Local was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_local
      @local = Local.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def local_params
      params.require(:local).permit([:nome,:codigo,:municipio,:escola,:setorial,:secretaria,:local_pai])
    end
  end
