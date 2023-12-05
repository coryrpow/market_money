FactoryBot.define do
  factory :market do
    name { Faker::TvShows::TwinPeaks.character }
    street { Faker::Address.street_address }
    city { Faker::TvShows::Simpsons.location }
    county { Faker::TvShows::Spongebob.character }
    state { Faker::Address.state }
    zip { Faker::Address.zip }
    lat { Faker::Address.latitude }
    lon { Faker::Address.longitude }
  end
end
