class ProductsController < ApplicationController
  before_action :find_product, :only => [:show, :edit, :update, :destroy]
  layout 'page'

  def index
    if params[:limit]
      @products = Product.order(:product_name).page(params[:page]).per(params[:limit])
    else
      @products = Product.order(:product_name).page(params[:page])
    end
  end

  def new
    @product = Product.new
  end

  def show
  end

  def create
    if current_user.admin?
      @product = Product.new(product_params)
      if @product.save
        redirect_to products_path, notice: "Successfully created product."
      else
        render :new
      end
    else
      redirect_to products_path, alert: "You do not have permission."
    end
  end

  def edit
  end

  def update
    if current_user.admin?
      if @product.update_attributes(product_params)
        redirect_to product_path(id: @product.id), notice: "Successfully updated product."
      else
        render :edit
      end
    else
      redirect_to products_path, alert: "You do not have permission."
    end
  end

  def destroy
    if current_user.admin?
      @product.destroy

      redirect_to products_path, notice: "Successfully deleted product."
    else
      redirect_to products_path, alert: "You do not have permission."
    end
  end

  private
  def find_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :product_name,
      :description,
      :code,
      :base_price,
      :length_price,
      :product_line_id,
      product_line_attributes: [
        :id,
        :product_line],
      recipient_ids: [],
      recipient_attributes: [
        :id,
        :recipient_name]
        )
  end

end