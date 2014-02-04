require 'test_helper'

class ContentShareTest < ActiveSupport::TestCase

  test 'should create content share' do
    usr = users(:one)
    recipients = 'test1@wyshme.com, test2@wyshme.com'
    cs = usr.content_shares.create(content_type: 'Item',
                                   content_id: items(:item_1).id,
                                   recipients: recipients)

    assert_not_nil cs.id, 'ContentShare is not saved'
    assert_equal 'Item', cs.content_type
    assert_equal recipients, cs.recipients

    cs = usr.content_shares.create(content_type: 'List',
                                   content_id: usr.lists.first.id,
                                   recipients: recipients)

    assert_not_nil cs.id, 'ContentShare is not saved'
    assert_equal 'List', cs.content_type
    assert_equal recipients, cs.recipients

    cs = usr.content_shares.create(content_type: 'Event',
                                   content_id: usr.events.first.id,
                                   recipients: recipients)

    assert_not_nil cs.id, 'ContentShare is not saved'
    assert_equal 'Event', cs.content_type
    assert_equal recipients, cs.recipients
  end

  test 'should not create content share' do
    usr = users(:two)
    recipients = 'test1@wyshme.com, test2@wyshme.com'
    cs = usr.content_shares.create(content_type: 'Item',
                                   recipients: recipients)

    assert_nil cs.id, 'ContentShare is saved'
    assert_equal 'Item', cs.content_type
    assert_nil cs.content_id
    assert_equal recipients, cs.recipients

    event_id = usr.events.first.id
    cs = usr.content_shares.create(content_id: event_id,
                                   recipients: recipients)

    assert_nil cs.id, 'ContentShare is saved'
    assert_nil cs.content_type
    assert_equal event_id, cs.content_id
    assert_equal recipients, cs.recipients
  end

end
