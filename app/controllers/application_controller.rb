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
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:ativo,:local_nome,:gestor_setorial,:editor,:login,:cpf, :email, :nome, :admin, :mudar_senha, :inep, :local_id,:current_password,:password,:password_confirmation,:gestor_seed) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :inep, :cpf, :password, :remember_me) }
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

  def gestores
    if !current_usuario.admin? and !current_usuario.editor? and !current_usuario.gestor_seed?
      redirect_to :root,:alert=>"Você não tem acesso a esta área"
    end
  end

  def redir_editores
    if current_usuario.editor?
      redirect_to :root,:alert=>"Você não tem acesso a esta área"
    end
  end


      def dados
      @classes = ["A","B","C","D","E","F","S","GAB","3ª"].sort
      @padroes = ((1.upto(25).to_a)+[202,302,303,401,402,103]).sort
      @locais = Local.asc(:nome).collect{|l|["#{l.nome.upcase} - #{l.codigo}",l.id]}
      @ambientesprof = ["Coordenação de Projetos","Projeto Estadual","Projeto Federal","Portaria","Oficina de Artes","Laboratório de Ciências","Espaço Multimídia","TV Escola","Assessoria de Direção", "Biblioteca", "Coordenação Pedagógica - Assessor Pedagógico", "Coordenação Pedagógica - Orientação", "Coordenação Pedagógica - Supervisão", "Coordenação de Programa Estadual","Coordenação de Programa Federal", "LIED", "Sala de Aula", "Sala de Leitura", "Secretaria Escolar ","Sistema Modular de Ensino Médio","Sistema Modular de Ensino Fundamental","Sistema Modular de Ensino Médio Indígena","Sistema Modular de Ensino Fundamental Indígena","Atendimento de Ensino Especial"].sort
      @ambientes = ["Coordenação de Projetos","Projeto Estadual","Projeto Federal","Oficina de Artes","Laboratório de Ciências","Espaço Multimídia","TV Escola","Assessoria de Direção", "Biblioteca", "Coordenação Pedagógica - Assessor Pedagógico", "Coordenação Pedagógica - Orientação", "Coordenação Pedagógica - Supervisão", "Coordenação de Programa Estadual","Coordenação de Programa Federal", "LIED", "Sala de Leitura", "Secretaria Escolar","Atendimento de Ensino Especial"].sort
      @disciplinas = Disciplina.asc(:nome).collect{|d|[d.nome,d.id]}
      @formacoes = []
      @cargas_horarias = ["20 Horas","30 Horas","40 Horas"]
      @cargos = ["Assessor","Diretor","Secretarário","Diretor Adjunto","Cuidador","Intérprete","Agente de Portaria","Auxiliar Operacional de Serviços Diversos" ,"Especialista em Educaçao","Pedagogo","Auxiliar Educacional","Professor","Agente Administrativo","Datilógrafo","Auxiliar Administrativo"].sort
      @quadros = ["Cargo Comissionado Sem Vínculo","Estadual","Federal","Contrato Administrativo"]
      @concursos = ["Antes de 1989","1989","1992","1993","1994","1996","2000 (Ex-Ipesap)","2005","2012"]
      @municipios = Municipio.asc(:nome).collect{|m|[m.nome,m.id]}
      @situacoes = ["Ativo","Acompanhado pela Casa do Professor","Ativo mas em sala ambiente perante perícia médica","Licença Sem Vencimento","Licença Maternidade","Licença Médica (Junta Médica/AMPREV)","Licença para Estudos","Licença Prêmio Especial"]
      @boolean = [["Sim",true],["Não",false]] 
    end



end
