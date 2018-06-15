------------------
--Global Variables
------------------
NumScenario = 1

Infinite_MapTiles_GUID = "4895cd"
Infinite_DifficultTerrain_GUID = "4efdc4"
Infinite_Corridors_GUID = "359306"
Infinite_Traps_GUID = "0a3abe"
Infinite_Obstacles_GUID = "c912f5"
Infinite_Doors_GUID = "21be0e"
Infinite_HazardousTerrain_GUID = "0b51bb"
Infinite_ObjectiveTokens_GUID = "a945e4"
Infinite_ScenarioAidTokens_GUID = "0c647c"
Infinite_TreasureChests_GUID = "fe14ef"

Infinite_Coin1_GUID = "a41a54"

Delay_BagRegister = 1
Delay_Spawning = 2
Delay_Delete = 4




---------------
--Button Tables
---------------
Button_Scenario_Minus10 = {
	label			= "-10"
	,click_function	= "numScenario_Minus10"
	,function_owner	= self
	,position		= {0,0.1,0}
	,height			= 250
	,width			= 250
	,font_size		= 100
}

Button_Scenario_Minus1 = {
	label			= "-1"
	,click_function	= "numScenario_Minus1"
	,function_owner	= self
	,position		= {0.5,0.1,0}
	,height			= 250
	,width			= 250
	,font_size		= 100
}

Button_Scenario_Num = {
	label			= ""
	,click_function	= "NoFunction"
	,function_owner	= self
	,position		= {1,0.1,0}
	,height			= 250
	,width			= 250
	,font_size		= 180
}

Button_Scenario_Add1 = {
	label			= "+1"
	,click_function	= "numScenario_Add1"
	,function_owner	= self
	,position		= {1.5,0.1,0}
	,height			= 250
	,width			= 250
	,font_size		= 100
}

Button_Scenario_Add10 = {
	label			= "+10"
	,click_function	= "numScenario_Add10"
	,function_owner	= self
	,position		= {2,0.1,0}
	,height			= 250
	,width			= 250
	,font_size		= 100
}

Button_CreateMap = {
	label			= "Create Map"
	,click_function	= "createMap"
	,function_owner	= self
	,position		= {1,0.1,0.6}
	,height			= 250
	,width			= 600
	,font_size		= 100
}




-----------------
--OnSave / OnLoad
-----------------
function onSave()
	local DataToSave = {
		NumScenario = NumScenario
	}

	SavedData = JSON.encode(DataToSave)

	return SavedData
end

function onLoad(SavedData)
	if SavedData ~= "" then
		local LoadedData = JSON.decode(SavedData)
		NumScenario = LoadedData.NumScenario
	else
		NumScenario = 1
	end

	self.createButton(Button_Scenario_Minus10)
	self.createButton(Button_Scenario_Minus1)
	self.createButton(Button_Scenario_Num)
	self.createButton(Button_Scenario_Add1)
	self.createButton(Button_Scenario_Add10)
	self.createButton(Button_CreateMap)

	numScenario_Update(NumScenario)
end




--------------------
--Scenario Functions
--------------------
function numScenario_Update(x)
	self.editButton({index=2,label=x})
end

function numScenario_Add10()
	for i=1,10 do
		numScenario_Add1()
	end
end

function numScenario_Add1()
	if NumScenario ~= 95 then
		NumScenario = NumScenario + 1
		numScenario_Update(NumScenario)
	end
end

function numScenario_Minus1()
	if NumScenario ~= 1 then
		NumScenario = NumScenario - 1
		numScenario_Update(NumScenario)
	end
end

function numScenario_Minus10()
	for i=1,10 do
		numScenario_Minus1()
	end
end




------------
--Create Map
------------
function createMap()
	--Create Map "Global" Variables
	local Bag_MapTiles_GUID
	local Bag_DifficultTerrain_GUID
	local Bag_Corridors_GUID
	local Bag_Traps_GUID
	local Bag_Obstacles_GUID
	local Bag_Doors_GUID
	local Bag_HazardousTerrain_GUID
	local Bag_ObjectiveTokens_GUID
	local Bag_ScenarioAidTokens_GUID
	local Bag_TreasureChests_GUID

	local Bag_InfiniteBag_GUID


	--Take a Bag from Infinite
	takeBagFromInfinite(getObjectFromGUID(Infinite_MapTiles_GUID),"CreateMap_MapTiles")
	takeBagFromInfinite(getObjectFromGUID(Infinite_DifficultTerrain_GUID),"CreateMap_DifficultTerrain")
	takeBagFromInfinite(getObjectFromGUID(Infinite_Corridors_GUID),"CreateMap_Corridors")
	takeBagFromInfinite(getObjectFromGUID(Infinite_Traps_GUID),"CreateMap_Traps")
	takeBagFromInfinite(getObjectFromGUID(Infinite_Obstacles_GUID),"CreateMap_Obstacles")
	takeBagFromInfinite(getObjectFromGUID(Infinite_Doors_GUID),"CreateMap_Doors")
	takeBagFromInfinite(getObjectFromGUID(Infinite_HazardousTerrain_GUID),"CreateMap_HazardousTerrain")
	takeBagFromInfinite(getObjectFromGUID(Infinite_ObjectiveTokens_GUID),"CreateMap_ObjectiveTokens")
	takeBagFromInfinite(getObjectFromGUID(Infinite_ScenarioAidTokens_GUID),"CreateMap_ScenarioAidTokens")
	takeBagFromInfinite(getObjectFromGUID(Infinite_TreasureChests_GUID),"CreateMap_TreasureChests")


	--Create Infinite Bag
	spawnObject({
		type			= "Infinite_Bag"
		,position		= {x=-57.344707, y=1.493657, z=-22.819818}
		,sound			= false
		,callback		= "spawnCallback"
		,callback_owner = self
		,params			= {
			name	= "CreateMap_InfiniteBag"
			,lock	= true
		}
	})


	--Move Spawner Out the Way
	function moveSpawner()
		wait(1)
		self.setPositionSmooth(
			{x=-12.687500, y=1.797193, z=28.037571}
			,false
			,true
		)
		return 1
	end
	startLuaCoroutine(self, "moveSpawner")


	--Find GUIDs of standard bags after delay
	function registerBags_Maps()
		wait(Delay_BagRegister)
		local AllObjects = getAllObjects()
		local t = {
			CreateMap_MapTiles				= function(x) Bag_MapTiles_GUID = x end
			,CreateMap_DifficultTerrain		= function(x) Bag_DifficultTerrain_GUID = x end
			,CreateMap_Corridors			= function(x) Bag_Corridors_GUID = x end
			,CreateMap_Traps				= function(x) Bag_Traps_GUID = x end
			,CreateMap_Obstacles			= function(x) Bag_Obstacles_GUID = x end
			,CreateMap_Doors				= function(x) Bag_Doors_GUID = x end
			,CreateMap_HazardousTerrain		= function(x) Bag_HazardousTerrain_GUID = x end
			,CreateMap_ObjectiveTokens		= function(x) Bag_ObjectiveTokens_GUID = x end
			,CreateMap_ScenarioAidTokens	= function(x) Bag_ScenarioAidTokens_GUID = x end
			,CreateMap_TreasureChests		= function(x) Bag_TreasureChests_GUID = x end

			,CreateMap_InfiniteBag			= function(x) Bag_InfiniteBag_GUID = x end
		}
		for _,obj in ipairs(AllObjects) do
			if string.sub(obj.getName(),1,10) == "CreateMap_" then
				t[obj.getName()](obj.getGUID())
			end
		end
		return 1
	end
	startLuaCoroutine(self, "registerBags_Maps")


	--Spawn Scenario Page
	function spawnScenarioPage()
		wait(Delay_Spawning)

		local t = {
			--Scenario 1
			[1] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084823680/A1EE015BCC903434903B7B881EABBF910E171430/"}
			}
			--Scenario 2
			,[2] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084825034/1099A85A521A822F396AD9D62C5E0EB270C328C1/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084822447/C597DF7B62085D2D31BCE0A04D967ED80948FE6F/"}
			}
			--Scenario 3
			,[3] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084822447/C597DF7B62085D2D31BCE0A04D967ED80948FE6F/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084834847/721285A9989404BF32C6F6AB7352364DF91EA8A3/"}
			}
			--Scenario 4
			,[4] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084823523/6E864B9E321AE09E473198CA33E3E18F00B6785F/"}
			}
			--Scenario 5
			,[5] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084834060/4C54DE33D7ED91846B66DAAB59506CC1CC296128/"}
			}
			--Scenario 6
			,[6] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084825142/0C08CD04AA7DE6F1BD1BCC79B37C224AF418ECD3/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084821304/AF7328C68E384A31D9DB64855717D17D17A695A6/"}
			}
			--Scenario 7
			,[7] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084821304/AF7328C68E384A31D9DB64855717D17D17A695A6/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084824637/1B6FD94041B03DF0678CFC19C9E1810E7DFF510A/"}
			}
			--Scenario 8
			,[8] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084839414/A0999825EA2AE2E1EC1BDD0D32C8B5360BEBD2DB/"}
			}
			--Scenario 9
			,[9] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084838509/5607EC2D82BD96D9A2B72F20960CCA49C1C579B4/"}
			}
			--Scenario 10
			,[10] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084825734/66DCA1305C573607029F88364D1E102366731342/"}
			}
			--Scenario 11
			,[11] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084830238/55D555A0AFB03975A01AD89A47A2E9951B942F02/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084822245/98BC673318B3A81726D383646185C482E0BFF5C6/"}
			}
			--Scenario 12
			,[12] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084822245/98BC673318B3A81726D383646185C482E0BFF5C6/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084833448/A3656AB45F481EBE9A284D8F7439A64E8C31EEF2/"}
			}
			--Scenario 13
			,[13] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084838201/DF229C955CD38E17817AF8ABC26E0C4DBBF35920/"}
			}
			--Scenario 14
			,[14] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084828663/C3C7730AE254F0B3621D781EC5A02A9292B97586/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084833745/9BC954A20EA9F2B2109380D2B00DD83985862773/"}
			}
			--Scenario 15
			,[15] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084833745/9BC954A20EA9F2B2109380D2B00DD83985862773/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084839269/C1CDEF6D09D9EC65B69E70B022FA004C67113924/"}
			}
			--Scenario 16
			,[16] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084826722/57A2857E7023DC1321C11C090CA25468E1193CB0/"}
			}
			--Scenario 17
			,[17] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084826093/B9045085BA91F46D27C2170813155BBB98E4F29D/"}
			}
			--Scenario 18
			,[18] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084824220/9DD0FBC3520480AF10102CE422EAC4E5C6682C91/"}
			}
			--Scenario 19
			,[19] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084834161/761DB83DEF203AA0650CEE5D0815A32B833657C9/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084833578/DA0CFB2285590AC067B266ABF65B3A44DFCD67A2/"}
			}
			--Scenario 20
			,[20] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084833578/DA0CFB2285590AC067B266ABF65B3A44DFCD67A2/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084822342/0891BDEFA6E5E7335BC9190C5C26DA8F3DE6D56B/"}
			}
			--Scenario 21
			,[21] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084835889/6F9FBDE2DE4BC36DBF47C286CF62A21B016DC1BD/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084836608/1BC47CDA74ED21620D0C3DC7AFBF327C3BEB6A89/"}
			}
			--Scenario 22
			,[22] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084836608/1BC47CDA74ED21620D0C3DC7AFBF327C3BEB6A89/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084822670/C842FA48BAB0630BFF4A3AF2FC72391EA321EA3F/"}
			}
			--Scenario 23
			,[23] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084838089/7C833E624659BDAC9572377725B88D33A80B8C1C/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084832231/805C3F0EDFE1417851DBD8C8BBB9C63555732BB8/"}
			}
			--Scenario 24
			,[24] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084832231/805C3F0EDFE1417851DBD8C8BBB9C63555732BB8/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084825519/9C79A74904261C20476EE8CC354FA2500E48DAA3/"}
			}
			--Scenario 25
			,[25] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084821412/02AD49B33E832F92D4AC19FFA3674016562BBE66/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084823058/D675275D7DF11AB5F4FE6A80537513D53E52D07D/"}
			}
			--Scenario 26
			,[26] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084823058/D675275D7DF11AB5F4FE6A80537513D53E52D07D/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084827387/97441185510CDFDC139012242861F27C9CB9EBDC/"}
			}
			--Scenario 27
			,[27] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084826557/0D09383FF4B727BC8EF29090C3AEF517C465A576/"}
			}
			--Scenario 28
			,[28] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084833346/C9F4D0A5A196489FB1C043A1A54F79E07B7FAE70/"}
			}
			--Scenario 29
			,[29] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084822080/4781178ECF6F8A747424B347BC4F918A59F65A85/"}
			}
			--Scenario 30
			,[30] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084825396/F4CE1D88E179F9FC0F80B6A4E386C93D92963731/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084826942/62AC69BEAA6E47CCF860ECAD60558CDEA4FC4505/"}
			}
			--Scenario 31
			,[31] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084826942/62AC69BEAA6E47CCF860ECAD60558CDEA4FC4505/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084824750/8C6DD6FA1439EB535BCB17300DC65563BCAE60A2/"}
			}
			--Scenario 32
			,[32] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084823790/0B19630A4DF41345BBBD8C0668BEE12A2DA7C46A/"}
			}
			--Scenario 33
			,[33] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084821575/92F373FB4DDC7C5E5BE175232C37889BE13371AC/"}
			}
			--Scenario 34
			,[34] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084838387/C11476B3A862B6E83744C58FBC9B879F46C2045D/"}
			}
			--Scenario 35
			,[35] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084834740/EFA11EAD44B4DD4058965C43189A27C84F31E755/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084821749/8579EA6AB346CD20B361A27DC8168DE4E23B9152/"}
			}
			--Scenario 36
			,[36] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084821749/8579EA6AB346CD20B361A27DC8168DE4E23B9152/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084828504/B17678F6410A0DD665249427A8A251A5E3816587/"}
			}
			--Scenario 37
			,[37] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084826434/ECD55E8D3BF675F21B87824E7EFFF10ACF0CEBE9/"}
			}
			--Scenario 38
			,[38] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084829192/8DF833CE80481B48FA199C854AEA890D260C41B7/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084822773/401F7B86C98784252947D96E644FB771B6139828/"}
			}
			--Scenario 39
			,[39] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084822773/401F7B86C98784252947D96E644FB771B6139828/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084824090/D415108B5626CB13185A3CF5AFCA3C06F3141717/"}
			}
			--Scenario 40
			,[40] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084830697/527888CA7C04909E7C89E10D57CAB137A3B92696/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084837749/0E13EA3F46F4ECC06A816B9B94448B0E1F4215B9/"}
			}
			--Scenario 41
			,[41] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084837749/0E13EA3F46F4ECC06A816B9B94448B0E1F4215B9/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084828164/132B870A8DE199BC303F01707AE736957566CC71/"}
			}
			--Scenario 42
			,[42] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084833848/4C7B508EB132261B93922C3F797CD624B98C3D62/"}
			}
			--Scenario 43
			,[43] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084838861/4BFE29AD7D529C0042F9D5CA9F84FEA70679A762/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084831045/9DD25A8D439A5BC45DAC9DDE49A98FEFCC8DB351/"}
			}
			--Scenario 44
			,[44] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084831045/9DD25A8D439A5BC45DAC9DDE49A98FEFCC8DB351/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084823268/9F9DD002F9EB4FD6064531A827F296133CD5BF56/"}
			}
			--Scenario 45
			,[45] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084833187/303573C16AF1D7A8192A5C3E328A3BCEE3E5AD67/"}
			}
			--Scenario 46
			,[46] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084831211/70FAF5EE6707CDDBB65139AEC0EE0ABDA00565A8/"}
			}
			--Scenario 47
			,[47] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084831532/74DE5A13AD7D73180724C305594F70D8165A3E4A/"}
			}
			--Scenario 48
			,[48] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084839059/7AA80A43DBCA103082008EC7C2E5BC71E816C49A/"}
			}
			--Scenario 49
			,[49] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084835738/F189344273DAE7F7465B5A14EF6B80FD679C9439/"}
			}
			--Scenario 50
			,[50] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084826829/5E175A24EDEC8683590D3C75DA9BA0F353C2628B/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084825632/8A42EE9A0DB8AD8C5D049D2CC04F05E3E4864B46/"}
			}
			--Scenario 51
			,[51] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084825632/8A42EE9A0DB8AD8C5D049D2CC04F05E3E4864B46/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084832049/DEB248204D1F2104112099A5E221724864EA5631/"}
			}
			--Scenario 52
			,[52] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084825850/1CC21319F159682278BD7347DD542579979E6693/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084833952/0A64127069EB2618D139D07FA21015A7B35E9049/"}
			}
			--Scenario 53
			,[53] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084833952/0A64127069EB2618D139D07FA21015A7B35E9049/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084827988/C8322575346206EC6FC5064C24EEE8A6B1051D92/"}
			}
			--Scenario 54
			,[54] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084831785/C4C0699CA66A47B992F279DFD6F152E87611B9D4/"}
			}
			--Scenario 55
			,[55] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084823170/6E46BD68C6B85AD4AA0FF929C6C21E34BBBE1DA3/"}
			}
			--Scenario 56
			,[56] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084831369/97B6BACD549D8877D4C1A04C35A430E06F7D81DC/"}
			}
			--Scenario 57
			,[57] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084839564/C3C2989657240726AC3850B3AA8149A294FF081D/"}
			}
			--Scenario 58
			,[58] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084829735/588BE0782CA1F4B2B1E30EC792B1D561DE630221/"}
			}
			--Scenario 59
			,[59] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084830536/8E226CF576E83346F360DDCFB72841E5F2A4DC07/"}
			}
			--Scenario 60
			,[60] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084828853/26F73D34746DE483D9BA7CD16F8548DAABADC922/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084827654/56971ECF927BF3B2E79192ED1B52DFA224D7280E/"}
			}
			--Scenario 61
			,[61] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084827654/56971ECF927BF3B2E79192ED1B52DFA224D7280E/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084834626/4123D6E33D6B8EDB83E281255B92DF89683B4BF4/"}
			}
			--Scenario 62
			,[62] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084838624/71ADAE8B15C75F19644ACE97A53DEEB36F048938/"}
			}
			--Scenario 63
			,[63] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084836901/4970DB1E9FD25C4BFD2DB29689C0AECB8D2542FC/"}
			}
			--Scenario 64
			,[64] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084829012/DAFE87548F237347F095C10F82AB68DB1142D6BC/"}
			}
			--Scenario 65
			,[65] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084830122/6B1E9F9B01B861F13320DD6D2C4D03424D6C0F22/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084824380/80B8507BDBE0054272637672574BE3A5D2C6448C/"}
			}
			--Scenario 66
			,[66] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084824380/80B8507BDBE0054272637672574BE3A5D2C6448C/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084823954/908EB4B7B81E9E1823163E11DF10B753D448314F/"}
			}
			--Scenario 67
			,[67] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084834372/D9AEA230B851C43CF5D06CAC55725C794177C6B0/"}
			}
			--Scenario 68
			,[68] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084838738/67A42E3AD241C228BC5309AAC24EC6675AC94ED2/"}
			}
			--Scenario 69
			,[69] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084826312/D394516440E9A0F5A479BFD220E8AF631B295B15/"}
			}
			--Scenario 70
			,[70] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084830345/1F2EE2A88CCE534F28EC70E5C2D5DC605AA182FA/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084821881/9D5DC0BD5B3EE29B352D3145C35DE45BE9672B46/"}
			}
			--Scenario 71
			,[71] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084821881/9D5DC0BD5B3EE29B352D3145C35DE45BE9672B46/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084827260/8E24AD42F22B3CBCD3188304A6BE395B10D00E29/"}
			}
			--Scenario 72
			,[72] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084829626/A846762AAADC46489C0C756E4997B48D24B3E1F9/"}
			}
			--Scenario 73
			,[73] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084821118/76EC22D9BB4930D8DDA94969F4622BC2F8C67293/"}
			}
			--Scenario 74
			,[74] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084829294/EAEE47D9926BEC9675FE489EB1E67110BB827952/"}
			}
			--Scenario 75
			,[75] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084825274/10AE111BFEEB18F95161ACD4AE975394E902517D/"}
			}
			--Scenario 76
			,[76] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084830005/72ECB66753368B305B6EFAA13CEB34B7BD6EA8F6/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084824859/3AC36FA3DB34F01D46327B18030CE381D15AAECE/"}
			}
			--Scenario 77
			,[77] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084824859/3AC36FA3DB34F01D46327B18030CE381D15AAECE/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084824534/C6A3E907A605DEA9EB06D3263CF211FB21660A63/"}
			}
			--Scenario 78
			,[78] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084827820/24C273D3065239E34903C79A621A06FE04E0C874/"}
			}
			--Scenario 79
			,[79] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084827115/52D4717F1FC5D2A7AEE32733FFC8EBC1BDC7A51C/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084821988/80F5237B5317AC90910E849AB8869CC6B38D1F21/"}
			}
			--Scenario 80
			,[80] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084821988/80F5237B5317AC90910E849AB8869CC6B38D1F21/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084837638/6AF8A380935BD7AB0BA2591CA296D61145587B74/"}
			}
			--Scenario 81
			,[81] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084837936/C093A9670FC67A3BBC1B64C6A0999A51E7DE3E10/"}
			}
			--Scenario 82
			,[82] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084836752/3748412ACD03F84912133E2E936980F86FB7ABF5/"}
			}
			--Scenario 83
			,[83] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084822543/4BF6E53086D7DF0CD2C94A81A1CE09E8F28477E2/"}
			}
			--Scenario 84
			,[84] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084835530/FF5996203DBD7104FD3B753B15008C0F2056B19E/"}
			}
			--Scenario 85
			,[85] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084836035/5F7C3D550020CB4265B655EC333BA1F26742F17A/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084826212/15931F3494FD7A16680230E53808120C2D4C5129/"}
			}
			--Scenario 86
			,[86] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084826212/15931F3494FD7A16680230E53808120C2D4C5129/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084827516/811034D6828804818B3F647C2125918C4647F35F/"}
			}
			--Scenario 87
			,[87] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084836392/B60C5A4E472380B6CBDC52EA82023351190DF7EF/"}
			}
			--Scenario 88
			,[88] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084829407/1DC67CCF33CC4EF648086182F459E9AA886EFE5B/"}
			}
			--Scenario 89
			,[89] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084836167/3968AFBFDB90381FBC6B48D12ACC5374902BAF81/"}
			}
			--Scenario 90
			,[90] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084837013/2A80F46263B79622095ED7DBDD63DFB968428E51/"}
			}
			--Scenario 91
			,[91] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084834503/B0F74DE25B9880837196B7FD16A4C9AC43C98CF6/"}
			}
			--Scenario 92
			,[92] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084829851/ABA213366423617A7D330CD25E40FB29BFFED026/"}
			}
			--Scenario 93
			,[93] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084830903/007760FBA03523D8BC46CB4EC9D0E93FC191D7B6/"}
			}
			--Scenario 94
			,[94] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084825972/3B2A7DB61C2E2EB47FCBCA2F380463CDC1B66867/"}
			}
			--Scenario 95
			,[95] = {
				{image = "http://cloud-3.steamusercontent.com/ugc/931553965084831672/0DF0FC5E04B026F5549297B51E00F41B595B3F4A/"}
				,{image = "http://cloud-3.steamusercontent.com/ugc/931553965084834271/C0DE6FD6FF1A00D919DFC9E374BF31725E853C2B/"}
			}
		}


		local position = {x=-19.687500, y=1.750121, z=3.788861}
		if #t[NumScenario] == 2 then position.x = position.x - 19 end

		for _,i in ipairs(t[NumScenario]) do
			i.type				= "Custom_Token"
			i.position			= position
			i.rotation			= {x=0, y=180, z=0}
			i.scale				= {x=5.750000, y=1.000000, z=5.750000}
			i.sound				= false
			i.snap_to_grid		= true
			i.callback			= "spawnCallback"
			i.callback_owner	= self
			i.params			= {lock = true}

			spawnObject(i).setCustomObject(i)
			position.x = position.x + 19
		end

		return 1
	end
	startLuaCoroutine(self, "spawnScenarioPage")


	--Spawn Map Tiles
	function spawnMapTiles()
		wait(Delay_Spawning)

		local Bag_MapTiles = getObjectFromGUID(Bag_MapTiles_GUID)

		local t = {
			--Scenario 1
			[1] = {
				{
					tile		= "G1"
					,position	= {x=0.874285, y=1.759086, z=6.063714}
					,rotation	= {x=0.000250, y=0.024955, z=180.000763}
				}
				,{
					tile		= "I1"
					,position	= {x=-5.687230, y=1.752955, z=5.304418}
					,rotation	= {x=0.795132, y=179.994095, z=179.999222}
				}
				,{
					tile		= "L1"
					,position	= {x=0.889695, y=-3.775473, z=-3.034077}
					,rotation	= {x=-0.000249, y=180.008926, z=-0.000768}
				}
			}
			--Scenario 2
			,[2] = {
				{
					tile		= "A1"
					,position	= {x=11.366568, y=1.758538, z=4.812493}
					,rotation	= {x=0.000873, y=269.984070, z=-0.000228}
				}
				,{
					tile		= "A2"
					,position	= {x=-2.273403, y=1.758384, z=-3.062795}
					,rotation	= {x=-0.000557, y=149.970520, z=-0.000586}
				}
				,{
					tile		= "A3"
					,position	= {x=8.335624, y=1.760201, z=-3.062603}
					,rotation	= {x=-0.000241, y=209.997070, z=179.999542}
				}
				,{
					tile		= "A4"
					,position	= {x=-5.304409, y=1.760030, z=4.812119}
					,rotation	= {x=-0.000439, y=90.005722, z=179.999924}
				}
				,{
					tile		= "B3"
					,position	= {x=3.035127, y=1.759058, z=11.384703}
					,rotation	= {x=-0.001827, y=89.944977, z=180.000778}
				}
				,{
					tile		= "M1"
					,position	= {x=3.030007, y=1.818404, z=3.492803}
					,rotation	= {x=0.000247, y=269.993439, z=-0.000326}
				}
			}
			--Scenario 3
			,[3] = {
				{
					tile		= "B1"
					,position	= {x=10.498160, y=1.759216, z=6.062178}
					,rotation	= {x=0.000251, y=0.000857, z=0.000771}
				}
				,{
					tile		= "B2"
					,position	= {x=10.499999, y=1.759248, z=-1.515544}
					,rotation	= {x=0.000251, y=0.033798, z=0.000768}
				}
				,{
					tile		= "B3"
					,position	= {x=-5.250000, y=1.759004, z=6.062178}
					,rotation	= {x=-0.000251, y=179.998032, z=-0.000767}
				}
				,{
					tile		= "B4"
					,position	= {x=-5.250000, y=1.759038, z=-1.515544}
					,rotation	= {x=-0.000248, y=180.000000, z=-0.000767}
				}
				,{
					tile		= "E1"
					,position	= {x=1.312500, y=1.757535, z=12.882128}
					,rotation	= {x=-0.000767, y=89.999939, z=180.000259}
				}
				,{
					tile		= "L1"
					,position	= {x=2.625062, y=7.293711, z=6.062229}
					,rotation	= {x=-0.000248, y=179.995193, z=179.999222}
				}
				,{
					tile		= "L3"
					,position	= {x=2.625000, y=7.293749, z=-3.031088}
					,rotation	= {x=0.000250, y=-0.000592, z=180.000778}
				}
			}
			--Scenario 4
			,[4] = {
				{
					tile		= "C1"
					,position	= {x=6.562500, y=1.818192, z=-0.757772}
					,rotation	= {x=0.000247, y=0.018086, z=0.000773}
				}
				,{
					tile		= "E1"
					,position	= {x=-3.937430, y=1.757514, z=2.273321}
					,rotation	= {x=0.000760, y=270.008301, z=-0.000200}
				}
				,{
					tile		= "G1"
					,position	= {x=1.310142, y=1.759132, z=3.788861}
					,rotation	= {x=0.000595, y=0.001911, z=180.000626}
				}
				,{
					tile		= "M1"
					,position	= {x=9.187500, y=1.818513, z=8.335494}
					,rotation	= {x=0.000373, y=359.981049, z=0.000776}
				}
			}
			--Scenario 5
			,[5] = {
				{
					tile		= "K1"
					,position	= {x=1.513068, y=1.772006, z=16.625071}
					,rotation	= {x=0.000369, y=-0.000181, z=180.000763}
				}
				,{
					tile		= "K2"
					,position	= {x=1.515545, y=1.772097, z=-4.375000}
					,rotation	= {x=-0.000131, y=179.970825, z=179.999222}
				}
				,{
					tile		= "M1"
					,position	= {x=1.515545, y=1.818395, z=6.125001}
					,rotation	= {x=0.000767, y=270.002930, z=-0.000248}
				}
			}
			--Scenario 6
			,[6] = {
				{
					tile		= "K1"
					,position	= {x=0.757772, y=1.772085, z=-3.937500}
					,rotation	= {x=0.000371, y=-0.005661, z=180.000763}
				}
				,{
					tile		= "K2"
					,position	= {x=0.757773, y=1.772005, z=14.437500}
					,rotation	= {x=-0.000129, y=179.993256, z=179.999222}
				}
				,{
					tile		= "L1"
					,position	= {x=-4.546633, y=-3.775583, z=5.250000}
					,rotation	= {x=-0.000771, y=89.990547, z=0.000247}
				}
				,{
					tile		= "M1"
					,position	= {x=4.546729, y=1.818439, z=5.252127}
					,rotation	= {x=0.000764, y=270.008362, z=-0.000251}
				}
			}
			--Scenario 7
			,[7] = {
				{
					tile		= "B4"
					,position	= {x=0.004200, y=1.759037, z=14.889327}
					,rotation	= {x=-0.000767, y=89.985504, z=180.000259}
				}
				,{
					tile		= "C2"
					,position	= {x=-4.549309, y=1.700035, z=4.380509}
					,rotation	= {x=-0.000880, y=330.043915, z=180.002213}
				}
				,{
					tile		= "D2"
					,position	= {x=9.903316, y=1.700521, z=3.066463}
					,rotation	= {x=0.000541, y=240.096588, z=179.999405}
				}
				,{
					tile		= "F1"
					,position	= {x=8.356160, y=1.758955, z=13.564923}
					,rotation	= {x=-0.000250, y=179.853821, z=-0.000767}
				}
				,{
					tile		= "G2"
					,position	= {x=-0.006577, y=1.759059, z=9.649603}
					,rotation	= {x=-0.000768, y=90.131577, z=0.000252}
				}
				,{
					tile		= "M1"
					,position	= {x=1.533255, y=1.700433, z=-0.881468}
					,rotation	= {x=-0.000377, y=29.938147, z=180.000763}
				}
			}
			--Scenario 8
			,[8] = {
				{
					tile		= "G2"
					,position	= {x=2.273317, y=1.759084, z=10.934969}
					,rotation	= {x=0.000769, y=270.033447, z=179.999741}
				}
				,{
					tile		= "I1"
					,position	= {x=3.031089, y=1.817858, z=-3.500000}
					,rotation	= {x=-0.000765, y=90.001862, z=0.000249}
				}
				,{
					tile		= "I2"
					,position	= {x=3.031085, y=1.700423, z=4.374997}
					,rotation	= {x=-0.000765, y=89.999672, z=180.000259}
				}
			}
			--Scenario 9
			,[9] = {
				{
					tile		= "I2"
					,position	= {x=0.000001, y=1.817804, z=-0.875000}
					,rotation	= {x=0.000766, y=269.996307, z=-0.000251}
				}
				,{
					tile		= "N1"
					,position	= {x=0.757230, y=1.759075, z=8.309997}
					,rotation	= {x=0.000767, y=269.998596, z=-0.000249}
				}
			}
			--Scenario 10
			,[10] = {
				{
					tile		= "D1"
					,position	= {x=-0.436977, y=1.700339, z=12.882254}
					,rotation	= {x=0.000168, y=210.015259, z=179.999222}
				}
				,{
					tile		= "G1"
					,position	= {x=6.124903, y=1.759144, z=9.093305}
					,rotation	= {x=-0.000249, y=179.992065, z=-0.000774}
				}
				,{
					tile		= "L1"
					,position	= {x=-1.750001, y=7.293659, z=4.546632}
					,rotation	= {x=-0.000249, y=180.025208, z=179.999237}
				}
				,{
					tile		= "L3"
					,position	= {x=-1.750000, y=7.293697, z=-4.546633}
					,rotation	= {x=0.000250, y=0.005393, z=180.000778}
				}
			}
			--Scenario 11
			,[11] = {
				{
					tile		= "D1"
					,position	= {x=10.500000, y=1.818555, z=-3.031089}
					,rotation	= {x=0.000599, y=330.015045, z=0.000541}
				}
				,{
					tile		= "E1"
					,position	= {x=7.882883, y=1.757620, z=13.658168}
					,rotation	= {x=0.000768, y=269.977783, z=-0.000250}
				}
				,{
					tile		= "H1"
					,position	= {x=0.000411, y=1.700414, z=-3.031132}
					,rotation	= {x=0.000251, y=0.024830, z=0.000766}
				}
				,{
					tile		= "L1"
					,position	= {x=-2.625035, y=-3.775560, z=6.062130}
					,rotation	= {x=0.000251, y=359.985260, z=0.000767}
				}
				,{
					tile		= "L2"
					,position	= {x=-2.634769, y=7.293605, z=15.154384}
					,rotation	= {x=-0.000250, y=179.984787, z=179.999237}
				}
			}
			--Scenario 12
			,[12] = {
				{
					tile		= "D1"
					,position	= {x=10.500000, y=1.818555, z=-3.031089}
					,rotation	= {x=0.000599, y=330.015045, z=0.000541}
				}
				,{
					tile		= "E1"
					,position	= {x=7.882883, y=1.757620, z=13.658168}
					,rotation	= {x=0.000768, y=269.977783, z=-0.000250}
				}
				,{
					tile		= "H1"
					,position	= {x=0.000411, y=1.700414, z=-3.031132}
					,rotation	= {x=0.000251, y=0.024830, z=0.000766}
				}
				,{
					tile		= "L1"
					,position	= {x=-2.625035, y=-3.775560, z=6.062130}
					,rotation	= {x=0.000251, y=359.985260, z=0.000767}
				}
				,{
					tile		= "L2"
					,position	= {x=-2.634769, y=7.293605, z=15.154384}
					,rotation	= {x=-0.000250, y=179.984787, z=179.999237}
				}
			}
			--Scenario 13
			,[13] = {
				{
					tile		= "M1"
					,position	= {x=0.000003, y=1.818415, z=-3.031088}
					,rotation	= {x=-0.000250, y=180.000000, z=-0.000767}
				}
				,{
					tile		= "N1"
					,position	= {x=-0.000001, y=1.759068, z=7.577722}
					,rotation	= {x=-0.000251, y=180.014481, z=179.999222}
				}
			}
			--Scenario 14
			,[14] = {
				{
					tile		= "I2"
					,position	= {x=5.688042, y=1.817822, z=12.882142}
					,rotation	= {x=-0.000250, y=179.988480, z=-0.000767}
				}
				,{
					tile		= "K1"
					,position	= {x=3.062098, y=1.749436, z=-2.272619}
					,rotation	= {x=0.000629, y=270.008362, z=-0.000256}
				}
				,{
					tile		= "K2"
					,position	= {x=-2.187503, y=1.749313, z=9.851041}
					,rotation	= {x=-0.000901, y=89.995888, z=0.000242}
				}
			}
			--Scenario 15
			,[15] = {
				{
					tile		= "C1"
					,position	= {x=12.253350, y=1.818235, z=7.575331}
					,rotation	= {x=-0.000499, y=59.832535, z=0.000567}
				}
				,{
					tile		= "D1"
					,position	= {x=5.690457, y=1.818448, z=6.807616}
					,rotation	= {x=0.000171, y=209.979843, z=-0.000787}
				}
				,{
					tile		= "H1"
					,position	= {x=10.938575, y=1.700557, z=-2.267557}
					,rotation	= {x=0.000538, y=239.992493, z=-0.000600}
				}
				,{
					tile		= "H3"
					,position	= {x=9.625000, y=1.700458, z=16.670988}
					,rotation	= {x=-0.000790, y=119.992531, z=-0.000166}
				}
				,{
					tile		= "L1"
					,position	= {x=-3.500015, y=-3.775572, z=6.062175}
					,rotation	= {x=0.000249, y=0.002544, z=0.000768}
				}
			}
			--Scenario 16
			,[16] = {
				{
					tile		= "A2"
					,position	= {x=2.625000, y=1.760130, z=1.515544}
					,rotation	= {x=0.000250, y=0.000001, z=180.000763}
				}
				,{
					tile		= "B4"
					,position	= {x=3.937500, y=1.759177, z=-5.304405}
					,rotation	= {x=0.000251, y=359.990570, z=180.000778}
				}
				,{
					tile		= "I2"
					,position	= {x=5.250000, y=1.817825, z=10.608810}
					,rotation	= {x=-0.000248, y=179.991638, z=-0.000770}
				}
				,{
					tile		= "K2"
					,position	= {x=-2.625000, y=1.749317, z=7.577724}
					,rotation	= {x=-0.000903, y=90.004250, z=0.000241}
				}
			}
			--Scenario 17
			,[17] = {
				{
					tile		= "B3"
					,position	= {x=9.851141, y=1.759225, z=-3.062562}
					,rotation	= {x=0.000184, y=270.007263, z=-0.000076}
				}
				,{
					tile		= "B4"
					,position	= {x=10.609954, y=1.759856, z=3.493242}
					,rotation	= {x=0.015233, y=269.986328, z=0.001767}
				}
				,{
					tile		= "C1"
					,position	= {x=9.851585, y=1.700320, z=10.061893}
					,rotation	= {x=-0.003639, y=150.009308, z=180.001999}
				}
				,{
					tile		= "L1"
					,position	= {x=3.788861, y=7.293769, z=-3.062500}
					,rotation	= {x=0.000766, y=269.984924, z=179.999741}
				}
				,{
					tile		= "L3"
					,position	= {x=-5.304405, y=7.293643, z=-3.062500}
					,rotation	= {x=-0.000765, y=89.993729, z=180.000259}
				}
			}
			--Scenario 18
			,[18] = {
				{
					tile		= "H1"
					,position	= {x=9.187869, y=1.700488, z=8.334728}
					,rotation	= {x=-0.000252, y=179.991699, z=-0.000765}
				}
				,{
					tile		= "H3"
					,position	= {x=9.187529, y=1.700538, z=-2.273269}
					,rotation	= {x=-0.000286, y=179.994522, z=-0.000814}
				}
				,{
					tile		= "M1"
					,position	= {x=-2.625000, y=1.818380, z=-3.031089}
					,rotation	= {x=-0.000250, y=180.005112, z=-0.000764}
				}
			}
			--Scenario 19
			,[19] = {
				{
					tile		= "C1"
					,position	= {x=1.517205, y=1.818107, z=3.490061}
					,rotation	= {x=-0.000601, y=149.980545, z=-0.000540}
				}
				,{
					tile		= "C2"
					,position	= {x=-3.789352, y=1.818065, z=-0.438905}
					,rotation	= {x=-0.000852, y=150.008072, z=-0.000555}
				}
				,{
					tile		= "D1"
					,position	= {x=1.519020, y=1.818437, z=-4.380968}
					,rotation	= {x=0.000386, y=239.958328, z=-0.000750}
				}
				,{
					tile		= "D2"
					,position	= {x=8.336639, y=1.818516, z=-0.436357}
					,rotation	= {x=-0.000238, y=180.021744, z=-0.000647}
				}
				,{
					tile		= "I1"
					,position	= {x=0.757833, y=1.700368, z=10.066877}
					,rotation	= {x=0.000768, y=270.021729, z=179.999741}
				}
			}
			--Scenario 20
			,[20] = {
				{
					tile		= "C1"
					,position	= {x=9.851036, y=1.818235, z=-0.437499}
					,rotation	= {x=-0.000769, y=89.990738, z=0.000251}
				}
				,{
					tile		= "D1"
					,position	= {x=6.819947, y=1.818426, z=15.312499}
					,rotation	= {x=0.000541, y=239.990463, z=-0.000599}
				}
				,{
					tile		= "J1"
					,position	= {x=-0.757772, y=1.818405, z=-3.062500}
					,rotation	= {x=-0.000766, y=89.992966, z=0.000249}
				}
				,{
					tile		= "K1"
					,position	= {x=6.062191, y=1.772112, z=6.124998}
					,rotation	= {x=-0.000128, y=180.000000, z=179.999222}
				}
			}
			--Scenario 21
			,[21] = {
				{
					tile		= "D1"
					,position	= {x=10.062787, y=1.877561, z=0.753055}
					,rotation	= {x=0.858947, y=29.996010, z=0.001053}
				}
				,{
					tile		= "D2"
					,position	= {x=10.062499, y=1.818493, z=9.851038}
					,rotation	= {x=-0.000170, y=29.987665, z=0.000787}
				}
				,{
					tile		= "E1"
					,position	= {x=-5.690080, y=1.757465, z=3.790666}
					,rotation	= {x=-0.000198, y=90.029045, z=0.000203}
				}
				,{
					tile		= "J1"
					,position	= {x=4.812615, y=1.818480, z=-0.759331}
					,rotation	= {x=0.000340, y=0.017731, z=0.000694}
				}
				,{
					tile		= "J2"
					,position	= {x=4.812500, y=1.818416, z=11.366582}
					,rotation	= {x=-0.000545, y=59.993458, z=0.000609}
				}
			}
			--Scenario 22
			,[22] = {
				{
					tile		= "B2"
					,position	= {x=3.789522, y=1.758878, z=7.448952}
					,rotation	= {x=359.993225, y=89.969460, z=180.001862}
				}
				,{
					tile		= "C1"
					,position	= {x=-3.031089, y=1.818080, z=-4.375001}
					,rotation	= {x=-0.000767, y=90.032448, z=0.000252}
				}
				,{
					tile		= "C2"
					,position	= {x=10.608812, y=1.818263, z=-4.375000}
					,rotation	= {x=-0.000768, y=89.993851, z=0.000253}
				}
				,{
					tile		= "D1"
					,position	= {x=11.366583, y=1.818533, z=4.812500}
					,rotation	= {x=-0.000251, y=180.015579, z=-0.000769}
				}
				,{
					tile		= "D2"
					,position	= {x=-3.790344, y=1.877622, z=4.812065}
					,rotation	= {x=0.433291, y=240.015930, z=359.254852}
				}
				,{
					tile		= "M1"
					,position	= {x=3.790383, y=1.818460, z=-0.441127}
					,rotation	= {x=0.000712, y=269.991638, z=-0.000194}
				}
			}
			--Scenario 23
			,[23] = {
				{
					tile		= "D1"
					,position	= {x=-1.750000, y=1.818398, z=-4.546632}
					,rotation	= {x=0.000601, y=330.036621, z=0.000541}
				}
				,{
					tile		= "I1"
					,position	= {x=12.687499, y=1.700555, z=3.788861}
					,rotation	= {x=-0.000249, y=180.009354, z=179.999237}
				}
				,{
					tile		= "K2"
					,position	= {x=3.500003, y=1.772084, z=4.546627}
					,rotation	= {x=0.000887, y=269.988251, z=179.999741}
				}
				,{
					tile		= "M1"
					,position	= {x=-3.062500, y=1.818297, z=14.397672}
					,rotation	= {x=0.000249, y=0.015726, z=0.000766}
				}
			}
			--Scenario 24
			,[24] = {
				{
					tile		= "A2"
					,position	= {x=-1.750000, y=1.760031, z=10.608810}
					,rotation	= {x=0.000250, y=-0.000001, z=180.000778}
				}
				,{
					tile		= "B4"
					,position	= {x=3.499926, y=1.759161, z=-3.031077}
					,rotation	= {x=0.000789, y=300.008881, z=180.000168}
				}
				,{
					tile		= "D2"
					,position	= {x=6.124932, y=1.700470, z=3.031041}
					,rotation	= {x=-0.000599, y=150.008835, z=179.999466}
				}
				,{
					tile		= "G2"
					,position	= {x=-5.687500, y=1.758989, z=8.335494}
					,rotation	= {x=0.000249, y=0.020306, z=0.000768}
				}
				,{
					tile		= "J1"
					,position	= {x=-3.062500, y=1.700357, z=0.757773}
					,rotation	= {x=0.000251, y=0.001335, z=180.000778}
				}
				,{
					tile		= "L2"
					,position	= {x=-0.437354, y=-3.775586, z=18.944258}
					,rotation	= {x=-0.000249, y=179.991531, z=-0.000766}
				}
			}
			--Scenario 25
			,[25] = {
				{
					tile		= "G2"
					,position	= {x=-3.031088, y=1.759088, z=-6.125000}
					,rotation	= {x=0.000769, y=269.994537, z=-0.000246}
				}
				,{
					tile		= "K2"
					,position	= {x=5.304405, y=1.749397, z=13.562500}
					,rotation	= {x=-0.000922, y=119.982834, z=-0.000174}
				}
				,{
					tile		= "N1"
					,position	= {x=4.546588, y=1.759155, z=1.750077}
					,rotation	= {x=-0.000769, y=89.994057, z=0.000252}
				}
			}
			--Scenario 26
			,[26] = {
				{
					tile		= "C1"
					,position	= {x=-3.032757, y=1.819365, z=6.125526}
					,rotation	= {x=359.976318, y=90.016090, z=0.006269}
				}
				,{
					tile		= "J1"
					,position	= {x=6.064925, y=1.818557, z=6.114214}
					,rotation	= {x=0.000642, y=330.152161, z=-0.000918}
				}
				,{
					tile		= "L1"
					,position	= {x=-3.788861, y=-3.775538, z=-3.062500}
					,rotation	= {x=-0.000765, y=89.999794, z=0.000247}
				}
				,{
					tile		= "M1"
					,position	= {x=10.611990, y=1.818517, z=11.382998}
					,rotation	= {x=-0.000486, y=89.970291, z=0.000683}
				}
			}
			--Scenario 27
			,[27] = {
				{
					tile		= "M1"
					,position	= {x=0.000000, y=1.818409, z=-1.750000}
					,rotation	= {x=-0.000764, y=90.016090, z=0.000251}
				}
			}
			--Scenario 28
			,[28] = {
				{
					tile		= "C1"
					,position	= {x=13.125000, y=1.818277, z=0.000000}
					,rotation	= {x=-0.000254, y=180.009369, z=-0.000772}
				}
				,{
					tile		= "C2"
					,position	= {x=-5.250000, y=1.818031, z=-0.000001}
					,rotation	= {x=0.000249, y=0.020069, z=0.000770}
				}
				,{
					tile		= "M1"
					,position	= {x=3.938170, y=1.818458, z=-0.757599}
					,rotation	= {x=0.000260, y=0.006937, z=0.000767}
				}
			}
			--Scenario 29
			,[29] = {
				{
					tile		= "D1"
					,position	= {x=-4.375000, y=1.818356, z=-3.031089}
					,rotation	= {x=-0.000596, y=150.011795, z=-0.000538}
				}
				,{
					tile		= "D2"
					,position	= {x=11.375000, y=1.818567, z=-3.031090}
					,rotation	= {x=-0.000766, y=90.000717, z=0.000250}
				}
				,{
					tile		= "E1"
					,position	= {x=2.189761, y=1.757167, z=-2.273837}
					,rotation	= {x=359.993591, y=89.999954, z=-0.001410}
				}
				,{
					tile		= "J1"
					,position	= {x=3.501265, y=1.820002, z=6.070292}
					,rotation	= {x=0.014112, y=300.007599, z=359.984436}
				}
			}
			--Scenario 30
			,[30] = {
				{
					tile		= "E1"
					,position	= {x=-1.312499, y=1.757579, z=-5.304405}
					,rotation	= {x=-0.000763, y=89.988152, z=0.000246}
				}
				,{
					tile		= "L1"
					,position	= {x=0.000096, y=-3.775512, z=3.031139}
					,rotation	= {x=-0.000250, y=179.991623, z=-0.000764}
				}
				,{
					tile		= "N1"
					,position	= {x=-0.000014, y=1.759048, z=12.124358}
					,rotation	= {x=0.000250, y=359.975983, z=180.000778}
				}
			}
			--Scenario 31
			,[31] = {
				{
					tile		= "G2"
					,position	= {x=7.000000, y=1.759123, z=16.670988}
					,rotation	= {x=-0.000250, y=180.013153, z=-0.000766}
				}
				,{
					tile		= "J1"
					,position	= {x=4.375000, y=1.700440, z=4.546638}
					,rotation	= {x=0.000249, y=359.990662, z=180.000778}
				}
				,{
					tile		= "L2"
					,position	= {x=-2.187500, y=-3.775522, z=-2.273317}
					,rotation	= {x=0.000540, y=240.013611, z=-0.000601}
				}
			}
			--Scenario 32
			,[32] = {
				{
					tile		= "A4"
					,position	= {x=-4.546634, y=1.758302, z=8.750000}
					,rotation	= {x=0.000769, y=270.008545, z=-0.000248}
				}
				,{
					tile		= "G2"
					,position	= {x=-2.273805, y=1.759016, z=12.690136}
					,rotation	= {x=-0.000768, y=89.974014, z=180.000259}
				}
				,{
					tile		= "H2"
					,position	= {x=4.546633, y=1.700470, z=-1.749999}
					,rotation	= {x=-0.000762, y=89.998970, z=0.000247}
				}
				,{
					tile		= "I1"
					,position	= {x=4.544429, y=1.817835, z=6.126389}
					,rotation	= {x=0.000769, y=270.010437, z=-0.000249}
				}
				,{
					tile		= "L1"
					,position	= {x=-3.031243, y=7.293658, z=0.874962}
					,rotation	= {x=0.000765, y=269.991547, z=179.999741}
				}
			}
			--Scenario 33
			,[33] = {
				{
					tile		= "A3"
					,position	= {x=-6.062179, y=1.760035, z=-3.499984}
					,rotation	= {x=0.000597, y=330.008636, z=180.000534}
				}
				,{
					tile		= "A4"
					,position	= {x=-0.759830, y=1.760111, z=-4.810069}
					,rotation	= {x=0.000605, y=329.978729, z=180.000656}
				}
				,{
					tile		= "C2"
					,position	= {x=4.549972, y=1.818177, z=-3.485531}
					,rotation	= {x=0.000755, y=270.083649, z=-0.000252}
				}
				,{
					tile		= "I1"
					,position	= {x=6.062173, y=1.700463, z=4.375792}
					,rotation	= {x=-0.000786, y=89.991333, z=180.000244}
				}
				,{
					tile		= "M1"
					,position	= {x=5.304406, y=1.818413, z=13.562500}
					,rotation	= {x=-0.000768, y=89.995514, z=0.000250}
				}
			}
			--Scenario 34
			,[34] = {
				{
					tile		= "L2"
					,position	= {x=4.546634, y=-3.775433, z=-2.624999}
					,rotation	= {x=0.000771, y=270.007324, z=-0.000249}
				}
				,{
					tile		= "L3"
					,position	= {x=-4.546502, y=-3.775550, z=-2.624971}
					,rotation	= {x=-0.000771, y=90.011734, z=0.000248}
				}
			}
			--Scenario 35
			,[35] = {
				{
					tile		= "B2"
					,position	= {x=3.788860, y=1.759166, z=-3.062517}
					,rotation	= {x=0.000768, y=270.000000, z=179.999741}
				}
				,{
					tile		= "I1"
					,position	= {x=-3.031089, y=1.700380, z=-4.375000}
					,rotation	= {x=-0.000766, y=90.000008, z=180.000259}
				}
				,{
					tile		= "L1"
					,position	= {x=3.788861, y=7.293731, z=4.812500}
					,rotation	= {x=0.000769, y=269.992920, z=179.999741}
				}
				,{
					tile		= "L3"
					,position	= {x=-5.304407, y=7.293611, z=4.812500}
					,rotation	= {x=-0.000768, y=89.999985, z=180.000259}
				}
			}
			--Scenario 36
			,[36] = {
				{
					tile		= "B2"
					,position	= {x=3.788860, y=1.759166, z=-3.062517}
					,rotation	= {x=0.000768, y=270.000000, z=179.999741}
				}
				,{
					tile		= "I1"
					,position	= {x=-3.031089, y=1.700380, z=-4.375000}
					,rotation	= {x=-0.000766, y=90.000008, z=180.000259}
				}
				,{
					tile		= "L1"
					,position	= {x=3.788861, y=7.293731, z=4.812500}
					,rotation	= {x=0.000769, y=269.992920, z=179.999741}
				}
				,{
					tile		= "L3"
					,position	= {x=-5.304407, y=7.293611, z=4.812500}
					,rotation	= {x=-0.000768, y=89.999985, z=180.000259}
				}
			}
			--Scenario 37
			,[37] = {
				{
					tile		= "H2"
					,position	= {x=9.093267, y=1.818515, z=1.749999}
					,rotation	= {x=-0.000770, y=90.002815, z=180.000229}
				}
				,{
					tile		= "J1"
					,position	= {x=-1.515544, y=1.700396, z=-3.500000}
					,rotation	= {x=0.000168, y=209.981827, z=179.999222}
				}
				,{
					tile		= "K2"
					,position	= {x=10.608810, y=1.749462, z=14.875000}
					,rotation	= {x=-0.000922, y=120.015602, z=-0.000174}
				}
			}
			--Scenario 38
			,[38] = {
				{
					tile		= "A4"
					,position	= {x=6.999999, y=1.758429, z=15.155445}
					,rotation	= {x=-0.000249, y=180.008530, z=-0.000762}
				}
				,{
					tile		= "C2"
					,position	= {x=12.250000, y=1.700193, z=16.670988}
					,rotation	= {x=-0.000250, y=179.984482, z=179.999237}
				}
				,{
					tile		= "D1"
					,position	= {x=-4.812500, y=1.700347, z=-2.273318}
					,rotation	= {x=-0.000769, y=90.018120, z=180.000259}
				}
				,{
					tile		= "H2"
					,position	= {x=5.687500, y=1.700488, z=-2.273317}
					,rotation	= {x=-0.000250, y=179.965607, z=-0.000769}
				}
				,{
					tile		= "M1"
					,position	= {x=8.312500, y=1.700483, z=6.819950}
					,rotation	= {x=0.000252, y=0.001583, z=180.000778}
				}
			}
			--Scenario 39
			,[39] = {
				{
					tile		= "D2"
					,position	= {x=-1.515544, y=1.700312, z=15.750000}
					,rotation	= {x=-0.000542, y=59.994717, z=180.000595}
				}
				,{
					tile		= "L2"
					,position	= {x=-0.757772, y=-3.775491, z=-3.937500}
					,rotation	= {x=-0.000768, y=89.994667, z=0.000247}
				}
				,{
					tile		= "N1"
					,position	= {x=0.757773, y=1.759084, z=6.562500}
					,rotation	= {x=0.000767, y=270.008453, z=-0.000247}
				}
			}
			--Scenario 40
			,[40] = {
				{
					tile		= "A4"
					,position	= {x=12.882155, y=1.760237, z=7.437637}
					,rotation	= {x=0.000693, y=270.004272, z=179.999771}
				}
				,{
					tile		= "C1"
					,position	= {x=-3.788733, y=1.818072, z=-3.066215}
					,rotation	= {x=0.000828, y=269.997070, z=-0.000649}
				}
				,{
					tile		= "D1"
					,position	= {x=12.124369, y=1.877377, z=14.001617}
					,rotation	= {x=359.142700, y=180.007675, z=-0.000729}
				}
				,{
					tile		= "D2"
					,position	= {x=5.304405, y=1.818394, z=17.937500}
					,rotation	= {x=-0.000786, y=120.004951, z=-0.000165}
				}
				,{
					tile		= "K2"
					,position	= {x=3.788862, y=1.772122, z=-3.062503}
					,rotation	= {x=0.000912, y=299.994781, z=180.000153}
				}
				,{
					tile		= "L1"
					,position	= {x=-6.062070, y=-3.775609, z=6.124914}
					,rotation	= {x=-0.000766, y=89.991463, z=0.000249}
				}
				,{
					tile		= "M1"
					,position	= {x=4.546634, y=1.818424, z=8.749999}
					,rotation	= {x=-0.000769, y=90.008606, z=0.000249}
				}
			}
			--Scenario 41
			,[41] = {
				{
					tile		= "E1"
					,position	= {x=1.312311, y=1.757535, z=12.879581}
					,rotation	= {x=0.000768, y=269.975220, z=-0.000250}
				}
				,{
					tile		= "L1"
					,position	= {x=0.000097, y=-3.775519, z=4.546682}
					,rotation	= {x=0.000250, y=0.009332, z=0.000768}
				}
				,{
					tile		= "M1"
					,position	= {x=-0.000003, y=1.818415, z=-3.031088}
					,rotation	= {x=0.000251, y=0.015621, z=0.000768}
				}
			}
			--Scenario 42
			,[42] = {
				{
					tile		= "J1"
					,position	= {x=7.000003, y=1.700495, z=0.000001}
					,rotation	= {x=0.000250, y=359.992889, z=180.000778}
				}
				,{
					tile		= "J2"
					,position	= {x=-3.499919, y=1.700354, z=-0.000045}
					,rotation	= {x=-0.000788, y=120.016373, z=179.999832}
				}
				,{
					tile		= "L2"
					,position	= {x=1.750000, y=-3.775502, z=6.062178}
					,rotation	= {x=-0.000250, y=180.008545, z=-0.000767}
				}
			}
			--Scenario 43
			,[43] = {
				{
					tile		= "A2"
					,position	= {x=9.187498, y=1.760214, z=2.273317}
					,rotation	= {x=-0.000249, y=179.979950, z=179.999237}
				}
				,{
					tile		= "A3"
					,position	= {x=9.187499, y=1.758475, z=11.366584}
					,rotation	= {x=0.000249, y=359.991516, z=0.000769}
				}
				,{
					tile		= "E1"
					,position	= {x=-0.000001, y=1.757501, z=16.670988}
					,rotation	= {x=-0.000768, y=89.988182, z=180.000259}
				}
				,{
					tile		= "G2"
					,position	= {x=-6.562500, y=1.758984, z=6.819950}
					,rotation	= {x=-0.000248, y=180.009491, z=-0.000767}
				}
				,{
					tile		= "I2"
					,position	= {x=0.000000, y=1.817821, z=-4.546634}
					,rotation	= {x=-0.000250, y=180.008545, z=-0.000766}
				}
				,{
					tile		= "N1"
					,position	= {x=1.311273, y=1.759089, z=6.819947}
					,rotation	= {x=0.000249, y=359.988190, z=0.000769}
				}
			}
			--Scenario 44
			,[44] = {
				{
					tile		= "B1"
					,position	= {x=3.030647, y=1.759050, z=-4.378831}
					,rotation	= {x=-0.002095, y=270.008606, z=180.001175}
				}
				,{
					tile		= "B3"
					,position	= {x=3.031088, y=1.759092, z=11.375002}
					,rotation	= {x=0.000770, y=269.994507, z=-0.000249}
				}
				,{
					tile		= "B4"
					,position	= {x=-6.062179, y=1.758970, z=11.375001}
					,rotation	= {x=0.000765, y=270.008820, z=-0.000250}
				}
				,{
					tile		= "L1"
					,position	= {x=-6.062178, y=7.293605, z=3.499999}
					,rotation	= {x=-0.000767, y=89.997063, z=180.000259}
				}
				,{
					tile		= "M1"
					,position	= {x=3.030830, y=1.700628, z=3.510613}
					,rotation	= {x=-0.001563, y=270.006897, z=179.999573}
				}
			}
			--Scenario 45
			,[45] = {
				{
					tile		= "D1"
					,position	= {x=-2.273316, y=1.700392, z=-4.812500}
					,rotation	= {x=-0.000538, y=59.991562, z=180.000595}
				}
				,{
					tile		= "F1"
					,position	= {x=-2.273958, y=1.758346, z=16.197662}
					,rotation	= {x=-0.005338, y=180.022171, z=-0.003771}
				}
				,{
					tile		= "G1"
					,position	= {x=9.093266, y=1.759204, z=4.375000}
					,rotation	= {x=-0.000766, y=89.979813, z=0.000249}
				}
				,{
					tile		= "M1"
					,position	= {x=-1.515938, y=1.700585, z=4.372346}
					,rotation	= {x=-0.001074, y=90.016083, z=179.998520}
				}
			}
			--Scenario 46
			,[46] = {
				{
					tile		= "I2"
					,position	= {x=6.819951, y=1.817913, z=-4.812500}
					,rotation	= {x=0.000769, y=269.991425, z=-0.000250}
				}
				,{
					tile		= "J1"
					,position	= {x=-4.546632, y=1.700321, z=4.375000}
					,rotation	= {x=-0.000600, y=150.008270, z=179.999466}
				}
				,{
					tile		= "K2"
					,position	= {x=3.788860, y=1.749422, z=3.062500}
					,rotation	= {x=-0.000382, y=179.989594, z=-0.000774}
				}
			}
			--Scenario 47
			,[47] = {
				{
					tile		= "J1"
					,position	= {x=-0.757773, y=1.818405, z=-3.062500}
					,rotation	= {x=-0.000764, y=89.967308, z=0.000249}
				}
				,{
					tile		= "M1"
					,position	= {x=9.851038, y=1.818535, z=-0.437500}
					,rotation	= {x=0.000769, y=269.993835, z=-0.000251}
				}
			}
			--Scenario 48
			,[48] = {
				{
					tile		= "L1"
					,position	= {x=4.546633, y=7.293774, z=-2.625000}
					,rotation	= {x=0.000771, y=270.008148, z=179.999741}
				}
				,{
					tile		= "L3"
					,position	= {x=-4.546633, y=7.293651, z=-2.625000}
					,rotation	= {x=-0.000771, y=89.994461, z=180.000259}
				}
			}
			--Scenario 49
			,[49] = {
				{
					tile		= "G1"
					,position	= {x=-0.000001, y=1.759042, z=13.639900}
					,rotation	= {x=-0.000250, y=179.994461, z=-0.000766}
				}
				,{
					tile		= "L1"
					,position	= {x=0.000000, y=7.293720, z=-4.546633}
					,rotation	= {x=0.000249, y=359.991455, z=180.000778}
				}
				,{
					tile		= "L3"
					,position	= {x=-0.092576, y=7.293680, z=4.546600}
					,rotation	= {x=-0.000249, y=180.009369, z=179.999222}
				}
			}
			--Scenario 50
			,[50] = {
				{
					tile		= "B2"
					,position	= {x=5.249999, y=1.759191, z=-4.546633}
					,rotation	= {x=0.000251, y=-0.005646, z=180.000763}
				}
				,{
					tile		= "B3"
					,position	= {x=5.249999, y=1.759112, z=13.639900}
					,rotation	= {x=0.000249, y=0.012480, z=180.000778}
				}
				,{
					tile		= "C1"
					,position	= {x=13.125000, y=1.818277, z=0.000000}
					,rotation	= {x=0.000793, y=299.999573, z=0.000167}
				}
				,{
					tile		= "C2"
					,position	= {x=13.124998, y=1.818238, z=9.093268}
					,rotation	= {x=-0.000539, y=59.990578, z=0.000601}
				}
				,{
					tile		= "I1"
					,position	= {x=-3.937500, y=1.700325, z=5.304405}
					,rotation	= {x=0.000248, y=-0.005486, z=180.000778}
				}
				,{
					tile		= "N1"
					,position	= {x=5.249998, y=1.759152, z=4.546633}
					,rotation	= {x=0.000248, y=0.015657, z=180.000778}
				}
			}
			--Scenario 51
			,[51] = {
				{
					tile		= "D1"
					,position	= {x=-0.875002, y=1.818369, z=4.546630}
					,rotation	= {x=-0.000766, y=89.991234, z=0.000251}
				}
				,{
					tile		= "D2"
					,position	= {x=-4.812490, y=1.818347, z=-2.273337}
					,rotation	= {x=-0.000167, y=29.987755, z=0.000791}
				}
				,{
					tile		= "M1"
					,position	= {x=4.373527, y=1.818473, z=-3.031129}
					,rotation	= {x=0.000252, y=359.991821, z=0.000768}
				}
			}
			--Scenario 52
			,[52] = {
				{
					tile		= "J1"
					,position	= {x=-3.070936, y=1.818351, z=2.272812}
					,rotation	= {x=0.000254, y=359.872131, z=0.000766}
				}
				,{
					tile		= "J2"
					,position	= {x=7.437500, y=1.818452, z=11.366583}
					,rotation	= {x=-0.000254, y=179.974625, z=-0.000761}
				}
				,{
					tile		= "K1"
					,position	= {x=10.061447, y=1.772203, z=-2.271296}
					,rotation	= {x=-0.000045, y=30.006456, z=180.000778}
				}
				,{
					tile		= "K2"
					,position	= {x=-4.375000, y=1.771927, z=16.670988}
					,rotation	= {x=-0.000646, y=90.017548, z=180.000244}
				}
				,{
					tile		= "M1"
					,position	= {x=2.194992, y=1.818401, z=6.822117}
					,rotation	= {x=-0.000250, y=179.952271, z=-0.000770}
				}
			}
			--Scenario 53
			,[53] = {
				{
					tile		= "D1"
					,position	= {x=0.757923, y=1.936153, z=-4.812284}
					,rotation	= {x=359.029358, y=299.990875, z=1.286547}
				}
				,{
					tile		= "D2"
					,position	= {x=2.273315, y=1.818373, z=13.562501}
					,rotation	= {x=-0.000791, y=119.983452, z=-0.000168}
				}
				,{
					tile		= "J1"
					,position	= {x=-4.546648, y=1.818586, z=4.375041}
					,rotation	= {x=-0.001470, y=29.990805, z=-0.001239}
				}
				,{
					tile		= "J2"
					,position	= {x=7.578370, y=1.818484, z=4.374330}
					,rotation	= {x=0.000168, y=209.959808, z=-0.000789}
				}
				,{
					tile		= "M1"
					,position	= {x=1.514793, y=1.877715, z=4.374533}
					,rotation	= {x=0.580489, y=89.955116, z=0.297064}
				}
			}
			--Scenario 54
			,[54] = {
				{
					tile		= "G2"
					,position	= {x=-0.000001, y=1.759055, z=10.608812}
					,rotation	= {x=0.000251, y=359.991455, z=0.000764}
				}
				,{
					tile		= "N1"
					,position	= {x=0.000001, y=1.759108, z=-1.515544}
					,rotation	= {x=0.000251, y=-0.005120, z=0.000767}
				}
			}
			--Scenario 55
			,[55] = {}
			--Scenario 56
			,[56] = {
				{
					tile		= "A4"
					,position	= {x=0.759905, y=1.758410, z=-0.438930}
					,rotation	= {x=0.000153, y=209.979294, z=-0.000953}
				}
				,{
					tile		= "C2"
					,position	= {x=-4.546638, y=1.700048, z=-1.750003}
					,rotation	= {x=-0.000766, y=90.009460, z=180.000259}
				}
				,{
					tile		= "L3"
					,position	= {x=-5.304406, y=7.293598, z=7.437500}
					,rotation	= {x=-0.000768, y=90.008545, z=180.000259}
				}
				,{
					tile		= "M1"
					,position	= {x=8.335494, y=1.700526, z=-3.062501}
					,rotation	= {x=-0.000167, y=29.981615, z=180.000778}
				}
			}
			--Scenario 57
			,[57] = {
				{
					tile		= "A1"
					,position	= {x=1.515544, y=1.758425, z=-0.874999}
					,rotation	= {x=-0.000764, y=89.988457, z=0.000250}
				}
				,{
					tile		= "C1"
					,position	= {x=-5.300888, y=1.817971, z=13.560151}
					,rotation	= {x=0.000764, y=269.993347, z=-0.000251}
				}
				,{
					tile		= "C2"
					,position	= {x=-5.304408, y=1.818051, z=-4.812535}
					,rotation	= {x=-0.000770, y=89.999985, z=0.000247}
				}
				,{
					tile		= "F1"
					,position	= {x=-4.546633, y=1.758822, z=4.375001}
					,rotation	= {x=0.000249, y=-0.005271, z=0.000767}
				}
				,{
					tile		= "I1"
					,position	= {x=1.515544, y=1.700380, z=9.625001}
					,rotation	= {x=0.000768, y=270.008514, z=179.999756}
				}
			}
			--Scenario 58
			,[58] = {
				{
					tile		= "B1"
					,position	= {x=-5.250000, y=1.759031, z=0.000000}
					,rotation	= {x=-0.000245, y=179.994553, z=-0.000768}
				}
				,{
					tile		= "C2"
					,position	= {x=5.250000, y=1.700191, z=-4.546633}
					,rotation	= {x=-0.000250, y=179.990158, z=179.999222}
				}
				,{
					tile		= "D1"
					,position	= {x=6.562500, y=1.700466, z=5.304405}
					,rotation	= {x=-0.000159, y=29.987648, z=180.000793}
				}
				,{
					tile		= "G2"
					,position	= {x=0.000000, y=1.759101, z=0.000000}
					,rotation	= {x=0.000250, y=0.000000, z=180.000778}
				}
			}
			--Scenario 59
			,[59] = {
				{
					tile		= "A4"
					,position	= {x=10.500000, y=1.758548, z=-1.515544}
					,rotation	= {x=-0.000251, y=179.979584, z=-0.000766}
				}
				,{
					tile		= "D1"
					,position	= {x=5.249998, y=1.700485, z=-3.031089}
					,rotation	= {x=-0.000600, y=150.008347, z=179.999466}
				}
				,{
					tile		= "L3"
					,position	= {x=11.812502, y=7.293839, z=5.304446}
					,rotation	= {x=0.000250, y=359.991547, z=180.000778}
				}
				,{
					tile		= "M1"
					,position	= {x=-3.937500, y=1.700365, z=-3.788861}
					,rotation	= {x=0.000247, y=-0.000005, z=180.000778}
				}
			}
			--Scenario 60
			,[60] = {
				{
					tile		= "B1"
					,position	= {x=10.608810, y=1.759205, z=8.750000}
					,rotation	= {x=0.000762, y=270.012329, z=-0.000249}
				}
				,{
					tile		= "B2"
					,position	= {x=9.850817, y=1.759258, z=-5.689857}
					,rotation	= {x=0.000770, y=270.024597, z=-0.000251}
				}
				,{
					tile		= "B3"
					,position	= {x=0.000000, y=1.759075, z=6.125000}
					,rotation	= {x=0.000763, y=269.991455, z=-0.000250}
				}
				,{
					tile		= "B4"
					,position	= {x=-5.304405, y=1.759055, z=-5.687500}
					,rotation	= {x=0.000763, y=270.011810, z=-0.000251}
				}
				,{
					tile		= "G2"
					,position	= {x=0.000000, y=1.759098, z=0.874999}
					,rotation	= {x=-0.000770, y=90.012405, z=180.000259}
				}
				,{
					tile		= "I2"
					,position	= {x=9.851193, y=1.700524, z=2.189857}
					,rotation	= {x=0.000769, y=270.024597, z=179.999741}
				}
			}
			--Scenario 61
			,[61] = {
				{
					tile		= "A1"
					,position	= {x=-0.757773, y=1.758374, z=3.937500}
					,rotation	= {x=0.000766, y=269.977570, z=-0.000251}
				}
				,{
					tile		= "A3"
					,position	= {x=-0.757786, y=1.760024, z=14.437469}
					,rotation	= {x=0.000692, y=270.001038, z=179.999756}
				}
				,{
					tile		= "C1"
					,position	= {x=0.757701, y=1.888350, z=19.687405}
					,rotation	= {x=0.899262, y=329.984741, z=359.495117}
				}
				,{
					tile		= "D1"
					,position	= {x=-3.788862, y=1.818311, z=9.187500}
					,rotation	= {x=0.000790, y=299.988190, z=0.000168}
				}
				,{
					tile		= "M1"
					,position	= {x=0.757770, y=1.818429, z=-3.937501}
					,rotation	= {x=-0.000768, y=90.000000, z=0.000251}
				}
			}
			--Scenario 62
			,[62] = {
				{
					tile		= "B2"
					,position	= {x=0.000000, y=1.759078, z=5.250000}
					,rotation	= {x=-0.000763, y=89.991455, z=180.000259}
				}
				,{
					tile		= "M1"
					,position	= {x=0.000000, y=1.818413, z=-2.625000}
					,rotation	= {x=-0.000768, y=89.989304, z=0.000250}
				}
			}
			--Scenario 63
			,[63] = {
				{
					tile		= "D2"
					,position	= {x=-0.757772, y=1.700339, z=11.812500}
					,rotation	= {x=0.000251, y=-0.003003, z=180.000763}
				}
				,{
					tile		= "I2"
					,position	= {x=-0.757773, y=1.817774, z=3.937500}
					,rotation	= {x=-0.000767, y=89.997185, z=0.000251}
				}
				,{
					tile		= "K1"
					,position	= {x=2.273314, y=1.749432, z=-3.937499}
					,rotation	= {x=0.000117, y=359.984253, z=0.000761}
				}
			}
			--Scenario 64
			,[64] = {
				{
					tile		= "D2"
					,position	= {x=-3.788862, y=1.700341, z=2.187500}
					,rotation	= {x=0.000248, y=-0.003007, z=180.000778}
				}
				,{
					tile		= "K1"
					,position	= {x=5.304405, y=1.749469, z=-3.062496}
					,rotation	= {x=0.000118, y=359.993866, z=0.000759}
				}
				,{
					tile		= "M1"
					,position	= {x=9.093266, y=1.700497, z=6.124999}
					,rotation	= {x=0.000769, y=269.994568, z=179.999741}
				}
			}
			--Scenario 65
			,[65] = {
				{
					tile		= "B1"
					,position	= {x=-5.304405, y=1.759028, z=0.437501}
					,rotation	= {x=-0.000770, y=90.010620, z=0.000250}
				}
				,{
					tile		= "B2"
					,position	= {x=11.366583, y=1.759251, z=0.437501}
					,rotation	= {x=-0.000767, y=90.008530, z=0.000249}
				}
				,{
					tile		= "B3"
					,position	= {x=-5.304405, y=1.758983, z=10.937500}
					,rotation	= {x=-0.000769, y=89.988197, z=0.000250}
				}
				,{
					tile		= "B4"
					,position	= {x=11.364551, y=1.759205, z=10.937496}
					,rotation	= {x=-0.000768, y=89.975029, z=0.000251}
				}
				,{
					tile		= "H1"
					,position	= {x=3.788708, y=1.818461, z=-2.188061}
					,rotation	= {x=0.000764, y=270.010681, z=179.999741}
				}
				,{
					tile		= "H2"
					,position	= {x=3.788613, y=1.818421, z=8.299676}
					,rotation	= {x=0.000596, y=269.916199, z=179.994324}
				}
				,{
					tile		= "I2"
					,position	= {x=2.273319, y=1.700361, z=16.187014}
					,rotation	= {x=0.000767, y=270.027863, z=179.999756}
				}
			}
			--Scenario 66
			,[66] = {
				{
					tile		= "A1"
					,position	= {x=13.126114, y=1.758529, z=7.577855}
					,rotation	= {x=0.000825, y=-0.005364, z=-0.001691}
				}
				,{
					tile		= "A2"
					,position	= {x=6.562832, y=1.797574, z=-5.303115}
					,rotation	= {x=-0.000677, y=59.963940, z=358.271362}
				}
				,{
					tile		= "C1"
					,position	= {x=3.935515, y=1.818142, z=12.883663}
					,rotation	= {x=-0.000775, y=180.070679, z=-0.000213}
				}
				,{
					tile		= "C2"
					,position	= {x=-3.941544, y=1.818051, z=0.757600}
					,rotation	= {x=-0.001302, y=120.012764, z=-0.000253}
				}
				,{
					tile		= "D1"
					,position	= {x=6.559217, y=1.820552, z=6.817923}
					,rotation	= {x=359.983521, y=149.998764, z=0.024635}
				}
				,{
					tile		= "D2"
					,position	= {x=2.626877, y=1.818110, z=-0.002047}
					,rotation	= {x=0.000012, y=209.990265, z=359.989746}
				}
				,{
					tile		= "J1"
					,position	= {x=-5.250001, y=1.700265, z=15.155450}
					,rotation	= {x=0.000790, y=300.013580, z=180.000168}
				}
			}
			--Scenario 67
			,[67] = {
				{
					tile		= "A2"
					,position	= {x=3.788860, y=1.758458, z=-1.312498}
					,rotation	= {x=-0.000768, y=90.010597, z=0.000249}
				}
				,{
					tile		= "G1"
					,position	= {x=1.515544, y=1.759144, z=-5.250000}
					,rotation	= {x=0.000767, y=269.990967, z=179.999741}
				}
				,{
					tile		= "L3"
					,position	= {x=-4.546633, y=7.293629, z=2.625000}
					,rotation	= {x=-0.000772, y=90.000000, z=180.000259}
				}
				,{
					tile		= "M1"
					,position	= {x=12.124355, y=1.818564, z=0.000000}
					,rotation	= {x=-0.000765, y=89.975029, z=0.000251}
				}
			}
			--Scenario 68
			,[68] = {
				{
					tile		= "B1"
					,position	= {x=4.823019, y=1.758884, z=-3.789103}
					,rotation	= {x=359.992645, y=180.012161, z=180.000854}
				}
				,{
					tile		= "C2"
					,position	= {x=10.062500, y=1.700193, z=9.851039}
					,rotation	= {x=0.000540, y=239.990662, z=179.999405}
				}
				,{
					tile		= "G1"
					,position	= {x=4.812499, y=1.759143, z=5.304407}
					,rotation	= {x=-0.000249, y=180.009323, z=-0.000771}
				}
				,{
					tile		= "M1"
					,position	= {x=-3.069514, y=1.701231, z=-3.786652}
					,rotation	= {x=359.988953, y=180.066467, z=179.998566}
				}
			}
			--Scenario 69
			,[69] = {
				{
					tile		= "B1"
					,position	= {x=4.812500, y=1.759189, z=-5.304405}
					,rotation	= {x=-0.000248, y=180.012161, z=179.999237}
				}
				,{
					tile		= "D2"
					,position	= {x=6.125000, y=1.818463, z=4.546633}
					,rotation	= {x=-0.000596, y=150.011810, z=-0.000534}
				}
				,{
					tile		= "J1"
					,position	= {x=-0.437502, y=1.818373, z=5.304408}
					,rotation	= {x=-0.000541, y=59.994450, z=0.000601}
				}
				,{
					tile		= "L3"
					,position	= {x=-3.062500, y=7.293677, z=-3.788861}
					,rotation	= {x=-0.000249, y=180.016815, z=179.999222}
				}
			}
			--Scenario 70
			,[70] = {
				{
					tile		= "A2"
					,position	= {x=2.265996, y=1.760092, z=9.193423}
					,rotation	= {x=0.000596, y=330.285828, z=180.000534}
				}
				,{
					tile		= "A3"
					,position	= {x=10.608810, y=1.758520, z=5.250000}
					,rotation	= {x=0.000767, y=270.011475, z=-0.000251}
				}
				,{
					tile		= "D2"
					,position	= {x=9.117196, y=1.700478, z=10.495294}
					,rotation	= {x=-0.000541, y=60.102638, z=180.000595}
				}
				,{
					tile		= "E1"
					,position	= {x=-3.814193, y=1.757494, z=6.568728}
					,rotation	= {x=-0.000542, y=60.294487, z=180.000595}
				}
				,{
					tile		= "L1"
					,position	= {x=12.124355, y=7.293877, z=-2.625000}
					,rotation	= {x=-0.000766, y=90.005257, z=180.000259}
				}
				,{
					tile		= "L3"
					,position	= {x=6.062177, y=7.293795, z=-2.625000}
					,rotation	= {x=0.000767, y=270.008545, z=179.999741}
				}
			}
			--Scenario 71
			,[71] = {
				{
					tile		= "A2"
					,position	= {x=3.937500, y=1.760177, z=-5.306594}
					,rotation	= {x=-0.000251, y=180.005524, z=179.999237}
				}
				,{
					tile		= "A3"
					,position	= {x=10.499999, y=1.758476, z=15.155444}
					,rotation	= {x=0.000251, y=0.015803, z=0.000770}
				}
				,{
					tile		= "A4"
					,position	= {x=-1.312500, y=1.758374, z=2.273317}
					,rotation	= {x=-0.000250, y=180.008484, z=-0.000770}
				}
				,{
					tile		= "B1"
					,position	= {x=2.625000, y=1.759051, z=19.702078}
					,rotation	= {x=-0.000249, y=180.008392, z=179.999222}
				}
				,{
					tile		= "C2"
					,position	= {x=-5.250000, y=1.699965, z=15.155445}
					,rotation	= {x=0.000787, y=299.999939, z=180.000168}
				}
				,{
					tile		= "G2"
					,position	= {x=14.437500, y=1.759278, z=3.788861}
					,rotation	= {x=0.000249, y=0.009328, z=0.000771}
				}
				,{
					tile		= "H2"
					,position	= {x=5.250000, y=1.700459, z=3.031089}
					,rotation	= {x=0.000257, y=0.024666, z=0.000769}
				}
				,{
					tile		= "L3"
					,position	= {x=2.625000, y=7.293683, z=12.124355}
					,rotation	= {x=0.000248, y=0.001089, z=180.000763}
				}
			}
			--Scenario 72
			,[72] = {
				{
					tile		= "L1"
					,position	= {x=12.124355, y=7.293876, z=-2.625000}
					,rotation	= {x=0.000767, y=270.017822, z=179.999741}
				}
				,{
					tile		= "L3"
					,position	= {x=-4.546633, y=7.293655, z=-2.625000}
					,rotation	= {x=0.000767, y=270.001648, z=179.999741}
				}
				,{
					tile		= "M1"
					,position	= {x=3.031088, y=1.700453, z=-2.624999}
					,rotation	= {x=0.000767, y=269.991455, z=179.999741}
				}
			}
			--Scenario 73
			,[73] = {
				{
					tile		= "E1"
					,position	= {x=11.366583, y=1.757732, z=-1.312500}
					,rotation	= {x=-0.000250, y=179.984985, z=179.999222}
				}
				,{
					tile		= "L3"
					,position	= {x=-4.546633, y=7.293655, z=-2.625000}
					,rotation	= {x=0.000767, y=270.001648, z=179.999741}
				}
				,{
					tile		= "M1"
					,position	= {x=3.031088, y=1.700453, z=-2.624999}
					,rotation	= {x=0.000767, y=269.991455, z=179.999741}
				}
			}
			--Scenario 74
			,[74] = {
				{
					tile		= "B1"
					,position	= {x=0.000000, y=1.759071, z=7.000000}
					,rotation	= {x=0.000767, y=270.005585, z=-0.000249}
				}
				,{
					tile		= "G2"
					,position	= {x=0.000469, y=1.759094, z=1.748923}
					,rotation	= {x=-0.000768, y=90.000519, z=180.000259}
				}
				,{
					tile		= "I1"
					,position	= {x=-5.304410, y=1.817751, z=-4.812468}
					,rotation	= {x=0.000765, y=269.999969, z=-0.000252}
				}
				,{
					tile		= "I2"
					,position	= {x=3.788860, y=1.700473, z=-4.812500}
					,rotation	= {x=0.000767, y=270.002350, z=179.999756}
				}
			}
			--Scenario 75
			,[75] = {
				{
					tile		= "B1"
					,position	= {x=-6.062178, y=1.759001, z=4.375000}
					,rotation	= {x=-0.000769, y=89.988129, z=180.000259}
				}
				,{
					tile		= "G1"
					,position	= {x=6.062176, y=1.759163, z=4.374985}
					,rotation	= {x=-0.000769, y=89.999969, z=0.000251}
				}
				,{
					tile		= "L1"
					,position	= {x=1.515523, y=7.293736, z=-3.499997}
					,rotation	= {x=-0.000772, y=90.001305, z=180.000259}
				}
				,{
					tile		= "L3"
					,position	= {x=-4.546633, y=7.293659, z=-3.499999}
					,rotation	= {x=0.000767, y=270.001709, z=179.999756}
				}
			}
			--Scenario 76
			,[76] = {
				{
					tile		= "A2"
					,position	= {x=-2.630620, y=1.760073, z=-1.515271}
					,rotation	= {x=0.000252, y=0.004453, z=180.000763}
				}
				,{
					tile		= "A3"
					,position	= {x=-6.562496, y=1.758317, z=-0.757779}
					,rotation	= {x=-0.000251, y=179.968491, z=-0.000771}
				}
				,{
					tile		= "B1"
					,position	= {x=3.937769, y=1.759132, z=14.398910}
					,rotation	= {x=0.001212, y=0.020831, z=180.000778}
				}
				,{
					tile		= "B4"
					,position	= {x=3.937960, y=1.759164, z=-2.271097}
					,rotation	= {x=0.000251, y=0.007829, z=180.000763}
				}
				,{
					tile		= "E1"
					,position	= {x=-0.000941, y=1.757626, z=7.578481}
					,rotation	= {x=0.001900, y=269.985504, z=179.999847}
				}
				,{
					tile		= "G2"
					,position	= {x=9.187499, y=1.759234, z=-2.273316}
					,rotation	= {x=0.000251, y=359.991486, z=0.000772}
				}
				,{
					tile		= "H2"
					,position	= {x=6.562510, y=1.818460, z=6.819956}
					,rotation	= {x=-0.000249, y=179.990814, z=179.999222}
				}
			}
			--Scenario 77
			,[77] = {
				{
					tile		= "B2"
					,position	= {x=-5.304406, y=1.759044, z=-3.062500}
					,rotation	= {x=-0.000769, y=89.999771, z=180.000244}
				}
				,{
					tile		= "B3"
					,position	= {x=12.882127, y=1.759287, z=-3.062502}
					,rotation	= {x=-0.000767, y=90.000008, z=180.000259}
				}
				,{
					tile		= "M1"
					,position	= {x=3.788858, y=1.818420, z=7.437465}
					,rotation	= {x=-0.000765, y=89.999992, z=0.000251}
				}
				,{
					tile		= "N1"
					,position	= {x=3.788903, y=1.759165, z=-3.062554}
					,rotation	= {x=-0.000766, y=89.994263, z=180.000259}
				}
			}
			--Scenario 78
			,[78] = {
				{
					tile		= "F1"
					,position	= {x=-6.062179, y=1.758787, z=7.874999}
					,rotation	= {x=-0.000251, y=179.984177, z=179.999222}
				}
				,{
					tile		= "I1"
					,position	= {x=1.515543, y=1.700440, z=-5.250008}
					,rotation	= {x=-0.000852, y=90.000053, z=180.000259}
				}
				,{
					tile		= "M1"
					,position	= {x=0.757755, y=1.876818, z=3.938236}
					,rotation	= {x=-0.000966, y=90.000122, z=0.644961}
				}
			}
			--Scenario 79
			,[79] = {
				{
					tile		= "C2"
					,position	= {x=4.546635, y=1.818082, z=18.375000}
					,rotation	= {x=0.000603, y=329.992950, z=0.000538}
				}
				,{
					tile		= "D2"
					,position	= {x=5.304775, y=1.818469, z=1.311467}
					,rotation	= {x=0.000740, y=300.020874, z=0.000608}
				}
				,{
					tile		= "K1"
					,position	= {x=-3.031006, y=1.772028, z=-2.623991}
					,rotation	= {x=0.000662, y=240.012939, z=179.999390}
				}
				,{
					tile		= "K2"
					,position	= {x=13.639899, y=1.772252, z=-2.624999}
					,rotation	= {x=-0.000669, y=119.965851, z=179.999832}
				}
				,{
					tile		= "M1"
					,position	= {x=6.062333, y=1.818456, z=10.518473}
					,rotation	= {x=-0.000560, y=90.023521, z=0.000564}
				}
			}
			--Scenario 80
			,[80] = {
				{
					tile		= "A1"
					,position	= {x=-1.517151, y=1.758411, z=-7.000001}
					,rotation	= {x=-0.000767, y=89.991508, z=0.000247}
				}
				,{
					tile		= "B1"
					,position	= {x=12.882128, y=1.759287, z=-3.062500}
					,rotation	= {x=0.000169, y=210.011673, z=-0.000790}
				}
				,{
					tile		= "D1"
					,position	= {x=6.820010, y=1.759453, z=2.187573}
					,rotation	= {x=0.428881, y=179.987595, z=179.256027}
				}
				,{
					tile		= "H1"
					,position	= {x=-2.273330, y=1.700373, z=-0.437956}
					,rotation	= {x=0.000771, y=270.003571, z=-0.000246}
				}
				,{
					tile		= "J1"
					,position	= {x=7.577717, y=1.818479, z=8.749993}
					,rotation	= {x=-0.000549, y=150.009369, z=-0.000820}
				}
				,{
					tile		= "L1"
					,position	= {x=-1.515459, y=-3.775570, z=11.375222}
					,rotation	= {x=0.000768, y=269.994507, z=-0.000249}
				}
			}
			--Scenario 81
			,[81] = {
				{
					tile		= "D1"
					,position	= {x=2.187637, y=1.818427, z=0.758152}
					,rotation	= {x=-0.000170, y=29.976475, z=0.000788}
				}
				,{
					tile		= "J1"
					,position	= {x=-3.062485, y=1.818364, z=-0.759938}
					,rotation	= {x=0.000246, y=0.016912, z=0.000777}
				}
				,{
					tile		= "J2"
					,position	= {x=-3.062495, y=1.818311, z=11.366585}
					,rotation	= {x=-0.000544, y=60.012299, z=0.000603}
				}
			}
			--Scenario 82
			,[82] = {
				{
					tile		= "B2"
					,position	= {x=4.545657, y=1.759109, z=12.248397}
					,rotation	= {x=0.000770, y=269.993530, z=179.999741}
				}
				,{
					tile		= "C1"
					,position	= {x=-2.273316, y=1.818057, z=3.062495}
					,rotation	= {x=0.000766, y=269.980042, z=-0.000251}
				}
				,{
					tile		= "D1"
					,position	= {x=6.062176, y=1.818463, z=4.374999}
					,rotation	= {x=-0.000791, y=119.984337, z=-0.000166}
				}
				,{
					tile		= "I1"
					,position	= {x=-2.271123, y=1.700323, z=10.937680}
					,rotation	= {x=-0.000767, y=90.006157, z=180.000259}
				}
				,{
					tile		= "K1"
					,position	= {x=1.515544, y=1.772093, z=-3.500000}
					,rotation	= {x=0.000375, y=359.974243, z=180.000763}
				}
			}
			--Scenario 83
			,[83] = {
				{
					tile		= "H1"
					,position	= {x=-0.757772, y=1.700320, z=16.187500}
					,rotation	= {x=-0.000768, y=90.003670, z=0.000248}
				}
				,{
					tile		= "I1"
					,position	= {x=-0.758044, y=1.700365, z=5.685981}
					,rotation	= {x=0.000741, y=270.000061, z=179.999756}
				}
				,{
					tile		= "M1"
					,position	= {x=0.000000, y=1.818417, z=-3.499999}
					,rotation	= {x=0.000768, y=270.006348, z=-0.000251}
				}
			}
			--Scenario 84
			,[84] = {
				{
					tile		= "A2"
					,position	= {x=7.875000, y=1.760227, z=-4.546633}
					,rotation	= {x=-0.000250, y=180.012283, z=179.999237}
				}
				,{
					tile		= "A3"
					,position	= {x=-7.877328, y=1.758316, z=-4.546613}
					,rotation	= {x=-0.000250, y=180.037796, z=-0.000772}
				}
				,{
					tile		= "E1"
					,position	= {x=-1.312500, y=1.757540, z=3.788861}
					,rotation	= {x=-0.000765, y=89.994133, z=180.000259}
				}
				,{
					tile		= "L2"
					,position	= {x=-0.016881, y=-3.775479, z=-4.548751}
					,rotation	= {x=0.000249, y=0.012583, z=0.000769}
				}
			}
			--Scenario 85
			,[85] = {
				{
					tile		= "C1"
					,position	= {x=4.546633, y=1.818181, z=-4.375000}
					,rotation	= {x=-0.000768, y=89.990479, z=0.000249}
				}
				,{
					tile		= "C2"
					,position	= {x=-3.788861, y=1.818064, z=-3.062500}
					,rotation	= {x=-0.000766, y=90.023605, z=0.000249}
				}
				,{
					tile		= "D1"
					,position	= {x=3.788860, y=1.818385, z=15.312500}
					,rotation	= {x=0.000252, y=359.990692, z=0.000768}
				}
				,{
					tile		= "D2"
					,position	= {x=-3.031089, y=1.818311, z=11.375000}
					,rotation	= {x=-0.000791, y=119.995674, z=-0.000168}
				}
				,{
					tile		= "F1"
					,position	= {x=5.304350, y=1.758953, z=4.813320}
					,rotation	= {x=-0.000251, y=180.005447, z=179.999222}
				}
				,{
					tile		= "I1"
					,position	= {x=-4.546633, y=1.700325, z=3.500000}
					,rotation	= {x=0.000767, y=270.017700, z=179.999756}
				}
			}
			--Scenario 86
			,[86] = {
				{
					tile		= "A4"
					,position	= {x=2.623448, y=1.759463, z=15.156006}
					,rotation	= {x=0.015391, y=180.021515, z=359.993896}
				}
				,{
					tile		= "B1"
					,position	= {x=9.190023, y=1.759174, z=17.429348}
					,rotation	= {x=-0.000085, y=0.005227, z=180.000992}
				}
				,{
					tile		= "B2"
					,position	= {x=-3.937500, y=1.759019, z=6.819950}
					,rotation	= {x=-0.000251, y=180.022949, z=-0.000768}
				}
				,{
					tile		= "B3"
					,position	= {x=11.820513, y=1.759226, z=6.820003}
					,rotation	= {x=0.000152, y=0.021722, z=0.000728}
				}
				,{
					tile		= "H3"
					,position	= {x=6.562501, y=1.818499, z=-2.273317}
					,rotation	= {x=-0.000258, y=180.005020, z=179.999222}
				}
				,{
					tile		= "M1"
					,position	= {x=3.929154, y=1.700426, z=6.820070}
					,rotation	= {x=-0.000267, y=180.021652, z=179.999222}
				}
			}
			--Scenario 87
			,[87] = {
				{
					tile		= "D2"
					,position	= {x=-4.811687, y=1.700353, z=-3.788293}
					,rotation	= {x=-0.000599, y=150.013000, z=179.999466}
				}
				,{
					tile		= "L2"
					,position	= {x=4.375147, y=-3.775434, z=-1.515592}
					,rotation	= {x=-0.000247, y=179.980026, z=-0.000767}
				}
				,{
					tile		= "L3"
					,position	= {x=4.375145, y=-3.775461, z=4.546585}
					,rotation	= {x=0.000252, y=359.980042, z=0.000766}
				}
			}
			--Scenario 88
			,[88] = {
				{
					tile		= "D2"
					,position	= {x=3.031089, y=1.700392, z=11.375000}
					,rotation	= {x=0.000249, y=0.008379, z=180.000763}
				}
				,{
					tile		= "G2"
					,position	= {x=-2.273318, y=1.759050, z=4.812499}
					,rotation	= {x=0.000767, y=270.005493, z=-0.000248}
				}
				,{
					tile		= "N1"
					,position	= {x=-2.273318, y=1.759084, z=-3.062500}
					,rotation	= {x=-0.000766, y=90.005531, z=0.000250}
				}
			}
			--Scenario 89
			,[89] = {
				{
					tile		= "B1"
					,position	= {x=3.788860, y=1.759131, z=4.812500}
					,rotation	= {x=0.000769, y=269.994507, z=-0.000250}
				}
				,{
					tile		= "B2"
					,position	= {x=-4.546634, y=1.759037, z=0.875001}
					,rotation	= {x=-0.000770, y=89.991463, z=0.000250}
				}
				,{
					tile		= "B3"
					,position	= {x=13.639898, y=1.759246, z=8.750000}
					,rotation	= {x=0.000763, y=269.994507, z=-0.000249}
				}
				,{
					tile		= "H3"
					,position	= {x=4.546632, y=1.818470, z=-1.749999}
					,rotation	= {x=0.000766, y=270.000153, z=179.999741}
				}
				,{
					tile		= "I2"
					,position	= {x=12.882127, y=1.700565, z=2.187500}
					,rotation	= {x=0.000765, y=269.994446, z=179.999756}
				}
			}
			--Scenario 90
			,[90] = {
				{
					tile		= "C2"
					,position	= {x=12.686906, y=1.700349, z=-2.273919}
					,rotation	= {x=-0.001130, y=239.978943, z=180.000931}
				}
				,{
					tile		= "D1"
					,position	= {x=6.120607, y=1.704280, z=-3.030633}
					,rotation	= {x=0.085626, y=330.015594, z=180.048630}
				}
				,{
					tile		= "M1"
					,position	= {x=-3.062500, y=1.700371, z=-2.273317}
					,rotation	= {x=-0.000252, y=179.998306, z=179.999222}
				}
			}
			--Scenario 91
			,[91] = {
				{
					tile		= "G1"
					,position	= {x=4.812500, y=1.759176, z=-2.273316}
					,rotation	= {x=0.000253, y=0.020002, z=0.000765}
				}
				,{
					tile		= "H2"
					,position	= {x=-4.375000, y=1.700356, z=-3.031089}
					,rotation	= {x=0.000252, y=0.013148, z=0.000768}
				}
				,{
					tile		= "M1"
					,position	= {x=12.687500, y=1.700561, z=2.273317}
					,rotation	= {x=-0.000252, y=179.999420, z=179.999222}
				}
			}
			--Scenario 92
			,[92] = {
				{
					tile		= "F1"
					,position	= {x=3.788848, y=1.758932, z=4.812500}
					,rotation	= {x=0.000250, y=0.000001, z=180.000763}
				}
				,{
					tile		= "H3"
					,position	= {x=-4.546118, y=1.700348, z=-1.749809}
					,rotation	= {x=-0.000767, y=89.987854, z=0.000249}
				}
			}
			--Scenario 93
			,[93] = {
				{
					tile		= "B3"
					,position	= {x=14.397672, y=1.759307, z=-3.062500}
					,rotation	= {x=0.000768, y=270.007202, z=-0.000247}
				}
				,{
					tile		= "G1"
					,position	= {x=-3.031088, y=1.759068, z=-1.750000}
					,rotation	= {x=0.000599, y=330.016144, z=0.000542}
				}
				,{
					tile		= "I1"
					,position	= {x=6.062174, y=1.817890, z=-1.752348}
				,rotation	= {x=0.000768, y=269.986725, z=-0.000251}
				}
				,{
					tile		= "K2"
					,position	= {x=3.030204, y=1.749399, z=6.124488}
					,rotation	= {x=-0.000380, y=180.007431, z=-0.000775}
				}
			}
			--Scenario 94
			,[94] = {
				{
					tile		= "C2"
					,position	= {x=-1.312500, y=1.700067, z=3.788862}
					,rotation	= {x=0.000541, y=239.980316, z=179.999405}
				}
				,{
					tile		= "D1"
					,position	= {x=-3.937500, y=1.700365, z=-3.788862}
					,rotation	= {x=0.000602, y=330.000031, z=180.000534}
				}
				,{
					tile		= "H2"
					,position	= {x=7.875000, y=1.700480, z=6.062178}
					,rotation	= {x=0.000251, y=0.008461, z=0.000765}
				}
				,{
					tile		= "M1"
					,position	= {x=5.250000, y=1.700485, z=-3.031089}
					,rotation	= {x=-0.000252, y=179.999878, z=179.999222}
				}
			}
			--Scenario 95
			,[95] = {
				{
					tile		= "D1"
					,position	= {x=-3.937501, y=1.818365, z=-3.788861}
					,rotation	= {x=-0.000602, y=149.993881, z=-0.000539}
				}
				,{
					tile		= "E1"
					,position	= {x=3.936508, y=1.757583, z=9.851589}
					,rotation	= {x=0.000766, y=269.982849, z=-0.000248}
				}
				,{
					tile		= "G1"
					,position	= {x=2.624997, y=1.759137, z=-0.001164}
					,rotation	= {x=-0.000251, y=179.991455, z=179.999237}
				}
				,{
					tile		= "K2"
					,position	= {x=11.812501, y=1.772219, z=-0.757773}
					,rotation	= {x=0.000288, y=210.009308, z=179.999207}
				}
			}
		}

		for _,tMap in ipairs(t[NumScenario]) do
			
			local obj_parameters = {}
			obj_parameters.type = 'Custom_Model'
			obj_parameters.position = tMap.position
			obj_parameters.rotation = tMap.rotation
			--obj_parameters.nickname = tMap.tile
			obj = spawnObject(obj_parameters)
			obj.setLock(true)
			
			custom = {}
			custom.mesh = allTheMapTiles[tMap.tile][1]
			custom.diffuse = allTheMapTiles[tMap.tile][2]
			custom.material = 1
			obj.setCustomObject(custom)
			obj.setName(tMap.tile)

		end
		return 1
	end
	startLuaCoroutine(self, "spawnMapTiles")


	--Spawn Tiles
	function spawnTiles()
		wait(Delay_Spawning)
		local Bag_InfiniteBag = getObjectFromGUID(Bag_InfiniteBag_GUID)

		local t = {
			--Scenario 1
			[1] = {
				--Traps
				{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Spike Trap"
							,tile	= {
								{
									position	= {x=-0.437501, y=1.931061, z=6.819950}
									,rotation	= {x=-0.000249, y=180.004166, z=-0.000766}
								}
								,{
									position	= {x=-0.437501, y=1.931067, z=5.304405}
									,rotation	= {x=-0.000251, y=180.004272, z=-0.000765}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Table"
							,tile	= {
								{
									position	= {x=-4.375215, y=1.901806, z=7.578357}
									,rotation	= {x=359.205902, y=0.006967, z=180.000580}
								}
								,{
									position	= {x=-4.373833, y=1.838818, z=3.033045}
									,rotation	= {x=359.205902, y=359.933441, z=180.001343}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=-1.749237, y=1.880841, z=6.063232}
									,rotation	= {x=0.793896, y=179.927002, z=180.010391}
								}
							}
						}
					}
				}
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Vertical"
							,tile	= {
								{
									position	= {x=0.875000, y=1.817813, z=0.000000}
									,rotation	= {x=-0.000242, y=180.000381, z=179.999222}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=-8.312699, y=1.941525, z=2.270859}
									,rotation	= {x=0.794108, y=179.994080, z=-0.000571}
									,params	 = {
										buttonTheme  = "Treasure"
										,buttonLabel = "7"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=-8.324668, y=1.990724, z=9.847832}
									,rotation	= {x=0.793931, y=179.766800, z=-0.003822}
								}
								,{
									position	= {x=-7.000021, y=1.980280, z=9.093269}
									,rotation	= {x=0.793940, y=179.997910, z=-0.000609}
								}
								,{
									position	= {x=-5.687591, y=1.990784, z=9.850259}
									,rotation	= {x=0.793940, y=180.008316, z=-0.000466}
								}
								,{
									position	= {x=-7.000081, y=1.896261, z=3.030319}
									,rotation	= {x=0.793939, y=179.973145, z=-0.000955}
								}
								,{
									position	= {x=-5.687580, y=1.885774, z=2.272546}
									,rotation	= {x=0.793954, y=180.002731, z=-0.000555}
								}
							}
						}
					}
				}
			}
			--Scenario 2
			,[2] = {
				--Traps
				{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Bear Trap"
							,tile	= {
								{
									position	= {x=1.517138, y=1.933786, z=11.378545}
									,rotation	= {x=-0.003584, y=90.000290, z=0.001113}
								}
								,{
									position	= {x=4.541172, y=1.933901, z=11.363235}
									,rotation	= {x=-0.001731, y=89.999992, z=0.000165}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Sarcophagus A"
							,tile	= {
								{
									position	= {x=1.514858, y=1.934336, z=6.123295}
									,rotation	= {x=0.000257, y=210.007645, z=-0.000027}
								}
								,{
									position	= {x=4.546328, y=1.934128, z=6.125289}
									,rotation	= {x=0.000438, y=149.993622, z=0.003497}
								}
								,{
									position	= {x=2.281958, y=1.934367, z=2.186150}
									,rotation	= {x=0.000352, y=90.036034, z=-0.001777}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=3.028531, y=1.818087, z=8.752478}
									,rotation	= {x=-0.000863, y=270.045990, z=179.971451}
								}
								,{
									position	= {x=-0.757200, y=1.818190, z=-0.442370}
									,rotation	= {x=0.001134, y=329.983582, z=180.009293}
								}
								,{
									position	= {x=6.821640, y=1.818301, z=-0.442846}
									,rotation	= {x=0.001205, y=29.983543, z=179.988724}
								}
							}
						}
						,{
							name	= "Stone Door Vertical"
							,tile	= {
								{
									position	= {x=-1.515446, y=1.818184, z=3.494373}
									,rotation	= {x=0.013247, y=269.973083, z=179.996933}
								}
								,{
									position	= {x=7.577676, y=1.818249, z=3.498284}
									,rotation	= {x=359.992554, y=269.951477, z=179.999649}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=6.819931, y=1.928054, z=-5.687508}
									,rotation	= {x=0.062806, y=89.999947, z=0.025069}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "67"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 3
			,[3] = {
				--Corridors
				{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Earth Corridor 1"
							,tile	= {
								{
									position	= {x=0.000005, y=1.814376, z=1.515555}
									,rotation	= {x=359.830353, y=-0.003161, z=180.052917}
								}
								,{
									position	= {x=2.624777, y=1.818403, z=1.515942}
									,rotation	= {x=0.300753, y=-0.002123, z=180.110870}
								}
								,{
									position	= {x=5.250003, y=1.823338, z=1.515538}
									,rotation	= {x=0.663734, y=-0.001451, z=180.110901}
								}
							}
						}
						,{
							name	= "Earth Corridor 2"
							,tile	= {
								{
									position	= {x=-1.311192, y=1.926800, z=0.758443}
									,rotation	= {x=359.792480, y=-0.004770, z=0.004516}
								}
								,{
									position	= {x=1.312264, y=1.932720, z=0.757591}
									,rotation	= {x=0.057242, y=-0.001921, z=0.110855}
								}
								,{
									position	= {x=3.937199, y=1.940340, z=0.758726}
									,rotation	= {x=0.255512, y=359.990601, z=0.110876}
								}
								,{
									position	= {x=6.563825, y=1.939687, z=0.758593}
									,rotation	= {x=0.080010, y=359.978302, z=0.088679}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Spike Trap"
							,tile	= {
								{
									position	= {x=1.312496, y=1.928017, z=9.851023}
									,rotation	= {x=-0.000248, y=179.999756, z=-0.000766}
								}
								,{
									position	= {x=2.624999, y=1.928031, z=10.608809}
									,rotation	= {x=-0.000254, y=179.999756, z=-0.000770}
								}
								,{
									position	= {x=3.937500, y=1.928052, z=9.851039}
									,rotation	= {x=-0.000251, y=179.999725, z=-0.000769}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Barrel"
							,tile	= {
								{
									position	= {x=-6.562500, y=1.933911, z=0.757772}
									,rotation	= {x=0.000253, y=0.011450, z=0.000770}
								}
								,{
									position	= {x=10.500000, y=1.934156, z=-3.031089}
									,rotation	= {x=0.000249, y=0.011460, z=0.000767}
								}
							}
						}
						,{
							name	= "Crate B"
							,tile	= {
								{
									position	= {x=-6.562500, y=1.930992, z=3.788861}
									,rotation	= {x=0.000250, y=0.012984, z=0.000766}
								}
								,{
									position	= {x=10.500000, y=1.931204, z=7.577722}
									,rotation	= {x=0.000245, y=0.012973, z=0.000767}
								}
							}
						}
						,{
							name	= "Totem"
							,tile	= {
								{
									position	= {x=1.312451, y=2.044501, z=2.273344}
									,rotation	= {x=359.942780, y=180.018448, z=359.889130}
								}
								,{
									position	= {x=2.624946, y=2.047903, z=1.515709}
									,rotation	= {x=359.699219, y=180.009521, z=359.889038}
								}
								,{
									position	= {x=3.937668, y=2.046882, z=2.273589}
									,rotation	= {x=359.744537, y=180.032074, z=359.888916}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Dark Fog"
							,tile	= {
								{
									position	= {x=2.624996, y=1.934533, z=9.093749}
									,rotation	= {x=359.771240, y=180.000549, z=-0.000853}
								}
							}
						}
						,{
							name	= "Wooden Door Horizontal"
							,tile	= {
								{
									position	= {x=-2.625000, y=1.817740, z=6.062178}
									,rotation	= {x=-0.000242, y=180.000000, z=179.999237}
								}
								,{
									position	= {x=7.875001, y=1.817880, z=6.062178}
									,rotation	= {x=0.000264, y=-0.000007, z=180.000809}
								}
								,{
									position	= {x=-2.625000, y=1.817773, z=-1.515544}
									,rotation	= {x=-0.000272, y=180.000031, z=179.999313}
								}
								,{
									position	= {x=7.875000, y=1.817914, z=-1.515545}
									,rotation	= {x=0.000245, y=0.000006, z=180.000778}
								}
							}
						}
					}
				}
				--Hazardous Terrain
				,{
					bag	 	= Bag_HazardousTerrain_GUID
					,type	= {
						{
							name	= "Thorns"
							,tile	= {
								{
									position	= {x=1.312500, y=1.931090, z=5.304405}
									,rotation	= {x=0.000251, y=0.000106, z=0.000764}
								}
								,{
									position	= {x=-1.312500, y=1.931095, z=-3.788861}
									,rotation	= {x=0.000251, y=0.000109, z=0.000771}
								}
								,{
									position	= {x=6.562517, y=2.047164, z=0.757764}
									,rotation	= {x=-0.000934, y=0.000037, z=-0.002068}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=1.312501, y=1.927989, z=15.913217}
									,rotation	= {x=-0.000251, y=180.000671, z=-0.000768}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "65"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=0.000000, y=1.872180, z=15.155444}
									,rotation	= {x=-0.000255, y=179.999496, z=-0.000761}
								}
								,{
									position	= {x=5.250023, y=1.872250, z=15.155465}
									,rotation	= {x=-0.000267, y=179.998947, z=-0.000761}
								}
								,{
									position	= {x=5.250000, y=1.872257, z=13.639908}
									,rotation	= {x=-0.000313, y=179.999908, z=-0.000677}
								}
								,{
									position	= {x=-7.875000, y=1.875163, z=7.577722}
									,rotation	= {x=-0.000245, y=179.999420, z=-0.000764}
								}
								,{
									position	= {x=-6.562500, y=1.875177, z=8.335494}
									,rotation	= {x=-0.000244, y=179.999420, z=-0.000761}
								}
								,{
									position	= {x=11.812500, y=1.875424, z=8.335494}
									,rotation	= {x=-0.000249, y=179.999420, z=-0.000759}
								}
								,{
									position	= {x=13.125000, y=1.875444, z=7.577722}
									,rotation	= {x=-0.000247, y=179.999420, z=-0.000768}
								}
								,{
									position	= {x=-7.874998, y=1.875210, z=-3.031085}
									,rotation	= {x=-0.000250, y=179.999390, z=-0.000765}
								}
								,{
									position	= {x=13.125000, y=1.875491, z=-3.031089}
									,rotation	= {x=-0.000259, y=179.999405, z=-0.000773}
								}
							}
						}
					}
				}
			}
			--Scenario 4
			,[4] = {
				--Traps
				{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Spike Trap"
							,tile	= {
								{
									position	= {x=6.562499, y=1.931749, z=8.335479}
									,rotation	= {x=-0.000254, y=179.999771, z=-0.000763}
								}
								,{
									position	= {x=11.812501, y=1.931819, z=8.335494}
									,rotation	= {x=-0.000259, y=179.999771, z=-0.000766}
								}
								,{
									position	= {x=-2.625000, y=1.927985, z=4.546633}
									,rotation	= {x=-0.000250, y=179.999771, z=-0.000772}
								}
								,{
									position	= {x=-6.562500, y=1.927949, z=0.757774}
									,rotation	= {x=-0.000255, y=179.999771, z=-0.000768}
								}
								,{
									position	= {x=5.249995, y=1.931166, z=0.000002}
									,rotation	= {x=-0.000247, y=179.999756, z=-0.000769}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Stone Pillar"
							,tile	= {
								{
									position	= {x=6.562499, y=1.931742, z=9.851039}
									,rotation	= {x=0.000253, y=0.024124, z=0.000764}
								}
								,{
									position	= {x=10.500000, y=1.931792, z=10.608810}
									,rotation	= {x=0.000253, y=0.024122, z=0.000764}
								}
								,{
									position	= {x=9.187500, y=1.931791, z=6.819950}
									,rotation	= {x=0.000250, y=0.024122, z=0.000763}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=3.937504, y=1.818327, z=8.335492}
									,rotation	= {x=0.004461, y=179.987946, z=179.971954}
								}
								,{
									position	= {x=-1.312476, y=1.817743, z=0.757784}
									,rotation	= {x=-0.000288, y=179.987579, z=179.799591}
								}
								,{
									position	= {x=3.937500, y=1.817858, z=-0.757772}
									,rotation	= {x=-0.000240, y=179.987610, z=179.999298}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=9.187500, y=1.931771, z=11.366584}
									,rotation	= {x=-0.000257, y=180.000656, z=-0.000763}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "38"
									}
								}
								,{
									position	= {x=7.875001, y=1.931214, z=-3.031090}
									,rotation	= {x=-0.000248, y=180.000656, z=-0.000767}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "46"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=10.500000, y=1.875990, z=12.124358}
									,rotation	= {x=-0.000248, y=179.999557, z=-0.000766}
								}
								,{
									position	= {x=11.812499, y=1.876011, z=11.366586}
									,rotation	= {x=-0.000256, y=179.999329, z=-0.000759}
								}
								,{
									position	= {x=13.125004, y=1.876032, z=10.608810}
									,rotation	= {x=-0.000251, y=179.999252, z=-0.000766}
								}
							}
						}
					}
				}
			}
			--Scenario 5
			,[5] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Rubble"
							,tile	= {
								{
									position	= {x=-2.273316, y=1.934240, z=15.312501}
									,rotation	= {x=-0.000159, y=29.181112, z=0.000792}
								}
								,{
									position	= {x=0.757772, y=1.934280, z=15.312500}
									,rotation	= {x=-0.000161, y=29.181013, z=0.000788}
								}
								,{
									position	= {x=3.031089, y=1.934316, z=14.000000}
									,rotation	= {x=-0.000163, y=29.180973, z=0.000793}
								}
								,{
									position	= {x=-0.000018, y=1.934345, z=-1.750015}
									,rotation	= {x=-0.000162, y=30.000080, z=0.000794}
								}
								,{
									position	= {x=1.515543, y=1.934365, z=-1.750000}
									,rotation	= {x=-0.000160, y=30.000008, z=0.000797}
								}
								,{
									position	= {x=-1.515544, y=1.934336, z=-4.375000}
									,rotation	= {x=-0.000150, y=29.181026, z=0.000796}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Spike Trap"
							,tile	= {
								{
									position	= {x=0.757873, y=1.931663, z=10.062697}
									,rotation	= {x=0.000167, y=209.999329, z=-0.000787}
								}
								,{
									position	= {x=2.273316, y=1.931683, z=10.062509}
									,rotation	= {x=0.000164, y=209.999329, z=-0.000788}
								}
								,{
									position	= {x=0.757788, y=1.931697, z=2.187521}
									,rotation	= {x=0.000163, y=210.000946, z=-0.000792}
								}
								,{
									position	= {x=2.273320, y=1.931718, z=2.187498}
									,rotation	= {x=0.000164, y=209.999680, z=-0.000789}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Altar Horizontal"
							,tile	= {
								{
									position	= {x=3.031089, y=1.931711, z=6.124998}
									,rotation	= {x=-0.000767, y=89.999992, z=0.000249}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=1.515549, y=1.820940, z=11.375041}
									,rotation	= {x=-0.000778, y=90.004066, z=179.830383}
								}
								,{
									position	= {x=1.513997, y=1.821063, z=0.828147}
									,rotation	= {x=0.000692, y=270.000000, z=179.988968}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=-3.788861, y=1.934208, z=17.937500}
									,rotation	= {x=-0.000770, y=89.999985, z=0.000243}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "28"
									}
								}
								,{
									position	= {x=-3.788861, y=1.934312, z=-5.687501}
									,rotation	= {x=-0.000766, y=89.999992, z=0.000257}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "4"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=4.546633, y=1.878519, z=19.250000}
									,rotation	= {x=-0.000240, y=179.999420, z=-0.000767}
								}
								,{
									position	= {x=6.053118, y=1.878540, z=19.256725}
									,rotation	= {x=-0.000248, y=179.999435, z=-0.000773}
								}
								,{
									position	= {x=6.819948, y=1.878556, z=17.937500}
									,rotation	= {x=-0.000248, y=179.999451, z=-0.000759}
								}
								,{
									position	= {x=6.819951, y=1.878659, z=-5.687500}
									,rotation	= {x=-0.000255, y=179.999405, z=-0.000765}
								}
								,{
									position	= {x=4.546641, y=1.878634, z=-7.000000}
									,rotation	= {x=-0.000259, y=179.999542, z=-0.000766}
								}
								,{
									position	= {x=6.062178, y=1.878655, z=-7.000000}
									,rotation	= {x=-0.000255, y=179.999435, z=-0.000760}
								}
							}
						}
					}
				}
			}
			--Scenario 6
			,[6] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Rubble"
							,tile	= {
								{
									position	= {x=-4.546637, y=1.934219, z=13.125000}
									,rotation	= {x=-0.000166, y=30.002401, z=0.000791}
								}
								,{
									position	= {x=-3.788861, y=1.931028, z=3.937499}
									,rotation	= {x=-0.000173, y=30.002621, z=0.000792}
								}
								,{
									position	= {x=-4.546633, y=1.931023, z=2.624996}
									,rotation	= {x=-0.000173, y=30.002529, z=0.000790}
								}
								,{
									position	= {x=1.504502, y=1.934379, z=-5.260636}
									,rotation	= {x=-0.000172, y=30.002583, z=0.000788}
								}
								,{
									position	= {x=3.788861, y=1.931741, z=1.312500}
									,rotation	= {x=-0.000165, y=30.002522, z=0.000787}
								}
								,{
									position	= {x=6.062178, y=1.931743, z=7.875005}
									,rotation	= {x=-0.000159, y=30.002630, z=0.000789}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Poison Gas"
							,tile	= {
								{
									position	= {x=1.515543, y=1.934277, z=18.375000}
									,rotation	= {x=0.000161, y=209.988464, z=-0.000790}
								}
								,{
									position	= {x=0.757772, y=1.934272, z=17.062500}
									,rotation	= {x=0.000162, y=209.988464, z=-0.000794}
								}
								,{
									position	= {x=0.757772, y=1.934375, z=-6.562500}
									,rotation	= {x=0.000167, y=209.988464, z=-0.000788}
								}
								,{
									position	= {x=1.515545, y=1.934391, z=-7.875004}
									,rotation	= {x=0.000171, y=209.988556, z=-0.000789}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Stone Pillar"
							,tile	= {
								{
									position	= {x=5.304397, y=1.931739, z=6.562500}
									,rotation	= {x=-0.000766, y=90.012451, z=0.000250}
								}
								,{
									position	= {x=5.304405, y=1.931750, z=3.937500}
									,rotation	= {x=-0.000762, y=90.012451, z=0.000250}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=-3.031086, y=1.820621, z=10.499972}
									,rotation	= {x=0.000857, y=269.985718, z=180.191956}
								}
								,{
									position	= {x=4.546633, y=1.820788, z=10.500001}
									,rotation	= {x=-0.000769, y=90.000084, z=179.843369}
								}
								,{
									position	= {x=-3.031091, y=1.820672, z=0.000004}
									,rotation	= {x=-0.000711, y=90.000061, z=180.192856}
								}
								,{
									position	= {x=4.546634, y=1.820829, z=0.000002}
									,rotation	= {x=0.000705, y=269.985901, z=179.843185}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=6.062176, y=1.931755, z=5.250000}
									,rotation	= {x=-0.000768, y=90.000046, z=0.000252}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "50"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=6.819951, y=1.875952, z=9.187502}
									,rotation	= {x=-0.000247, y=179.999527, z=-0.000759}
								}
								,{
									position	= {x=7.577726, y=1.875969, z=7.875004}
									,rotation	= {x=-0.000251, y=179.999115, z=-0.000771}
								}
								,{
									position	= {x=8.335498, y=1.875984, z=6.562501}
									,rotation	= {x=-0.000236, y=179.999405, z=-0.000773}
								}
								,{
									position	= {x=8.335496, y=1.875996, z=3.937500}
									,rotation	= {x=-0.000257, y=179.999344, z=-0.000754}
								}
								,{
									position	= {x=7.577731, y=1.875991, z=2.624999}
									,rotation	= {x=-0.000246, y=179.999084, z=-0.000749}
								}
								,{
									position	= {x=6.819951, y=1.875987, z=1.312492}
									,rotation	= {x=-0.000252, y=179.999176, z=-0.000765}
								}
							}
						}
					}
				}
			}
			--Scenario 7
			,[7] = {
				--Traps
				{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Poison Gas"
							,tile	= {
								{
									position	= {x=7.577722, y=1.930725, z=17.500000}
									,rotation	= {x=0.000170, y=209.986008, z=-0.000790}
								}
								,{
									position	= {x=9.093266, y=1.930746, z=17.500000}
									,rotation	= {x=0.000172, y=209.986008, z=-0.000787}
								}
								,{
									position	= {x=8.335494, y=1.931795, z=3.062500}
									,rotation	= {x=0.000166, y=209.986008, z=-0.000788}
								}
								,{
									position	= {x=10.608810, y=1.931831, z=1.750000}
									,rotation	= {x=0.000168, y=209.986008, z=-0.000789}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Bush 1"
							,tile	= {
								{
									position	= {x=9.851038, y=1.930784, z=10.937500}
									,rotation	= {x=-0.000772, y=90.005630, z=0.000247}
								}
								,{
									position	= {x=9.093266, y=1.930780, z=9.625001}
									,rotation	= {x=-0.000766, y=90.005630, z=0.000249}
								}
								,{
									position	= {x=-6.819950, y=1.930994, z=3.062500}
									,rotation	= {x=-0.000783, y=90.005630, z=0.000273}
								}
								,{
									position	= {x=0.000000, y=1.931701, z=-0.875000}
									,rotation	= {x=-0.000778, y=90.005630, z=0.000214}
								}
								,{
									position	= {x=3.788861, y=1.931758, z=-2.187500}
									,rotation	= {x=-0.000783, y=90.005630, z=0.000211}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Dark Fog"
							,tile	= {
								{
									position	= {x=-0.000043, y=1.934548, z=12.249998}
									,rotation	= {x=0.000770, y=269.991577, z=-0.000269}
								}
								,{
									position	= {x=-4.546677, y=1.934511, z=7.000000}
									,rotation	= {x=0.000801, y=269.991577, z=-0.000340}
								}
								,{
									position	= {x=6.062209, y=1.934543, z=9.625010}
									,rotation	= {x=359.986481, y=269.991638, z=-0.005358}
								}
							}
						}
						,{
							name	= "LIght Fog"
							,tile	= {
								{
									position	= {x=-3.031115, y=1.935094, z=1.750022}
									,rotation	= {x=0.004985, y=30.000231, z=0.020644}
								}
								,{
									position	= {x=6.819980, y=1.935293, z=0.437472}
									,rotation	= {x=-0.000504, y=150.000046, z=-0.000303}
								}
								,{
									position	= {x=9.064186, y=1.935168, z=7.036713}
									,rotation	= {x=0.008007, y=270.000061, z=359.954590}
								}
							}
						}
					}
				}
				--Hazardous Terrain
				,{
					bag	 	= Bag_HazardousTerrain_GUID
					,type	= {
						{
							name	= "Thorns"
							,tile	= {
								{
									position	= {x=6.819949, y=1.930732, z=13.562497}
									,rotation	= {x=-0.000170, y=30.015732, z=0.000789}
								}
								,{
									position	= {x=-4.546633, y=1.931019, z=4.375000}
									,rotation	= {x=-0.000147, y=30.015707, z=0.000815}
								}
								,{
									position	= {x=-2.273316, y=1.931675, z=-2.187500}
									,rotation	= {x=-0.000202, y=30.015759, z=0.000784}
								}
								,{
									position	= {x=3.788862, y=1.931748, z=0.437500}
									,rotation	= {x=-0.000207, y=30.015715, z=0.000780}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=1.515544, y=1.931040, z=17.500000}
									,rotation	= {x=-0.000767, y=89.999969, z=0.000251}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=9.851038, y=1.930750, z=18.812500}
									,rotation	= {x=-0.000769, y=89.999985, z=0.000250}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=-7.577722, y=1.930977, z=4.375000}
									,rotation	= {x=-0.000786, y=89.999985, z=0.000285}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=-3.031089, y=1.931660, z=-0.875000}
									,rotation	= {x=-0.000779, y=89.999969, z=0.000215}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=9.851056, y=1.931804, z=5.687500}
									,rotation	= {x=-0.000766, y=89.999352, z=0.000249}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 8
			,[8] = {
				--Traps
				{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Bear Trap"
							,tile	= {
								{
									position	= {x=3.031089, y=1.934012, z=7.000000}
									,rotation	= {x=-0.000764, y=90.008514, z=0.000248}
								}
								,{
									position	= {x=4.546633, y=1.934055, z=1.749999}
									,rotation	= {x=-0.000765, y=90.008591, z=0.000252}
								}
								,{
									position	= {x=2.273315, y=1.934042, z=-2.187500}
									,rotation	= {x=-0.000767, y=90.008514, z=0.000247}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Bookcase"
							,tile	= {
								{
									position	= {x=0.757770, y=1.933787, z=5.687506}
									,rotation	= {x=0.000765, y=270.007874, z=-0.000248}
								}
								,{
									position	= {x=3.788862, y=1.933828, z=5.687500}
									,rotation	= {x=0.000765, y=270.007874, z=-0.000249}
								}
								,{
									position	= {x=2.273317, y=1.933819, z=3.062501}
									,rotation	= {x=0.000766, y=270.008026, z=-0.000251}
								}
								,{
									position	= {x=5.304409, y=1.933859, z=3.062493}
									,rotation	= {x=0.000763, y=270.007904, z=-0.000244}
								}
							}
						}
						,{
							name	= "Cabinet"
							,tile	= {
								{
									position	= {x=-1.515546, y=1.933997, z=-3.500001}
									,rotation	= {x=-0.000769, y=89.865356, z=0.000250}
								}
								,{
									position	= {x=6.062178, y=1.934098, z=-3.500000}
									,rotation	= {x=-0.000767, y=89.865356, z=0.000246}
								}
							}
						}
						,{
							name	= "Shelf"
							,tile	= {
								{
									position	= {x=-0.000002, y=1.933806, z=-0.874455}
									,rotation	= {x=0.000765, y=269.962738, z=-0.000247}
								}
								,{
									position	= {x=6.062179, y=1.933887, z=-0.875000}
									,rotation	= {x=0.000765, y=269.969727, z=-0.000245}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Wooden Door Horizontal"
							,tile	= {
								{
									position	= {x=2.273317, y=1.817796, z=8.312500}
									,rotation	= {x=0.000770, y=270.018311, z=179.999741}
								}
								,{
									position	= {x=2.273317, y=1.817830, z=0.437500}
									,rotation	= {x=0.000772, y=270.018311, z=179.999741}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=6.062178, y=1.931170, z=1.750001}
									,rotation	= {x=-0.000767, y=90.000015, z=0.000248}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "51"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=-3.031092, y=1.875208, z=12.250005}
									,rotation	= {x=-0.000279, y=179.999222, z=-0.000772}
								}
								,{
									position	= {x=-2.273317, y=1.875224, z=10.937500}
									,rotation	= {x=-0.000250, y=179.999481, z=-0.000767}
								}
								,{
									position	= {x=-3.031089, y=1.875219, z=9.625000}
									,rotation	= {x=-0.000256, y=179.999374, z=-0.000767}
								}
								,{
									position	= {x=7.577724, y=1.875350, z=12.249999}
									,rotation	= {x=-0.000248, y=179.999435, z=-0.000772}
								}
								,{
									position	= {x=6.819957, y=1.875346, z=10.937497}
									,rotation	= {x=-0.000257, y=179.999039, z=-0.000768}
								}
								,{
									position	= {x=7.577744, y=1.875361, z=9.624981}
									,rotation	= {x=-0.000244, y=179.999008, z=-0.000755}
								}
							}
						}
					}
				}
			}
			--Scenario 9
			,[9] = {
				--Traps
				{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Bear Trap"
							,tile	= {
								{
									position	= {x=-0.757773, y=1.933955, z=8.312500}
									,rotation	= {x=-0.000763, y=90.094772, z=0.000247}
								}
								,{
									position	= {x=6.062179, y=1.934041, z=9.625001}
									,rotation	= {x=-0.000763, y=90.094788, z=0.000248}
								}
								,{
									position	= {x=5.295932, y=1.934048, z=5.673152}
									,rotation	= {x=-0.000767, y=90.094780, z=0.000250}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Boulder"
							,tile	= {
								{
									position	= {x=-3.788867, y=1.930998, z=10.937508}
									,rotation	= {x=-0.000597, y=150.016113, z=-0.000542}
								}
								,{
									position	= {x=-1.515545, y=1.931034, z=9.625000}
									,rotation	= {x=-0.000600, y=150.016159, z=-0.000538}
								}
								,{
									position	= {x=-1.515545, y=1.931046, z=7.000000}
									,rotation	= {x=-0.000596, y=150.016159, z=-0.000540}
								}
								,{
									position	= {x=4.546636, y=1.931115, z=9.625000}
									,rotation	= {x=-0.000597, y=150.016235, z=-0.000539}
								}
								,{
									position	= {x=4.546721, y=1.931138, z=4.374455}
									,rotation	= {x=-0.000601, y=149.998703, z=-0.000540}
								}
							}
						}
						,{
							name	= "Boulder 2"
							,tile	= {
								{
									position	= {x=-3.788398, y=1.933715, z=8.312229}
									,rotation	= {x=0.000165, y=210.031067, z=-0.000779}
								}
								,{
									position	= {x=0.757771, y=1.933764, z=10.937500}
									,rotation	= {x=0.000167, y=210.031052, z=-0.000784}
								}
								,{
									position	= {x=3.031089, y=1.933789, z=12.250001}
									,rotation	= {x=0.000169, y=210.031082, z=-0.000790}
								}
								,{
									position	= {x=3.788862, y=1.933816, z=8.312500}
									,rotation	= {x=0.000169, y=210.031052, z=-0.000790}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Dark Fog"
							,tile	= {
								{
									position	= {x=0.737215, y=1.934598, z=3.109837}
									,rotation	= {x=0.000762, y=269.998444, z=-0.000237}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=4.546634, y=1.931104, z=12.250001}
									,rotation	= {x=-0.000768, y=89.999969, z=0.000248}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=-3.031087, y=1.875208, z=12.250010}
									,rotation	= {x=-0.000259, y=179.998886, z=-0.000767}
								}
								,{
									position	= {x=-1.515558, y=1.875228, z=12.250028}
									,rotation	= {x=-0.000271, y=179.998642, z=-0.000774}
								}
								,{
									position	= {x=1.515546, y=1.875269, z=12.250006}
									,rotation	= {x=-0.000237, y=179.999222, z=-0.000770}
								}
								,{
									position	= {x=3.788868, y=1.875305, z=10.937510}
									,rotation	= {x=-0.000263, y=179.999191, z=-0.000760}
								}
								,{
									position	= {x=5.304466, y=1.875325, z=10.937517}
									,rotation	= {x=-0.000245, y=179.999146, z=-0.000740}
								}
								,{
									position	= {x=6.062296, y=1.875330, z=12.250054}
									,rotation	= {x=-0.000267, y=179.999878, z=-0.000761}
								}
							}
						}
					}
				}
			}
			--Scenario 10
			,[10] = {
				--Corridors
				{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Earth Corridor 1"
							,tile	= {
								{
									position	= {x=-4.375006, y=1.817743, z=0.000000}
									,rotation	= {x=0.000259, y=-0.000191, z=180.000763}
								}
								,{
									position	= {x=-1.750000, y=1.817778, z=0.000000}
									,rotation	= {x=0.000263, y=-0.000162, z=180.000778}
								}
								,{
									position	= {x=0.875003, y=1.817813, z=0.000000}
									,rotation	= {x=0.000263, y=-0.000159, z=180.000778}
								}
							}
						}
						,{
							name	= "Earth Corridor 2"
							,tile	= {
								{
									position	= {x=-5.687501, y=1.933729, z=-0.757771}
									,rotation	= {x=0.000257, y=0.026066, z=0.000775}
								}
								,{
									position	= {x=-3.062500, y=1.933764, z=-0.757772}
									,rotation	= {x=0.000257, y=0.026190, z=0.000776}
								}
								,{
									position	= {x=-0.437498, y=1.933799, z=-0.757772}
									,rotation	= {x=0.000260, y=0.026210, z=0.000784}
								}
								,{
									position	= {x=2.187502, y=1.933834, z=-0.757773}
									,rotation	= {x=0.000259, y=0.026394, z=0.000769}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Spike Trap"
							,tile	= {
								{
									position	= {x=4.812499, y=1.931138, z=5.304397}
									,rotation	= {x=-0.000250, y=179.999878, z=-0.000760}
								}
								,{
									position	= {x=6.125000, y=1.931152, z=6.062186}
									,rotation	= {x=-0.000247, y=180.000168, z=-0.000763}
								}
								,{
									position	= {x=7.437500, y=1.931172, z=5.304404}
									,rotation	= {x=-0.000244, y=179.999908, z=-0.000759}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Altar Vertical"
							,tile	= {
								{
									position	= {x=-3.062498, y=1.931599, z=12.882129}
									,rotation	= {x=0.000250, y=359.947845, z=0.000763}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "LIght Fog"
							,tile	= {
								{
									position	= {x=3.500063, y=1.935112, z=13.639917}
									,rotation	= {x=0.005710, y=0.009081, z=359.974976}
								}
								,{
									position	= {x=3.499952, y=1.934628, z=4.546622}
									,rotation	= {x=0.000246, y=0.008566, z=0.000801}
								}
							}
						}
					}
				}
				--Hazardous Terrain
				,{
					bag	 	= Bag_HazardousTerrain_GUID
					,type	= {
						{
							name	= "Hot Coals 1"
							,tile	= {
								{
									position	= {x=-5.687505, y=2.049922, z=0.757774}
									,rotation	= {x=-0.000253, y=180.000214, z=-0.000866}
								}
								,{
									position	= {x=-4.375001, y=1.933936, z=1.515544}
									,rotation	= {x=-0.000250, y=180.000320, z=-0.000769}
								}
								,{
									position	= {x=-4.375000, y=2.050143, z=-0.000004}
									,rotation	= {x=-0.000259, y=180.000153, z=-0.000760}
								}
								,{
									position	= {x=-3.062499, y=2.049956, z=-0.757776}
									,rotation	= {x=0.000088, y=180.000229, z=-0.000813}
								}
								,{
									position	= {x=-3.062500, y=1.933970, z=-2.273317}
									,rotation	= {x=-0.000249, y=180.000320, z=-0.000767}
								}
								,{
									position	= {x=-1.750000, y=1.933991, z=-3.031089}
									,rotation	= {x=-0.000252, y=180.000320, z=-0.000768}
								}
								,{
									position	= {x=-1.750000, y=1.933998, z=-4.546633}
									,rotation	= {x=-0.000249, y=180.000320, z=-0.000767}
								}
								,{
									position	= {x=-0.437500, y=1.934012, z=-3.788861}
									,rotation	= {x=-0.000248, y=180.000320, z=-0.000766}
								}
								,{
									position	= {x=0.875000, y=1.934033, z=-4.546633}
									,rotation	= {x=-0.000252, y=180.000320, z=-0.000769}
								}
								,{
									position	= {x=2.187500, y=1.934047, z=-3.788860}
									,rotation	= {x=-0.000248, y=180.000351, z=-0.000765}
								}
								,{
									position	= {x=-0.437499, y=1.933985, z=2.273317}
									,rotation	= {x=-0.000248, y=180.000320, z=-0.000764}
								}
								,{
									position	= {x=-0.437500, y=2.049992, z=0.757773}
									,rotation	= {x=-0.000257, y=180.000305, z=-0.000873}
								}
								,{
									position	= {x=0.875002, y=1.934006, z=1.515544}
									,rotation	= {x=-0.000251, y=180.000320, z=-0.000764}
								}
								,{
									position	= {x=2.187503, y=1.934020, z=2.273317}
									,rotation	= {x=-0.000249, y=180.000320, z=-0.000766}
								}
								,{
									position	= {x=4.812500, y=1.934023, z=9.851039}
									,rotation	= {x=-0.000246, y=180.000320, z=-0.000758}
								}
								,{
									position	= {x=6.125000, y=1.934037, z=10.608811}
									,rotation	= {x=-0.000251, y=180.000320, z=-0.000761}
								}
								,{
									position	= {x=7.437500, y=1.934071, z=6.819950}
									,rotation	= {x=-0.000251, y=180.000320, z=-0.000759}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=-5.687500, y=1.931050, z=-6.819950}
									,rotation	= {x=-0.000253, y=180.000656, z=-0.000770}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "11"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=-5.687500, y=1.875196, z=6.819950}
									,rotation	= {x=-0.000240, y=179.999405, z=-0.000753}
								}
								,{
									position	= {x=-5.687500, y=1.875202, z=5.304405}
									,rotation	= {x=-0.000261, y=179.999451, z=-0.000790}
								}
								,{
									position	= {x=-3.062500, y=1.875231, z=6.819950}
									,rotation	= {x=-0.000241, y=179.999405, z=-0.000772}
								}
							}
						}
					}
				}
			}
			--Scenario 11
			,[11] = {
				--Corridors
				{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Man Stone Corridor 1"
							,tile	= {
								{
									position	= {x=-2.625000, y=1.817718, z=10.608812}
									,rotation	= {x=0.000616, y=-0.001450, z=180.000595}
								}
							}
						}
						,{
							name	= "Man Stone Corridor 2"
							,tile	= {
								{
									position	= {x=-6.562506, y=1.933673, z=9.851048}
									,rotation	= {x=0.000692, y=0.034272, z=0.000657}
								}
								,{
									position	= {x=-5.250024, y=1.933635, z=10.608809}
									,rotation	= {x=0.009752, y=0.098045, z=0.009802}
								}
								,{
									position	= {x=-3.937501, y=1.933708, z=9.851043}
									,rotation	= {x=0.000512, y=0.034213, z=0.000695}
								}
								,{
									position	= {x=-1.312500, y=1.933741, z=9.851039}
									,rotation	= {x=0.000487, y=0.034221, z=0.000862}
								}
								,{
									position	= {x=-0.003417, y=1.933831, z=9.093115}
									,rotation	= {x=0.002978, y=359.948181, z=0.003704}
								}
								,{
									position	= {x=1.312502, y=1.933780, z=9.851040}
									,rotation	= {x=0.000269, y=0.034177, z=0.000901}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Bear Trap"
							,tile	= {
								{
									position	= {x=1.312500, y=1.933985, z=15.913223}
									,rotation	= {x=0.000988, y=0.093160, z=0.002038}
								}
								,{
									position	= {x=1.312502, y=1.934011, z=14.397674}
									,rotation	= {x=0.000988, y=0.093007, z=0.002038}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Wall Section"
							,tile	= {
								{
									position	= {x=-3.937505, y=1.933651, z=12.882124}
									,rotation	= {x=-0.001267, y=60.005741, z=0.001872}
								}
								,{
									position	= {x=-1.314471, y=1.933744, z=12.878657}
									,rotation	= {x=-0.002259, y=119.407501, z=-0.000137}
								}
								,{
									position	= {x=-0.000298, y=2.050400, z=10.608781}
									,rotation	= {x=0.011910, y=179.986526, z=359.979401}
								}
								,{
									position	= {x=-1.311023, y=1.933789, z=8.332924}
									,rotation	= {x=0.003584, y=240.528519, z=0.001561}
								}
								,{
									position	= {x=-3.937489, y=1.933681, z=8.335506}
									,rotation	= {x=0.000475, y=300.003937, z=0.003886}
								}
								,{
									position	= {x=-5.250026, y=2.049845, z=10.608779}
									,rotation	= {x=359.992035, y=0.034199, z=0.014562}
								}
							}
						}
						,{
							name	= "Fountain"
							,tile	= {
								{
									position	= {x=-2.624261, y=2.047300, z=10.639740}
									,rotation	= {x=-0.004320, y=0.052880, z=0.012347}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=2.625020, y=1.817731, z=15.155466}
									,rotation	= {x=0.001297, y=0.003017, z=179.805527}
								}
								,{
									position	= {x=6.562501, y=1.818499, z=-2.273318}
									,rotation	= {x=-0.000236, y=180.050827, z=179.999161}
								}
							}
						}
						,{
							name	= "Stone Door Vertical"
							,tile	= {
								{
									position	= {x=-2.624999, y=1.817687, z=3.031083}
									,rotation	= {x=0.011642, y=0.009597, z=179.994873}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=7.875022, y=1.927878, z=10.608822}
									,rotation	= {x=-0.000744, y=180.000534, z=0.001143}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "5"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 12
			,[12] = {
				--Corridors
				{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Man Stone Corridor 1"
							,tile	= {
								{
									position	= {x=-2.625000, y=1.817718, z=10.608812}
									,rotation	= {x=0.000616, y=-0.001450, z=180.000595}
								}
							}
						}
						,{
							name	= "Man Stone Corridor 2"
							,tile	= {
								{
									position	= {x=-6.562506, y=1.933673, z=9.851048}
									,rotation	= {x=0.000692, y=0.034272, z=0.000657}
								}
								,{
									position	= {x=-5.250024, y=1.933635, z=10.608809}
									,rotation	= {x=0.009752, y=0.098045, z=0.009802}
								}
								,{
									position	= {x=-3.937501, y=1.933708, z=9.851043}
									,rotation	= {x=0.000512, y=0.034213, z=0.000695}
								}
								,{
									position	= {x=-1.312500, y=1.933741, z=9.851039}
									,rotation	= {x=0.000487, y=0.034221, z=0.000862}
								}
								,{
									position	= {x=-0.003417, y=1.933831, z=9.093115}
									,rotation	= {x=0.002978, y=359.948181, z=0.003704}
								}
								,{
									position	= {x=1.312502, y=1.933780, z=9.851040}
									,rotation	= {x=0.000269, y=0.034177, z=0.000901}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Bear Trap"
							,tile	= {
								{
									position	= {x=5.249995, y=1.934713, z=-1.515568}
									,rotation	= {x=0.000284, y=0.023648, z=0.000947}
								}
								,{
									position	= {x=5.250001, y=1.934721, z=-3.031096}
									,rotation	= {x=0.000278, y=0.028384, z=0.000946}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Wall Section"
							,tile	= {
								{
									position	= {x=-3.937505, y=1.933651, z=12.882124}
									,rotation	= {x=-0.001267, y=60.005741, z=0.001872}
								}
								,{
									position	= {x=-1.314471, y=1.933744, z=12.878657}
									,rotation	= {x=-0.002259, y=119.407501, z=-0.000137}
								}
								,{
									position	= {x=-0.000298, y=2.050400, z=10.608781}
									,rotation	= {x=0.011910, y=179.986526, z=359.979401}
								}
								,{
									position	= {x=-1.311023, y=1.933789, z=8.332924}
									,rotation	= {x=0.003584, y=240.528519, z=0.001561}
								}
								,{
									position	= {x=-3.937489, y=1.933681, z=8.335506}
									,rotation	= {x=0.000475, y=300.003937, z=0.003886}
								}
								,{
									position	= {x=-5.250026, y=2.049845, z=10.608779}
									,rotation	= {x=359.992035, y=0.034199, z=0.014562}
								}
							}
						}
						,{
							name	= "Fountain"
							,tile	= {
								{
									position	= {x=-2.624261, y=2.047300, z=10.639740}
									,rotation	= {x=-0.004320, y=0.052880, z=0.012347}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=2.625020, y=1.817731, z=15.155466}
									,rotation	= {x=0.001297, y=0.003017, z=179.805527}
								}
								,{
									position	= {x=6.562501, y=1.818499, z=-2.273318}
									,rotation	= {x=-0.000236, y=180.050827, z=179.999161}
								}
							}
						}
						,{
							name	= "Stone Door Vertical"
							,tile	= {
								{
									position	= {x=-2.624999, y=1.817687, z=3.031083}
									,rotation	= {x=0.011642, y=0.009597, z=179.994873}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=7.874999, y=1.931822, z=-4.546635}
									,rotation	= {x=-0.000236, y=180.000580, z=-0.000775}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "34"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 13
			,[13] = {
				--Traps
				{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Bear Trap"
							,tile	= {
								{
									position	= {x=1.312500, y=1.933969, z=11.366583}
									,rotation	= {x=0.000249, y=0.000274, z=0.000766}
								}
								,{
									position	= {x=0.000000, y=1.933975, z=6.062178}
									,rotation	= {x=0.000250, y=0.000274, z=0.000767}
								}
								,{
									position	= {x=-2.625001, y=1.933953, z=3.031073}
									,rotation	= {x=0.000249, y=0.000286, z=0.000762}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Altar Horizontal"
							,tile	= {
								{
									position	= {x=-0.000002, y=1.931043, z=12.124354}
									,rotation	= {x=0.000252, y=0.000105, z=0.000763}
								}
							}
						}
						,{
							name	= "Stone Pillar"
							,tile	= {
								{
									position	= {x=-2.625001, y=1.931015, z=10.608810}
									,rotation	= {x=0.000247, y=0.024603, z=0.000762}
								}
								,{
									position	= {x=-2.625000, y=1.931028, z=7.577722}
									,rotation	= {x=0.000246, y=0.024602, z=0.000763}
								}
								,{
									position	= {x=-2.625000, y=1.931041, z=4.546633}
									,rotation	= {x=0.000248, y=0.024606, z=0.000762}
								}
								,{
									position	= {x=2.625001, y=1.931085, z=10.608810}
									,rotation	= {x=0.000248, y=0.024605, z=0.000764}
								}
								,{
									position	= {x=2.625001, y=1.931098, z=7.577722}
									,rotation	= {x=0.000246, y=0.024605, z=0.000761}
								}
								,{
									position	= {x=2.625001, y=1.931111, z=4.546633}
									,rotation	= {x=0.000247, y=0.024605, z=0.000762}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Vertical"
							,tile	= {
								{
									position	= {x=-0.000003, y=1.818301, z=1.515531}
									,rotation	= {x=0.029437, y=0.020350, z=179.991547}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=-3.937500, y=1.930988, z=12.882128}
									,rotation	= {x=-0.000245, y=180.000671, z=-0.000762}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "10"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=1.312502, y=1.875263, z=12.882128}
									,rotation	= {x=-0.000243, y=179.999527, z=-0.000773}
								}
								,{
									position	= {x=2.625000, y=1.875284, z=12.124355}
									,rotation	= {x=-0.000249, y=179.999329, z=-0.000771}
								}
								,{
									position	= {x=3.937501, y=1.875298, z=12.882128}
									,rotation	= {x=-0.000248, y=179.999435, z=-0.000760}
								}
							}
						}
					}
				}
			}
			--Scenario 14
			,[14] = {
				--Traps
				{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Bear Trap"
							,tile	= {
								{
									position	= {x=7.000000, y=1.934022, z=16.670988}
									,rotation	= {x=0.000253, y=0.000256, z=0.000766}
								}
								,{
									position	= {x=7.000000, y=1.934049, z=10.608811}
									,rotation	= {x=0.000251, y=0.000258, z=0.000767}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Boulder 2"
							,tile	= {
								{
									position	= {x=-0.875000, y=1.936964, z=15.155446}
									,rotation	= {x=0.000546, y=240.039719, z=-0.000616}
								}
								,{
									position	= {x=-3.500003, y=1.936962, z=7.577725}
									,rotation	= {x=0.000801, y=299.979950, z=0.000176}
								}
							}
						}
						,{
							name	= "Rock Column"
							,tile	= {
								{
									position	= {x=3.062500, y=1.933966, z=17.428761}
									,rotation	= {x=0.000253, y=0.018259, z=0.000771}
								}
								,{
									position	= {x=5.687500, y=1.934008, z=15.913217}
									,rotation	= {x=0.000256, y=0.018258, z=0.000771}
								}
								,{
									position	= {x=8.312500, y=1.934043, z=15.913218}
									,rotation	= {x=0.000249, y=0.018258, z=0.000767}
								}
								,{
									position	= {x=3.062500, y=1.934000, z=9.851039}
									,rotation	= {x=0.000251, y=0.018260, z=0.000768}
								}
								,{
									position	= {x=5.687500, y=1.934028, z=11.366583}
									,rotation	= {x=0.000250, y=0.018258, z=0.000770}
								}
								,{
									position	= {x=8.312500, y=1.934063, z=11.366583}
									,rotation	= {x=0.000252, y=0.018258, z=0.000768}
								}
							}
						}
						,
						{
							name	= "Stalagmites"
							,tile	= {
								{
									position	= {x=3.062666, y=1.937273, z=2.273047}
									,rotation	= {x=0.000249, y=0.017184, z=0.000753}
								}
								,{
									position	= {x=4.375000, y=1.937313, z=-3.031089}
									,rotation	= {x=0.000248, y=0.017147, z=0.000755}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Dark Fog"
							,tile	= {
								{
									position	= {x=1.751190, y=1.937467, z=13.639901}
									,rotation	= {x=0.000331, y=0.000253, z=359.808838}
								}
								,{
									position	= {x=0.437498, y=1.937832, z=3.788862}
									,rotation	= {x=-0.000540, y=59.993446, z=0.000619}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=8.312500, y=1.931132, z=17.428762}
									,rotation	= {x=-0.000250, y=180.000763, z=-0.000766}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "26"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 15
			,[15] = {
				--Corridors
				{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Pressure Plate"
							,tile	= {
								{
									position	= {x=7.000000, y=1.934009, z=19.702078}
									,rotation	= {x=0.000253, y=-0.001084, z=0.000769}
								}
								,{
									position	= {x=14.875000, y=1.934135, z=15.155444}
									,rotation	= {x=0.000255, y=-0.001109, z=0.000767}
								}
								,{
									position	= {x=5.687500, y=1.934648, z=6.819950}
									,rotation	= {x=0.000251, y=-0.001107, z=0.000768}
								}
								,{
									position	= {x=7.000000, y=1.934121, z=-6.062178}
									,rotation	= {x=0.000252, y=-0.001077, z=0.000758}
								}
								,{
									position	= {x=14.875006, y=1.934207, z=-1.515543}
									,rotation	= {x=0.000251, y=-0.001230, z=0.000764}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Bear Trap"
							,tile	= {
								{
									position	= {x=8.312498, y=1.934023, z=20.459835}
									,rotation	= {x=0.000250, y=0.000300, z=0.000768}
								}
								,{
									position	= {x=8.312500, y=1.934030, z=18.944305}
									,rotation	= {x=0.000255, y=0.000298, z=0.000773}
								}
								,{
									position	= {x=8.312500, y=1.934136, z=-5.304405}
									,rotation	= {x=0.000250, y=0.000285, z=0.000763}
								}
								,{
									position	= {x=8.312500, y=1.934142, z=-6.819951}
									,rotation	= {x=0.000251, y=0.000289, z=0.000766}
								}
							}
						}
						,{
							name	= "Spike Trap"
							,tile	= {
								{
									position	= {x=13.562501, y=1.931209, z=15.913216}
									,rotation	= {x=-0.000253, y=179.999756, z=-0.000770}
								}
								,{
									position	= {x=14.875000, y=1.931223, z=16.670988}
									,rotation	= {x=-0.000256, y=179.999756, z=-0.000771}
								}
								,{
									position	= {x=13.562501, y=1.931287, z=-2.273316}
									,rotation	= {x=-0.000251, y=179.999741, z=-0.000764}
								}
								,{
									position	= {x=14.875001, y=1.931308, z=-3.031080}
									,rotation	= {x=-0.000254, y=180.000000, z=-0.000766}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Stone Pillar"
							,tile	= {
								{
									position	= {x=-2.187500, y=1.931030, z=8.335494}
									,rotation	= {x=0.000249, y=0.023860, z=0.000769}
								}
								,{
									position	= {x=-2.187500, y=1.931037, z=6.819950}
									,rotation	= {x=0.000247, y=0.023851, z=0.000771}
								}
								,{
									position	= {x=-2.187500, y=1.931044, z=5.304405}
									,rotation	= {x=0.000244, y=0.023858, z=0.000765}
								}
								,{
									position	= {x=10.937500, y=1.931167, z=17.428761}
									,rotation	= {x=0.000251, y=0.023856, z=0.000768}
								}
								,{
									position	= {x=10.937500, y=1.931259, z=-3.788861}
									,rotation	= {x=0.000250, y=0.023876, z=0.000766}
								}
							}
						}
						,{
							name	= "Wall Section"
							,tile	= {
								{
									position	= {x=-4.813143, y=1.933694, z=9.851039}
									,rotation	= {x=-0.000248, y=179.983383, z=-0.000770}
								}
								,{
									position	= {x=-4.812530, y=1.933720, z=3.788862}
									,rotation	= {x=0.000248, y=359.993683, z=0.000770}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=1.750014, y=1.818263, z=7.577726}
									,rotation	= {x=0.018714, y=0.005739, z=180.031906}
								}
								,{
									position	= {x=1.750005, y=1.818270, z=6.062177}
									,rotation	= {x=0.018708, y=0.005648, z=180.031906}
								}
								,{
									position	= {x=7.000001, y=1.818449, z=10.608810}
									,rotation	= {x=0.000787, y=300.000061, z=180.000137}
								}
								,{
									position	= {x=7.000000, y=1.818482, z=3.031090}
									,rotation	= {x=-0.000539, y=59.999996, z=180.000549}
								}
								,{
									position	= {x=9.624996, y=1.818422, z=7.577723}
									,rotation	= {x=0.005747, y=0.005606, z=179.974976}
								}
								,{
									position	= {x=9.625005, y=1.818429, z=6.062180}
									,rotation	= {x=0.005754, y=0.005601, z=179.974991}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=13.562500, y=1.931248, z=6.819951}
									,rotation	= {x=-0.000253, y=180.000656, z=-0.000772}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 16
			,[16] = {
				--Corridors
				{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Stone Corridor 1"
							,tile	= {
								{
									position	= {x=3.937501, y=1.818163, z=-2.273316}
									,rotation	= {x=0.002097, y=0.018063, z=180.000305}
								}
							}
						}
						,{
							name	= "Stone Corridor 2"
							,tile	= {
								{
									position	= {x=2.620205, y=1.934058, z=-3.026145}
									,rotation	= {x=359.993835, y=0.213972, z=0.001618}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Spike Trap"
							,tile	= {
								{
									position	= {x=-6.562501, y=1.934225, z=5.304389}
									,rotation	= {x=-0.000251, y=179.999771, z=-0.000781}
								}
								,{
									position	= {x=-5.250000, y=1.934240, z=6.062178}
									,rotation	= {x=-0.000251, y=179.999771, z=-0.000776}
								}
								,{
									position	= {x=-5.250000, y=1.934233, z=7.577722}
									,rotation	= {x=-0.000246, y=179.999771, z=-0.000778}
								}
								,{
									position	= {x=-3.937500, y=1.934247, z=8.335494}
									,rotation	= {x=-0.000253, y=179.999771, z=-0.000780}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Boulder"
							,tile	= {
								{
									position	= {x=1.312500, y=1.931137, z=-5.304405}
									,rotation	= {x=0.000248, y=0.000074, z=0.000762}
								}
								,{
									position	= {x=3.937500, y=2.047658, z=-2.273317}
									,rotation	= {x=0.002098, y=359.974304, z=0.000308}
								}
								,{
									position	= {x=3.937500, y=1.931086, z=14.397672}
									,rotation	= {x=0.000250, y=0.000072, z=0.000764}
								}
								,{
									position	= {x=3.937499, y=1.931100, z=11.366583}
									,rotation	= {x=0.000247, y=0.000072, z=0.000765}
								}
							}
						}
						,{
							name	= "Boulder 2"
							,tile	= {
								{
									position	= {x=7.875000, y=1.933854, z=12.124356}
									,rotation	= {x=0.000789, y=299.990784, z=0.000164}
								}
								,{
									position	= {x=6.562498, y=1.933853, z=8.335499}
									,rotation	= {x=0.000787, y=299.990784, z=0.000165}
								}
								,{
									position	= {x=7.875047, y=1.933867, z=9.093268}
									,rotation	= {x=-0.000251, y=179.992996, z=-0.000762}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Dark Fog"
							,tile	= {
								{
									position	= {x=1.312532, y=1.937476, z=11.366583}
									,rotation	= {x=-0.000338, y=359.810516, z=359.808472}
								}
								,{
									position	= {x=1.305630, y=1.937565, z=3.774789}
									,rotation	= {x=-0.000284, y=359.810516, z=359.824615}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=-6.562500, y=1.934205, z=9.851039}
									,rotation	= {x=-0.000253, y=180.000656, z=-0.000779}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "1"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 17
			,[17] = {
				--Corridors
				{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Earth Corridor 1"
							,tile	= {
								{
									position	= {x=-0.757770, y=1.817793, z=-0.437497}
									,rotation	= {x=-0.000201, y=30.004625, z=180.000778}
								}
								,{
									position	= {x=-0.757771, y=1.817804, z=-3.062499}
									,rotation	= {x=-0.000187, y=30.004595, z=180.000778}
								}
								,{
									position	= {x=-0.757772, y=1.817816, z=-5.687500}
									,rotation	= {x=-0.000176, y=30.004595, z=180.000778}
								}
							}
						}
						,{
							name	= "Earth Corridor 2"
							,tile	= {
								{
									position	= {x=0.000003, y=1.933797, z=0.875001}
									,rotation	= {x=0.000762, y=270.000000, z=-0.000225}
								}
								,{
									position	= {x=0.000002, y=1.933809, z=-1.750000}
									,rotation	= {x=0.000761, y=270.000000, z=-0.000252}
								}
								,{
									position	= {x=0.000001, y=1.933820, z=-4.375000}
									,rotation	= {x=0.000765, y=270.000000, z=-0.000247}
								}
								,{
									position	= {x=0.000000, y=1.933832, z=-7.000000}
									,rotation	= {x=0.000765, y=269.999939, z=-0.000252}
								}
								,{
									position	= {x=1.515568, y=1.933852, z=-6.999987}
									,rotation	= {x=0.000602, y=330.008698, z=0.000537}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Spike Trap"
							,tile	= {
								{
									position	= {x=-3.031118, y=1.930806, z=-4.374996}
									,rotation	= {x=0.004685, y=209.978271, z=359.987732}
								}
								,{
									position	= {x=0.000022, y=2.046815, z=-1.749990}
									,rotation	= {x=359.989746, y=209.978226, z=0.009374}
								}
								,{
									position	= {x=3.788860, y=1.930835, z=-3.062500}
									,rotation	= {x=-0.000272, y=209.978256, z=0.002543}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Bush 1"
							,tile	= {
								{
									position	= {x=-5.304447, y=1.930148, z=-0.437502}
									,rotation	= {x=359.987030, y=90.005791, z=0.002072}
								}
								,{
									position	= {x=-0.757761, y=2.047073, z=-3.062494}
									,rotation	= {x=0.008190, y=90.005753, z=0.003664}
								}
								,{
									position	= {x=3.031077, y=1.930842, z=-4.375009}
									,rotation	= {x=0.002345, y=90.005844, z=-0.001033}
								}
							}
						}
						,{
							name	= "Tree"
							,tile	= {
								{
									position	= {x=-3.788888, y=1.931270, z=-3.062505}
									,rotation	= {x=0.012973, y=269.995056, z=-0.002081}
								}
								,{
									position	= {x=0.757773, y=1.931688, z=-0.437500}
									,rotation	= {x=0.002341, y=90.008583, z=-0.001034}
								}
								,{
									position	= {x=1.515610, y=2.047171, z=-6.999998}
									,rotation	= {x=359.980133, y=269.994873, z=-0.002264}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Wooden Door Horizontal"
							,tile	= {
								{
									position	= {x=10.608809, y=1.817976, z=0.874996}
									,rotation	= {x=0.001872, y=270.018433, z=179.994125}
								}
							}
						}
						,{
							name	= "Wooden Door Vertical"
							,tile	= {
								{
									position	= {x=6.819960, y=1.817791, z=-3.062505}
									,rotation	= {x=359.979553, y=89.981842, z=179.989090}
								}
								,{
									position	= {x=11.366583, y=1.817966, z=7.437500}
									,rotation	= {x=0.000680, y=270.018311, z=180.004211}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=8.335492, y=1.931199, z=10.062501}
									,rotation	= {x=-0.000683, y=89.999870, z=0.001275}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "71"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=7.577722, y=1.875418, z=-4.375000}
									,rotation	= {x=0.000122, y=179.999435, z=-0.001589}
								}
								,{
									position	= {x=8.335494, y=1.875442, z=-3.062500}
									,rotation	= {x=0.000105, y=179.999435, z=-0.001582}
								}
								,{
									position	= {x=9.851039, y=1.875484, z=-3.062500}
									,rotation	= {x=0.000124, y=179.999435, z=-0.001584}
								}
								,{
									position	= {x=12.124355, y=1.875543, z=-4.375000}
									,rotation	= {x=0.000124, y=179.999435, z=-0.001589}
								}
								,{
									position	= {x=9.851038, y=1.875489, z=-0.437500}
									,rotation	= {x=0.000125, y=179.999405, z=-0.001573}
								}
								,{
									position	= {x=11.366583, y=1.875531, z=-0.437500}
									,rotation	= {x=0.000126, y=179.999405, z=-0.001580}
								}
								,{
									position	= {x=12.124356, y=1.875549, z=-1.750000}
									,rotation	= {x=0.000121, y=179.999390, z=-0.001566}
								}
								,{
									position	= {x=9.093267, y=1.875395, z=6.125000}
									,rotation	= {x=-0.000004, y=179.999405, z=-0.000907}
								}
								,{
									position	= {x=12.124356, y=1.875443, z=6.125000}
									,rotation	= {x=-0.000006, y=179.999405, z=-0.000908}
								}
								,{
									position	= {x=11.366584, y=1.875431, z=4.812500}
									,rotation	= {x=-0.000005, y=179.999420, z=-0.000911}
								}
								,{
									position	= {x=10.608810, y=1.875419, z=3.500000}
									,rotation	= {x=-0.000003, y=179.999420, z=-0.000907}
								}
								,{
									position	= {x=9.851040, y=1.875408, z=2.187500}
									,rotation	= {x=-0.000007, y=179.999451, z=-0.000909}
								}
								,{
									position	= {x=11.366584, y=1.875431, z=2.187500}
									,rotation	= {x=-0.000007, y=179.999405, z=-0.000902}
								}
								,{
									position	= {x=12.882129, y=1.875455, z=2.187500}
									,rotation	= {x=-0.000008, y=179.999420, z=-0.000908}
								}
							}
						}
					}
				}
			}
			--Scenario 18
			,[18] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Water 1"
							,tile	= {
								{
									position	= {x=5.250003, y=1.931727, z=9.093266}
									,rotation	= {x=0.000247, y=-0.000011, z=0.000766}
								}
								,{
									position	= {x=6.562500, y=1.931748, z=8.335494}
									,rotation	= {x=0.000253, y=-0.000011, z=0.000768}
								}
								,{
									position	= {x=7.875000, y=1.931762, z=9.093266}
									,rotation	= {x=0.000249, y=-0.000011, z=0.000768}
								}
								,{
									position	= {x=9.187553, y=1.931707, z=8.335508}
									,rotation	= {x=0.005875, y=0.000390, z=359.974152}
								}
								,{
									position	= {x=10.500000, y=1.931197, z=9.093266}
									,rotation	= {x=0.000252, y=-0.000011, z=0.000767}
								}
								,{
									position	= {x=11.812500, y=1.931218, z=8.335494}
									,rotation	= {x=0.000250, y=-0.000011, z=0.000763}
								}
								,{
									position	= {x=10.500000, y=1.931217, z=4.546633}
									,rotation	= {x=0.000244, y=-0.000011, z=0.000764}
								}
								,{
									position	= {x=10.500000, y=1.931224, z=3.031092}
									,rotation	= {x=0.000251, y=-0.000004, z=0.000767}
								}
								,{
									position	= {x=10.500000, y=1.931230, z=1.515545}
									,rotation	= {x=0.000251, y=0.000002, z=0.000765}
								}
								,{
									position	= {x=10.500000, y=1.931237, z=0.000001}
									,rotation	= {x=0.000247, y=0.000000, z=0.000761}
								}
								,{
									position	= {x=10.500000, y=1.931244, z=-1.515544}
									,rotation	= {x=0.000251, y=-0.000010, z=0.000760}
								}
								,{
									position	= {x=10.500000, y=1.931250, z=-3.031089}
									,rotation	= {x=0.000253, y=-0.000011, z=0.000763}
								}
								,{
									position	= {x=10.500000, y=1.931257, z=-4.546633}
									,rotation	= {x=0.000250, y=-0.000011, z=0.000762}
								}
								,{
									position	= {x=10.500000, y=1.931264, z=-6.062178}
									,rotation	= {x=0.000250, y=-0.000011, z=0.000767}
								}
								,{
									position	= {x=10.500000, y=1.931270, z=-7.577722}
									,rotation	= {x=0.000253, y=-0.000011, z=0.000763}
								}
								,{
									position	= {x=1.312500, y=1.931720, z=-0.757774}
									,rotation	= {x=0.000254, y=-0.000002, z=0.000798}
								}
								,{
									position	= {x=0.000000, y=1.931705, z=-1.515545}
									,rotation	= {x=0.000258, y=-0.000013, z=0.000804}
								}
								,{
									position	= {x=-0.000001, y=1.931711, z=-3.031089}
									,rotation	= {x=0.000256, y=-0.000011, z=0.000800}
								}
								,{
									position	= {x=-1.312500, y=1.931690, z=-2.273317}
									,rotation	= {x=0.000253, y=-0.000012, z=0.000798}
								}
								,{
									position	= {x=-1.312502, y=1.931696, z=-3.788862}
									,rotation	= {x=0.000253, y=0.000047, z=0.000804}
								}
								,{
									position	= {x=-2.625000, y=1.931668, z=-1.515547}
									,rotation	= {x=0.000257, y=0.000035, z=0.000803}
								}
								,{
									position	= {x=-2.624987, y=1.931674, z=-3.030609}
									,rotation	= {x=0.000256, y=359.976959, z=0.000800}
								}
								,{
									position	= {x=-2.630577, y=1.931681, z=-4.551039}
									,rotation	= {x=0.000247, y=0.280611, z=0.000801}
								}
								,{
									position	= {x=-3.937501, y=1.931660, z=-3.788861}
									,rotation	= {x=0.000257, y=-0.000009, z=0.000802}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Poison Gas"
							,tile	= {
								{
									position	= {x=-5.249958, y=1.931651, z=-6.062201}
									,rotation	= {x=-0.000257, y=179.999908, z=-0.000799}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=2.625000, y=1.818452, z=-3.031089}
									,rotation	= {x=-0.000210, y=179.956070, z=179.999390}
								}
							}
						}
						,{
							name	= "Stone Door Vertical"
							,tile	= {
								{
									position	= {x=11.812500, y=1.817950, z=2.273317}
									,rotation	= {x=-0.000251, y=179.972198, z=179.999237}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=-3.937500, y=1.931653, z=-2.273315}
									,rotation	= {x=-0.000251, y=180.000717, z=-0.000801}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "63"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 19
			,[19] = {
				--Traps
				{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Poison Gas"
							,tile	= {
								{
									position	= {x=-0.757772, y=1.931065, z=4.812500}
									,rotation	= {x=0.000167, y=210.009491, z=-0.000789}
								}
								,{
									position	= {x=0.757773, y=1.931086, z=4.812500}
									,rotation	= {x=0.000166, y=210.009460, z=-0.000792}
								}
								,{
									position	= {x=2.273316, y=1.931106, z=4.812500}
									,rotation	= {x=0.000167, y=210.009445, z=-0.000788}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Altar Vertical"
							,tile	= {
								{
									position	= {x=1.515572, y=1.931067, z=11.375051}
									,rotation	= {x=-0.000766, y=90.042496, z=0.000253}
								}
							}
						}
						,{
							name	= "Boulder 3"
							,tile	= {
								{
									position	= {x=2.273581, y=1.935346, z=-3.062069}
									,rotation	= {x=0.000677, y=269.978943, z=-0.000169}
								}
							}
						}
						,{
							name	= "Stone Pillar"
							,tile	= {
								{
									position	= {x=6.062179, y=1.931785, z=-1.750001}
									,rotation	= {x=-0.000765, y=90.008514, z=0.000257}
								}
								,{
									position	= {x=6.819950, y=1.931801, z=-3.062501}
									,rotation	= {x=-0.000768, y=90.008537, z=0.000258}
								}
								,{
									position	= {x=9.851039, y=1.931818, z=2.187500}
									,rotation	= {x=-0.000770, y=90.008537, z=0.000255}
								}
								,{
									position	= {x=10.608811, y=1.931834, z=0.874999}
									,rotation	= {x=-0.000767, y=90.008537, z=0.000257}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=1.515544, y=1.817795, z=6.125001}
									,rotation	= {x=0.000754, y=270.005341, z=179.999771}
								}
								,{
									position	= {x=-1.536404, y=1.817779, z=0.879152}
									,rotation	= {x=0.000683, y=330.007477, z=180.000381}
								}
								,{
									position	= {x=-1.515524, y=1.818296, z=-1.749999}
									,rotation	= {x=0.005664, y=210.000473, z=179.965973}
								}
								,{
									position	= {x=4.546633, y=1.818470, z=-1.750000}
									,rotation	= {x=-0.000585, y=149.984329, z=179.999405}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=2.273314, y=1.931072, z=12.687500}
									,rotation	= {x=-0.000770, y=90.000053, z=0.000249}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "17"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=-2.273317, y=1.875216, z=12.687500}
									,rotation	= {x=-0.000244, y=179.999420, z=-0.000780}
								}
								,{
									position	= {x=-0.757772, y=1.875236, z=12.687500}
									,rotation	= {x=-0.000252, y=179.999405, z=-0.000778}
								}
								,{
									position	= {x=3.788862, y=1.875297, z=12.687504}
									,rotation	= {x=-0.000255, y=179.999405, z=-0.000765}
								}
								,{
									position	= {x=5.304405, y=1.875317, z=12.687500}
									,rotation	= {x=-0.000247, y=179.984634, z=-0.000772}
								}
								,{
									position	= {x=-2.273316, y=1.875239, z=7.437500}
									,rotation	= {x=-0.000245, y=179.999435, z=-0.000774}
								}
								,{
									position	= {x=-0.757772, y=1.875259, z=7.437500}
									,rotation	= {x=-0.000252, y=179.999420, z=-0.000776}
								}
								,{
									position	= {x=3.788861, y=1.875320, z=7.437500}
									,rotation	= {x=-0.000246, y=179.999420, z=-0.000765}
								}
								,{
									position	= {x=5.304406, y=1.875341, z=7.437500}
									,rotation	= {x=-0.000258, y=179.999466, z=-0.000770}
								}
							}
						}
					}
				}
			}
			--Scenario 20
			,[20] = {
				--Traps
				{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Bear Trap"
							,tile	= {
								{
									position	= {x=5.304405, y=1.934606, z=15.312500}
									,rotation	= {x=-0.000766, y=89.771599, z=0.000257}
								}
								,{
									position	= {x=8.335494, y=1.934646, z=15.312500}
									,rotation	= {x=-0.000769, y=89.771599, z=0.000251}
								}
								,{
									position	= {x=9.093266, y=1.937349, z=3.500000}
									,rotation	= {x=-0.000765, y=89.999046, z=0.000260}
								}
								,{
									position	= {x=10.608810, y=1.937369, z=3.500000}
									,rotation	= {x=-0.000765, y=90.003502, z=0.000262}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Sarcophagus A"
							,tile	= {
								{
									position	= {x=1.515542, y=1.934430, z=-1.749024}
									,rotation	= {x=-0.000769, y=89.961205, z=0.000247}
								}
								,{
									position	= {x=3.031089, y=1.937044, z=8.750001}
									,rotation	= {x=-0.000157, y=29.981024, z=0.000791}
								}
								,{
									position	= {x=9.851037, y=1.937141, z=7.437499}
									,rotation	= {x=-0.000605, y=150.005402, z=-0.000522}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=6.062178, y=1.821000, z=11.375001}
									,rotation	= {x=0.000794, y=269.999847, z=179.830139}
								}
								,{
									position	= {x=2.273313, y=1.820789, z=2.187483}
									,rotation	= {x=0.000864, y=269.999847, z=180.156250}
								}
								,{
									position	= {x=9.851039, y=1.820837, z=2.187500}
									,rotation	= {x=0.000844, y=269.999817, z=180.192429}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=9.851039, y=1.931230, z=-0.437500}
									,rotation	= {x=-0.000767, y=90.000015, z=0.000248}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "60"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=8.335494, y=1.875415, z=-0.437500}
									,rotation	= {x=-0.000250, y=179.999374, z=-0.000769}
								}
								,{
									position	= {x=9.093266, y=1.875431, z=-1.750000}
									,rotation	= {x=-0.000256, y=179.999420, z=-0.000768}
								}
								,{
									position	= {x=9.851038, y=1.875447, z=-3.062500}
									,rotation	= {x=-0.000249, y=179.999390, z=-0.000764}
								}
								,{
									position	= {x=10.608810, y=1.875451, z=-1.750000}
									,rotation	= {x=-0.000255, y=179.999420, z=-0.000767}
								}
								,{
									position	= {x=11.366583, y=1.875455, z=-0.437500}
									,rotation	= {x=-0.000259, y=179.999405, z=-0.000755}
								}
							}
						}
					}
				}
			}
			--Scenario 21
			,[21] = {
				--Obstacles
				{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Altar Horizontal"
							,tile	= {
								{
									position	= {x=10.063569, y=1.990759, z=0.759520}
									,rotation	= {x=0.744572, y=0.028776, z=359.571533}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=8.750001, y=1.818495, z=13.639903}
									,rotation	= {x=0.001190, y=60.735538, z=180.003479}
								}
								,{
									position	= {x=-0.437490, y=1.818224, z=6.819939}
									,rotation	= {x=-0.000251, y=359.981781, z=180.236984}
								}
								,{
									position	= {x=-0.437467, y=1.818283, z=0.757768}
									,rotation	= {x=0.000724, y=359.967865, z=180.239441}
								}
								,{
									position	= {x=8.750038, y=1.936525, z=-3.030990}
									,rotation	= {x=0.000662, y=300.006744, z=179.152435}
								}
								,{
									position	= {x=10.062601, y=1.824065, z=5.304775}
									,rotation	= {x=359.786163, y=269.981689, z=179.629761}
								}
							}
						}
						,{
							name	= "Stone Door Vertical"
							,tile	= {
								{
									position	= {x=2.187499, y=1.818418, z=5.304401}
									,rotation	= {x=0.000139, y=0.008527, z=180.000641}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=12.687505, y=1.931771, z=8.335492}
									,rotation	= {x=0.000275, y=180.000626, z=0.000224}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "15"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 22
			,[22] = {
				--Obstacles
				{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Altar Vertical"
							,tile	= {
								{
									position	= {x=-6.064237, y=1.948294, z=6.126060}
									,rotation	= {x=359.373444, y=90.027039, z=0.351750}
								}
								,{
									position	= {x=13.639899, y=1.931860, z=6.124999}
									,rotation	= {x=-0.001041, y=90.022514, z=0.000051}
								}
								,{
									position	= {x=-4.546634, y=1.931066, z=-6.999998}
									,rotation	= {x=-0.000767, y=90.022514, z=0.000248}
								}
								,{
									position	= {x=12.124355, y=1.931289, z=-7.000000}
									,rotation	= {x=-0.000768, y=90.022514, z=0.000247}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=0.000747, y=1.917167, z=3.499590}
									,rotation	= {x=0.009198, y=210.008072, z=186.541931}
								}
								,{
									position	= {x=3.788863, y=1.818414, z=4.812517}
									,rotation	= {x=0.007029, y=89.998917, z=180.027512}
								}
								,{
									position	= {x=7.577724, y=1.818487, z=3.500001}
									,rotation	= {x=0.000501, y=329.841278, z=179.997971}
								}
								,{
									position	= {x=-0.007657, y=1.818374, z=-4.378966}
									,rotation	= {x=0.005443, y=149.948776, z=179.972015}
								}
								,{
									position	= {x=7.577710, y=1.818394, z=-4.374999}
									,rotation	= {x=0.004388, y=30.000425, z=179.976273}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=4.546635, y=1.931762, z=-4.375001}
									,rotation	= {x=-0.000032, y=90.000015, z=-0.000198}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "21"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=3.031091, y=1.875975, z=-1.749998}
									,rotation	= {x=0.000202, y=179.999390, z=-0.000023}
								}
								,{
									position	= {x=4.546633, y=1.875976, z=-1.750001}
									,rotation	= {x=0.000204, y=179.999435, z=-0.000029}
								}
							}
						}
					}
				}
			}
			--Scenario 23
			,[23] = {
				--Corridors
				{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Pressure Plate"
							,tile	= {
								{
									position	= {x=-4.374998, y=1.934556, z=-3.031090}
									,rotation	= {x=0.000250, y=-0.001137, z=0.000769}
								}
								,{
									position	= {x=-1.749999, y=1.934611, z=-7.577722}
									,rotation	= {x=0.000249, y=-0.001149, z=0.000770}
								}
								,{
									position	= {x=-4.375000, y=1.934490, z=12.124355}
									,rotation	= {x=0.000245, y=-0.001147, z=0.000767}
								}
								,{
									position	= {x=-1.750000, y=1.934505, z=16.670988}
									,rotation	= {x=0.000256, y=-0.001149, z=0.000770}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Bear Trap"
							,tile	= {
								{
									position	= {x=3.500000, y=1.937250, z=9.093266}
									,rotation	= {x=0.000240, y=0.000325, z=0.000730}
								}
								,{
									position	= {x=2.187500, y=1.937236, z=8.335495}
									,rotation	= {x=0.000241, y=0.000213, z=0.000730}
								}
								,{
									position	= {x=2.187500, y=1.937242, z=6.819934}
									,rotation	= {x=0.000238, y=0.000244, z=0.000730}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Boulder"
							,tile	= {
								{
									position	= {x=-3.062499, y=1.931665, z=-2.273318}
									,rotation	= {x=0.000248, y=0.000044, z=0.000769}
								}
								,{
									position	= {x=-0.437500, y=1.931714, z=-5.304405}
									,rotation	= {x=0.000250, y=0.000070, z=0.000770}
								}
								,{
									position	= {x=0.875003, y=1.934349, z=0.000000}
									,rotation	= {x=0.000238, y=0.000032, z=0.000730}
								}
								,{
									position	= {x=2.187500, y=1.934356, z=2.273317}
									,rotation	= {x=0.000234, y=0.000072, z=0.000729}
								}
								,{
									position	= {x=3.500000, y=1.934370, z=3.031089}
									,rotation	= {x=0.000236, y=0.000070, z=0.000730}
								}
								,{
									position	= {x=4.812500, y=1.934396, z=0.757772}
									,rotation	= {x=0.000238, y=0.000096, z=0.000729}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=0.874999, y=1.820707, z=10.608835}
									,rotation	= {x=0.001736, y=240.384094, z=179.844711}
								}
								,{
									position	= {x=8.749954, y=1.821048, z=4.546650}
									,rotation	= {x=-0.000394, y=180.067322, z=180.207489}
								}
								,{
									position	= {x=0.874993, y=1.820758, z=-1.515570}
									,rotation	= {x=-0.000702, y=120.013702, z=179.845291}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=10.062500, y=1.931195, z=8.335494}
									,rotation	= {x=-0.000249, y=180.000656, z=-0.000770}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "39"
									}
								}
								,{
									position	= {x=10.062500, y=1.931228, z=0.757772}
									,rotation	= {x=-0.000249, y=180.000656, z=-0.000769}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "72"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 24
			,[24] = {
				--Traps
				{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Spike Trap"
							,tile	= {
								{
									position	= {x=-0.437500, y=1.931341, z=11.366583}
									,rotation	= {x=-0.000251, y=179.999893, z=-0.000766}
								}
								,{
									position	= {x=-0.437500, y=1.931681, z=2.273318}
									,rotation	= {x=-0.000252, y=179.999863, z=-0.000766}
								}
								,{
									position	= {x=-5.687504, y=1.931630, z=-2.273326}
									,rotation	= {x=-0.000260, y=179.999832, z=-0.000772}
								}
								,{
									position	= {x=4.812500, y=1.931177, z=-3.788861}
									,rotation	= {x=-0.000248, y=179.999878, z=-0.000763}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Nest"
							,tile	= {
								{
									position	= {x=-5.687500, y=1.931004, z=3.788860}
									,rotation	= {x=0.000246, y=0.052605, z=0.000772}
								}
								,{
									position	= {x=2.188281, y=1.931149, z=-5.274002}
									,rotation	= {x=0.000254, y=0.052609, z=0.000769}
								}
							}
						}
						,{
							name	= "Rock Column"
							,tile	= {
								{
									position	= {x=-1.750000, y=1.933899, z=18.186533}
									,rotation	= {x=0.000247, y=0.027981, z=0.000764}
								}
								,{
									position	= {x=2.187501, y=1.933955, z=17.428761}
									,rotation	= {x=0.000252, y=0.027982, z=0.000767}
								}
								,{
									position	= {x=-5.687500, y=1.933889, z=8.335494}
									,rotation	= {x=0.000250, y=0.027979, z=0.000769}
								}
								,{
									position	= {x=6.125000, y=1.934670, z=3.031089}
									,rotation	= {x=0.000254, y=0.027977, z=0.000766}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Dark Fog"
							,tile	= {
								{
									position	= {x=-0.437502, y=1.934745, z=14.397700}
									,rotation	= {x=359.984863, y=179.581573, z=-0.001423}
								}
								,{
									position	= {x=-3.062522, y=1.934767, z=11.366573}
									,rotation	= {x=0.002745, y=179.581604, z=359.990234}
								}
								,{
									position	= {x=-0.437490, y=1.935104, z=6.819987}
									,rotation	= {x=359.989166, y=179.581421, z=0.003459}
								}
								,{
									position	= {x=-3.062553, y=1.935066, z=5.304399}
									,rotation	= {x=0.005060, y=179.581635, z=359.974823}
								}
								,{
									position	= {x=-3.062557, y=1.935068, z=3.788851}
									,rotation	= {x=0.005031, y=179.581726, z=359.973358}
								}
								,{
									position	= {x=2.187500, y=1.935215, z=3.788867}
									,rotation	= {x=-0.000189, y=179.581329, z=-0.000779}
								}
								,{
									position	= {x=4.812436, y=1.935197, z=-0.757814}
									,rotation	= {x=0.004670, y=119.994209, z=359.975433}
								}
								,{
									position	= {x=0.875050, y=1.935103, z=-1.515554}
									,rotation	= {x=0.020202, y=119.994186, z=0.007803}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=-7.000001, y=1.931616, z=-3.031093}
									,rotation	= {x=-0.000254, y=180.000687, z=-0.000765}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "70"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=-7.002846, y=1.875181, z=6.082327}
									,rotation	= {x=-0.000247, y=179.999405, z=-0.000766}
								}
								,{
									position	= {x=-7.000000, y=1.875188, z=4.546632}
									,rotation	= {x=-0.000277, y=179.999390, z=-0.000775}
								}
								,{
									position	= {x=4.812500, y=1.875389, z=-5.304406}
									,rotation	= {x=-0.000246, y=179.999481, z=-0.000764}
								}
								,{
									position	= {x=3.500000, y=1.875375, z=-6.062178}
									,rotation	= {x=-0.000239, y=179.999420, z=-0.000762}
								}
							}
						}
					}
				}
			}
			--Scenario 25
			,[25] = {
				--Traps
				{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Spike Trap"
							,tile	= {
								{
									position	= {x=5.304406, y=1.931166, z=0.437499}
									,rotation	= {x=-0.000600, y=149.994675, z=-0.000537}
								}
								,{
									position	= {x=4.546633, y=1.931161, z=-0.875004}
									,rotation	= {x=-0.000601, y=149.994659, z=-0.000537}
								}
								,{
									position	= {x=6.062173, y=1.931181, z=-0.874996}
									,rotation	= {x=-0.000596, y=149.995071, z=-0.000537}
								}
								,{
									position	= {x=9.093266, y=1.931222, z=-0.875004}
									,rotation	= {x=-0.000602, y=149.994507, z=-0.000540}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Boulder"
							,tile	= {
								{
									position	= {x=3.788861, y=1.931122, z=5.687503}
									,rotation	= {x=-0.000766, y=89.979584, z=0.000252}
								}
								,{
									position	= {x=3.788853, y=1.931145, z=0.437500}
									,rotation	= {x=-0.000768, y=89.979561, z=0.000252}
								}
								,{
									position	= {x=8.335494, y=1.931195, z=3.062500}
									,rotation	= {x=-0.000765, y=89.979515, z=0.000255}
								}
								,{
									position	= {x=-6.062178, y=1.931042, z=-6.125000}
									,rotation	= {x=-0.000770, y=89.979553, z=0.000248}
								}
								,{
									position	= {x=-2.273317, y=1.931099, z=-7.437500}
									,rotation	= {x=-0.000768, y=89.979576, z=0.000251}
								}
								,{
									position	= {x=0.757775, y=1.931128, z=-4.812499}
									,rotation	= {x=-0.000764, y=89.979584, z=0.000248}
								}
							}
						}
						,{
							name	= "Boulder 2"
							,tile	= {
								{
									position	= {x=0.757766, y=1.933798, z=3.062503}
									,rotation	= {x=0.000769, y=269.994507, z=-0.000254}
								}
								,{
									position	= {x=3.031087, y=1.933834, z=1.750000}
									,rotation	= {x=0.000768, y=269.994507, z=-0.000254}
								}
								,{
									position	= {x=9.851050, y=1.933931, z=0.437506}
									,rotation	= {x=0.000599, y=330.008148, z=0.000543}
								}
								,{
									position	= {x=6.819980, y=1.933902, z=-2.187521}
									,rotation	= {x=-0.000165, y=30.005861, z=0.000792}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Dark Fog"
							,tile	= {
								{
									position	= {x=4.545937, y=1.937434, z=6.975271}
									,rotation	= {x=-0.000598, y=89.988449, z=359.814880}
								}
								,{
									position	= {x=1.515546, y=1.934637, z=-3.499617}
									,rotation	= {x=-0.000744, y=89.988136, z=0.000272}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=9.851043, y=1.931238, z=-2.187500}
									,rotation	= {x=-0.000770, y=89.999786, z=0.000252}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "58"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=-0.757773, y=1.875266, z=5.687500}
									,rotation	= {x=-0.000253, y=179.999405, z=-0.000761}
								}
								,{
									position	= {x=0.757770, y=1.875287, z=5.687501}
									,rotation	= {x=-0.000229, y=179.999390, z=-0.000772}
								}
								,{
									position	= {x=8.335494, y=1.875422, z=-2.187502}
									,rotation	= {x=-0.000268, y=179.999374, z=-0.000776}
								}
							}
						}
					}
				}
			}
			--Scenario 26
			,[26] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Water 1"
							,tile	= {
								{
									position	= {x=8.335492, y=1.931752, z=15.312502}
									,rotation	= {x=0.000677, y=270.008179, z=-0.000261}
								}
								,{
									position	= {x=9.093266, y=1.931767, z=14.000000}
									,rotation	= {x=0.000673, y=270.008118, z=-0.000262}
								}
								,{
									position	= {x=9.851038, y=1.931770, z=15.312502}
									,rotation	= {x=0.000676, y=270.008148, z=-0.000260}
								}
								,{
									position	= {x=10.608811, y=1.931785, z=14.000000}
									,rotation	= {x=0.000676, y=270.008148, z=-0.000260}
								}
								,{
									position	= {x=11.366583, y=1.931788, z=15.312503}
									,rotation	= {x=0.000675, y=270.008148, z=-0.000266}
								}
								,{
									position	= {x=12.124355, y=1.931803, z=14.000001}
									,rotation	= {x=0.000675, y=270.008148, z=-0.000264}
								}
								,{
									position	= {x=12.882128, y=1.931806, z=15.312504}
									,rotation	= {x=0.000675, y=270.008209, z=-0.000261}
								}
								,{
									position	= {x=-5.304406, y=1.931027, z=-0.437500}
									,rotation	= {x=0.000768, y=270.008148, z=-0.000250}
								}
								,{
									position	= {x=-0.757772, y=1.931088, z=-0.437500}
									,rotation	= {x=0.000769, y=270.008118, z=-0.000249}
								}
								,{
									position	= {x=-5.304406, y=1.931049, z=-5.687500}
									,rotation	= {x=0.000769, y=270.008148, z=-0.000250}
								}
								,{
									position	= {x=-0.757772, y=1.931110, z=-5.687501}
									,rotation	= {x=0.000770, y=270.008118, z=-0.000250}
								}
							}
						}
					}
				}
				--Corridors
				,{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Man Stone Corridor 2"
							,tile	= {
								{
									position	= {x=-3.788864, y=1.933738, z=2.187040}
									,rotation	= {x=-0.001163, y=89.970779, z=0.000342}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Poison Gas"
							,tile	= {
								{
									position	= {x=-4.546638, y=1.931011, z=3.499996}
									,rotation	= {x=0.000450, y=209.991867, z=-0.001130}
								}
								,{
									position	= {x=-1.515542, y=1.931075, z=3.499998}
									,rotation	= {x=0.000454, y=209.991943, z=-0.001132}
								}
								,{
									position	= {x=-5.304406, y=1.931038, z=-3.062500}
									,rotation	= {x=0.000172, y=209.991882, z=-0.000788}
								}
								,{
									position	= {x=-0.757771, y=1.931099, z=-3.062500}
									,rotation	= {x=0.000167, y=209.992050, z=-0.000788}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Boulder"
							,tile	= {
								{
									position	= {x=2.273327, y=1.931736, z=7.437495}
									,rotation	= {x=0.001787, y=30.008669, z=0.000331}
								}
								,{
									position	= {x=9.851032, y=1.931735, z=4.812500}
									,rotation	= {x=0.001793, y=30.008774, z=0.000333}
								}
							}
						}
						,{
							name	= "Boulder 2"
							,tile	= {
								{
									position	= {x=5.304910, y=1.934566, z=2.187800}
									,rotation	= {x=0.001181, y=330.002838, z=-0.001389}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=0.000013, y=1.818387, z=6.125000}
									,rotation	= {x=0.005263, y=149.992523, z=179.962662}
								}
								,{
									position	= {x=10.608810, y=1.818494, z=6.124995}
									,rotation	= {x=0.001762, y=89.988274, z=179.992386}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=2.273322, y=1.931658, z=10.062499}
									,rotation	= {x=0.000610, y=90.000023, z=0.001716}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "66"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=1.515554, y=1.875910, z=8.749986}
									,rotation	= {x=-0.001706, y=180.000519, z=0.000626}
								}
								,{
									position	= {x=3.031090, y=1.875895, z=8.749998}
									,rotation	= {x=-0.001730, y=180.000565, z=0.000610}
								}
							}
						}
					}
				}
			}
			--Scenario 27
			,[27] = {
				--Obstacles
				{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Altar Horizontal"
							,tile	= {
								{
									position	= {x=1.515543, y=1.931724, z=-1.750001}
									,rotation	= {x=-0.000770, y=90.236702, z=0.000251}
								}
							}
						}
					}
				}
			}
			--Scenario 28
			,[28] = {
				--Obstacles
				{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Altar Horizontal"
							,tile	= {
								{
									position	= {x=3.937500, y=1.931746, z=0.757772}
									,rotation	= {x=0.000253, y=0.000049, z=0.000768}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=-1.312499, y=1.818282, z=-0.757774}
									,rotation	= {x=0.004409, y=179.991196, z=179.967804}
								}
								,{
									position	= {x=9.187504, y=1.818462, z=-0.757771}
									,rotation	= {x=0.005974, y=0.019443, z=179.977051}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=-6.562500, y=1.931005, z=0.757772}
									,rotation	= {x=-0.000255, y=180.000656, z=-0.000768}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "32"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=-5.250000, y=1.875231, z=0.000000}
									,rotation	= {x=-0.000254, y=179.999405, z=-0.000764}
								}
								,{
									position	= {x=-3.937500, y=1.875246, z=0.757772}
									,rotation	= {x=-0.000256, y=179.999420, z=-0.000785}
								}
								,{
									position	= {x=-3.937500, y=1.875252, z=-0.757772}
									,rotation	= {x=-0.000247, y=179.999420, z=-0.000764}
								}
								,{
									position	= {x=11.812500, y=1.875459, z=0.757772}
									,rotation	= {x=0.000067, y=179.999420, z=-0.000624}
								}
								,{
									position	= {x=11.812500, y=1.875457, z=-0.757773}
									,rotation	= {x=0.000069, y=179.999405, z=-0.000626}
								}
								,{
									position	= {x=13.125000, y=1.875472, z=0.000000}
									,rotation	= {x=0.000069, y=179.999420, z=-0.000623}
								}
							}
						}
					}
				}
			}
			--Scenario 29
			,[29] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Rubble"
							,tile	= {
								{
									position	= {x=-3.062500, y=1.931665, z=-2.273317}
									,rotation	= {x=0.000250, y=359.971619, z=0.000767}
								}
								,{
									position	= {x=2.187503, y=1.933518, z=3.788918}
									,rotation	= {x=0.029560, y=359.971619, z=-0.001510}
								}
								,{
									position	= {x=3.500004, y=1.933093, z=4.546690}
									,rotation	= {x=0.029566, y=359.971619, z=-0.001501}
								}
								,{
									position	= {x=11.375000, y=1.931876, z=-4.546635}
									,rotation	= {x=0.000331, y=359.971619, z=0.000237}
								}
								,{
									position	= {x=11.375002, y=1.931885, z=-6.062180}
									,rotation	= {x=0.000334, y=359.971680, z=0.000237}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Nest"
							,tile	= {
								{
									position	= {x=0.875004, y=1.932379, z=6.062235}
									,rotation	= {x=0.029567, y=-0.001266, z=-0.001489}
								}
								,{
									position	= {x=6.125006, y=1.933806, z=3.031147}
									,rotation	= {x=0.029567, y=-0.001230, z=-0.001488}
								}
								,{
									position	= {x=-5.687500, y=1.931630, z=-2.273317}
									,rotation	= {x=0.000250, y=-0.001237, z=0.000764}
								}
								,{
									position	= {x=2.187501, y=1.928069, z=-0.757773}
									,rotation	= {x=0.000249, y=-0.001240, z=0.000761}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=-0.437475, y=1.818408, z=-3.788860}
									,rotation	= {x=-0.000194, y=179.992828, z=180.241058}
								}
								,{
									position	= {x=7.437301, y=1.818421, z=-3.788917}
									,rotation	= {x=0.000572, y=359.981689, z=180.236557}
								}
							}
						}
						,{
							name	= "Stone Door Vertical"
							,tile	= {
								{
									position	= {x=3.499995, y=1.821230, z=1.515536}
									,rotation	= {x=359.509277, y=0.002642, z=179.998184}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=14.000002, y=1.931887, z=-4.546634}
									,rotation	= {x=-0.000335, y=180.000656, z=-0.000238}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "41"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 30
			,[30] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Stairs Vertical"
							,tile	= {
								{
									position	= {x=-2.617573, y=1.933901, z=15.168235}
									,rotation	= {x=-0.000782, y=119.983322, z=-0.000167}
								}
								,{
									position	= {x=2.625000, y=1.933970, z=15.155446}
									,rotation	= {x=-0.000533, y=59.939541, z=0.000593}
								}
							}
						}
						,{
							name	= "Water 1"
							,tile	= {
								{
									position	= {x=-2.625000, y=1.931009, z=12.124355}
									,rotation	= {x=-0.000247, y=179.984802, z=-0.000761}
								}
								,{
									position	= {x=-1.312500, y=1.931023, z=12.882128}
									,rotation	= {x=-0.000245, y=179.984802, z=-0.000756}
								}
								,{
									position	= {x=-1.312500, y=1.931029, z=11.366583}
									,rotation	= {x=-0.000248, y=179.984802, z=-0.000757}
								}
								,{
									position	= {x=1.312500, y=1.931058, z=12.882128}
									,rotation	= {x=-0.000246, y=179.984802, z=-0.000759}
								}
								,{
									position	= {x=3.937500, y=1.931092, z=12.882128}
									,rotation	= {x=-0.000247, y=179.984802, z=-0.000761}
								}
								,{
									position	= {x=1.312500, y=1.931071, z=9.851039}
									,rotation	= {x=-0.000244, y=179.984802, z=-0.000759}
								}
								,{
									position	= {x=2.625000, y=1.931085, z=10.608810}
									,rotation	= {x=-0.000250, y=179.984802, z=-0.000761}
								}
								,{
									position	= {x=2.625000, y=1.931091, z=9.093266}
									,rotation	= {x=-0.000248, y=179.984802, z=-0.000758}
								}
								,{
									position	= {x=3.937500, y=1.931105, z=9.851039}
									,rotation	= {x=-0.000248, y=179.984802, z=-0.000760}
								}
								,{
									position	= {x=3.937500, y=1.931112, z=8.335494}
									,rotation	= {x=-0.000244, y=179.984802, z=-0.000758}
								}
								,{
									position	= {x=-2.625000, y=1.931022, z=9.093266}
									,rotation	= {x=-0.000246, y=179.984802, z=-0.000761}
								}
								,{
									position	= {x=-1.312500, y=1.931042, z=8.335494}
									,rotation	= {x=-0.000247, y=179.984802, z=-0.000761}
								}
								,{
									position	= {x=0.000001, y=1.931063, z=7.577722}
									,rotation	= {x=-0.000248, y=179.984818, z=-0.000757}
								}
								,{
									position	= {x=0.000000, y=2.047269, z=6.062179}
									,rotation	= {x=-0.000239, y=179.984970, z=-0.000876}
								}
								,{
									position	= {x=1.312543, y=2.047083, z=6.819873}
									,rotation	= {x=-0.000249, y=180.037689, z=-0.000931}
								}
								,{
									position	= {x=1.312500, y=2.047090, z=5.304405}
									,rotation	= {x=-0.000216, y=180.000259, z=-0.000790}
								}
								,{
									position	= {x=1.312503, y=1.931097, z=3.788861}
									,rotation	= {x=-0.000307, y=179.984818, z=-0.000791}
								}
								,{
									position	= {x=0.000001, y=1.931083, z=3.031089}
									,rotation	= {x=-0.000312, y=179.984818, z=-0.000793}
								}
								,{
									position	= {x=-1.312500, y=1.931061, z=3.788861}
									,rotation	= {x=-0.000307, y=179.984802, z=-0.000791}
								}
								,{
									position	= {x=-1.312500, y=1.931069, z=2.273317}
									,rotation	= {x=-0.000309, y=179.984818, z=-0.000794}
								}
								,{
									position	= {x=-2.625000, y=1.931046, z=3.031089}
									,rotation	= {x=-0.000307, y=179.984802, z=-0.000792}
								}
								,{
									position	= {x=-3.937500, y=1.931032, z=2.273317}
									,rotation	= {x=-0.000315, y=179.984818, z=-0.000795}
								}
								,{
									position	= {x=1.312500, y=1.931113, z=0.757772}
									,rotation	= {x=-0.000313, y=179.984787, z=-0.000797}
								}
								,{
									position	= {x=3.937500, y=1.931150, z=0.757772}
									,rotation	= {x=-0.000311, y=179.984787, z=-0.000795}
								}
							}
						}
					}
				}
				--Corridors
				,{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Man Stone Corridor 1"
							,tile	= {
								{
									position	= {x=0.000000, y=1.817773, z=6.062177}
									,rotation	= {x=0.000236, y=-0.001290, z=180.000870}
								}
							}
						}
						,{
							name	= "Man Stone Corridor 2"
							,tile	= {
								{
									position	= {x=-3.937498, y=1.933719, z=5.304408}
									,rotation	= {x=0.000087, y=0.033268, z=0.000825}
								}
								,{
									position	= {x=-1.312499, y=1.933758, z=5.304405}
									,rotation	= {x=0.000085, y=0.033303, z=0.000820}
								}
								,{
									position	= {x=1.312663, y=1.934124, z=5.304389}
									,rotation	= {x=359.984070, y=0.030324, z=0.000314}
								}
								,{
									position	= {x=3.937501, y=1.933830, z=5.304407}
									,rotation	= {x=0.000258, y=0.033308, z=0.000788}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Bear Trap"
							,tile	= {
								{
									position	= {x=-1.312500, y=1.933915, z=15.913215}
									,rotation	= {x=0.000247, y=0.000324, z=0.000759}
								}
								,{
									position	= {x=1.312500, y=1.933949, z=15.913217}
									,rotation	= {x=0.000247, y=0.000324, z=0.000762}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Boulder"
							,tile	= {
								{
									position	= {x=-1.312500, y=1.931016, z=14.397670}
									,rotation	= {x=0.000247, y=0.000145, z=0.000761}
								}
								,{
									position	= {x=0.000000, y=1.931037, z=13.639900}
									,rotation	= {x=0.000250, y=0.000143, z=0.000762}
								}
								,{
									position	= {x=1.312500, y=1.931051, z=14.397672}
									,rotation	= {x=0.000249, y=0.000143, z=0.000758}
								}
							}
						}
						,{
							name	= "Wall Section"
							,tile	= {
								{
									position	= {x=-3.937585, y=1.933674, z=17.423737}
									,rotation	= {x=-0.000247, y=179.979538, z=-0.000755}
								}
								,{
									position	= {x=3.937500, y=1.933784, z=15.913218}
									,rotation	= {x=0.000246, y=0.019901, z=0.000762}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Vertical"
							,tile	= {
								{
									position	= {x=0.000000, y=1.817719, z=-1.515596}
									,rotation	= {x=359.773926, y=0.009228, z=180.000732}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=0.000000, y=1.931030, z=15.155446}
									,rotation	= {x=-0.000244, y=180.000732, z=-0.000759}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=-2.625000, y=1.875194, z=16.670988}
									,rotation	= {x=-0.000243, y=179.999420, z=-0.000768}
								}
								,{
									position	= {x=-1.312500, y=1.875208, z=17.428761}
									,rotation	= {x=-0.000246, y=179.999420, z=-0.000739}
								}
								,{
									position	= {x=1.312500, y=1.875243, z=17.428761}
									,rotation	= {x=-0.000250, y=179.999420, z=-0.000751}
								}
								,{
									position	= {x=2.625000, y=1.875264, z=16.670988}
									,rotation	= {x=-0.000248, y=179.999420, z=-0.000747}
								}
							}
						}
					}
				}
			}
			--Scenario 31
			,[31] = {
				--Traps
				{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Spike Trap"
							,tile	= {
								{
									position	= {x=5.687491, y=1.931769, z=0.757759}
									,rotation	= {x=-0.000253, y=180.000031, z=-0.000767}
								}
								,{
									position	= {x=5.687500, y=1.931750, z=5.304406}
									,rotation	= {x=-0.000253, y=179.999893, z=-0.000765}
								}
								,{
									position	= {x=5.687500, y=1.931123, z=11.366583}
									,rotation	= {x=-0.000248, y=179.999908, z=-0.000769}
								}
								,{
									position	= {x=7.000000, y=1.931137, z=12.124357}
									,rotation	= {x=-0.000250, y=180.000076, z=-0.000771}
								}
								,{
									position	= {x=8.312500, y=1.931158, z=11.366583}
									,rotation	= {x=-0.000246, y=179.999924, z=-0.000769}
								}
								,{
									position	= {x=8.312500, y=1.931132, z=17.428761}
									,rotation	= {x=-0.000249, y=179.999954, z=-0.000768}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Rock Column"
							,tile	= {
								{
									position	= {x=-3.500000, y=1.933968, z=-3.031089}
									,rotation	= {x=0.000249, y=0.027980, z=0.000769}
								}
							}
						}
						,{
							name	= "Stalagmites"
							,tile	= {
								{
									position	= {x=7.000000, y=1.934016, z=18.186533}
									,rotation	= {x=0.000245, y=0.004061, z=0.000769}
								}
								,{
									position	= {x=5.687500, y=1.934015, z=14.397672}
									,rotation	= {x=0.000251, y=0.004063, z=0.000770}
								}
								,{
									position	= {x=8.312507, y=1.934670, z=9.851062}
									,rotation	= {x=0.000249, y=0.003918, z=0.000771}
								}
								,{
									position	= {x=5.687500, y=1.934661, z=3.788861}
									,rotation	= {x=0.000247, y=0.004052, z=0.000767}
								}
								,{
									position	= {x=3.062497, y=1.934633, z=2.273308}
									,rotation	= {x=0.000252, y=0.004042, z=0.000773}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Dark Fog"
							,tile	= {
								{
									position	= {x=6.999990, y=1.935126, z=10.608873}
									,rotation	= {x=359.983276, y=180.006851, z=359.991241}
								}
								,{
									position	= {x=0.437446, y=1.935092, z=-0.757882}
									,rotation	= {x=0.022483, y=240.000122, z=0.007123}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=1.750001, y=1.931139, z=-4.546633}
									,rotation	= {x=-0.000248, y=180.000687, z=-0.000769}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "69"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 32
			,[32] = {
				--Corridors
				{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Earth Corridor 1"
							,tile	= {
								{
									position	= {x=-3.031072, y=1.817969, z=6.125029}
									,rotation	= {x=0.009489, y=270.023590, z=180.014709}
								}
							}
						}
						,{
							name	= "Earth Corridor 2"
							,tile	= {
								{
									position	= {x=-4.545111, y=1.934012, z=6.123358}
									,rotation	= {x=0.000281, y=270.067749, z=0.015545}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Poison Gas"
							,tile	= {
								{
									position	= {x=-6.819949, y=1.930985, z=4.812498}
									,rotation	= {x=-0.000602, y=149.999710, z=-0.000537}
								}
								,{
									position	= {x=-5.304405, y=1.931006, z=4.812500}
									,rotation	= {x=-0.000598, y=149.999817, z=-0.000536}
								}
								,{
									position	= {x=-6.062175, y=1.931001, z=3.499997}
									,rotation	= {x=-0.000601, y=149.999741, z=-0.000540}
								}
							}
						}
						,{
							name	= "Spike Trap"
							,tile	= {
								{
									position	= {x=-7.577723, y=1.931257, z=8.750000}
									,rotation	= {x=-0.000595, y=150.029861, z=-0.000542}
								}
								,{
									position	= {x=-6.062250, y=1.931278, z=8.750193}
									,rotation	= {x=-0.000596, y=150.029846, z=-0.000540}
								}
								,{
									position	= {x=-2.273312, y=1.931334, z=7.437498}
									,rotation	= {x=-0.000596, y=150.021210, z=-0.000543}
								}
								,{
									position	= {x=-6.062177, y=1.931024, z=-1.750000}
									,rotation	= {x=-0.000602, y=150.021194, z=-0.000540}
								}
								,{
									position	= {x=1.515538, y=1.931113, z=0.875005}
									,rotation	= {x=-0.000594, y=150.021179, z=-0.000538}
								}
								,{
									position	= {x=0.757764, y=1.931109, z=-0.437498}
									,rotation	= {x=-0.000594, y=150.021332, z=-0.000541}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Boulder 2"
							,tile	= {
								{
									position	= {x=-3.788861, y=1.934019, z=7.437500}
									,rotation	= {x=0.000597, y=330.011169, z=0.000542}
								}
								,{
									position	= {x=-4.546630, y=1.933727, z=3.499998}
									,rotation	= {x=-0.000166, y=30.005383, z=0.000787}
								}
								,{
									position	= {x=-0.757771, y=1.933771, z=4.812500}
									,rotation	= {x=0.000763, y=270.028351, z=-0.000255}
								}
								,{
									position	= {x=-3.788905, y=1.933765, z=-3.062534}
									,rotation	= {x=0.000600, y=330.013947, z=0.000543}
								}
							}
						}
						,{
							name	= "Boulder 3"
							,tile	= {
								{
									position	= {x=-4.554533, y=1.934638, z=0.874985}
									,rotation	= {x=-0.000769, y=89.979675, z=0.000249}
								}
							}
						}
						,{
							name	= "Nest"
							,tile	= {
								{
									position	= {x=-6.062178, y=1.930954, z=14.000000}
									,rotation	= {x=-0.000168, y=29.999998, z=0.000790}
								}
								,{
									position	= {x=2.273314, y=1.931095, z=7.437500}
									,rotation	= {x=-0.000173, y=30.000042, z=0.000788}
								}
								,{
									position	= {x=9.093268, y=1.931193, z=6.125000}
									,rotation	= {x=-0.000172, y=30.000154, z=0.000791}
								}
							}
						}
						,{
							name	= "Table"
							,tile	= {
								{
									position	= {x=7.577723, y=1.933866, z=8.750007}
									,rotation	= {x=0.000769, y=269.929810, z=-0.000252}
								}
								,{
									position	= {x=5.304056, y=1.933852, z=4.802957}
									,rotation	= {x=0.000767, y=269.929810, z=-0.000246}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "LIght Fog"
							,tile	= {
								{
									position	= {x=-0.000002, y=1.934599, z=0.875000}
									,rotation	= {x=-0.000717, y=89.991440, z=0.000276}
								}
							}
						}
						,{
							name	= "Wooden Door Horizontal"
							,tile	= {
								{
									position	= {x=-6.819949, y=1.817915, z=10.062495}
									,rotation	= {x=0.003683, y=270.000000, z=179.984055}
								}
								,{
									position	= {x=2.273316, y=1.817789, z=10.062502}
									,rotation	= {x=0.000773, y=270.000000, z=179.999710}
								}
								,{
									position	= {x=6.819950, y=1.817883, z=2.187501}
									,rotation	= {x=0.000761, y=269.999969, z=179.999802}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=3.031089, y=1.931076, z=14.000000}
									,rotation	= {x=-0.000768, y=90.000031, z=0.000252}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 33
			,[33] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Rubble"
							,tile	= {
								{
									position	= {x=2.273305, y=1.931100, z=3.062486}
									,rotation	= {x=-0.000593, y=30.005192, z=0.000574}
								}
								,{
									position	= {x=4.546620, y=1.931126, z=1.749988}
									,rotation	= {x=-0.000589, y=30.005247, z=0.000576}
								}
								,{
									position	= {x=7.577730, y=1.931179, z=4.375007}
									,rotation	= {x=-0.000591, y=30.005138, z=0.000574}
								}
								,{
									position	= {x=3.031086, y=1.931153, z=-3.500002}
									,rotation	= {x=-0.000151, y=30.005268, z=0.000776}
								}
								,{
									position	= {x=3.788859, y=1.931168, z=-4.812503}
									,rotation	= {x=-0.000156, y=30.005161, z=0.000773}
								}
							}
						}
					}
				}
				--Corridors
				,{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Man Stone Corridor 2"
							,tile	= {
								{
									position	= {x=-2.273315, y=1.934092, z=-4.812498}
									,rotation	= {x=0.000608, y=329.988342, z=0.000337}
								}
							}
						}
						,{
							name	= "Pressure Plate"
							,tile	= {
								{
									position	= {x=1.515542, y=1.934010, z=6.999996}
									,rotation	= {x=0.000793, y=270.008636, z=0.000228}
								}
								,{
									position	= {x=1.515536, y=1.934000, z=4.374990}
									,rotation	= {x=0.000794, y=270.008698, z=0.000225}
								}
								,{
									position	= {x=9.093281, y=1.934115, z=7.000016}
									,rotation	= {x=0.000794, y=270.008728, z=0.000226}
								}
								,{
									position	= {x=9.093276, y=1.934105, z=4.375012}
									,rotation	= {x=0.000794, y=270.008728, z=0.000225}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Bear Trap"
							,tile	= {
								{
									position	= {x=2.273313, y=1.934562, z=16.187500}
									,rotation	= {x=-0.000745, y=90.008522, z=0.000263}
								}
								,{
									position	= {x=3.788859, y=1.934582, z=16.187500}
									,rotation	= {x=-0.000745, y=90.008545, z=0.000265}
								}
								,{
									position	= {x=6.819950, y=1.934622, z=16.187500}
									,rotation	= {x=-0.000743, y=90.008583, z=0.000263}
								}
								,{
									position	= {x=8.335494, y=1.934641, z=16.187500}
									,rotation	= {x=-0.000749, y=90.008560, z=0.000263}
								}
								,{
									position	= {x=2.273313, y=1.934575, z=13.562500}
									,rotation	= {x=-0.000742, y=90.008514, z=0.000270}
								}
								,{
									position	= {x=8.335494, y=1.934653, z=13.562500}
									,rotation	= {x=-0.000747, y=90.008560, z=0.000266}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=5.304409, y=1.818355, z=8.312502}
									,rotation	= {x=0.008913, y=269.994720, z=180.023071}
								}
								,{
									position	= {x=5.304401, y=1.817861, z=0.437499}
									,rotation	= {x=0.001491, y=269.994171, z=179.997787}
								}
								,{
									position	= {x=2.273314, y=1.818105, z=-4.812498}
									,rotation	= {x=0.003734, y=330.029114, z=179.984787}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=3.031088, y=1.931661, z=17.500000}
									,rotation	= {x=-0.000745, y=90.000244, z=0.000263}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=7.577722, y=1.931720, z=17.500000}
									,rotation	= {x=-0.000746, y=90.000244, z=0.000263}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=1.515535, y=1.931654, z=14.875000}
									,rotation	= {x=-0.000745, y=90.000237, z=0.000268}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=9.093266, y=1.931752, z=14.875000}
									,rotation	= {x=-0.000745, y=90.000244, z=0.000264}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=4.546633, y=1.875886, z=17.500000}
									,rotation	= {x=-0.000265, y=179.999374, z=-0.000738}
								}
								,{
									position	= {x=6.062178, y=1.875906, z=17.500000}
									,rotation	= {x=-0.000268, y=179.999420, z=-0.000733}
								}
								,{
									position	= {x=1.515536, y=1.875871, z=12.250000}
									,rotation	= {x=-0.000269, y=179.999268, z=-0.000751}
								}
								,{
									position	= {x=9.093266, y=1.875970, z=12.250000}
									,rotation	= {x=-0.000277, y=179.999512, z=-0.000737}
								}
							}
						}
					}
				}
			}
			--Scenario 34
			,[34] = {
				--Corridors
				{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Stone Corridor 1"
							,tile	= {
								{
									position	= {x=0.000004, y=1.817824, z=-5.250006}
									,rotation	= {x=0.000821, y=269.994568, z=179.999771}
								}
								,{
									position	= {x=0.000004, y=1.817813, z=-2.625000}
									,rotation	= {x=0.000826, y=269.994568, z=179.999786}
								}
								,{
									position	= {x=0.000000, y=1.817802, z=0.000003}
									,rotation	= {x=0.000832, y=269.994568, z=179.999786}
								}
							}
						}
						,{
							name	= "Stone Corridor 2"
							,tile	= {
								{
									position	= {x=0.757773, y=1.933840, z=-6.562567}
									,rotation	= {x=0.000805, y=270.000580, z=-0.000272}
								}
								,{
									position	= {x=0.757775, y=1.933829, z=-3.937500}
									,rotation	= {x=0.000808, y=270.000580, z=-0.000256}
								}
								,{
									position	= {x=0.757779, y=1.933817, z=-1.312497}
									,rotation	= {x=0.000790, y=270.000580, z=-0.000236}
								}
								,{
									position	= {x=0.757778, y=1.933806, z=1.312503}
									,rotation	= {x=0.000820, y=270.000641, z=-0.000261}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Boulder 3"
							,tile	= {
								{
									position	= {x=-6.819951, y=1.934627, z=-3.937501}
									,rotation	= {x=-0.000765, y=89.991592, z=0.000248}
								}
								,{
									position	= {x=-0.757788, y=2.050724, z=1.312519}
									,rotation	= {x=-0.000591, y=89.991417, z=0.005315}
								}
								,{
									position	= {x=5.304405, y=1.934790, z=-3.937500}
									,rotation	= {x=-0.000768, y=89.991722, z=0.000248}
								}
							}
						}
						,{
							name	= "Nest"
							,tile	= {
								{
									position	= {x=-4.546633, y=1.931035, z=0.000000}
									,rotation	= {x=-0.000166, y=30.033485, z=0.000789}
								}
								,{
									position	= {x=-3.031089, y=1.931078, z=-5.250002}
									,rotation	= {x=-0.000166, y=30.033514, z=0.000790}
								}
								,{
									position	= {x=2.273317, y=1.931145, z=-3.937500}
									,rotation	= {x=-0.000167, y=30.033518, z=0.000789}
								}
								,{
									position	= {x=3.788861, y=1.931154, z=-1.312500}
									,rotation	= {x=-0.000174, y=30.033518, z=0.000788}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=6.819950, y=1.931183, z=1.312499}
									,rotation	= {x=-0.000768, y=90.000015, z=0.000245}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "23"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=-6.819950, y=1.875204, z=1.312501}
									,rotation	= {x=-0.000248, y=179.999435, z=-0.000768}
								}
								,{
									position	= {x=-5.304405, y=1.875224, z=1.312501}
									,rotation	= {x=-0.000246, y=179.999298, z=-0.000769}
								}
								,{
									position	= {x=-3.788861, y=1.875245, z=1.312501}
									,rotation	= {x=-0.000246, y=179.999344, z=-0.000765}
								}
								,{
									position	= {x=-6.062178, y=1.875220, z=0.000000}
									,rotation	= {x=-0.000248, y=179.999420, z=-0.000776}
								}
								,{
									position	= {x=5.304405, y=1.875368, z=1.312500}
									,rotation	= {x=-0.000250, y=179.999451, z=-0.000776}
								}
								,{
									position	= {x=6.062178, y=1.875383, z=0.000000}
									,rotation	= {x=-0.000259, y=179.999283, z=-0.000763}
								}
							}
						}
					}
				}
			}
			--Scenario 35
			,[35] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Stairs Horizontal"
							,tile	= {
								{
									position	= {x=-3.031092, y=1.933968, z=-1.750002}
									,rotation	= {x=0.000763, y=270.011200, z=-0.000267}
								}
								,{
									position	= {x=1.515543, y=2.050022, z=-1.749996}
									,rotation	= {x=-0.000476, y=90.069336, z=0.000205}
								}
							}
						}
					}
				}
				--Corridors
				,{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Earth Corridor 1"
							,tile	= {
								{
									position	= {x=-0.757782, y=1.817759, z=7.437508}
									,rotation	= {x=0.000625, y=270.013062, z=179.999817}
								}
								,{
									position	= {x=-0.757780, y=1.817771, z=4.812503}
									,rotation	= {x=0.000616, y=270.013245, z=179.999817}
								}
								,{
									position	= {x=-0.757775, y=1.817783, z=2.187504}
									,rotation	= {x=0.000583, y=270.013336, z=179.999817}
								}
							}
						}
						,{
							name	= "Earth Corridor 2"
							,tile	= {
								{
									position	= {x=-0.000012, y=1.933762, z=8.749368}
									,rotation	= {x=0.000695, y=270.028503, z=-0.000227}
								}
								,{
									position	= {x=-0.000004, y=1.933774, z=6.125002}
									,rotation	= {x=0.000666, y=270.028687, z=-0.000250}
								}
								,{
									position	= {x=0.000000, y=1.933786, z=3.500000}
									,rotation	= {x=0.000646, y=270.028687, z=-0.000242}
								}
								,{
									position	= {x=0.000000, y=1.933798, z=0.875001}
									,rotation	= {x=0.000628, y=270.028748, z=-0.000238}
								}
							}
						}
						,{
							name	= "Man Stone Corridor 1"
							,tile	= {
								{
									position	= {x=0.757767, y=1.817825, z=-3.062498}
									,rotation	= {x=0.000828, y=269.995972, z=179.999741}
								}
								,{
									position	= {x=0.756038, y=1.817837, z=-5.677360}
									,rotation	= {x=0.001191, y=270.017212, z=180.000595}
								}
							}
						}
						,{
							name	= "Man Stone Corridor 2"
							,tile	= {
								{
									position	= {x=-5.304405, y=1.933736, z=-0.437500}
									,rotation	= {x=0.000871, y=269.994415, z=0.000039}
								}
								,{
									position	= {x=-2.273316, y=1.933775, z=-0.437500}
									,rotation	= {x=0.000756, y=269.994446, z=0.000048}
								}
								,{
									position	= {x=2.273316, y=1.933834, z=-0.437499}
									,rotation	= {x=0.000799, y=269.994415, z=-0.000249}
								}
								,{
									position	= {x=5.304405, y=1.933875, z=-0.437499}
									,rotation	= {x=0.000764, y=269.994446, z=-0.000303}
								}
								,{
									position	= {x=1.515536, y=1.933830, z=-1.749991}
									,rotation	= {x=0.000812, y=269.994263, z=-0.000261}
								}
								,{
									position	= {x=1.515543, y=1.933842, z=-4.374999}
									,rotation	= {x=0.000797, y=269.994446, z=-0.000266}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Bear Trap"
							,tile	= {
								{
									position	= {x=-6.062179, y=1.933907, z=3.500000}
									,rotation	= {x=-0.000767, y=89.992317, z=0.000264}
								}
								,{
									position	= {x=-4.546633, y=1.933915, z=6.125000}
									,rotation	= {x=-0.000768, y=89.992279, z=0.000263}
								}
								,{
									position	= {x=0.000003, y=2.049984, z=3.500003}
									,rotation	= {x=-0.000525, y=89.992210, z=0.000425}
								}
								,{
									position	= {x=3.788860, y=1.934019, z=7.437501}
									,rotation	= {x=-0.000768, y=89.992279, z=0.000256}
								}
								,{
									position	= {x=5.304407, y=1.934062, z=2.187498}
									,rotation	= {x=-0.000773, y=89.992279, z=0.000252}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Stone Pillar"
							,tile	= {
								{
									position	= {x=-3.788865, y=1.931059, z=-3.062502}
									,rotation	= {x=-0.000765, y=89.900368, z=0.000268}
								}
								,{
									position	= {x=2.273315, y=1.931141, z=-3.062499}
									,rotation	= {x=-0.000769, y=89.900322, z=0.000254}
								}
							}
						}
						,{
							name	= "Wall Section"
							,tile	= {
								{
									position	= {x=-5.304407, y=2.049736, z=-0.437502}
									,rotation	= {x=0.000873, y=269.997345, z=0.000043}
								}
								,{
									position	= {x=-3.788941, y=2.049756, z=-0.435606}
									,rotation	= {x=-0.000743, y=90.049538, z=-0.000156}
								}
								,{
									position	= {x=2.284055, y=2.049835, z=-0.438053}
									,rotation	= {x=0.000836, y=270.001526, z=-0.000281}
								}
								,{
									position	= {x=3.788867, y=2.049855, z=-0.437916}
									,rotation	= {x=-0.000762, y=90.068260, z=0.000302}
								}
								,{
									position	= {x=-5.304395, y=1.933743, z=-3.062496}
									,rotation	= {x=0.000767, y=270.025208, z=-0.000270}
								}
								,{
									position	= {x=3.788859, y=1.933866, z=-3.062171}
									,rotation	= {x=-0.000768, y=90.025284, z=0.000262}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=-0.757772, y=1.817795, z=-0.437500}
									,rotation	= {x=0.000653, y=270.000793, z=179.999786}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=5.304407, y=1.931193, z=-5.687501}
									,rotation	= {x=-0.000769, y=89.999954, z=0.000252}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "61"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 36
			,[36] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Stairs Horizontal"
							,tile	= {
								{
									position	= {x=-3.031092, y=1.933968, z=-1.750002}
									,rotation	= {x=0.000763, y=270.011200, z=-0.000267}
								}
								,{
									position	= {x=1.515543, y=2.050022, z=-1.749996}
									,rotation	= {x=-0.000476, y=90.069336, z=0.000205}
								}
							}
						}
					}
				}
				--Corridors
				,{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Earth Corridor 1"
							,tile	= {
								{
									position	= {x=-0.757782, y=1.817759, z=7.437508}
									,rotation	= {x=0.000625, y=270.013062, z=179.999817}
								}
								,{
									position	= {x=-0.757780, y=1.817771, z=4.812503}
									,rotation	= {x=0.000616, y=270.013245, z=179.999817}
								}
								,{
									position	= {x=-0.757775, y=1.817783, z=2.187504}
									,rotation	= {x=0.000583, y=270.013336, z=179.999817}
								}
							}
						}
						,{
							name	= "Earth Corridor 2"
							,tile	= {
								{
									position	= {x=-0.000012, y=1.933762, z=8.749368}
									,rotation	= {x=0.000695, y=270.028503, z=-0.000227}
								}
								,{
									position	= {x=-0.000004, y=1.933774, z=6.125002}
									,rotation	= {x=0.000666, y=270.028687, z=-0.000250}
								}
								,{
									position	= {x=0.000000, y=1.933786, z=3.500000}
									,rotation	= {x=0.000646, y=270.028687, z=-0.000242}
								}
								,{
									position	= {x=0.000000, y=1.933798, z=0.875001}
									,rotation	= {x=0.000628, y=270.028748, z=-0.000238}
								}
							}
						}
						,{
							name	= "Man Stone Corridor 1"
							,tile	= {
								{
									position	= {x=0.757767, y=1.817825, z=-3.062498}
									,rotation	= {x=0.000828, y=269.995972, z=179.999741}
								}
								,{
									position	= {x=0.756038, y=1.817837, z=-5.677360}
									,rotation	= {x=0.001191, y=270.017212, z=180.000595}
								}
							}
						}
						,{
							name	= "Man Stone Corridor 2"
							,tile	= {
								{
									position	= {x=-5.304405, y=1.933736, z=-0.437500}
									,rotation	= {x=0.000871, y=269.994415, z=0.000039}
								}
								,{
									position	= {x=-2.273316, y=1.933775, z=-0.437500}
									,rotation	= {x=0.000756, y=269.994446, z=0.000048}
								}
								,{
									position	= {x=2.273316, y=1.933834, z=-0.437499}
									,rotation	= {x=0.000799, y=269.994415, z=-0.000249}
								}
								,{
									position	= {x=5.304405, y=1.933875, z=-0.437499}
									,rotation	= {x=0.000764, y=269.994446, z=-0.000303}
								}
								,{
									position	= {x=1.515536, y=1.933830, z=-1.749991}
									,rotation	= {x=0.000812, y=269.994263, z=-0.000261}
								}
								,{
									position	= {x=1.515543, y=1.933842, z=-4.374999}
									,rotation	= {x=0.000797, y=269.994446, z=-0.000266}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Bear Trap"
							,tile	= {
								{
									position	= {x=-6.062179, y=1.933907, z=3.500000}
									,rotation	= {x=-0.000767, y=89.992317, z=0.000264}
								}
								,{
									position	= {x=-4.546633, y=1.933915, z=6.125000}
									,rotation	= {x=-0.000768, y=89.992279, z=0.000263}
								}
								,{
									position	= {x=0.000003, y=2.049984, z=3.500003}
									,rotation	= {x=-0.000525, y=89.992210, z=0.000425}
								}
								,{
									position	= {x=3.788860, y=1.934019, z=7.437501}
									,rotation	= {x=-0.000768, y=89.992279, z=0.000256}
								}
								,{
									position	= {x=5.304407, y=1.934062, z=2.187498}
									,rotation	= {x=-0.000773, y=89.992279, z=0.000252}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Stone Pillar"
							,tile	= {
								{
									position	= {x=-3.788865, y=1.931059, z=-3.062502}
									,rotation	= {x=-0.000765, y=89.900368, z=0.000268}
								}
								,{
									position	= {x=2.273315, y=1.931141, z=-3.062499}
									,rotation	= {x=-0.000769, y=89.900322, z=0.000254}
								}
							}
						}
						,{
							name	= "Wall Section"
							,tile	= {
								{
									position	= {x=-5.304407, y=2.049736, z=-0.437502}
									,rotation	= {x=0.000873, y=269.997345, z=0.000043}
								}
								,{
									position	= {x=-3.788941, y=2.049756, z=-0.435606}
									,rotation	= {x=-0.000743, y=90.049538, z=-0.000156}
								}
								,{
									position	= {x=2.284055, y=2.049835, z=-0.438053}
									,rotation	= {x=0.000836, y=270.001526, z=-0.000281}
								}
								,{
									position	= {x=3.788867, y=2.049855, z=-0.437916}
									,rotation	= {x=-0.000762, y=90.068260, z=0.000302}
								}
								,{
									position	= {x=-5.304395, y=1.933743, z=-3.062496}
									,rotation	= {x=0.000767, y=270.025208, z=-0.000270}
								}
								,{
									position	= {x=3.788859, y=1.933866, z=-3.062171}
									,rotation	= {x=-0.000768, y=90.025284, z=0.000262}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=-0.757772, y=1.817795, z=-0.437500}
									,rotation	= {x=0.000653, y=270.000793, z=179.999786}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=5.304407, y=1.931193, z=-5.687501}
									,rotation	= {x=-0.000769, y=89.999954, z=0.000252}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "2"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 37
			,[37] = {
				--Traps
				{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Spike Trap"
							,tile	= {
								{
									position	= {x=9.093269, y=1.931800, z=4.375003}
									,rotation	= {x=-0.000578, y=150.008652, z=-0.000553}
								}
								,{
									position	= {x=11.366585, y=1.931835, z=3.062502}
									,rotation	= {x=-0.000582, y=150.008667, z=-0.000555}
								}
								,{
									position	= {x=11.366583, y=1.931846, z=0.437500}
									,rotation	= {x=-0.000582, y=150.008560, z=-0.000555}
								}
								,{
									position	= {x=12.882129, y=1.931866, z=0.437501}
									,rotation	= {x=-0.000581, y=150.008530, z=-0.000556}
								}
								,{
									position	= {x=13.639900, y=1.931881, z=-0.875000}
									,rotation	= {x=-0.000580, y=150.008591, z=-0.000556}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Stalagmites"
							,tile	= {
								{
									position	= {x=-3.031090, y=1.934576, z=-3.500000}
									,rotation	= {x=-0.000753, y=90.011818, z=0.000239}
								}
								,{
									position	= {x=2.273316, y=1.934629, z=0.437500}
									,rotation	= {x=-0.000752, y=90.011917, z=0.000243}
								}
								,{
									position	= {x=9.851035, y=1.934710, z=5.687500}
									,rotation	= {x=-0.000769, y=90.011856, z=0.000227}
								}
								,{
									position	= {x=10.608810, y=1.937330, z=12.250000}
									,rotation	= {x=-0.000774, y=90.011887, z=0.000255}
								}
								,{
									position	= {x=8.335494, y=1.937282, z=16.187500}
									,rotation	= {x=-0.000779, y=90.011887, z=0.000253}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Dark Fog"
							,tile	= {
								{
									position	= {x=9.851037, y=1.937635, z=8.312181}
									,rotation	= {x=0.000697, y=270.011658, z=0.154303}
								}
								,{
									position	= {x=4.546632, y=1.935264, z=-0.874690}
									,rotation	= {x=0.000720, y=270.011719, z=-0.000246}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=14.397672, y=1.931886, z=0.437501}
									,rotation	= {x=-0.000770, y=90.000076, z=0.000222}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "49"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 38
			,[38] = {
				--Traps
				{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Bear Trap"
							,tile	= {
								{
									position	= {x=7.000000, y=1.934682, z=3.031089}
									,rotation	= {x=0.000255, y=359.989471, z=0.000771}
								}
								,{
									position	= {x=8.312500, y=1.934696, z=3.788861}
									,rotation	= {x=0.000253, y=359.989502, z=0.000768}
								}
								,{
									position	= {x=9.625000, y=1.934717, z=3.031089}
									,rotation	= {x=0.000254, y=359.989471, z=0.000771}
								}
								,{
									position	= {x=6.999998, y=1.934116, z=-4.546633}
									,rotation	= {x=0.000247, y=359.989502, z=0.000768}
								}
								,{
									position	= {x=8.312500, y=1.934136, z=-5.304406}
									,rotation	= {x=0.000250, y=359.989471, z=0.000771}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Stump"
							,tile	= {
								{
									position	= {x=5.687500, y=1.931749, z=5.304406}
									,rotation	= {x=0.000255, y=0.011588, z=0.000768}
								}
								,{
									position	= {x=10.937500, y=1.931813, z=6.819950}
									,rotation	= {x=0.000252, y=0.011589, z=0.000768}
								}
								,{
									position	= {x=-3.499999, y=1.931649, z=0.000001}
									,rotation	= {x=0.000262, y=0.011590, z=0.000771}
								}
								,{
									position	= {x=3.062500, y=1.931748, z=-2.273317}
									,rotation	= {x=0.000248, y=0.011589, z=0.000771}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "LIght Fog"
							,tile	= {
								{
									position	= {x=9.625033, y=1.934900, z=16.670977}
									,rotation	= {x=0.004942, y=179.999863, z=0.014218}
								}
								,{
									position	= {x=8.312461, y=1.935187, z=11.366613}
									,rotation	= {x=359.989563, y=179.999878, z=-0.004778}
								}
								,{
									position	= {x=8.312483, y=1.935184, z=2.273277}
									,rotation	= {x=0.021537, y=180.000000, z=0.006005}
								}
								,{
									position	= {x=-0.875030, y=1.935203, z=-3.031078}
									,rotation	= {x=-0.000255, y=179.999802, z=-0.000755}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=7.000000, y=1.931224, z=-7.577723}
									,rotation	= {x=-0.000250, y=180.000656, z=-0.000774}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "29"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=7.000000, y=1.875422, z=-6.062177}
									,rotation	= {x=-0.000255, y=179.999451, z=-0.000772}
								}
								,{
									position	= {x=8.312500, y=1.875443, z=-6.819950}
									,rotation	= {x=-0.000264, y=179.999435, z=-0.000775}
								}
							}
						}
					}
				}
			}
			--Scenario 39
			,[39] = {
				--Corridors
				{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Stone Corridor 1"
							,tile	= {
								{
									position	= {x=-3.031082, y=1.817750, z=2.625006}
									,rotation	= {x=0.000600, y=329.998169, z=180.000534}
								}
							}
						}
						,{
							name	= "Stone Corridor 2"
							,tile	= {
								{
									position	= {x=-3.031098, y=1.933762, z=0.000024}
									,rotation	= {x=0.000595, y=330.011200, z=0.000527}
								}
								,{
									position	= {x=-0.757773, y=1.933787, z=1.312524}
									,rotation	= {x=0.000766, y=270.027466, z=-0.000290}
								}
								,{
									position	= {x=2.273316, y=1.933828, z=1.312506}
									,rotation	= {x=0.000763, y=270.005249, z=-0.000276}
								}
								,{
									position	= {x=3.788821, y=1.933848, z=1.312491}
									,rotation	= {x=0.000174, y=210.014999, z=-0.000780}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Spike Trap"
							,tile	= {
								{
									position	= {x=2.273296, y=1.931111, z=3.937508}
									,rotation	= {x=-0.000597, y=149.988510, z=-0.000542}
								}
								,{
									position	= {x=0.000000, y=1.931086, z=2.625003}
									,rotation	= {x=-0.000597, y=149.987244, z=-0.000544}
								}
								,{
									position	= {x=-0.000003, y=1.931098, z=0.000016}
									,rotation	= {x=-0.000601, y=149.987305, z=-0.000544}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Boulder"
							,tile	= {
								{
									position	= {x=1.494496, y=1.931094, z=5.259554}
									,rotation	= {x=-0.000770, y=90.011879, z=0.000245}
								}
								,{
									position	= {x=-1.515546, y=1.931066, z=2.625001}
									,rotation	= {x=-0.000767, y=90.011879, z=0.000248}
								}
								,{
									position	= {x=2.273324, y=2.047124, z=1.312503}
									,rotation	= {x=-0.000559, y=90.011971, z=0.000211}
								}
							}
						}
						,{
							name	= "Dark Pit"
							,tile	= {
								{
									position	= {x=-4.546630, y=1.933730, z=2.625000}
									,rotation	= {x=-0.000173, y=30.013136, z=0.000794}
								}
								,{
									position	= {x=-3.788884, y=2.049806, z=1.312486}
									,rotation	= {x=-0.004079, y=30.013403, z=0.000317}
								}
								,{
									position	= {x=-3.031090, y=2.049763, z=0.000002}
									,rotation	= {x=-0.000157, y=30.013077, z=0.000804}
								}
								,{
									position	= {x=4.550969, y=1.933852, z=2.617200}
									,rotation	= {x=0.000597, y=330.003052, z=0.000541}
								}
								,{
									position	= {x=6.062177, y=1.933872, z=2.625001}
									,rotation	= {x=0.000599, y=330.003143, z=0.000547}
								}
								,{
									position	= {x=3.030985, y=2.049845, z=0.000032}
									,rotation	= {x=-0.000126, y=30.032902, z=0.000772}
								}
							}
						}
						,{
							name	= "Altar Vertical"
							,tile	= {
								{
									position	= {x=-0.000001, y=1.931616, z=18.375000}
									,rotation	= {x=-0.000768, y=89.999802, z=0.000241}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Dark Fog"
							,tile	= {
								{
									position	= {x=-2.273335, y=1.935048, z=11.812444}
									,rotation	= {x=0.007465, y=270.006042, z=0.021618}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=6.062178, y=1.931133, z=10.499999}
									,rotation	= {x=-0.000766, y=90.000015, z=0.000249}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "73"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 40
			,[40] = {
				--Corridors
				{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Pressure Plate"
							,tile	= {
								{
									position	= {x=-5.304438, y=1.933896, z=7.405479}
									,rotation	= {x=-0.000766, y=90.017426, z=0.000250}
								}
								,{
									position	= {x=14.397673, y=1.934456, z=7.437500}
									,rotation	= {x=-0.000694, y=90.017342, z=0.000225}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Poison Gas"
							,tile	= {
								{
									position	= {x=1.515545, y=1.931678, z=8.750000}
									,rotation	= {x=-0.000770, y=89.988152, z=0.000251}
								}
								,{
									position	= {x=2.273317, y=1.931683, z=10.062500}
									,rotation	= {x=-0.000773, y=89.988113, z=0.000247}
								}
								,{
									position	= {x=7.577722, y=1.931748, z=11.375000}
									,rotation	= {x=-0.000770, y=89.988152, z=0.000249}
								}
								,{
									position	= {x=6.062175, y=1.931751, z=6.125000}
									,rotation	= {x=-0.000772, y=89.988129, z=0.000251}
								}
							}
						}
						,{
							name	= "Spike Trap"
							,tile	= {
								{
									position	= {x=-3.788952, y=1.931038, z=-0.467763}
									,rotation	= {x=-0.000829, y=90.023529, z=0.000648}
								}
								,{
									position	= {x=-4.546633, y=1.931041, z=-1.750000}
									,rotation	= {x=-0.000828, y=90.023552, z=0.000650}
								}
								,{
									position	= {x=-5.304405, y=1.931045, z=-3.062501}
									,rotation	= {x=-0.000827, y=90.023529, z=0.000651}
								}
								,{
									position	= {x=3.031089, y=1.934397, z=-4.375000}
									,rotation	= {x=-0.000763, y=90.023537, z=0.000248}
								}
								,{
									position	= {x=2.273316, y=1.934393, z=-5.687500}
									,rotation	= {x=-0.000763, y=90.023453, z=0.000250}
								}
								,{
									position	= {x=1.515546, y=1.934388, z=-7.000000}
									,rotation	= {x=-0.000760, y=90.023453, z=0.000253}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Nest"
							,tile	= {
								{
									position	= {x=4.546633, y=1.934406, z=-1.750000}
									,rotation	= {x=-0.000760, y=90.011856, z=0.000248}
								}
								,{
									position	= {x=4.546628, y=1.934417, z=-4.375001}
									,rotation	= {x=-0.000759, y=90.011887, z=0.000252}
								}
								,{
									position	= {x=8.335492, y=1.934462, z=-3.062499}
									,rotation	= {x=-0.000760, y=90.012001, z=0.000254}
								}
								,{
									position	= {x=6.819950, y=1.934453, z=-5.687500}
									,rotation	= {x=-0.000766, y=90.011887, z=0.000250}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=-4.546633, y=1.817730, z=0.875000}
									,rotation	= {x=0.001142, y=270.000671, z=180.000839}
								}
								,{
									position	= {x=-1.515486, y=1.820714, z=-4.375014}
									,rotation	= {x=0.000138, y=210.002335, z=179.807526}
								}
								,{
									position	= {x=4.546637, y=1.820787, z=3.500015}
									,rotation	= {x=-0.000742, y=89.996597, z=180.154999}
								}
								,{
									position	= {x=4.546633, y=1.818401, z=14.000015}
									,rotation	= {x=0.000760, y=270.289886, z=179.999741}
								}
								,{
									position	= {x=9.093095, y=1.838075, z=16.625584}
									,rotation	= {x=0.741772, y=30.040640, z=181.297684}
								}
								,{
									position	= {x=11.366579, y=1.935914, z=10.062478}
									,rotation	= {x=-0.002119, y=89.999435, z=172.190033}
								}
							}
						}
					}
				}
				--Hazardous Terrain
				,{
					bag	 	= Bag_HazardousTerrain_GUID
					,type	= {
						{
							name	= "Hot Coals 1"
							,tile	= {
								{
									position	= {x=10.608810, y=1.954288, z=16.626913}
									,rotation	= {x=-0.000482, y=89.991455, z=0.857278}
								}
								,{
									position	= {x=12.124355, y=1.954333, z=16.624994}
									,rotation	= {x=-0.000481, y=89.991440, z=0.857274}
								}
								,{
									position	= {x=9.851039, y=1.973949, z=15.312494}
									,rotation	= {x=-0.000480, y=89.991440, z=0.857274}
								}
								,{
									position	= {x=11.366583, y=1.973965, z=15.312493}
									,rotation	= {x=-0.000481, y=89.991440, z=0.857273}
								}
								,{
									position	= {x=12.877614, y=1.973981, z=15.312493}
									,rotation	= {x=-0.002880, y=90.151680, z=0.857269}
								}
								,{
									position	= {x=14.396807, y=1.973997, z=15.312576}
									,rotation	= {x=-0.000789, y=90.012039, z=0.857273}
								}
								,{
									position	= {x=10.608810, y=1.993598, z=13.999995}
									,rotation	= {x=-0.000479, y=89.991440, z=0.857275}
								}
								,{
									position	= {x=12.124355, y=1.993613, z=13.999995}
									,rotation	= {x=-0.000482, y=89.991440, z=0.857275}
								}
								,{
									position	= {x=9.851039, y=2.013229, z=12.687495}
									,rotation	= {x=-0.000481, y=89.991440, z=0.857275}
								}
								,{
									position	= {x=11.366583, y=2.013246, z=12.687495}
									,rotation	= {x=-0.000482, y=89.991440, z=0.857275}
								}
								,{
									position	= {x=10.608810, y=2.032878, z=11.374995}
									,rotation	= {x=-0.000480, y=89.991440, z=0.857275}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=15.913217, y=1.931569, z=7.437498}
									,rotation	= {x=-0.000690, y=90.000069, z=0.000229}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "47"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=-6.819951, y=1.875165, z=10.062529}
									,rotation	= {x=-0.000249, y=179.999298, z=-0.000771}
								}
								,{
									position	= {x=-5.304405, y=1.875185, z=10.062501}
									,rotation	= {x=-0.000244, y=179.999603, z=-0.000780}
								}
								,{
									position	= {x=-3.788844, y=1.875205, z=10.062503}
									,rotation	= {x=-0.000243, y=179.998947, z=-0.000769}
								}
								,{
									position	= {x=-7.577722, y=1.875160, z=8.750001}
									,rotation	= {x=-0.000242, y=179.999496, z=-0.000775}
								}
								,{
									position	= {x=-6.062178, y=1.875181, z=8.750002}
									,rotation	= {x=-0.000254, y=179.999268, z=-0.000762}
								}
								,{
									position	= {x=-4.546630, y=1.875201, z=8.750001}
									,rotation	= {x=-0.000242, y=179.999084, z=-0.000761}
								}
								,{
									position	= {x=-3.031084, y=1.875221, z=8.750000}
									,rotation	= {x=-0.000239, y=179.999435, z=-0.000750}
								}
								,{
									position	= {x=12.882128, y=1.875737, z=7.437500}
									,rotation	= {x=-0.000228, y=179.999481, z=-0.000681}
								}
								,{
									position	= {x=15.155444, y=1.875759, z=8.749999}
									,rotation	= {x=-0.000227, y=179.999451, z=-0.000688}
								}
							}
						}
					}
				}
			}
			--Scenario 41
			,[41] = {
				--Corridors
				{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Pressure Plate"
							,tile	= {
								{
									position	= {x=0.000006, y=1.933974, z=6.061301}
									,rotation	= {x=0.000252, y=-0.001124, z=0.000770}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Poison Gas"
							,tile	= {
								{
									position	= {x=0.000000, y=1.931063, z=7.577723}
									,rotation	= {x=0.000248, y=0.011600, z=0.000768}
								}
								,{
									position	= {x=1.312500, y=1.931084, z=6.819950}
									,rotation	= {x=0.000250, y=0.011611, z=0.000767}
								}
								,{
									position	= {x=1.312500, y=1.931090, z=5.304405}
									,rotation	= {x=0.000254, y=0.011612, z=0.000770}
								}
								,{
									position	= {x=0.000000, y=1.931076, z=4.546633}
									,rotation	= {x=0.000249, y=0.011612, z=0.000767}
								}
								,{
									position	= {x=-1.312500, y=1.931055, z=5.304405}
									,rotation	= {x=0.000252, y=0.011613, z=0.000768}
								}
								,{
									position	= {x=-1.312502, y=1.931049, z=6.819951}
									,rotation	= {x=0.000247, y=0.011616, z=0.000765}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Sarcophagus A"
							,tile	= {
								{
									position	= {x=0.000001, y=1.934422, z=-4.546633}
									,rotation	= {x=0.000250, y=0.032018, z=0.000770}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Vertical"
							,tile	= {
								{
									position	= {x=0.000000, y=1.817669, z=9.093325}
									,rotation	= {x=0.226373, y=0.009527, z=180.000717}
								}
								,{
									position	= {x=-0.000002, y=1.818302, z=1.515523}
									,rotation	= {x=0.033253, y=0.010074, z=179.991089}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=-2.625000, y=1.927939, z=15.155444}
									,rotation	= {x=-0.000251, y=180.000671, z=-0.000766}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "24"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=2.625000, y=1.872215, z=15.155444}
									,rotation	= {x=-0.000251, y=179.999390, z=-0.000759}
								}
								,{
									position	= {x=-2.625007, y=1.875867, z=0.000008}
									,rotation	= {x=-0.000237, y=179.999420, z=-0.000767}
								}
								,{
									position	= {x=2.625001, y=1.875937, z=0.000001}
									,rotation	= {x=-0.000252, y=179.999344, z=-0.000744}
								}
								,{
									position	= {x=-2.625003, y=1.875893, z=-6.062180}
									,rotation	= {x=-0.000248, y=179.999222, z=-0.000773}
								}
								,{
									position	= {x=2.625004, y=1.875964, z=-6.062179}
									,rotation	= {x=-0.000245, y=179.999451, z=-0.000769}
								}
							}
						}
					}
				}
			}
			--Scenario 42
			,[42] = {
				--Corridors
				{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Stone Corridor 2"
							,tile	= {
								{
									position	= {x=-3.499950, y=1.934360, z=3.031083}
									,rotation	= {x=-0.001048, y=0.024633, z=359.972809}
								}
								,{
									position	= {x=6.999920, y=1.934485, z=3.031092}
									,rotation	= {x=0.000137, y=0.024608, z=0.012126}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Altar Horizontal"
							,tile	= {
								{
									position	= {x=-0.875002, y=1.931064, z=4.546634}
									,rotation	= {x=0.000250, y=0.000829, z=0.000764}
								}
								,{
									position	= {x=4.375000, y=1.931135, z=4.546633}
									,rotation	= {x=0.000252, y=0.000841, z=0.000766}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=-7.437499, y=1.931574, z=5.304406}
									,rotation	= {x=-0.000245, y=180.000748, z=-0.000770}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "30"
									}
								}
								,{
									position	= {x=10.937500, y=1.931820, z=5.304405}
									,rotation	= {x=-0.000248, y=180.000687, z=-0.000768}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "55"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 43
			,[43] = {
				--Traps
				{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Spike Trap"
							,tile	= {
								{
									position	= {x=0.000000, y=1.931043, z=12.124355}
									,rotation	= {x=0.000247, y=0.005266, z=0.000771}
								}
								,{
									position	= {x=1.312500, y=1.931064, z=11.366583}
									,rotation	= {x=0.000248, y=0.005266, z=0.000770}
								}
								,{
									position	= {x=2.625000, y=1.931079, z=12.124355}
									,rotation	= {x=0.000249, y=0.005306, z=0.000769}
								}
								,{
									position	= {x=-1.312503, y=1.931068, z=2.273317}
									,rotation	= {x=0.000252, y=0.005251, z=0.000770}
								}
								,{
									position	= {x=1.312500, y=1.931097, z=3.788861}
									,rotation	= {x=0.000248, y=0.005257, z=0.000771}
								}
								,{
									position	= {x=3.937500, y=1.931139, z=2.273316}
									,rotation	= {x=0.000249, y=0.005266, z=0.000771}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Boulder"
							,tile	= {
								{
									position	= {x=-2.625001, y=1.931008, z=12.124355}
									,rotation	= {x=-0.000250, y=179.989380, z=-0.000771}
								}
								,{
									position	= {x=1.312500, y=1.931071, z=9.851039}
									,rotation	= {x=-0.000254, y=179.989380, z=-0.000771}
								}
								,{
									position	= {x=5.250001, y=1.931134, z=7.577722}
									,rotation	= {x=-0.000250, y=179.989380, z=-0.000768}
								}
								,{
									position	= {x=-2.625010, y=1.931041, z=4.546639}
									,rotation	= {x=-0.000250, y=179.989380, z=-0.000770}
								}
								,{
									position	= {x=0.000000, y=1.931070, z=6.062178}
									,rotation	= {x=-0.000247, y=179.989380, z=-0.000767}
								}
								,{
									position	= {x=5.250001, y=1.931160, z=1.515544}
									,rotation	= {x=-0.000254, y=179.989380, z=-0.000771}
								}
							}
						}
						,{
							name	= "Nest"
							,tile	= {
								{
									position	= {x=-7.874994, y=1.930951, z=9.093260}
									,rotation	= {x=0.000245, y=-0.001159, z=0.000768}
								}
								,{
									position	= {x=-7.875000, y=1.930971, z=4.546633}
									,rotation	= {x=0.000247, y=-0.001161, z=0.000766}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Dark Fog"
							,tile	= {
								{
									position	= {x=1.312500, y=1.934333, z=12.882565}
									,rotation	= {x=359.783875, y=179.999390, z=-0.000805}
								}
								,{
									position	= {x=-3.937500, y=1.934499, z=11.366583}
									,rotation	= {x=-0.000249, y=179.999481, z=-0.000719}
								}
								,{
									position	= {x=6.562480, y=1.934904, z=9.851031}
									,rotation	= {x=0.002910, y=179.999573, z=359.990692}
								}
								,{
									position	= {x=-3.937500, y=1.934539, z=2.273316}
									,rotation	= {x=-0.000252, y=179.999481, z=-0.000729}
								}
								,{
									position	= {x=1.312498, y=1.934615, z=0.757773}
									,rotation	= {x=-0.000244, y=179.999481, z=-0.000766}
								}
								,{
									position	= {x=6.562480, y=1.934930, z=3.788854}
									,rotation	= {x=0.002919, y=179.999573, z=359.990723}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=1.312499, y=1.927975, z=18.944305}
									,rotation	= {x=-0.000262, y=180.000671, z=-0.000771}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "35"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=-1.312497, y=1.872166, z=14.397672}
									,rotation	= {x=-0.000267, y=179.999496, z=-0.000769}
								}
								,{
									position	= {x=3.937500, y=1.872236, z=14.397673}
									,rotation	= {x=-0.000263, y=179.999344, z=-0.000758}
								}
								,{
									position	= {x=-5.250000, y=1.875179, z=12.124355}
									,rotation	= {x=-0.000245, y=179.999405, z=-0.000771}
								}
								,{
									position	= {x=-7.875000, y=1.875163, z=7.577722}
									,rotation	= {x=-0.000238, y=179.999420, z=-0.000768}
								}
								,{
									position	= {x=-6.562500, y=1.875204, z=2.273316}
									,rotation	= {x=-0.000248, y=179.999405, z=-0.000763}
								}
							}
						}
					}
				}
			}
			--Scenario 44
			,[44] = {
				--Corridors
				{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Earth Corridor 1"
							,tile	= {
								{
									position	= {x=4.525891, y=1.818531, z=-1.751816}
									,rotation	= {x=359.961548, y=330.015137, z=180.011734}
								}
							}
						}
						,{
							name	= "Earth Corridor 2"
							,tile	= {
								{
									position	= {x=3.031092, y=1.934669, z=-1.749990}
									,rotation	= {x=-0.001567, y=269.990784, z=0.002155}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Bear Trap"
							,tile	= {
								{
									position	= {x=2.273317, y=1.934819, z=7.437500}
									,rotation	= {x=0.001563, y=90.005585, z=0.000433}
								}
								,{
									position	= {x=2.273319, y=1.934859, z=2.187500}
									,rotation	= {x=0.001562, y=90.005600, z=0.000431}
								}
								,{
									position	= {x=3.788861, y=1.934817, z=2.187500}
									,rotation	= {x=0.001562, y=90.005600, z=0.000433}
								}
								,{
									position	= {x=6.062178, y=1.934745, z=3.500000}
									,rotation	= {x=0.001566, y=90.005608, z=0.000434}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Bush 1"
							,tile	= {
								{
									position	= {x=-6.819955, y=1.930984, z=4.812500}
									,rotation	= {x=-0.000772, y=90.008537, z=0.000264}
								}
								,{
									position	= {x=-0.757769, y=1.932036, z=2.187499}
									,rotation	= {x=0.001565, y=90.008514, z=0.000433}
								}
								,{
									position	= {x=3.788862, y=1.931893, z=4.812500}
									,rotation	= {x=0.001565, y=90.008553, z=0.000433}
								}
							}
						}
						,{
							name	= "Cabinet"
							,tile	= {
								{
									position	= {x=-4.546633, y=1.933890, z=11.375000}
									,rotation	= {x=-0.000764, y=90.008537, z=0.000251}
								}
								,{
									position	= {x=4.546633, y=1.934012, z=11.374998}
									,rotation	= {x=-0.000768, y=90.008545, z=0.000250}
								}
							}
						}
						,{
							name	= "Table"
							,tile	= {
								{
									position	= {x=0.757681, y=1.933756, z=12.687551}
									,rotation	= {x=-0.000172, y=30.000616, z=0.000788}
								}
							}
						}
						,{
							name	= "Tree"
							,tile	= {
								{
									position	= {x=-6.819601, y=1.931691, z=-0.448140}
									,rotation	= {x=0.000767, y=269.988342, z=-0.000265}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "LIght Fog"
							,tile	= {
								{
									position	= {x=-1.513993, y=1.935407, z=3.479319}
									,rotation	= {x=359.948547, y=90.009033, z=359.985779}
								}
							}
						}
						,{
							name	= "Wooden Door Horizontal"
							,tile	= {
								{
									position	= {x=-6.062177, y=1.817681, z=8.750001}
									,rotation	= {x=0.000763, y=270.018250, z=179.999802}
								}
								,{
									position	= {x=3.031089, y=1.818474, z=8.750001}
									,rotation	= {x=0.004746, y=270.018311, z=179.964493}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=-6.062178, y=1.875159, z=14.000016}
									,rotation	= {x=-0.000252, y=179.999619, z=-0.000756}
								}
								,{
									position	= {x=-3.788860, y=1.875195, z=12.687500}
									,rotation	= {x=-0.000247, y=179.999374, z=-0.000754}
								}
								,{
									position	= {x=4.546635, y=1.875301, z=14.000006}
									,rotation	= {x=-0.000251, y=179.999329, z=-0.000770}
								}
							}
						}
					}
				}
			}
			--Scenario 45
			,[45] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Log"
							,tile	= {
								{
									position	= {x=-1.515549, y=1.932775, z=17.500011}
									,rotation	= {x=-0.002739, y=209.984238, z=359.994080}
								}
								,{
									position	= {x=-0.000004, y=1.934613, z=4.374999}
									,rotation	= {x=0.001822, y=209.984238, z=-0.000191}
								}
								,{
									position	= {x=9.851140, y=1.933909, z=5.687564}
									,rotation	= {x=-0.000597, y=150.000626, z=-0.000541}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Poison Gas"
							,tile	= {
								{
									position	= {x=-0.000001, y=1.931976, z=6.999996}
									,rotation	= {x=-0.001073, y=89.991493, z=-0.001485}
								}
								,{
									position	= {x=-3.031088, y=1.931784, z=1.749997}
									,rotation	= {x=-0.001077, y=89.991463, z=-0.001485}
								}
								,{
									position	= {x=-2.273317, y=1.931687, z=-4.812498}
									,rotation	= {x=-0.000767, y=89.991478, z=0.000244}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Stump"
							,tile	= {
								{
									position	= {x=-3.031094, y=1.930460, z=12.250014}
									,rotation	= {x=-0.003762, y=89.918785, z=0.005345}
								}
								,{
									position	= {x=-3.031089, y=1.931920, z=6.999999}
									,rotation	= {x=-0.001075, y=89.918762, z=-0.001480}
								}
								,{
									position	= {x=-2.257190, y=1.931763, z=0.403988}
									,rotation	= {x=-0.001080, y=89.918800, z=-0.001485}
								}
							}
						}
						,{
							name	= "Totem"
							,tile	= {
								{
									position	= {x=-3.788867, y=1.929799, z=18.812511}
									,rotation	= {x=-0.003768, y=89.988266, z=0.005339}
								}
								,{
									position	= {x=-3.788867, y=1.930533, z=10.937510}
									,rotation	= {x=-0.003767, y=89.988266, z=0.005338}
								}
								,{
									position	= {x=-5.304406, y=1.931843, z=5.687496}
									,rotation	= {x=-0.001074, y=89.988289, z=-0.001486}
								}
								,{
									position	= {x=0.757794, y=1.931821, z=0.437497}
									,rotation	= {x=-0.001075, y=89.988556, z=-0.001486}
								}
								,{
									position	= {x=5.304405, y=1.931154, z=3.062499}
									,rotation	= {x=-0.000763, y=89.988266, z=0.000249}
								}
								,{
									position	= {x=-3.788866, y=1.931678, z=-7.437498}
									,rotation	= {x=-0.000762, y=89.988266, z=0.000245}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "LIght Fog"
							,tile	= {
								{
									position	= {x=-1.515546, y=1.935526, z=9.625113}
									,rotation	= {x=0.001953, y=269.991638, z=359.947906}
								}
								,{
									position	= {x=3.031167, y=1.935336, z=4.374917}
									,rotation	= {x=359.953583, y=269.992096, z=359.987579}
								}
								,{
									position	= {x=-3.031085, y=1.935206, z=-0.875107}
									,rotation	= {x=0.001612, y=269.990967, z=0.005075}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=-0.757778, y=1.929753, z=21.437510}
									,rotation	= {x=-0.003769, y=90.000015, z=0.005339}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "74"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=0.000001, y=1.875928, z=-6.125000}
									,rotation	= {x=-0.000244, y=179.999329, z=-0.000770}
								}
								,{
									position	= {x=-0.757775, y=1.875923, z=-7.437501}
									,rotation	= {x=-0.000245, y=179.999374, z=-0.000758}
								}
							}
						}
					}
				}
			}
			--Scenario 46
			,[46] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Rubble"
							,tile	= {
								{
									position	= {x=-7.577724, y=1.931575, z=4.374999}
									,rotation	= {x=-0.000773, y=90.008522, z=0.000243}
								}
								,{
									position	= {x=-6.819950, y=1.931591, z=3.062500}
									,rotation	= {x=-0.000772, y=90.008499, z=0.000248}
								}
								,{
									position	= {x=-5.304405, y=1.931612, z=3.062500}
									,rotation	= {x=-0.000769, y=90.008522, z=0.000248}
								}
								,{
									position	= {x=0.757772, y=1.934333, z=3.062500}
									,rotation	= {x=-0.000765, y=90.008514, z=0.000256}
								}
								,{
									position	= {x=1.515544, y=1.934349, z=1.750000}
									,rotation	= {x=-0.000765, y=90.008522, z=0.000259}
								}
								,{
									position	= {x=6.819950, y=1.934414, z=3.062500}
									,rotation	= {x=-0.000771, y=90.008522, z=0.000255}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Spike Trap"
							,tile	= {
								{
									position	= {x=-6.062181, y=1.931596, z=4.375000}
									,rotation	= {x=-0.000771, y=89.991562, z=0.000250}
								}
								,{
									position	= {x=-6.062178, y=1.931619, z=-0.875000}
									,rotation	= {x=-0.000771, y=89.991440, z=0.000250}
								}
								,{
									position	= {x=-4.546633, y=1.931639, z=-0.875000}
									,rotation	= {x=-0.000771, y=89.991554, z=0.000248}
								}
								,{
									position	= {x=3.031089, y=1.934345, z=7.000001}
									,rotation	= {x=-0.000767, y=89.991554, z=0.000261}
								}
								,{
									position	= {x=3.031089, y=1.934357, z=4.375000}
									,rotation	= {x=-0.000770, y=89.991554, z=0.000256}
								}
								,{
									position	= {x=5.304405, y=1.934382, z=5.687500}
									,rotation	= {x=-0.000768, y=89.991554, z=0.000257}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Boulder"
							,tile	= {
								{
									position	= {x=-5.304405, y=1.931600, z=5.687500}
									,rotation	= {x=-0.000766, y=90.005295, z=0.000249}
								}
								,{
									position	= {x=-6.819951, y=1.931603, z=0.437499}
									,rotation	= {x=-0.000772, y=90.005219, z=0.000246}
								}
								,{
									position	= {x=2.273317, y=1.934341, z=5.687500}
									,rotation	= {x=-0.000766, y=90.005295, z=0.000257}
								}
								,{
									position	= {x=4.546633, y=1.934378, z=4.375000}
									,rotation	= {x=-0.000766, y=90.005295, z=0.000260}
								}
								,{
									position	= {x=6.062175, y=1.931192, z=-3.500002}
									,rotation	= {x=-0.000766, y=90.005295, z=0.000251}
								}
								,{
									position	= {x=9.851039, y=1.931249, z=-4.812500}
									,rotation	= {x=-0.000768, y=90.005295, z=0.000250}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Dark Fog"
							,tile	= {
								{
									position	= {x=-2.273582, y=1.937507, z=0.437345}
									,rotation	= {x=-0.000334, y=149.991714, z=359.844879}
								}
								,{
									position	= {x=7.577720, y=1.937610, z=-0.874868}
									,rotation	= {x=-0.000660, y=89.998924, z=359.808136}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=-5.304404, y=1.931634, z=-2.187500}
									,rotation	= {x=-0.000769, y=89.999931, z=0.000248}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "48"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 47
			,[47] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Water 1"
							,tile	= {
								{
									position	= {x=-5.304405, y=1.931639, z=-3.062500}
									,rotation	= {x=0.000170, y=210.005280, z=-0.000784}
								}
								,{
									position	= {x=-3.031089, y=1.931675, z=-4.375000}
									,rotation	= {x=0.000166, y=210.005280, z=-0.000784}
								}
								,{
									position	= {x=-3.788861, y=1.931648, z=-0.437500}
									,rotation	= {x=0.000164, y=210.005280, z=-0.000788}
								}
								,{
									position	= {x=-3.031089, y=1.931664, z=-1.750000}
									,rotation	= {x=0.000170, y=210.005280, z=-0.000790}
								}
								,{
									position	= {x=-2.273317, y=1.931668, z=-0.437500}
									,rotation	= {x=0.000164, y=210.005295, z=-0.000789}
								}
								,{
									position	= {x=-1.515544, y=1.931673, z=0.875000}
									,rotation	= {x=0.000165, y=210.005280, z=-0.000788}
								}
								,{
									position	= {x=-1.515544, y=1.931684, z=-1.750000}
									,rotation	= {x=0.000166, y=210.005280, z=-0.000788}
								}
								,{
									position	= {x=0.757772, y=1.931709, z=-0.437500}
									,rotation	= {x=0.000165, y=210.005295, z=-0.000788}
								}
								,{
									position	= {x=1.515544, y=1.931713, z=0.875000}
									,rotation	= {x=0.000166, y=210.005280, z=-0.000789}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Vertical"
							,tile	= {
								{
									position	= {x=5.304404, y=1.818474, z=-0.437500}
									,rotation	= {x=-0.000732, y=89.959755, z=180.000259}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=12.124355, y=1.931878, z=-4.375003}
									,rotation	= {x=-0.000772, y=90.000061, z=0.000249}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "18"
									}
								}
								,{
									position	= {x=12.124357, y=1.931843, z=3.500003}
									,rotation	= {x=-0.000767, y=89.999886, z=0.000254}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "57"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 48
			,[48] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Log"
							,tile	= {
								{
									position	= {x=-6.062178, y=1.933719, z=0.000000}
									,rotation	= {x=0.000156, y=209.993439, z=-0.000803}
								}
								,{
									position	= {x=1.515541, y=2.049843, z=-5.250000}
									,rotation	= {x=0.000137, y=209.993439, z=-0.000757}
								}
							}
						}
					}
				}
				--Corridors
				,{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Earth Corridor 1"
							,tile	= {
								{
									position	= {x=0.000001, y=1.817800, z=-0.000004}
									,rotation	= {x=0.000621, y=330.017578, z=180.000519}
								}
								,{
									position	= {x=-0.000001, y=1.817812, z=-2.625003}
									,rotation	= {x=0.000592, y=330.017639, z=180.000504}
								}
							}
						}
						,{
							name	= "Earth Corridor 2"
							,tile	= {
								{
									position	= {x=0.757770, y=1.933804, z=1.312496}
									,rotation	= {x=0.000771, y=269.994385, z=-0.000260}
								}
								,{
									position	= {x=0.757774, y=1.933816, z=-1.312505}
									,rotation	= {x=0.000757, y=269.994476, z=-0.000252}
								}
								,{
									position	= {x=2.273315, y=1.933836, z=-1.312502}
									,rotation	= {x=0.000163, y=209.987244, z=-0.000787}
								}
								,{
									position	= {x=0.757773, y=1.933828, z=-3.937501}
									,rotation	= {x=0.000735, y=269.994385, z=-0.000255}
								}
								,{
									position	= {x=1.515544, y=1.933844, z=-5.250003}
									,rotation	= {x=0.000734, y=269.994446, z=-0.000277}
								}
								,{
									position	= {x=0.757773, y=1.933839, z=-6.562497}
									,rotation	= {x=0.000723, y=269.994537, z=-0.000254}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Bush 1"
							,tile	= {
								{
									position	= {x=-2.286766, y=1.931058, z=1.338660}
									,rotation	= {x=-0.000773, y=90.071869, z=0.000263}
								}
								,{
									position	= {x=6.062178, y=1.931177, z=0.000000}
									,rotation	= {x=-0.000772, y=90.071869, z=0.000254}
								}
								,{
									position	= {x=4.546633, y=1.931180, z=-5.250000}
									,rotation	= {x=-0.000773, y=90.071869, z=0.000252}
								}
							}
						}
						,{
							name	= "Tree"
							,tile	= {
								{
									position	= {x=-3.031091, y=1.931761, z=-5.250001}
									,rotation	= {x=0.000773, y=270.012360, z=-0.000264}
								}
								,{
									position	= {x=0.757769, y=2.047794, z=-1.312500}
									,rotation	= {x=-0.000768, y=89.979813, z=0.000254}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=6.819951, y=1.931181, z=1.312498}
									,rotation	= {x=-0.000768, y=90.000046, z=0.000254}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "64"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 49
			,[49] = {
				--Corridors
				{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Earth Corridor 1"
							,tile	= {
								{
									position	= {x=-2.625000, y=1.817765, z=0.000000}
									,rotation	= {x=0.000258, y=-0.000192, z=180.000778}
								}
								,{
									position	= {x=-0.000001, y=1.817800, z=0.000001}
									,rotation	= {x=0.000250, y=-0.000170, z=180.000778}
								}
								,{
									position	= {x=2.625000, y=1.817836, z=0.000000}
									,rotation	= {x=0.000238, y=-0.000185, z=180.000778}
								}
							}
						}
						,{
							name	= "Earth Corridor 2"
							,tile	= {
								{
									position	= {x=-3.937500, y=1.933751, z=-0.757772}
									,rotation	= {x=0.000257, y=0.026242, z=0.000774}
								}
								,{
									position	= {x=-1.312499, y=1.933786, z=-0.757772}
									,rotation	= {x=0.000251, y=0.026233, z=0.000764}
								}
								,{
									position	= {x=1.312501, y=1.933821, z=-0.757772}
									,rotation	= {x=0.000246, y=0.026235, z=0.000776}
								}
								,{
									position	= {x=3.937501, y=1.933856, z=-0.757773}
									,rotation	= {x=0.000237, y=0.026252, z=0.000780}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Stump"
							,tile	= {
								{
									position	= {x=-2.624999, y=1.931033, z=6.062178}
									,rotation	= {x=0.000250, y=0.011587, z=0.000774}
								}
								,{
									position	= {x=2.625001, y=1.931111, z=4.546633}
									,rotation	= {x=0.000248, y=0.011587, z=0.000774}
								}
								,{
									position	= {x=-3.937502, y=2.047038, z=0.757773}
									,rotation	= {x=0.000339, y=0.011588, z=0.001194}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "LIght Fog"
							,tile	= {
								{
									position	= {x=0.000000, y=1.934568, z=7.577722}
									,rotation	= {x=-0.000196, y=179.999954, z=-0.000750}
								}
							}
						}
					}
				}
				--Hazardous Terrain
				,{
					bag	 	= Bag_HazardousTerrain_GUID
					,type	= {
						{
							name	= "Thorns"
							,tile	= {
								{
									position	= {x=-2.625000, y=1.931040, z=4.546633}
									,rotation	= {x=0.000245, y=0.000269, z=0.000774}
								}
								,{
									position	= {x=2.625000, y=1.931104, z=6.062178}
									,rotation	= {x=0.000248, y=0.000269, z=0.000774}
								}
								,{
									position	= {x=-3.937500, y=1.931065, z=-5.304405}
									,rotation	= {x=0.000250, y=0.000270, z=0.000769}
								}
								,{
									position	= {x=3.937500, y=1.931158, z=-2.273317}
									,rotation	= {x=0.000248, y=0.000269, z=0.000769}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=-3.937500, y=1.931072, z=-6.819950}
									,rotation	= {x=-0.000251, y=180.000641, z=-0.000773}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "44"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 50
			,[50] = {
				--Corridors
				{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Man Stone Corridor 2"
							,tile	= {
								{
									position	= {x=10.500000, y=1.933910, z=7.577722}
									,rotation	= {x=0.000249, y=0.033288, z=0.000773}
								}
								,{
									position	= {x=10.500000, y=1.933942, z=0.000002}
									,rotation	= {x=0.000247, y=0.033302, z=0.000735}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Bear Trap"
							,tile	= {
								{
									position	= {x=1.312500, y=1.933996, z=5.304405}
									,rotation	= {x=0.000247, y=0.000289, z=0.000772}
								}
								,{
									position	= {x=1.312498, y=1.934002, z=3.788846}
									,rotation	= {x=0.000247, y=0.000289, z=0.000771}
								}
								,{
									position	= {x=9.187500, y=1.934088, z=8.335495}
									,rotation	= {x=0.000243, y=0.000284, z=0.000766}
								}
								,{
									position	= {x=9.187500, y=1.934121, z=0.757770}
									,rotation	= {x=0.000248, y=0.000294, z=0.000769}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Stone Pillar"
							,tile	= {
								{
									position	= {x=3.937500, y=1.931120, z=6.819952}
									,rotation	= {x=0.000246, y=0.023925, z=0.000771}
								}
								,{
									position	= {x=3.937500, y=1.931139, z=2.273317}
									,rotation	= {x=0.000246, y=0.023850, z=0.000771}
								}
								,{
									position	= {x=7.875000, y=1.931169, z=7.577722}
									,rotation	= {x=0.000246, y=0.023849, z=0.000772}
								}
								,{
									position	= {x=7.875000, y=1.931195, z=1.515542}
									,rotation	= {x=0.000248, y=0.023861, z=0.000771}
								}
								,{
									position	= {x=11.812500, y=1.931219, z=8.335494}
									,rotation	= {x=0.000247, y=0.023849, z=0.000766}
								}
								,{
									position	= {x=11.812500, y=1.931251, z=0.757772}
									,rotation	= {x=0.000255, y=0.023848, z=0.000772}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=0.000000, y=1.817781, z=4.546633}
									,rotation	= {x=-0.000255, y=179.991730, z=179.999222}
								}
							}
						}
						,{
							name	= "Stone Door Vertical"
							,tile	= {
								{
									position	= {x=5.250000, y=1.817825, z=10.608813}
									,rotation	= {x=-0.000294, y=179.990753, z=179.999237}
								}
								,{
									position	= {x=5.250000, y=1.817878, z=-1.515544}
									,rotation	= {x=0.000214, y=359.917603, z=180.000778}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=-6.562500, y=1.930972, z=8.335494}
									,rotation	= {x=-0.000243, y=180.000671, z=-0.000768}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=-6.562500, y=1.931004, z=0.757772}
									,rotation	= {x=-0.000249, y=180.000656, z=-0.000774}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=15.750000, y=1.931268, z=9.093266}
									,rotation	= {x=-0.000252, y=180.000671, z=-0.000767}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=15.749999, y=1.931307, z=0.000000}
									,rotation	= {x=-0.000253, y=180.000656, z=-0.000770}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 51
			,[51] = {
				--Corridors
				{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Man Stone Corridor 1"
							,tile	= {
								{
									position	= {x=-2.187500, y=1.818382, z=-2.273315}
									,rotation	= {x=0.000248, y=0.012517, z=180.000778}
								}
							}
						}
						,{
							name	= "Man Stone Corridor 2"
							,tile	= {
								{
									position	= {x=-2.187508, y=1.934369, z=0.757765}
									,rotation	= {x=0.000791, y=299.993103, z=0.000147}
								}
								,{
									position	= {x=1.750000, y=1.934418, z=1.515544}
									,rotation	= {x=0.000805, y=299.994385, z=0.000159}
								}
								,{
									position	= {x=0.425801, y=1.934403, z=0.763944}
									,rotation	= {x=0.000512, y=239.755081, z=-0.000620}
								}
								,{
									position	= {x=-0.875002, y=1.934403, z=-3.031090}
									,rotation	= {x=0.000248, y=0.013168, z=0.000709}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Altar Horizontal"
							,tile	= {
								{
									position	= {x=-2.187496, y=2.047649, z=0.757776}
									,rotation	= {x=0.000166, y=299.990448, z=-0.000965}
								}
							}
						}
						,{
							name	= "Dark Pit"
							,tile	= {
								{
									position	= {x=0.437497, y=2.050404, z=0.757774}
									,rotation	= {x=0.000266, y=359.991211, z=0.000762}
								}
								,{
									position	= {x=-2.186970, y=2.050560, z=-2.274213}
									,rotation	= {x=0.004314, y=59.947861, z=-0.000277}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=-3.499855, y=2.047644, z=1.515476}
									,rotation	= {x=-0.000149, y=179.999741, z=-0.000775}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "56"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 52
			,[52] = {
				--Traps
				{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Poison Gas"
							,tile	= {
								{
									position	= {x=-7.000000, y=1.934177, z=15.155444}
									,rotation	= {x=0.000244, y=0.043405, z=0.000771}
								}
								,{
									position	= {x=8.749996, y=1.931774, z=9.093266}
									,rotation	= {x=0.000255, y=0.043414, z=0.000763}
								}
								,{
									position	= {x=-4.375001, y=1.931625, z=3.031089}
									,rotation	= {x=0.000253, y=0.043402, z=0.000770}
								}
								,{
									position	= {x=6.125000, y=1.934419, z=0.000001}
									,rotation	= {x=0.000248, y=0.043362, z=0.000768}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Boulder"
							,tile	= {
								{
									position	= {x=-5.687500, y=1.934192, z=15.913217}
									,rotation	= {x=-0.000248, y=179.991577, z=-0.000773}
								}
								,{
									position	= {x=10.062500, y=1.931795, z=8.335495}
									,rotation	= {x=-0.000254, y=179.991714, z=-0.000758}
								}
								,{
									position	= {x=-0.437497, y=1.931701, z=-2.273320}
									,rotation	= {x=-0.000256, y=179.991577, z=-0.000769}
								}
								,{
									position	= {x=14.000000, y=1.934544, z=-4.546635}
									,rotation	= {x=-0.000250, y=179.991501, z=-0.000772}
								}
								,{
									position	= {x=0.875000, y=1.931675, z=7.577721}
									,rotation	= {x=-0.000254, y=179.991592, z=-0.000773}
								}
								,{
									position	= {x=2.187498, y=1.931709, z=3.788863}
									,rotation	= {x=-0.000247, y=179.991577, z=-0.000769}
								}
							}
						}
						,{
							name	= "Boulder 2"
							,tile	= {
								{
									position	= {x=-0.437502, y=1.934366, z=6.819952}
									,rotation	= {x=0.000541, y=240.009460, z=-0.000600}
								}
								,{
									position	= {x=2.187584, y=1.934388, z=9.851041}
									,rotation	= {x=-0.000250, y=179.999039, z=-0.000773}
								}
								,{
									position	= {x=6.125001, y=1.934451, z=7.577722}
									,rotation	= {x=0.000541, y=240.009445, z=-0.000598}
								}
							}
						}
						,{
							name	= "Boulder 3"
							,tile	= {
								{
									position	= {x=-4.375216, y=1.937792, z=21.206146}
									,rotation	= {x=-0.000248, y=180.000580, z=-0.000772}
								}
								,{
									position	= {x=2.187495, y=1.935308, z=5.304407}
									,rotation	= {x=0.000246, y=359.990784, z=0.000769}
								}
							}
						}
						,{
							name	= "Sarcophagus A"
							,tile	= {
								{
									position	= {x=-3.062498, y=1.936945, z=12.882128}
									,rotation	= {x=0.000551, y=239.990692, z=-0.000601}
								}
								,{
									position	= {x=10.062500, y=1.934473, z=14.397672}
									,rotation	= {x=0.000531, y=239.990662, z=-0.000602}
								}
								,{
									position	= {x=-5.687503, y=1.934303, z=5.304409}
									,rotation	= {x=-0.000254, y=179.990616, z=-0.000762}
								}
								,{
									position	= {x=10.062500, y=1.937193, z=-3.788863}
									,rotation	= {x=0.000787, y=300.005798, z=0.000177}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=-1.750000, y=1.820672, z=10.608820}
									,rotation	= {x=0.000597, y=240.020355, z=180.153870}
								}
								,{
									position	= {x=-3.062480, y=1.818337, z=5.304403}
									,rotation	= {x=-0.000264, y=179.404770, z=179.999344}
								}
								,{
									position	= {x=7.437499, y=1.818465, z=8.335495}
									,rotation	= {x=0.000238, y=0.009453, z=180.000793}
								}
								,{
									position	= {x=6.125015, y=1.820817, z=3.031070}
									,rotation	= {x=-0.000166, y=60.009129, z=180.155258}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=-1.750882, y=1.934222, z=21.244101}
									,rotation	= {x=-0.000245, y=180.110855, z=-0.000771}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=4.812500, y=1.931685, z=17.428761}
									,rotation	= {x=-0.000252, y=180.110901, z=-0.000761}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=-0.437498, y=1.931708, z=-3.788869}
									,rotation	= {x=-0.000250, y=180.110886, z=-0.000766}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=15.312500, y=1.934552, z=-2.273314}
									,rotation	= {x=-0.000239, y=180.110870, z=-0.000769}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=-3.062322, y=1.878406, z=21.975374}
									,rotation	= {x=-0.000245, y=180.012604, z=-0.000771}
								}
								,{
									position	= {x=-3.062505, y=1.878420, z=18.944305}
									,rotation	= {x=-0.000249, y=180.012634, z=-0.000756}
								}
								,{
									position	= {x=3.500001, y=1.875883, z=15.155445}
									,rotation	= {x=-0.000255, y=180.012604, z=-0.000775}
								}
								,{
									position	= {x=7.437500, y=1.875932, z=15.913216}
									,rotation	= {x=-0.000254, y=180.012665, z=-0.000762}
								}
								,{
									position	= {x=-1.749996, y=1.875893, z=-3.031108}
									,rotation	= {x=-0.000262, y=180.012817, z=-0.000788}
								}
								,{
									position	= {x=0.875004, y=1.875921, z=-1.515549}
									,rotation	= {x=-0.000258, y=180.012650, z=-0.000765}
								}
								,{
									position	= {x=12.687500, y=1.878722, z=-2.273314}
									,rotation	= {x=-0.000257, y=180.012726, z=-0.000766}
								}
								,{
									position	= {x=15.312500, y=1.878764, z=-3.788861}
									,rotation	= {x=-0.000253, y=180.012619, z=-0.000759}
								}
							}
						}
					}
				}
			}
			--Scenario 53
			,[53] = {
				--Traps
				{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Poison Gas"
							,tile	= {
								{
									position	= {x=-7.577722, y=1.931899, z=4.374996}
									,rotation	= {x=0.000341, y=89.999985, z=-0.001892}
								}
								,{
									position	= {x=-0.756444, y=2.007200, z=5.687987}
									,rotation	= {x=0.580333, y=90.009117, z=0.297668}
								}
								,{
									position	= {x=-0.756444, y=2.020832, z=3.062987}
									,rotation	= {x=0.580332, y=90.009079, z=0.297665}
								}
								,{
									position	= {x=3.790189, y=1.961153, z=5.687987}
									,rotation	= {x=0.580339, y=90.009003, z=0.297672}
								}
								,{
									position	= {x=3.790188, y=1.974784, z=3.062986}
									,rotation	= {x=0.580335, y=90.009102, z=0.297671}
								}
								,{
									position	= {x=10.608809, y=1.931820, z=4.374999}
									,rotation	= {x=-0.000767, y=90.000000, z=0.000250}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Altar Vertical"
							,tile	= {
								{
									position	= {x=1.531374, y=1.990985, z=4.348702}
									,rotation	= {x=0.580422, y=89.992554, z=0.297501}
								}
							}
						}
						,{
							name	= "Boulder"
							,tile	= {
								{
									position	= {x=-6.075623, y=1.931891, z=4.402702}
									,rotation	= {x=-0.000338, y=270.031464, z=0.001894}
								}
								,{
									position	= {x=9.093265, y=1.931799, z=4.375004}
									,rotation	= {x=0.000764, y=270.031494, z=-0.000250}
								}
							}
						}
						,{
							name	= "Stone Pillar"
							,tile	= {
								{
									position	= {x=2.272143, y=1.931668, z=13.561900}
									,rotation	= {x=0.000772, y=269.993042, z=-0.000248}
								}
								,{
									position	= {x=0.000008, y=1.992725, z=6.999998}
									,rotation	= {x=359.419647, y=269.994720, z=359.702515}
								}
								,{
									position	= {x=3.031096, y=1.962027, z=6.999998}
									,rotation	= {x=359.419647, y=269.994781, z=359.702484}
								}
								,{
									position	= {x=0.001468, y=2.019969, z=1.750744}
									,rotation	= {x=359.419647, y=269.994629, z=359.702484}
								}
								,{
									position	= {x=3.031095, y=1.989290, z=1.749999}
									,rotation	= {x=359.419647, y=269.994751, z=359.702515}
								}
								,{
									position	= {x=0.756892, y=2.049368, z=-4.816830}
									,rotation	= {x=359.809235, y=269.759674, z=1.600140}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=-2.273633, y=1.892797, z=8.312869}
									,rotation	= {x=0.534757, y=30.096983, z=184.906494}
								}
								,{
									position	= {x=1.515927, y=1.848686, z=9.625255}
									,rotation	= {x=0.578545, y=90.006210, z=182.005386}
								}
								,{
									position	= {x=5.304235, y=1.823588, z=8.312386}
									,rotation	= {x=0.195889, y=150.015579, z=180.340240}
								}
								,{
									position	= {x=-2.272812, y=1.936520, z=0.437754}
									,rotation	= {x=0.032644, y=149.986115, z=180.640778}
								}
								,{
									position	= {x=1.515077, y=2.043306, z=-0.876039}
									,rotation	= {x=0.186474, y=90.063362, z=189.487183}
								}
								,{
									position	= {x=5.305186, y=1.859774, z=0.437681}
									,rotation	= {x=0.548155, y=30.026171, z=179.632217}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=0.758262, y=1.976071, z=-7.441733}
									,rotation	= {x=0.197534, y=90.001472, z=358.400696}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "31"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=3.031089, y=1.875877, z=14.875000}
									,rotation	= {x=-0.000255, y=179.999435, z=-0.000772}
								}
								,{
									position	= {x=0.757772, y=1.875853, z=13.562500}
									,rotation	= {x=-0.000248, y=179.999435, z=-0.000766}
								}
								,{
									position	= {x=-6.062177, y=1.876269, z=9.624999}
									,rotation	= {x=0.001911, y=179.999451, z=0.000336}
								}
								,{
									position	= {x=-6.819949, y=1.876143, z=5.687498}
									,rotation	= {x=0.001887, y=179.999390, z=0.000340}
								}
								,{
									position	= {x=-6.819950, y=1.875970, z=0.437495}
									,rotation	= {x=0.001885, y=179.999420, z=0.000332}
								}
								,{
									position	= {x=-1.515106, y=1.964722, z=-6.129733}
									,rotation	= {x=1.599510, y=179.975052, z=0.196685}
								}
								,{
									position	= {x=9.093266, y=1.876027, z=-0.875000}
									,rotation	= {x=-0.000250, y=179.999390, z=-0.000764}
								}
								,{
									position	= {x=10.608810, y=1.876013, z=7.000000}
									,rotation	= {x=-0.000256, y=179.999420, z=-0.000765}
								}
							}
						}
					}
				}
			}
			--Scenario 54
			,[54] = {
				--Traps
				{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Poison Gas"
							,tile	= {
								{
									position	= {x=-1.312500, y=1.931029, z=11.366583}
									,rotation	= {x=0.000252, y=-0.005286, z=0.000766}
								}
								,{
									position	= {x=0.000000, y=1.931057, z=9.093266}
									,rotation	= {x=0.000253, y=-0.005286, z=0.000765}
								}
								,{
									position	= {x=1.312500, y=1.931091, z=5.304405}
									,rotation	= {x=0.000253, y=-0.005267, z=0.000765}
								}
								,{
									position	= {x=-2.625000, y=1.931054, z=1.515543}
									,rotation	= {x=0.000253, y=-0.005225, z=0.000765}
								}
								,{
									position	= {x=2.625000, y=1.931131, z=0.000000}
									,rotation	= {x=0.000251, y=-0.005283, z=0.000770}
								}
								,{
									position	= {x=-0.000002, y=1.931110, z=-3.031090}
									,rotation	= {x=0.000250, y=-0.005284, z=0.000764}
								}
							}
						}
						,{
							name	= "Spike Trap"
							,tile	= {
								{
									position	= {x=1.312500, y=1.931058, z=12.882128}
									,rotation	= {x=0.000252, y=359.991486, z=0.000765}
								}
								,{
									position	= {x=-1.312500, y=1.931049, z=6.819950}
									,rotation	= {x=0.000256, y=359.991486, z=0.000766}
								}
								,{
									position	= {x=-2.625000, y=1.931048, z=3.031089}
									,rotation	= {x=0.000251, y=359.991486, z=0.000766}
								}
								,{
									position	= {x=-3.937502, y=1.931054, z=-2.273317}
									,rotation	= {x=0.000252, y=359.991486, z=0.000768}
								}
								,{
									position	= {x=-1.312500, y=1.931102, z=-5.304405}
									,rotation	= {x=0.000253, y=359.991486, z=0.000767}
								}
								,{
									position	= {x=3.937500, y=1.931152, z=-0.757772}
									,rotation	= {x=0.000252, y=359.991486, z=0.000765}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Altar Horizontal"
							,tile	= {
								{
									position	= {x=-0.000003, y=1.931123, z=-6.062177}
									,rotation	= {x=-0.000252, y=179.979919, z=-0.000769}
								}
							}
						}
						,{
							name	= "Stalagmites"
							,tile	= {
								{
									position	= {x=0.000000, y=1.933948, z=12.124355}
									,rotation	= {x=0.000252, y=0.004054, z=0.000766}
								}
								,{
									position	= {x=1.312500, y=1.933976, z=9.851039}
									,rotation	= {x=0.000253, y=0.004054, z=0.000765}
								}
								,{
									position	= {x=0.000000, y=1.933975, z=6.062178}
									,rotation	= {x=0.000250, y=0.004054, z=0.000766}
								}
								,{
									position	= {x=-2.625000, y=1.933973, z=-1.515545}
									,rotation	= {x=0.000245, y=0.004058, z=0.000764}
								}
								,{
									position	= {x=2.625000, y=1.934043, z=-1.515544}
									,rotation	= {x=0.000248, y=0.004054, z=0.000769}
								}
							}
						}
						,{
							name	= "Stone Pillar"
							,tile	= {
								{
									position	= {x=-1.312500, y=1.931075, z=0.757772}
									,rotation	= {x=0.000254, y=0.023862, z=0.000769}
								}
								,{
									position	= {x=1.312500, y=1.931111, z=0.757772}
									,rotation	= {x=0.000250, y=0.023863, z=0.000765}
								}
								,{
									position	= {x=-1.312500, y=1.931095, z=-3.788861}
									,rotation	= {x=0.000252, y=0.023860, z=0.000770}
								}
								,{
									position	= {x=1.312500, y=1.931130, z=-3.788861}
									,rotation	= {x=0.000248, y=0.023860, z=0.000765}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Dark Fog"
							,tile	= {
								{
									position	= {x=0.000000, y=1.934581, z=4.546633}
									,rotation	= {x=-0.000245, y=180.000015, z=-0.000763}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=-3.937500, y=1.931073, z=-6.819950}
									,rotation	= {x=-0.000250, y=180.000671, z=-0.000764}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "25"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=-3.937500, y=1.875272, z=-5.304406}
									,rotation	= {x=-0.000247, y=179.999374, z=-0.000763}
								}
								,{
									position	= {x=-2.625001, y=1.875293, z=-6.062178}
									,rotation	= {x=-0.000247, y=179.999405, z=-0.000762}
								}
								,{
									position	= {x=3.937501, y=1.875384, z=-6.819995}
									,rotation	= {x=-0.000248, y=179.999420, z=-0.000762}
								}
							}
						}
					}
				}
			}
			--Scenario 55
			,[55] = {}
			--Scenario 56
			,[56] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Log"
							,tile	= {
								{
									position	= {x=-4.546878, y=1.933697, z=8.749862}
									,rotation	= {x=-0.000613, y=149.980804, z=-0.000541}
								}
								,{
									position	= {x=-5.304406, y=1.933732, z=-0.437775}
									,rotation	= {x=-0.000764, y=89.982841, z=0.000265}
								}
								,{
									position	= {x=6.062178, y=1.934491, z=-1.750000}
									,rotation	= {x=-0.000751, y=89.982841, z=0.000240}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Bush 1"
							,tile	= {
								{
									position	= {x=-6.062179, y=1.930972, z=8.750000}
									,rotation	= {x=-0.000772, y=90.005394, z=0.000265}
								}
								,{
									position	= {x=-2.273314, y=1.931029, z=7.437503}
									,rotation	= {x=-0.000765, y=90.005417, z=0.000265}
								}
								,{
									position	= {x=-6.819952, y=1.930980, z=4.812498}
									,rotation	= {x=-0.000769, y=90.005379, z=0.000268}
								}
								,{
									position	= {x=-3.031088, y=1.931051, z=0.875001}
									,rotation	= {x=-0.000767, y=90.005379, z=0.000260}
								}
								,{
									position	= {x=3.031088, y=1.931433, z=0.875000}
									,rotation	= {x=-0.000905, y=90.005348, z=0.000341}
								}
								,{
									position	= {x=5.304405, y=1.931781, z=-3.062500}
									,rotation	= {x=-0.000748, y=90.005371, z=0.000238}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "LIght Fog"
							,tile	= {
								{
									position	= {x=-3.788863, y=1.934539, z=2.187500}
									,rotation	= {x=0.000840, y=269.952057, z=-0.000423}
								}
								,{
									position	= {x=-1.515573, y=1.934832, z=-1.749986}
									,rotation	= {x=0.002691, y=210.008041, z=359.983124}
								}
								,{
									position	= {x=3.788835, y=1.935199, z=-0.437500}
									,rotation	= {x=0.012432, y=269.952271, z=-0.001591}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=6.819951, y=1.931812, z=-5.687501}
									,rotation	= {x=-0.000754, y=90.000046, z=0.000242}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "45"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=3.788861, y=1.875967, z=-3.062500}
									,rotation	= {x=-0.000246, y=179.999329, z=-0.000740}
								}
								,{
									position	= {x=4.546631, y=1.875982, z=-4.375005}
									,rotation	= {x=-0.000244, y=179.999451, z=-0.000745}
								}
								,{
									position	= {x=6.062178, y=1.875980, z=0.875026}
									,rotation	= {x=-0.000239, y=179.998535, z=-0.000745}
								}
								,{
									position	= {x=9.093268, y=1.876019, z=0.875041}
									,rotation	= {x=-0.000238, y=180.000366, z=-0.000753}
								}
								,{
									position	= {x=9.093266, y=1.876053, z=-7.000002}
									,rotation	= {x=-0.000235, y=179.999359, z=-0.000746}
								}
								,{
									position	= {x=10.608809, y=1.876072, z=-7.000012}
									,rotation	= {x=-0.000263, y=179.999374, z=-0.000761}
								}
							}
						}
					}
				}
			}
			--Scenario 57
			,[57] = {
				--Traps
				{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Bear Trap"
							,tile	= {
								{
									position	= {x=-0.757774, y=1.934289, z=0.437501}
									,rotation	= {x=-0.000763, y=90.005424, z=0.000248}
								}
								,{
									position	= {x=-1.515546, y=1.934285, z=-0.875000}
									,rotation	= {x=-0.000761, y=90.005463, z=0.000253}
								}
								,{
									position	= {x=2.273317, y=1.934329, z=0.437500}
									,rotation	= {x=-0.000763, y=90.005440, z=0.000253}
								}
								,{
									position	= {x=3.031090, y=1.934345, z=-0.875000}
									,rotation	= {x=-0.000766, y=90.005440, z=0.000250}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Boulder"
							,tile	= {
								{
									position	= {x=-7.577721, y=1.930930, z=14.875000}
									,rotation	= {x=-0.000763, y=89.989929, z=0.000251}
								}
								,{
									position	= {x=-6.062178, y=1.930586, z=7.000000}
									,rotation	= {x=-0.000767, y=89.989922, z=0.000248}
								}
								,{
									position	= {x=-3.031089, y=1.930638, z=4.375000}
									,rotation	= {x=-0.000765, y=89.989922, z=0.000247}
								}
								,{
									position	= {x=-6.062098, y=1.930609, z=1.722788}
									,rotation	= {x=-0.000764, y=89.989899, z=0.000251}
								}
							}
						}
						,{
							name	= "Table"
							,tile	= {
								{
									position	= {x=4.546632, y=1.933810, z=12.249998}
									,rotation	= {x=0.000173, y=209.988434, z=-0.000794}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=-5.304407, y=1.817610, z=10.937497}
									,rotation	= {x=0.006717, y=270.158112, z=180.015106}
								}
								,{
									position	= {x=-5.304402, y=1.817667, z=-2.187499}
									,rotation	= {x=0.005250, y=89.720131, z=180.015594}
								}
							}
						}
						,{
							name	= "Stone Door Vertical"
							,tile	= {
								{
									position	= {x=-2.273318, y=1.817685, z=8.312501}
									,rotation	= {x=359.987976, y=89.976814, z=179.996216}
								}
								,{
									position	= {x=-2.273321, y=1.817959, z=0.437499}
									,rotation	= {x=359.982574, y=89.976921, z=179.992172}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=0.757772, y=1.931404, z=0.437501}
									,rotation	= {x=-0.000762, y=90.000015, z=0.000249}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "22"
									}
								}
								,{
									position	= {x=4.546634, y=1.931460, z=-0.875000}
									,rotation	= {x=-0.000765, y=90.000015, z=0.000248}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "3"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=-0.000002, y=1.875605, z=-0.875001}
									,rotation	= {x=-0.000248, y=179.999466, z=-0.000768}
								}
								,{
									position	= {x=1.515544, y=1.875625, z=-0.875000}
									,rotation	= {x=-0.000254, y=179.999390, z=-0.000769}
								}
								,{
									position	= {x=3.788869, y=1.875650, z=0.437502}
									,rotation	= {x=-0.000239, y=179.999451, z=-0.000763}
								}
							}
						}
					}
				}
			}
			--Scenario 58
			,[58] = {
				--Traps
				{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Poison Gas"
							,tile	= {
								{
									position	= {x=0.000000, y=1.931076, z=4.546633}
									,rotation	= {x=0.000252, y=-0.000005, z=0.000771}
								}
								,{
									position	= {x=1.312500, y=1.931097, z=3.788861}
									,rotation	= {x=0.000246, y=-0.000005, z=0.000769}
								}
								,{
									position	= {x=1.312539, y=1.931124, z=-2.273339}
									,rotation	= {x=0.000249, y=-0.000003, z=0.000772}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Bush 1"
							,tile	= {
								{
									position	= {x=6.562500, y=1.931768, z=3.788861}
									,rotation	= {x=0.000262, y=0.000126, z=0.000772}
								}
								,{
									position	= {x=5.250000, y=1.931186, z=-4.546633}
									,rotation	= {x=0.000247, y=0.000129, z=0.000776}
								}
								,{
									position	= {x=5.250000, y=1.931193, z=-6.062178}
									,rotation	= {x=0.000255, y=0.000127, z=0.000776}
								}
							}
						}
						,{
							name	= "Nest"
							,tile	= {
								{
									position	= {x=-7.874216, y=1.930984, z=1.546163}
									,rotation	= {x=0.000243, y=0.041532, z=0.000767}
								}
								,{
									position	= {x=-3.937500, y=1.931034, z=2.273317}
									,rotation	= {x=0.000246, y=0.041529, z=0.000771}
								}
								,{
									position	= {x=-7.875000, y=1.930997, z=-1.515544}
									,rotation	= {x=0.000249, y=0.041529, z=0.000771}
								}
								,{
									position	= {x=-3.937500, y=1.931053, z=-2.273317}
									,rotation	= {x=0.000247, y=0.041527, z=0.000769}
								}
							}
						}
						,{
							name	= "Table"
							,tile	= {
								{
									position	= {x=-1.312613, y=1.933793, z=-2.281252}
									,rotation	= {x=-0.000248, y=180.023041, z=-0.000770}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Wooden Door Horizontal"
							,tile	= {
								{
									position	= {x=2.624997, y=1.818322, z=4.546630}
									,rotation	= {x=0.005219, y=180.034592, z=179.967636}
								}
								,{
									position	= {x=-2.625000, y=1.817766, z=0.000000}
									,rotation	= {x=-0.000250, y=180.034363, z=179.999268}
								}
								,{
									position	= {x=2.625000, y=1.817856, z=-4.546633}
									,rotation	= {x=-0.000255, y=180.034393, z=179.999268}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=0.000000, y=1.931096, z=0.000000}
									,rotation	= {x=-0.000249, y=180.000656, z=-0.000771}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=9.187500, y=1.876008, z=3.788860}
									,rotation	= {x=-0.000276, y=179.999573, z=-0.000766}
								}
								,{
									position	= {x=7.874998, y=1.875994, z=3.031057}
									,rotation	= {x=-0.000256, y=180.000046, z=-0.000767}
								}
								,{
									position	= {x=-1.312500, y=1.875306, z=-5.304405}
									,rotation	= {x=-0.000249, y=179.999527, z=-0.000763}
								}
							}
						}
					}
				}
			}
			--Scenario 59
			,[59] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Log"
							,tile	= {
								{
									position	= {x=-2.624999, y=1.934373, z=-1.515548}
									,rotation	= {x=-0.000544, y=60.011532, z=0.000606}
								}
								,{
									position	= {x=3.937707, y=1.934471, z=-3.788498}
									,rotation	= {x=-0.000793, y=119.912636, z=-0.000172}
								}
								,{
									position	= {x=14.437953, y=1.933974, z=5.305191}
									,rotation	= {x=-0.000792, y=120.024826, z=-0.000170}
								}
							}
						}
					}
				}
				--Corridors
				,{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Earth Corridor 2"
							,tile	= {
								{
									position	= {x=9.187528, y=1.934546, z=-3.788857}
									,rotation	= {x=-0.000183, y=0.028696, z=359.984863}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Spike Trap"
							,tile	= {
								{
									position	= {x=5.249997, y=1.931780, z=-3.031088}
									,rotation	= {x=0.000250, y=359.991516, z=0.000770}
								}
								,{
									position	= {x=10.500000, y=1.931530, z=1.515544}
									,rotation	= {x=0.000254, y=359.991516, z=0.000765}
								}
								,{
									position	= {x=11.812500, y=1.931551, z=0.757771}
									,rotation	= {x=0.000252, y=359.991516, z=0.000766}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Bush 1"
							,tile	= {
								{
									position	= {x=6.562500, y=1.931788, z=-0.757777}
									,rotation	= {x=0.000247, y=-0.002860, z=0.000766}
								}
								,{
									position	= {x=11.812500, y=1.931564, z=-2.273317}
									,rotation	= {x=0.000247, y=-0.002874, z=0.000763}
								}
								,{
									position	= {x=14.437500, y=1.931256, z=8.335494}
									,rotation	= {x=0.000253, y=-0.002874, z=0.000773}
								}
							}
						}
						,{
							name	= "Tree"
							,tile	= {
								{
									position	= {x=-6.562502, y=1.932307, z=-3.788860}
									,rotation	= {x=0.000248, y=359.990601, z=0.000770}
								}
								,{
									position	= {x=-1.312500, y=1.932378, z=-3.788861}
									,rotation	= {x=-0.000248, y=179.989044, z=-0.000771}
								}
								,{
									position	= {x=9.187500, y=1.931875, z=6.819950}
									,rotation	= {x=-0.000248, y=179.989044, z=-0.000773}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "LIght Fog"
							,tile	= {
								{
									position	= {x=1.312505, y=1.935229, z=-2.273312}
									,rotation	= {x=-0.000248, y=179.998047, z=-0.000763}
								}
								,{
									position	= {x=11.812494, y=1.934962, z=2.273339}
									,rotation	= {x=359.985046, y=179.998505, z=-0.001446}
								}
							}
						}
					}
				}
				--Hazardous Terrain
				,{
					bag	 	= Bag_HazardousTerrain_GUID
					,type	= {
						{
							name	= "Thorns"
							,tile	= {
								{
									position	= {x=-1.317642, y=1.931689, z=-2.268981}
									,rotation	= {x=0.000246, y=0.016422, z=0.000772}
								}
								,{
									position	= {x=9.187541, y=2.047846, z=-2.273315}
									,rotation	= {x=-0.000179, y=0.016507, z=359.982391}
								}
								,{
									position	= {x=10.500000, y=1.931556, z=-4.546633}
									,rotation	= {x=0.000250, y=0.016420, z=0.000765}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=11.812499, y=1.931221, z=8.335497}
									,rotation	= {x=-0.000247, y=180.000778, z=-0.000768}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=10.500000, y=1.875405, z=9.093267}
									,rotation	= {x=-0.000252, y=179.999374, z=-0.000767}
								}
								,{
									position	= {x=10.500000, y=1.875412, z=7.577723}
									,rotation	= {x=-0.000245, y=179.999481, z=-0.000771}
								}
								,{
									position	= {x=13.125000, y=1.875440, z=9.093267}
									,rotation	= {x=-0.000252, y=180.029037, z=-0.000759}
								}
								,{
									position	= {x=13.125000, y=1.875447, z=7.577723}
									,rotation	= {x=-0.000257, y=179.999374, z=-0.000766}
								}
							}
						}
					}
				}
			}
			--Scenario 60
			,[60] = {
				--Corridors
				{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Wooden Corridor 1"
							,tile	= {
								{
									position	= {x=6.066826, y=1.817879, z=0.875371}
									,rotation	= {x=-0.000735, y=89.966621, z=180.000214}
								}
							}
						}
						,{
							name	= "Wooden Corridor 2"
							,tile	= {
								{
									position	= {x=5.304403, y=1.933863, z=2.187481}
									,rotation	= {x=-0.000751, y=90.004112, z=0.000260}
								}
								,{
									position	= {x=5.304405, y=1.933876, z=-0.437503}
									,rotation	= {x=-0.000741, y=90.004089, z=0.000258}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Bear Trap"
							,tile	= {
								{
									position	= {x=-5.304409, y=1.933943, z=-3.062500}
									,rotation	= {x=-0.000766, y=90.005623, z=0.000249}
								}
								,{
									position	= {x=-3.788862, y=1.933975, z=-5.687500}
									,rotation	= {x=-0.000764, y=90.005653, z=0.000250}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Bookcase"
							,tile	= {
								{
									position	= {x=-0.762220, y=1.933794, z=-0.440016}
									,rotation	= {x=0.000607, y=330.704010, z=0.000547}
								}
								,{
									position	= {x=3.788857, y=1.933843, z=2.187500}
									,rotation	= {x=0.000770, y=270.005493, z=-0.000264}
								}
								,{
									position	= {x=9.093266, y=1.933908, z=3.500000}
									,rotation	= {x=0.000770, y=270.005493, z=-0.000265}
								}
								,{
									position	= {x=10.608810, y=1.933940, z=0.875000}
									,rotation	= {x=0.000768, y=270.005493, z=-0.000257}
								}
							}
						}
						,{
							name	= "Nest"
							,tile	= {
								{
									position	= {x=11.335402, y=1.931204, z=10.063450}
									,rotation	= {x=0.000762, y=270.031982, z=-0.000248}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Wooden Door Horizontal"
							,tile	= {
								{
									position	= {x=-0.000001, y=1.817786, z=3.499996}
									,rotation	= {x=0.000757, y=270.018250, z=179.999771}
								}
								,{
									position	= {x=10.608811, y=1.817916, z=6.125000}
									,rotation	= {x=0.000755, y=270.018250, z=179.999741}
								}
								,{
									position	= {x=10.608811, y=1.817951, z=-1.750000}
									,rotation	= {x=-0.000758, y=90.002922, z=180.000214}
								}
								,{
									position	= {x=-4.546633, y=1.817748, z=-1.750000}
									,rotation	= {x=-0.000775, y=90.002937, z=180.000168}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=0.000000, y=1.931059, z=8.750010}
									,rotation	= {x=-0.000763, y=90.000000, z=0.000248}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=9.093266, y=1.931168, z=11.375000}
									,rotation	= {x=-0.000766, y=90.000031, z=0.000248}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=7.608665, y=1.931229, z=-7.000946}
									,rotation	= {x=-0.000771, y=90.022987, z=0.000251}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=-3.031089, y=1.931086, z=-7.000000}
									,rotation	= {x=-0.000764, y=90.022987, z=0.000253}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=6.819950, y=1.875372, z=4.812500}
									,rotation	= {x=-0.000252, y=179.999435, z=-0.000771}
								}
								,{
									position	= {x=8.335494, y=1.875392, z=4.812500}
									,rotation	= {x=-0.000261, y=179.999374, z=-0.000760}
								}
								,{
									position	= {x=10.608811, y=1.875474, z=-7.000000}
									,rotation	= {x=-0.000248, y=179.999405, z=-0.000771}
								}
							}
						}
					}
				}
			}
			--Scenario 61
			,[61] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Stairs Horizontal"
							,tile	= {
								{
									position	= {x=-2.275844, y=1.934206, z=14.421455}
									,rotation	= {x=-0.000139, y=30.000305, z=0.000721}
								}
								,{
									position	= {x=-0.000001, y=1.934290, z=2.624999}
									,rotation	= {x=0.000602, y=329.966095, z=0.000539}
								}
							}
						}
						,{
							name	= "Stairs Vertical"
							,tile	= {
								{
									position	= {x=-1.515552, y=1.934209, z=15.750007}
									,rotation	= {x=-0.000559, y=150.029114, z=-0.000480}
								}
								,{
									position	= {x=-0.757772, y=1.934274, z=3.937508}
									,rotation	= {x=-0.000170, y=29.992819, z=0.000786}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Bear Trap"
							,tile	= {
								{
									position	= {x=0.000000, y=1.934228, z=15.750001}
									,rotation	= {x=-0.000694, y=90.005478, z=0.000242}
								}
								,{
									position	= {x=-2.273319, y=1.934254, z=3.937500}
									,rotation	= {x=-0.000764, y=90.005478, z=0.000253}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Nest"
							,tile	= {
								{
									position	= {x=-5.304405, y=1.931574, z=11.812501}
									,rotation	= {x=0.000600, y=329.968750, z=0.000541}
								}
							}
						}
						,{
							name	= "Stone Pillar"
							,tile	= {
								{
									position	= {x=1.515799, y=1.977844, z=21.003300}
									,rotation	= {x=0.013440, y=270.044189, z=358.968811}
								}
								,{
									position	= {x=-0.757772, y=1.931319, z=14.437500}
									,rotation	= {x=0.000691, y=270.007629, z=-0.000241}
								}
								,{
									position	= {x=-3.788861, y=1.931606, z=9.187500}
									,rotation	= {x=0.000767, y=270.007629, z=-0.000250}
								}
								,{
									position	= {x=-3.788862, y=1.931329, z=3.937501}
									,rotation	= {x=0.000767, y=270.007599, z=-0.000249}
								}
								,{
									position	= {x=0.757771, y=1.931724, z=-3.937502}
									,rotation	= {x=0.000767, y=270.007629, z=-0.000254}
								}
							}
						}
						,{
							name	= "Wall Section"
							,tile	= {
								{
									position	= {x=-3.789663, y=1.933987, z=14.437955}
									,rotation	= {x=-0.000137, y=29.940708, z=0.000716}
								}
								,{
									position	= {x=-1.515545, y=1.934070, z=2.625000}
									,rotation	= {x=0.000767, y=270.026581, z=-0.000256}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=0.757759, y=1.932632, z=17.062414}
									,rotation	= {x=0.081901, y=270.012817, z=187.603073}
								}
								,{
									position	= {x=-3.031090, y=1.818253, z=13.125006}
									,rotation	= {x=0.003797, y=270.000916, z=179.984009}
								}
								,{
									position	= {x=-3.031085, y=1.818268, z=5.249999}
									,rotation	= {x=0.006752, y=270.000702, z=180.012238}
								}
								,{
									position	= {x=0.757775, y=1.818349, z=1.312508}
									,rotation	= {x=0.003436, y=270.000488, z=179.984100}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=2.273650, y=1.954402, z=22.314949}
									,rotation	= {x=359.986542, y=90.046326, z=1.031197}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=2.273317, y=1.931356, z=14.437500}
									,rotation	= {x=-0.000694, y=90.000259, z=0.000239}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=-6.819951, y=1.931565, z=9.187500}
									,rotation	= {x=-0.000767, y=90.000259, z=0.000250}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=2.273309, y=1.931410, z=3.937500}
									,rotation	= {x=-0.000769, y=90.000275, z=0.000247}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=1.515545, y=1.875546, z=15.750000}
									,rotation	= {x=-0.000233, y=179.999298, z=-0.000705}
								}
								,{
									position	= {x=0.757775, y=1.875543, z=14.437500}
									,rotation	= {x=-0.000232, y=179.999481, z=-0.000701}
								}
								,{
									position	= {x=0.757772, y=1.875594, z=3.937500}
									,rotation	= {x=-0.000251, y=179.999283, z=-0.000760}
								}
								,{
									position	= {x=1.515542, y=1.875610, z=2.625000}
									,rotation	= {x=-0.000253, y=179.999344, z=-0.000774}
								}
							}
						}
					}
				}
			}
			--Sceanrio 62
			,[62] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Rubble"
							,tile	= {
								{
									position	= {x=0.000001, y=1.931061, z=7.875000}
									,rotation	= {x=-0.000760, y=90.008522, z=0.000265}
								}
								,{
									position	= {x=1.515537, y=2.047723, z=2.625063}
									,rotation	= {x=-0.000805, y=90.008850, z=0.027374}
								}
								,{
									position	= {x=-1.515546, y=1.931676, z=-0.000001}
									,rotation	= {x=-0.000771, y=90.008514, z=0.000247}
								}
								,{
									position	= {x=-2.273316, y=1.931672, z=-1.312500}
									,rotation	= {x=-0.000768, y=90.008537, z=0.000246}
								}
								,{
									position	= {x=-0.757772, y=1.931704, z=-3.937500}
									,rotation	= {x=-0.000773, y=90.008514, z=0.000247}
								}
								,{
									position	= {x=2.273316, y=1.931744, z=-3.937500}
									,rotation	= {x=-0.000770, y=90.008514, z=0.000249}
								}
							}
						}
					}
				}
				--Corridors
				,{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Man Stone Corridor 1"
							,tile	= {
								{
									position	= {x=1.515390, y=1.818303, z=2.638797}
									,rotation	= {x=0.005293, y=270.021912, z=179.968246}
								}
							}
						}
						,{
							name	= "Man Stone Corridor 2"
							,tile	= {
								{
									position	= {x=0.000031, y=1.934352, z=2.625152}
									,rotation	= {x=0.000759, y=270.015778, z=359.962799}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Spike Trap"
							,tile	= {
								{
									position	= {x=-0.757776, y=1.931069, z=3.937497}
									,rotation	= {x=-0.000763, y=89.994652, z=0.000263}
								}
								,{
									position	= {x=2.273316, y=1.931721, z=1.312498}
									,rotation	= {x=-0.000771, y=89.994514, z=0.000246}
								}
								,{
									position	= {x=0.757772, y=1.931713, z=-1.312500}
									,rotation	= {x=-0.000767, y=89.994560, z=0.000249}
								}
								,{
									position	= {x=-1.515544, y=1.931688, z=-2.625001}
									,rotation	= {x=-0.000766, y=89.994591, z=0.000253}
								}
								,{
									position	= {x=1.515544, y=1.931740, z=-5.250000}
									,rotation	= {x=-0.000768, y=89.994537, z=0.000248}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=2.276483, y=1.931097, z=6.596291}
									,rotation	= {x=-0.000762, y=90.000069, z=0.000263}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "59"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=-1.515524, y=1.875246, z=7.875009}
									,rotation	= {x=-0.000272, y=180.041824, z=-0.000750}
								}
								,{
									position	= {x=1.515551, y=1.875286, z=7.875009}
									,rotation	= {x=-0.000280, y=180.041245, z=-0.000778}
								}
								,{
									position	= {x=-2.273319, y=1.875242, z=6.562498}
									,rotation	= {x=-0.000262, y=180.041153, z=-0.000773}
								}
							}
						}
					}
				}
			}
			--Scenario 63
			,[63] = {
				--Doors
				{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Dark Fog"
							,tile	= {
								{
									position	= {x=-1.515575, y=1.935044, z=7.874936}
									,rotation	= {x=0.013798, y=269.991272, z=0.029889}
								}
								,{
									position	= {x=-1.515518, y=1.937481, z=0.000450}
									,rotation	= {x=0.000854, y=269.991089, z=359.807861}
								}
							}
						}
					}
				}
				--Hazardous Terrain
				,{
					bag	 	= Bag_HazardousTerrain_GUID
					,type	= {
						{
							name	= "Hot Coals 1"
							,tile	= {
								{
									position	= {x=-3.031089, y=1.934503, z=13.125000}
									,rotation	= {x=-0.000755, y=89.994545, z=0.000251}
								}
								,{
									position	= {x=-1.515546, y=1.934523, z=13.125000}
									,rotation	= {x=-0.000754, y=89.994591, z=0.000252}
								}
								,{
									position	= {x=-0.757774, y=1.934539, z=11.812500}
									,rotation	= {x=-0.000756, y=89.994644, z=0.000249}
								}
								,{
									position	= {x=0.000000, y=1.934555, z=10.500000}
									,rotation	= {x=-0.000759, y=89.994644, z=0.000250}
								}
								,{
									position	= {x=1.515536, y=1.934575, z=10.500000}
									,rotation	= {x=-0.000757, y=89.994904, z=0.000251}
								}
								,{
									position	= {x=-1.515546, y=1.933958, z=5.250000}
									,rotation	= {x=-0.000771, y=89.994949, z=0.000248}
								}
								,{
									position	= {x=-0.000007, y=1.933979, z=5.250000}
									,rotation	= {x=-0.000767, y=89.995201, z=0.000252}
								}
								,{
									position	= {x=-3.788862, y=1.933933, z=3.937500}
									,rotation	= {x=-0.000770, y=89.995201, z=0.000247}
								}
								,{
									position	= {x=-2.273317, y=1.933954, z=3.937500}
									,rotation	= {x=-0.000768, y=89.995224, z=0.000252}
								}
								,{
									position	= {x=-0.757774, y=1.933974, z=3.937500}
									,rotation	= {x=-0.000766, y=89.995270, z=0.000253}
								}
								,{
									position	= {x=-1.515544, y=1.933970, z=2.625000}
									,rotation	= {x=-0.000768, y=89.995270, z=0.000251}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=0.757764, y=1.931643, z=14.437500}
									,rotation	= {x=-0.000759, y=90.000282, z=0.000249}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "12"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=-2.273316, y=1.875808, z=14.437500}
									,rotation	= {x=-0.000243, y=179.999329, z=-0.000759}
								}
								,{
									position	= {x=-0.757772, y=1.875828, z=14.437500}
									,rotation	= {x=-0.000249, y=179.999329, z=-0.000754}
								}
								,{
									position	= {x=1.515545, y=1.875863, z=13.125000}
									,rotation	= {x=-0.000248, y=179.999329, z=-0.000758}
								}
								,{
									position	= {x=2.273317, y=1.875879, z=11.812500}
									,rotation	= {x=-0.000259, y=179.999344, z=-0.000756}
								}
							}
						}
					}
				}
			}
			--Scenario 64
			,[64] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Water 1"
							,tile	= {
								{
									position	= {x=9.093266, y=1.931780, z=8.750000}
									,rotation	= {x=-0.000774, y=89.988174, z=0.000254}
								}
								,{
									position	= {x=10.608809, y=1.931801, z=8.749999}
									,rotation	= {x=-0.000767, y=89.988228, z=0.000256}
								}
								,{
									position	= {x=8.335492, y=1.931776, z=7.437500}
									,rotation	= {x=-0.000769, y=89.988297, z=0.000256}
								}
								,{
									position	= {x=9.851036, y=1.931796, z=7.437500}
									,rotation	= {x=-0.000767, y=89.988358, z=0.000254}
								}
								,{
									position	= {x=7.577720, y=1.931772, z=6.125000}
									,rotation	= {x=-0.000770, y=89.988411, z=0.000252}
								}
								,{
									position	= {x=9.093265, y=1.931792, z=6.125000}
									,rotation	= {x=-0.000766, y=89.988472, z=0.000256}
								}
								,{
									position	= {x=10.608809, y=1.931812, z=6.125000}
									,rotation	= {x=-0.000770, y=89.988541, z=0.000252}
								}
								,{
									position	= {x=12.124355, y=1.931833, z=6.125000}
									,rotation	= {x=-0.000767, y=89.988541, z=0.000262}
								}
								,{
									position	= {x=8.335494, y=1.931788, z=4.812500}
									,rotation	= {x=-0.000765, y=89.988541, z=0.000255}
								}
								,{
									position	= {x=9.851039, y=1.931808, z=4.812500}
									,rotation	= {x=-0.000769, y=89.988541, z=0.000252}
								}
								,{
									position	= {x=11.366583, y=1.931828, z=4.812500}
									,rotation	= {x=-0.000767, y=89.988541, z=0.000258}
								}
								,{
									position	= {x=12.882128, y=1.931849, z=4.812501}
									,rotation	= {x=-0.000767, y=89.988541, z=0.000257}
								}
								,{
									position	= {x=6.819948, y=1.934441, z=-3.062500}
									,rotation	= {x=-0.000761, y=89.988594, z=0.000244}
								}
								,{
									position	= {x=6.062178, y=1.934436, z=-4.375000}
									,rotation	= {x=-0.000764, y=89.988594, z=0.000242}
								}
								,{
									position	= {x=4.546630, y=1.934416, z=-4.375000}
									,rotation	= {x=-0.000765, y=89.988670, z=0.000238}
								}
								,{
									position	= {x=3.788859, y=1.934411, z=-5.687500}
									,rotation	= {x=-0.000767, y=89.988731, z=0.000239}
								}
								,{
									position	= {x=3.031089, y=1.934407, z=-7.000000}
									,rotation	= {x=-0.000768, y=89.988708, z=0.000239}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Spike Trap"
							,tile	= {
								{
									position	= {x=-4.546634, y=1.931632, z=0.875002}
									,rotation	= {x=-0.000771, y=89.993172, z=0.000249}
								}
								,{
									position	= {x=-3.788861, y=1.931636, z=2.187500}
									,rotation	= {x=-0.000767, y=89.993172, z=0.000249}
								}
								,{
									position	= {x=-2.273316, y=1.931656, z=2.187500}
									,rotation	= {x=-0.000771, y=89.993172, z=0.000246}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Dark Fog"
							,tile	= {
								{
									position	= {x=-0.758066, y=1.937532, z=-0.437331}
									,rotation	= {x=0.000234, y=210.007385, z=359.844482}
								}
								,{
									position	= {x=9.093264, y=1.937693, z=0.875009}
									,rotation	= {x=0.000742, y=269.951782, z=359.842773}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=12.882128, y=1.931837, z=7.437500}
									,rotation	= {x=-0.000766, y=90.000145, z=0.000256}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "9"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=12.124355, y=1.876026, z=8.750000}
									,rotation	= {x=-0.000259, y=179.999451, z=-0.000768}
								}
								,{
									position	= {x=11.366583, y=1.876022, z=7.437500}
									,rotation	= {x=-0.000257, y=179.999481, z=-0.000771}
								}
							}
						}
					}
				}
			}
			--Scenario 65
			,[65] = {
				--Traps
				{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Bear Trap"
							,tile	= {
								{
									position	= {x=1.515544, y=1.933945, z=17.500000}
									,rotation	= {x=-0.000765, y=89.999985, z=0.000242}
								}
								,{
									position	= {x=4.546633, y=1.933986, z=17.500000}
									,rotation	= {x=-0.000768, y=89.999985, z=0.000240}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Barrel"
							,tile	= {
								{
									position	= {x=-6.819950, y=1.933908, z=0.437500}
									,rotation	= {x=0.000767, y=269.994537, z=-0.000251}
								}
								,{
									position	= {x=12.882128, y=1.934171, z=0.437500}
									,rotation	= {x=0.000769, y=269.994537, z=-0.000246}
								}
							}
						}
						,{
							name	= "Boulder"
							,tile	= {
								{
									position	= {x=2.273317, y=1.931045, z=18.812500}
									,rotation	= {x=-0.000767, y=89.977005, z=0.000243}
								}
								,{
									position	= {x=-0.000002, y=1.931020, z=17.500000}
									,rotation	= {x=-0.000768, y=89.977005, z=0.000243}
								}
								,{
									position	= {x=6.062177, y=1.931101, z=17.500000}
									,rotation	= {x=-0.000765, y=89.976936, z=0.000243}
								}
								,{
									position	= {x=1.515545, y=1.931051, z=14.875000}
									,rotation	= {x=-0.000768, y=89.977005, z=0.000244}
								}
								,{
									position	= {x=3.031088, y=1.931072, z=14.875000}
									,rotation	= {x=-0.000768, y=89.977005, z=0.000241}
								}
								,{
									position	= {x=4.546634, y=1.931092, z=14.875000}
									,rotation	= {x=-0.000769, y=89.976982, z=0.000240}
								}
							}
						}
						,{
							name	= "Cabinet"
							,tile	= {
								{
									position	= {x=-5.304405, y=1.933939, z=-2.187500}
									,rotation	= {x=-0.000771, y=90.010635, z=0.000252}
								}
								,{
									position	= {x=11.366583, y=1.934162, z=-2.187500}
									,rotation	= {x=-0.000766, y=90.010674, z=0.000249}
								}
							}
						}
						,{
							name	= "Shelf"
							,tile	= {
								{
									position	= {x=-5.280904, y=1.933684, z=10.921728}
									,rotation	= {x=0.000168, y=209.990143, z=-0.000789}
								}
								,{
									position	= {x=12.124352, y=1.933921, z=9.624998}
									,rotation	= {x=0.000602, y=330.011688, z=0.000538}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Dark Fog"
							,tile	= {
								{
									position	= {x=-2.273349, y=1.934800, z=10.937450}
									,rotation	= {x=0.011954, y=269.988953, z=0.000710}
								}
								,{
									position	= {x=3.031111, y=1.934753, z=12.250046}
									,rotation	= {x=0.003757, y=269.989349, z=359.977753}
								}
								,{
									position	= {x=8.335532, y=1.934915, z=10.937462}
									,rotation	= {x=359.984314, y=269.989380, z=-0.003836}
								}
								,{
									position	= {x=3.031040, y=1.935780, z=1.749950}
									,rotation	= {x=0.006069, y=269.989777, z=0.018771}
								}
								,{
									position	= {x=-2.273357, y=1.935048, z=0.437530}
									,rotation	= {x=0.023452, y=269.989899, z=0.005423}
								}
								,{
									position	= {x=8.335606, y=1.935166, z=0.437513}
									,rotation	= {x=359.968353, y=269.989899, z=-0.000772}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=-0.757773, y=1.931004, z=18.812500}
									,rotation	= {x=-0.000769, y=90.000046, z=0.000238}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=-7.577722, y=1.930942, z=12.250000}
									,rotation	= {x=-0.000771, y=90.000046, z=0.000248}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=13.639901, y=1.931225, z=12.250000}
									,rotation	= {x=-0.000767, y=89.999985, z=0.000251}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=-6.819950, y=1.931014, z=-2.187500}
									,rotation	= {x=-0.000771, y=89.999985, z=0.000248}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=12.882128, y=1.931278, z=-2.187500}
									,rotation	= {x=-0.000765, y=89.999985, z=0.000248}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=0.757771, y=1.875230, z=18.812500}
									,rotation	= {x=-0.000243, y=179.999451, z=-0.000766}
								}
								,{
									position	= {x=5.304405, y=1.875290, z=18.812500}
									,rotation	= {x=-0.000237, y=179.999405, z=-0.000773}
								}
								,{
									position	= {x=6.819951, y=1.875311, z=18.812500}
									,rotation	= {x=-0.000251, y=179.999481, z=-0.000770}
								}
							}
						}
					}
				}
			}
			--Scenario 66
			,[66] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Water 1"
							,tile	= {
								{
									position	= {x=-6.562500, y=1.931533, z=17.428761}
									,rotation	= {x=0.000245, y=0.005852, z=0.000765}
								}
								,{
									position	= {x=-5.250000, y=1.931553, z=16.670988}
									,rotation	= {x=0.000247, y=0.005788, z=0.000772}
								}
								,{
									position	= {x=-3.937501, y=1.931574, z=15.913217}
									,rotation	= {x=0.000252, y=0.005792, z=0.000769}
								}
								,{
									position	= {x=-3.937500, y=1.931581, z=14.397672}
									,rotation	= {x=0.000247, y=0.005785, z=0.000771}
								}
								,{
									position	= {x=-3.937500, y=1.931601, z=9.851039}
									,rotation	= {x=0.000246, y=0.005776, z=0.000765}
								}
								,{
									position	= {x=-5.250001, y=1.931540, z=19.702078}
									,rotation	= {x=0.000243, y=0.005904, z=0.000763}
								}
								,{
									position	= {x=-3.937500, y=1.931561, z=18.944304}
									,rotation	= {x=0.000246, y=0.005968, z=0.000766}
								}
								,{
									position	= {x=-2.625000, y=1.931582, z=18.186533}
									,rotation	= {x=0.000253, y=0.005987, z=0.000773}
								}
								,{
									position	= {x=-1.312501, y=1.931610, z=15.913217}
									,rotation	= {x=0.000248, y=0.005960, z=0.000766}
								}
								,{
									position	= {x=-1.312500, y=1.931616, z=14.397671}
									,rotation	= {x=0.000245, y=0.006015, z=0.000767}
								}
								,{
									position	= {x=-1.312500, y=1.931636, z=9.851038}
									,rotation	= {x=0.000246, y=0.006108, z=0.000765}
								}
							}
						}
					}
				}
				--Corridors
				,{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Pressure Plate"
							,tile	= {
								{
									position	= {x=-2.624999, y=1.934513, z=12.124354}
									,rotation	= {x=0.000247, y=0.061499, z=0.000768}
								}
								,{
									position	= {x=2.624972, y=1.934047, z=12.124302}
									,rotation	= {x=0.000772, y=0.034417, z=0.000209}
								}
								,{
									position	= {x=6.562523, y=1.936750, z=6.819995}
									,rotation	= {x=0.026613, y=0.034412, z=359.986938}
								}
								,{
									position	= {x=2.624985, y=1.934310, z=0.000008}
									,rotation	= {x=0.005113, y=0.034415, z=0.008897}
								}
								,{
									position	= {x=-3.937484, y=1.933951, z=0.757762}
									,rotation	= {x=0.000432, y=0.034419, z=0.001253}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Bear Trap"
							,tile	= {
								{
									position	= {x=6.562546, y=1.935343, z=9.851083}
									,rotation	= {x=0.026605, y=0.000278, z=359.986908}
								}
								,{
									position	= {x=5.249996, y=1.935995, z=9.093258}
									,rotation	= {x=0.026604, y=0.000279, z=359.986908}
								}
								,{
									position	= {x=-0.000047, y=1.933902, z=-0.000040}
									,rotation	= {x=0.005125, y=0.000312, z=0.008897}
								}
								,{
									position	= {x=-0.000005, y=1.934037, z=-1.515544}
									,rotation	= {x=0.005116, y=0.000354, z=0.008893}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=-0.000009, y=1.818256, z=13.639901}
									,rotation	= {x=0.004957, y=0.009150, z=179.972702}
								}
								,{
									position	= {x=5.250000, y=1.818969, z=10.608836}
									,rotation	= {x=0.034252, y=59.855839, z=180.054260}
								}
								,{
									position	= {x=10.500000, y=1.819170, z=7.577732}
									,rotation	= {x=0.033828, y=0.187461, z=179.944000}
								}
								,{
									position	= {x=5.250003, y=1.822610, z=3.031099}
									,rotation	= {x=-0.001962, y=120.000320, z=180.016891}
								}
								,{
									position	= {x=-1.312485, y=1.817775, z=-0.757764}
									,rotation	= {x=0.002740, y=180.027023, z=180.005386}
								}
								,{
									position	= {x=5.250018, y=1.936493, z=-3.031142}
									,rotation	= {x=-0.000247, y=59.975948, z=178.281464}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=13.125005, y=1.931524, z=7.577724}
									,rotation	= {x=-0.000826, y=180.000687, z=0.001694}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "36"
									}
								}
								,{
									position	= {x=6.564363, y=1.970504, z=-5.307757}
									,rotation	= {x=1.497149, y=180.000153, z=0.864671}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "16"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=13.124284, y=1.875707, z=9.094449}
									,rotation	= {x=-0.000813, y=179.872452, z=0.001706}
								}
								,{
									position	= {x=13.124999, y=1.875751, z=6.062178}
									,rotation	= {x=-0.000819, y=179.978180, z=0.001693}
								}
								,{
									position	= {x=7.874998, y=1.914788, z=-4.546628}
									,rotation	= {x=1.497033, y=179.994446, z=0.864428}
								}
								,{
									position	= {x=5.249997, y=1.914810, z=-6.062173}
									,rotation	= {x=1.497021, y=179.994431, z=0.864422}
								}
							}
						}
					}
				}
			}
			--Scenario 67
			,[67] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Water 1"
							,tile	= {
								{
									position	= {x=-0.757775, y=1.931103, z=-3.937498}
									,rotation	= {x=-0.000769, y=89.986542, z=0.000253}
								}
								,{
									position	= {x=-1.515548, y=1.931098, z=-5.249997}
									,rotation	= {x=-0.000765, y=89.986549, z=0.000256}
								}
								,{
									position	= {x=-2.273325, y=1.931094, z=-6.562498}
									,rotation	= {x=-0.000765, y=89.986725, z=0.000256}
								}
								,{
									position	= {x=2.273315, y=1.931155, z=-6.562500}
									,rotation	= {x=-0.000767, y=89.986755, z=0.000253}
								}
								,{
									position	= {x=3.030210, y=1.931159, z=-5.245526}
									,rotation	= {x=-0.000764, y=89.986526, z=0.000256}
								}
								,{
									position	= {x=3.788855, y=1.931175, z=-6.562502}
									,rotation	= {x=-0.000765, y=89.986732, z=0.000253}
								}
								,{
									position	= {x=4.546634, y=1.931180, z=-5.250001}
									,rotation	= {x=-0.000770, y=89.986732, z=0.000252}
								}
								,{
									position	= {x=6.062172, y=1.931200, z=-5.250002}
									,rotation	= {x=-0.000767, y=89.987015, z=0.000252}
								}
								,{
									position	= {x=6.819954, y=1.931204, z=-3.937502}
									,rotation	= {x=-0.000768, y=89.986893, z=0.000256}
								}
								,{
									position	= {x=5.304404, y=1.931473, z=-1.312500}
									,rotation	= {x=-0.000768, y=89.986923, z=0.000249}
								}
								,{
									position	= {x=3.031087, y=1.931437, z=-0.000001}
									,rotation	= {x=-0.000770, y=89.986969, z=0.000249}
								}
							}
						}
					}
				}
				--Corridors
				,{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Man Stone Corridor 2"
							,tile	= {
								{
									position	= {x=3.031085, y=1.934132, z=-2.625011}
									,rotation	= {x=0.001171, y=270.006714, z=0.018217}
								}
								,{
									position	= {x=6.041407, y=1.934180, z=-2.627630}
									,rotation	= {x=0.001260, y=270.006805, z=0.019026}
								}
							}
						}
						,{
							name	= "Pressure Plate"
							,tile	= {
								{
									position	= {x=12.882124, y=1.934757, z=3.937498}
									,rotation	= {x=-0.000763, y=90.005531, z=0.000252}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Bear Trap"
							,tile	= {
								{
									position	= {x=-3.758700, y=1.933968, z=-3.938371}
									,rotation	= {x=-0.000768, y=90.042091, z=0.000252}
								}
								,{
									position	= {x=-3.031100, y=1.933983, z=-5.249997}
									,rotation	= {x=-0.000771, y=90.023849, z=0.000256}
								}
								,{
									position	= {x=-0.757775, y=1.934019, z=-6.562499}
									,rotation	= {x=-0.000765, y=90.023849, z=0.000256}
								}
								,{
									position	= {x=0.757769, y=1.934028, z=-3.937499}
									,rotation	= {x=-0.000766, y=90.023888, z=0.000253}
								}
								,{
									position	= {x=6.062175, y=1.934383, z=0.000000}
									,rotation	= {x=-0.000767, y=90.023949, z=0.000250}
								}
								,{
									position	= {x=6.819948, y=1.934399, z=-1.312500}
									,rotation	= {x=-0.000765, y=90.023979, z=0.000250}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Bookcase"
							,tile	= {
								{
									position	= {x=10.608809, y=1.934532, z=2.624999}
									,rotation	= {x=0.000600, y=330.006317, z=0.000528}
								}
								,{
									position	= {x=14.384272, y=1.934577, z=3.937261}
									,rotation	= {x=0.000163, y=209.862854, z=-0.000784}
								}
								,{
									position	= {x=10.608831, y=1.934555, z=-2.625011}
									,rotation	= {x=0.000164, y=209.991013, z=-0.000789}
								}
								,{
									position	= {x=14.383310, y=1.934611, z=-3.947820}
									,rotation	= {x=0.000600, y=329.904266, z=0.000541}
								}
							}
						}
						,{
							name	= "Boulder"
							,tile	= {
								{
									position	= {x=-2.233036, y=1.931083, z=-3.939274}
									,rotation	= {x=-0.000770, y=90.017006, z=0.000252}
								}
								,{
									position	= {x=0.000000, y=1.931119, z=-5.249999}
									,rotation	= {x=-0.000765, y=90.016991, z=0.000257}
								}
								,{
									position	= {x=3.788861, y=1.931453, z=-1.312500}
									,rotation	= {x=-0.000767, y=90.016991, z=0.000248}
								}
							}
						}
						,{
							name	= "Tree"
							,tile	= {
								{
									position	= {x=-6.819965, y=1.931677, z=1.312489}
									,rotation	= {x=-0.000772, y=89.999977, z=0.000260}
								}
								,{
									position	= {x=-3.765548, y=1.931706, z=3.936493}
									,rotation	= {x=-0.000774, y=90.000076, z=0.000266}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=-3.031114, y=1.817771, z=-2.624982}
									,rotation	= {x=-0.000679, y=90.008034, z=180.000381}
								}
							}
						}
						,{
							name	= "Stone Door Vertical"
							,tile	= {
								{
									position	= {x=7.577735, y=1.818409, z=-0.000004}
									,rotation	= {x=359.984406, y=89.998276, z=179.994019}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=12.882126, y=1.931886, z=-3.937501}
									,rotation	= {x=-0.000764, y=90.010445, z=0.000249}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "14"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=11.366582, y=1.876037, z=3.937501}
									,rotation	= {x=-0.000245, y=179.999344, z=-0.000775}
								}
								,{
									position	= {x=12.124355, y=1.876053, z=2.625000}
									,rotation	= {x=-0.000254, y=179.999420, z=-0.000760}
								}
								,{
									position	= {x=12.124355, y=1.876076, z=-2.625000}
									,rotation	= {x=-0.000255, y=179.999420, z=-0.000768}
								}
								,{
									position	= {x=11.366583, y=1.876071, z=-3.937500}
									,rotation	= {x=-0.000246, y=179.999451, z=-0.000761}
								}
							}
						}
					}
				}
			}
			--Scenario 68
			,[68] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Water 1"
							,tile	= {
								{
									position	= {x=-3.062504, y=1.931942, z=-0.757751}
									,rotation	= {x=0.011077, y=0.008341, z=0.001437}
								}
								,{
									position	= {x=-1.750000, y=1.931828, z=0.000002}
									,rotation	= {x=0.011057, y=0.008329, z=0.001421}
								}
								,{
									position	= {x=-1.753701, y=1.932123, z=-1.530643}
									,rotation	= {x=0.011057, y=0.008334, z=0.001419}
								}
								,{
									position	= {x=-3.062501, y=1.932819, z=-5.304401}
									,rotation	= {x=0.011055, y=0.008360, z=0.001417}
								}
								,{
									position	= {x=-4.374999, y=1.932933, z=-6.062173}
									,rotation	= {x=0.011061, y=0.008382, z=0.001418}
								}
								,{
									position	= {x=-0.437500, y=1.933176, z=-6.819953}
									,rotation	= {x=0.011057, y=0.008387, z=0.001418}
								}
								,{
									position	= {x=0.875000, y=1.932770, z=-4.546628}
									,rotation	= {x=0.011058, y=0.008418, z=0.001418}
								}
								,{
									position	= {x=0.875000, y=1.932478, z=-3.031085}
									,rotation	= {x=0.011059, y=0.008456, z=0.001417}
								}
								,{
									position	= {x=6.125005, y=1.930957, z=-4.546643}
									,rotation	= {x=0.007369, y=0.008456, z=-0.000851}
								}
								,{
									position	= {x=3.500000, y=1.930801, z=-3.031089}
									,rotation	= {x=0.007371, y=0.008452, z=-0.000852}
								}
								,{
									position	= {x=3.500082, y=2.046856, z=-1.515582}
									,rotation	= {x=359.984955, y=0.011471, z=-0.002185}
								}
								,{
									position	= {x=3.499979, y=2.047249, z=-0.000144}
									,rotation	= {x=359.986420, y=0.012568, z=0.004820}
								}
								,{
									position	= {x=4.812547, y=2.047148, z=-0.757837}
									,rotation	= {x=359.968994, y=0.012679, z=359.985931}
								}
								,{
									position	= {x=6.124971, y=1.931172, z=1.515603}
									,rotation	= {x=0.000249, y=0.012720, z=0.000773}
								}
								,{
									position	= {x=6.125000, y=1.931166, z=3.031089}
									,rotation	= {x=0.000246, y=0.012712, z=0.000768}
								}
								,{
									position	= {x=3.500000, y=1.931124, z=4.546633}
									,rotation	= {x=0.000252, y=0.012705, z=0.000773}
								}
								,{
									position	= {x=4.812500, y=1.931125, z=8.335494}
									,rotation	= {x=0.000249, y=0.012726, z=0.000773}
								}
								,{
									position	= {x=6.126740, y=1.931139, z=9.130989}
									,rotation	= {x=0.000245, y=0.053717, z=0.000770}
								}
								,{
									position	= {x=6.125000, y=1.931133, z=10.608815}
									,rotation	= {x=0.000249, y=0.019059, z=0.000769}
								}
								,{
									position	= {x=8.749999, y=1.931167, z=10.608809}
									,rotation	= {x=0.000242, y=0.019129, z=0.000764}
								}
							}
						}
					}
				}
				--Corridors
				,{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Earth Corridor 1"
							,tile	= {
								{
									position	= {x=4.812491, y=1.817765, z=-0.757814}
									,rotation	= {x=359.986969, y=0.004722, z=179.994064}
								}
							}
						}
						,{
							name	= "Earth Corridor 2"
							,tile	= {
								{
									position	= {x=3.500039, y=1.933654, z=-1.515559}
									,rotation	= {x=359.987579, y=0.024854, z=0.005087}
								}
								,{
									position	= {x=6.124998, y=1.933652, z=-1.515551}
									,rotation	= {x=359.985168, y=0.024960, z=0.005859}
								}
								,{
									position	= {x=7.437511, y=1.933865, z=8.335526}
									,rotation	= {x=0.000243, y=0.024970, z=0.000745}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Tree"
							,tile	= {
								{
									position	= {x=-4.375003, y=1.933323, z=-4.546615}
									,rotation	= {x=0.011054, y=0.005572, z=0.001414}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "LIght Fog"
							,tile	= {
								{
									position	= {x=2.187559, y=1.936169, z=-3.788839}
									,rotation	= {x=359.988892, y=180.000122, z=0.025338}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=-7.000001, y=1.931991, z=-1.515526}
									,rotation	= {x=359.988953, y=180.000656, z=-0.001416}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "33"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 69
			,[69] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Log"
							,tile	= {
								{
									position	= {x=-4.374797, y=1.933761, z=-4.546278}
									,rotation	= {x=-0.000793, y=120.024101, z=-0.000168}
								}
								,{
									position	= {x=-0.437509, y=1.933805, z=-2.273300}
									,rotation	= {x=-0.000542, y=59.996429, z=0.000602}
								}
							}
						}
					}
				}
				--Corridors
				,{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Pressure Plate"
							,tile	= {
								{
									position	= {x=7.437477, y=1.934124, z=-5.304338}
									,rotation	= {x=0.000251, y=359.988159, z=0.000760}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Bear Trap"
							,tile	= {
								{
									position	= {x=-3.062503, y=1.934551, z=2.273314}
									,rotation	= {x=0.000253, y=0.015033, z=0.000770}
								}
								,{
									position	= {x=-3.062503, y=1.934538, z=5.304405}
									,rotation	= {x=0.000248, y=0.015048, z=0.000768}
								}
								,{
									position	= {x=-1.750000, y=1.934545, z=7.577724}
									,rotation	= {x=0.000242, y=0.015060, z=0.000771}
								}
								,{
									position	= {x=0.875001, y=1.934574, z=9.093267}
									,rotation	= {x=0.000249, y=0.014917, z=0.000771}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Bush 1"
							,tile	= {
								{
									position	= {x=-7.000000, y=1.931014, z=-3.031089}
									,rotation	= {x=-0.000246, y=179.991531, z=-0.000776}
								}
								,{
									position	= {x=-7.000000, y=1.931028, z=-6.062178}
									,rotation	= {x=-0.000250, y=179.991531, z=-0.000774}
								}
								,{
									position	= {x=-0.437499, y=1.931120, z=-6.819950}
									,rotation	= {x=-0.000250, y=180.016586, z=-0.000770}
								}
							}
						}
						,{
							name	= "Stone Pillar"
							,tile	= {
								{
									position	= {x=4.812500, y=1.931744, z=3.788861}
									,rotation	= {x=0.000252, y=0.023864, z=0.000763}
								}
								,{
									position	= {x=6.125000, y=1.931758, z=4.546631}
									,rotation	= {x=0.000247, y=0.023909, z=0.000759}
								}
								,{
									position	= {x=6.125000, y=1.931751, z=6.062178}
									,rotation	= {x=0.000250, y=0.023901, z=0.000758}
								}
								,{
									position	= {x=7.437500, y=1.931779, z=3.788861}
									,rotation	= {x=0.000248, y=0.023893, z=0.000761}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=3.500000, y=1.818416, z=7.577723}
									,rotation	= {x=-0.000542, y=60.519512, z=180.000534}
								}
							}
						}
						,{
							name	= "Stone Door Vertical"
							,tile	= {
								{
									position	= {x=-3.062499, y=1.818260, z=-0.757769}
									,rotation	= {x=359.972626, y=0.005093, z=179.990891}
								}
							}
						}
					}
				}
			}
			--Scenario 70
			,[70] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Log"
							,tile	= {
								{
									position	= {x=5.304403, y=1.933866, z=1.312623}
									,rotation	= {x=-0.000767, y=90.004921, z=0.000257}
								}
								,{
									position	= {x=2.273313, y=1.933849, z=-3.937500}
									,rotation	= {x=-0.000604, y=150.008499, z=-0.000535}
								}
								,{
									position	= {x=12.882128, y=1.933993, z=-3.937500}
									,rotation	= {x=-0.000611, y=150.008499, z=-0.000537}
								}
							}
						}
					}
				}
				--Corridors
				,{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Earth Corridor 1"
							,tile	= {
								{
									position	= {x=9.093267, y=1.817924, z=0.000002}
									,rotation	= {x=-0.000872, y=90.081657, z=180.000305}
								}
								,{
									position	= {x=9.093266, y=1.817947, z=-5.250000}
									,rotation	= {x=-0.000927, y=90.017036, z=180.000351}
								}
							}
						}
						,{
							name	= "Earth Corridor 2"
							,tile	= {
								{
									position	= {x=8.335526, y=1.933906, z=1.301723}
									,rotation	= {x=-0.000821, y=90.000130, z=0.000259}
								}
								,{
									position	= {x=8.335493, y=1.933918, z=-1.312500}
									,rotation	= {x=-0.000838, y=90.000130, z=0.000272}
								}
								,{
									position	= {x=9.093266, y=1.933935, z=-2.625000}
									,rotation	= {x=-0.000854, y=90.000191, z=0.000246}
								}
								,{
									position	= {x=8.335494, y=1.933929, z=-3.937501}
									,rotation	= {x=-0.000853, y=90.000130, z=0.000278}
								}
								,{
									position	= {x=8.335495, y=1.933940, z=-6.562501}
									,rotation	= {x=-0.000874, y=90.000099, z=0.000298}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Spike Trap"
							,tile	= {
								{
									position	= {x=-2.273317, y=1.927970, z=9.187503}
									,rotation	= {x=-0.000764, y=89.988182, z=0.000244}
								}
								,{
									position	= {x=-1.515547, y=1.927997, z=5.250000}
									,rotation	= {x=-0.000765, y=89.988251, z=0.000245}
								}
								,{
									position	= {x=2.273315, y=1.931387, z=9.187500}
									,rotation	= {x=-0.000762, y=89.988297, z=0.000252}
								}
								,{
									position	= {x=3.031089, y=1.931391, z=10.500001}
									,rotation	= {x=-0.000762, y=89.988274, z=0.000249}
								}
								,{
									position	= {x=10.608810, y=1.931782, z=13.125002}
									,rotation	= {x=-0.000764, y=89.988319, z=0.000241}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Boulder"
							,tile	= {
								{
									position	= {x=6.819950, y=1.931748, z=9.187499}
									,rotation	= {x=-0.000768, y=90.008598, z=0.000242}
								}
								,{
									position	= {x=8.335485, y=1.931768, z=9.187500}
									,rotation	= {x=-0.000764, y=90.008873, z=0.000245}
								}
								,{
									position	= {x=9.851037, y=1.931788, z=9.187500}
									,rotation	= {x=-0.000763, y=90.008934, z=0.000245}
								}
								,{
									position	= {x=9.093265, y=1.931773, z=10.500000}
									,rotation	= {x=-0.000765, y=90.008995, z=0.000244}
								}
								,{
									position	= {x=9.851039, y=1.931777, z=11.812500}
									,rotation	= {x=-0.000765, y=90.008995, z=0.000244}
								}
							}
						}
						,{
							name	= "Tree"
							,tile	= {
								{
									position	= {x=3.794950, y=1.931835, z=-1.308395}
									,rotation	= {x=-0.000768, y=89.948677, z=0.000259}
								}
								,{
									position	= {x=9.093266, y=2.047913, z=-2.625000}
									,rotation	= {x=-0.000835, y=89.982178, z=0.000280}
								}
								,{
									position	= {x=13.639897, y=1.931971, z=-1.750001}
									,rotation	= {x=0.000766, y=269.987610, z=-0.000271}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Dark Fog"
							,tile	= {
								{
									position	= {x=5.304344, y=1.935182, z=9.187466}
									,rotation	= {x=0.001979, y=149.989395, z=359.983032}
								}
								,{
									position	= {x=9.851031, y=1.935241, z=6.562507}
									,rotation	= {x=0.010846, y=270.008606, z=0.015388}
								}
								,{
									position	= {x=9.093257, y=1.934952, z=2.625012}
									,rotation	= {x=0.004543, y=270.007324, z=0.015977}
								}
							}
						}
					}
				}
				--Hazardous Terrain
				,{
					bag	 	= Bag_HazardousTerrain_GUID
					,type	= {
						{
							name	= "Thorns"
							,tile	= {
								{
									position	= {x=4.546549, y=1.931157, z=0.000008}
									,rotation	= {x=-0.000766, y=90.009392, z=0.000253}
								}
								,{
									position	= {x=7.577723, y=1.931209, z=-2.625000}
									,rotation	= {x=-0.000766, y=90.009369, z=0.000253}
								}
								,{
									position	= {x=11.366583, y=1.931244, z=1.312500}
									,rotation	= {x=-0.000770, y=90.009369, z=0.000263}
								}
								,{
									position	= {x=12.124355, y=1.931284, z=-5.250000}
									,rotation	= {x=-0.000764, y=90.009369, z=0.000265}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=-4.546635, y=1.927957, z=5.250000}
									,rotation	= {x=-0.000764, y=90.000069, z=0.000247}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "6"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=-5.304405, y=1.872135, z=9.187500}
									,rotation	= {x=-0.000247, y=179.999420, z=-0.000766}
								}
								,{
									position	= {x=-3.788861, y=1.872178, z=3.937500}
									,rotation	= {x=-0.000251, y=179.999435, z=-0.000760}
								}
								,{
									position	= {x=-2.273316, y=1.872186, z=6.562500}
									,rotation	= {x=-0.000238, y=179.999405, z=-0.000765}
								}
								,{
									position	= {x=3.776351, y=1.875624, z=6.545933}
									,rotation	= {x=-0.000248, y=179.999619, z=-0.000765}
								}
								,{
									position	= {x=7.577722, y=1.875946, z=13.125000}
									,rotation	= {x=-0.000250, y=179.999634, z=-0.000763}
								}
								,{
									position	= {x=12.124356, y=1.876018, z=10.500000}
									,rotation	= {x=-0.000265, y=179.999573, z=-0.000790}
								}
								,{
									position	= {x=12.882128, y=1.875756, z=3.937500}
									,rotation	= {x=-0.000250, y=179.999573, z=-0.000771}
								}
							}
						}
					}
				}
			}
			--Scenario 71
			,[71] = {
				--Corridors
				{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Earth Corridor 1"
							,tile	= {
								{
									position	= {x=2.625000, y=1.817764, z=16.670988}
									,rotation	= {x=0.000254, y=-0.000217, z=180.000763}
								}
								,{
									position	= {x=5.250000, y=1.817799, z=16.670988}
									,rotation	= {x=0.000205, y=-0.000219, z=180.000778}
								}
								,{
									position	= {x=2.625000, y=1.817797, z=9.093267}
									,rotation	= {x=0.000239, y=-0.000246, z=180.000763}
								}
							}
						}
						,{
							name	= "Earth Corridor 2"
							,tile	= {
								{
									position	= {x=-2.625000, y=1.933708, z=13.639900}
									,rotation	= {x=0.000244, y=0.025781, z=0.000803}
								}
								,{
									position	= {x=1.312502, y=1.933754, z=15.913218}
									,rotation	= {x=0.000083, y=0.025710, z=0.000474}
								}
								,{
									position	= {x=3.937502, y=1.933789, z=15.913217}
									,rotation	= {x=0.000058, y=0.025729, z=0.000474}
								}
								,{
									position	= {x=3.937499, y=1.933818, z=8.335496}
									,rotation	= {x=0.000254, y=0.025779, z=0.000768}
								}
								,{
									position	= {x=1.312536, y=1.934071, z=2.273313}
									,rotation	= {x=-0.001433, y=0.025571, z=359.983612}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Spike Trap"
							,tile	= {
								{
									position	= {x=-5.250003, y=1.930973, z=12.124355}
									,rotation	= {x=0.000249, y=359.990509, z=0.000767}
								}
								,{
									position	= {x=1.312508, y=2.047028, z=15.913214}
									,rotation	= {x=-0.000940, y=359.990509, z=-0.002085}
								}
								,{
									position	= {x=5.249994, y=1.931081, z=19.702078}
									,rotation	= {x=0.000249, y=359.990509, z=0.000771}
								}
								,{
									position	= {x=3.937500, y=1.931099, z=11.366583}
									,rotation	= {x=0.000251, y=359.990509, z=0.000755}
								}
								,{
									position	= {x=2.625000, y=1.931105, z=6.062178}
									,rotation	= {x=0.000260, y=359.990479, z=0.000767}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Bush 1"
							,tile	= {
								{
									position	= {x=3.937524, y=2.047063, z=15.913206}
									,rotation	= {x=-0.000958, y=359.991241, z=-0.002082}
								}
								,{
									position	= {x=2.624994, y=1.931098, z=7.577725}
									,rotation	= {x=0.000259, y=359.991241, z=0.000770}
								}
							}
						}
						,{
							name	= "Tree"
							,tile	= {
								{
									position	= {x=1.312500, y=1.931734, z=14.397672}
									,rotation	= {x=-0.000249, y=179.976715, z=-0.000754}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Dark Fog"
							,tile	= {
								{
									position	= {x=7.874938, y=1.934905, z=13.639902}
									,rotation	= {x=0.002914, y=180.000336, z=359.990692}
								}
								,{
									position	= {x=11.812562, y=1.935263, z=3.788853}
									,rotation	= {x=0.006354, y=180.000229, z=0.022236}
								}
								,{
									position	= {x=2.624945, y=1.934867, z=-1.515512}
									,rotation	= {x=359.989746, y=180.000259, z=-0.004841}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=5.250000, y=1.931075, z=21.217621}
									,rotation	= {x=-0.000252, y=180.000702, z=-0.000771}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=-6.562500, y=1.930952, z=12.882128}
									,rotation	= {x=-0.000245, y=180.000702, z=-0.000765}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=-1.312500, y=1.931382, z=-0.757772}
									,rotation	= {x=-0.000247, y=180.000717, z=-0.000767}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 72
			,[72] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Log"
							,tile	= {
								{
									position	= {x=-6.819933, y=1.933706, z=1.312509}
									,rotation	= {x=-0.000604, y=149.996094, z=-0.000537}
								}
								,{
									position	= {x=-2.273359, y=2.050092, z=-1.312481}
									,rotation	= {x=0.008582, y=209.995041, z=359.985992}
								}
								,{
									position	= {x=10.608809, y=1.933966, z=-5.250000}
									,rotation	= {x=0.000164, y=209.995026, z=-0.000795}
								}
							}
						}
					}
				}
				--Corridors
				,{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Earth Corridor 1"
							,tile	= {
								{
									position	= {x=7.577718, y=1.818420, z=-2.625009}
									,rotation	= {x=359.971436, y=269.994690, z=179.990463}
								}
							}
						}
						,{
							name	= "Earth Corridor 2"
							,tile	= {
								{
									position	= {x=-0.757803, y=1.934605, z=-1.311980}
									,rotation	= {x=0.020135, y=269.968658, z=359.993317}
								}
								,{
									position	= {x=-1.515544, y=1.934312, z=-2.625028}
									,rotation	= {x=0.015763, y=269.968628, z=0.008073}
								}
								,{
									position	= {x=-0.757781, y=1.934616, z=-3.937470}
									,rotation	= {x=0.020090, y=269.968628, z=359.993286}
								}
								,{
									position	= {x=8.335577, y=1.934217, z=-1.312522}
									,rotation	= {x=359.980988, y=269.968689, z=0.005337}
								}
								,{
									position	= {x=8.335549, y=1.934265, z=-3.937513}
									,rotation	= {x=359.986298, y=269.968445, z=0.010342}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Boulder"
							,tile	= {
								{
									position	= {x=-4.546633, y=1.931049, z=-2.625000}
									,rotation	= {x=-0.000767, y=90.007828, z=0.000257}
								}
								,{
									position	= {x=0.757772, y=1.931712, z=-1.312499}
									,rotation	= {x=-0.000772, y=90.007820, z=0.000251}
								}
								,{
									position	= {x=3.788862, y=1.931764, z=-3.937500}
									,rotation	= {x=-0.000768, y=90.007813, z=0.000252}
								}
								,{
									position	= {x=6.819966, y=2.047954, z=-3.937508}
									,rotation	= {x=0.017891, y=90.007759, z=359.994141}
								}
								,{
									position	= {x=9.851039, y=1.931222, z=1.312500}
									,rotation	= {x=-0.000767, y=90.007698, z=0.000253}
								}
								,{
									position	= {x=13.639898, y=1.931290, z=-2.625000}
									,rotation	= {x=-0.000763, y=90.007751, z=0.000256}
								}
							}
						}
						,{
							name	= "Bush 1"
							,tile	= {
								{
									position	= {x=-6.819950, y=1.931012, z=-1.312501}
									,rotation	= {x=-0.000770, y=90.005280, z=0.000253}
								}
								,{
									position	= {x=-3.031089, y=1.931080, z=-5.250000}
									,rotation	= {x=-0.000768, y=90.005280, z=0.000252}
								}
								,{
									position	= {x=1.515545, y=1.931739, z=-5.250000}
									,rotation	= {x=-0.000767, y=90.005280, z=0.000253}
								}
								,{
									position	= {x=5.304406, y=1.931773, z=-1.312500}
									,rotation	= {x=-0.000767, y=90.005264, z=0.000255}
								}
								,{
									position	= {x=9.093267, y=1.931229, z=-2.625001}
									,rotation	= {x=-0.000770, y=90.005226, z=0.000253}
								}
								,{
									position	= {x=12.882128, y=1.931274, z=-1.312500}
									,rotation	= {x=-0.000767, y=90.005226, z=0.000254}
								}
							}
						}
						,{
							name	= "Tree"
							,tile	= {
								{
									position	= {x=-6.819951, y=1.931718, z=-6.562500}
									,rotation	= {x=0.000767, y=269.987091, z=-0.000253}
								}
								,{
									position	= {x=2.274657, y=1.932403, z=1.314732}
									,rotation	= {x=-0.000769, y=90.454071, z=0.000252}
								}
								,{
									position	= {x=14.397670, y=1.932000, z=-6.562501}
									,rotation	= {x=0.000767, y=269.986847, z=-0.000260}
								}
							}
						}
					}
				}
			}
			--Scenario 73
			,[73] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Rubble"
							,tile	= {
								{
									position	= {x=0.757764, y=1.931712, z=-1.312492}
									,rotation	= {x=-0.000768, y=89.999847, z=0.000253}
								}
								,{
									position	= {x=1.515542, y=1.931728, z=-2.624999}
									,rotation	= {x=-0.000766, y=89.999847, z=0.000255}
								}
								,{
									position	= {x=0.757770, y=1.931724, z=-3.937500}
									,rotation	= {x=-0.000766, y=89.999863, z=0.000256}
								}
								,{
									position	= {x=5.304403, y=1.931773, z=-1.312500}
									,rotation	= {x=-0.000764, y=89.999870, z=0.000257}
								}
								,{
									position	= {x=4.546632, y=1.931768, z=-2.625001}
									,rotation	= {x=-0.000767, y=89.999893, z=0.000255}
								}
								,{
									position	= {x=5.304406, y=1.931784, z=-3.937502}
									,rotation	= {x=-0.000764, y=89.999908, z=0.000256}
								}
							}
						}
					}
				}
				--Corridors
				,{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Earth Corridor 1"
							,tile	= {
								{
									position	= {x=-1.515539, y=1.818298, z=-2.624993}
									,rotation	= {x=0.030069, y=269.995361, z=179.990616}
								}
							}
						}
						,{
							name	= "Earth Corridor 2"
							,tile	= {
								{
									position	= {x=-0.757777, y=1.934468, z=-1.312521}
									,rotation	= {x=0.006975, y=269.994385, z=-0.001131}
								}
								,{
									position	= {x=-0.757715, y=1.934429, z=-3.937536}
									,rotation	= {x=0.002529, y=269.994965, z=-0.000486}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Spike Trap"
							,tile	= {
								{
									position	= {x=-0.000007, y=1.931708, z=-2.624993}
									,rotation	= {x=-0.000767, y=90.009003, z=0.000252}
								}
								,{
									position	= {x=3.788859, y=1.931752, z=-1.312500}
									,rotation	= {x=-0.000767, y=90.009003, z=0.000255}
								}
								,{
									position	= {x=3.788861, y=1.931764, z=-3.937501}
									,rotation	= {x=-0.000767, y=90.009026, z=0.000254}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Boulder"
							,tile	= {
								{
									position	= {x=-0.757801, y=2.047808, z=-1.312461}
									,rotation	= {x=359.989227, y=90.012764, z=0.001185}
								}
								,{
									position	= {x=-1.515607, y=2.047661, z=-2.624975}
									,rotation	= {x=359.966522, y=90.013046, z=0.011913}
								}
								,{
									position	= {x=-0.757735, y=2.047819, z=-3.937566}
									,rotation	= {x=359.989227, y=90.013954, z=0.001201}
								}
								,{
									position	= {x=6.819970, y=1.931793, z=-1.312502}
									,rotation	= {x=-0.000767, y=90.013985, z=0.000255}
								}
								,{
									position	= {x=6.062178, y=1.931789, z=-2.625000}
									,rotation	= {x=-0.000764, y=90.013947, z=0.000260}
								}
								,{
									position	= {x=6.819951, y=1.931805, z=-3.937501}
									,rotation	= {x=-0.000766, y=90.013885, z=0.000257}
								}
							}
						}
						,{
							name	= "Boulder 3"
							,tile	= {
								{
									position	= {x=-3.795259, y=1.934646, z=1.312794}
									,rotation	= {x=-0.000769, y=90.044029, z=0.000255}
								}
								,{
									position	= {x=2.279926, y=2.049841, z=1.312253}
									,rotation	= {x=2.916941, y=90.079742, z=0.015885}
								}
								,{
									position	= {x=-2.273319, y=1.934701, z=-6.562495}
									,rotation	= {x=0.000769, y=270.119446, z=-0.000253}
								}
								,{
									position	= {x=3.788617, y=1.935382, z=-6.563966}
									,rotation	= {x=0.000824, y=270.111267, z=-0.000257}
								}
							}
						}
						,{
							name	= "Dark Pit"
							,tile	= {
								{
									position	= {x=1.515530, y=1.934421, z=0.000016}
									,rotation	= {x=0.000604, y=330.017456, z=0.000538}
								}
								,{
									position	= {x=4.546626, y=1.934462, z=0.000007}
									,rotation	= {x=-0.000164, y=30.006552, z=0.000802}
								}
								,{
									position	= {x=1.513313, y=1.934445, z=-5.234485}
									,rotation	= {x=0.000167, y=210.316162, z=-0.000795}
								}
								,{
									position	= {x=4.546688, y=1.934485, z=-5.249935}
									,rotation	= {x=-0.000606, y=150.017273, z=-0.000532}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Dark Fog"
							,tile	= {
								{
									position	= {x=7.578274, y=1.935240, z=-2.625009}
									,rotation	= {x=359.727448, y=270.011536, z=-0.000442}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=9.093266, y=1.928163, z=0.000000}
									,rotation	= {x=-0.000774, y=90.000015, z=0.000251}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=13.639900, y=1.928236, z=-2.625000}
									,rotation	= {x=-0.000775, y=90.000015, z=0.000247}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=9.093266, y=1.928186, z=-5.250000}
									,rotation	= {x=-0.000776, y=90.000015, z=0.000248}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 74
			,[74] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Water 1"
							,tile	= {
								{
									position	= {x=-1.515545, y=1.931034, z=9.625002}
									,rotation	= {x=-0.000766, y=89.994545, z=0.000248}
								}
								,{
									position	= {x=-0.000002, y=1.931055, z=9.624999}
									,rotation	= {x=-0.000769, y=89.994591, z=0.000248}
								}
								,{
									position	= {x=1.515536, y=1.931075, z=9.624999}
									,rotation	= {x=-0.000765, y=89.994873, z=0.000251}
								}
								,{
									position	= {x=-2.273317, y=1.931030, z=8.312500}
									,rotation	= {x=-0.000766, y=89.994873, z=0.000248}
								}
								,{
									position	= {x=-0.757774, y=1.931050, z=8.312500}
									,rotation	= {x=-0.000766, y=89.994926, z=0.000250}
								}
								,{
									position	= {x=0.757770, y=1.931070, z=8.312500}
									,rotation	= {x=-0.000767, y=89.995010, z=0.000251}
								}
								,{
									position	= {x=2.273315, y=1.931091, z=8.312500}
									,rotation	= {x=-0.000768, y=89.995049, z=0.000250}
								}
								,{
									position	= {x=-1.515546, y=1.931046, z=7.000000}
									,rotation	= {x=-0.000765, y=89.995110, z=0.000250}
								}
								,{
									position	= {x=0.000000, y=1.931066, z=7.000000}
									,rotation	= {x=-0.000765, y=89.995110, z=0.000251}
								}
								,{
									position	= {x=1.515542, y=1.931086, z=7.000000}
									,rotation	= {x=-0.000765, y=89.995163, z=0.000251}
								}
								,{
									position	= {x=-2.273316, y=1.931041, z=5.687500}
									,rotation	= {x=-0.000766, y=89.995163, z=0.000250}
								}
								,{
									position	= {x=2.273316, y=1.931102, z=5.687500}
									,rotation	= {x=-0.000765, y=89.995163, z=0.000250}
								}
							}
						}
					}
				}
				--Corridors
				,{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Wooden Corridor 1"
							,tile	= {
								{
									position	= {x=-0.000001, y=1.817782, z=4.375000}
									,rotation	= {x=-0.000775, y=89.992310, z=180.000229}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Barrel"
							,tile	= {
								{
									position	= {x=-3.031091, y=1.933987, z=-6.125002}
									,rotation	= {x=-0.000763, y=89.991394, z=0.000253}
								}
								,{
									position	= {x=2.273317, y=1.934053, z=-4.812500}
									,rotation	= {x=-0.000767, y=89.991386, z=0.000242}
								}
								,{
									position	= {x=5.304404, y=1.934082, z=-2.187499}
									,rotation	= {x=-0.000769, y=89.991417, z=0.000240}
								}
							}
						}
						,{
							name	= "Table"
							,tile	= {
								{
									position	= {x=-6.062181, y=1.933735, z=-3.500000}
									,rotation	= {x=-0.000600, y=150.005463, z=-0.000536}
								}
								,{
									position	= {x=6.819951, y=1.933913, z=-4.812502}
									,rotation	= {x=0.000175, y=210.006180, z=-0.000785}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Wooden Door Horizontal"
							,tile	= {
								{
									position	= {x=-3.031090, y=1.817765, z=-0.875000}
									,rotation	= {x=-0.000790, y=90.000107, z=180.000168}
								}
								,{
									position	= {x=3.031089, y=1.817846, z=-0.874999}
									,rotation	= {x=-0.000759, y=90.000130, z=180.000214}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=-0.757772, y=1.931118, z=-7.437500}
									,rotation	= {x=-0.000765, y=90.000015, z=0.000250}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "20"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=-8.335494, y=1.875199, z=-2.187506}
									,rotation	= {x=-0.000246, y=179.999771, z=-0.000760}
								}
								,{
									position	= {x=-6.062178, y=1.875247, z=-6.125000}
									,rotation	= {x=-0.000249, y=179.999802, z=-0.000763}
								}
								,{
									position	= {x=-0.757773, y=1.875312, z=-4.812500}
									,rotation	= {x=-0.000253, y=179.999756, z=-0.000771}
								}
								,{
									position	= {x=3.788862, y=1.875384, z=-7.437500}
									,rotation	= {x=-0.000232, y=179.999741, z=-0.000767}
								}
								,{
									position	= {x=6.819951, y=1.875403, z=-2.187501}
									,rotation	= {x=-0.000236, y=179.999603, z=-0.000762}
								}
								,{
									position	= {x=7.577723, y=1.875429, z=-6.125001}
									,rotation	= {x=-0.000242, y=179.999649, z=-0.000779}
								}
							}
						}
					}
				}
			}
			--Scenario 75
			,[75] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Log"
							,tile	= {
								{
									position	= {x=-5.304406, y=1.933743, z=-2.187500}
									,rotation	= {x=-0.000592, y=150.003738, z=-0.000542}
								}
								,{
									position	= {x=3.031089, y=1.933845, z=-0.874999}
									,rotation	= {x=0.000171, y=210.005310, z=-0.000800}
								}
								,{
									position	= {x=2.273317, y=1.933818, z=3.062500}
									,rotation	= {x=0.000768, y=269.985474, z=-0.000251}
								}
							}
						}
					}
				}
				--Corridors
				,{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Earth Corridor 1"
							,tile	= {
								{
									position	= {x=-1.515545, y=1.817786, z=-0.875000}
									,rotation	= {x=0.000538, y=269.960175, z=179.999680}
								}
								,{
									position	= {x=-1.518362, y=1.817809, z=-6.113586}
									,rotation	= {x=0.000593, y=269.946899, z=179.999695}
								}
							}
						}
						,{
							name	= "Earth Corridor 2"
							,tile	= {
								{
									position	= {x=-0.757774, y=1.933790, z=0.437496}
									,rotation	= {x=0.000587, y=269.994781, z=-0.000225}
								}
								,{
									position	= {x=-0.757772, y=1.933801, z=-2.187501}
									,rotation	= {x=0.000604, y=269.994781, z=-0.000215}
								}
								,{
									position	= {x=0.000082, y=1.933815, z=-3.499886}
									,rotation	= {x=0.000643, y=269.996124, z=-0.000277}
								}
								,{
									position	= {x=-0.757825, y=1.933812, z=-4.812569}
									,rotation	= {x=0.000655, y=269.992645, z=-0.000234}
								}
								,{
									position	= {x=-0.757768, y=1.933824, z=-7.437508}
									,rotation	= {x=0.000639, y=269.994080, z=-0.000228}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Poison Gas"
							,tile	= {
								{
									position	= {x=-4.546637, y=1.931042, z=-0.874997}
									,rotation	= {x=-0.000765, y=89.994522, z=0.000242}
								}
								,{
									position	= {x=0.757771, y=1.931115, z=-2.187500}
									,rotation	= {x=-0.000773, y=89.994537, z=0.000247}
								}
								,{
									position	= {x=-2.273316, y=2.047101, z=-7.437502}
									,rotation	= {x=-0.000682, y=89.994522, z=0.000005}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Sarcophagus A"
							,tile	= {
								{
									position	= {x=-6.830494, y=1.933685, z=5.703793}
									,rotation	= {x=-0.000768, y=89.701889, z=0.000270}
								}
								,{
									position	= {x=-6.062178, y=1.933749, z=-6.125002}
									,rotation	= {x=-0.000592, y=150.003967, z=-0.000540}
								}
								,{
									position	= {x=0.757773, y=1.933786, z=5.687502}
									,rotation	= {x=-0.000770, y=89.994728, z=0.000251}
								}
							}
						}
						,{
							name	= "Stone Pillar"
							,tile	= {
								{
									position	= {x=-7.577723, y=1.931002, z=-0.874999}
									,rotation	= {x=-0.000767, y=89.995102, z=0.000240}
								}
								,{
									position	= {x=-2.273212, y=2.047088, z=-4.812487}
									,rotation	= {x=-0.000694, y=89.994736, z=0.000194}
								}
								,{
									position	= {x=-0.744377, y=2.047080, z=0.436826}
									,rotation	= {x=-0.000408, y=89.994736, z=0.000010}
								}
								,{
									position	= {x=0.757770, y=1.931138, z=-7.437500}
									,rotation	= {x=-0.000771, y=90.012306, z=0.000251}
								}
								,{
									position	= {x=3.788861, y=1.931167, z=-4.812500}
									,rotation	= {x=-0.000770, y=90.012329, z=0.000248}
								}
								,{
									position	= {x=5.304405, y=1.931154, z=3.062500}
									,rotation	= {x=-0.000769, y=90.012329, z=0.000253}
								}
							}
						}
						,{
							name	= "Stump"
							,tile	= {
								{
									position	= {x=-8.335495, y=1.930972, z=3.062500}
									,rotation	= {x=-0.000771, y=90.221756, z=0.000261}
								}
								,{
									position	= {x=-3.788861, y=1.931033, z=3.062500}
									,rotation	= {x=-0.000768, y=90.006844, z=0.000266}
								}
								,{
									position	= {x=-2.273317, y=2.047068, z=0.437499}
									,rotation	= {x=-0.000637, y=90.006828, z=-0.000016}
								}
								,{
									position	= {x=1.515544, y=1.931142, z=-6.125000}
									,rotation	= {x=-0.000772, y=90.006866, z=0.000249}
								}
								,{
									position	= {x=6.819950, y=1.931163, z=5.687500}
									,rotation	= {x=-0.000768, y=90.006866, z=0.000251}
								}
							}
						}
						,{
							name	= "Tree"
							,tile	= {
								{
									position	= {x=-6.815658, y=1.931722, z=-7.431324}
									,rotation	= {x=0.000769, y=270.031647, z=-0.000240}
								}
								,{
									position	= {x=-1.511438, y=2.047776, z=-3.501777}
									,rotation	= {x=-0.000625, y=89.822189, z=0.000243}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "LIght Fog"
							,tile	= {
								{
									position	= {x=-6.062180, y=1.934515, z=1.750002}
									,rotation	= {x=0.000816, y=270.008575, z=-0.000452}
								}
								,{
									position	= {x=3.031090, y=1.934634, z=1.750001}
									,rotation	= {x=0.000762, y=270.008575, z=-0.000220}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=5.304403, y=1.931199, z=-7.437500}
									,rotation	= {x=-0.000774, y=90.000046, z=0.000247}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "53"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 76
			,[76] = {
				--Traps
				{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Poison Gas"
							,tile	= {
								{
									position	= {x=-1.312500, y=1.927993, z=6.819950}
									,rotation	= {x=0.000250, y=-0.005444, z=0.000767}
								}
								,{
									position	= {x=3.937500, y=1.931713, z=8.335494}
									,rotation	= {x=0.000249, y=-0.005449, z=0.000775}
								}
								,{
									position	= {x=7.875000, y=1.931782, z=4.546633}
									,rotation	= {x=0.000248, y=-0.005459, z=0.000774}
								}
								,{
									position	= {x=3.937500, y=1.931159, z=-2.273318}
									,rotation	= {x=0.000255, y=-0.005418, z=0.000759}
								}
								,{
									position	= {x=7.875000, y=1.931221, z=-4.546635}
									,rotation	= {x=0.000250, y=-0.005362, z=0.000772}
								}
								,{
									position	= {x=10.500000, y=1.931237, z=0.000000}
									,rotation	= {x=0.000249, y=-0.005364, z=0.000769}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Rock Column"
							,tile	= {
								{
									position	= {x=10.500000, y=1.934709, z=7.577722}
									,rotation	= {x=0.000250, y=0.031442, z=0.000774}
								}
								,{
									position	= {x=-5.250015, y=1.934231, z=-0.000007}
									,rotation	= {x=0.000248, y=0.034779, z=0.000771}
								}
								,{
									position	= {x=9.187500, y=1.934147, z=-5.304405}
									,rotation	= {x=0.000248, y=0.034769, z=0.000768}
								}
							}
						}
						,{
							name	= "Stalagmites"
							,tile	= {
								{
									position	= {x=-1.312501, y=1.930885, z=9.851039}
									,rotation	= {x=0.000247, y=0.030713, z=0.000765}
								}
								,{
									position	= {x=3.937500, y=1.934637, z=3.788861}
									,rotation	= {x=0.000247, y=0.004752, z=0.000768}
								}
								,{
									position	= {x=2.625001, y=1.934050, z=-3.031090}
									,rotation	= {x=0.000250, y=0.004742, z=0.000758}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=-6.562500, y=1.931312, z=-0.757772}
									,rotation	= {x=-0.000250, y=180.000656, z=-0.000771}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "75"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=-6.562500, y=1.875504, z=2.273314}
									,rotation	= {x=-0.000243, y=179.999435, z=-0.000783}
								}
								,{
									position	= {x=-6.562499, y=1.875530, z=-3.788833}
									,rotation	= {x=-0.000241, y=179.999207, z=-0.000771}
								}
							}
						}
					}
				}
			}
			--Scenario 77
			,[77] = {
				--Corridors
				{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Pressure Plate"
							,tile	= {
								{
									position	= {x=3.031086, y=1.934073, z=-7.000001}
									,rotation	= {x=-0.000764, y=90.005592, z=0.000264}
								}
								,{
									position	= {x=4.546632, y=1.934093, z=-7.000001}
									,rotation	= {x=-0.000768, y=90.005592, z=0.000262}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Bear Trap"
							,tile	= {
								{
									position	= {x=1.515543, y=1.934595, z=6.124999}
									,rotation	= {x=-0.000764, y=90.005432, z=0.000249}
								}
								,{
									position	= {x=4.546631, y=1.934624, z=8.750000}
									,rotation	= {x=-0.000763, y=90.005486, z=0.000252}
								}
								,{
									position	= {x=5.304405, y=1.934652, z=4.812500}
									,rotation	= {x=-0.000765, y=90.005486, z=0.000249}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Barrel"
							,tile	= {
								{
									position	= {x=7.577724, y=1.934098, z=0.875002}
									,rotation	= {x=-0.000764, y=89.991493, z=0.000266}
								}
								,{
									position	= {x=6.819950, y=1.934093, z=-0.437498}
									,rotation	= {x=-0.000771, y=89.991508, z=0.000262}
								}
							}
						}
						,{
							name	= "Bookcase"
							,tile	= {
								{
									position	= {x=-6.062178, y=1.933728, z=-1.750000}
									,rotation	= {x=0.000768, y=270.005493, z=-0.000240}
								}
								,{
									position	= {x=-3.031089, y=1.933780, z=-4.375000}
									,rotation	= {x=0.000768, y=270.005463, z=-0.000241}
								}
								,{
									position	= {x=12.124355, y=1.933983, z=-4.374999}
									,rotation	= {x=0.000767, y=270.005432, z=-0.000270}
								}
								,{
									position	= {x=15.155444, y=1.934011, z=-1.750000}
									,rotation	= {x=0.000768, y=270.005432, z=-0.000263}
								}
							}
						}
						,{
							name	= "Stone Pillar"
							,tile	= {
								{
									position	= {x=3.788861, y=1.931715, z=7.437500}
									,rotation	= {x=-0.000769, y=90.009399, z=0.000248}
								}
								,{
									position	= {x=3.788861, y=1.931160, z=-3.062500}
									,rotation	= {x=-0.000771, y=90.009399, z=0.000264}
								}
							}
						}
						,{
							name	= "Table"
							,tile	= {
								{
									position	= {x=1.515542, y=1.933841, z=-4.375002}
									,rotation	= {x=0.000763, y=269.991455, z=-0.000266}
								}
								,{
									position	= {x=7.557871, y=1.933921, z=-4.303880}
									,rotation	= {x=0.000764, y=269.991455, z=-0.000259}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=3.788866, y=1.818359, z=2.187499}
									,rotation	= {x=0.009465, y=270.001465, z=180.023544}
								}
							}
						}
						,{
							name	= "Stone Door Vertical"
							,tile	= {
								{
									position	= {x=-2.273321, y=1.817784, z=-3.062505}
									,rotation	= {x=-0.000721, y=89.991501, z=180.000259}
								}
								,{
									position	= {x=9.898804, y=1.817947, z=-2.999526}
									,rotation	= {x=-0.000794, y=89.991394, z=180.000259}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=-6.819950, y=1.931008, z=-0.437502}
									,rotation	= {x=-0.000769, y=89.999969, z=0.000239}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=14.397673, y=1.931290, z=-0.437500}
									,rotation	= {x=-0.000765, y=89.999969, z=0.000266}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=-6.819949, y=1.875224, z=-3.062497}
									,rotation	= {x=-0.000236, y=179.999619, z=-0.000770}
								}
								,{
									position	= {x=-7.577717, y=1.875219, z=-4.374996}
									,rotation	= {x=-0.000240, y=179.999832, z=-0.000763}
								}
								,{
									position	= {x=14.397672, y=1.875508, z=-3.062500}
									,rotation	= {x=-0.000264, y=179.999878, z=-0.000766}
								}
								,{
									position	= {x=15.155444, y=1.875524, z=-4.375000}
									,rotation	= {x=-0.000263, y=179.999908, z=-0.000765}
								}
							}
						}
					}
				}
			}
			--Scenario 78
			,[78] = {
				--Obstacles
				{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Altar Vertical"
							,tile	= {
								{
									position	= {x=-0.000002, y=1.931125, z=-7.875001}
									,rotation	= {x=0.000853, y=270.004944, z=-0.000265}
								}
								,{
									position	= {x=1.515545, y=1.931147, z=-7.874999}
									,rotation	= {x=0.000849, y=270.004944, z=-0.000267}
								}
							}
						}
						,{
							name	= "Boulder"
							,tile	= {
								{
									position	= {x=-7.577723, y=1.930562, z=7.875000}
									,rotation	= {x=-0.000777, y=90.008560, z=0.000249}
								}
								,{
									position	= {x=-6.062178, y=1.930606, z=2.625000}
									,rotation	= {x=-0.000777, y=90.008560, z=0.000251}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=-0.757738, y=1.935905, z=-1.312581}
									,rotation	= {x=-0.000893, y=89.990417, z=180.637283}
								}
								,{
									position	= {x=0.757807, y=1.935838, z=-1.311804}
									,rotation	= {x=-0.000766, y=89.984406, z=180.635910}
								}
								,{
									position	= {x=2.273357, y=1.935947, z=-1.311710}
									,rotation	= {x=-0.000728, y=89.977440, z=180.637344}
								}
							}
						}
						,{
							name	= "Stone Door Vertical"
							,tile	= {
								{
									position	= {x=-3.788098, y=1.875550, z=3.953809}
									,rotation	= {x=355.919373, y=89.995453, z=180.643982}
								}
							}
						}
					}
				}
			}
			--Scenario 79
			,[79] = {
				--Corridors
				{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Man Stone Corridor 2"
							,tile	= {
								{
									position	= {x=6.062210, y=1.934389, z=15.750024}
									,rotation	= {x=0.000568, y=269.994324, z=359.975006}
								}
								,{
									position	= {x=2.273795, y=1.937002, z=-1.312225}
									,rotation	= {x=0.000482, y=329.996613, z=359.828674}
								}
								,{
									position	= {x=9.093242, y=1.937092, z=0.000028}
									,rotation	= {x=0.000227, y=209.998260, z=359.828522}
								}
							}
						}
						,{
							name	= "Pressure Plate"
							,tile	= {
								{
									position	= {x=-4.546633, y=1.937180, z=0.000000}
									,rotation	= {x=-0.000764, y=90.005455, z=0.000253}
								}
								,{
									position	= {x=-1.515544, y=1.937244, z=-5.250000}
									,rotation	= {x=-0.000763, y=90.005455, z=0.000254}
								}
								,{
									position	= {x=15.155444, y=1.937445, z=0.000000}
									,rotation	= {x=-0.000770, y=90.005455, z=0.000258}
								}
								,{
									position	= {x=12.124355, y=1.937428, z=-5.250000}
									,rotation	= {x=-0.000770, y=90.005455, z=0.000256}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Poison Gas"
							,tile	= {
								{
									position	= {x=6.062178, y=1.931725, z=13.125000}
									,rotation	= {x=-0.000561, y=89.994537, z=0.000563}
								}
								,{
									position	= {x=6.062178, y=1.931777, z=7.875000}
									,rotation	= {x=-0.000560, y=89.994537, z=0.000562}
								}
							}
						}
						,{
							name	= "Spike Trap"
							,tile	= {
								{
									position	= {x=-2.273318, y=1.934312, z=-1.312500}
									,rotation	= {x=-0.000763, y=89.991760, z=0.000253}
								}
								,{
									position	= {x=-1.515546, y=1.934327, z=-2.625000}
									,rotation	= {x=-0.000766, y=89.991814, z=0.000250}
								}
								,{
									position	= {x=3.788861, y=1.931732, z=-1.312501}
									,rotation	= {x=-0.000943, y=89.991814, z=-0.000156}
								}
								,{
									position	= {x=6.819951, y=1.931782, z=-1.312500}
									,rotation	= {x=-0.000943, y=89.991821, z=-0.000155}
								}
								,{
									position	= {x=12.124353, y=1.934511, z=-2.624999}
									,rotation	= {x=-0.000775, y=89.991882, z=0.000255}
								}
								,{
									position	= {x=12.882128, y=1.934515, z=-1.312500}
									,rotation	= {x=-0.000769, y=89.991882, z=0.000256}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Stone Pillar"
							,tile	= {
								{
									position	= {x=-0.757772, y=1.934320, z=1.312500}
									,rotation	= {x=-0.000762, y=90.005417, z=0.000252}
								}
								,{
									position	= {x=-0.757772, y=1.934332, z=-1.312500}
									,rotation	= {x=-0.000764, y=90.005417, z=0.000251}
								}
								,{
									position	= {x=1.515545, y=1.934368, z=-2.625000}
									,rotation	= {x=-0.000763, y=90.005432, z=0.000252}
								}
								,{
									position	= {x=9.093266, y=1.934470, z=-2.625000}
									,rotation	= {x=-0.000776, y=90.005432, z=0.000255}
								}
								,{
									position	= {x=11.366583, y=1.934495, z=-1.312500}
									,rotation	= {x=-0.000771, y=90.005432, z=0.000254}
								}
								,{
									position	= {x=11.366583, y=1.934483, z=1.312500}
									,rotation	= {x=-0.000771, y=90.005432, z=0.000254}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=6.062177, y=1.818503, z=5.250000}
									,rotation	= {x=-0.000192, y=89.991631, z=179.999344}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=5.304405, y=1.931081, z=19.687500}
									,rotation	= {x=-0.000768, y=90.000000, z=0.000256}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "52"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=4.546633, y=1.875271, z=21.000000}
									,rotation	= {x=-0.000251, y=179.999435, z=-0.000770}
								}
								,{
									position	= {x=6.062178, y=1.875291, z=21.000000}
									,rotation	= {x=-0.000255, y=179.999435, z=-0.000762}
								}
								,{
									position	= {x=3.788861, y=1.875266, z=19.687500}
									,rotation	= {x=-0.000252, y=179.999420, z=-0.000767}
								}
								,{
									position	= {x=6.819951, y=1.875307, z=19.687500}
									,rotation	= {x=-0.000255, y=179.999420, z=-0.000767}
								}
								,{
									position	= {x=-6.819952, y=1.878444, z=1.312502}
									,rotation	= {x=-0.000255, y=179.999557, z=-0.000761}
								}
								,{
									position	= {x=-1.515544, y=1.878556, z=-7.875000}
									,rotation	= {x=-0.000258, y=179.999588, z=-0.000758}
								}
								,{
									position	= {x=12.124356, y=1.878739, z=-7.874998}
									,rotation	= {x=-0.000254, y=179.999313, z=-0.000766}
								}
								,{
									position	= {x=17.428761, y=1.878770, z=1.312501}
									,rotation	= {x=-0.000254, y=179.999207, z=-0.000771}
								}
							}
						}
					}
				}
			}
			--Scenario 80
			,[80] = {
				--Corridors
				{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Man Stone Corridor 1"
							,tile	= {
								{
									position	= {x=-3.031098, y=1.818009, z=-4.375002}
									,rotation	= {x=0.004696, y=90.009392, z=180.012009}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Bear Trap"
							,tile	= {
								{
									position	= {x=-4.546636, y=1.934537, z=0.875000}
									,rotation	= {x=-0.000770, y=90.005356, z=0.000249}
								}
								,{
									position	= {x=-1.515542, y=1.934578, z=0.875001}
									,rotation	= {x=-0.000771, y=90.005257, z=0.000245}
								}
								,{
									position	= {x=-1.515545, y=1.933931, z=11.375000}
									,rotation	= {x=-0.000769, y=90.005257, z=0.000247}
								}
								,{
									position	= {x=6.819947, y=1.934664, z=10.062500}
									,rotation	= {x=-0.000986, y=90.005318, z=0.000064}
								}
								,{
									position	= {x=11.366583, y=1.934743, z=10.062500}
									,rotation	= {x=-0.000985, y=90.005318, z=0.000064}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Boulder"
							,tile	= {
								{
									position	= {x=-2.273307, y=1.931573, z=-0.437562}
									,rotation	= {x=0.004866, y=90.005997, z=359.967682}
								}
								,{
									position	= {x=-0.757783, y=1.931053, z=7.437566}
									,rotation	= {x=-0.000766, y=90.005981, z=0.000251}
								}
								,{
									position	= {x=-3.031089, y=1.931005, z=11.375000}
									,rotation	= {x=-0.000772, y=90.005981, z=0.000251}
								}
								,{
									position	= {x=6.062178, y=1.931745, z=11.375000}
									,rotation	= {x=-0.000986, y=90.005981, z=0.000064}
								}
								,{
									position	= {x=9.093266, y=1.931800, z=8.750000}
									,rotation	= {x=-0.000985, y=90.005981, z=0.000068}
								}
								,{
									position	= {x=12.882128, y=1.931867, z=7.437500}
									,rotation	= {x=-0.000987, y=90.005981, z=0.000063}
								}
							}
						}
						,{
							name	= "Bush 1"
							,tile	= {
								{
									position	= {x=5.302685, y=1.971064, z=2.186452}
									,rotation	= {x=359.255859, y=89.980309, z=359.571198}
								}
								,{
									position	= {x=7.576891, y=2.010426, z=3.499572}
									,rotation	= {x=359.255859, y=89.983391, z=359.571167}
								}
								,{
									position	= {x=7.577004, y=1.990771, z=0.874637}
									,rotation	= {x=359.255890, y=89.986473, z=359.571136}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=-3.031085, y=1.818228, z=6.124987}
									,rotation	= {x=0.005606, y=270.001221, z=179.967087}
								}
								,{
									position	= {x=9.850872, y=1.936090, z=4.812412}
									,rotation	= {x=359.952271, y=150.335785, z=187.799866}
								}
							}
						}
						,{
							name	= "Stone Door Vertical"
							,tile	= {
								{
									position	= {x=1.515544, y=1.818268, z=11.374999}
									,rotation	= {x=359.971527, y=90.009407, z=179.990295}
								}
							}
						}
						,{
							name	= "Wooden Door Horizontal"
							,tile	= {
								{
									position	= {x=9.852348, y=1.896895, z=-0.438313}
									,rotation	= {x=359.259460, y=30.018316, z=174.770142}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=-3.788864, y=1.930978, z=15.312500}
									,rotation	= {x=-0.000767, y=90.000099, z=0.000247}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=0.000000, y=1.931035, z=14.000000}
									,rotation	= {x=-0.000767, y=90.000099, z=0.000250}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=-5.304405, y=1.930981, z=10.062500}
									,rotation	= {x=-0.000767, y=90.000069, z=0.000250}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=0.757773, y=1.931073, z=7.437499}
									,rotation	= {x=-0.000771, y=90.000076, z=0.000247}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=-5.304446, y=1.875163, z=15.312517}
									,rotation	= {x=-0.000251, y=179.999786, z=-0.000768}
								}
								,{
									position	= {x=-2.273316, y=1.875204, z=15.312500}
									,rotation	= {x=-0.000248, y=179.999786, z=-0.000774}
								}
								,{
									position	= {x=-4.546633, y=1.875179, z=14.000000}
									,rotation	= {x=-0.000254, y=179.999786, z=-0.000769}
								}
								,{
									position	= {x=11.367487, y=1.875455, z=-0.437037}
									,rotation	= {x=-0.000250, y=180.014450, z=-0.000757}
								}
								,{
									position	= {x=9.851039, y=1.875447, z=-3.062500}
									,rotation	= {x=-0.000243, y=180.014435, z=-0.000772}
								}
								,{
									position	= {x=15.155445, y=1.875512, z=-1.749999}
									,rotation	= {x=-0.000250, y=180.014450, z=-0.000774}
								}
								,{
									position	= {x=12.882128, y=1.875499, z=-5.687500}
									,rotation	= {x=-0.000260, y=180.014465, z=-0.000769}
								}
							}
						}
					}
				}
			}
			--Scenario 81
			,[81] = {
				--Traps
				{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Poison Gas"
							,tile	= {
								{
									position	= {x=-5.687500, y=1.931571, z=11.366583}
									,rotation	= {x=0.000250, y=0.008463, z=0.000776}
								}
								,{
									position	= {x=-7.000002, y=1.931583, z=4.546634}
									,rotation	= {x=0.000247, y=0.008507, z=0.000775}
								}
								,{
									position	= {x=-4.375000, y=1.931618, z=4.546633}
									,rotation	= {x=0.000244, y=0.008546, z=0.000778}
								}
								,{
									position	= {x=-3.062505, y=1.931679, z=-5.304404}
									,rotation	= {x=0.000242, y=0.009036, z=0.000776}
								}
								,{
									position	= {x=-1.743393, y=1.931700, z=-6.044917}
									,rotation	= {x=0.000249, y=359.966888, z=0.000775}
								}
								,{
									position	= {x=-0.437500, y=1.931714, z=-5.304406}
									,rotation	= {x=0.000247, y=359.966858, z=0.000776}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Altar Horizontal"
							,tile	= {
								{
									position	= {x=2.187501, y=1.931709, z=3.788861}
									,rotation	= {x=0.000246, y=0.000026, z=0.000766}
								}
							}
						}
						,{
							name	= "Stone Pillar"
							,tile	= {
								{
									position	= {x=-5.687500, y=1.931564, z=12.882128}
									,rotation	= {x=0.000249, y=0.031519, z=0.000773}
								}
								,{
									position	= {x=-5.687501, y=1.931577, z=9.851039}
									,rotation	= {x=0.000247, y=0.031519, z=0.000775}
								}
								,{
									position	= {x=-7.000000, y=1.931602, z=0.000000}
									,rotation	= {x=0.000246, y=0.031513, z=0.000777}
								}
								,{
									position	= {x=-1.750000, y=1.931687, z=-3.031096}
									,rotation	= {x=0.000243, y=0.031785, z=0.000774}
								}
								,{
									position	= {x=-1.750000, y=1.931693, z=-4.546633}
									,rotation	= {x=0.000247, y=0.031797, z=0.000777}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=0.875001, y=1.818427, z=-3.031089}
									,rotation	= {x=0.000829, y=299.988678, z=180.000076}
								}
							}
						}
						,{
							name	= "Stone Door Vertical"
							,tile	= {
								{
									position	= {x=-5.687500, y=1.818302, z=5.304408}
									,rotation	= {x=-0.000271, y=179.990601, z=179.999222}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=-7.000000, y=1.931550, z=12.124355}
									,rotation	= {x=-0.000248, y=180.000671, z=-0.000770}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=-7.000000, y=1.931609, z=-1.515545}
									,rotation	= {x=-0.000246, y=180.000656, z=-0.000778}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
								,{
									position	= {x=-0.437500, y=1.931680, z=2.273317}
									,rotation	= {x=-0.000249, y=180.000671, z=-0.000769}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "68"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=-7.000001, y=1.875761, z=10.608811}
									,rotation	= {x=-0.000245, y=179.999344, z=-0.000773}
								}
								,{
									position	= {x=-4.375000, y=1.875863, z=-4.546634}
									,rotation	= {x=-0.000243, y=179.999374, z=-0.000775}
								}
								,{
									position	= {x=-3.062500, y=1.875877, z=-3.788862}
									,rotation	= {x=-0.000258, y=179.999481, z=-0.000780}
								}
								,{
									position	= {x=-0.437500, y=1.875898, z=-0.757772}
									,rotation	= {x=-0.000252, y=179.999527, z=-0.000763}
								}
								,{
									position	= {x=-0.437500, y=1.875892, z=0.757772}
									,rotation	= {x=-0.000244, y=179.999557, z=-0.000771}
								}
							}
						}
					}
				}
			}
			--Scenario 82
			,[82] = {
				--Corridors
				{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Man Stone Corridor 1"
							,tile	= {
								{
									position	= {x=1.515546, y=1.817768, z=12.250002}
									,rotation	= {x=0.000819, y=270.001801, z=179.999741}
								}
								,{
									position	= {x=1.515546, y=1.817780, z=9.625002}
									,rotation	= {x=0.000785, y=270.002014, z=179.999741}
								}
								,{
									position	= {x=1.514485, y=1.818399, z=4.375916}
									,rotation	= {x=0.034226, y=269.982666, z=179.980637}
								}
							}
						}
						,{
							name	= "Man Stone Corridor 2"
							,tile	= {
								{
									position	= {x=2.273314, y=1.933773, z=13.562512}
									,rotation	= {x=0.000803, y=270.002014, z=-0.000266}
								}
								,{
									position	= {x=2.273316, y=1.933785, z=10.937370}
									,rotation	= {x=0.000795, y=270.002075, z=-0.000234}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Spike Trap"
							,tile	= {
								{
									position	= {x=-3.788863, y=1.931020, z=5.687503}
									,rotation	= {x=-0.000773, y=90.008438, z=0.000256}
								}
								,{
									position	= {x=-2.273318, y=1.931040, z=5.687501}
									,rotation	= {x=-0.000764, y=90.008484, z=0.000250}
								}
								,{
									position	= {x=-0.757773, y=1.931072, z=3.062500}
									,rotation	= {x=-0.000766, y=90.008537, z=0.000249}
								}
								,{
									position	= {x=-3.031090, y=1.931048, z=1.750000}
									,rotation	= {x=-0.000766, y=90.008575, z=0.000249}
								}
								,{
									position	= {x=-2.273317, y=1.934316, z=-2.187500}
									,rotation	= {x=-0.000764, y=90.008575, z=0.000247}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=-3.031092, y=1.817730, z=6.999999}
									,rotation	= {x=0.000756, y=269.691437, z=179.999847}
								}
								,{
									position	= {x=-2.273334, y=1.820674, z=0.437317}
									,rotation	= {x=0.000739, y=269.997955, z=179.805878}
								}
								,{
									position	= {x=5.304416, y=1.818341, z=8.312591}
									,rotation	= {x=0.006225, y=269.999420, z=179.968216}
								}
								,{
									position	= {x=5.304409, y=1.820839, z=0.437488}
									,rotation	= {x=0.000840, y=269.999603, z=179.843109}
								}
							}
						}
						,{
							name	= "Stone Door Vertical"
							,tile	= {
								{
									position	= {x=-0.000005, y=1.817782, z=4.375008}
									,rotation	= {x=-0.000764, y=88.899025, z=180.000259}
								}
								,{
									position	= {x=3.010820, y=1.818422, z=4.380181}
									,rotation	= {x=-0.003486, y=269.941833, z=179.999802}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=0.757889, y=2.047058, z=10.937541}
									,rotation	= {x=-0.000965, y=90.001472, z=-0.000042}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "62"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=-6.819951, y=1.875150, z=13.562500}
									,rotation	= {x=-0.000250, y=179.999344, z=-0.000756}
								}
								,{
									position	= {x=6.819951, y=1.875334, z=13.562500}
									,rotation	= {x=-0.000238, y=179.999374, z=-0.000778}
								}
								,{
									position	= {x=1.515545, y=1.991468, z=12.250000}
									,rotation	= {x=-0.000267, y=179.999344, z=-0.000791}
								}
								,{
									position	= {x=0.000008, y=1.875247, z=12.250001}
									,rotation	= {x=-0.000262, y=179.999222, z=-0.000771}
								}
								,{
									position	= {x=-0.757771, y=1.875243, z=10.937500}
									,rotation	= {x=-0.000262, y=179.999313, z=-0.000769}
								}
								,{
									position	= {x=0.000000, y=1.875260, z=9.625000}
									,rotation	= {x=-0.000269, y=179.999344, z=-0.000776}
								}
								,{
									position	= {x=1.515545, y=1.991480, z=9.625000}
									,rotation	= {x=-0.000261, y=179.999344, z=-0.000794}
								}
								,{
									position	= {x=2.273317, y=1.991284, z=10.937500}
									,rotation	= {x=-0.000297, y=179.999313, z=-0.000735}
								}
								,{
									position	= {x=4.560539, y=1.875932, z=6.992048}
									,rotation	= {x=-0.000256, y=179.999939, z=-0.000773}
								}
								,{
									position	= {x=7.577722, y=1.875983, z=4.375000}
									,rotation	= {x=-0.000251, y=179.999939, z=-0.000768}
								}
								,{
									position	= {x=8.335496, y=1.875999, z=3.062499}
									,rotation	= {x=-0.000257, y=179.999924, z=-0.000763}
								}
								,{
									position	= {x=4.546633, y=1.875954, z=1.749998}
									,rotation	= {x=-0.000264, y=179.999802, z=-0.000759}
								}
							}
						}
					}
				}
			}
			--Scenario 83
			,[83] = {
				--Obstacles
				{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Altar Vertical"
							,tile	= {
								{
									position	= {x=-0.000002, y=1.931712, z=-3.500002}
									,rotation	= {x=0.000767, y=270.003571, z=-0.000253}
								}
							}
						}
						,{
							name	= "Stone Pillar"
							,tile	= {
								{
									position	= {x=-3.031093, y=1.931036, z=4.375000}
									,rotation	= {x=-0.000742, y=90.005508, z=0.000241}
								}
								,{
									position	= {x=3.031089, y=1.931115, z=4.374998}
									,rotation	= {x=-0.000744, y=90.005539, z=0.000240}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=0.000000, y=1.818274, z=9.624997}
									,rotation	= {x=0.004077, y=89.992096, z=179.974411}
								}
								,{
									position	= {x=-0.000002, y=1.818316, z=1.750006}
									,rotation	= {x=0.006122, y=89.991982, z=180.022675}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=-3.788862, y=1.875237, z=3.062501}
									,rotation	= {x=-0.000232, y=179.998978, z=-0.000743}
								}
								,{
									position	= {x=-2.273315, y=1.875257, z=3.062499}
									,rotation	= {x=-0.000236, y=179.999084, z=-0.000743}
								}
								,{
									position	= {x=2.273324, y=1.875315, z=3.062492}
									,rotation	= {x=-0.000241, y=179.999222, z=-0.000741}
								}
								,{
									position	= {x=3.788867, y=1.875335, z=3.062494}
									,rotation	= {x=-0.000241, y=179.999725, z=-0.000728}
								}
							}
						}
					}
				}
			}
			--Scenario 84
			,[84] = {
				--Traps
				{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Spike Trap"
							,tile	= {
								{
									position	= {x=-2.625004, y=1.931081, z=-4.546633}
									,rotation	= {x=0.000246, y=359.991669, z=0.000766}
								}
								,{
									position	= {x=0.000000, y=1.931109, z=-3.031089}
									,rotation	= {x=0.000250, y=359.991669, z=0.000773}
								}
								,{
									position	= {x=2.625000, y=1.931151, z=-4.546635}
									,rotation	= {x=0.000246, y=359.991730, z=0.000768}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Crystal"
							,tile	= {
								{
									position	= {x=-0.000001, y=1.931123, z=-6.062177}
									,rotation	= {x=0.000247, y=-0.000001, z=0.000767}
								}
							}
						}
						,{
							name	= "Stalagmites"
							,tile	= {
								{
									position	= {x=-6.562502, y=1.934230, z=-3.788861}
									,rotation	= {x=0.000253, y=-0.000001, z=0.000772}
								}
								,{
									position	= {x=0.000000, y=1.930924, z=3.031089}
									,rotation	= {x=0.000285, y=-0.000002, z=0.000924}
								}
								,{
									position	= {x=6.562500, y=1.934406, z=-3.788861}
									,rotation	= {x=0.000251, y=-0.000002, z=0.000758}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=0.000000, y=1.928004, z=6.062178}
									,rotation	= {x=-0.000286, y=180.000702, z=-0.000926}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "42"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=-7.874999, y=1.875503, z=-1.515543}
									,rotation	= {x=-0.000240, y=179.999954, z=-0.000765}
								}
								,{
									position	= {x=-7.875000, y=1.875530, z=-7.577722}
									,rotation	= {x=-0.000253, y=179.999954, z=-0.000764}
								}
								,{
									position	= {x=-3.937500, y=1.875272, z=-5.304405}
									,rotation	= {x=-0.000241, y=179.999969, z=-0.000776}
								}
								,{
									position	= {x=-3.937500, y=1.875278, z=-6.819950}
									,rotation	= {x=-0.000252, y=179.999954, z=-0.000777}
								}
								,{
									position	= {x=3.937501, y=1.875377, z=-5.304405}
									,rotation	= {x=-0.000248, y=179.999924, z=-0.000764}
								}
								,{
									position	= {x=3.937500, y=1.875384, z=-6.819950}
									,rotation	= {x=-0.000241, y=179.999939, z=-0.000757}
								}
								,{
									position	= {x=7.875000, y=1.875714, z=-1.515544}
									,rotation	= {x=-0.000238, y=179.999924, z=-0.000755}
								}
								,{
									position	= {x=7.875000, y=1.875740, z=-7.577722}
									,rotation	= {x=-0.000253, y=179.999908, z=-0.000762}
								}
							}
						}
					}
				}
			}
			--Scenario 85
			,[85] = {
				--Corridors
				{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Man Stone Corridor 2"
							,tile	= {
								{
									position	= {x=0.757770, y=1.934356, z=12.687502}
									,rotation	= {x=0.000601, y=330.015747, z=0.000541}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Bear Trap"
							,tile	= {
								{
									position	= {x=-4.546637, y=1.933914, z=6.124976}
									,rotation	= {x=-0.000765, y=90.011932, z=0.000242}
								}
								,{
									position	= {x=-3.031090, y=1.933934, z=6.125000}
									,rotation	= {x=-0.000766, y=90.011993, z=0.000240}
								}
								,{
									position	= {x=3.788861, y=1.933622, z=7.437500}
									,rotation	= {x=-0.000774, y=90.011993, z=0.000252}
								}
								,{
									position	= {x=5.304404, y=1.933643, z=7.437500}
									,rotation	= {x=-0.000774, y=90.012047, z=0.000250}
								}
								,{
									position	= {x=6.819950, y=1.933663, z=7.437500}
									,rotation	= {x=-0.000773, y=90.012047, z=0.000249}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Altar Vertical"
							,tile	= {
								{
									position	= {x=-3.031090, y=1.931606, z=11.375002}
									,rotation	= {x=-0.000772, y=89.994423, z=0.000249}
								}
								,{
									position	= {x=3.788861, y=1.931680, z=15.312500}
									,rotation	= {x=-0.000767, y=89.994423, z=0.000249}
								}
							}
						}
						,{
							name	= "Boulder"
							,tile	= {
								{
									position	= {x=-3.031093, y=1.931063, z=-1.750002}
									,rotation	= {x=-0.000764, y=90.006485, z=0.000252}
								}
								,{
									position	= {x=-3.788861, y=1.931070, z=-5.687500}
									,rotation	= {x=-0.000765, y=90.006485, z=0.000251}
								}
								,{
									position	= {x=3.031089, y=1.931156, z=-4.375000}
									,rotation	= {x=-0.000770, y=90.006485, z=0.000247}
								}
								,{
									position	= {x=6.062178, y=1.931208, z=-7.000001}
									,rotation	= {x=-0.000763, y=90.006485, z=0.000255}
								}
							}
						}
						,{
							name	= "Stone Pillar"
							,tile	= {
								{
									position	= {x=-5.304405, y=1.931004, z=4.812501}
									,rotation	= {x=-0.000765, y=90.005463, z=0.000242}
								}
								,{
									position	= {x=-2.273317, y=1.931045, z=4.812500}
									,rotation	= {x=-0.000767, y=90.005463, z=0.000241}
								}
								,{
									position	= {x=-5.304405, y=1.931015, z=2.187500}
									,rotation	= {x=-0.000768, y=90.005463, z=0.000242}
								}
								,{
									position	= {x=-2.273316, y=1.931056, z=2.187500}
									,rotation	= {x=-0.000765, y=90.005463, z=0.000244}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=-3.788858, y=1.818197, z=7.437494}
									,rotation	= {x=0.017263, y=270.001923, z=180.029526}
								}
								,{
									position	= {x=-3.788856, y=1.817752, z=-0.437493}
									,rotation	= {x=0.000789, y=270.002167, z=179.999725}
								}
								,{
									position	= {x=4.546632, y=1.818365, z=11.375005}
									,rotation	= {x=0.004041, y=270.002594, z=180.053207}
								}
								,{
									position	= {x=4.546635, y=1.817800, z=-1.749997}
									,rotation	= {x=0.004384, y=270.003479, z=179.979233}
								}
							}
						}
					}
				}
			}
			--Scenario 86
			,[86] = {
				--Corridors
				{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Earth Corridor 1"
							,tile	= {
								{
									position	= {x=3.937498, y=1.818432, z=11.366580}
									,rotation	= {x=-0.002789, y=-0.000112, z=180.004730}
								}
							}
						}
						,{
							name	= "Earth Corridor 2"
							,tile	= {
								{
									position	= {x=2.624991, y=1.934368, z=10.608813}
									,rotation	= {x=-0.002153, y=0.025238, z=0.002088}
								}
								,{
									position	= {x=5.250014, y=1.935851, z=16.670961}
									,rotation	= {x=359.984558, y=0.024093, z=0.005235}
								}
							}
						}
						,{
							name	= "Wooden Corridor 1"
							,tile	= {
								{
									position	= {x=3.937500, y=1.818446, z=2.273317}
									,rotation	= {x=0.000023, y=-0.000152, z=180.000717}
								}
							}
						}
						,{
							name	= "Wooden Corridor 2"
							,tile	= {
								{
									position	= {x=5.250000, y=1.934463, z=1.515545}
									,rotation	= {x=0.000105, y=0.022358, z=0.000808}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Barrel"
							,tile	= {
								{
									position	= {x=7.875000, y=1.934713, z=-1.515545}
									,rotation	= {x=0.000259, y=0.011454, z=0.000779}
								}
								,{
									position	= {x=10.500000, y=1.934749, z=-1.515545}
									,rotation	= {x=0.000258, y=0.011455, z=0.000774}
								}
							}
						}
						,{
							name	= "Cabinet"
							,tile	= {
								{
									position	= {x=-3.937500, y=1.933912, z=8.335496}
									,rotation	= {x=0.000251, y=359.990173, z=0.000770}
								}
								,{
									position	= {x=10.500000, y=1.934115, z=4.546633}
									,rotation	= {x=0.000154, y=359.990173, z=0.000730}
								}
							}
						}
						,{
							name	= "Crate B"
							,tile	= {
								{
									position	= {x=6.562499, y=1.931121, z=15.913216}
									,rotation	= {x=-0.000085, y=0.013039, z=0.000987}
								}
								,{
									position	= {x=7.875000, y=1.931143, z=15.155444}
									,rotation	= {x=-0.000085, y=0.013042, z=0.000990}
								}
							}
						}
						,{
							name	= "Fountain"
							,tile	= {
								{
									position	= {x=3.937500, y=1.931721, z=6.819950}
									,rotation	= {x=0.000267, y=-0.000010, z=0.000772}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Wooden Door Horizontal"
							,tile	= {
								{
									position	= {x=-1.312499, y=1.818252, z=6.819949}
									,rotation	= {x=0.004503, y=179.991119, z=179.967880}
								}
								,{
									position	= {x=9.187490, y=1.818428, z=6.819948}
									,rotation	= {x=0.005903, y=0.010586, z=179.976593}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=-5.250000, y=1.875191, z=9.093266}
									,rotation	= {x=-0.000250, y=179.999969, z=-0.000770}
								}
								,{
									position	= {x=-6.562500, y=1.875191, z=5.304405}
									,rotation	= {x=-0.000264, y=179.999969, z=-0.000768}
								}
								,{
									position	= {x=14.437500, y=1.875459, z=6.819950}
									,rotation	= {x=-0.000145, y=179.999908, z=-0.000731}
								}
								,{
									position	= {x=14.437500, y=1.875463, z=5.304405}
									,rotation	= {x=-0.000157, y=179.999954, z=-0.000725}
								}
							}
						}
					}
				}
			}
			--Scenario 87
			,[87] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Water 1"
							,tile	= {
								{
									position	= {x=-7.437503, y=1.931606, z=-2.273316}
									,rotation	= {x=0.000250, y=359.991516, z=0.000768}
								}
								,{
									position	= {x=-6.125000, y=1.931621, z=-1.515546}
									,rotation	= {x=0.000245, y=359.991577, z=0.000766}
								}
								,{
									position	= {x=-4.812500, y=1.931635, z=-0.757772}
									,rotation	= {x=0.000252, y=359.991577, z=0.000771}
								}
								,{
									position	= {x=1.750000, y=1.931085, z=7.577722}
									,rotation	= {x=0.000256, y=359.991577, z=0.000767}
								}
								,{
									position	= {x=8.312500, y=1.931177, z=6.819949}
									,rotation	= {x=0.000254, y=359.991669, z=0.000770}
								}
								,{
									position	= {x=8.312500, y=1.931230, z=-5.304407}
									,rotation	= {x=0.000249, y=359.991730, z=0.000768}
								}
							}
						}
					}
				}
				--Corridors
				,{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Stone Corridor 1"
							,tile	= {
								{
									position	= {x=1.749995, y=1.817818, z=1.515540}
									,rotation	= {x=0.000306, y=0.026003, z=180.000778}
								}
								,{
									position	= {x=4.375000, y=1.817853, z=1.515544}
									,rotation	= {x=0.000300, y=0.026007, z=180.000763}
								}
								,{
									position	= {x=7.000000, y=1.817888, z=1.515544}
									,rotation	= {x=0.000318, y=0.026019, z=180.000793}
								}
							}
						}
						,{
							name	= "Stone Corridor 2"
							,tile	= {
								{
									position	= {x=0.437499, y=1.933804, z=0.757767}
									,rotation	= {x=0.000292, y=0.032881, z=0.000777}
								}
								,{
									position	= {x=3.062508, y=1.933839, z=0.757769}
									,rotation	= {x=0.000282, y=0.032961, z=0.000758}
								}
								,{
									position	= {x=5.687500, y=1.933874, z=0.757772}
									,rotation	= {x=0.000285, y=0.032941, z=0.000757}
								}
								,{
									position	= {x=8.312506, y=1.933910, z=0.757764}
									,rotation	= {x=0.000279, y=0.033425, z=0.000774}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Poison Gas"
							,tile	= {
								{
									position	= {x=1.749997, y=1.931106, z=3.031089}
									,rotation	= {x=0.000252, y=0.005253, z=0.000767}
								}
								,{
									position	= {x=5.687500, y=1.931148, z=5.304404}
									,rotation	= {x=0.000252, y=0.005320, z=0.000765}
								}
								,{
									position	= {x=4.375000, y=1.931161, z=-1.515546}
									,rotation	= {x=0.000249, y=0.005364, z=0.000765}
								}
								,{
									position	= {x=7.000000, y=1.931209, z=-4.546633}
									,rotation	= {x=0.000247, y=0.005357, z=0.000770}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Rock Column"
							,tile	= {
								{
									position	= {x=-6.125000, y=1.934545, z=-6.062178}
									,rotation	= {x=0.000245, y=0.028018, z=0.000769}
								}
								,{
									position	= {x=-3.500000, y=1.934567, z=-3.031089}
									,rotation	= {x=0.000245, y=0.028012, z=0.000766}
								}
								,{
									position	= {x=3.062500, y=1.934059, z=-3.788861}
									,rotation	= {x=0.000249, y=0.028007, z=0.000768}
								}
								,{
									position	= {x=0.437501, y=2.050004, z=0.757811}
									,rotation	= {x=0.000264, y=0.027565, z=0.000903}
								}
								,{
									position	= {x=7.000000, y=1.934081, z=3.031089}
									,rotation	= {x=0.000253, y=0.027562, z=0.000766}
								}
								,{
									position	= {x=8.312501, y=1.934095, z=3.788861}
									,rotation	= {x=0.000252, y=0.027555, z=0.000768}
								}
							}
						}
						,{
							name	= "Stalagmites"
							,tile	= {
								{
									position	= {x=-4.812500, y=1.934560, z=-5.304405}
									,rotation	= {x=0.000246, y=0.004043, z=0.000767}
								}
								,{
									position	= {x=5.687500, y=1.934087, z=-2.273317}
									,rotation	= {x=0.000246, y=0.004035, z=0.000769}
								}
								,{
									position	= {x=1.750000, y=1.934025, z=-0.000001}
									,rotation	= {x=0.000243, y=0.004070, z=0.000763}
								}
								,{
									position	= {x=0.437499, y=2.049997, z=2.273317}
									,rotation	= {x=0.000282, y=0.004043, z=0.000926}
								}
								,{
									position	= {x=3.088538, y=1.934018, z=5.304407}
									,rotation	= {x=0.000249, y=0.043612, z=0.000765}
								}
								,{
									position	= {x=7.000000, y=1.934067, z=6.062178}
									,rotation	= {x=0.000253, y=0.024394, z=0.000768}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Dark Fog"
							,tile	= {
								{
									position	= {x=-0.874958, y=1.935139, z=-4.546652}
									,rotation	= {x=0.006367, y=180.000900, z=0.021190}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=8.312492, y=2.047197, z=2.273314}
									,rotation	= {x=-0.000316, y=180.000793, z=-0.001047}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "40"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 88
			,[88] = {
				--Corridors
				{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Stone Corridor 1"
							,tile	= {
								{
									position	= {x=-6.819951, y=1.817701, z=2.187500}
									,rotation	= {x=-0.000756, y=90.005478, z=180.000244}
								}
								,{
									position	= {x=-3.788862, y=1.817741, z=2.187500}
									,rotation	= {x=-0.000774, y=90.005508, z=180.000229}
								}
								,{
									position	= {x=-0.757772, y=1.817782, z=2.187500}
									,rotation	= {x=-0.000765, y=90.005508, z=180.000229}
								}
								,{
									position	= {x=2.275985, y=1.817822, z=2.149381}
									,rotation	= {x=-0.000756, y=90.005524, z=180.000229}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Spike Trap"
							,tile	= {
								{
									position	= {x=-3.031090, y=1.931041, z=3.500000}
									,rotation	= {x=-0.000769, y=89.987640, z=0.000246}
								}
								,{
									position	= {x=-0.757774, y=1.931088, z=-0.437500}
									,rotation	= {x=-0.000766, y=89.987709, z=0.000251}
								}
								,{
									position	= {x=-3.788863, y=1.931059, z=-3.062500}
									,rotation	= {x=-0.000765, y=89.987762, z=0.000251}
								}
								,{
									position	= {x=-0.000002, y=1.931115, z=-4.375000}
									,rotation	= {x=-0.000766, y=89.987808, z=0.000248}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Crystal"
							,tile	= {
								{
									position	= {x=-3.031090, y=1.931086, z=-7.000001}
									,rotation	= {x=-0.000769, y=90.011841, z=0.000249}
								}
							}
						}
						,{
							name	= "Rock Column"
							,tile	= {
								{
									position	= {x=-6.062179, y=1.933928, z=-1.750002}
									,rotation	= {x=-0.000764, y=90.008514, z=0.000250}
								}
								,{
									position	= {x=-4.546632, y=1.933959, z=-4.375000}
									,rotation	= {x=-0.000763, y=90.008514, z=0.000252}
								}
								,{
									position	= {x=-0.757772, y=1.933970, z=4.812500}
									,rotation	= {x=-0.000764, y=90.008514, z=0.000249}
								}
								,{
									position	= {x=2.283453, y=1.934033, z=-0.423284}
									,rotation	= {x=-0.000769, y=90.008507, z=0.000251}
								}
							}
						}
						,{
							name	= "Stalagmites"
							,tile	= {
								{
									position	= {x=-6.062181, y=1.933905, z=3.499999}
									,rotation	= {x=-0.000766, y=89.991463, z=0.000249}
								}
								,{
									position	= {x=-1.515544, y=1.933988, z=-1.750000}
									,rotation	= {x=-0.000766, y=89.991463, z=0.000249}
								}
								,{
									position	= {x=0.757772, y=1.934036, z=-5.687500}
									,rotation	= {x=-0.000764, y=89.991463, z=0.000251}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Dark Fog"
							,tile	= {
								{
									position	= {x=2.273307, y=1.935097, z=7.437516}
									,rotation	= {x=0.013803, y=270.002930, z=0.029993}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=-7.577723, y=1.931025, z=-7.000000}
									,rotation	= {x=-0.000766, y=89.999985, z=0.000248}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "37"
									}
								}
								,{
									position	= {x=3.031088, y=1.931167, z=-7.000000}
									,rotation	= {x=-0.000769, y=89.999969, z=0.000250}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "8"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 89
			,[89] = {
				--Traps
				{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Poison Gas"
							,tile	= {
								{
									position	= {x=-5.304407, y=1.931028, z=-0.437500}
									,rotation	= {x=-0.000772, y=90.006546, z=0.000250}
								}
								,{
									position	= {x=12.882125, y=1.931249, z=4.812502}
									,rotation	= {x=-0.000766, y=90.006561, z=0.000241}
								}
							}
						}
						,{
							name	= "Bear Trap"
							,tile	= {
								{
									position	= {x=0.000000, y=1.934598, z=0.874999}
									,rotation	= {x=-0.000765, y=90.005478, z=0.000253}
								}
								,{
									position	= {x=2.273315, y=1.934645, z=-3.062500}
									,rotation	= {x=-0.000766, y=90.005539, z=0.000255}
								}
								,{
									position	= {x=3.031081, y=1.934661, z=-4.375000}
									,rotation	= {x=-0.000765, y=90.005806, z=0.000253}
								}
								,{
									position	= {x=4.546632, y=1.934682, z=-4.375000}
									,rotation	= {x=-0.000764, y=90.005806, z=0.000254}
								}
								,{
									position	= {x=5.305617, y=1.934686, z=-3.031615}
									,rotation	= {x=-0.000765, y=90.004799, z=0.000253}
								}
								,{
									position	= {x=7.577722, y=1.934699, z=0.875000}
									,rotation	= {x=-0.000765, y=90.004799, z=0.000256}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Barrel"
							,tile	= {
								{
									position	= {x=3.789524, y=1.934666, z=-3.036275}
									,rotation	= {x=-0.000767, y=90.000008, z=0.000255}
								}
								,{
									position	= {x=11.393602, y=1.934135, z=4.811685}
									,rotation	= {x=-0.000766, y=90.031364, z=0.000240}
								}
								,{
									position	= {x=17.428764, y=1.934215, z=4.812500}
									,rotation	= {x=-0.000768, y=90.031136, z=0.000242}
								}
							}
						}
						,{
							name	= "Table"
							,tile	= {
								{
									position	= {x=15.155448, y=1.934001, z=0.874999}
									,rotation	= {x=0.000765, y=269.994446, z=-0.000257}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Wooden Door Horizontal"
							,tile	= {
								{
									position	= {x=3.788867, y=1.818345, z=2.187495}
									,rotation	= {x=0.005329, y=270.018982, z=179.972351}
								}
								,{
									position	= {x=13.639897, y=1.817958, z=6.125001}
									,rotation	= {x=0.000768, y=270.018677, z=179.999664}
								}
							}
						}
						,{
							name	= "Wooden Door Vertical"
							,tile	= {
								{
									position	= {x=-1.515535, y=1.818283, z=0.875003}
									,rotation	= {x=0.033692, y=269.995056, z=179.990234}
								}
								,{
									position	= {x=9.118343, y=1.818374, z=0.904812}
									,rotation	= {x=0.022614, y=89.998466, z=179.991074}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=-6.819950, y=1.930996, z=2.187500}
									,rotation	= {x=-0.000766, y=90.000015, z=0.000250}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "43"
									}
								}
								,{
									position	= {x=2.273317, y=1.931094, z=7.437501}
									,rotation	= {x=-0.000769, y=90.000000, z=0.000249}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "13"
									}
								}
								,{
									position	= {x=15.155444, y=1.931250, z=11.375001}
									,rotation	= {x=-0.000762, y=90.000000, z=0.000249}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "27"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=15.913217, y=1.875495, z=4.812499}
									,rotation	= {x=-0.000228, y=179.999115, z=-0.000775}
								}
								,{
									position	= {x=16.670988, y=1.875510, z=3.499993}
									,rotation	= {x=-0.000245, y=179.999191, z=-0.000760}
								}
								,{
									position	= {x=15.913266, y=1.875517, z=-0.437530}
									,rotation	= {x=-0.000212, y=179.999741, z=-0.000764}
								}
								,{
									position	= {x=17.428823, y=1.875537, z=-0.437553}
									,rotation	= {x=-0.000228, y=180.000168, z=-0.000761}
								}
							}
						}
					}
				}
			}
			--Scenario 90
			,[90] = {
				--Corridors
				{
					bag	 	= Bag_Corridors_GUID
					,type	= {
						{
							name	= "Earth Corridor 2"
							,tile	= {
								{
									position	= {x=10.063935, y=1.944710, z=-3.788856}
									,rotation	= {x=0.049413, y=359.993683, z=359.377716}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Spike Trap"
							,tile	= {
								{
									position	= {x=4.812352, y=1.934296, z=-3.788778}
									,rotation	= {x=0.049885, y=359.991943, z=0.084900}
								}
								,{
									position	= {x=7.437464, y=1.936868, z=-2.273295}
									,rotation	= {x=0.049888, y=359.991943, z=0.084905}
								}
								,{
									position	= {x=12.687671, y=1.931338, z=-3.788960}
									,rotation	= {x=-0.000246, y=359.991913, z=-0.001442}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Altar Horizontal"
							,tile	= {
								{
									position	= {x=-3.062500, y=1.931666, z=-2.273316}
									,rotation	= {x=0.000256, y=0.000305, z=0.000774}
								}
								,{
									position	= {x=3.499859, y=1.931692, z=-3.031005}
									,rotation	= {x=0.049872, y=0.000294, z=0.084915}
								}
							}
						}
					}
				}
				--Hazardous Terrain
				,{
					bag	 	= Bag_HazardousTerrain_GUID
					,type	= {
						{
							name	= "Hot Coals 1"
							,tile	= {
								{
									position	= {x=4.812353, y=1.934564, z=-0.757683}
									,rotation	= {x=359.950165, y=180.017075, z=359.915070}
								}
								,{
									position	= {x=7.437463, y=1.941092, z=-3.788840}
									,rotation	= {x=359.950165, y=180.017090, z=359.915070}
								}
								,{
									position	= {x=8.750023, y=1.942377, z=-3.031102}
									,rotation	= {x=359.950165, y=180.017090, z=359.915070}
								}
								,{
									position	= {x=10.066428, y=2.059584, z=-2.272704}
									,rotation	= {x=359.949951, y=180.112534, z=0.618223}
								}
								,{
									position	= {x=10.063336, y=2.060920, z=-3.788813}
									,rotation	= {x=359.951263, y=180.005585, z=0.626135}
								}
							}
						}
						,{
							name	= "Thorns"
							,tile	= {
								{
									position	= {x=-4.375000, y=1.931632, z=1.515544}
									,rotation	= {x=0.000248, y=0.016351, z=0.000772}
								}
								,{
									position	= {x=-5.687500, y=1.931637, z=-3.788861}
									,rotation	= {x=0.000252, y=0.016352, z=0.000775}
								}
								,{
									position	= {x=-0.437500, y=1.931708, z=-3.788861}
									,rotation	= {x=0.000250, y=0.016344, z=0.000771}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=15.312504, y=1.931278, z=-2.273318}
									,rotation	= {x=0.000246, y=180.000656, z=0.001446}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "19"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 91
			,[91] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Log"
							,tile	= {
								{
									position	= {x=15.312498, y=1.934603, z=0.757775}
									,rotation	= {x=0.000544, y=239.994507, z=-0.000604}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Bear Trap"
							,tile	= {
								{
									position	= {x=11.375000, y=1.934727, z=6.062178}
									,rotation	= {x=0.000255, y=0.025800, z=0.000770}
								}
								,{
									position	= {x=11.375000, y=1.934740, z=3.031088}
									,rotation	= {x=0.000253, y=0.025846, z=0.000775}
								}
								,{
									position	= {x=12.687500, y=1.934761, z=2.273317}
									,rotation	= {x=0.000255, y=0.025845, z=0.000776}
								}
								,{
									position	= {x=10.062500, y=1.934732, z=0.757772}
									,rotation	= {x=0.000251, y=0.025848, z=0.000772}
								}
								,{
									position	= {x=6.117446, y=1.992310, z=1.563590}
									,rotation	= {x=357.740387, y=359.972229, z=3.922578}
								}
								,{
									position	= {x=4.826925, y=1.934090, z=-5.297873}
									,rotation	= {x=0.000251, y=0.040653, z=0.000763}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Stump"
							,tile	= {
								{
									position	= {x=-7.000000, y=1.931009, z=-1.515544}
									,rotation	= {x=0.000250, y=0.011598, z=0.000770}
								}
								,{
									position	= {x=-0.437500, y=1.931707, z=-3.788861}
									,rotation	= {x=0.000256, y=0.011598, z=0.000769}
								}
								,{
									position	= {x=6.125000, y=1.931185, z=-1.515544}
									,rotation	= {x=0.000251, y=0.011599, z=0.000767}
								}
								,{
									position	= {x=15.312500, y=1.931878, z=5.304405}
									,rotation	= {x=0.000253, y=0.011599, z=0.000770}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "LIght Fog"
							,tile	= {
								{
									position	= {x=2.187560, y=1.935127, z=-2.273350}
									,rotation	= {x=0.014067, y=179.999832, z=0.028964}
								}
								,{
									position	= {x=7.437377, y=1.935186, z=2.273336}
									,rotation	= {x=0.004410, y=179.999878, z=359.967865}
								}
							}
						}
					}
				}
			}
			--Scenario 92
			,[92] = {
				--Traps
				{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Bear Trap"
							,tile	= {
								{
									position	= {x=-0.000002, y=1.933998, z=0.874998}
									,rotation	= {x=-0.000767, y=90.005463, z=0.000249}
								}
								,{
									position	= {x=0.757772, y=1.934013, z=-0.437501}
									,rotation	= {x=-0.000766, y=90.005470, z=0.000251}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Barrel"
							,tile	= {
								{
									position	= {x=-6.062180, y=1.933916, z=0.874998}
									,rotation	= {x=-0.000769, y=90.011818, z=0.000249}
								}
							}
						}
						,{
							name	= "Crate B"
							,tile	= {
								{
									position	= {x=2.273317, y=1.930696, z=7.437500}
									,rotation	= {x=0.000754, y=269.994537, z=-0.000252}
								}
								,{
									position	= {x=5.304404, y=1.930771, z=-0.437498}
									,rotation	= {x=0.000754, y=269.994537, z=-0.000249}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Vertical"
							,tile	= {
								{
									position	= {x=1.515536, y=1.817721, z=0.874999}
									,rotation	= {x=0.015512, y=89.994621, z=179.991333}
								}
							}
						}
					}
				}
			}
			--Scenario 93
			,[93] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Water 1"
							,tile	= {
								{
									position	= {x=-6.819951, y=1.930995, z=2.187502}
									,rotation	= {x=-0.000769, y=89.991425, z=0.000248}
								}
								,{
									position	= {x=-6.062180, y=1.931011, z=0.875002}
									,rotation	= {x=-0.000772, y=89.991463, z=0.000246}
								}
								,{
									position	= {x=-5.304409, y=1.931027, z=-0.437499}
									,rotation	= {x=-0.000768, y=89.991516, z=0.000250}
								}
								,{
									position	= {x=-4.546635, y=1.931043, z=-1.750000}
									,rotation	= {x=-0.000766, y=89.991524, z=0.000249}
								}
								,{
									position	= {x=-3.788862, y=1.931059, z=-3.062501}
									,rotation	= {x=-0.000768, y=89.991531, z=0.000246}
								}
								,{
									position	= {x=-3.031089, y=1.931074, z=-4.375001}
									,rotation	= {x=-0.000768, y=89.991539, z=0.000247}
								}
								,{
									position	= {x=-2.273318, y=1.931090, z=-5.687502}
									,rotation	= {x=-0.000768, y=89.991623, z=0.000247}
								}
								,{
									position	= {x=-1.515544, y=1.931106, z=-7.000001}
									,rotation	= {x=-0.000770, y=89.991676, z=0.000247}
								}
								,{
									position	= {x=3.031080, y=1.931133, z=0.875001}
									,rotation	= {x=-0.000768, y=89.991936, z=0.000251}
								}
								,{
									position	= {x=3.788853, y=1.931149, z=-0.437500}
									,rotation	= {x=-0.000766, y=89.992188, z=0.000251}
								}
								,{
									position	= {x=3.013815, y=1.931144, z=-1.737946}
									,rotation	= {x=-0.000769, y=89.992371, z=0.000253}
								}
								,{
									position	= {x=3.788858, y=1.931160, z=-3.062500}
									,rotation	= {x=-0.000766, y=89.992401, z=0.000250}
								}
								,{
									position	= {x=3.031088, y=1.931156, z=-4.375000}
									,rotation	= {x=-0.000768, y=89.992416, z=0.000249}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Bear Trap"
							,tile	= {
								{
									position	= {x=5.304400, y=1.934074, z=-0.437501}
									,rotation	= {x=-0.000766, y=89.991600, z=0.000250}
								}
								,{
									position	= {x=7.577722, y=1.934122, z=-4.375000}
									,rotation	= {x=-0.000768, y=89.991600, z=0.000249}
								}
								,{
									position	= {x=10.608814, y=1.934151, z=-1.750000}
									,rotation	= {x=-0.000766, y=89.991577, z=0.000251}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Barrel"
							,tile	= {
								{
									position	= {x=6.062175, y=1.934090, z=-1.750000}
									,rotation	= {x=-0.000764, y=90.012344, z=0.000254}
								}
								,{
									position	= {x=7.577723, y=1.934110, z=-1.750000}
									,rotation	= {x=-0.000768, y=90.012344, z=0.000249}
								}
							}
						}
						,{
							name	= "Crystal"
							,tile	= {
								{
									position	= {x=2.273317, y=1.934335, z=7.437500}
									,rotation	= {x=-0.000767, y=90.000000, z=0.000256}
								}
								,{
									position	= {x=4.546633, y=1.934359, z=8.750000}
									,rotation	= {x=-0.000766, y=90.000000, z=0.000259}
								}
							}
						}
						,{
							name	= "Rock Column"
							,tile	= {
								{
									position	= {x=-2.273317, y=1.937190, z=4.812500}
									,rotation	= {x=-0.000768, y=90.371994, z=0.000253}
								}
								,{
									position	= {x=0.757772, y=1.937231, z=4.812500}
									,rotation	= {x=-0.000767, y=90.003326, z=0.000256}
								}
								,{
									position	= {x=0.757770, y=1.937219, z=7.437500}
									,rotation	= {x=-0.000768, y=90.003395, z=0.000258}
								}
								,{
									position	= {x=1.515545, y=1.937223, z=8.750000}
									,rotation	= {x=-0.000768, y=90.003403, z=0.000255}
								}
								,{
									position	= {x=4.546633, y=1.937276, z=6.125000}
									,rotation	= {x=-0.000768, y=90.003403, z=0.000255}
								}
								,{
									position	= {x=7.577723, y=1.937316, z=6.125000}
									,rotation	= {x=-0.000764, y=90.003380, z=0.000258}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Dark Fog"
							,tile	= {
								{
									position	= {x=-3.031391, y=1.937419, z=3.499832}
									,rotation	= {x=0.165339, y=270.011322, z=0.094892}
								}
								,{
									position	= {x=6.820291, y=1.937587, z=2.187438}
									,rotation	= {x=0.000875, y=270.009216, z=0.191954}
								}
							}
						}
						,{
							name	= "Wooden Door Vertical"
							,tile	= {
								{
									position	= {x=11.366585, y=1.817967, z=-3.062500}
									,rotation	= {x=-0.000750, y=89.982101, z=180.000259}
								}
							}
						}
					}
				}
				--Hazardous Terrain
				,{
					bag	 	= Bag_HazardousTerrain_GUID
					,type	= {
						{
							name	= "Thorns"
							,tile	= {
								{
									position	= {x=-3.031090, y=1.931052, z=0.875006}
									,rotation	= {x=-0.000770, y=90.005478, z=0.000246}
								}
								,{
									position	= {x=-0.757766, y=1.931099, z=-3.062502}
									,rotation	= {x=-0.000771, y=90.005424, z=0.000247}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Horizontal"
							,tile	= {
								{
									position	= {x=16.670986, y=1.931327, z=-1.750000}
									,rotation	= {x=-0.000768, y=90.000015, z=0.000247}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "54"
									}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=12.882128, y=1.875476, z=-0.437499}
									,rotation	= {x=-0.000242, y=179.999344, z=-0.000769}
								}
								,{
									position	= {x=14.397673, y=1.875496, z=-0.437500}
									,rotation	= {x=-0.000251, y=179.999344, z=-0.000758}
								}
								,{
									position	= {x=15.913217, y=1.875516, z=-0.437499}
									,rotation	= {x=-0.000238, y=179.999451, z=-0.000762}
								}
								,{
									position	= {x=15.913217, y=1.875528, z=-3.062500}
									,rotation	= {x=-0.000249, y=179.999481, z=-0.000772}
								}
								,{
									position	= {x=15.155444, y=1.875523, z=-4.375000}
									,rotation	= {x=-0.000254, y=179.999481, z=-0.000775}
								}
								,{
									position	= {x=16.670988, y=1.875543, z=-4.375000}
									,rotation	= {x=-0.000245, y=179.999466, z=-0.000774}
								}
							}
						}
					}
				}
			}
			--Scenario 94
			,[94] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Log"
							,tile	= {
								{
									position	= {x=9.187496, y=1.934494, z=6.819950}
									,rotation	= {x=-0.000251, y=179.990585, z=-0.000758}
								}
								,{
									position	= {x=5.249998, y=1.934485, z=-3.031086}
									,rotation	= {x=-0.000545, y=59.994526, z=0.000606}
								}
								,{
									position	= {x=3.937796, y=1.934477, z=-5.303891}
									,rotation	= {x=-0.000795, y=120.026642, z=-0.000168}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Spike Trap"
							,tile	= {
								{
									position	= {x=5.249999, y=1.931153, z=3.031072}
									,rotation	= {x=-0.000252, y=179.999741, z=-0.000767}
								}
								,{
									position	= {x=6.562500, y=1.931174, z=2.273318}
									,rotation	= {x=-0.000252, y=179.999786, z=-0.000762}
								}
								,{
									position	= {x=-1.312500, y=1.931075, z=0.757772}
									,rotation	= {x=-0.000244, y=179.999771, z=-0.000766}
								}
								,{
									position	= {x=-3.937500, y=1.931647, z=-0.757770}
									,rotation	= {x=-0.000258, y=179.999832, z=-0.000769}
								}
								,{
									position	= {x=2.625000, y=1.931738, z=-1.515544}
									,rotation	= {x=-0.000251, y=179.999832, z=-0.000776}
								}
								,{
									position	= {x=1.312500, y=1.931730, z=-3.788860}
									,rotation	= {x=-0.000250, y=179.999878, z=-0.000774}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Nest"
							,tile	= {
								{
									position	= {x=-2.625001, y=1.931041, z=4.546633}
									,rotation	= {x=0.000247, y=359.991516, z=0.000767}
								}
								,{
									position	= {x=-5.250000, y=1.931646, z=-4.546633}
									,rotation	= {x=0.000256, y=359.991516, z=0.000764}
								}
								,{
									position	= {x=2.625000, y=1.931758, z=-6.062178}
									,rotation	= {x=0.000251, y=359.991516, z=0.000774}
								}
								,{
									position	= {x=9.187500, y=1.931823, z=-0.757772}
									,rotation	= {x=0.000249, y=359.991486, z=0.000770}
								}
							}
						}
						,{
							name	= "Totem"
							,tile	= {
								{
									position	= {x=6.562500, y=1.931788, z=-0.757772}
									,rotation	= {x=-0.000254, y=180.014572, z=-0.000776}
								}
								,{
									position	= {x=2.625000, y=1.931745, z=-3.031089}
									,rotation	= {x=-0.000251, y=180.014572, z=-0.000774}
								}
								,{
									position	= {x=6.562500, y=1.931808, z=-5.304405}
									,rotation	= {x=-0.000249, y=180.014587, z=-0.000774}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "LIght Fog"
							,tile	= {
								{
									position	= {x=-2.624963, y=1.935078, z=0.000050}
									,rotation	= {x=359.982727, y=180.000122, z=0.018675}
								}
								,{
									position	= {x=-0.000041, y=1.935214, z=-3.031125}
									,rotation	= {x=-0.000251, y=180.000122, z=-0.000753}
								}
								,{
									position	= {x=1.312458, y=1.935124, z=0.757811}
									,rotation	= {x=359.978821, y=180.000214, z=359.978485}
								}
								,{
									position	= {x=5.250029, y=1.935146, z=1.515549}
									,rotation	= {x=359.977936, y=180.000290, z=359.992401}
								}
							}
						}
					}
				}
				--Treasure Chests
				,{
					bag	 	= Bag_TreasureChests_GUID
					,type	= {
						{
							name	= "Treasure Chest Vertical"
							,tile	= {
								{
									position	= {x=-6.562500, y=1.931618, z=-2.273316}
									,rotation	= {x=-0.000254, y=180.000626, z=-0.000769}
									,params	 = {
										buttonTheme = "Treasure"
										,buttonLabel = "G"
									}
								}
							}
						}
					}
				}
			}
			--Scenario 95
			,[95] = {
				--Difficult Terrain
				{
					bag	 	= Bag_DifficultTerrain_GUID
					,type	= {
						{
							name	= "Water 1"
							,tile	= {
								{
									position	= {x=-6.562503, y=1.931618, z=-2.273316}
									,rotation	= {x=0.000253, y=0.010184, z=0.000766}
								}
								,{
									position	= {x=-6.562500, y=1.931625, z=-3.788862}
									,rotation	= {x=0.000249, y=0.010246, z=0.000768}
								}
								,{
									position	= {x=-6.562501, y=1.931631, z=-5.304407}
									,rotation	= {x=0.000250, y=0.001005, z=0.000771}
								}
								,{
									position	= {x=-5.250000, y=1.931632, z=-1.515545}
									,rotation	= {x=0.000252, y=0.001054, z=0.000769}
								}
								,{
									position	= {x=-5.250000, y=1.931639, z=-3.031090}
									,rotation	= {x=0.000248, y=0.001116, z=0.000768}
								}
								,{
									position	= {x=-5.250000, y=1.931646, z=-4.546635}
									,rotation	= {x=0.000247, y=0.001163, z=0.000765}
								}
								,{
									position	= {x=-5.250000, y=1.931652, z=-6.062185}
									,rotation	= {x=0.000251, y=0.001439, z=0.000764}
								}
								,{
									position	= {x=-3.937500, y=1.931647, z=-0.757773}
									,rotation	= {x=0.000256, y=0.001474, z=0.000771}
								}
								,{
									position	= {x=-3.937500, y=1.931653, z=-2.273318}
									,rotation	= {x=0.000248, y=0.001529, z=0.000765}
								}
								,{
									position	= {x=-3.937500, y=1.931660, z=-3.788861}
									,rotation	= {x=0.000252, y=0.005370, z=0.000765}
								}
								,{
									position	= {x=-3.937500, y=1.931667, z=-5.304407}
									,rotation	= {x=0.000250, y=0.005417, z=0.000765}
								}
								,{
									position	= {x=-3.937500, y=1.931673, z=-6.819952}
									,rotation	= {x=0.000247, y=0.005496, z=0.000765}
								}
								,{
									position	= {x=-2.625000, y=1.931668, z=-1.515552}
									,rotation	= {x=0.000251, y=0.005759, z=0.000765}
								}
								,{
									position	= {x=-2.625000, y=1.931674, z=-3.031090}
									,rotation	= {x=0.000249, y=0.005804, z=0.000765}
								}
								,{
									position	= {x=-2.625000, y=1.931681, z=-4.546641}
									,rotation	= {x=0.000254, y=0.006079, z=0.000768}
								}
								,{
									position	= {x=-2.625001, y=1.931688, z=-6.062179}
									,rotation	= {x=0.000249, y=0.006129, z=0.000768}
								}
								,{
									position	= {x=-1.312500, y=1.931688, z=-2.273318}
									,rotation	= {x=0.000249, y=0.006178, z=0.000768}
								}
								,{
									position	= {x=-1.312500, y=1.931695, z=-3.788862}
									,rotation	= {x=0.000249, y=0.006227, z=0.000766}
								}
								,{
									position	= {x=-1.312500, y=1.931702, z=-5.304406}
									,rotation	= {x=0.000246, y=0.006205, z=0.000764}
								}
							}
						}
					}
				}
				--Traps
				,{
					bag	 	= Bag_Traps_GUID
					,type	= {
						{
							name	= "Poison Gas"
							,tile	= {
								{
									position	= {x=10.500000, y=1.934470, z=1.515545}
									,rotation	= {x=-0.000260, y=179.999969, z=-0.000769}
								}
								,{
									position	= {x=10.500000, y=1.934477, z=0.000000}
									,rotation	= {x=-0.000254, y=179.999969, z=-0.000769}
								}
								,{
									position	= {x=14.437501, y=1.934527, z=0.757774}
									,rotation	= {x=-0.000260, y=180.000000, z=-0.000766}
								}
								,{
									position	= {x=14.437501, y=1.934533, z=-0.757771}
									,rotation	= {x=-0.000256, y=180.000061, z=-0.000764}
								}
							}
						}
						,{
							name	= "Spike Trap"
							,tile	= {
								{
									position	= {x=7.874998, y=1.934435, z=1.515529}
									,rotation	= {x=-0.000255, y=179.999725, z=-0.000764}
								}
								,{
									position	= {x=7.875000, y=1.934442, z=0.000000}
									,rotation	= {x=-0.000255, y=179.999741, z=-0.000770}
								}
								,{
									position	= {x=13.125001, y=1.934519, z=-1.515543}
									,rotation	= {x=-0.000256, y=179.999786, z=-0.000768}
								}
								,{
									position	= {x=15.750000, y=1.934554, z=-1.515543}
									,rotation	= {x=-0.000259, y=179.999817, z=-0.000766}
								}
							}
						}
					}
				}
				--Obstacles
				,{
					bag	 	= Bag_Obstacles_GUID
					,type	= {
						{
							name	= "Boulder"
							,tile	= {
								{
									position	= {x=11.812500, y=1.934485, z=2.273309}
									,rotation	= {x=0.000260, y=0.000367, z=0.000767}
								}
								,{
									position	= {x=14.437500, y=1.934520, z=2.273315}
									,rotation	= {x=0.000254, y=0.000451, z=0.000766}
								}
								,{
									position	= {x=13.125000, y=1.934512, z=0.000000}
									,rotation	= {x=0.000252, y=0.000455, z=0.000765}
								}
								,{
									position	= {x=14.437500, y=1.934540, z=-2.273317}
									,rotation	= {x=0.000259, y=0.000430, z=0.000765}
								}
								,{
									position	= {x=14.437500, y=1.934554, z=-5.304406}
									,rotation	= {x=0.000253, y=0.000423, z=0.000765}
								}
							}
						}
						,{
							name	= "Stone Pillar"
							,tile	= {
								{
									position	= {x=11.812500, y=1.934478, z=3.788862}
									,rotation	= {x=0.000253, y=0.023863, z=0.000765}
								}
								,{
									position	= {x=13.125000, y=1.934506, z=1.515544}
									,rotation	= {x=0.000257, y=0.023864, z=0.000764}
								}
								,{
									position	= {x=14.437500, y=1.934547, z=-3.788861}
									,rotation	= {x=0.000253, y=0.023869, z=0.000765}
								}
							}
						}
					}
				}
				--Doors
				,{
					bag	 	= Bag_Doors_GUID
					,type	= {
						{
							name	= "Stone Door Horizontal"
							,tile	= {
								{
									position	= {x=-0.000042, y=1.818334, z=-3.031098}
									,rotation	= {x=0.006081, y=179.996872, z=180.022324}
								}
								,{
									position	= {x=5.250052, y=1.820743, z=-0.000072}
									,rotation	= {x=0.000185, y=0.026411, z=180.190659}
								}
							}
						}
						,{
							name	= "Stone Door Vertical"
							,tile	= {
								{
									position	= {x=2.625000, y=1.817687, z=6.062155}
									,rotation	= {x=0.224208, y=359.980316, z=180.000687}
								}
							}
						}
					}
				}
				--Coins
				,{
					type	= {
						{
							name	= "Coin 1"
							,tile	= {
								{
									position	= {x=0.000003, y=1.872193, z=12.124360}
									,rotation	= {x=-0.000247, y=179.999420, z=-0.000767}
								}
								,{
									position	= {x=1.312502, y=1.872207, z=12.882128}
									,rotation	= {x=-0.000246, y=179.999603, z=-0.000768}
								}
								,{
									position	= {x=3.937500, y=1.872242, z=12.882128}
									,rotation	= {x=-0.000239, y=179.999573, z=-0.000766}
								}
								,{
									position	= {x=5.250000, y=1.872263, z=12.124355}
									,rotation	= {x=-0.000247, y=179.999573, z=-0.000771}
								}
							}
						}
					}
				}
			}
		}

		for _,tBag in ipairs(t[NumScenario]) do
			for _,tType in ipairs(tBag.type) do
				for _,tTile in ipairs(tType.tile) do
					
					if(tType.name == "Coin 1") then
						local obj_parameters = {}
						obj_parameters.type = 'Custom_Token'
						obj_parameters.position = tTile.position
						obj_parameters.rotation = tTile.rotation
						obj_parameters.scale = {0.38, 1.00, 0.38}
						
						--obj_parameters.nickname = tMap.tile
						obj = spawnObject(obj_parameters)
						
						paramsCustom = {
							image = 'http://cloud-3.steamusercontent.com/ugc/83721958669669224/E3E1295D7B0F051D7AA322674A25AB52F646B85C/',
							thickness = 0.12,
							merge_distance = 15,
							stackable = true
						}
						
						obj.setCustomObject(paramsCustom)
						obj.setName(tType.name)
					else 
						
						local obj_parameters = {}
						obj_parameters.type = 'Custom_Model'
						obj_parameters.position = tTile.position
						obj_parameters.rotation = tTile.rotation
						--obj_parameters.nickname = tMap.tile
						obj = spawnObject(obj_parameters)
						obj.setLock(true)
						
						custom = {}
						custom.mesh = allTheObjects[tType.name][1]
						custom.collider = allTheObjects[tType.name][1]
						custom.diffuse = allTheObjects[tType.name][2]
						custom.material = 1
						obj.setCustomObject(custom)
						obj.setName(tType.name)
					end
				end
			end
		end

		return 1
	end
	startLuaCoroutine(self, "spawnTiles")


	--Spawn Enemies
	function spawnEnemies()
		wait(Delay_Spawning)
		local AllObjects = getAllObjects()

		local t = {
			--Scenario 1
			[1] = {
				{"Bandit Guard"}
				,{"Bandit Archer"}
				,{"Living Bones"}
			}
			--Scenario 2
			,[2] = {
				{"Bandit Archer"}
				,{"Living Bones"}
				,{"Living Corpse"}
				,{"Bandit Commander"}
			}
			--Scenario 3
			,[3] = {
				{"Inox Guard"}
				,{"Inox Archer"}
				,{"Inox Shaman"}
			}
			--Scenario 4
			,[4] = {
				{"Living Bones"}
				,{"Bandit Archer"}
				,{"Cultist"}
				,{"Earth Demon"}
				,{"Wind Demon"}
			}
			--Scenario 5
			,[5] = {
				{"Cultist"}
				,{"Living Bones"}
				,{"Night Demon"}
				,{"Flame Demon"}
				,{"Frost Demon"}
			}
			--Scenario 6
			,[6] = {
				{"Living Bones"}
				,{"Living Corpse"}
				,{"Living Spirit"}
			}
			--Scenario 7
			,[7] = {
				{"Forest Imp"}
				,{"Cave Bear"}
				,{"Inox Shaman"}
				,{"Earth Demon"}
			}
			--Scenario 8
			,[8] = {
				{"Living Bones"}
				,{"Living Corpse"}
				,{"Inox Bodyguard"}
			}
			--Scenario 9
			,[9] = {
				{"Hound"}
				,{"Vermling Scout"}
				,{"Merciless Overseer"}
			}
			--Scenario 10
			,[10] = {
				{"Flame Demon"}
				,{"Earth Demon"}
				,{"Sun Demon"}
			}
			--Scenario 11
			,[11] = {
				{"Living Bones"}
				,{"Living Corpse"}
				,{"City Guard"}
				,{"City Archer"}
				,{"Captain of the Guard"}
			}
			--Scenario 12
			,[12] = {
				{"Living Bones"}
				,{"Living Corpse"}
				,{"Cultist"}
				,{"City Guard"}
				,{"City Archer"}
				,{"Jekserah"}
			}
			--Scenario 13
			,[13] = {
				{"Stone Golem"}
				,{"Cave Bear"}
				,{"Living Spirit"}
				,{"Spitting Drake"}
			}
			--Scenario 14
			,[14] = {
				{"Hound"}
				,{"Living Spirit"}
				,{"Frost Demon"}
			}
			--Scenario 15
			,[15] = {
				{"Stone Golem"}
				,{"Savvas Icestorm"}
				,{"Frost Demon"}
				,{"Wind Demon"}
				,{"Harrower Infester"}
			}
			--Scenario 16
			,[16] = {
				{"Earth Demon"}
				,{"Wind Demon"}
				,{"Inox Guard"}
				,{"Inox Archer"}
			}
			--Scenario 17
			,[17] = {
				{"Vermling Scout"}
				,{"Vermling Shaman"}
				,{"Cave Bear"}
			}
			--Scenario 18
			,[18] = {
				{"Giant Viper"}
				,{"Ooze"}
				,{"Vermling Scout"}
			}
			--Scenario 19
			,[19] = {
				{"Cultist"}
				,{"Living Bones"}
				,{"Living Spirit"}
				,{"Living Corpse"}
			}
			--Scenario 20
			,[20] = {
				{"Living Bones"}
				,{"Cultist"}
				,{"Night Demon"}
				,{"Living Corpse"}
				,{"Jekserah"}
			}
			--Scenario 21
			,[21] = {
				{"Sun Demon"}
				,{"Frost Demon"}
				,{"Night Demon"}
				,{"Wind Demon"}
				,{"Earth Demon"}
				,{"Flame Demon"}
				,{"Prime Demon"}
			}
			--Scenario 22
			,[22] = {
				{"Living Bones"}
				,{"Cultist"}
				,{"Earth Demon"}
				,{"Flame Demon"}
				,{"Frost Demon"}
				,{"Wind Demon"}
			}
			--Scenario 23
			,[23] = {
				{"Stone Golem"}
				,{"Ancient Artillery"}
				,{"Living Bones"}
				,{"Living Spirit"}
			}
			--Scenario 24
			,[24] = {
				{"Rending Drake"}
				,{"Ooze"}
				,{"Living Spirit"}
			}
			--Scenario 25
			,[25] = {
				{"Hound"}
				,{"Rending Drake"}
				,{"Spitting Drake"}
			}
			--Scenario 26
			,[26] = {
				{"Living Corpse"}
				,{"Ooze"}
				,{"Night Demon"}
				,{"Black Imp"}
			}
			--Scenario 27
			,[27] = {
				{"Night Demon"}
				,{"Wind Demon"}
				,{"Frost Demon"}
				,{"Sun Demon"}
				,{"Earth Demon"}
				,{"Flame Demon"}
			}
			--Scenario 28
			,[28] = {
				{"Living Corpse"}
				,{"Cultist"}
				,{"Living Bones"}
				,{"Night Demon"}
				,{"Sun Demon"}
			}
			--Scenario 29
			,[29] = {
				{"Living Bones"}
				,{"Living Corpse"}
				,{"Living Spirit"}
				,{"Black Imp"}
			}
			--Scenario 30
			,[30] = {
				{"Ooze"}
				,{"Lurker"}
				,{"Deep Terror"}
			}
			--Scenario 31
			,[31] = {
				{"Deep Terror"}
				,{"Night Demon"}
				,{"Black Imp"}
			}
			--Scenario 32
			,[32] = {
				{"Harrower Infester"}
				,{"Giant Viper"}
				,{"Deep Terror"}
				,{"Black Imp"}
			}
			--Scenario 33
			,[33] = {
				{"Savvas Icestorm"}
				,{"Savvas Lavaflow"}
				,{"Frost Demon"}
				,{"Flame Demon"}
				,{"Wind Demon"}
				,{"Earth Demon"}
			}
			--Scenario 34
			,[34] = {
				{"Rending Drake"}
				,{"Spitting Drake"}
				,{"Elder Drake"}
			}
			--Scenario 35
			,[35] = {
				{"Flame Demon"}
				,{"Frost Demon"}
				,{"Earth Demon"}
				,{"Wind Demon"}
				,{"City Guard"}
				,{"City Archer"}
				,{"Captain of the Guard"}
			}
			--Scenario 36
			,[36] = {
				{"Flame Demon"}
				,{"Frost Demon"}
				,{"Earth Demon"}
				,{"Wind Demon"}
				,{"City Archer"}
				,{"Prime Demon"}
			}
			--Scenario 37
			,[37] = {
				{"Lurker"}
				,{"Deep Terror"}
				,{"Harrower Infester"}
			}
			--Scenario 38
			,[38] = {
				{"Inox Guard"}
				,{"Inox Archer"}
				,{"Inox Shaman"}
				,{"Stone Golem"}
			}
			--Scenario 39
			,[39] = {
				{"Cave Bear"}
				,{"Frost Demon"}
				,{"Spitting Drake"}
				,{"Cultist"}
				,{"Living Bones"}
			}
			--Scenario 40
			,[40] = {
				{"Living Corpse"}
				,{"Cave Bear"}
				,{"Flame Demon"}
				,{"Stone Golem"}
				,{"Forest Imp"}
			}
			--Scenario 41
			,[41] = {
				{"Ancient Artillery"}
				,{"Living Corpse"}
				,{"Living Spirit"}
				,{"Stone Golem"}
			}
			--Scenario 42
			,[42] = {
				{"Night Demon"}
				,{"Wind Demon"}
				,{"Living Spirit"}
			}
			--Scenario 43
			,[43] = {
				{"Flame Demon"}
				,{"Rending Drake"}
				,{"Spitting Drake"}
			}
			--Scenario 44
			,[44] = {
				{"Inox Guard"}
				,{"Inox Archer"}
				,{"Hound"}
				,{"Inox Shaman"}
			}
			--Scenario 45
			,[45] = {
				{"City Guard"}
				,{"City Archer"}
				,{"Hound"}
			}
			--Scenario 46
			,[46] = {
				{"Night Demon"}
				,{"Frost Demon"}
				,{"Wind Demon"}
				,{"Savvas Icestorm"}
				,{"Winged Horror"}
			}
			--Scenario 47
			,[47] = {
				{"Lurker"}
				,{"Deep Terror"}
				,{"Harrower Infester"}
				,{"The Sightless Eye"}
			}
			--Scenario 48
			,[48] = {
				{"Forest Imp"}
				,{"Earth Demon"}
				,{"Harrower Infester"}
				,{"Dark Rider"}
			}
			--Scenario 49
			,[49] = {
				{"Giant Viper"}
				,{"City Archer"}
				,{"City Guard"}
				,{"Ancient Artillery"}
			}
			--Scenario 50
			,[50] = {
				{"Night Demon"}
				,{"Sun Demon"}
				,{"Earth Demon"}
				,{"Wind Demon"}
			}
			--Scenario 51
			,[51] = {
				{"The Gloom"}
			}
			--Scenario 52
			,[52] = {
				{"Spitting Drake"}
				,{"Ooze"}
				,{"Vermling Scout"}
				,{"Living Corpse"}
				,{"Vermling Shaman"}
			}
			--Scenario 53
			,[53] = {
				{"Ooze"}
				,{"Living Corpse"}
				,{"Living Spirit"}
				,{"Living Bones"}
				,{"Giant Viper"}
			}
			--Scenario 54
			,[54] = {
				{"Cave Bear"}
				,{"Living Spirit"}
				,{"Frost Demon"}
				,{"Harrower Infester"}
			}
			--Scenario 55
			,[55] = {}
			--Scenario 56
			,[56] = {
				{"Hound"}
				,{"Bandit Archer"}
				,{"Rending Drake"}
				,{"Bandit Guard"}
			}
			--Scenario 57
			,[57] = {
				{"City Guard"}
				,{"City Archer"}
				,{"Hound"}
			}
			--Scenario 58
			,[58] = {
				{"Earth Demon"}
				,{"Harrower Infester"}
				,{"Black Imp"}
				,{"City Guard"}
			}
			--Scenario 59
			,[59] = {
				{"Cave Bear"}
				,{"Hound"}
				,{"Forest Imp"}
			}
			--Scenario 60
			,[60] = {
				{"Ooze"}
				,{"Giant Viper"}
				,{"Hound"}
				,{"Rending Drake"}
				,{"Spitting Drake"}
			}
			--Scenario 61
			,[61] = {
				{"Ooze"}
				,{"Giant Viper"}
				,{"Frost Demon"}
				,{"Flame Demon"}
			}
			--Scenario 62
			,[62] = {
				{"Living Bones"}
				,{"Living Spirit"}
			}
			--Scenario 63
			,[63] = {
				{"Vermling Scout"}
				,{"Inox Guard"}
				,{"Inox Archer"}
			}
			--Scenario 64
			,[64] = {
				{"Ooze"}
				,{"Forest Imp"}
				,{"Rending Drake"}
			}
			--Scenario 65
			,[65] = {
				{"Vermling Scout"}
				,{"Hound"}
				,{"Inox Shaman"}
			}
			--Scenario 66
			,[66] = {
				{"Ooze"}
				,{"Ancient Artillery"}
				,{"Living Spirit"}
				,{"Stone Golem"}
			}
			--Scenario 67
			,[67] = {
				{"Forest Imp"}
				,{"Cave Bear"}
				,{"Stone Golem"}
			}
			--Scenario 68
			,[68] = {
				{"Rending Drake"}
				,{"Black Imp"}
				,{"Giant Viper"}
				,{"Living Corpse"}
			}
			--Scenario 69
			,[69] = {
				{"Vermling Scout"}
				,{"Vermling Shaman"}
				,{"Forest Imp"}
				,{"Stone Golem"}
				,{"Living Spirit"}
			}
			--Scenario 70
			,[70] = {
				{"Night Demon"}
				,{"Wind Demon"}
				,{"Living Spirit"}
			}
			--Scenario 71
			,[71] = {
				{"Spitting Drake"}
				,{"Wind Demon"}
				,{"Sun Demon"}
			}
			--Scenario 72
			,[72] = {
				{"Ooze"}
				,{"Forest Imp"}
				,{"Giant Viper"}
			}
			--Scenario 73
			,[73] = {
				{"Hound"}
				,{"Inox Archer"}
				,{"Ancient Artillery"}
				,{"Inox Guard"}
				,{"Inox Shaman"}
			}
			--Scenario  74
			,[74] = {
				{"Bandit Guard"}
				,{"Bandit Archer"}
				,{"Lurker"}
				,{"Deep Terror"}
			}
			--Scenario 75
			,[75] = {
				{"Living Bones"}
				,{"Living Corpse"}
				,{"Living Spirit"}
			}
			--Scenario 76
			,[76] = {
				 {"Giant Viper"}
				 ,{"Living Bones"}
				 ,{"Night Demon"}
				 ,{"Harrower Infester"}
			}
			--Scenario 77
			,[77] = {
				{"City Guard"}
				,{"City Archer"}
				,{"Stone Golem"}
				,{"Hound"}
			}
			--Scenario 78
			,[78] = {
				{"Bandit Guard"}
				,{"Bandit Archer"}
				,{"Cultist"}
				,{"Living Bones"}
				,{"Black Imp"}
			}
			--Scenario 79
			,[79] = {
				{"Stone Golem"}
				,{"Giant Viper"}
				,{"The Betrayer"}
			}
			--Scenario 80
			,[80] = {
				{"City Guard"}
				,{"City Archer"}
				,{"Ancient Artillery"}
				,{"Hound"}
			}
			--Scenario 81
			,[81] = {
				{"Night Demon"}
				,{"Sun Demon"}
				,{"Stone Golem"}
				,{"Ancient Artillery"}
				,{"The Colorless"}
			}
			--Scenario 82
			,[82] = {
				{"Earth Demon"}
				,{"Flame Demon"}
				,{"Stone Golem"}
			}
			--Scenario 83
			,[83] = {
				{"Hound"}
				,{"Cultist"}
				,{"Living Bones"}
				,{"Living Spirit"}
				,{"Flame Demon"}
			}
			--Scenario 84
			,[84] = {
				{"Flame Demon"}
				,{"Frost Demon"}
				,{"Earth Demon"}
			}
			--Scenario 85
			,[85] = {
				{"Hound"}
				,{"Black Imp"}
				,{"Night Demon"}
				,{"Sun Demon"}
			}
			--Scenario 86
			,[86] = {
				{"Cave Bear"}
				,{"Vermling Shaman"}
				,{"Vermling Scout"}
				,{"Lurker"}
			}
			--Scenario 87
			,[87] = {
				{"Lurker"}
				,{"Deep Terror"}
				,{"Ooze"}
				,{"Black Imp"}
			}
			--Scenario 88
			,[88] = {
				{"Frost Demon"}
				,{"Ooze"}
				,{"Lurker"}
			}
			--Scenario 89
			,[89] = {
				{"Bandit Archer"}
				,{"Bandit Guard"}
				,{"Cultist"}
				,{"Giant Viper"}
			}
			--Scenario 90
			,[90] = {
				{"Earth Demon"}
				,{"Wind Demon"}
				,{"Night Demon"}
				,{"Living Spirit"}
			}
			--Scenario 91
			,[91] = {
				{"Cave Bear"}
				,{"Hound"}
				,{"Bandit Guard"}
				,{"Bandit Archer"}
				,{"Living Spirit"}
			}
			--Scenario 92
			,[92] = {
				{"Bandit Guard"}
				,{"Bandit Archer"}
				,{"Inox Guard"}
				,{"Savvas Lavaflow"}
				,{"Flame Demon"}
				,{"Earth Demon"}
				,{"City Guard"}
				,{"City Archer"}
			}
			--Scenario 93
			,[93] = {
				{"Lurker"}
				,{"Frost Demon"}
				,{"Living Spirit"}
			}
			--Scenario 94
			,[94] = {
				{"Hound"}
				,{"Vermling Scout"}
				,{"Vermling Shaman"}
				,{"Cave Bear"}
			}
			--Scenario 95
			,[95] = {
				{"Deep Terror"}
				,{"Flame Demon"}
				,{"Earth Demon"}
				,{"Savvas Lavaflow"}
			}
		}

		local position = {x=22, y=1, z=10}
		if #t[NumScenario] == 5 or #t[NumScenario] == 6 then
			position.z = position.z + 5
		elseif #t[NumScenario] == 7 or #t[NumScenario] == 8 then
			position.z = position.z + 10
		end

		for _,tEnemy in ipairs(t[NumScenario]) do
			tEnemy.position	= position
			tEnemy.smooth	= false

			for _,obj in ipairs(AllObjects) do
				if obj.getName() == tEnemy[1] then
					obj.takeObject(tEnemy)
					break
				end
			end

			position.z = position.z - 5
		end

		return 1
	end
	startLuaCoroutine(self, "spawnEnemies")


	--Clean up and Delete all Bags
	function deleteObjects()
		wait(Delay_Delete)
		local AllObjects = getAllObjects()

		for _,obj in ipairs(AllObjects) do
			if (obj.getName() ~= '' and obj.getName() ~= nil and string.sub(obj.getName(),1,10) == "CreateMap_" ) then
				destroyObject(obj)
			end
		end

		return 1
	end
	startLuaCoroutine(self, "deleteObjects")
end




------------------
--Global Functions
------------------
function NoFunction() end

function spawnCallback(obj,params)
	if params.buttonLabel ~= nil then
		local t = {
			label			= params.buttonLabel
			,click_function	= "NoFunction"
			,function_owner	= self
			,position		= {0,0,0}
			,rotation		= {0,180-obj.getRotation().y,0}
		}

		if params.buttonTheme == "Treasure" then
			t.color		= {0.941,0.694,0.027}
			t.height	= 250
			t.width		= 280
			t.font_size	= 200
		end
		obj.createButton(t)
	end

	if params.lock == true then
		obj.lock()
	end

	if params.name ~= nil then
		obj.setName(params.name)
	end
end

function takeBagFromInfinite(InfiniteBag,FutureName)
	local pos = InfiniteBag.getPosition()
	pos.y = pos.y + 4
	local BagGUID = InfiniteBag.takeObject({
		position		= pos
		,callback		= "spawnCallback"
		,callback_owner	= self
		,params			= {
			lock	= true
			,name	= FutureName
		}
	}).getGUID()
	return BagGUID
end

function wait(time)
	local start = os.time()
	repeat coroutine.yield(0) until os.time() > start + time
end


--object data
allTheMapTiles = {['L2'] = {'http://cloud-3.steamusercontent.com/ugc/83722891599338299/02E41F15350C60685BEF5A5F7F739314D0468840/','http://cloud-3.steamusercontent.com/ugc/802048386390896281/43D2225AAB090BFFBB6F17110B6976871CCDFFBA/'} , 
['I2'] = {'http://cloud-3.steamusercontent.com/ugc/802048152546136215/85825BE7478C08ABC1C96A0CD06D5EEE0D34C4F5/','http://cloud-3.steamusercontent.com/ugc/928183875658027078/D75B9FBAF56FE061634EDC68A70E418EEE64F5A1/'} , 
['K2'] = {'http://cloud-3.steamusercontent.com/ugc/875244468232281023/55572ACC96212B3388AC64A76A3A82D02E281AEE/','http://cloud-3.steamusercontent.com/ugc/863985014568834768/A98C9BD0ADBE792A0B025D7C0BF0441D0E9282F7/'} , 
['G1'] = {'http://cloud-3.steamusercontent.com/ugc/83722391140199162/F8A8783AB59B297FA261895C15ACDB33C3101206/','http://cloud-3.steamusercontent.com/ugc/83722391140199619/7EBC404DBAFF2373B75D982B7A33E5CB34F91FFD/'} , 
['A3'] = {'http://cloud-3.steamusercontent.com/ugc/83721958684093483/D77C00D85CC3FFAF785716362E4353362F198BFB/','http://cloud-3.steamusercontent.com/ugc/802048562938730633/14A02CCF63C7FA45B6E8DEEB8914D5299533B332/'} , 
['N1'] = {'http://cloud-3.steamusercontent.com/ugc/802048562944496110/B7AA4E4C49A1CEA27C97090EEBFDC25EA0009A46/','http://cloud-3.steamusercontent.com/ugc/802048562944496560/B53C7E41C99E15B622D840394FF78AC486914EBB/'} , 
['B3'] = {'http://cloud-3.steamusercontent.com/ugc/802047973668669991/C509EF9EF97403C0C612D7D02D6B6CDBA1CC6987/','http://cloud-3.steamusercontent.com/ugc/802047973668654088/E857569A16C29194C7CC511724E6FC3ADC4B35F4/'} , 
['H3'] = {'http://cloud-3.steamusercontent.com/ugc/83721958677917505/517A0C5BCDB59858CEF2302169BA88B2911AB48C/','http://cloud-3.steamusercontent.com/ugc/83721958677989557/96027C60F80BD04EC11C43F94018102BC245230A/'} , 
['F1'] = {'http://cloud-3.steamusercontent.com/ugc/875244468232169382/251067F8092335B5CE772D9B7F1993084A58CF88/','http://cloud-3.steamusercontent.com/ugc/863985014571152087/E24C2EDCA435222EF0BDDBB53BC175407884BE99/'} , 
['K1'] = {'http://cloud-3.steamusercontent.com/ugc/875244468232281023/55572ACC96212B3388AC64A76A3A82D02E281AEE/','http://cloud-3.steamusercontent.com/ugc/863985014568461211/47220AF3B0D66B1C5EFDFF85A579A62C1E60C06C/'} , 
['E1'] = {'http://cloud-3.steamusercontent.com/ugc/875244468232069996/993F69505A6CC24ED906D251A4D2CFECAA00BF64/','http://cloud-3.steamusercontent.com/ugc/863985014571132187/A39BC02A7AD7A07E42E75D7C0B7D7121A185E4E8/'} , 
['L3'] = {'http://cloud-3.steamusercontent.com/ugc/83722891599338299/02E41F15350C60685BEF5A5F7F739314D0468840/','http://cloud-3.steamusercontent.com/ugc/863985014569248796/F45BD795E02F146CD3A9A1D193E6DE361B65E8D7/'} , 
['A2'] = {'http://cloud-3.steamusercontent.com/ugc/83721958684093483/D77C00D85CC3FFAF785716362E4353362F198BFB/','http://cloud-3.steamusercontent.com/ugc/802048562938727950/D189BE023398632DC89DD84CD121EEEA1CC9A0F0/'} , 
['B2'] = {'http://cloud-3.steamusercontent.com/ugc/83722391140246344/68EE0655821DBD75C2C8934489DB4F322EE960A2/','http://cloud-3.steamusercontent.com/ugc/83721958684100417/00CCC7A3B71F1F535A43407C0DCA51C196C91679/'} , 
['B4'] = {'http://cloud-3.steamusercontent.com/ugc/83722391140246344/68EE0655821DBD75C2C8934489DB4F322EE960A2/','http://cloud-3.steamusercontent.com/ugc/83722891599343654/03F71A5A0C7CB83953F89CE385005845F1F0C612/'} , 
['L1'] = {'http://cloud-3.steamusercontent.com/ugc/83722891599338299/02E41F15350C60685BEF5A5F7F739314D0468840/','http://cloud-3.steamusercontent.com/ugc/83722891599338968/905996632299E4F788392070F0ED4AC170EE3B5D/'} , 
['D1'] = {'http://cloud-3.steamusercontent.com/ugc/83722891611846459/66038720EFAFB3BE5D7232EAF4F0433AD52CF0D6/','http://cloud-3.steamusercontent.com/ugc/83722891611847427/5B8F3FEDB114AC8C8332CB11889DB33FB4476CBF/'} , 
['A1'] = {'http://cloud-3.steamusercontent.com/ugc/83721958684093483/D77C00D85CC3FFAF785716362E4353362F198BFB/','http://cloud-3.steamusercontent.com/ugc/83721958684075069/AFD7F49F6B43634134959A94DD652A65A632941C/'} , 
['M1'] = {'http://cloud-3.steamusercontent.com/ugc/83722391140191201/CBC468A064138817853D6106C1DE2AC48A9D65FB/','http://cloud-3.steamusercontent.com/ugc/83722391140147372/4E55A159785653540B0F2C5984C823709D6B42A2/'} , 
['J1'] = {'http://cloud-3.steamusercontent.com/ugc/802047661689178905/6DD2545C79B524302C5DEC09B0D8F495681B3B51/','http://cloud-3.steamusercontent.com/ugc/802047661689179670/3814548473F493C0245706EDF1D01BFEA73B0471/'} , 
['H2'] = {'http://cloud-3.steamusercontent.com/ugc/83721958677917505/517A0C5BCDB59858CEF2302169BA88B2911AB48C/','http://cloud-3.steamusercontent.com/ugc/83721958677905342/6D32F0BA97BBD5C8D2196CDBEE7B20FD279F52E7/'} , 
['C2'] = {'http://cloud-3.steamusercontent.com/ugc/83721958684061598/216FD3B93206D3563EFB432D653B1023428A7706/','http://cloud-3.steamusercontent.com/ugc/863985014569241871/EA0E681D787C54FE5B0D319EEF69A03EFCA621A0/'} , 
['A4'] = {'http://cloud-3.steamusercontent.com/ugc/83721958684093483/D77C00D85CC3FFAF785716362E4353362F198BFB/','http://cloud-3.steamusercontent.com/ugc/83722391140204849/EE9E9D85576486F58C518CF6CBDFB00BF08352E5/'} , 
['D2'] = {'http://cloud-3.steamusercontent.com/ugc/83722891611846459/66038720EFAFB3BE5D7232EAF4F0433AD52CF0D6/','http://cloud-3.steamusercontent.com/ugc/863985014569244468/854372DFC79BEDFC18D4205FF18BEACE451ACB40/'} , 
['J2'] = {'http://cloud-3.steamusercontent.com/ugc/802047661689178905/6DD2545C79B524302C5DEC09B0D8F495681B3B51/','http://cloud-3.steamusercontent.com/ugc/863985014569246699/EB9AF143171953202097C209FFD82E034803EC96/'} , 
['B1'] = {'http://cloud-3.steamusercontent.com/ugc/83722391140246344/68EE0655821DBD75C2C8934489DB4F322EE960A2/','http://cloud-3.steamusercontent.com/ugc/83722391140195969/F885D1EC3CC10E6876E090C79C3E00665FDA349F/'} , 
['C1'] = {'http://cloud-3.steamusercontent.com/ugc/83721958684061598/216FD3B93206D3563EFB432D653B1023428A7706/','http://cloud-3.steamusercontent.com/ugc/83721958684062489/4736A568BED40621759B5489AAB0CECDDBFDD05E/'} , 
['H1'] = {'http://cloud-3.steamusercontent.com/ugc/83721958677917505/517A0C5BCDB59858CEF2302169BA88B2911AB48C/','http://cloud-3.steamusercontent.com/ugc/83721958677880318/162CCE87AB3E4B2A1147C2A7384CD9F65F5E49AB/'} , 
['I1'] = {'http://cloud-3.steamusercontent.com/ugc/802048152546136215/85825BE7478C08ABC1C96A0CD06D5EEE0D34C4F5/','http://cloud-3.steamusercontent.com/ugc/802048152546127872/BDB4F4C57D2CDB7EBEB3C1D67F36EDD2F8BAC0CB/'} , 
['G2'] = {'http://cloud-3.steamusercontent.com/ugc/83722391140199162/F8A8783AB59B297FA261895C15ACDB33C3101206/','http://cloud-3.steamusercontent.com/ugc/802048562944492994/89242BB19171EF08C5FAAC75E4C7F5A7497B8800/'} 
}




allTheObjects = {['Treasure Chest Horizontal'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/83722391128231995/FF18CE3D5CF469D349FF094D7621F35D2D690E7E/'} , 
['Treasure Chest Vertical'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/875244656065692270/3D5176DFC33BE0AC13E7BBA1A23BC40B88480B49/'} , 
['Hot Coals 1'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/83722891599539752/B6C79AF76662558CB3ECC7B31DF00567962D7961/'} , 
['Hot Coals 2'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738804766/219FECA0BA9B6D8758161AB3EC85D157CEB20EB1/','http://cloud-3.steamusercontent.com/ugc/875244656065520967/E27867C410131BBF662082F5BAE8EDA47FBB8F42/'} , 
['Hot Coals 3'] = {'http://cloud-3.steamusercontent.com/ugc/802048562944608067/7C6D8D4F54EDA0210E0C27CA127E4F3941707937/','http://cloud-3.steamusercontent.com/ugc/875244656065620372/040E776071240F09C4FF87E213759E754495D071/'} , 
['Thorns'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/83722391140979668/55563C2223D19FC44775A2787947248FAAEAE5A7/'} , 
['Stone Door Horizontal'] = {'http://cloud-3.steamusercontent.com/ugc/83722391128365550/DEB708227991687C3022A86F49D86206392EB877/','http://cloud-3.steamusercontent.com/ugc/875244656065514661/02EAF3AFA27CF19CCF6A1A77B37F349517AF3611/'} , 
['Stone Door Vertical'] = {'http://cloud-3.steamusercontent.com/ugc/83722391128365550/DEB708227991687C3022A86F49D86206392EB877/','http://cloud-3.steamusercontent.com/ugc/802048152546220388/C181B4A53C920B8D6CF1D1C4DFC61513C9FB7057/'} , 
['Dark Fog'] = {'http://cloud-3.steamusercontent.com/ugc/83722391128365550/DEB708227991687C3022A86F49D86206392EB877/','http://cloud-3.steamusercontent.com/ugc/875244468232619595/0D734223A535DCFB2BA357D3EDBB6E14B6910BEF/'} , 
['Spike Trap'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/802047834669627945/48B796A39C4CCB08910B39832EB52EEE1336C790/'} , 
['Log'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738804766/219FECA0BA9B6D8758161AB3EC85D157CEB20EB1/','http://cloud-3.steamusercontent.com/ugc/83722391140982867/494C706DA2ED566D8DAA1A6478428E0BE2545166/'} , 
['Rubble'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/83722891611911546/CA70EAC4ED45D01B9DB8A55DC157F69A40DD781B/'} , 
['Earth Corridor 1'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/83722891599494871/00F862D6B5CB25E89C666D65CD2862BF9CA0F13E/'} , 
['Earth Corridor 2'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738804766/219FECA0BA9B6D8758161AB3EC85D157CEB20EB1/','http://cloud-3.steamusercontent.com/ugc/83722391141090318/F81E88196A2B98A9193B9E966F97E8DEDB907E2D/'} , 
['Man Stone Corridor 1'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/875244468232666187/E2822EA481A74EE412C92340F1BD250959A72947/'} , 
['Man Stone Corridor 2'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738804766/219FECA0BA9B6D8758161AB3EC85D157CEB20EB1/','http://cloud-3.steamusercontent.com/ugc/875244468232756686/863477ABC440769E4931FE83C97B0515F06813B9/'} , 
['Pressure Plate'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/802048152546593921/56844E4918A8BAC082EA1116A808392C9E0B606C/'} , 
['Wooden Corridor 1'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/875244468232666761/3C53984E626CE7A6DC4586B3188F979596FBF0A7/'} , 
['Bear Trap'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/83721958675842054/FD7DA328151E02C2116F97769B2205DD4544EBB2/'} , 
['Poison Gas'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/83722391128230364/494F2F861F980800352F54D4FD00AC004EEEBEE8/'} , 
['Wooden Corridor 2'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738804766/219FECA0BA9B6D8758161AB3EC85D157CEB20EB1/','http://cloud-3.steamusercontent.com/ugc/83721958669626124/5FEFE31B876469250F6C6B586582D62CD28389B4/'} , 
['Stairs Horizontal'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/83722391128274583/8CA463FD3885871B39D26AE1930AF35465560074/'} , 
['Stairs Vertical'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/83722391128261083/AC5DB293E39709A44279E427DA3BAB2A88CA844E/'} , 
['Water 1'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/83722391128233223/33C9CEE0F85B069281726DC04ECBB28D85CA820A/'} , 
['Water 2'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738804766/219FECA0BA9B6D8758161AB3EC85D157CEB20EB1/','http://cloud-3.steamusercontent.com/ugc/875244656065521674/9F7CEF40096C987777B155A31EEB9D646CB160EF/'} , 
['Stone Corridor 1'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/83722891599522130/F989782505CD1657E58FEE0A91682670554BF6D4/'} , 
['Stone Corridor 2'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738804766/219FECA0BA9B6D8758161AB3EC85D157CEB20EB1/','http://cloud-3.steamusercontent.com/ugc/875244468232757314/E1B6F305194385F06BC4D37D740E152758417AE9/'} , 
['Water 3'] = {'http://cloud-3.steamusercontent.com/ugc/802048562944608067/7C6D8D4F54EDA0210E0C27CA127E4F3941707937/','http://cloud-3.steamusercontent.com/ugc/875244656065619255/126893F63C7EE50C723E53A5067C7219CB677260/'} , 
['LIght Fog'] = {'http://cloud-3.steamusercontent.com/ugc/83722391128365550/DEB708227991687C3022A86F49D86206392EB877/','http://cloud-3.steamusercontent.com/ugc/875244468232620736/26CA5060B314637080E0E8EFC5146DF226C42F86/'} , 
['Wooden Door Horizontal'] = {'http://cloud-3.steamusercontent.com/ugc/83722391128365550/DEB708227991687C3022A86F49D86206392EB877/','http://cloud-3.steamusercontent.com/ugc/83722391128366173/B80EA353B6F74167420670A7B3C9D4D61034538A/'} , 
['Wooden Door Vertical'] = {'http://cloud-3.steamusercontent.com/ugc/83722391128365550/DEB708227991687C3022A86F49D86206392EB877/','http://cloud-3.steamusercontent.com/ugc/83722391128368061/8F26DDD8891708056F9E64ADB2F309A233ACBE13/'} , 
['Wall Section'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738804766/219FECA0BA9B6D8758161AB3EC85D157CEB20EB1/','http://cloud-3.steamusercontent.com/ugc/875244656065519934/3A7D80E0A1C9A917AF869DB741A68CF203847C79/'} , 
['Tree'] = {'http://cloud-3.steamusercontent.com/ugc/83722391141011936/ECE63C2A354D7E832CEB67F368D4F76F8C7F8DD7/','http://cloud-3.steamusercontent.com/ugc/83722391140985138/374A2F04838BDC93EE86366C38044755507EEA55/'} , 
['Totem'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/83722391140980718/1D1AE577AF3C977428EB6A073601BA19884F4942/'} , 
['Table'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738804766/219FECA0BA9B6D8758161AB3EC85D157CEB20EB1/','http://cloud-3.steamusercontent.com/ugc/83722891599505650/FED7465DD372D6958E492BB4B8A4A22098C7CAEB/'} , 
['Stump'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/83722391140978180/9693DE4816A74B035515CE631F5454C8D09E81C9/'} , 
['Stone Pillar'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/83722891611900662/09BC7042814EAD0FBA638B032C3606D0F626CE5E/'} , 
['Stalagmites'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/802048562944618973/2E8C2BF2F2824127431FAFF3B4D63342DBD26F9B/'} , 
['Shelf'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738804766/219FECA0BA9B6D8758161AB3EC85D157CEB20EB1/','http://cloud-3.steamusercontent.com/ugc/83722391128241835/2C45A4B6FD14A2F9181049F6C9607815ED3768EB/'} , 
['Sarcophagus B'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738804766/219FECA0BA9B6D8758161AB3EC85D157CEB20EB1/','http://cloud-3.steamusercontent.com/ugc/875244468232525452/369DD3F6241A3B79D0F09999D4E3EB0F329B1C7C/'} , 
['Sarcophagus A'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738804766/219FECA0BA9B6D8758161AB3EC85D157CEB20EB1/','http://cloud-3.steamusercontent.com/ugc/802048562938772696/EC1D14D6BF812F63FD0C72E6AAB2232E4A518383/'} , 
['Rock Column'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/802048562944644041/C7FBE53A654430523E69FEA025E9BBDF23BEA007/'} , 
['Nest'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/875244656065519031/5747BCC064E27505F54E277E1E6236EDD09994AF/'} , 
['Fountain'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/875244656065518204/F3FDCD484410DD540CBA972D11BEC8D506B156CF/'} , 
['Dark Pit'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738804766/219FECA0BA9B6D8758161AB3EC85D157CEB20EB1/','http://cloud-3.steamusercontent.com/ugc/83722391128240948/5CC94879812EC8D314CE47DCBF37B3D04929FF7F/'} , 
['Crystal'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/875244656065517489/94D5D035B8BB64869ABED5E6B0F9422D2FFBBEF8/'} , 
['Crate B'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/875244656065516279/B80FD4273328707C7BDC96288B90F23B351CA19C/'} , 
['Crate A'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/875244656065516927/FAB47B7FABF7768ECCD01887EDEA49DECBDF4147/'} , 
['Cabinet'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/83721528738705488/1BC41B1296BC27984BA50CDCA1026181E42A5477/'} , 
['Bush 1'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/875244468232642063/9E7826348FEF1BF8B17C42D67573158D76F1437E/'} , 
['Boulder 3'] = {'http://cloud-3.steamusercontent.com/ugc/802048562944608067/7C6D8D4F54EDA0210E0C27CA127E4F3941707937/','http://cloud-3.steamusercontent.com/ugc/802048562944608381/92DD474416E98C91ABF2FC6888F3A088755743BB/'} , 
['Boulder 2'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738804766/219FECA0BA9B6D8758161AB3EC85D157CEB20EB1/','http://cloud-3.steamusercontent.com/ugc/802048562944610090/E8B8E5B9E828B8D68E9EB7F0983E80F9497AABB1/'} , 
['Boulder'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/83722391128239231/ECFAA8D897C5950DA1AE2AB7BD396582B53F581C/'} , 
['Bookcase'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738804766/219FECA0BA9B6D8758161AB3EC85D157CEB20EB1/','http://cloud-3.steamusercontent.com/ugc/875244468232558012/978B7355577B6B9E4BE0370C1502B672A7DAB0B5/'} , 
['Barrel'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/83721528738779719/EC94DB858B1C55C7C68D111C839FD74F49F2EB9B/'} , 
['Altar Horizontal'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/875244468232439199/4F1C58B1DE6E3999E2D0F207C503BA9A500F52EF/'} , 
['Altar Vertical'] = {'http://cloud-3.steamusercontent.com/ugc/83721528738764794/4991992B121C950439220491B89158F7D80A1888/','http://cloud-3.steamusercontent.com/ugc/83722891611903816/58F3379303B47B150145BBC91E307233461D205D/'} 
}