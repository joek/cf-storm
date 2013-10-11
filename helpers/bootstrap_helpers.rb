module BootstrapHelpers
  def bs
    @bootstrap ||= BootstrapUI.new
  end

  def ui_navbar
    "#{bs.navbar} #{bs.navbar_default} #{bs.navbar_inverse}"
  end

  def ui_navbar_top
    ui_navbar + " #{bs.navbar_fixed_top}"
  end

  def ui_navbar_bottom
    ui_navbar + " #{bs.navbar_fixed_bottom}"
  end

  def ui_navbar_content
    "collapse navbar-collapse navbar-ex1-collapse"
  end

  def ui_navbar_list
    "#{bs.nav} #{bs.navbar_nav}"
  end

  def ui_navbar_right
    ui_navbar_list + ' ' + bs.navbar_right
  end



  class BootstrapUI

    def navbar_nav
      'navbar-nav'
    end

    def navbar_right
      'navbar-right'
    end

    def navbar_header
      'navbar-header'
    end

    def container
      'container'
    end

    def navbar_default
      'navbar-default'
    end

    def row
      'row'
    end

    def row_fluid
      row
    end

    def container_fluid
      container
    end

    def width width
      "col-md-#{width}"
    end

    def breadcrumb
      'breadcrumb'
    end

    def apps_list
      %w[ table table-striped table-hover ]
    end

    def width_offset width
      "col-md-offset-#{width}"
    end

    def brand
      'navbar-brand'
    end

    def btn kind='default', size=nil
      "btn btn-#{kind}#{size ? (' btn-' + size) : ''}"
    end

    def panel kind='default'
      "panel panel-#{kind}"
    end

    def panel_heading
      'panel-heading'
    end

    def panel_body
      'panel-body'
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
      'btn-lg'
    end

    def form_group
      'form-group'
    end

    def form_control
      'form-control'
    end

    def input_group
      'input-group'
    end

    def form_inline
      'form-horizontal'
    end

    def input_addon
      'input-group-addon'
    end

    def input_group_btn
      'input-group-btn'
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

    def label_success
      'label-success'
    end

    def label_danger
      'label-danger'
    end

    def badge_important
      'badge-important'
    end

    def badge_success
      'badge-success'
    end

    def badge
      'badge'
    end

    def alert
      'alert'
    end

    def alert_error
      'alert-error'
    end

    def alert_info
      'alert-info'
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
      ''
    end

    def nav
      'nav'
    end

    def navbar_text
      'navbar-text'
    end

    def icon icon
      "glyphicon glyphicon-#{icon}"
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
