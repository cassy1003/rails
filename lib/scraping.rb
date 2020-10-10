require 'mechanize'

class Scraping
  def self.scrape
    result = {}
    agent = Mechanize.new
    page = agent.get(ItemSupplier.find(2).url)

    el = page.at('.tb-shop-name a')
    result[:shop] = el.get_attribute(:title)

    el = page.at('.tb-main-title')
    result[:title] = el.get_attribute(:'data-title')

    els = page.search('.J_Prop_measurement li a span')
    result[:size_list] = els.map { |el| el.inner_text }

    els = page.search('.J_Prop_Color li a span')
    result[:color_list] = els.map { |el| el.inner_text }

    els = page.search('.tb-thumb li img')
    result[:image_list] = els.map { |el| 'https:'el.get_attribute(:'data-src') }

    result
  end
end
