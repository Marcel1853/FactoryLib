---@diagnostic disable: undefined-global, inject-field, assign-type-mismatch, param-type-mismatch, redundant-parameter, missing-fields, deprecated, duplicate-set-field, different-requires, redefined-local, undefined-field, need-check-nil, cast-local-type
-- FactoryLib — Modding utility library for Factorio 2.1.
-- Exposes the global `FLib` table for prototype and runtime helpers.

if rawget(_G, "FLib") then return end -- already loaded

FLib = {}

require("__FactoryLib__/lib/utils")
require("__FactoryLib__/lib/item")
require("__FactoryLib__/lib/recipe")
require("__FactoryLib__/lib/technology")
require("__FactoryLib__/lib/entity")

-- GUI modules are only available in runtime (control.lua) and data-stage layout definitions.
require("__FactoryLib__/lib/gui_layout")
require("__FactoryLib__/lib/gui")
require("__FactoryLib__/lib/styles")
