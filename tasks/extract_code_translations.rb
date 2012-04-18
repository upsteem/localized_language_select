require 'nokogiri'

# html = open('http://www.biblegateway.com/passage/?search=Mateo1-2&version=NVI')
# doc = Nokogiri::HTML(html.read)

link = 'language_table.html'

# doc = Nokogiri::HTML(open(link))

doc = Nokogiri::HTML(open(link).read, nil, 'utf-8')
# doc.encoding = 'utf-8'

codes = doc.css('tr td:first').map(&:content)

puts codes

hash = {}
current_code = ''

doc.css('tr').each do |tr|
	td = tr.css('td').first
	puts td
	if td
		code = td.content 
		hash[code] = []

		tr.css('td').each do |td|
			label = td.content
			hash[code] << label if hash[code] && label != code
		end
	end
end

puts hash
