require "will_paginate"
class RemoteLinkRenderer < WillPaginate::LinkRenderer
  def prepare(collection, options, template)
    @remote = options.delete(:remote) || {}
    super
  end

  protected

  def page_link_or_span(page, span_class, text = nil)
    text ||= page.to_s
    classnames = Array[*span_class]

    if page and page != current_page
      @template.link_to(text, :url => url_for(page), :method => :get, :html => {:rel => rel_value(page), :class => classnames[1]}, :remote => true)
    else
      @template.content_tag :span, text, :class => classnames.join(' ')
    end    
  end
end
