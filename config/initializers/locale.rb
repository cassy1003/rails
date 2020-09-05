
# I18nライブラリに訳文の探索場所を指示する
I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]

# アプリケーションでの利用を許可するロケールをホワイトリスト化する
# I18n.available_locales = %i[ja en]
I18n.available_locales = %i[ja]

# ロケールを:en以外に変更する
I18n.default_locale = :ja
