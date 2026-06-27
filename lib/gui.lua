---@diagnostic disable: undefined-global, inject-field, assign-type-mismatch, param-type-mismatch, redundant-parameter, missing-fields, deprecated, duplicate-set-field, different-requires, redefined-local, undefined-field, need-check-nil, cast-local-type
-- FactoryLib GUI Runtime
-- Renders a layout tree into real Factorio GUI elements and provides
-- element access by path string.

FLib.gui = FLib.gui or {}

--- Return the name of the topmost child element in a layout tree.
function FLib.gui.getRootElementName(tree)
  local _, first = next(tree.children or {})
  return first and first.name or "unknownRootElementName"
end

--- Recursively instantiate GUI elements from the layout tree.
local function spawnChildren(parent, kids)
  for _, descriptor in pairs(kids or {}) do
    -- Collect only GUI-relevant keys (skip internal bookkeeping).
    local spec = {}
    for k, v in pairs(descriptor) do
      if k ~= "children" and k ~= "path" and k ~= "drag_target" then
        spec[k] = v
      end
    end

    -- Guard against duplicates.
    if parent[spec.name] then return end

    local elem = parent.add(spec)

    -- Resolve drag_target path into a real element reference.
    if descriptor.drag_target then
      elem.drag_target = FLib.gui.getElement(parent.player_index, descriptor.drag_target)
    end

    -- Honour explicit visibility flags stored during layout building.
    if descriptor.visible == false or descriptor.hidden == true then
      elem.visible = false
    end

    -- Recurse into child descriptors.
    if elem and not FLib.utils.table.isEmpty(descriptor.children) then
      spawnChildren(elem, descriptor.children)
    end
  end
end

--- Build the complete GUI described by *tree* for *playerIndex*.
--- Automatically centres screen-anchored GUIs.
function FLib.gui.create(playerIndex, tree)
  local anchor = game.players[playerIndex].gui[tree.name]
  spawnChildren(anchor, tree.children)
  local rootName = FLib.gui.getRootElementName(tree)
  if tree.name == "screen" and anchor[rootName] then
    anchor[rootName].force_auto_center()
  end
  return anchor[rootName]
end

--- Tear down whatever *tree* previously added for *playerIndex*.
function FLib.gui.destroy(playerIndex, tree)
  local anchor = game.players[playerIndex].gui[tree.name]
  for _, kid in pairs(tree.children or {}) do
    if anchor[kid.name] then anchor[kid.name].destroy() end
  end
  return nil
end

--- Navigate to a live GUI element using a path string.
--- Path format: "root(screen)/frame-name/child-name/…"
function FLib.gui.getElement(playerIndex, path)
  local parts = FLib.utils.string.split(path, "/")
  -- First segment is "root(anchor)" — extract the anchor name from between parentheses.
  local anchorName = parts[1]:match("%((.+)%)") or parts[1]
  local cursor = game.players[playerIndex].gui[anchorName]
  for i = 2, #parts do
    if not cursor then return nil end
    cursor = cursor[parts[i]]
  end
  return cursor
end
