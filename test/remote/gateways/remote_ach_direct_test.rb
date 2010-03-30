require 'test_helper'


######################################################################################################
# NOTE - AchDirect seems to return TEST APPROVAL for just about everything
######################################################################################################
 
class RemoteAchDirectTest < Test::Unit::TestCase
 
  def setup
    Base.mode = :test
    
    @gateway = AchDirectGateway.new(fixtures(:ach_direct))
    @amount = 100
    @credit_card = credit_card('4000100011112224')
    @options = {
      :order_id => generate_unique_id,
      :billing_address => address,
      :email => "joe@example.com",
      :customer => "1234"
    }
  end
  
  def test_bad_login
    gateway = AchDirectGateway.new({
      :login => '',
      :password => ''
    })
    assert response = gateway.purchase(@amount, @credit_card, @options)
    assert_equal 'INVALID MERCH', response.message
    assert_failure response
  end

  def test_successful_purchase
    assert response = @gateway.purchase(@amount, @credit_card, @options)
    assert_success response
    assert response.test?
    assert_equal 'TEST APPROVAL', response.message
    assert response.authorization
  end

  def test_invalid_amount
    assert response = @gateway.purchase(nil, @credit_card, @options)
    assert_equal 'INVALID AMOUNT', response.message
    assert_failure response
  end
  
  # def test_successful_credit
  #   assert response = @gateway.credit(@amount, @credit_card, @options)
  #   assert_success response
  #   assert response.test?
  #   assert_equal 'TEST APPROVAL', response.message
  #   assert response.authorization
  # end
  # 
  # def test_unsuccessful_purchase
  #   assert response = @gateway.purchase(@amount, credit_card('4000300011112220'), @options)
  #   assert_equal 'AUTH DECLINE', response.message
  #   assert_failure response
  # end
  #    
  # def test_authorize_and_capture
  #   assert auth = @gateway.authorize(@amount, @credit_card, @options)
  #   assert_success auth
  #   assert_equal 'TEST APPROVAL', auth.message
  #   assert auth.authorization
  #   assert capture = @gateway.capture(@amount, auth.authorization, @options)
  #   assert_success capture
  # end
   
end