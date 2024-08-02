FactoryBot.define do
  factory :comment do
    comment { Faker::Hipster.sentences.sample }
    association :user, factory: :user
    association :post, factory: :post
  end
end
