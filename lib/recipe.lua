---@diagnostic disable: undefined-global, inject-field, assign-type-mismatch, param-type-mismatch, redundant-parameter, missing-fields, deprecated, duplicate-set-field, different-requires, redefined-local, undefined-field, need-check-nil, cast-local-type
-- FLib.recipe — prototype-stage recipe helpers.
-- API signatures match the original FLib.

FLib.recipe = FLib.recipe or {}

local function getRecipe(recipeName)
  if not data or not data.raw or not data.raw["recipe"] then return nil end
  return data.raw["recipe"][recipeName]
end

function FLib.recipe.getIcons(recipeName)
  local recipe = getRecipe(recipeName)
  if not recipe then return nil end
  if recipe.icons then
    return util.table.deepcopy(recipe.icons)
  elseif recipe.icon then
    return {{icon = recipe.icon, icon_size = recipe.icon_size or 64}}
  end
  -- Try getting icons from the main product
  if recipe.main_product then
    local icons = FLib.item.getIcons(nil, recipe.main_product)
    if icons then return icons end
  end
  -- Try first result
  local results = recipe.results
  if results and results[1] then
    local name = results[1].name or results[1][1]
    if name then
      local icons = FLib.item.getIcons(nil, name)
      if icons then return icons end
    end
  end
  return nil
end

--- addIngredient(recipeName, ingredientName, amount)
--- Original FLib signature: 3 args, no type (defaults to "item").
function FLib.recipe.addIngredient(recipeName, ingredientName, amount)
  local recipe = getRecipe(recipeName)
  if not recipe then return end
  recipe.ingredients = recipe.ingredients or {}
  table.insert(recipe.ingredients, {type = "item", name = ingredientName, amount = amount or 1})
end

function FLib.recipe.removeIngredient(recipeName, ingredientName)
  local recipe = getRecipe(recipeName)
  if not recipe or not recipe.ingredients then return end
  for i = #recipe.ingredients, 1, -1 do
    local ing = recipe.ingredients[i]
    local name = ing.name or ing[1]
    if name == ingredientName then
      table.remove(recipe.ingredients, i)
      return
    end
  end
end

function FLib.recipe.editIngredient(recipeName, ingredientName, newAmount)
  local recipe = getRecipe(recipeName)
  if not recipe or not recipe.ingredients then return end
  for _, ing in pairs(recipe.ingredients) do
    local name = ing.name or ing[1]
    if name == ingredientName then
      if ing.name then
        ing.amount = newAmount
      else
        ing[2] = newAmount
      end
      return
    end
  end
end

function FLib.recipe.disable(recipeName)
  local recipe = getRecipe(recipeName)
  if recipe then recipe.enabled = false end
end

function FLib.recipe.setLocalisedName(recipeName, localisedName)
  local recipe = getRecipe(recipeName)
  if recipe then recipe.localised_name = localisedName end
end

function FLib.recipe.setMainResult(recipeName, mainResult)
  local recipe = getRecipe(recipeName)
  if recipe then recipe.main_product = mainResult end
end

function FLib.recipe.setShowProduct(recipeName, showProduct)
  local recipe = getRecipe(recipeName)
  if recipe then recipe.always_show_products = showProduct end
end
