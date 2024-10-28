class OrdersController < ApplicationController
  before_action :set_order, only: %i[show update destroy]

  # GET /orders
  def index
    orders = paginate(Order.all.includes(:order_products))
    render_response(model_name: 'Order', data: orders, message: I18n.t('orders.orders_fetched_successfully'))
  end

  # GET /orders/:id
  def show
    render_response(model_name: 'Order', data: @order, message: I18n.t('orders.order_fetched_successfully'))
  end

  # POST /orders
  def create
    @order = Order.new(order_params)
    if @order.save
      create_order_products
      render_response(model_name: 'Order', data: @order, message: I18n.t('orders.order_created_successfully'), status: :created)
    else
      # handle_error(@order.errors, I18n.t('orders.failed_to_create_order'))
      render_response_helper(message: @order.errors, status: :unprocessable_entity)
    end
  end

  # PATCH/PUT /orders/:id
  def update
    if @order.update(order_params)
      create_order_products
      render_response(model_name: 'Order', data: @order, message: I18n.t('orders.order_updated_successfully'))
    else
      handle_error(@order.errors, I18n.t('orders.failed_to_update_order'))
    end
  end

  # DELETE /orders/:id
  def destroy
    @order.destroy!
    render_response(message: I18n.t('orders.order_deleted_successfully'), status: :no_content)
  rescue ActiveRecord::RecordNotDestroyed => e
    handle_error(e, I18n.t('orders.failed_to_delete_order'))
  end

  private

  def set_order
    @order = Order.includes(:order_products).find(params[:id])
  end

  def order_params
    params.require(:order).permit(:latitude, :longitude, :address, :total_price, :deliverer_id, :customer_id, :delivery_time, order_products_attributes: [:product_id, :quantity, :include_iron])
  end

  # def create_order_products
  #   # Assuming order_products are nested within the order parameters
  #   return unless params[:order][:order_products_attributes].present?
    
  #   params[:order][:order_products_attributes].each do |order_product_params|
  #     @order.order_products.create!(order_product_params.permit(:product_id, :quantity, :include_iron))
  #   end
  # end

  def create_order_products
    return unless params[:order][:order_products_attributes].present?
    
    params[:order][:order_products_attributes].each do |order_product_params|
      existing_order_product = @order.order_products.find_by(product_id: order_product_params[:product_id])
      if existing_order_product
        # If the product already exists, update the quantity instead of creating a new record
        existing_order_product.update(quantity: existing_order_product.quantity + order_product_params[:quantity].to_i)
      else
        # Create a new OrderProduct if it doesn't exist
        @order.order_products.create!(order_product_params.permit(:product_id, :quantity, :include_iron))
      end
    end
  end
  
end
