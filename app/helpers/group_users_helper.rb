module GroupUsersHelper

  def link_to_suspend(group_user)
    if group_user.can_be_suspend?
      link_to("Suspend", group_group_user_path(group_user.group, group_user, :suspend => true), :confirm => "Are you sure you want to suspend the user?", :method => :put)
    else
      link_to_function("Suspend", "alert('User cannot be suspended from the group because of having non zero credit :P');")
    end
  end

  def link_to_activate(group_user)
    link_to("Activate", group_group_user_path(group_user.group, group_user, :activate => true), :confirm => "Are you sure you want to activate the user?", :method => :put)
  end

  def render_action_link(group_user, cur_user)
    if group_user.user != cur_user
      group_user.active? ? link_to_suspend(group_user) : link_to_activate(group_user)
    end
  end
end
