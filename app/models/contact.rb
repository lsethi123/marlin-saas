class Contact
  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_many :addresses
  embeds_many :phones
  embeds_many :websites
  embeds_many :emails
  embedded_in :contactable, polymorphic: true
  accepts_nested_attributes_for :addresses, :phones, :websites, :emails
end

class Address
  include Mongoid::Document
  field :street
  field :street2
  field :city
  field :state
  field :zip_code
  field :area
  field :country
  embedded_in :contact  
end

class Phone
  include Mongoid::Document
  field :of_type
  field :number
  field :code
  embedded_in :contact
end

class Website
  include Mongoid::Document
  field :url
  field :description
  field :of_type
  embedded_in :contact
end

class Email
  include Mongoid::Document
  field :ad, as: :address
  field :ot, as: :of_type
  embedded_in :contact
end
