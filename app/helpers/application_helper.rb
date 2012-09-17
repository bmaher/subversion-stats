module ApplicationHelper

  require 'will_paginate/array'
    
  def title
    base_title = "Subversion Stats"
    if @title.nil?
      base_title
    else
      "#{base_title} | #@title"
    end
  end
end
