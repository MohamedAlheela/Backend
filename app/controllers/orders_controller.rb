class OrdersController < ApplicationController
  before_action :authorize_customer_or_admin
  before_action :set_order, only: %i[show update destroy]
  before_action :authorize_order_access, only: %i[show update destroy]
  before_action :check_ability_to_change_order, only: %i[update destroy]

  # GET /orders
  def index
    orders =  if @current_user.admin?
                paginate(Order.all.includes(:order_products))
              else
                paginate(@current_user.orders.includes(:order_products))
              end

    render_response(model_name: 'Order', data: orders, message: I18n.t('orders.orders_fetched_successfully'))
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
    render_response(message: I18n.t('orders.order_deleted_successfully'))
  rescue ActiveRecord::RecordNotDestroyed => e
    handle_error(e, I18n.t('orders.failed_to_delete_order'))
  end

  private

  def set_order
    @order = Order.includes(:order_products).find(params[:id])
  end

  def authorize_order_access
    return if @current_user.admin?

    if @order.customer_id != @current_user.id      
      render_response(message: I18n.t('errors.unauthorized_order_access'), status: :forbidden)
    end
  end

  def check_ability_to_change_order
    return if @current_user.admin?

    if @order.deliverer_id.present?
      render_response(message: I18n.t('errors.unauthorized_order_access'), status: :forbidden)
    end
  end

  def order_params
    params.require(:order).permit(:latitude, :longitude, :address, :country_id, :total_price, :deliverer_id, :customer_id, :delivery_time, order_products_attributes: [:product_id, :quantity, :include_iron])
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
