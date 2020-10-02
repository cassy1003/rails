class Dashboard::ItemsController < DashboardController
  def index
    @shop = current_user.shops.first
    gon.items = @shop.items.order(modified_at: 'DESC').map do |item|
      {
        visible: item.show?,
        base_id: item.key,
        name: item.name,
        price: item.price.to_s(:delimited),
        stock: item.stock,
        images: item.images,
        updated_at: item.modified_at.strftime('%Y/%m/%d %H:%M')
      }
    end
  end

  def import_csv
    CsvImporter.import( File.read(params[:csv_file]) )
    flash[:notice] = '読み込みが完了しました'
    redirect_to action: :index
  end
end
