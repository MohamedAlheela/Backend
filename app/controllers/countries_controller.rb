class CountriesController < ApplicationController
  before_action :set_country, only: %i[show update destroy]
  # before_action :authorize_admin, only: %i[create update destroy]

  # GET /countries
  def index
    countries = paginate(Country.all)
    render_response(model_name: 'Country', data: countries, message: I18n.t('countries.countries_fetched_successfully'))
  end

  # GET /countries/:id
  def show
    render_response(model_name: 'Country', data: @country, message: I18n.t('countries.country_fetched_successfully'))
  end

  # POST /countries
  def create
    country = Country.create!(country_params)
    # render_response(model_name: 'Country', data: country, message: I18n.t('countries.country_created_successfully'), status: :created)
    render_response_helper(data: {"country": country}, message: I18n.t('countries.country_created_successfully'), status: :created)
  rescue ActiveRecord::RecordInvalid => e
    handle_error(e, I18n.t('countries.failed_to_create_country'))
  end

  # PATCH/PUT /countries/:id
  def update
    @country.update!(country_params)
    render_response(model_name: 'Country', data: @country, message: I18n.t('countries.country_updated_successfully'))
  rescue ActiveRecord::RecordInvalid => e
    handle_error(e, I18n.t('countries.failed_to_update_country'))
  end

  # DELETE /countries/:id
  def destroy
    @country.destroy!
    render_response(message: I18n.t('countries.country_deleted_successfully'))
  rescue ActiveRecord::RecordNotDestroyed => e
    handle_error(e, I18n.t('countries.failed_to_delete_country'))
  end

  private

  def set_country
    @country = Country.find(params[:id])
  end

  def country_params
    params.require(:country).permit(:name, :code, :currency)
  end
end
