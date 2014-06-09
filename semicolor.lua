jumping = PlayerCanJump()
function fif(test, if_true, if_false)
  if test then return if_true else return if_false end
end

hifi = GetQualityLevel() > 2 -- GetQualityLevel returns 1,2,or 3
function ifhifi(if_true, if_false)
  if hifi then return if_true else return if_false end
end

skinvars = GetSkinProperties()
trackWidth = skinvars["trackwidth"]
curvescaler = skinvars["curvescaler"] or 1
steepscaler = skinvars["steepscaler"] or 1
 
--trackWidth = 16 -- uses a wide water track even for vehicles
fullsteep = jumping or skinvars.prefersteep

SetScene{
	glowpasses = ifhifi(5,2),
	glowspread = ifhifi(4,1),
	radialblur_strength = .5,
--	radialblur_strength = fif(jumping,2,0),
	--environment = "city",
	watertint = {r=255,g=255,b=255,a=200},
	watertexture = "watchadoinsnoopinthroughthesefiles.png",--texture used to color the dynamic "digital water" surface
	towropes = jumping,--use the tow ropes if jumping
	airdebris_count = 0,
	closecam_far = 10,
	--usedefaultrails=false,
	widewater = false,
	watertint_highway = true,
	useblackgrid=true,
	twistmode={curvescaler, steepscaler} -- note: "cork" is the same as {curvescaler=1, steepscaler=1} and "cork_flatish" is the same as {curvescaler=1, steepscaler=.4}
	--skywirecolor={r=255,g=0,b=0}
}

LoadSounds{
	--hit="hit.wav",
	--hitgrey="hitgrey.wav",
	trickfail="silence.wav",
	matchsmall="silence.wav",
	matchmedium="silence.wav",
	matchlarge="silence.wav",
	matchhuge="silence.wav",
	overfillwarning="silence.wav"
}

if not jumping then
	SetBlocks{
		colorblocks={
			--mesh = "DoubleLozenge.obj",
			--shader = fif(ispuzzle, "Diffuse", "RimLight"),
			--texture = "DoubleLozenge.png",
		    height = 0.8,
		    float_on_water = false,
		    scale = {1,0.5,1}
		},
		greyblocks={
			mesh = "DoubleLozenge.obj",
			shader = "RimLight",
			texture = "DoubleLozenge.png"
		}
	}
end

if jumping then
	SetPlayer{
		--showsurfer = true,
		--showboard = true,
		cameramode = "first_jumpthird",
		--cameramode_air = "third",--"first_jumptrickthird", --start in first, go to third for jumps and tricks

		camfirst={ --sets the camera position when in first person mode. Can change this while the game is running.
			pos={0,2.7,-3.50475},
			rot={20.49113,0,0},
			strafefactor = 1
		},
		camthird={ --sets the two camera positions for 3rd person mode. lerps out towards pos2 when the song is less intense
			pos={0,2.7,-3.50475},
			rot={20.49113,0,0},
			strafefactor = 0.75,
			pos2={0,2.8,-3.50475},
			rot2={20.49113,0,0},
			strafefactorFar = 1},
		surfer={ --set all the models used to represent the surfer
			arms={
				--mesh="arm.obj",
				shader="RimLightHatchedSurfer",
				shadercolors={
					_Color={colorsource="highway", scaletype="intensity", minscaler=3, maxscaler=6, param="_Threshold", paramMin=2, paramMax=2},
					_RimColor={0,63,192}
				},
				texture="FullLeftArm_1024_wAO.png"
			},
			--leg={
			--	mesh="foot.obj",
			--	shader="RimLightHatchedSurfer",
			--	shadercolors={
			--		_Color={colorsource="highway", scaletype="intensity", minscaler=3, maxscaler=6, param="_Threshold", paramMin=-1, paramMax=2},
			--		_RimColor={0,49,242}
			--		--_RimColor={colorsource="highway", scaletype="intensity", minscaler=3, maxscaler=3}
			--	},
			--	texture="foot.png"
			--},
			board={
				--mesh="wakeboard.obj",
				shader=ifhifi("RimLightHatchedSurferExternal","VertexColorUnlitTinted"), -- don't use the transparency shader in lofi mode. less fillrate needed that way
				renderqueue=3999,
				shadercolors={ --each color in the shader can be set to a static color, or change every frame like the arm model above
					_Color={colorsource="highway", scaletype="intensity", minscaler=5, maxscaler=5},
					_RimColor={0,0,0}
				},
				shadersettings={
					_Threshold=11
				},
				texture="board_internalOutline.png"
			},
			body={
				--mesh="surferbot.obj",
				shader="RimLightHatchedSurferExternal", -- don't use the transparency shader in lofi mode. less fillrate needed that way
				renderqueue=3000,
				shadercolors={
					_Color={colorsource="highway", scaletype="intensity", minscaler=3, maxscaler=3},
					_RimColor={0,0,0}
				},
				shadersettings={
					_Threshold=1.7
				},
				texture="robot_HighContrast.png"
			}
		}
	}
