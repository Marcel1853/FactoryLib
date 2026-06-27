---@diagnostic disable: undefined-global, inject-field, assign-type-mismatch, param-type-mismatch, redundant-parameter, missing-fields, deprecated, duplicate-set-field, different-requires, redefined-local, undefined-field, need-check-nil, cast-local-type
-- FLib.item — prototype-stage item helpers.
-- All functions take (itemType, itemName, ...) matching the original FLib API.

FLib.item = FLib.item or {}

local function findItem(itemType, itemName)
  if not data or not data.raw then return nil end
  if itemType and data.raw[itemType] and data.raw[itemType][itemName] then
    return data.raw[itemType][itemName]
  end
  -- Fallback: search common item types
  for _, t in pairs({"item", "item-with-entity-data", "item-with-label", "item-with-inventory",
    "item-with-tags", "tool", "ammo", "armor", "gun", "capsule", "module",
    "rail-planner", "blueprint", "blueprint-book", "deconstruction-item",
    "upgrade-item", "spidertron-remote", "selection-tool", "copy-paste-tool"}) do
    if data.raw[t] and data.raw[t][itemName] then
      return data.raw[t][itemName]
    end
  end
  return nil
end

--- Get icons for an item prototype.
--- @param itemType string  e.g. "item", "item-with-entity-data"
--- @param itemName string  e.g. "locomotive"
--- @param scale number|nil  optional scale applied to all icon layers
--- @param shift table|nil   optional {x,y} shift applied to all icon layers
--- @return table|nil        array of icon layers, or nil
function FLib.item.getIcons(itemType, itemName, scale, shift)
  local item = findItem(itemType, itemName)
  if not item then return nil end

  local icons
  if item.icons then
    icons = util.table.deepcopy(item.icons)
  elseif item.icon then
    icons = {{icon = item.icon, icon_size = item.icon_size or 64}}
  else
    return nil
  end

  -- Apply optional scale and shift
  if scale or shift then
    for _, layer in pairs(icons) do
      if scale then
        layer.scale = (layer.scale or 1) * scale
      end
      if shift then
        local ls = layer.shift or {0, 0}
        layer.shift = {(ls[1] or 0) + (shift[1] or 0), (ls[2] or 0) + (shift[2] or 0)}
      end
    end
  end

  return icons
end

--- Get icon size for an item prototype.
--- @param itemType string
--- @param itemName string
--- @return table  e.g. {64} or {64, 64}
function FLib.item.getIconSize(itemType, itemName)
  local item = findItem(itemType, itemName)
  if not item then return {64} end
  local size = item.icon_size or 64
  if type(size) == "table" then return size end
  return {size}
end

function FLib.item.getSubgroup(itemType, itemName)
  local item = findItem(itemType, itemName)
  if not item then return nil end
  return item.subgroup
end

function FLib.item.setSubgroup(itemType, itemName, subgroup)
  local item = findItem(itemType, itemName)
  if item then item.subgroup = subgroup end
end

function FLib.item.getOrderstring(itemType, itemName)
  local item = findItem(itemType, itemName)
  if not item then return "" end
  return item.order or ""
end

function FLib.item.setOrderstring(itemType, itemName, order)
  local item = findItem(itemType, itemName)
  if item then item.order = order end
end

function FLib.item.setHidden(itemType, itemName, hidden)
  local item = findItem(itemType, itemName)
  if item then
    if hidden == nil then hidden = true end
    item.hidden = hidden
  end
end
