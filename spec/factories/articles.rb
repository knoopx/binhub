FactoryGirl.define do
  factory :article do
    subject "Release [1/5] (filename.bin) (10/10)"
    date { 1.month.ago }
    from "hihi <hihi@kere.ws>"
    sequence(:uid) { |n| "<#{n}@eu.news.astraweb.com>" }
    size 1.megabyte
    lines 100
  end
end
