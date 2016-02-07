
require 'oga'

class XMLParser
  attr_accessor :xdoc

  class<<self
    def open(fname)
      handle = File.open(fname)
      xdoc = Oga.parse_xml(handle)
      xp = new
      xp.xdoc = xdoc
      xp
    end
  end

  def read_people
    by_xpath('peoples/people/person')
  end

  private
  def by_xpath(xpath)
    xdoc.xpath(xpath).each do |person|
      puts person.get('id')
      puts person.at_xpath('name').text
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  fname = 'people.xml'
  xp = XMLParser.open fname
  xp.read_people
end