else
	SetPlayer{
		--showsurfer = false,
		--showboard = false,
		cameramode = "third",
	--	cameramode_air = "first",--"first_jumptrickthird", --start in first, go to third for jumps and tricks

		camfirst={
			pos={0,1.84,-0.8},
			rot={20,0,0}},
		camthird={
			pos={0,3.5,-3},
			rot={30,0,0},
			strafefactorFar = .75,
			pos2={0,5,-4},
			rot2={30,0,0},
			strafefactorFar = 1,
			transitionspeed = 1,
			puzzleoffset=-0.65,
			puzzleoffset2=-1.5},
		vehicle={ --livecoding not supported here
			min_hover_height= 0.23,
			max_hover_height = 0.23, -- 0.75
			use_water_rooster = true,
			roostercolor = {9,9,18,255},
			water_rooster_z_offset = -.81,
            smooth_tilting = true,
            smooth_tilting_speed = 10,
            smooth_tilting_max_offset = -20,
			pos={x=0,y=0,z=0},
			mesh="ASship02.obj",
			shader="VertexColorUnlitTinted",
			shadercolors={
				_Color = {colorsource="highway", scaletype="intensity", minscaler=6, maxscaler=6}},
			texture="ASship02_ao.png",
			scale = {x=1,y=1,z=1},
			thrusters = {crossSectionShape={{-.35,-.35,0},{-.5,0,0},{-.35,.35,0},{0,.5,0},{.35,.35,0},{.5,0,0},{.35,-.35,0}},
						perShapeNodeColorScalers={.5,1,1,1,1,1,.5},
						extrusions=22,
						stretch=-0.1191,
						updateseconds = 0.025,
						instances={
							{pos={0,.15,-1.4},rot={0,0,0},scale={1.2,1.2,1.2}},
							{pos={.4376,.15,-1.4},rot={0,-4,58.713},scale={.5,.5,.5}},
							{pos={-.4376,.15,-1.4},rot={0,4,313.7366},scale={.5,.5,.5}}
						}}
		}
	}
	--[[
	SetPlayer{
		cameramode = "third",

		camfirst={
			pos={0,1.84,-0.8},
			rot={20,0,0},
			strafefactor=1},
		camthird={
			pos={0.66,2,-0.5},
			rot={30,0,0},
			strafefactor=0.66,
			pos2={1,5,-4},
			rot2={30,0,0},
			strafefactorFar=.75,
			transitionspeed = 1,
			puzzleoffset=-0.85,
			puzzleoffset2=-1.75},
		vehicle={ --livecoding not supported here
			pos={x=0,y=0,z=0},
			mesh="vehicle1a.obj",
			shader="VertexColorUnlitTinted",
			shadercolors={
				_Color={r=1,g=1,b=1}},
				--_RimColor={colorsource="highway", scaletype="intensity", minscaler=3, maxscaler=3}},
			texture="vehicle1a_ao.png",
			scale = {x=1,y=1,z=1},
			thrusters = {crossSectionShape={{-.5,.5,0},{.5,.5,0},{.5,-.5,0},{-.5,-.5,0}},
						perShapeNodeColorScalers={1,1,0,0},
						extrusions=22,
						stretch=-0.1191,
						instances={
							{pos={0,.281,-1.33},rot={0,0,0},scale={1,1,1}},
							{pos={.1236,0.2,-1.297},rot={0,0,58.713},scale={.7,.7,.7}},
							{pos={-.1236,0.2,-1.297},rot={0,0,313.7366},scale={.7,.7,.7}}
						}}
			}
	}
	--]]
