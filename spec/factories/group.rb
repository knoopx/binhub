FactoryGirl.define do
  factory :group do
    name { "alt.binaries.#{Faker::Internet.domain_word}" }
  end
end
