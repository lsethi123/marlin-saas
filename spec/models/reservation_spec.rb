require 'spec_helper'

RSpec.describe Reservation, type: :model, ctrl_clean: true do
  
  let(:account) {FactoryGirl.build(:account)}
  let(:reservation) {FactoryGirl.build(:reservation, :user => account.user)}
  
  def assert_rsv_creation
    reservation.save
    expect(reservation).to be_persisted
  end

  it { should be_timestamped_document }
  it { should be_timestamped_document.with(:created) }
  it { should be_timestamped_document.with(:updated) }

  #required
  it { should validate_presence_of(:rsv_type) }
  it { should validate_presence_of(:check_in) }
  it { should validate_presence_of(:check_out) }
  it { should validate_presence_of(:user) }
  #it { should validate_presence_of(:tenant) }

  #fields
  it { should have_field(:rsv_type).of_type(Symbol).with_default_value_of(:regular) }
  it { should have_field(:check_in).of_type(Date) }
  it { should have_field(:check_out).of_type(Date) }
  it { should have_field(:num_adults).of_type(Integer).with_default_value_of(2) }
  it { should have_field(:num_children).of_type(Integer).with_default_value_of(0) }
  it { should have_field(:stage).of_type(Symbol) }
  it { should have_field(:notes).of_type(String) }  

  #validations
  it { should validate_inclusion_of(:rsv_type).to_allow([:regular, :owner_time, :agent_block]) }
  it { should validate_inclusion_of(:num_adults).to_allow(1..300) }
  it { should validate_inclusion_of(:num_children).to_allow(1..300) }
  
  #relation
  it { should belong_to(:user) }
  it { should belong_to(:account) }
  it { should belong_to(:property) }
  it { should belong_to(:tenant).of_type(User).as_inverse_of(:bookings) }
  it { should have_many(:activities) }
  it { should embed_many(:payments) }
  it { should embed_one(:guest).with_autobuild}
  it { should accept_nested_attributes_for(:guest) }  

  it 'should create new reservation' do
    assert_rsv_creation
  end

  it 'destroys completely the reservation if status is pending' do
    assert_rsv_creation
    reservation.discard
    expect(reservation).not_to be_persisted
  end

  it 'creates booking creation activity' do
    assert_rsv_creation
    expect(Activity.where(:logeable_type => Reservation.to_s).and(:logeable_id => reservation.id)).not_to be_nil   
  end

end