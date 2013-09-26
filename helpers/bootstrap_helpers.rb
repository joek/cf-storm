module BootstrapHelpers
  def container_class prev=nil
    return prev + ' container' if prev
    return 'container'
  end

  def row_class
    'row-fluid'
  end

  def width_class width
    "span#{width}"
  end

  def breadcrum_class
    'breadcrum'
  end

  def apps_list_class
    %w[ table table-striped table-hover ]
  end
end
