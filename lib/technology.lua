---@diagnostic disable: undefined-global, inject-field, assign-type-mismatch, param-type-mismatch, redundant-parameter, missing-fields, deprecated, duplicate-set-field, different-requires, redefined-local, undefined-field, need-check-nil, cast-local-type
-- FLib.technology — prototype-stage technology helpers.
-- API signatures match the original FLib.

FLib.technology = FLib.technology or {}

local function getTech(techName)
  if not data or not data.raw or not data.raw["technology"] then return nil end
  return data.raw["technology"][techName]
end

function FLib.technology.addRecipeUnlock(techName, recipeName)
  local tech = getTech(techName)
  if not tech then return end
  tech.effects = tech.effects or {}
  for _, effect in pairs(tech.effects) do
    if effect.type == "unlock-recipe" and effect.recipe == recipeName then return end
  end
  table.insert(tech.effects, {type = "unlock-recipe", recipe = recipeName})
end

--- moveRecipeUnlock(fromTechName, toTechName, recipeName)
--- Original FLib signature: move a recipe unlock from one tech to another.
--- Note: some callers use (recipeName, fromTech, toTech) and some use
--- (fromTech, toTech, recipeName). The mod's wrapper in modded-final-fixes.lua
--- uses (from_technology, to_technology, recipe_name).
function FLib.technology.moveRecipeUnlock(fromTechName, toTechName, recipeName)
  -- Remove from old tech
  local fromTech = getTech(fromTechName)
  if fromTech and fromTech.effects then
    for i = #fromTech.effects, 1, -1 do
      if fromTech.effects[i].type == "unlock-recipe" and fromTech.effects[i].recipe == recipeName then
        table.remove(fromTech.effects, i)
      end
    end
  end
  -- Add to new tech
  FLib.technology.addRecipeUnlock(toTechName, recipeName)
end

function FLib.technology.addPrerequisite(techName, prerequisiteName)
  local tech = getTech(techName)
  if not tech then return end
  tech.prerequisites = tech.prerequisites or {}
  for _, p in pairs(tech.prerequisites) do
    if p == prerequisiteName then return end
  end
  table.insert(tech.prerequisites, prerequisiteName)
end

function FLib.technology.removePrerequisite(techName, prerequisiteName)
  local tech = getTech(techName)
  if not tech or not tech.prerequisites then return end
  for i = #tech.prerequisites, 1, -1 do
    if tech.prerequisites[i] == prerequisiteName then
      table.remove(tech.prerequisites, i)
      return
    end
  end
end

--- addIngredient(techName, amount, ingredientName)
--- Original FLib signature: (techName, amount, ingredientName).
function FLib.technology.addIngredient(techName, amount, ingredientName)
  local tech = getTech(techName)
  if not tech or not tech.unit then return end
  tech.unit.ingredients = tech.unit.ingredients or {}
  for _, ing in pairs(tech.unit.ingredients) do
    local name = ing.name or ing[1]
    if name == ingredientName then return end
  end
  table.insert(tech.unit.ingredients, {ingredientName, amount})
end

function FLib.technology.removeIngredient(techName, ingredientName)
  local tech = getTech(techName)
  if not tech or not tech.unit or not tech.unit.ingredients then return end
  for i = #tech.unit.ingredients, 1, -1 do
    local ing = tech.unit.ingredients[i]
    local name = ing.name or ing[1]
    if name == ingredientName then
      table.remove(tech.unit.ingredients, i)
      return
    end
  end
end
