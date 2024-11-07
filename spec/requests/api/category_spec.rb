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
    context 'when there is a category with the id' do
      let(:category) { create(:category) }

      it 'returns the category as json' do
        get api_category_path(category)
        expect(JSON.parse(response.body)).to eq(category.as_json)
      end
    end

    context 'when the category id is invalid' do
      it 'returns an error' do
        get api_category_path(999)
        expect(JSON.parse(response.body)).to eq({ "error"=>"Couldn't find Category with 'id'=999" })
        expect(response.status).to eq(404)
      end
    end
  end

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
    context 'with valid params' do
      let(:category) { create(:category) }

      it 'updates the record' do
        patch api_category_path(category.id), params: { category: category_params.merge({ name: 'new name' }) }
        expect(response.status).to eq(200)
        category.reload
        expect(category.name).to eq('new name')
      end
    end

    context 'with invalid params' do
      let(:category) { create(:category) }

      it 'fails to update the record' do
        patch api_category_path(category.id), params: { category: category_params.merge({ name: '' }) }
        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)).to eq({ "name"=>[ "can't be blank" ] })
        category.reload
        expect(category.name).not_to eq('new name')
      end
    end
  end

  describe "PUT /api/categories/:id" do
    context 'with valid params' do
      let(:category) { create(:category) }

      it 'updates the record' do
        put api_category_path(category.id), params: { category: { name: 'new name' } }
        expect(response.status).to eq(200)
        category.reload
        expect(category.name).to eq('new name')
      end
    end

    context 'with invalid params' do
      let(:category) { create(:category) }

      it 'fails to update the record' do
        put api_category_path(category.id), params: { category: { name: '' } }
        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)).to eq({ "name"=>[ "can't be blank" ] })
        category.reload
        expect(category.name).not_to eq('new name')
      end
    end
  end

  describe "DELETE /api/categories/:id" do
    context 'with correct params' do
      let!(:category) { create(:category) }

      it 'deletes successfully' do
        expect do
          delete api_category_path(category.id)
        end.to change(Category, :count).by(-1)
        expect(JSON.parse(response.body)).to eq(category.as_json)
      end
    end

    context 'with invalid params' do
      it 'raise an error' do
        delete api_category_path(999)
        expect(JSON.parse(response.body)).to eq({ "error"=>"Couldn't find Category with 'id'=999" })
        expect(response.status).to eq(404)
      end
    end
  end

  def category_params
    {
      name: 'Name'
    }
  end
end
