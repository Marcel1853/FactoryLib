---@diagnostic disable: undefined-global, inject-field, assign-type-mismatch, param-type-mismatch, redundant-parameter, missing-fields, deprecated, duplicate-set-field, different-requires, redefined-local, undefined-field, need-check-nil, cast-local-type
-- FLib.styles — prototype-stage style helpers.
-- These are used by the train construction site mod's GUI layout definitions.

FLib.styles = FLib.styles or {}

function FLib.styles.addButtonStyle(styleName, options)
  if not data or not data.raw["gui-style"] or not data.raw["gui-style"]["default"] then return end
  options = options or {}
  local parentStyle = options.parent or "button"
  data.raw["gui-style"]["default"][styleName] = {
    type = "button_style",
    parent = parentStyle,
    width = options.width,
    height = options.height,
    minimal_width = options.minimal_width,
    minimal_height = options.minimal_height,
    maximal_width = options.maximal_width,
    maximal_height = options.maximal_height,
    padding = options.padding,
    top_padding = options.top_padding,
    bottom_padding = options.bottom_padding,
    left_padding = options.left_padding,
    right_padding = options.right_padding,
  }
end

function FLib.styles.addLabelStyle(styleName, options)
  if not data or not data.raw["gui-style"] or not data.raw["gui-style"]["default"] then return end
  options = options or {}
  local parentStyle = options.parent or "label"
  data.raw["gui-style"]["default"][styleName] = {
    type = "label_style",
    parent = parentStyle,
    width = options.width,
    height = options.height,
    font = options.font,
    font_color = options.font_color,
    single_line = options.single_line,
  }
end

function FLib.styles.addTableStyle(styleName, options)
  if not data or not data.raw["gui-style"] or not data.raw["gui-style"]["default"] then return end
  options = options or {}
  local parentStyle = options.parent or "table"
  data.raw["gui-style"]["default"][styleName] = {
    type = "table_style",
    parent = parentStyle,
    horizontal_spacing = options.horizontal_spacing,
    vertical_spacing = options.vertical_spacing,
    cell_padding = options.cell_padding,
  }
end
