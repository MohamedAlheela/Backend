class OrderStatusesController < ApplicationController
  before_action :authorize_admin, only: %i[create update destroy]
  before_action :authorize_customer_or_admin, only: %i[index show]
  before_action :set_order_status, only: %i[show update destroy]
  before_action :authorize_order_status_access, only: %i[show]

  # GET /order_statuses
  def index
    order_statuses = paginate(OrderStatus.all)
    render_response(model_name: 'OrderStatus', data: order_statuses, message: I18n.t('orders.order_statuses_fetched_successfully'))
  end

  # GET /order_statuses/:id
  def show
    render_response(model_name: 'OrderStatus', data: @order_status, message: I18n.t('orders.order_status_fetched_successfully'))
  end

  # POST /order_statuses
  def create
    order_status = OrderStatus.create!(order_status_params)
    render_response(model_name: 'OrderStatus', data: order_status, message: I18n.t('orders.order_status_craeted_successfully'), status: :created)
  rescue ActiveRecord::RecordInvalid => e
    handle_error(e, I18n.t('orders.failed_to_create_order_status'))
  end

  # PATCH/PUT /order_statuses/:id
  def update
    @order_status.update!(order_status_params)
    render_response(model_name: 'OrderStatus', data: @order_status, message: I18n.t('orders.order_status_updated_successfully'))
  rescue ActiveRecord::RecordInvalid => e
    handle_error(e, I18n.t('orders.failed_to_update_order_status'))
  end

  # DELETE /order_statuses/:id
  def destroy
    @order_status.destroy!
    render_response(message:  I18n.t('orders.order_status_deleted_successfully'))
  rescue ActiveRecord::RecordNotDestroyed => e
    handle_error(e, I18n.t('orders.failed_to_delete_order_status'))
  end

  private

  # Set the order status for show, update, and destroy actions
  def set_order_status
    @order_status = OrderStatus.find(params[:id])
  end

  def authorize_order_status_access
    return if @current_user.admin?

    if @order_status.order.user_id != @current_user.id
      render_response(message: I18n.t('orders.unauthorized_order_status_access'), status: :forbidden)
    end
  end      

  # Define allowed parameters for creating or updating an order status
  def order_status_params
    params.require(:order_status).permit(:order_id, :time, :note, :name)
  end
end
