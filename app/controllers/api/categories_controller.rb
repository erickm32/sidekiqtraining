class Api::CategoriesController < Api::BaseController
  def index
    render json: Category.all
  end

  def show
    render json: Category.find(params["id"])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  def create
    category = Category.new(category_params)
    if category.save
      render json: category
    else
      render json: category.errors, status: :unprocessable_entity
    end
  end

  def update
    category = Category.find(params["id"])
    if category.update(category_params)
      render json: category
    else
      render json: category.errors, status: :unprocessable_entity
    end
  end

  def destroy
    category = Category.find(params["id"])
    if category.destroy
      render json: category
    else
      render json: category.errors, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  private

  def category_params
    params.fetch(:category, {}).permit(Category.permitted_attributes)
  end
end
