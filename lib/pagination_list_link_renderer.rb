class PaginationListLinkRenderer < WillPaginate::ActionView::LinkRenderer

  protected

  def gap
    tag(:li, link("...","#"), :class => "disabled")
  end

  def page_number(page)
    unless page == current_page
      tag(:li, link(page, page, :rel => rel_value(page)))
    else
      tag(:li, link(page,"#"), :class => "active")
    end
  end

  def previous_or_next_page(page, text, classname)
    new_class = classname == "previous_page" ? "prev" : "next"
    if page
      tag(:li, link(text, page), :class => new_class)
    else
      tag(:li, link(text,"#"), :class => new_class + ' disabled')
    end
  end

  def html_container(html)
    tag(:div, tag(:ul, html, container_attributes), :class => "pagination")
      
  end

end