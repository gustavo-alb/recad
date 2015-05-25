require 'test_helper'

class ConfiguracaosControllerTest < ActionController::TestCase
  setup do
    @configuracao = configuracaos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:configuracaos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create configuracao" do
    assert_difference('Configuracao.count') do
      post :create, configuracao: { aberto_departamento: @configuracao.aberto_departamento, aberto_escolas: @configuracao.aberto_escolas, periodo_fim: @configuracao.periodo_fim, periodo_inicio: @configuracao.periodo_inicio }
    end

    assert_redirected_to configuracao_path(assigns(:configuracao))
  end

  test "should show configuracao" do
    get :show, id: @configuracao
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @configuracao
    assert_response :success
  end

  test "should update configuracao" do
    patch :update, id: @configuracao, configuracao: { aberto_departamento: @configuracao.aberto_departamento, aberto_escolas: @configuracao.aberto_escolas, periodo_fim: @configuracao.periodo_fim, periodo_inicio: @configuracao.periodo_inicio }
    assert_redirected_to configuracao_path(assigns(:configuracao))
  end

  test "should destroy configuracao" do
    assert_difference('Configuracao.count', -1) do
      delete :destroy, id: @configuracao
    end

    assert_redirected_to configuracaos_path
  end
end
