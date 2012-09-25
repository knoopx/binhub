require 'spec_helper'

describe Group do
  context do
    let!(:group) { create(:group) }
    let!(:article) { create(:article) }
    let!(:first_reference) { create(:reference, number: "1", article: article, group: group) }
    let!(:last_reference) { create(:reference, number: "2", article: article, group: group) }
    let!(:another_reference) { create(:reference, number: "0", article: article, group: group) }

    example "#last_reference" do
      group.last_reference.should == last_reference
    end
  end
end