end

if hifi then
	SetSkybox{
		sky={
			month=2,
			hour=1,
			minute=36,
			longitude=185.6,--175,
			cloudmaxheight=1.2,
			cloudminheight=-1.2,
			clouddensity=0.5,
			cirrusposition=0,
			useProceduralAmbientLight = true,
			useProceduralSunLight = true
		}
	}
else
	SetSkybox{ --this shows how to set up a skybox. There's also a dynamic sky system that's used by the audiosprint skin. It could be used here too.
		custom={
			_FrontTex = "Front.png",
			_BackTex = "Back.png",
			_RightTex = "Right.png",
			_LeftTex = "Left.png",
			_UpTex = "Up.png",
			_DownTex = "Down.png"
		}
	}
end

SetTrackColors{ --enter any number of colors here. The track will use the first ones on less intense sections and interpolate all the way to the last one on the most intense sections of the track
    {r=50, g=50, b=200},
    {r=140, g=100, b=255},
    {r=220, g=30, b=30},
	{r=200, g=200, b=200},
    {r=255,g=255,b=255}
}

SetBlockColors{ --this is only used for puzzle modes (which you don't have yet) with multiple colors of blocks
    {r=50, g=50, b=200},
    {r=140, g=100, b=255},
    {r=220, g=30, b=30},
	{r=200, g=200, b=200},
    {r=255,g=255,b=255}
}

--if hifi then
--	CreateLight{
--		railoffset = -3,
--		range = 10,
--		intensity = 2,
--		transform = {
--			position={0,.5,0}
--		},
--		color="highway"
--	}
--end

SetRings{ --setup the tracks tunnel rings. the airtexture is the tunnel used when you're up in a jump
	texture="aRing_FadedEarringAlphaTestable_1024.png",
	--texture="Classic_OnBlack",
	shader="VertexColorUnlitTintedAddSmooth",
	size=40,
	percentringed=.2,--ifhifi(2,.01),-- .2,
	airtexture="Bits.png",
	airshader="VertexColorUnlitTintedAddSmoothNoDepth",
	airsize=16
}

--if jumping then wakeHeight=(ifhifi(4,2)) else wakeHeight = (ifhifi(4,2)) end
SetWake{ --setup the spray coming from the two pulling "boats"
	height = (ifhifi(4,2)),
	fallrate = 0.95,
	shader = "VertexColorUnlitTintedAddSmooth",
	layer = 13, -- looks better not rendered in background when water surface is not type 2
	bottomcolor = "highway",
	topcolor = {r=0,g=0,b=0}
}

CreateObject{
	name="EndCookie",
	tracknode="end",
	gameobject={
		transform={pos={0,0,126},scale={scaletype="intensity",min={55,99,900},max={66,120,900}}},
		mesh="danishCookie_boxes.obj",
		shader="RimLightHatched",
		shadercolors={
			_Color={0,0,0},
			_RimColor={1,1,1}
		}
	}
}

--This shows that scripted dynamic meshes can be used, but you probably don't need this
--function AddQuadIndices(t, index0, index1, index2, index3)
--	table.insert(t, index0)
--	table.insert(t, index1)
--	table.insert(t, index2)
--	table.insert(t, index1)
--	table.insert(t, index3)
--	table.insert(t, index2)
--end
--
--if mesh1==nil then --if this mesh hasn't been created yet
--	verts = {}
--	verts[1] = {x=-0.5, y=0.5, z=0.5}
--	verts[2] = {x=0.5, y=0.5, z=0.5}
--	verts[3] = {x=-0.5, y=0.5, z=-0.5}
--	verts[4] = {x=0.5, y=0.5, z=-0.5}
--	verts[5] = {x=-0.5, y=-0.5, z=0.5}
--	verts[6] = {x=0.5, y=-0.5, z=0.5}
--	verts[7] = {x=-0.5, y=-0.5, z=-0.5}
--	verts[8] = {x=0.5, y=-0.5, z=-0.5}
--	uvs = {}
--	uvs[1] = {0,1}
--	uvs[2] = {1,1}
--	uvs[3] = {0,1}
--	uvs[4] = {1,1}
--	uvs[5] = {0,0}
--	uvs[6] = {1,0}
--	uvs[7] = {0,0}
--	uvs[8] = {1,0}
--	indices = {}
--	AddQuadIndices(indices, 0, 1, 2, 3)
--	AddQuadIndices(indices, 1, 0, 5, 4)
--	AddQuadIndices(indices, 3, 1, 7, 5)
--	AddQuadIndices(indices, 2, 3, 6, 7)
--	AddQuadIndices(indices, 0, 2, 4, 6)
--	AddQuadIndices(indices, 5, 4, 7, 6)
--
--	mesh1 = BuildMesh{
--		vertextable=verts,
--		indextable=indices,
--		uvtable = uvs,
--		calculatenormals = true
--	}
--end
--
--function Update(dt) --called every frame if it exists
--	for i=1,4 do
--		verts[i].y = dt*100
--	end
--
--	BuildMesh{
--		mesh=mesh1,
--		vertextable = verts,
--		calculatenormals = true
--	}
--end
--[[
CreateObject{ --creates a uniquely named prototype (prefab) that can be used later in the script or by the mod script. The audiosprint mod uses prototypes created in it's skin script
	name="BuildingCloneMe",
	gameobject={
		pos={x=0,y=0,z=0},
		--mesh="skyscraper42.obj",
		mesh="skyscraper_withbase.obj",
		--shader="VertexColorUnlitTintedAlpha",
		shader="PsychoBuilding2",
		diffuseinair = true,
		shadercolors={
			--_Color={r=255,g=255,b=255}
			--_Color="highwaysmooth"
			--_Color = {colorsource="highway", scaletype="intensity", minscaler=6, maxscaler=6}
			_Color = {colorsource="highway", scaletype="intensity", minscaler=2, maxscaler=2}
		},
		texture="White.png",
		--texture="skyscraper.png",
		scale = {x=1,y=1,z=1}
	}
}--]]

--CreateObject{ --creates a uniquely named prototype (prefab) that can be used later in the script or by the mod script. The audiosprint mod uses prototypes created in it's skin script
--	name="BuildingCloneMeToo",
--	gameobject={
--		pos={x=0,y=0,z=0},
--		--mesh="skyscraper42.obj",
--		mesh="skyscraper42_withbase.obj",
--		--shader="VertexColorUnlitTintedAlpha",
--		shader="PsychoBuilding",
--		shadercolors={
--			--_Color={r=255,g=255,b=255}
--			--_Color="highwaysmooth"
--			--_Color = {colorsource="highway", scaletype="intensity", minscaler=6, maxscaler=6}
--			_Color = {colorsource="highway", scaletype="intensity", minscaler=2, maxscaler=2}
--		},
--		--texture="cliffRails.png",
--		--texture="skyscraper.png",
--		scale = {x=1,y=1,z=1}
--	}
--}

track = GetTrack()--get the track data from the game engine

if buildingNodes == nil then
	buildingNodes = {} --the track is made of nodes, each one with a position and rotation. This table will hold the indices of track nods that should have a skyscraper rendered at them (with some offset)
	offsets = {}
	buildingNodesToo = {}
	offsetsToo = {}
	for i=1,#track do
		if i%80==0 then
			buildingNodes[#buildingNodes+1] = i
			local xOffset = 150 + 1650*math.random()
			if math.random() > 0.5 then xOffset = xOffset * -1 end
			offsets[#offsets+1] = {xOffset,-100,0}
		end

--		if (i+40)%120==0 then
--			buildingNodesToo[#buildingNodesToo+1] = i
--			local xOffset = 150 + 1650*math.random()
--			if math.random() > 0.5 then xOffset = xOffset * -1 end
--			offsetsToo[#offsetsToo+1] = {xOffset,-100,0}
--		end
	end

	--[[BatchRenderEveryFrame{prefabName="BuildingCloneMe", --tell the game to render these prefabs in a batch (with Graphics.DrawMesh) every frame
							locations=buildingNodes,
                    		rotateWithTrack=false,
                    		maxShown=50,
                    		maxDistanceShown=2000,
							offsets=offsets,
							collisionLayer = 1,--will collision test with other batch-rendered objects on the same layer. set less than 0 for no other-object collision testing
							testAndHideIfCollideWithTrack=true --if true, it checks each render location against a ray down the center of the track for collision. Any hits are not rendered
						}--]]

--	BatchRenderEveryFrame{prefabName="BuildingCloneMeToo", --tell the game to render these prefabs in a batch (with Graphics.DrawMesh) every frame
--							locations=buildingNodesToo,
--                    		rotateWithTrack=false,
--                    		maxShown=50,
--                    		maxDistanceShown=2000,
--							offsets=offsetsToo,
--							collisionLayer = 1,--will collision test with other batch-rendered objects on the same layer. set less than 0 for no other-object collision testing
--							testAndHideIfCollideWithTrack=true --if true, it checks each render location against a ray down the center of the track for collision. Any hits are not rendered
--						}
end

--[[
CreateObject{ --creates a uniquely named prototype (prefab) that can be used later in the script or by the mod script. The audiosprint mod uses prototypes created in it's skin script
	name="SpriteTest",
	active=false,
	gameobject={
		pos={x=0,y=0,z=0},
		mesh="skyscraper42_withbase.obj",--mesh doesn't matter, the spritebatch won't use it
		shader="VertexColorUnlitTintedAddSmooth",
		shadercolors={
			_Color = {255,255,255}
		},
		texture="Frequency_OnBlack.jpg"
	}
}

spritenodes = {}
spriteoffsets = {}
for i=1,#track do
	if i%80==0 then
		spritenodes[#spritenodes+1]=i
		local xOffset = 150 + 300*math.random()
		if math.random() > 0.5 then xOffset = xOffset * -1 end
		spriteoffsets[#spriteoffsets+1] = {xOffset,-100,0}
	end
end

CreateSpriteBatch{
	prefabName="SpriteTest",--the material from this prefab is used
	locations=spritenodes,
	offsets={120,0,0},
	scales={30,30,30},
	repeaterSpacings={2,4,6,8,10,12,14,16,18,20}
}

--]]

CreateObject{--skywires, the red lines in the sky. A railed object is attached to the track and moves along it with the player.
	railoffset=0,
	floatonwaterwaves = false,
	gameobject={
		name="scriptSkyWires",
		pos={x=0,y=0,z=0},
		mesh="skywires.obj",
		renderqueue=1000,
		layer=ifhifi(18,13), -- in low detail the glow camera (layer 18) is disabled, so move the skywires to the main camera's layer (13)
		shader="VertexColorUnlitTintedSkywire",
		shadercolors={
			_Color="highway" --{r=255,g=0,b=0}
		},
		texture="White.png",
		scale = {x=1,y=1,z=1},
		lookat = "end"
	}
}

if jumping then
	--[[
	CreateObject{--left rope puller
		railoffset=18,
		floatonwaterwaves = true,
		tiltsmoother = 44,
		gameobject={
			pos={
				x=-7.5,
				y=.25,
				z=1},
			mesh="staggersphere.obj",
			shader="rimlight.shader",--shader text files can be used. Take the compiled shader from unity and give it a "shader" file extension to use it
			shadercolors={
				_Color={r=46,g=46,b=46},
				_RimColor={colorsource="highway", scaletype="intensity", minscaler=3, maxscaler=3}
			},
			texture="White.png",
			scale = {x=1.25,y=1.25,z=1.25}
		}
	}

	CreateObject{--right rope puller
		railoffset=18,
		floatonwaterwaves = true,
		tiltsmoother = 44,
		gameobject={
			pos={
				x=7.5,
				y=.25,
				z=1},
			mesh="staggersphere.obj",
			shader="rimlight.shader",
			shadercolors={
				_Color={r=46,g=46,b=46},
				_RimColor={colorsource="highway", scaletype="intensity", minscaler=3, maxscaler=3}
			},
			texture="White.png",
			scale = {x=1.25,y=1.25,z=1.25}
		}
	}
	--]]
end

--RAILS. rails are the bulk of the graphics in audiosurf. Each one is a 2D shape extruded down the length of the track.

--[[
	local laneDividers = skinvars["lanedividers"]
	for i=1,#laneDividers do
		CreateRail{ -- lane line
			positionOffset={
				x=laneDividers[i],
				y=0.1},
			crossSectionShape={
				{x=-.07,y=0},
				{x=.07,y=0}},
			perShapeNodeColorScalers={
				1,
				1},
			colorMode="static",
			color = {r=255,g=255,b=255},
			flatten=false,
			nodeskip = 2,
			wrapnodeshape = false,
			shader="VertexColorUnlitTinted"
		}
	end
--]]

CreateRail{--big cliff
	positionOffset={
		x=0,
		y=0},
	crossSectionShape={
		{x=11,y=-2},
		{x=22,y=-11},
		{x=22,y=-40},
		{x=-22,y=-40},
		{x=-22,y=-11},
		{x=-11,y=-2}
		},
	perShapeNodeColorScalers={
		1,
		1,
		.4,
		.4,
		1,
		1},
	colorMode="highway",
	color = {r=255,g=255,b=255},
	flatten=false,
	wrapnodeshape = false,
	texture="cliffRails.png",
	fullfuture = true,--ifhifi(true,false),
	stretch = 3,
	calculatenormals = true,
	shader="Cliff"
}

--CreateRail{--big cliff low detail. This one will almost always be able to render the song's full future.
--	positionOffset={
--		x=0,
--		y=0},
--	crossSectionShape={
--		{x=0,y=-4},
--		{x=0,y=-35}
--		},
--	perShapeNodeColorScalers={
--		1,
--		.4},
--	colorMode="highway",
--	color = {r=255,g=255,b=255},
--	flatten=false,
--	wrapnodeshape = true,
--	texture="cliffRails.png",
--	fullfuture = true,
--	stretch = 3,
--	calculatenormals = true,
--	shader="Cliff"
--}

--[[
CreateRail{--distant water
	positionOffset={
		x=0,
		y=0},
	crossSectionShape={
		{x=-12,y=-5.5},
		{x=12,y=-5.5}},
	perShapeNodeColorScalers={
		1,
		1},
	colorMode="static",
	color = {r=0,g=137,b=255},
	flatten=false,
	wrapnodeshape = false,
    layer=13,
	texture="White.png",
	shader="VertexColorUnlitTinted"
}
--]]

-- Default main rails
--[[
CreateRail{--left rail
	positionOffset={
		x=-trackWidth,
		y=0},
	crossSectionShape={
		{x=-.95,y=1.4},
		{x=0,y=1},
		{x=0,y=-3},
		{x=-.95,y=-3}},
	perShapeNodeColorScalers={
		.5,
		1,
		0,
		0},
	colorMode="highway",
	color = {r=255,g=255,b=255},
	flatten=true,
	texture="cliffRails.png",
	shader="CliffRail"
}

CreateRail{--right rail
	positionOffset={
		x=trackWidth,
		y=0},
	crossSectionShape={
		{x=0,y=1},
		{x=.95,y=1.4},
		{x=.95,y=-3},
		{x=0,y=-3}},
	perShapeNodeColorScalers={
		1,
		.5,
		0,
		0},
	colorMode="highway",
	color = {r=255,g=255,b=255},
	flatten=true,
	texture="cliffRails.png",
	shader="CliffRail"
}
--]]
--[[
CreateRail{--left aurora core
	positionOffset={
		x=-18,
		y=0},
	crossSectionShape={
		{x=-13,y=.5},
		{x=-9,y=.5},
		{x=-9,y=-.5},
		{x=-13,y=-.5}},
	perShapeNodeColorScalers={
		1,
		1,
		1,
		1},
	colorMode="highway",
	color = {r=255,g=255,b=255},
	flatten=true,
	texture="White.png",
	shader="VertexColorUnlitTinted"
}

CreateRail{--right aurora core
	positionOffset={
		x=18,
		y=0},
	crossSectionShape={
		{x=9,y=.5},
		{x=13,y=.5},
		{x=13,y=-.5},
		{x=9,y=-.5}},
	perShapeNodeColorScalers={
		1,
		1,
		1,
		1},
	colorMode="highway",
	color = {r=255,g=255,b=255},
	flatten=true,
	texture="White.png",
	shader="VertexColorUnlitTinted"
}--]]

auroraExtent = ifhifi(200, 50)
CreateRail{--left aurora
	positionOffset={
		x=-8,
		y=-4},
	crossSectionShape={
		{x=-auroraExtent,y=1},
		{x=-15,y=1},
		{x=-15,y=-1},
		{x=-auroraExtent,y=-1}},
	perShapeNodeColorScalers={
		0,
		1,
		1,
		0},
	colorMode="aurora",
	color = {r=255,g=255,b=255},
	flatten=true,
    layer=13,
	texture="White.png",
	shader="VertexColorUnlitTintedAddSmoothNoCull"
}

CreateRail{--right aurora
	positionOffset={
		x=8,
		y=-4},
	crossSectionShape={
		{x=15,y=1},
		{x=auroraExtent,y=1},
		{x=auroraExtent,y=-1},
		{x=15,y=-1}},
	perShapeNodeColorScalers={
		1,
		0,
		0,
		1},
	colorMode="aurora",
	color = {r=255,g=255,b=255},
	flatten=true,
    layer=13,
	texture="White.png",
	shader="VertexColorUnlitTintedAddSmoothNoCull"
}
--[[
if hifi then
	CreateRail{--left shell
		positionOffset={
			x = -trackWidth + 6,
			y=0},
		crossSectionShape={
			{x=-.3,y=3},
			{x=-.1,y=3},
			{x=.1,y=-3},
			{x=-.3,y=-3}},
		perShapeNodeColorScalers={
			.3,
			.2,
			.8,
			.2},
		colorMode="highway",
		flatten=true,
		wrapnodeshape = false,
		shader="proximity_2way_Color",
		renderqueue=3998,
	    layer=13,
		shadercolors={_nearColor={r=255,g=255,b=255,a=0},
						_farColor={r=255,g=255,b=255,a=214}},
		shadersettings={_nearDistance=0, _farDistance=103.5}
	}

	CreateRail{--right shell
		positionOffset={
			x=trackWidth - 6,
			y=0},
		crossSectionShape={
			{x=.3,y=-3},
			{x=-.1,y=-3},
			{x=-.1,y=3},
			{x=.3,y=3}},
		perShapeNodeColorScalers={
			.3,
			.8,
			.2,
			.2},
		colorMode="highway",
		flatten=true,
		wrapnodeshape = false,
		shader="proximity_2way_Color",
		renderqueue=3998,
	    layer=13,
		shadercolors={_nearColor={r=255,g=255,b=255,a=0},
						_farColor={r=255,g=255,b=255,a=214}},
		shadersettings={_nearDistance=0, _farDistance=103.5}
	}
end
--]]
--[[
CreateRail{--left shell topper
	positionOffset={
		x=-trackWidth - 6,
		y=0},
	crossSectionShape={
		{x=-.1,y=3},
		{x=-.1,y=-3},
		{x=.1,y=-3},
		{x=.1,y=3}},
	perShapeNodeColorScalers={
		1,
		1,
		1,
		1},
	colorMode="highway",
	color = {r=255,g=255,b=255},
	flatten=true,
	texture="White.png",
	shader="VertexColorUnlitTinted"
}

CreateRail{--right shell top
	positionOffset={
		x=trackWidth + 6,
		y=0},
	crossSectionShape={
		{x=-.1,y=3},
		{x=-.1,y=-3},
		{x=.1,y=-3},
		{x=.1,y=3}},
	perShapeNodeColorScalers={
		1,
		1,
		1,
		1},
	colorMode="highway",
	color = {r=255,g=255,b=255},
	flatten=true,
	texture="White.png",
	shader="VertexColorUnlitTinted"
}
--]]