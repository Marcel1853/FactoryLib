# FactoryLib

Modding utility library for Factorio 2.1. Provides helper functions for prototype manipulation, GUI building, and common Lua utilities.

FactoryLib was created as a standalone replacement for [LSlib / LSlib_James_Fork](https://mods.factorio.com/mod/LSlib_James_Fork), which has not been updated since December 2024 and may not receive a Factorio 2.1 update.

## Installation

1. Place the `FactoryLib` ZIP into your Factorio mods folder (`~/.factorio/mods/` or `%APPDATA%\Factorio\mods\`)
2. Add it as a dependency in your mod's `info.json`:

```json
{
  "dependencies": [
    "FactoryLib >= 0.2.1"
  ]
}
```

3. Require it in `data.lua`, `control.lua`, or wherever you need it:

```lua
require("__FactoryLib__/FactoryLib")
```

The global variable `FLib` is now available.

## Available Modules

### `FLib.utils` — General Helpers

#### Directions

```lua
FLib.utils.directions.oposite(direction)           -- Opposite direction (e.g. north → south)
FLib.utils.directions.opposite(direction)           -- Alias for oposite
FLib.utils.directions.toString(direction)            -- Direction enum → "north", "east", ...
FLib.utils.directions.orientationTo4WayDirection(o)  -- Orientation (0–1) → 4-way direction
```

#### Strings

```lua
FLib.utils.string.split(inputstring, separator)  -- Split string → array
```

#### Tables

```lua
FLib.utils.table.isEmpty(t)            -- true if nil or empty
FLib.utils.table.areEqual(a, b)        -- Deep comparison of two tables
FLib.utils.table.orderedPairs(t, fn)   -- Ordered iterator (optional sort function)
```

#### Units

```lua
FLib.utils.units.getLocalisedUnit(value, unitString, precision)
-- Returns a Factorio localised string, e.g. {"", "150 k", {"si-unit-symbol-watt"}}
-- value:      numeric value
-- unitString: string or localised string table for the unit
-- precision:  decimal places (optional, default: 0)
```

---

### `FLib.item` — Item Prototype Helpers

All functions take `(itemType, itemName, ...)` as parameters.

```lua
FLib.item.getIcons(itemType, itemName, scale?, shift?)
-- Returns a deep copy of the icon layers. Optionally applies scale/shift to all layers.

FLib.item.getIconSize(itemType, itemName)
-- Returns {size} as a table, e.g. {64}

FLib.item.getSubgroup(itemType, itemName)
FLib.item.setSubgroup(itemType, itemName, subgroup)

FLib.item.getOrderstring(itemType, itemName)
FLib.item.setOrderstring(itemType, itemName, order)

FLib.item.setHidden(itemType, itemName, hidden?)  -- hidden defaults to true
```

**Example:**

```lua
-- Get locomotive icons at 40% scale, shifted to bottom-left
local icons = FLib.item.getIcons("item-with-entity-data", "locomotive", 0.4, {-20, 19})

-- Move rail planner into a custom subgroup
FLib.item.setSubgroup("rail-planner", "rail", "my-custom-subgroup")
FLib.item.setOrderstring("rail-planner", "rail", "a[rail]-a[stone]")
```

---

### `FLib.recipe` — Recipe Prototype Helpers

```lua
FLib.recipe.getIcons(recipeName)
-- Returns the recipe's icons (falls back to main product icons)

FLib.recipe.addIngredient(recipeName, ingredientName, amount)
FLib.recipe.removeIngredient(recipeName, ingredientName)
FLib.recipe.editIngredient(recipeName, ingredientName, newAmount)

FLib.recipe.disable(recipeName)
FLib.recipe.setLocalisedName(recipeName, localisedName)
FLib.recipe.setMainResult(recipeName, mainResult)
FLib.recipe.setShowProduct(recipeName, showProduct)
```

**Example:**

```lua
-- Replace coal with wood in a recipe
FLib.recipe.removeIngredient("my-recipe", "coal")
FLib.recipe.addIngredient("my-recipe", "wood", 5)
```

---

### `FLib.technology` — Technology Prototype Helpers

```lua
FLib.technology.addRecipeUnlock(techName, recipeName)
FLib.technology.moveRecipeUnlock(fromTechName, toTechName, recipeName)

FLib.technology.addPrerequisite(techName, prerequisiteName)
FLib.technology.removePrerequisite(techName, prerequisiteName)

FLib.technology.addIngredient(techName, amount, ingredientName)
FLib.technology.removeIngredient(techName, ingredientName)
```

**Example:**

```lua
-- Move a recipe unlock from one technology to another
FLib.technology.moveRecipeUnlock("old-tech", "new-tech", "my-recipe")
```

---

### `FLib.entity` — Entity Prototype Helpers

```lua
FLib.entity.getIcons(entityType, entityName)
-- Returns icons of an entity prototype
```

---

### `FLib.gui.layout` — Declarative GUI Layout Builder

Builds a tree structure describing a GUI hierarchy. Each node stores its full path from root, its properties, and children. The tree is constructed at data/control load time and rendered at runtime via `FLib.gui.create()`.

```lua
-- Create a new layout (anchor: "screen", "top", "left", "center", "relative", "goal")
local layout = FLib.gui.layout.create("screen")

-- Add elements — each returns the path string of the new node
local framePath = FLib.gui.layout.addFrame(layout, "root", "my-frame", "vertical", {
  style = "frame", caption = "My Window",
})

local flowPath = FLib.gui.layout.addFlow(layout, framePath, "my-flow", "horizontal")

FLib.gui.layout.addLabel(layout, flowPath, "my-label", {
  caption = "Hello World!", style = "label",
})

FLib.gui.layout.addButton(layout, flowPath, "my-button", {
  caption = "Click me", style = "button",
})
```

#### All Layout Functions

| Function | Description |
|----------|-------------|
| `create(anchor)` | Create a new layout tree |
| `addFrame(layout, parent, name, direction, options?)` | Add a frame |
| `addFlow(layout, parent, name, direction, options?)` | Add a flow |
| `addLabel(layout, parent, name, options?)` | Add a label |
| `addButton(layout, parent, name, options?)` | Add a button |
| `addSpriteButton(layout, parent, name, options?)` | Add a sprite button |
| `addTextfield(layout, parent, name, options?)` | Add a text field |
| `addListbox(layout, parent, name, options?)` | Add a list box |
| `addTable(layout, parent, name, columns, options?)` | Add a table |
| `addSlider(layout, parent, name, options?)` | Add a slider |
| `addScrollPane(layout, parent, name, options?)` | Add a scroll pane |
| `addEntityPreview(layout, parent, name, options?)` | Add an entity preview |
| `addEmptyWidget(layout, parent, name, options?)` | Add an empty widget (e.g. for drag targets) |
| `addSprite(layout, parent, name, options?)` | Add a sprite |
| `addTabs(layout, parent, name, pages, tabOptions)` | Add a tab system with buttons and content frames |
| `getElement(layout, path)` | Find a node in the tree by path |
| `getElementPath(layout, elementName)` | Search for a named element and return its path |
| `getTabContentFrameFlow(layout, contentPath, index)` | Get the path of the Nth tab content |

---

### `FLib.gui` — Runtime GUI Management

```lua
-- Build a GUI from a layout tree for a player
local rootElement = FLib.gui.create(playerIndex, layout)
-- Screen GUIs are automatically centered

-- Destroy the GUI
FLib.gui.destroy(playerIndex, layout)

-- Find an element by its path string (format: "root(screen)/frame/child/...")
local element = FLib.gui.getElement(playerIndex, "root(screen)/my-frame/my-flow/my-label")
element.caption = "New text!"

-- Get the root element name of a layout
local rootName = FLib.gui.getRootElementName(layout)
```

**Drag support:** Use `addEmptyWidget` with `drag_target` to make screen windows draggable:

```lua
FLib.gui.layout.addEmptyWidget(layout, headerFlow, "dragger", {
  drag_target = framePath,  -- Path of the frame to drag
  style = "draggable_space_header",
})
```

---

### `FLib.styles` — GUI Style Helpers

```lua
FLib.styles.addButtonStyle(styleName, options)
FLib.styles.addLabelStyle(styleName, options)
FLib.styles.addTableStyle(styleName, options)
```

---

## License

MIT — Free to use in any Factorio mod.

## Author

Marcel171297
