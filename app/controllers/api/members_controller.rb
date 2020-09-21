class Api::MembersController < ApiController
  def update
    owner = Owner.find(params[:id])
    owner.update(status: params[:status], approved_at: DateTime.now, approved_by: current_user)
    render json: { status: owner.status_i18n, isApproved: owner.approved? }
  end
end
