FactoryGirl.define do
  factory :regular_expression do
    value ":name [:file_number/:total_files] (:filename) (:segment_number/:total_segments)"
    process_placeholders true
  end
end
