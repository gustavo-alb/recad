class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_usuario!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def mongoid_get_autocomplete_items(parameters)
  	model = parameters[:model]
  	method = parameters[:method]
  	options = parameters[:options]
  	is_full_search = options[:full]
  	term = parameters[:term]
  	limit = get_autocomplete_limit(options)
  	order = mongoid_get_autocomplete_order(method, options)

  	if is_full_search
  		search = '.*' + Regexp.escape(term) + '.*'
  	else
  		search = '^' + Regexp.escape(term)
  	end
  	items = model.where(method.to_sym => /#{search}/i).limit(limit).order_by(order)
  end

  def mongoid_get_autocomplete_order(method, options, model=nil)
  	order = options[:order]
  	if order
  		order.split(',').collect do |fields|
  			sfields = fields.split
  			[sfields[0].downcase.to_sym, sfields[1].downcase.to_sym]
  		end
  	else
  		[[method.to_sym, :asc]]
  	end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:cpf, :email, :nome, :admin, :mudar_senha, :inep, :local_id,:current_password,:password,:password_confirmation) }
  end

  def mudar_senha
    if current_usuario.mudar_senha?
      redirect_to(edit_usuario_registration_path,:notice=>"Mude sua senha, para evitar problemas posteriormente.")
    end
  end

  def admin
    if !current_usuario.admin?
      redirect_to :root,:alert=>"Você não tem acesso a esta área"
    end
  end

end
