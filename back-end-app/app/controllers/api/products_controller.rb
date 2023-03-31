class Api::ProductsController < ApplicationController
  before_action :load_data

  # GET /api
  def index
    render json: @data.to_json
  end

   # GET /users/:id
  # expand this action to determine the user type - if project manager or developer
  # filter through JSON and return those that meet the query param name
  def show
    product = @data.find { |u| u["productId"] == params[:id].to_i }
    if product
      render json: product.to_json
    else
      render json: { error: "product not found" }, status: :not_found
    end
  end

  # POST /api
  def create
    if request_values_missing?
      errors = Hash("missing_values" => missing_values)
      render json: errors.to_json, status: :unprocessable_entity
    else
      product = {
        productId: @data.last["productId"] + 1,
        productName: params[:productName],
        productOwnername: params[:productOwnerName],
        Developers: params[:Developers],
        scrumMasterName: params[:scrumMasterName],
        startDate: params[:startDate],
        methodology: params[:methodology]
      }
      
      @data << product
      save_data
      render json: product.to_json, status: :created
    end
  end

  # PUT /api/products/:id
  def update
    product = @data.find { |u| u["productId"] == params[:id].to_i }
    
    if product
      product["productName"] = params[:productName] if params[:productName]
      product["productOwnername"] = params[:productOwnerName] if params[:productOwnerName]
      product["Developers"] = params[:Developers] if params[:Developers]
      product["scrumMasterName"] = params[:scrumMasterName] if params[:scrumMasterName]
      product["startDate"] = params[:startDate] if params[:startDate]
      product["methodology"] = params[:methodology] if params[:methodology]

      save_data
      render json: product.to_json
    else
      render json: { error: "Product not found" }, status: :not_found
    end
  end

  private

  def load_data
    @data = JSON.parse(File.read(Rails.root.join("app/data.json")))
  end

  def save_data
    File.write(Rails.root.join("app/data.json"), JSON.pretty_generate(@data))
  end

  def request_values_missing?
    params.values.any? { |value| value.empty? }
  end

  def missing_values
    error_keys = []
    params.each_key { |key| error_keys << key if params[key].empty? }
    error_keys
  end
end
