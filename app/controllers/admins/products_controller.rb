class Admins::ProductsController < Admins::ApplicationController
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @products = Product.order_by_oldest
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admins_products_path, notice: t('common.controller.create.success', model: Product.model_name.human)
    else
      flash.now[:alert] = t('common.controller.create.failed', model: Product.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to admins_products_path, notice: t('common.controller.update.success', model: Product.model_name.human)
    else
      flash.now[:alert] = t('common.controller.update.failed', model: Product.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy!
    redirect_to admins_products_path, notice: t('common.controller.destroy.success', model: Product.model_name.human)
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :image, :display, :position)
  end
end
