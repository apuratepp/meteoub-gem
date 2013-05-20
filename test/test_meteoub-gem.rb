require 'helper'

class TestMeteoubGem < Test::Unit::TestCase
  # should "probably rename this file and start testing for real" do
  #   flunk "hey buddy, you should probably rename this file and start testing for real"
  # end

  context "Gettings temperature" do
  	should "get float temperature" do
  	  dades = MeteoUB::Data.new
  	  assert_operator(dades.temperature, :>, -10.0)
	end
	should "" do
	  dades = MeteoUB::Data.new
  	  assert_operator(dades.temperature, :<, 50.0)
	end
  end
end
