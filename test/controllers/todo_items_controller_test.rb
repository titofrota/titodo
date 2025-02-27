require "test_helper"

class TodoItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @todo_list = todo_lists(:one)
    @todo_item = todo_items(:one)
  end

  test "should get index" do
    get todo_list_todo_items_url(@todo_list), as: :turbo_stream
    assert_response :success
  end

  test "should get show" do
    get todo_list_todo_item_url(@todo_list, @todo_item), as: :turbo_stream
    assert_response :success
  end

  test "should get new" do
    get new_todo_list_todo_item_url(@todo_list), as: :turbo_stream
    assert_response :success
  end


  test "should create todo_item" do
    assert_difference("TodoItem.count") do
      post todo_list_todo_items_url(@todo_list), params: { todo_item: { name: "New Item", completed: false, due_date: Date.tomorrow } }, as: :turbo_stream
    end
    assert_response :success
    assert_match /turbo-stream action="append"/, @response.body
  end

  test "should not create todo_item with invalid data" do
    assert_no_difference("TodoItem.count") do
      post todo_list_todo_items_url(@todo_list), params: { todo_item: { name: "", completed: false, due_date: Date.tomorrow } }, as: :turbo_stream
    end
    assert_response :unprocessable_entity
    assert_match /turbo-stream action="update"/, @response.body
  end


  test "should update todo_item" do
    patch todo_list_todo_item_url(@todo_list, @todo_item), params: { todo_item: { name: "Updated Item", completed: true, due_date: Date.tomorrow } }, as: :turbo_stream
    assert_response :success
    assert_match /turbo-stream action="replace"/, @response.body
  end

  test "should not update todo_item with invalid data" do
    patch todo_list_todo_item_url(@todo_list, @todo_item), params: { todo_item: { name: "", completed: true, due_date: Date.tomorrow } }, as: :turbo_stream
    assert_response :unprocessable_entity
    assert_match /turbo-stream action="update"/, @response.body
  end


  test "should destroy todo_item" do
    assert_difference("TodoItem.count", -1) do
      delete todo_list_todo_item_url(@todo_list, @todo_item), as: :turbo_stream
    end
    assert_response :success
    assert_match /turbo-stream action="remove"/, @response.body
  end
end