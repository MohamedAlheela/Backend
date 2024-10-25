class ProductsController < ApplicationController
  before_action :set_product, only: %i[show update destroy]

  # GET /products
  def index
    products = paginate(Product.all)
    render_response(model_name: 'Product', data: products, message: 'Products fetched successfully')
  end

  # GET /products/:id
  def show
    render_response(model_name: 'Product', data: @product, message: 'Product fetched successfully')
  end

  # POST /products
  def create
    product = Product.create!(product_params)
    render_response(model_name: 'Product', data: product, message: 'Product created successfully', status: :created)
  rescue ActiveRecord::RecordInvalid => e
    handle_error(e, 'Failed to create product')
  end

  # PATCH/PUT /products/:id
  def update
    @product.update!(product_params)
    render_response(model_name: 'Product', data: @product, message: 'Product updated successfully')
  rescue ActiveRecord::RecordInvalid => e
    handle_error(e, 'Failed to update product')
  end

  # DELETE /products/:id
  def destroy
    @product.destroy!
    render_response(message: 'Product deleted successfully', status: :no_content)
  rescue ActiveRecord::RecordNotDestroyed => e
    handle_error(e, 'Failed to delete product')
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :price, :iron_price, :discount)
  end
end
