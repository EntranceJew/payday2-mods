return {
	-- Shadow Raid
	kosugi = {
		{	-- guis/textures/pd2/pre_planning/shadow_raid_2
			index = 2, -- Warehouse Roof
			size = { w = 2048, h = 2048 },
			scale = 0.3,
			bounds = {
				x = { min = -3830, max = 680 },
				y = { min = -5680, max = -1170 },
				z = { min = 1600 },
			},
		},
		{	-- guis/textures/pd2/pre_planning/shadow_raid_3
			index = 3, -- Warehouse Top Floor
			size = { w = 2048, h = 2048 },
			scale = 0.25,
			bounds = {
				x = { min = -3830, max = 680 },
				y = { min = -6080, max = -1170 },
				z = { min = 1200 },
			},
		},
		{	-- guis/textures/pd2/pre_planning/shadow_raid_4
			index = 4, -- Warehouse Ground Floor
			size = { w = 2048, h = 2048 },
			scale = 0.25,
			bounding_boxes = {
				{
					x = { min = -3830, max = 680 },
					y = { min = -5680, max = -1170 },
					z = { min = 800 },
				},
				{
					x = { min = 680, max = 1480 },
					y = { min = -5250, max = -3600 },
					z = { min = 800, max = 1200 },
				},
			},
		},
		{	-- guis/textures/pd2/pre_planning/shadow_raid_1
			index = 1, -- Compound Exterior
			size = { w = 2048, h = 2048 },
			scale = 0.25,
		},
	},
}