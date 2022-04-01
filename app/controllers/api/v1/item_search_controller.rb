class Api::V1::ItemSearchController < ApplicationController
  
  def find_all
    if params[:name].present? && (params[:min_price].present? || params[:max_price].present?)
      render status: 404
    elsif params[:min_price].present? && params[:max_price].present?
      items = Item.range_search(params[:min_price], params[:max_price])
      validate_items(items)
    elsif params[:min_price].present?
      items = Item.min_price_search(params[:min_price])
      validate_items(items)
    elsif params[:max_price].present?
      items = Item.max_price_search(params[:max_price])
      validate_items(items)
    elsif params[:name].present?
      items = Item.name_search(params[:name])
      validate_items(items)
    end
  end
  
  private

  def validate_items(items)
    if items.empty?
      render json: {data: []}
    else
      render json: ItemSerializer.new(items)
    end
  end
end