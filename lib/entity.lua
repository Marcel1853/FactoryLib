---@diagnostic disable: undefined-global, inject-field, assign-type-mismatch, param-type-mismatch, redundant-parameter, missing-fields, deprecated, duplicate-set-field, different-requires, redefined-local, undefined-field, need-check-nil, cast-local-type
-- FLib.entity — prototype-stage entity helpers.

FLib.entity = FLib.entity or {}

function FLib.entity.getIcons(entityType, entityName)
  if not data or not data.raw then return nil end
  local entity = data.raw[entityType] and data.raw[entityType][entityName]
  if not entity then return nil end
  if entity.icons then
    return util.table.deepcopy(entity.icons)
  elseif entity.icon then
    return {{icon = entity.icon, icon_size = entity.icon_size or 64}}
  end
  return nil
end
