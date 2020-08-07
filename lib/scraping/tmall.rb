require 'mechanize'

module Scraping
  class Tmall
    def self.exec(url)
      agent = Mechanize.new
      page = agent.get(url)
      page.search('#J_LinkBasket').each do |el|
        puts el.inner_text.include?('加入购物车')
      end
    end

    def self.test()
      exec("https://detail.tmall.com/item.htm?spm=a1z10.3-b-s.w4011-21290156812.275.426d53ceYjytI2&id=617066390097&rn=3af581a1d1ee0a87ba581fdbcbfa904f&abbucket=16&sku_properties=20509:380970824")
    end
  end
end
