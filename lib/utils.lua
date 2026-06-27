---@diagnostic disable: undefined-global, inject-field, assign-type-mismatch, param-type-mismatch, redundant-parameter, missing-fields, deprecated, duplicate-set-field, different-requires, redefined-local, undefined-field, need-check-nil, cast-local-type

FLib.utils = FLib.utils or {}

--------------------------------------------------------------------------------
-- FLib.utils.directions
--------------------------------------------------------------------------------
FLib.utils.directions = FLib.utils.directions or {}

do
  local d = defines and defines.direction or {north=0,northeast=1,east=2,southeast=3,south=4,southwest=5,west=6,northwest=7}
  local north=d.north or 0; local northeast=d.northeast or 1
  local east=d.east or 2;   local southeast=d.southeast or 3
  local south=d.south or 4; local southwest=d.southwest or 5
  local west=d.west or 6;   local northwest=d.northwest or 7

  local opposite_map = {
    [north]=south,[northeast]=southwest,[east]=west,[southeast]=northwest,
    [south]=north,[southwest]=northeast,[west]=east,[northwest]=southeast,
  }
  local name_map = {
    [north]="north",[northeast]="northeast",[east]="east",[southeast]="southeast",
    [south]="south",[southwest]="southwest",[west]="west",[northwest]="northwest",
  }

  function FLib.utils.directions.oposite(direction) return opposite_map[direction] or direction end
  FLib.utils.directions.opposite = FLib.utils.directions.oposite
  function FLib.utils.directions.toString(direction) return name_map[direction] or "north" end
  function FLib.utils.directions.orientationTo4WayDirection(orientation)
    orientation = (orientation or 0) % 1
    if orientation >= 0.875 or orientation < 0.125 then return north
    elseif orientation < 0.375 then return east
    elseif orientation < 0.625 then return south
    else return west end
  end
end

--------------------------------------------------------------------------------
-- FLib.utils.string
--------------------------------------------------------------------------------
FLib.utils.string = FLib.utils.string or {}

function FLib.utils.string.split(inputstring, sep)
  if inputstring == nil then return {} end
  if sep == nil then sep = "%s" end
  local t = {}
  local i = 1
  for str in string.gmatch(inputstring, "([^" .. sep .. "]+)") do
    t[i] = str
    i = i + 1
  end
  return t
end

--------------------------------------------------------------------------------
-- FLib.utils.table
--------------------------------------------------------------------------------
FLib.utils.table = FLib.utils.table or {}

function FLib.utils.table.isEmpty(t)
  if not t then return true end
  return next(t) == nil
end

function FLib.utils.table.areEqual(a, b)
  if a == b then return true end
  if type(a) ~= "table" or type(b) ~= "table" then return false end
  for k, v in pairs(a) do
    if not FLib.utils.table.areEqual(v, b[k]) then return false end
  end
  for k in pairs(b) do if a[k] == nil then return false end end
  return true
end

function FLib.utils.table.orderedPairs(t, sortFunc)
  local keys = {}
  for k in pairs(t) do keys[#keys+1] = k end
  table.sort(keys, sortFunc)
  local i = 0
  return function()
    i = i + 1
    local k = keys[i]
    if k ~= nil then return k, t[k] end
  end
end

--------------------------------------------------------------------------------
-- FLib.utils.units
--------------------------------------------------------------------------------
FLib.utils.units = FLib.utils.units or {}

function FLib.utils.units.getLocalisedUnit(value, unitString, precision)
  if type(value) == "string" then
    return {"", value, " ", unitString or ""}
  end
  local prefixes = {"", "k", "M", "G", "T", "P"}
  local idx = 1
  local v = math.abs(value or 0)
  while v >= 1000 and idx < #prefixes do v = v / 1000; idx = idx + 1 end
  if (value or 0) < 0 then v = -v end
  local fmt = "%." .. tostring(precision or 0) .. "f"
  local formatted = string.format(fmt, v)
  local prefix = prefixes[idx]
  if type(unitString) == "table" then
    return {"", formatted .. " " .. prefix, unitString}
  else
    return {"", formatted .. " " .. prefix .. (unitString or "")}
  end
end
