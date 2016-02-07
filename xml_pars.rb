
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

  private
  def by_xpath(xpath)
    xdoc.xpath(xpath).each do |node|
      yield node
    end
  end
end

class People < XMLParser
  def read_people(xpath)
    by_xpath(xpath) do |node| 
      puts node.get('id')
      puts node.at_xpath('name').text
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  fname = 'people.xml'
  p = People.open fname
  xpath = 'peoples/people/person'
  p.read_node xpath
end
