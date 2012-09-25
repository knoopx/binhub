# encoding: utf-8

#<?xml version="1.0" encoding="UTF-8"?>
xml.instruct!

# <!DOCTYPE nzb PUBLIC "-//newzBin//DTD NZB 1.1//EN" "http://www.newzbin.com/DTD/nzb/nzb-1.1.dtd">
xml.declare! :DOCTYPE, :nzb, :PUBLIC, "-//newzBin//DTD NZB 1.1//EN", "http://www.newzbin.com/DTD/nzb/nzb-1.1.dtd"

# <nzb xmlns="http://www.newzbin.com/DTD/2003/nzb">
xml.nzb xmlns: "http://www.newzbin.com/DTD/2003/nzb" do
  # <head>
  xml.head do |head|
    # <meta type="category">Audio &gt; MP3</meta>
    # head.meta "Category", type: "category"
    # <meta type="name">Risenfall - Le Loon EP-(TBS08)-WEB-2012-YOU</meta>
    head.meta resource.name, type: "name"
  end
  #</head>

  resource.files.each do |file|
    # <file poster="hihi &lt;hihi@kere.ws&gt;" date="1347703791" subject="&lt;kere.ws&gt; - MP3 - 1347700312 - Risenfall_-_Le_Loon_EP-(TBS08)-WEB-2012-YOU - [01/13] - &quot;00_risenfall_-_le_loon_ep-(tbs08)-web-2012-you.m3u&quot; yEnc (1/1) (1/1)">
    xml.file(poster: file.articles.first.from, date: file.articles.first.date, subject: file.articles.first.subject) do |file_node|
      # <groups>
      file_node.groups do |groups_node|
        #  <group>alt.binaries.mom</group>
        resource.groups.each { |group| groups_node.group group.name }
      end
      # </groups>
      # <segments>
      file_node.segments do |segments_node|
        file.segments.each do |segment|
          #  <segment bytes="746" number="1">1347703791.28055.1@eu.news.astraweb.com</segment>
          segments_node.segment segment.article.nzb_uid, bytes: segment.article.size, number: segment.number
        end
      end
      # </segments>
    end
    #</file>
  end
end