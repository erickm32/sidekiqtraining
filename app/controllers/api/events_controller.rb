class Api::EventsController < Api::BaseController
  def index
    render json: Event.all
  end

  def show
    render json: Event.find(params["id"])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  def create
    event = Event.new(event_params)
    if event.save
      render json: event
    else
      render json: event.errors, status: :unprocessable_entity
    end
  end

  def update
    event = Event.find(params["id"])
    if event.update(event_params)
      render json: event
    else
      render json: event.errors, status: :unprocessable_entity
    end
  end

  def destroy
    event = Event.find(params["id"])
    if event.destroy
      render json: event
    else
      render json: event.errors, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  private

  def event_params
    params.fetch(:event, {}).permit(Event.permitted_attributes)
  end
end
