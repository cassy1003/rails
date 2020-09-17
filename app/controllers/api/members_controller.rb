class Api::MembersController < ApiController
  def update
    User.find(params[:id])
        .update(status: params[:status], approved_at: DateTime.now, approved_by: current_user)
    render json: { message: 'success' }
  end
end
