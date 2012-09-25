ActiveRecord::Base.transaction do
  File.open(File.expand_path("../seeds/groups.seed", __FILE__)).each_line do |line|
    next if line.start_with?("#")
    Group.create!(name: line.chomp)
  end

  File.open(File.expand_path("../seeds/regex.seed", __FILE__)).each_line do |line|
    RegularExpression.create!(value: line.chomp, :process_placeholders => false)
  end
end