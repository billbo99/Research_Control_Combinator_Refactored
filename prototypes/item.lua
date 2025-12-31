local item = table.deepcopy(data.raw["item"]["constant-combinator"])

item.name = "Research_Control_Combinator"
item.place_result = "Research_Control_Combinator"
item.order = "z[Research_Control_Combinator]"
item.icons = {
    {
        icon = data.raw["constant-combinator"]["constant-combinator"].icon,
        icon_size = data.raw["constant-combinator"]["constant-combinator"].icon_size,
        tint = { r = 0.5, g = 0.5, b = 1.0, a = 1.0 },
        icon_mipmaps = 4
    }
}

data:extend({item})
