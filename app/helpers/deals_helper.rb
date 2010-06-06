module DealsHelper
  def submitted_ago(deal)
    deal.created_at.strftime("%B %d, %Y")
  end
end
