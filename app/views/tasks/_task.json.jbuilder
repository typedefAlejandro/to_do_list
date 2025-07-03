json.extract! task, :id, :title, :description, :due_date, :completed, :priority, :list_id, :created_at, :updated_at
json.url task_url(task, format: :json)
