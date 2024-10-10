class Api::CategoriesController < Api::BaseController
  def index
    render json: Category.all
  end

  def show
  end

  def create
    category = Category.new(category_params)
    if category.save
      render json: category
    else
      render json: category.errors, status: :unprocessable_entity
    end
  end

  private

  def category_params
    params.fetch(:category, {}).permit(Category.permitted_attributes)
  end
end
