require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:one)
  end

  test "should get index" do
    get orders_url, as: :json
    assert_response :success
  end

  test "should create order" do
    assert_difference("Order.count") do
      post orders_url, params: { order: { address: @order.address, customer_id: @order.customer_id, customer_type: @order.customer_type, deliverer_id: @order.deliverer_id, deliverer_type: @order.deliverer_type, delivery_time: @order.delivery_time, latitude: @order.latitude, longitude: @order.longitude, total_price: @order.total_price } }, as: :json
    end

    assert_response :created
  end

  test "should show order" do
    get order_url(@order), as: :json
    assert_response :success
  end

  test "should update order" do
    patch order_url(@order), params: { order: { address: @order.address, customer_id: @order.customer_id, customer_type: @order.customer_type, deliverer_id: @order.deliverer_id, deliverer_type: @order.deliverer_type, delivery_time: @order.delivery_time, latitude: @order.latitude, longitude: @order.longitude, total_price: @order.total_price } }, as: :json
    assert_response :success
  end

  test "should destroy order" do
    assert_difference("Order.count", -1) do
      delete order_url(@order), as: :json
    end

    assert_response :no_content
  end
end
