
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
  def read_people(xpath, block)
    by_xpath(xpath) { |node| block.call node }
  end

  def method_missing(method, *args)
    unless method.to_s.start_with? 'xpath_'
      super
    end
    xpath = to_xpath(method)
    by_xpath(xpath) { |node| args[0].call node }
  end

  private
  def to_xpath(method)
    elms = method.to_s.split('_')
    elms[1..-1].join('/')
  end
end

if __FILE__ == $PROGRAM_NAME
  fname = 'people.xml'
  p = People.open fname

  check = Proc.new do |node|
    puts " - id:#{node.get('id')}, name:#{node.at_xpath('name').text}"
  end

  puts '1. xpath を利用'
  xpath = 'peoples/people/person'
  p.read_people(xpath, check)

  puts '2. メソッド名からxpath を生成してパース'
  xpath = p.xpath_peoples_people_person check
end
