require 'test_helper'

class ModelTest < ActiveSupport::TestCase
  test 'responds to user_sessions' do
    user = User.new
    assert_respond_to user, :user_sessions
  end

  test 'activate_session sets session_id' do
    warden = MockWarden.new
    user = User.new
    user.activate_session(warden)

    assert_not_nil user.user_sessions.first.session_id
  end

  test 'activate_session sets ip' do
    warden = MockWarden.new('REMOTE_ADDR' => '10.0.0.1')
    user = User.new
    user.activate_session(warden)

    assert_equal '10.0.0.1', user.user_sessions.first.ip
  end

  test 'activate_session sets user_agent' do
    warden = MockWarden.new('HTTP_USER_AGENT' => 'Mozilla/5.0')
    user = User.new
    user.activate_session(warden)

    assert_equal 'Mozilla/5.0', user.user_sessions.first.user_agent
  end

  test 'exclusive_session deletes all other sessions' do
    warden = MockWarden.new
    user = User.new(id: 1)
    user.activate_session(warden) # session #1
    session_id = user.activate_session(warden) # session #2

    assert_equal 2, user.user_sessions.count
    user.exclusive_session(session_id)
    assert_equal 1, user.user_sessions.count
  end

  test 'session_active? returns true when exists' do
    warden = MockWarden.new
    user = User.new(id: 1)
    session_id = user.activate_session(warden)

    assert_equal true, user.session_active?(session_id)
  end

  test 'session_active? returns false when does not exists' do
    warden = MockWarden.new
    user = User.new(id: 1)
    user.activate_session(warden)

    assert_equal false, user.session_active?('not-found')
  end

  test 'ensures only last 10 sessions kept' do
    warden = MockWarden.new
    user = User.new(id: 1)
    12.times { user.activate_session(warden) }

    assert_equal 10, user.user_sessions.count
  end

  private

  class MockWarden
    def initialize(env = {})
      @request = ActionDispatch::Request.new(env)
    end

    def request
      @request
    end
  end
end
