class Dashboard::ItemsController < DashboardController
  def index
    gon.items = @shop.items.order(modified_at: 'DESC').map do |item|
      {
        status: item.status_i18n,
        base_id: item.key,
        name: item.name,
        price: item.price.to_s(:delimited),
        stock: item.stock,
        images: item.images,
        updated_at: item.modified_at.strftime('%Y/%m/%d %H:%M')
      }
    end
  end

  def new
    @item = @shop.items.new

  end

  def edit

  end

  def show
    @item = @shop.items.find_by(key: params[:id])
  end

  def import_csv
    CsvImporter.import( File.read(params[:csv_file]) )
    flash[:notice] = '読み込みが完了しました'
    redirect_to action: :index
  end
end
