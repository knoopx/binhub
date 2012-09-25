FactoryGirl.define do
  factory :reference do
    sequence(:number)
    article
    group
  end
end
