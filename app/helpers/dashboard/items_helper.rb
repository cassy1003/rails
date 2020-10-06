module Dashboard::ItemsHelper
  def status_badge_class
    if @item.published?
      'info'
    elsif @item.unpublished?
      'primary'
    elsif @item.draft?
      'secondary'
    end
  end
end
