module DealsHelper
  def submitted_ago(deal)
    deal.created_at.strftime("%I:%M %p on %B %d, %Y")
  end
end
