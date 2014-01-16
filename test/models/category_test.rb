require 'test_helper'

class CategoryTest < ActiveSupport::TestCase

  test 'should create category' do
    cat_name = 'Test category'
    cat = Category.new(name: cat_name)
    assert(cat.save, 'Category is not saved')
    assert_equal(cat_name, cat.name, 'Passed and actual names are not equal')

    cat_name = 'Test category 2'
    cat_desc = 'This is very test item, please ignore'
    cat = Category.new(name: cat_name, description: cat_desc)
    assert(cat.save, 'Category is not saved')
    assert_equal(cat_name, cat.name, 'Passed and actual names are not equal')
    assert_equal(cat_desc, cat.description,
                 'Passed and actual descriptions are not equal')
  end

  test 'should not create category' do
    cat = Category.new
    assert_not(cat.save, 'Category without name is saved')

    cat.description = 'Some test description here'
    assert_not(cat.save, 'Category without name with descriptions is saved')
  end

  test 'should create categories and add items to them' do
    cat_name = 'Test category next'
    cat = Category.new(name: cat_name)
    assert(cat.save, 'Category is not saved')
    assert_equal(cat_name, cat.name, 'Passed and actual names are not equal')

    itms = [items(:item_11), items(:item_33)]
    cat.items = itms
    assert(cat.save, 'Category is not saved after adding items')
    assert_equal(itms.size, cat.items.size,
                 'Numbers of assigned and actual items are different')
  end

end
