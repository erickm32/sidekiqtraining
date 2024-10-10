require 'rails_helper'

RSpec.describe "Categories", type: :request do
  describe "GET /api/categories" do
    context 'when there are categories' do
      before do
        5.times { create(:category) }
      end

      it 'returns all the categories in json' do
        get api_categories_path
        expect(JSON.parse(response.body)).to eq(Category.all.as_json)
      end
    end
    context 'when there are no categories' do
      it 'returns something' do
        get api_categories_path
        expect(JSON.parse(response.body)).to eq([])
      end
    end
  end
  describe "GET /api/categories/:id" do
  end
  # describe "GET /index/new" do
  # end
  # describe "GET /index/edit" do
  # end
  describe "POST /api/categories" do
    context 'with correct params' do
      it 'creates a new category' do
        expect do
          post api_categories_path, params: { category: { name: 'New Category' } }
        end.to change(Category, :count).by(1)
        expect(JSON.parse(response.body)).to eq(Category.last.as_json)
      end
    end

    context 'without correct params' do
      it 'returns an array with the errors' do
        expect do
          post api_categories_path, params: { category: { name: nil } }
        end.to change(Category, :count).by(0)
        expect(JSON.parse(response.body)).to eq('name' => [ "can't be blank" ])
      end
    end
  end
  describe "PATCH /api/categories/:id" do
  end
  describe "PUT /api/categories/:id" do
  end
  describe "DELETE /api/categories/:id" do
  end
end
