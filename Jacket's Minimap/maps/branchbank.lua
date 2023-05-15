return {
	-- Bank Heist
	branchbank = {
		{	-- guis/textures/pd2/pre_planning/branchbank_1
			index = 1, -- Bank Interior
			size = { w = 2048, h = 2048 },
			scale = 0.2,
			bounding_boxes = {
				{
					x = { min = -2800, max = -1200 },
					y = { min = 0, max = 1200 },
					z = { max = 300 },
				},
				{
					x = { min = -3200, max = -1600 },
					y = { min = 1200, max = 2800 },
					z = { max = 300 },
				},
				{
					x = { min = -1600, max = 0 },
					y = { min = 800, max = 3200 },
					z = { max = 300 },
				},
				{
					x = { min = -1600, max = -800 },
					y = { min = 3200, max = 3500 },
					z = { max = 300 },
				},
			},
		},
		{	-- guis/textures/pd2/pre_planning/branchbank_2
			index = 2, -- Bank Exterior
			size = { w = 2048, h = 2048 },
			scale = 0.2,
		},
	},
}