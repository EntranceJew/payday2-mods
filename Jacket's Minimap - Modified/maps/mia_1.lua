return {
	-- Hotline Miami
	mia_1 = {
		{	-- guis/textures/pd2/pre_planning/hlm_03
			index = 3, -- Upper Motel Interior
			size = { w = 1024, h = 512 },
			scale = 0.5,
			bounds = {
				x = { min = -650, max = 5600 },
				y = { min = -4450, max = -1350 },
				z = { min = 300 },
			},
		},
		{	-- guis/textures/pd2/pre_planning/hlm_02
			index = 2, -- Motel Interior
			size = { w = 1024, h = 512 },
			scale = 0.5,
			bounding_boxes = {
				{
					x = { min = -650, max = 5600 },
					y = { min = -4450, max = -3350 },
					z = { min = -150 },
				},
				{
					x = { min = -650, max = 450 },
					y = { min = -3350, max = -1950 },
					z = { min = -150 },
				},
				{
					x = { min = 4500, max = 5600 },
					y = { min = -3350, max = -1350 },
					z = { min = -150 },
				},
			},
		},
		{	-- guis/textures/pd2/pre_planning/hlm_01
			index = 1, -- Motel Exterior
			size = { w = 2048, h = 1024 },
			scale = 0.35,
		},
	},
}