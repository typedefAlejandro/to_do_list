class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list
  before_action :set_task, only: %i[show edit update destroy]

  # GET /lists/:list_id/tasks
  def index
    @tasks = @list.tasks
  end

  # GET /lists/:list_id/tasks/:id
  def show
  end

  # GET /lists/:list_id/tasks/new
  def new
    @task = @list.tasks.build
  end

  # GET /lists/:list_id/tasks/:id/edit
  def edit
  end

  # POST /lists/:list_id/tasks
  def create
    @task = @list.tasks.build(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to [@list, @task], notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: [@list, @task] }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("task-modal-#{@list.id}", partial: 'tasks/form', locals: { task: @task, list: @list }) }
      end
    end
  end

  # PATCH/PUT /lists/:list_id/tasks/:id
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to lists_path, notice: "Task was successfully updated." }
        format.json { render :show, status: :ok, location: [@list, @task] }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("task-edit-modal-#{@list.id}-#{@task.id}", partial: 'tasks/edit_form', locals: { task: @task, list: @list }) }
      end
    end
  end

  # DELETE /lists/:list_id/tasks/:id
  def destroy
    @task.destroy!

    respond_to do |format|
      format.html { redirect_to list_tasks_path(@list), status: :see_other, notice: "Task was successfully destroyed." }
      format.json { head :no_content }
      format.turbo_stream
    end
  end

  private

    def set_list
      @list = current_user.lists.find(params[:list_id])
    end

    def set_task
      @task = @list.tasks.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:title, :description, :due_date, :completed, :priority)
    end
end
