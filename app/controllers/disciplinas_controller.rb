class DisciplinasController < ApplicationController
  before_action :set_disciplina, only: [:show, :edit, :update, :destroy]
  before_action :admin

  # GET /disciplinas
  # GET /disciplinas.json
def index
    @q = Disciplina.ransack(params[:q])
    @disciplinas = @q.result(distinct: true).asc(:nome).paginate(:page=>params[:page],:per_page=>10)
  end

  # GET /disciplinas/1
  # GET /disciplinas/1.json
  def show
  end

  # GET /disciplinas/new
  def new
    @caminho = admin_disciplinas_path
    @disciplina = Disciplina.new
  end

  # GET /disciplinas/1/edit
  def edit
   @caminho = admin_disciplina_path(@disciplina)
  end

  # POST /disciplinas
  # POST /disciplinas.json
  def create
    @disciplina = Disciplina.new(disciplina_params)
     @caminho = admin_disciplinas_path
    respond_to do |format|
      if @disciplina.save
        format.html { redirect_to admin_disciplina_path(@disciplina), notice: 'Disciplina was successfully created.' }
        format.json { render :show, status: :created, location: @disciplina }
      else
        format.html { render :new }
        format.json { render json: @disciplina.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /disciplinas/1
  # PATCH/PUT /disciplinas/1.json
  def update
     @caminho = admin_disciplina_path(@disciplina)
    respond_to do |format|
      if @disciplina.update(disciplina_params)
        format.html { redirect_to admin_disciplina_path(@disciplina), notice: 'Disciplina was successfully updated.' }
        format.json { render :show, status: :ok, location: @disciplina }
      else
        format.html { render :edit }
        format.json { render json: @disciplina.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /disciplinas/1
  # DELETE /disciplinas/1.json
  def destroy
    @disciplina.destroy
    respond_to do |format|
      format.html { redirect_to admin_disciplinas_url, notice: 'Disciplina was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_disciplina
      @disciplina = Disciplina.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def disciplina_params
      params.require(:disciplina).permit([:nome,:codigo])
    end
end
