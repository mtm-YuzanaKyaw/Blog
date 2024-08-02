FactoryBot.define do
  factory :post do
    title { Faker::Book.title }
    conntent { Faker::Quote.matz }
    association :user, factory: :user
  end
end
