#ruby vendor/plugins/active_merchant/test/unit/gateways/ach_direct_test.rb
 
require 'test_helper'
 
class AchDirectTest < Test::Unit::TestCase
  def setup
    @gateway = AchDirectGateway.new(
      :login => 'X',
      :password => 'Y'
    )
    @amount = 100
    @credit_card = credit_card
  end
  
  def test_successful_purchase
    @gateway.expects(:ssl_post).returns(successful_purchase_response)
  
    assert response = @gateway.purchase(@amount, @credit_card)
    assert_instance_of Response, response
    assert_success response
    assert_equal '123456', response.authorization
  end

  def test_failed_purchase
    @gateway.expects(:ssl_post).returns(failed_purchase_response)
  
    assert response = @gateway.authorize(@amount, @credit_card)
    assert_instance_of Response, response
    assert_failure response
    assert_equal nil, response.authorization
  end

  def test_failed_credit
    @gateway.expects(:ssl_post).returns(failed_purchase_response)
  
    assert response = @gateway.credit(@amount, @credit_card)
    assert_instance_of Response, response
    assert_failure response
    assert_equal nil, response.authorization
  end

  def test_successful_credit
    @gateway.expects(:ssl_post).returns(successful_purchase_response)
  
    assert response = @gateway.credit(@amount, @credit_card)
    assert_instance_of Response, response
    assert_success response
    assert_equal "123456", response.authorization
  end
  
  
  def successful_purchase_response
    <<-EOD
pg_response_type=A
pg_response_code=A01
pg_response_description=TEST APPROVAL
pg_authorization_code=123456
pg_trace_number=37CA2D62-B90F-49F0-B07C-2BA87F625AE3
pg_avs_result=00000
ecom_billto_online_email=joe@example.com
pg_transaction_type=10
ecom_consumerorderid=59a9beafc91c37cc94f3e8d47c1def8b
pg_consumer_id=1234
pg_total_amount=1.00
pg_merchant_id=116778
pg_billto_postal_name_company=Widgets Inc
endofdata
    EOD
  end
  
  def failed_purchase_response
    <<-EOD
pg_response_type=D
pg_response_code=U83
pg_response_description=INVALID CARD
pg_trace_number=CC7EFCE8-FA93-428E-BDBD-BA2CE538CEE2
pg_avs_result=00000
ecom_billto_online_email=joe@example.com
pg_transaction_type=10
ecom_consumerorderid=a2215582023df802082a4414e660f113
pg_consumer_id=1234
pg_total_amount=1.00
pg_merchant_id=116778
pg_billto_postal_name_company=Widgets Inc
endofdata
EOD
  end
  
end