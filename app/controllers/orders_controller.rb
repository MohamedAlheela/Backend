class OrdersController < ApplicationController
  before_action :set_order, only: %i[show update destroy]

  # GET /orders
  def index
    orders = paginate(Order.all.includes(:order_products))
    render_response(model_name: 'Order', data: orders, message: 'Orders fetched successfully')
  end

  # GET /orders/:id
  def show
    render_response(model_name: 'Order', data: @order, message: 'Order fetched successfully')
  end

  # POST /orders
  def create
    @order = Order.new(order_params)
    if @order.save
      create_order_products
      render_response(model_name: 'Order', data: @order, message: 'Order created successfully', status: :created)
    else
      handle_error(@order.errors, 'Failed to create order')
    end
  end

  # PATCH/PUT /orders/:id
  def update
    if @order.update(order_params)
      create_order_products
      render_response(model_name: 'Order', data: @order, message: 'Order updated successfully')
    else
      handle_error(@order.errors, 'Failed to update order')
    end
  end

  # DELETE /orders/:id
  def destroy
    @order.destroy!
    render_response(message: 'Order deleted successfully', status: :no_content)
  rescue ActiveRecord::RecordNotDestroyed => e
    handle_error(e, 'Failed to delete order')
  end

  private

  def set_order
    @order = Order.includes(:order_products).find(params[:id])
  end

  def order_params
    params.require(:order).permit(:latitude, :longitude, :address, :total_price, :deliverer_id, :customer_id, :delivery_time, order_products_attributes: [:product_id, :quantity, :include_iron])
  end

  def create_order_products
    # Assuming order_products are nested within the order parameters
    return unless params[:order][:order_products_attributes].present?
    
    params[:order][:order_products_attributes].each do |order_product_params|
      @order.order_products.create!(order_product_params.permit(:product_id, :quantity, :include_iron))
    end
  end
end
