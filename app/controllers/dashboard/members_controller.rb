class Dashboard::MembersController < DashboardController
  def index
    redirect_to action: :index unless current_user.admin?

    gon.admins = Owner.admin.order(updated_at: 'DESC').map do |admin|
      {
        id: admin.id,
        name: admin.name,
        status: admin.status_i18n,
        isApproved: admin.approved?,
        created_at: admin.created_at.strftime('%Y/%m/%d %H:%M')
      }
    end
    gon.members = Owner.member.order(updated_at: 'DESC').map do |member|
      {
        id: member.id,
        name: member.name,
        term: member.term,
        facebook_name: member.facebook_name,
        line_name: member.line_name,
        status: member.status_i18n,
        isApproved: member.approved?,
        created_at: member.created_at.strftime('%Y/%m/%d %H:%M')
      }
    end
  end

  def update
    owner = Owner.find(params[:id])
    owner.update(status: params[:status], approved_at: DateTime.now, approved_by: current_user)
    render json: { status: owner.status_i18n, isApproved: owner.approved? }
  end
end

