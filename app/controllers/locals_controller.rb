 class LocalsController < ApplicationController
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
