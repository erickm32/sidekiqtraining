class Api::EventsController < Api::BaseController
  def index
    render json: Event.all
  end

  def show
  end

  def create
    event = Event.new(event_params)
    if event.save
      render json: event
    else
      render json: event.errors, status: :unprocessable_entity
    end
  end

  private

  def event_params
    params.fetch(:event, {}).permit(Event.permitted_attributes)
  end
end
