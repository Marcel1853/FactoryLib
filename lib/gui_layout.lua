---@diagnostic disable: undefined-global, inject-field, assign-type-mismatch, param-type-mismatch, redundant-parameter, missing-fields, deprecated, duplicate-set-field, different-requires, redefined-local, undefined-field, need-check-nil, cast-local-type
-- FactoryLib GUI Layout Builder
-- Builds a declarative tree describing a GUI hierarchy.
-- Each node stores its full path from root, its properties, and child nodes.

require "util"

FLib.gui = FLib.gui or {}
FLib.gui.layout = FLib.gui.layout or {}

--- Build a path string for a child under its parent.
local function buildPath(parentPath, childName)
  return parentPath .. "/" .. childName
end

--- Create a new layout tree anchored to a Factorio GUI root.
function FLib.gui.layout.create(anchor)
  local valid = {top=1, left=1, center=1, relative=1, screen=1, goal=1}
  if not valid[anchor] then anchor = "center" end
  return {
    path     = string.format("root(%s)", anchor),
    name     = anchor,
    children = {nil},
  }
end

--- Insert a new node into the tree under the given parent path.
--- Returns the full path of the new node.
function FLib.gui.layout.addElement(tree, parentPath, props)
  local target = FLib.gui.layout.getElement(tree, parentPath)
  local entry = util.table.deepcopy(props)
  entry.path     = buildPath(target.path, props.name)
  entry.children = {nil}
  table.insert(target.children, entry)
  return entry.path
end

--- Walk the tree following a slash-separated path and return the matching node.
function FLib.gui.layout.getElement(tree, fullPath)
  local segments = FLib.utils.string.split(fullPath, "/")
  local cursor = tree
  for i = 2, #segments do
    local found = false
    for _, kid in pairs(cursor.children or {}) do
      if kid.name == segments[i] then
        cursor = kid
        found = true
        break
      end
    end
    if not found then return cursor end
  end
  return cursor
end

--- Recursively search the tree for a node by name and return its path.
function FLib.gui.layout.getElementPath(tree, targetName)
  for _, kid in pairs(tree.children or {}) do
    if kid.name == targetName then return kid.path end
    if kid.children then
      local hit = FLib.gui.layout.getElementPath(kid, targetName)
      if hit then return hit end
    end
  end
  return nil
end

-- Helper: build a property table from type-specific fields, then delegate to addElement.
local function register(tree, parentPath, etype, name, fields)
  fields = fields or {}
  fields.type = etype
  fields.name = name
  return FLib.gui.layout.addElement(tree, parentPath, fields)
end

function FLib.gui.layout.addFrame(tree, parentPath, name, dir, o)
  o = o or {}
  return register(tree, parentPath, "frame", name, {
    direction=dir, caption=o.caption, style=o.style,
    visible=o.visible, ignored_by_interaction=o.ignored_by_interaction,
  })
end

function FLib.gui.layout.addFlow(tree, parentPath, name, dir, o)
  o = o or {}
  return register(tree, parentPath, "flow", name, {
    direction=dir, style=o.style, visible=o.visible,
    ignored_by_interaction=o.ignored_by_interaction,
  })
end

function FLib.gui.layout.addLabel(tree, parentPath, name, o)
  o = o or {}
  return register(tree, parentPath, "label", name, {
    caption=o.caption, tooltip=o.tooltip, style=o.style,
    visible=o.visible, enabled=o.enabled,
    ignored_by_interaction=o.ignored_by_interaction,
  })
end

function FLib.gui.layout.addButton(tree, parentPath, name, o)
  o = o or {}
  return register(tree, parentPath, "button", name, {
    caption=o.caption, tooltip=o.tooltip, style=o.style,
    mouse_button_filter=o.mouse_button_filter,
    visible=o.visible, enabled=o.enabled,
    ignored_by_interaction=o.ignored_by_interaction,
  })
end

function FLib.gui.layout.addSpriteButton(tree, parentPath, name, o)
  o = o or {}
  return register(tree, parentPath, "sprite-button", name, {
    caption=o.caption, tooltip=o.tooltip, style=o.style,
    sprite=o.sprite, hovered_sprite=o.hovered_sprite,
    clicked_sprite=o.clicked_sprite, number=o.number,
    show_percent_for_small_numbers=o.show_percent_for_small_numbers,
    mouse_button_filter=o.mouse_button_filter,
    visible=o.visible, enabled=o.enabled,
    ignored_by_interaction=o.ignored_by_interaction,
  })
end

