return {
	-- Golden Grin Casino
	kenaz = {
		{	-- guis/dlcs/kenaz/textures/pd2/pre_planning/kenaz_loc_b_df
			index = 2, -- Casino Inside
			size = { w = 1024, h = 2048 },
			scale = 0.6,
			x1_override = -5575,
			x2_override = 4975,
			y1_override = -13750,
			y2_override = 7350,
			bounding_boxes = {
				{	-- Main 1
					x = { min = -1200, max = 1200 },
					y = { min = -7400, max = -6500 },
				},
				{	-- Main 2
					x = { min = -1600, max = 1600 },
					y = { min = -6500, max = -4600 },
				},
				{	-- Main 2 First Floor
					x = { min = -2400, max = 2400 },
					y = { min = -6500, max = -4600 },
					z = { min = 500 },
				},
				{	-- Main 3
					x = { min = -1800, max = 1800},
					y = { min = -4600 },
				},
				{	-- VIP Area
					x = { min = 1800, max = 3200 },
					y = { min = -4600, max = -3400 },
					z = { max = 500 },
				},
				{	-- Gentlemen
					x = { min = -3000, max = -1800 },
					y = { min = -1800 },
					z = { max = 500 },
				},
				{	-- Ladies
					x = { min = 1800, max = 3200 },
					y = { min = -1700 },
					z = { max = 500 },
				},
				{	-- Main 4 Left
					x = { min = -3400, max = -1800 },
					y = { min = -1000 },
				},
				{	-- Main 4 Right
					x = { min = 1800, max = 3400 },
					y = { min = -800 },
				},
			},
		},
		{	-- guis/dlcs/kenaz/textures/pd2/pre_planning/kenaz_loc_a_df
			index = 1, -- Casino Outside
			size = { w = 1024, h = 2048 },
			scale = 0.6,
			x1_override = -5575,
			x2_override = 4975,
			y1_override = -13750,
			y2_override = 7350,
		},
	},
}