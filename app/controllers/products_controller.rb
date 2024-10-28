class ProductsController < ApplicationController
  before_action :set_product, only: %i[show update destroy]
  before_action :authorize_admin, only: %i[create update destroy]

  # GET /products
  def index
    products = paginate(Product.all)
    render_response(model_name: 'Product', data: products, message: I18n.t('products.products_fetched_successfully'))
  end

  # GET /products/:id
  def show
    render_response(model_name: 'Product', data: @product, message: I18n.t('products.product_fetched_successfully'))
  end

  # POST /products
  def create
    product = Product.create!(product_params)
    render_response(model_name: 'Product', data: product, message: I18n.t('products.product_created_successfully'), status: :created)
  rescue ActiveRecord::RecordInvalid => e
    handle_error(e, I18n.t('products.failed_to_create_product'))
  end

  # PATCH/PUT /products/:id
  def update
    @product.update!(product_params)
    render_response(model_name: 'Product', data: @product, message: I18n.t('products.product_updated_successfully'))
  rescue ActiveRecord::RecordInvalid => e
    handle_error(e, I18n.t('products.failed_to_update_product'))
  end

  # DELETE /products/:id
  def destroy
    @product.destroy!
    render_response(message: I18n.t('products.product_deleted_successfully'), status: :no_content)
  rescue ActiveRecord::RecordNotDestroyed => e
    handle_error(e, I18n.t('products.failed_to_delete_product'))
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :price, :iron_price, :discount, :photo)
  end
end
