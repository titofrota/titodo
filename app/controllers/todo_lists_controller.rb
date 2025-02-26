class TodoListsController < ApplicationController
  before_action :set_todo_list, only: %i[ show edit update destroy ]

  # GET /todo_lists or /todo_lists.json
  def index
    @todo_lists = TodoList.all
  end

  # GET /todo_lists/1 or /todo_lists/1.json
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

  # GET /todo_lists/new
  def new
    @todo_list = TodoList.new

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  # GET /todo_lists/1/edit
  def edit
    render partial: "edit", locals: { todo_list: @todo_list }
  end

  # POST /todo_lists or /todo_lists.json
  def create
    @todo_list = TodoList.new(todo_list_params)

    if @todo_list.save
      respond_to do |format|
        format.html { redirect_to todo_lists_path, notice: "Todo list was successfully created." }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end


  # PATCH/PUT /todo_lists/1 or /todo_lists/1.json
  def update
    respond_to do |format|
      if @todo_list.update(todo_list_params)
        format.turbo_stream { }
        format.json { render :show, status: :ok, location: @todo_list }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @todo_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todo_lists/1 or /todo_lists/1.json
  def destroy
    @todo_list.destroy!

    respond_to do |format|
      format.html { redirect_to todo_lists_path, status: :see_other, notice: "Todo list was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo_list
      @todo_list = TodoList.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def todo_list_params
      params.expect(todo_list: [ :name ])
    end
end
