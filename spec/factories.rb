FactoryGirl.define do  
  factory :company do
    name 'SecondHouz'
    contact { FactoryGirl.build(:contact) }
  end
  factory :ecommerce_plan do
    trait :free do
      name '1-5 free properties'
      description 'Publish 1 to 5 properties for free'
      num_items_allowed 5
      price 0 
    end
    trait :charge do
      name '1-50 Properties For 9.99 Year'
      description 'Administer up to 50 properties for 9.99 Year'
      num_items_allowed 50
      price 9.99
    end
  end
  factory :letter do
    name 'confirmation email'
  end
  factory :reservation do
    user { FactoryGirl.create(:user) }
  end
  factory :activity do
    description 'Jim created reservation'
  end
  factory :account do
    user { FactoryGirl.create(:user) }
  end
  factory :user do
    email 'master@boloflix.com'
    first_name 'Adbeel'
    last_name 'Guzman'
    trait :owner do
      role :owner
    end          
    trait :agent do
      role :owner
    end   
    trait :tenant do
      role :owner
    end   
  end
  factory :contact do
    addresses { [FactoryGirl.build(:address)] }
    phones { [FactoryGirl.build(:phone)] }
    websites { [FactoryGirl.build(:website)] }
    emails { [FactoryGirl.build(:email)] }
  end  
  factory :address do
    street '1234 Main St'
    city 'Seattle'
    state 'WA'
    zip_code '12345'
  end
  factory :phone do
    of_type :mobile
    number '412-555-4838'
  end
  factory :website do
    url 'http://www.boloflix.com'
    description 'boloflix blog'
  end
  factory :email do
    address 'master@boloflix.com'
    of_type :company
  end
end