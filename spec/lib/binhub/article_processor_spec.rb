require 'spec_helper'

describe BinHub::ArticleProcessor do
  let(:regular_expressions) { RegularExpression.all }

  def process_all!
    Article.find_each do |article|
      BinHub::ArticleProcessor.new(regular_expressions, article).call
    end
  end

  context do
    before do
      create(:article, subject: "Release [1/2] (filename.bin) (1/1)")
      create(:article, subject: "Release [2/2] (filename2.bin) (1/2)")
      create(:article, subject: "Release [2/2] (filename2.bin) (2/2)")
      create(:regular_expression)
    end

    before { process_all! }

    it "sucessfully marks releases as complete when all segments are processed" do
      Article.count.should == 3
      Release.count.should == 1

      Release.includes(:files).last.tap do |release|
        release.should be_complete
        release.size.should == 3.megabytes
        release.files.count.should == 2

        release.files.first.tap do |file|
          file.should be_complete
          file.name.should == "filename.bin"
          file.segments.count.should == 1
        end

        release.files.last.tap do |file|
          file.should be_complete
          file.name.should == "filename2.bin"
          file.segments.count.should == 2
        end
      end
    end
  end

  context do
    before do
      create(:article, subject: "Release [1/5] (filename.bin) (1/10)")
      create(:article, subject: "Release [2/5] (filename2.bin) (1/5)")
      create(:article, subject: "Release [2/5] (filename2.bin) (2/5)")
      create(:regular_expression)
    end

    before { process_all! }

    it "processes articles" do
      Article.count.should == 3
      Release.count.should == 1

      Release.includes(files: :segments).last.tap do |release|
        release.name.should == "Release"

        release.files_count.should == 2
        release.total_files.should == 5

        release.files.first.tap do |file|
          file.name.should == "filename.bin"
          file.number.should == 1
          file.total_segments.should == 10
          file.segments.first.tap do |segment|
            segment.number.should == 1
          end
        end

        release.files.last.tap do |file|
          file.name.should == "filename2.bin"
          file.number.should == 2
          file.total_segments.should == 5
          file.segments.first.tap do |segment|
            segment.number.should == 1
          end
          file.segments.last.tap do |segment|
            segment.number.should == 2
          end
        end
      end
    end
  end

  context do
    before do
      create(:article, subject: "Release (filename.bin) (1/10)")
      create(:article, subject: "Release (filename2.bin) (1/5)")
      create(:article, subject: "Release (filename2.bin) (2/5)")
      create(:regular_expression, value: ":name (:filename) (:segment_number/:total_segments)")
    end

    before { process_all! }

    it "processes articles without file number or total files" do
      Article.count.should == 3
      Release.count.should == 1

      Release.includes(files: :segments).last.tap do |release|
        release.name.should == "Release"
        release.files_count.should == 2
        release.total_files.should == nil

        release.files.first.tap do |file|
          file.name.should == "filename.bin"
          file.number.should == nil
          file.total_segments.should == 10
          file.segments.first.tap do |segment|
            segment.number.should == 1
          end
        end

        release.files.last.tap do |file|
          file.name.should == "filename2.bin"
          file.number.should == nil
          file.total_segments.should == 5
          file.segments.first.tap do |segment|
            segment.number.should == 1
          end
          file.segments.last.tap do |segment|
            segment.number.should == 2
          end
        end
      end
    end
  end
end