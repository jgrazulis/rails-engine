class Api::V1::MerchantSearchController < ApplicationController
  before_action :parameters

  def find
    if @merchant.nil?
      render json: { data: {}, status: :ok}
    else
      render json: MerchantSerializer.new(@merchant)
    end
  end

  private

  def parameters
    if params[:name] == nil
      render json: { data: {} }, status: :bad_request
    elsif params[:name] == ""
      render json: {  data: {} }, status: :bad_request
    elsif params[:name].class == String && params[:name].length > 0
      @merchant = Merchant.search(params[:name]).first
    end
  end
end