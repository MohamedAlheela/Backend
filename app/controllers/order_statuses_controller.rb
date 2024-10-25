class OrderStatusesController < ApplicationController
  before_action :set_order_status, only: %i[show update destroy]

  # GET /order_statuses
  def index
    order_statuses = paginate(OrderStatus.all)
    render_response(model_name: 'OrderStatus', data: order_statuses, message: 'Order statuses fetched successfully')
  end

  # GET /order_statuses/:id
  def show
    render_response(model_name: 'OrderStatus', data: @order_status, message: 'Order status fetched successfully')
  end

  # POST /order_statuses
  def create
    order_status = OrderStatus.create!(order_status_params)
    render_response(model_name: 'OrderStatus', data: order_status, message: 'Order status created successfully', status: :created)
  rescue ActiveRecord::RecordInvalid => e
    handle_error(e, 'Failed to create order status')
  end

  # PATCH/PUT /order_statuses/:id
  def update
    @order_status.update!(order_status_params)
    render_response(model_name: 'OrderStatus', data: @order_status, message: 'Order status updated successfully')
  rescue ActiveRecord::RecordInvalid => e
    handle_error(e, 'Failed to update order status')
  end

  # DELETE /order_statuses/:id
  def destroy
    @order_status.destroy!
    render_response(message: 'Order status deleted successfully', status: :no_content)
  rescue ActiveRecord::RecordNotDestroyed => e
    handle_error(e, 'Failed to delete order status')
  end

  private

  # Set the order status for show, update, and destroy actions
  def set_order_status
    @order_status = OrderStatus.find(params[:id])
  end

  # Define allowed parameters for creating or updating an order status
  def order_status_params
    params.require(:order_status).permit(:order_id, :time, :note, :name)
  end
end
