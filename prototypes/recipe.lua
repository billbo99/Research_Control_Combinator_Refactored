local recipe = table.deepcopy(data.raw["recipe"]["constant-combinator"])

recipe.name = "Research_Control_Combinator"
recipe.enabled = true
recipe.ingredients = {
    {type = "item", name = "electronic-circuit", amount = 5},
    {type = "item", name = "iron-plate", amount = 2}
}
recipe.results = {
    {type = "item", name = recipe.name, amount = 1}
}
recipe.localised_name = {"", "Research Control Combinator"}

data:extend({ recipe })

local recipe2 = table.deepcopy(data.raw["recipe"]["constant-combinator"])

recipe2.name = "Research_Tracker_Combinator"
recipe2.enabled = true
recipe2.ingredients = {
    {type = "item", name = "electronic-circuit", amount = 5},
    {type = "item", name = "iron-plate", amount = 2}
}
recipe2.results = {
    {type = "item", name = recipe2.name, amount = 1}
}
recipe2.localised_name = {"", "Research Tracker Combinator"}

data:extend({recipe2})