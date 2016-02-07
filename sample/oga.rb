
require 'oga'

document = Oga.parse_xml <<-EOF
<people>
  <person id="1">
  <name>Alice</name>
  <age>28</name>
  </person>
</people>
EOF

document.xpath('people/person').each do |person|
  puts person.get('id') # => "1"
  puts person.at_xpath('name').text # => "Alice"
end
