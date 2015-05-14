require 'test_helper'

class AdministracaoControllerTest < ActionController::TestCase
  test "should get listagem_funcionarios" do
    get :listagem_funcionarios
    assert_response :success
  end

  test "should get relatorio_quantitativo" do
    get :relatorio_quantitativo
    assert_response :success
  end

  test "should get relatorio_nominal" do
    get :relatorio_nominal
    assert_response :success
  end

end
