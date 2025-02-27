require "test_helper"

class TodoListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @todo_list = todo_lists(:one)
    @todo_item = todo_items(:one)
  end

  test "should get index" do
    get todo_lists_url
    assert_response :success
  end

  test "should get show" do
    get todo_list_url(@todo_list)
    assert_response :success
  end

  test "should get show with completed filter" do
    get todo_list_url(@todo_list, filter: "completed")
    assert_response :success
  end

  test "should get show with pending filter" do
    get todo_list_url(@todo_list, filter: "pending")
    assert_response :success
  end

  test "should get new" do
    get new_todo_list_url
    assert_response :success
  end

  test "should create todo_list" do
    assert_difference("TodoList.count") do
      post todo_lists_url, params: { todo_list: { name: "New Todo List" } }, as: :turbo_stream
    end
    assert_response :success
    assert_match /turbo-stream action="append"/, @response.body
  end

  test "should fail to create todo_list" do
    assert_no_difference("TodoList.count") do
      post todo_lists_url, params: { todo_list: { name: "" } }, as: :turbo_stream
    end
    assert_response :unprocessable_entity
  end

  test "should get edit" do
    get edit_todo_list_url(@todo_list)
    assert_response :success
  end

  test "should update todo_list" do
    patch todo_list_url(@todo_list), params: { todo_list: { name: "Updated Todo List" } }, as: :turbo_stream
    assert_response :success
  end

  test "should destroy todo_list" do
    assert_difference("TodoList.count", -1) do
      delete todo_list_url(@todo_list)
    end
    assert_redirected_to todo_lists_path
  end

  test "should handle turbo stream for create" do
    post todo_lists_url, params: { todo_list: { name: "New Todo List" } }, as: :turbo_stream
    assert_response :success
  end

  test "should handle turbo stream for update" do
    patch todo_list_url(@todo_list), params: { todo_list: { name: "Updated Todo List" } }, as: :turbo_stream
    assert_response :success
  end

  test "should handle turbo stream for destroy" do
    delete todo_list_url(@todo_list), as: :turbo_stream
    assert_response :see_other
  end
end
