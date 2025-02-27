class TodoItemsController < ApplicationController
  include Dry::Monads[:result]

  before_action :set_todo_list
  before_action :set_todo_item, only: %i[show edit update destroy]

  # GET /todo_items or /todo_items.json
  def index
    @todo_items = @todo_list.items.order(created_at: :desc)
  end

  # GET /todo_items/1 or /todo_items/1.json
  def show
  end

  # GET /todo_items/new
  def new
    @todo_item = @todo_list.items.new
  end

  # GET /todo_items/1/edit
  def edit
    render partial: "edit", locals: { todo_item: @todo_item }
  end

  # POST /todo_items or /todo_items.json
  def create
    result = TodoItems::CreateTodoItemService.new(@todo_list, todo_item_params).call

    case result
    when Success
      @todo_item = result.success
      respond_to do |format|
        format.turbo_stream { }
        format.html { redirect_to @todo_list, notice: 'Todo item was successfully created.' }
      end
    when Failure
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update("new_todo_item", partial: "todo_items/form", locals: { todo_item: @todo_item, errors: result.failure }), status: :unprocessable_entity }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /todo_items/1 or /todo_items/1.json
  def update
    result = TodoItems::UpdateTodoItemService.new(@todo_item, todo_item_params).call

    case result
    when Success
      respond_to do |format|
        format.turbo_stream { }
        format.json { render :show, status: :ok, location: @todo_item }
      end
    when Failure
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update("edit_todo_item", partial: "todo_items/form", locals: { todo_item: @todo_item, errors: result.failure }), status: :unprocessable_entity }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todo_items/1 or /todo_items/1.json
  def destroy
    result = TodoItems::DestroyTodoItemService.new(@todo_item).call

    case result
    when Success
      respond_to do |format|
        format.turbo_stream { }
        format.json { head :no_content }
      end
    when Failure
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("todo_item_#{@todo_item.id}", partial: "todo_items/todo_item", locals: { todo_item: @todo_item, errors: result.failure }), status: :unprocessable_entity }
        format.html { render :index, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_todo_list
    @todo_list = TodoList.find(params[:todo_list_id])
  end

  def set_todo_item
    @todo_item = TodoItem.find(params[:id])
  end

  def todo_item_params
    params.require(:todo_item).permit(:name, :completed, :due_date)
  end
end