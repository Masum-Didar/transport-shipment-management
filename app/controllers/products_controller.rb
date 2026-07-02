class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @products = policy_scope(Product).kept.order(:name)
    @products = @products.where(product_category_id: params[:category_id]) if params[:category_id].present?
    @products = @products.ransack(name_cont: params[:q]).result if params[:q].present?
  end

  def show; end

  def new
    @product = Product.new
    authorize @product
  end

  def create
    @product = Product.new(product_params)
    authorize @product
    if @product.save
      redirect_to @product, notice: "Product added successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: "Product updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.discard!
    redirect_to products_path, notice: "Product removed successfully."
  end

  private

  def set_product
    @product = Product.kept.find(params[:id])
    authorize @product
  end

  def product_params
    params.require(:product).permit(:name, :product_category_id, :default_unit, :description)
  end
end
