class User
  include Mongoid::Document
  include Mongoid::Timestamps
  
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  field :confirmation_token,   :type => String
  field :confirmed_at,         :type => Time
  field :confirmation_sent_at, :type => Time
  field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time  
  
  field :role, type: Symbol, default: :admin
  field :active, type: Boolean, default: true
  field :first_name, type: String
  field :last_name, type: String
  field :password
  field :title, type: String
  field :nickname, type: String
  
  has_many :bookings, class_name: 'Reservation', inverse_of: :tenant
  has_many :reservations, inverse_of: :user
  has_and_belongs_to_many :agent_accounts, class_name: 'Account', inverse_of: :owners
  has_one :account
  embeds_one :contact, as: :contactable,  autobuild: true
  has_many :properties, dependent: :destroy
  belongs_to :company_account, class_name: 'Account', inverse_of: :agents
  has_many :activities, :dependent => :destroy
  has_one :picture, :dependent => :destroy

  validates_presence_of :email, :first_name, :last_name, :active, :role
  validates_inclusion_of :role, :in => [:owner, :tenant, :agent, :admin, :master]

  validates_presence_of :password, on: :create
  validates_length_of :password, :within => 6..128, :allow_blank => true  


  def full_name
    "#{first_name} #{last_name}"
  end
end