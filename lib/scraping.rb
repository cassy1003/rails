require 'mechanize'

class Scraping
  def self.load(url)
    if url.include?('taobao')
      load_taobao(url)
    elsif url.include?('tmall')
      load_tmall(url)
    end
  end

  def self.load_taobao(url)
    result = {}
    agent = Mechanize.new
    page = agent.get(url)

    el = page.at('.tb-shop-name a')
    result[:shop] = el.get_attribute(:title)

    el = page.at('.tb-main-title')
    result[:title] = el.get_attribute(:'data-title')

    els = page.search('.J_Prop_measurement li a span')
    result[:size_list] = els.map { |el| el.inner_text }

    els = page.search('.J_Prop_Color li a span')
    result[:color_list] = els.map { |el| el.inner_text }

    els = page.search('.tb-thumb li img')
    result[:image_list] = els.map { |el| "https:#{el.get_attribute(:'data-src')}" }

    result
  end

  def self.load_tmall(url)
    result = {}
    agent = Mechanize.new
    page = agent.get(url)

    el = page.at('#shopExtra .slogo-shopname strong')
    result[:shop] = el.inner_text

    el = page.at('#J_DetailMeta h1')
    result[:title] = el.inner_text.strip

    els = page.search('ul[data-property="尺码"] li span')
    result[:size_list] = els.map { |el| el.inner_text }

    els = page.search('ul[data-property*="颜色"] li span')
    result[:color_list] = els.map { |el| el.inner_text }

    els = page.search('.tb-thumb li img')
    result[:image_list] = els.map { |el| "https:#{el.get_attribute(:src)}" }

    result
  end
end
