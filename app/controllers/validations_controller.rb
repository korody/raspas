using StringExtensions

class ValidationsController < ApplicationController
  def validate
    validator = UserValidationService.new(attribute: params[:attribute].sanitize, value: params[:value].sanitize)

    if validator.valid?
      render nothing: true, status: 200
    else
      render json: { errors: validator.errors }, status: 409
    end
  end
end
