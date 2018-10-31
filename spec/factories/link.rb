FactoryBot.define do
  factory :link do
    url { Faker::Internet.url('returnista.nl') }
  end
end