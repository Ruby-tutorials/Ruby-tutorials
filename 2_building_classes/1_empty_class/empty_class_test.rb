require 'minitest/autorun'
require_relative 'empty_class'

class EmptyClassTest < MiniTest::Test
  def test_person
    person = Person.new
    assert_equal Person, person.class
  end
end
