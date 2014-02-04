require 'test_helper'

# NOTE: 10 lists are defined with fixtures, 5 per user
class ListsControllerTest < ActionController::TestCase

  # FIXME: In some reason `rake test` command does not setup
  #   controller sometimes
  def setup
    @controller = Api::ListsController.new
    setup_token
  end

  test 'should respond with lists' do
    get(:index, { access_token: @token })
    assert_response(:success, 'response is not successful')
    assert_not_nil(assigns(:lists), '@lists is not assigned')
    assert_equal(5, assigns(:lists).size, '@lists size is not 5')

    get(:index, { access_token: @token, page: 1, per_page: 3 })
    assert_response(:success, 'response is not successful')
    assert_not_nil(assigns(:lists), '@lists is not assigned')
    assert_equal(2, assigns(:lists).size, '@lists size is not 2')

    get(:index, { access_token: @token, page: 1, per_page: 20 })
    assert_response(:success, 'response is not successful')
    assert_not_nil(assigns(:lists), '@lists is not assigned')
    assert_equal(0, assigns(:lists).size, '@lists size is not 0')
  end

  test 'should create list' do
    list = default_list

    post(:create, { access_token: @token, list: list })
    response_and_model_test(list, 'list', false, 'success')
  end

  test 'should create list and assign items' do
    list = default_list
    list.merge!({ item_ids: [ items(:item_4).id,
                               items(:item_7).id ] })

    post(:create, { list: list, access_token: @token })
    response_and_model_test(list, 'list', false, 'success')
  end

  test 'should not create list' do
    list = default_list
    list.delete(:name)

    post(:create, { list: list, access_token: @token })
    response_and_model_test(list, 'list', false, 'error')
  end

  test 'should not create list and associations' do
    list = default_list
    list.delete(:name)
    list.merge!({ item_ids: [ items(:item_70).id,
                               items(:item_3).id ] })

    post(:create, { list: list, access_token: @token })
    response_and_model_test(list, 'list', false, 'error')
  end

  test 'should create list and return existing list on show action' do
    list = default_list

    post(:create, { list: list, access_token: @token })
    response_and_model_test(list, 'list', false, 'success')

    list_id = JSON.parse(@response.body)['id']
    get(:show, { id: list_id, access_token: @token })
    response_and_model_test(list, 'list', false, 'success')
  end

  test 'should create and update the list' do
    list = default_list

    post(:create, { list: list, access_token: @token })
    response_and_model_test(list, 'list', false, 'success')

    list_id = JSON.parse(@response.body)['id']
    list[:name] = 'New name of the list'

    patch(:update, { id: list_id, list: list, access_token: @token })
    response_and_model_test(list, 'list', false, 'success')
  end

  test 'should create list and its associations and then update them' do
    list = default_list
    list.merge!({ item_ids: [ items(:item_0).id,
                              items(:item_3).id ] })

    post(:create, { list: list, access_token: @token })
    response_and_model_test(list, 'list', false, 'success')

    list_id = JSON.parse(@response.body)['id']
    list[:name] = 'Name was changed'
    list[:item_ids] << items(:item_8).id

    patch(:update, { id: list_id, list: list, access_token: @token })
    response_and_model_test(list, 'list', false, 'success')
  end

  test 'should create but not update the list' do
    list = default_list

    post(:create, { list: list, access_token: @token })
    response_and_model_test(list, 'list', false, 'success')

    list_id = JSON.parse(@response.body)['id']
    list[:name] = nil

    patch(:update, { id: list_id, list: list, access_token: @token })
    response_and_model_test(list, 'list', false, 'error')
  end

  test 'should create and destroy the list' do
    list = default_list

    post(:create, { list: list, access_token: @token })
    response_and_model_test(list, 'list', false, 'success')

    list_id = JSON.parse(@response.body)['id']

    delete(:destroy, { id: list_id, access_token: @token })
    response_and_model_test(list, 'list', true, 'success')
  end

  test 'should share list' do
    list_id = users(:one).lists.first.id

    post(:share,
         { access_token:
           @token, id: list_id,
           recipients: 'test@wyshme.com' })
    response_and_model_test({ content_type: 'List',
                              content_id: list_id,
                              recipients: 'test@wyshme.com' },
                            'content_share', false, 'success')
  end

  def default_list
    {
      name: 'Newest list',
      description: 'My cool new list!',
      event: 'Happy day',
      event_at: '3000-01-01'
    }
  end

end
