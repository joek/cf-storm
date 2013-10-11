module BootstrapHelpers
  def bs
    @bootstrap ||= BootstrapUI.new
  end

  class BootstrapUI
    def container
      'container'
    end

    def row
      'row'
    end

    def row_fluid
      'row-fluid'
    end

    def container_fluid
      'container-fluid'
    end

    def width width
      "span#{width}"
    end

    def breadcrumb
      'breadcrumb'
    end

    def apps_list
      %w[ table table-striped table-hover ]
    end

    def width_offset width
      "offset#{width}"
    end

    def brand
      'brand'
    end

    def btn
      'btn'
    end

    def divider
      'divider'
    end

    def well
      'well'
    end

    def float_right
      'pull-right'
    end

    def btn_large
      'btn-large'
    end

    def table
      'table'
    end

    def btn_danger
      'btn-danger'
    end

    def label
      'label'
    end

    def label_info
      'label-info'
    end

    def badge
      'badge'
    end

    def badge_success
      'badge-success'
    end

    def alert
      'alert'
    end

    def alert_error
      'alert-error'
    end

    def navbar
      'navbar'
    end

    def navbar_inverse
      'navbar-inverse'
    end

    def navbar_fixed_bottom
      'navbar-fixed-bottom'
    end

    def navbar_inner
      'navbar-inner'
    end

    def nav
      'nav'
    end

    def navbar_text
      'navbar-text-class'
    end

    def icon icon
      "icon-#{icon}"
    end

    def navbar_fixed_top
      'navbar-fixed-top'
    end

    def active
      'active'
    end

    def dropdown
      'dropdown'
    end

    def dropdown_toggle
      'dropdown-toggle'
    end

    def dropdown_menu
      'dropdown-menu'
    end

    def caret
      'caret'
    end

    def table_condensed
      'table-condensed'
    end

    def table_hover
      'table-hover'
    end

    def table_stripped
      'table-stripped'
    end

    def btn_group
      'btn-group'
    end
  end
end
