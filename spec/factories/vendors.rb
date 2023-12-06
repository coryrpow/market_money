FactoryBot.define do
  factory :vendor do
    name { Faker::TvShows::Simpsons.character }
    description { Faker::TvShows::AquaTeenHungerForce.quote }
    contact_name { Faker::TvShows::Seinfeld.character }
    contact_phone { Faker::PhoneNumber.phone_number }
    credit_accepted { Faker::Boolean.boolean }
  end
end
