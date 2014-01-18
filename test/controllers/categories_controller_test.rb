require 'test_helper'

# NOTE: 15 categories are created with fixtures
class CategoriesControllerTest < ActionController::TestCase

  # FIXME: In some reason `rake test` command does not setup
  #   controller sometimes
  def setup
    @controller = Api::CategoriesController.new
    setup_token
  end

  test "should return categories" do
    get(:index, { access_token: @token })
    assert_response(:success, 'Response is not successfull')
    assert_not_nil(assigns(:categories), '@categories is not assigned')
    assert_equal(10, assigns(:categories).size, '@categories size is not equal to 10')

    get(:index, { access_token: @token, page: 1, per_page: 11 })
    assert_response(:success, 'response is not successful')
    assert_not_nil(assigns(:categories), '@categories is not assigned')
    assert_equal(4, assigns(:categories).size, '@categories size is not 4')

    get(:index, { access_token: @token, page: 2, per_page: 10 })
    assert_response(:success, 'response is not successful')
    assert_not_nil(assigns(:categories), '@categories is not assigned')
    assert_equal(0, assigns(:categories).size, '@categories size is not 0')
  end

  test 'should create category' do
    category = default_category

    post(:create, { access_token: @token, category: category })
    response_and_model_test(category, 'category', false, 'success')
  end

  test 'should not create category' do
    category = default_category
    category.delete(:name)

    post(:create, { access_token: @token, category: category })
    response_and_model_test(category, 'category', false, 'error')
  end

  test 'should create category and return existing category on show action' do
    category = default_category

    post(:create, { access_token: @token, category: category })
    response_and_model_test(category, 'category', false, 'success')

    category_id = JSON.parse(@response.body)['id']
    get(:show, { id: category_id, access_token: @token })
    response_and_model_test(category, 'category', false, 'success')
  end

  test 'should create and update the category' do
    category = default_category

    post(:create, { access_token: @token, category: category })
    response_and_model_test(category, 'category', false, 'success')

    category_id = JSON.parse(@response.body)['id']
    category[:name] = 'New name of the category'

    patch(:update, { id: category_id, access_token: @token,  category: category })
    response_and_model_test(category, 'category', false, 'success')
  end

  test 'should create but not update the category' do
    category = default_category

    post(:create, { access_token: @token, category: category })
    response_and_model_test(category, 'category', false, 'success')

    category_id = JSON.parse(@response.body)['id']
    category[:name] = nil

    patch(:update, { access_token: @token, id: category_id, category: category })
    response_and_model_test(category, 'category', false, 'error')
  end

  test 'should create and destroy the category' do
    category = default_category

    post(:create, { category: category, access_token: @token })
    response_and_model_test(category, 'category', false, 'success')

    category_id = JSON.parse(@response.body)['id']

    delete(:destroy, { id: category_id, access_token: @token })
    response_and_model_test(category, 'category', true, 'success')
  end

  test "should return featured items for category" do
    get(:featured_items, {id: categories(:category_5).id})
    assert_response(:success, 'Response is not successfull')
    assert_not_nil(assigns(:items), '@items is not assigned')
    assert_equal(5, assigns(:items).size, '@items size is not equal to 5')
  end

  test "should return first 10 featured items for all categories" do
    get(:all_featured_items)
    assert_response(:success, 'Response is not successfull')
    assert_not_nil(assigns(:items), '@items is not assigned')
    assert_equal(10, assigns(:items).size, '@items size is not equal to 10')
  end

  def default_category
    { name: 'New category, really', description: 'Only awesome things here!' }
  end

end
