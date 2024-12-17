class OrdersController < ApplicationController
  before_action :authorize_customer_or_admin, only: %i[create]
  before_action :set_order, only: %i[show update destroy]
  before_action :authorize_order_access, only: %i[show update destroy]
  before_action :check_ability_to_change_order, only: %i[update destroy]

  # GET /orders
  def index
    render_response(model_name: 'Order', data: fetch_orders, message: I18n.t('orders.orders_fetched_successfully'))
  end

  # GET /orders/:id
  def show
    render_response(model_name: 'Order', data: @order, message: I18n.t('orders.order_fetched_successfully'))
  end

  # POST /orders
  def create
    @order = @current_user.admin? ? Order.new(order_params) : @current_user.orders.build(order_params)
    if @order.save
      create_order_products
      render_response(model_name: 'Order', data: @order, message: I18n.t('orders.order_created_successfully'), status: :created)
    else
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
    render_response(message: I18n.t('orders.order_deleted_successfully'))
  rescue ActiveRecord::RecordNotDestroyed => e
    handle_error(e, I18n.t('orders.failed_to_delete_order'))
  end

  private

  def fetch_orders
    orders = if @current_user.admin?
                Order
              elsif @current_user.deliverer?
                @current_user.deliveries
              else
                @current_user.orders
              end
    paginate(orders.includes(:order_products))
  end

  def set_order
    @order = Order.includes(:order_products).find(params[:id])
  end

  def authorize_order_access
    return if @current_user.admin? || @order.customer_id == @current_user.id || @order.deliverer_id == @current_user.id
    render_response(message: I18n.t('errors.unauthorized_order_access'), status: :forbidden)
  end

  def check_ability_to_change_order
    return if @current_user.admin? || @order.deliverer_id.blank?
    render_response(message: I18n.t('errors.unauthorized_order_access'), status: :forbidden)    
  end

  def order_params
    params.require(:order).permit(:latitude, :longitude, :address, :country_id, :total_price, :deliverer_id, :customer_id, :delivery_time, order_products_attributes: [:product_id, :quantity, :include_iron])
  end

  def create_order_products
    return unless params[:order][:order_products_attributes].present?
    
    params[:order][:order_products_attributes].each do |order_product_params|
      order_product = @order.order_products.find_or_initialize_by(product_id: order_product_params[:product_id])      
      order_product.assign_attributes(order_product_params.slice(:quantity, :include_iron).compact)
      order_product.save!
    end
  end
  
end
