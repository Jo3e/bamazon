class ApplicationController < ActionController::API
    rescue_from ActiveRecord::RecordNotDestroyed, with: :not_destroyed

    private
        # Handling issues with deleting objects (exception handling)
        def not_destroyed(e)
            render json: { errors: e.record.errors }, status: :unprocessable_entity
        end
end
