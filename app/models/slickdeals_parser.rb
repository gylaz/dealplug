require 'open-uri'

class SlickdealsParser

  def self.parse args = {}
    results = []
    filtered_score = args.delete(:score) || 15
    doc = Nokogiri::HTML(open('http://slickdeals.net/forums/forumdisplay.php?f=9'))

    doc.search("//tr[contains(@id,'sdpostrow')]").each do |node|
      thumbs = node.at(".//img[contains(@class,'concat-thumbs')]")
      if thumbs && (score = parse_score(thumbs['alt']))
        title_link = node.at(".//a[contains(@id, 'thread_title')]")
        results << parse_page(title_link['href']) if score >= 15 && title_link.text =~ /\$\d+/
      end
    end
    results.compact
  end

  private
  def self.parse_page(url)
    # result = { :slickdeals_id => url[/(?<=&t=)\d*/] } # look behind only supported on 1.9.2
    result = { :slickdeals_id => url[/&t=\d*/].delete('&t=') }
    prefix = 'http://slickdeals.net/forums/'
    doc = Nokogiri::HTML(open(prefix + url))
    result[:title] = doc.css('.firstthread_title').text
    return unless price_text = result[:title][/\$\d+\.?\d+/]

    result[:price] = price_text.delete('$').to_f
    first_post = doc.css('.post_message')
    result[:description] = clean_up_html(first_post.inner_html)
    result[:url] = parse_url(first_post)
    result
  end

  def self.parse_score(str)
    str[/\d+$/].to_i rescue nil
  end

  def self.parse_url(node)
    url = node.at('.//a').try(:[], 'href')
    url[/http:\/\/(?!slickdeals\.net).+/] if url
  end

  def self.clean_up_html(html_string)
    html_string.gsub(/http:\/\/slickdeals.*u2=/, '').gsub(/<!--.*-->/, '')
  end
end
