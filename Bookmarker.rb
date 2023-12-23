require 'hexapdf'
require 'json'
require 'optparse'

Flag = {0 => nil, 1 => 0, 2 => 1, "Italic" => 0, "Bold" => 1}

def bm_create(outline, bm = Hash.new)
	if bm.key?(:Style) && bm[:Style] != ""
		flag = Flag[bm[:Style]]
	end
	if bm.key?(:Color) && bm[:Color] != ""
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

options = ARGV.getopts("i:b:o:", "input:", "bookmark:", "output:", "no-optimize")
input = (options["i"].nil? ? options["input"] : options["i"]).to_s
json = (options["b"].nil? ? options["bookmark"].nil? ? input : options["bookmark"] : options["b"]).to_s.sub(/\.pdf$/, ".json")
output = (options["o"].nil? ? options["output"] : options["o"]).to_s

doc = HexaPDF::Document.open(input)
info_raw = File.open(json).read
info = JSON.parse(info_raw, symbolize_names: true)
doc.trailer.info[:Title] = info[:Info][:BookTitle]
doc.trailer.info[:Author] = info[:Info][:BookAuthor]

info[:Outline].each do |bm|
	bm_create(doc.outline, bm)
end

unless options["no-optimize"]
	doc.task(:optimize, compact: true, object_streams: :generate, xref_streams: :generate, compress_pages: true, prune_page_resources: true)
end
doc.write(output)