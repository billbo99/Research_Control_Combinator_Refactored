local item = table.deepcopy(data.raw["item"]["constant-combinator"])

item.name = "Research_Control_Combinator"
item.place_result = item.name
item.order = "z[" .. item.name .. "]"
item.icons = {
    {
        icon = data.raw["constant-combinator"]["constant-combinator"].icon,
        icon_size = data.raw["constant-combinator"]["constant-combinator"].icon_size,
        tint = { r = 0.5, g = 0.5, b = 1.0, a = 1.0 },
        icon_mipmaps = 4
    }
}

data:extend({item})


local item2 = table.deepcopy(data.raw["item"]["constant-combinator"])

item2.name = "Research_Tracker_Combinator"
item2.place_result = item2.name
item2.order = "z[" .. item2.name .. "]"
item2.icons = {
    {
        icon = data.raw["constant-combinator"]["constant-combinator"].icon,
        icon_size = data.raw["constant-combinator"]["constant-combinator"].icon_size,
        tint = { r = 0.5, g = 1.0, b = 0.5, a = 1.0 },
        icon_mipmaps = 4
    }
}

data:extend({item2})