function FLib.gui.layout.addTextfield(tree, parentPath, name, o)
  o = o or {}
  return register(tree, parentPath, "textfield", name, {
    text=o.text, tooltip=o.tooltip, style=o.style,
    numeric=o.numeric, allow_decimal=o.allow_decimal,
    is_password=o.is_password,
    visible=o.visible, enabled=o.enabled,
    ignored_by_interaction=o.ignored_by_interaction,
  })
end

function FLib.gui.layout.addListbox(tree, parentPath, name, o)
  o = o or {}
  return register(tree, parentPath, "list-box", name, {
    items=o.items, selected_index=o.selected_index, style=o.style,
    visible=o.visible, enabled=o.enabled,
    ignored_by_interaction=o.ignored_by_interaction,
  })
end

function FLib.gui.layout.addTable(tree, parentPath, name, cols, o)
  o = o or {}
  return register(tree, parentPath, "table", name, {
    column_count=cols, style=o.style,
    draw_vertical_lines=o.draw_vertical_lines,
    draw_horizontal_lines=o.draw_horizontal_lines,
    draw_horizontal_line_after_headers=o.draw_horizontal_line_after_headers,
    visible=o.visible, enabled=o.enabled,
    ignored_by_interaction=o.ignored_by_interaction,
  })
end

function FLib.gui.layout.addSlider(tree, parentPath, name, o)
  o = o or {}
  return register(tree, parentPath, "slider", name, {
    minimum_value=o.minimum_value, maximum_value=o.maximum_value,
    value=o.value, style=o.style,
    visible=o.visible, enabled=o.enabled,
    ignored_by_interaction=o.ignored_by_interaction,
  })
end

function FLib.gui.layout.addScrollPane(tree, parentPath, name, o)
  o = o or {}
  return register(tree, parentPath, "scroll-pane", name, {
    horizontal_scroll_policy=o.horizontal_scroll_policy,
    vertical_scroll_policy=o.vertical_scroll_policy,
    style=o.style, visible=o.visible, enabled=o.enabled,
    ignored_by_interaction=o.ignored_by_interaction,
  })
end

function FLib.gui.layout.addEntityPreview(tree, parentPath, name, o)
  o = o or {}
  return register(tree, parentPath, "entity-preview", name, {
    style=o.style, visible=o.visible, enabled=o.enabled,
    ignored_by_interaction=o.ignored_by_interaction,
  })
end

function FLib.gui.layout.addEmptyWidget(tree, parentPath, name, o)
  o = o or {}
  return register(tree, parentPath, "empty-widget", name, {
    drag_target = (tree.name == "screen") and o.drag_target or nil,
    style=o.style, visible=o.visible, enabled=o.enabled,
  })
end

function FLib.gui.layout.addSprite(tree, parentPath, name, o)
  o = o or {}
  return register(tree, parentPath, "sprite", name, {
    sprite=o.sprite, style=o.style, visible=o.visible,
    enabled=o.enabled, ignored_by_interaction=o.ignored_by_interaction,
  })
end

--- Create a tabbed section: button row + one content flow per tab page.
--- Returns the path to the content container frame.
function FLib.gui.layout.addTabs(tree, parentPath, tabName, pages, opts)
  opts = opts or {}
  local outerFrame = FLib.gui.layout.addFrame(tree, parentPath, tabName, "vertical", {
    style = opts.tabInsideFrameStyle or "inside_deep_frame_for_tabs",
  })
  local btnFlow = FLib.gui.layout.addFlow(tree, outerFrame, tabName.."-buttons", "horizontal", {
    style = opts.buttonFlowStyle,
  })
  local contentFrame = FLib.gui.layout.addFrame(tree, outerFrame, tabName.."-content", "vertical", {
    style = opts.tabContentFrameStyle,
  })
  for _, pg in pairs(pages or {}) do
    FLib.gui.layout.addButton(tree, btnFlow, tabName..pg.name, {
      caption = pg.caption,
      style   = pg.selected and opts.buttonSelectedStyle or opts.buttonStyle,
    })
    if pg.enabled ~= false then
      local flow = FLib.gui.layout.addFlow(tree, contentFrame, tabName..pg.name, "vertical")
      if not pg.selected then
        FLib.gui.layout.getElement(tree, flow).visible = false
      end
    end
  end
  return contentFrame
end

--- Get the path of the Nth tab content flow inside a tab content frame.
function FLib.gui.layout.getTabContentFrameFlow(tree, contentPath, index)
  local node = FLib.gui.layout.getElement(tree, contentPath)
  if node and node.children and node.children[index] then
    return node.children[index].path
  end
  return nil
end
