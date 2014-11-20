require 'spec_helper'

RSpec.describe Property, type: :model, ctrl_clean: true do
  
  let(:property) {FactoryGirl.build(:property)}

  it { should be_timestamped_document }
  it { should be_timestamped_document.with(:created) }
  it { should be_timestamped_document.with(:updated) }

  #relations
  it { should belong_to(:user) }
  it { should belong_to(:owner).of_type(User).as_inverse_of(:properties)  }
  it { should belong_to(:account) }
  it { should embed_one(:contact).with_autobuild }
  #it { should embed_one(:seo) }
  #it { should embed_one(:website_info) }
  it { should embed_many(:payments) }
  it { should accept_nested_attributes_for(:contact) }
  it { should have_many(:reservations).with_dependent(:destroy) }
  it { should have_many(:pictures).with_dependent(:destroy) }
  it { should embed_many(:rates)  }

  # required fields
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:contact) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:active)}

  #validations
  it { should validate_inclusion_of(:unit_type).to_allow([:house, :condo, :mobile_house]) }
  #it { should validate_inclusion_of(:status).to_allow([]) }
  it { should validate_inclusion_of(:bathrooms).to_allow(0..10) }
  it { should validate_inclusion_of(:bedrooms).to_allow(0..20) }
  it { should validate_inclusion_of(:garages).to_allow(0..10) }
  it { should validate_length_of(:name).within(4..50) }
  
  # fields
  it { should have_field(:name).of_type(String) }
  it { should have_field(:unit_type).of_type(Symbol).with_default_value_of(:house) }
  it { should have_field(:description).of_type(String) }
  it { should have_field(:active).of_type(Mongoid::Boolean).with_default_value_of(true) }
  it { should have_field(:check_in).of_type(String).with_default_value_of("12:00") }
  it { should have_field(:check_out).of_type(String).with_default_value_of("11:15") }
  it { should have_field(:directions).of_type(String) }  
  it { should have_field(:bathrooms).of_type(Integer).with_default_value_of(1) }
  it { should have_field(:bedrooms).of_type(Integer).with_default_value_of(1) }
  it { should have_field(:garages).of_type(Integer).with_default_value_of(0) }
  it { should have_field(:bedding).of_type(String) }
  it { should have_field(:tags).of_type(Array).with_default_value_of([]) }
  it { should have_field(:property_size).of_type(String) }
  it { should have_field(:minimum_days).of_type(Integer).with_default_value_of(1) }
  it { should have_field(:num_persons_allowed).of_type(Integer).with_default_value_of(4) }
  it { should have_field(:pets_allowed).of_type(Mongoid::Boolean).with_default_value_of(true) }
  it { should have_field(:amenities).of_type(String) }

  it 'should create new property' do
    property.save    
    expect(property).to be_persisted          
  end

  it 'should generate a slug' do
    property.save
    expect(property.slug).to be_present
  end

  it 'set account creator to user field if its not specified' do
    property.user = nil
    property.save
    expect(property).to be_persisted 
  end

  it 'adds default rates after property created' do
    @acc = FactoryGirl.create(:account)
    p = @acc.properties.build :name => 'Some house for rental', :description => 'Cool house near the beach'
    p.save
    @acc.rates.where(:always_apply => true).each do |r|
      expect(p.rates.find_by(:name => r.name)).not_to be_nil      
    end    
  end

  # Pending
  it 'update property rates from json post'
  it 'check booking availability'
end