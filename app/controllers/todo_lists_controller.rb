class TodoListsController < ApplicationController
  include Dry::Monads[:result]

  before_action :set_todo_list, only: %i[show edit update destroy]

  def index
    @todo_lists = TodoList.all
  end

  def show
    @todo_items = case params[:filter]
    when "completed"
                    @todo_list.items.completed
    when "pending"
                    @todo_list.items.pending
    else
                    @todo_list.items
    end

    if turbo_frame_request?
      render @todo_items
    else
      render :show
    end
  end

  def new
    @todo_list = TodoList.new

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def edit
    render partial: "edit", locals: { todo_list: @todo_list }
  end

  def create
    @todo_list = TodoList.new(todo_list_params)

    result = TodoLists::CreateTodoListService.new(todo_list_params).call

    case result
    when Success
      @todo_list = result.success

      respond_to do |format|
        format.turbo_stream
      end
    when Failure
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update("new_todo_list", partial: "todo_lists/form", locals: { todo_list: @todo_list, errors: result.failure }), status: :unprocessable_entity }
      end
    end
  end

  def update
    result = TodoLists::UpdateTodoListService.new(@todo_list, todo_list_params).call

    case result
    when Success
      respond_to do |format|
        format.turbo_stream
      end
    when Failure
      render :edit, status: :unprocessable_entity, locals: { errors: result.failure }
    end
  end

  def destroy
    result = TodoLists::DestroyTodoListService.new(@todo_list).call

    case result
    when Success
      respond_to do |format|
        format.html { redirect_to todo_lists_path, status: :see_other, notice: "Todo list was successfully destroyed." }
        format.json { head :no_content }
      end
    when Failure
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("todo_list_#{@todo_list.id}", partial: "todo_lists/todo_list", locals: { todo_list: @todo_list, errors: result.failure }), status: :unprocessable_entity }
        format.html { render :index, status: :unprocessable_entity, locals: { errors: result.failure } }
      end
    end
  end

  private

    def set_todo_list
      @todo_list = TodoList.find(params[:id])
    end

    def todo_list_params
      params.require(:todo_list).permit(:name)
    end
end
