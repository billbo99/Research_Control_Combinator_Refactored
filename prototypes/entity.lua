local combinator = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
combinator.name = "Research_Control_Combinator"
combinator.localised_name = { "", "Research Control Combinator" }
combinator.minable = { mining_time = 0.1, result = combinator.name }
combinator.item_slot_count = 1
combinator.icons = {
    {
        icon = data.raw["constant-combinator"]["constant-combinator"].icon,
        icon_size = data.raw["constant-combinator"]["constant-combinator"].icon_size,
        tint = { r = 0.5, g = 0.5, b = 1.0, a = 1.0 },
        icon_mipmaps = 4
    }
}
combinator.icon = data.raw["constant-combinator"]["constant-combinator"].icon
combinator.icon_size = data.raw["constant-combinator"]["constant-combinator"].icon_size
combinator.control_behavior = nil
combinator.sprites.north.layers[1].tint = combinator.icons[1].tint
combinator.sprites.east.layers[1].tint = combinator.icons[1].tint
combinator.sprites.south.layers[1].tint = combinator.icons[1].tint
combinator.sprites.west.layers[1].tint = combinator.icons[1].tint

data:extend({ combinator })


local combinator2 = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
combinator2.name = "Research_Tracker_Combinator"
combinator2.localised_name = { "", "Research Tracker Combinator" }
combinator2.minable = { mining_time = 0.1, result = combinator2.name }
combinator2.item_slot_count = 40
combinator2.icons = {
    {
        icon = data.raw["constant-combinator"]["constant-combinator"].icon,
        icon_size = data.raw["constant-combinator"]["constant-combinator"].icon_size,
        tint = { r = 0.5, g = 1.0, b = 0.5, a = 1.0 },
        icon_mipmaps = 4
    }
}
combinator2.icon = data.raw["constant-combinator"]["constant-combinator"].icon
combinator2.icon_size = data.raw["constant-combinator"]["constant-combinator"].icon_size
combinator2.control_behavior = nil
combinator2.sprites.north.layers[1].tint = combinator2.icons[1].tint
combinator2.sprites.east.layers[1].tint = combinator2.icons[1].tint
combinator2.sprites.south.layers[1].tint = combinator2.icons[1].tint
combinator2.sprites.west.layers[1].tint = combinator2.icons[1].tint

data:extend({ combinator2 })
