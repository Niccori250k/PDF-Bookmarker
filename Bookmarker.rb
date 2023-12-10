require 'hexapdf'
require 'json'

Flag = {0 => nil, 1 => 0, 2 => 1, "Italic" => 0, "Bold" => 1}

def bm_create(outline, bm = Hash.new)
	if bm.key?(:Style)
		flag = Flag[bm[:Style]]
	end
	if bm.key?(:Color)
		color = bm[:Color]
	else
		color = "black"
	end
	if bm.key?(:Opened)
		is_open = bm[:Opened]
	else
		is_open = false
	end
	tmp = outline.add_item(bm[:Title], destination: bm[:Target] - 1, flags: flag, text_color: color, open: is_open)
	if bm.key?(:Bookmark)
		bm&.[](:Bookmark).each do |bm1|
			bm_create(tmp, bm1)
		end
	end
end

name = ARGF.argv[0].to_s

doc = HexaPDF::Document.open(name + ".pdf")
info_raw = File.open(name + ".json").read
info = JSON.parse(info_raw, symbolize_names: true)
doc.trailer.info[:Title] = info[:Info][:BookTitle]
doc.trailer.info[:Author] = info[:Info][:BookAuthor]

info[:Outline].each do |bm|
	/bookmark_create(doc, bm[:Title], bm[:Target], bm[:Style], bm[:Bookmark])/
	bm_create(doc.outline, bm)
end

doc.task(:optimize, compact: true, compress_pages: true)
doc.write(name + "_Bookmarked.pdf")