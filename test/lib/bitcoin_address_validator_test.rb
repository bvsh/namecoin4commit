require 'test_helper'

class BitcoinAddressValidatorTest < MiniTest::Unit::TestCase
  def setup
    @addressValidator = BitcoinAddressValidator.new({:attributes => {}})
  end
  
  def teardown
  end


  def test_validates_proper_namecoin_address
    address = "N3VQL7mZvSNL1WWoiJUnNp9TkpREnY9YhJ"
    assert(@addressValidator.valid_bitcoin_address? address)
  end

  def test test_rejects_bitcoin_address
    address = "N3VQL7mZvSNL1WWoiJUnNp9TkpREnY9YhJ"
    assert(@addressValidator.valid_bitcoin_address? address)
  end

  def test rejects_shorter_address
    address = "NEzXeLvYzfjwWJeUPs5j7kvKqu6QK37kr"
    assert(@addressValidator.valid_bitcoin_address? address)
  end

  def rejects_longer_address
    address = "NEzXeLvYzfjwWJeUPs5j7kvKqu6QK37krkk"
    assert(@addressValidator.valid_bitcoin_address? address)
  end

end
