module DealsHelper
  def submitted_by_text(deal)
    "Plugged by: #{deal.user.username} #{time_ago_in_words(deal.created_at)} ago"
  end
end
