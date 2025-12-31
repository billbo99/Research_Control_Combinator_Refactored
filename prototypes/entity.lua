local combinator = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
combinator.localised_name = { "", "Research Control Combinator" }
combinator.name = "Research_Control_Combinator"
combinator.minable = { mining_time = 0.1, result = "Research_Control_Combinator" }
combinator.item_slot_count = 10
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
combinator.sprites.north.layers[1].tint = { r = 0.5, g = 0.5, b = 1.0, a = 1.0 }
combinator.sprites.east.layers[1].tint = { r = 0.5, g = 0.5, b = 1.0, a = 1.0 }
combinator.sprites.south.layers[1].tint = { r = 0.5, g = 0.5, b = 1.0, a = 1.0 }
combinator.sprites.west.layers[1].tint = { r = 0.5, g = 0.5, b = 1.0, a = 1.0 }

data:extend({ combinator })
