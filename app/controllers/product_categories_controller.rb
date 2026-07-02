class ProductCategoriesController < ApplicationController
  before_action :set_category, only: %i[edit update destroy]

  def index
    @categories = policy_scope(ProductCategory).kept.order(:name)
  end

  def new
    @category = ProductCategory.new
    authorize @category
  end

  def create
    @category = ProductCategory.new(category_params)
    authorize @category
    if @category.save
      redirect_to product_categories_path, notice: "Category added successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @category.update(category_params)
      redirect_to product_categories_path, notice: "Category updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.discard!
    redirect_to product_categories_path, notice: "Category removed successfully."
  end

  private

  def set_category
    @category = ProductCategory.kept.find(params[:id])
    authorize @category
  end

  def category_params
    params.require(:product_category).permit(:name, :description)
  end
end
