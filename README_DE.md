# FactoryLib

Modding-Utility-Bibliothek für Factorio 2.1. Stellt Hilfsfunktionen für Prototyp-Manipulation, GUI-Bau und allgemeine Lua-Helfer bereit.

FactoryLib wurde als eigenständiger Ersatz für [LSlib / LSlib_James_Fork](https://mods.factorio.com/mod/LSlib_James_Fork) entwickelt, da diese Bibliothek seit Dezember 2024 kein Update mehr erhalten hat und unklar ist, ob sie ein Factorio-2.1-Update bekommen wird.

## Installation

1. `FactoryLib`-ZIP in den Factorio-Mods-Ordner legen (`~/.factorio/mods/` bzw. `%APPDATA%\Factorio\mods\`)
2. In deiner Mod `info.json` als Dependency eintragen:

```json
{
  "dependencies": [
    "FactoryLib >= 0.2.1"
  ]
}
```

3. In `data.lua`, `control.lua` oder wo du die Funktionen brauchst:

```lua
require("__FactoryLib__/FactoryLib")
```

Danach ist die globale Variable `FLib` verfügbar.

## Verfügbare Module

### `FLib.utils` — Allgemeine Helfer

#### Richtungen

```lua
FLib.utils.directions.oposite(direction)           -- Gegenrichtung (z.B. north → south)
FLib.utils.directions.opposite(direction)           -- Alias für oposite
FLib.utils.directions.toString(direction)            -- Direction-Enum → "north", "east", ...
FLib.utils.directions.orientationTo4WayDirection(o)  -- Orientation (0–1) → 4-Wege-Direction
```

#### Strings

```lua
FLib.utils.string.split(inputstring, separator)  -- String splitten → Array
```

#### Tabellen

```lua
FLib.utils.table.isEmpty(t)            -- true wenn nil oder leer
FLib.utils.table.areEqual(a, b)        -- Deep-Compare zweier Tabellen
FLib.utils.table.orderedPairs(t, fn)   -- Geordneter Iterator (optional mit Sort-Funktion)
```

#### Einheiten

```lua
FLib.utils.units.getLocalisedUnit(value, unitString, precision)
-- Gibt einen Factorio Localised-String zurück, z.B. {"", "150 k", {"si-unit-symbol-watt"}}
-- value:     Zahlenwert
-- unitString: String oder Localised-String-Table für die Einheit
-- precision:  Anzahl Nachkommastellen (optional, Standard: 0)
```

---

### `FLib.item` — Item-Prototyp-Helfer

Alle Funktionen nehmen `(itemType, itemName, ...)` als Parameter.

```lua
FLib.item.getIcons(itemType, itemName, scale?, shift?)
-- Gibt eine Kopie der Icon-Layer zurück. Optional mit Scale/Shift auf allen Layern.

FLib.item.getIconSize(itemType, itemName)
-- Gibt {size} als Table zurück, z.B. {64}

FLib.item.getSubgroup(itemType, itemName)
FLib.item.setSubgroup(itemType, itemName, subgroup)

FLib.item.getOrderstring(itemType, itemName)
FLib.item.setOrderstring(itemType, itemName, order)

FLib.item.setHidden(itemType, itemName, hidden?)  -- hidden default: true
```

**Beispiel:**

```lua
-- Alle Loko-Icons holen, 40% skaliert und nach links-unten verschoben
local icons = FLib.item.getIcons("item-with-entity-data", "locomotive", 0.4, {-20, 19})

-- Rail-Planner in eigene Subgruppe verschieben
FLib.item.setSubgroup("rail-planner", "rail", "my-custom-subgroup")
FLib.item.setOrderstring("rail-planner", "rail", "a[rail]-a[stone]")
```

---

### `FLib.recipe` — Rezept-Prototyp-Helfer

```lua
FLib.recipe.getIcons(recipeName)
-- Gibt Icons des Rezepts zurück (oder die des Hauptprodukts als Fallback)

FLib.recipe.addIngredient(recipeName, ingredientName, amount)
FLib.recipe.removeIngredient(recipeName, ingredientName)
FLib.recipe.editIngredient(recipeName, ingredientName, newAmount)

FLib.recipe.disable(recipeName)
FLib.recipe.setLocalisedName(recipeName, localisedName)
FLib.recipe.setMainResult(recipeName, mainResult)
FLib.recipe.setShowProduct(recipeName, showProduct)
```

**Beispiel:**

```lua
-- Kohle aus einem Rezept entfernen und durch Holz ersetzen
FLib.recipe.removeIngredient("my-recipe", "coal")
FLib.recipe.addIngredient("my-recipe", "wood", 5)
```

---

### `FLib.technology` — Technologie-Prototyp-Helfer

```lua
FLib.technology.addRecipeUnlock(techName, recipeName)
FLib.technology.moveRecipeUnlock(fromTechName, toTechName, recipeName)

FLib.technology.addPrerequisite(techName, prerequisiteName)
FLib.technology.removePrerequisite(techName, prerequisiteName)

FLib.technology.addIngredient(techName, amount, ingredientName)
FLib.technology.removeIngredient(techName, ingredientName)
```

**Beispiel:**

```lua
-- Rezept von einer Technologie zur anderen verschieben
FLib.technology.moveRecipeUnlock("old-tech", "new-tech", "my-recipe")
```

---

### `FLib.entity` — Entity-Prototyp-Helfer

```lua
FLib.entity.getIcons(entityType, entityName)
-- Gibt Icons eines Entity-Prototyps zurück
```

---

### `FLib.gui.layout` — Deklarativer GUI-Layoutbauer

Baut eine Baumstruktur, die eine GUI-Hierarchie beschreibt. Jeder Knoten speichert seinen vollständigen Pfad vom Root, seine Eigenschaften und Kinder. Der Baum wird zur Data-/Control-Ladezeit aufgebaut und dann zur Laufzeit über `FLib.gui.create()` gerendert.

```lua
-- Neues Layout erstellen (Anker: "screen", "top", "left", "center", "relative", "goal")
local layout = FLib.gui.layout.create("screen")

-- Elemente hinzufügen — gibt jeweils den Pfad-String zurück
local framePath = FLib.gui.layout.addFrame(layout, "root", "my-frame", "vertical", {
  style = "frame", caption = "Mein Fenster",
})

local flowPath = FLib.gui.layout.addFlow(layout, framePath, "my-flow", "horizontal")

FLib.gui.layout.addLabel(layout, flowPath, "my-label", {
  caption = "Hallo Welt!", style = "label",
})

FLib.gui.layout.addButton(layout, flowPath, "my-button", {
  caption = "Klick mich", style = "button",
})
```

#### Alle Layout-Funktionen

| Funktion | Beschreibung |
|----------|-------------|
| `create(anchor)` | Neuen Layout-Baum erstellen |
| `addFrame(layout, parent, name, direction, options?)` | Frame hinzufügen |
| `addFlow(layout, parent, name, direction, options?)` | Flow hinzufügen |
| `addLabel(layout, parent, name, options?)` | Label hinzufügen |
| `addButton(layout, parent, name, options?)` | Button hinzufügen |
| `addSpriteButton(layout, parent, name, options?)` | Sprite-Button hinzufügen |
| `addTextfield(layout, parent, name, options?)` | Textfeld hinzufügen |
| `addListbox(layout, parent, name, options?)` | Listbox hinzufügen |
| `addTable(layout, parent, name, columns, options?)` | Tabelle hinzufügen |
| `addSlider(layout, parent, name, options?)` | Slider hinzufügen |
| `addScrollPane(layout, parent, name, options?)` | Scroll-Bereich hinzufügen |
| `addEntityPreview(layout, parent, name, options?)` | Entity-Vorschau hinzufügen |
| `addEmptyWidget(layout, parent, name, options?)` | Leeres Widget (z.B. für Drag-Target) |
| `addSprite(layout, parent, name, options?)` | Sprite hinzufügen |
| `addTabs(layout, parent, name, pages, tabOptions)` | Tab-System mit Buttons + Content-Frames |
| `getElement(layout, path)` | Knoten im Baum per Pfad finden |
| `getElementPath(layout, elementName)` | Pfad eines benannten Elements suchen |
| `getTabContentFrameFlow(layout, contentPath, index)` | Pfad des N-ten Tab-Inhalts |

---

### `FLib.gui` — Runtime GUI-Verwaltung

```lua
-- GUI aus Layout-Baum für einen Spieler erstellen
local rootElement = FLib.gui.create(playerIndex, layout)
-- Screen-GUIs werden automatisch zentriert

-- GUI wieder entfernen
FLib.gui.destroy(playerIndex, layout)

-- Element per Pfad-String finden (Format: "root(screen)/frame/child/...")
local element = FLib.gui.getElement(playerIndex, "root(screen)/my-frame/my-flow/my-label")
element.caption = "Neuer Text!"

-- Name des Root-Elements im Layout
local rootName = FLib.gui.getRootElementName(layout)
```

**Drag-Unterstützung:** `addEmptyWidget` mit `drag_target` macht Screen-Fenster verschiebbar:

```lua
FLib.gui.layout.addEmptyWidget(layout, headerFlow, "dragger", {
  drag_target = framePath,  -- Pfad des zu ziehenden Frames
  style = "draggable_space_header",
})
```

---

### `FLib.styles` — GUI-Style-Helfer

```lua
FLib.styles.addButtonStyle(styleName, options)
FLib.styles.addLabelStyle(styleName, options)
FLib.styles.addTableStyle(styleName, options)
```

---

## Lizenz

MIT — Frei verwendbar für alle Factorio-Mods.

## Autor

Marcel171297
