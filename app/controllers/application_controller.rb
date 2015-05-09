class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_usuario!

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
end
