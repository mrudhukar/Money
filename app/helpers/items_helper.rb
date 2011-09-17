module ItemsHelper
  def display_my_total(user = current_user)
    if user.items
      user.items.collect(&:default_amount).sum
    else
      0
    end
  end

end