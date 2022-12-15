Config = {}

Config.Debug = false



Config.HorseInvWeight = 150000
Config.HorseInvSlots = 15

Config.dontallowwagonintown = false -- in lucru
Config.dontallowhorseintown = false -- inca nu

Config.aproapedeoras = "Prea aproape de Oras"
Config.nowagon = "Nu detii nici un Wagon sau nu ai unu selectat"

Config.BannedTowns = {'Annesburg', 'Armadillo', 'Blackwater', 'Rhodes', 'Siska', 'StDenis', 'Strawberry', 'Tumbleweed', 'Valentine', 'Vanhorn'} -- inca nu


Config.horsehealcost = 5 -- cost to heal horse after its dead 
Config.deadtimer = 150000 -- time until horse can be called again, set to 2.5 minutes

--------------------------------------
Config.callnearstable = false -- turn to true to allow horse calling only near stable 
Config.calldistance = 30 -- how far from stable coords does calling the horse stop 


Config.traineronly = true -- only trainers can increase exp
Config.horselead = 30000 -- every 20 seconds increase by 1 bonding for leading
Config.horseride = 50000 -- every 40 seconds increase by 1 bonding for riding


Config.spawnrangewagon = 20.0 ---- make sure the number has .0 in the end, for example 10.0 or 5.0(spawn horse in direction player is facing this amount of units away)
Config.horsedistancecall = 300 -- distance where if the horse is further it will despawn and a new horse will go to player 




Config.keys = { -- only change the hashes
["one"] = 0xD8F73058, --U
["two"] = 0xF3830D8E, --J    0xF3830D8E
["three"] = 0x24978A28, --H
["four"] = 0x8AAA0AD4, --ALT Rear up
["five"] = 0xD9D0E1C0, --space Rear up
["six"] = 0xCEFD9220, -- E -- 

}



Config.Stables = {
	Valentine = {
		Pos = vector3(-367.73, 787.72, 116.26),
		Name = 'Stable',
        	Heading = -30.65,
		SpawnPoint = {
			Pos = vector3(-372.43, 791.79, 116.13),
			CamPos = {x=1, y=-3, z=0},
			Heading = 182.3
        },
		SpawnPoint2 = {
			Pos = {x=-387.40, y=780.68, z=115.63},
			CamPos = {x=1, y=-3, z=0},
			Heading = 336.88
        }
    },
	Blackwater = {
		Pos = vector3(-873.63, -1361.89, 43.53),
		Name = 'Stable',
        	Heading = -30.65,
		SpawnPoint = {
			Pos = vector3(-886.81, -1377.98, 43.77),
			CamPos = {x=1, y=-2, z=1},
			Heading = 91.14
        },
		SpawnPoint2 = {
			Pos = {x=-387.40, y=780.68, z=115.63},
			CamPos = {x=1, y=-3, z=0},
			Heading = 336.88
        }
    },
	SaintDenis = {
		Pos = vector3(2503.13, -1449.08, 46.3),
		Name = 'Stable',
        	Heading = -30.65,
		SpawnPoint = {
			Pos = vector3(2508.41, -1446.89, 46.4),
			CamPos = {x=1, y=-3, z=0},
			Heading = 87.88
        },
		SpawnPoint2 = {
			Pos = {x=-387.40, y=780.68, z=115.63},
			CamPos = {x=1, y=-3, z=0},
			Heading = 336.88
        }
	},
	Annesburg = {
		Pos = vector3(2972.35, 1425.35, 44.67),
		Name = 'Stable',
        	Heading = -30.65,
		SpawnPoint = {
			Pos = vector3(2970.43, 1429.35, 44.7),
			CamPos = {x=1, y=-3, z=0},
			Heading = 223.94
        },
		SpawnPoint2 = {
			Pos = {x=-387.40, y=780.68, z=115.63},
			CamPos = {x=1, y=-3, z=0},
			Heading = 336.88
        }
	},
	Rhodes = {
		Pos = vector3(1321.46, -1358.66, 78.39),
		Name = 'Stable',
        	Heading = -30.65,
		SpawnPoint = {
			Pos = vector3(1318.74, -1354.64, 78.18),
			CamPos = {x=1, y=-3, z=0},
			Heading = 249.45
        },
		SpawnPoint2 = {
			Pos = {x=-387.40, y=780.68, z=115.63},
			CamPos = {x=1, y=-3, z=0},
			Heading = 336.88
        }
	},
	Tumbleweed = {
		Pos = vector3(-5519.43, -3043.45, -2.39),
		Name = 'Stable',
        	Heading = 0.0,
		SpawnPoint = {
			Pos = vector3(-5522.14, -3039.16, -2.29),
			CamPos = {x=1, y=-3, z=0},
			Heading = 189.93
        },
		SpawnPoint2 = {
			Pos = {x=-387.40, y=780.68, z=115.63},
			CamPos = {x=1, y=-3, z=0},
			Heading = 336.88
        }
	},		
}

Config.Horses = {
	{
		name = "Arabian",
		["A_C_Horse_Arabian_White"] = {"White", 15000, 12000},
		["A_C_Horse_Arabian_RoseGreyBay"] = {"Rose Grey Bay", 15500, 12625},
		["A_C_Horse_Arabian_Black"] = {"Black", 12050, 10560},
		["A_C_Horse_Arabian_Grey"] = {"Grey", 12150, 10680},
		["A_C_Horse_Arabian_WarpedBrindle_PC"] = {"Warped Brindle", 8500, 8125},
		["A_C_Horse_Arabian_RedChestnut"] = {"Red Chestnut", 4500, 4375},
	},
	{
		name = "Ardennes",
		["A_C_Horse_Ardennes_IronGreyRoan"] = {"Iron Grey Roan", 12000, 11250},
		["A_C_Horse_Ardennes_StrawberryRoan"] = {"Strawberry Roan", 4700, 4550},
		["A_C_Horse_Ardennes_BayRoan"] = {"Bay Roan", 8500, 8350},
	},
	{
		name = "Missouri Fox Trotter",
		["A_C_Horse_MissouriFoxTrotter_AmberChampagne"] = {"Amber Champagne", 9500, 9350},
		["A_C_Horse_MissouriFoxTrotter_SableChampagne"] = {"Sable Champagne", 9500, 9350},
		["A_C_Horse_MissouriFoxTrotter_SilverDapplePinto"] = {"Silver Dapple Pinto", 9500, 9350},
	},
	{
		name = "Turkoman",
		["A_C_Horse_Turkoman_Gold"] = {"Gold", 9500, 9350},
		["A_C_Horse_Turkoman_Silver"] = {"Silver", 9500, 9350},
		["A_C_Horse_Turkoman_DarkBay"] = {"Dark Bay", 9250, 9200},
	},
	{
		name = "Appaloosa",
		["A_C_Horse_Appaloosa_BlackSnowflake"] = {"Snow Flake", 9100, 9000},
		["A_C_Horse_Appaloosa_BrownLeopard"] = {"Brown Leopard", 4500, 4350},
		["A_C_Horse_Appaloosa_Leopard"] = {"Leopard", 4300, 4250},
		["A_C_Horse_Appaloosa_FewSpotted_PC"] = {"Few Spotted", 1400, 1325},
		["A_C_Horse_Appaloosa_Blanket"] = {"Blanket", 2400, 2250},
		["A_C_Horse_Appaloosa_LeopardBlanket"] = {"Lepard Blanket", 1500, 1450},
	},
	{
		name = "Mustang",
		["A_C_Horse_Mustang_GoldenDun"] = {"Golden Dun", 9500, 9350},
		["A_C_Horse_Mustang_TigerStripedBay"] = {"Tiger Striped Bay", 3500, 3450},
		["A_C_Horse_Mustang_GrulloDun"] = {"Grullo Dun", 1300, 1200},
		["A_C_Horse_Mustang_WildBay"] = {"Wild Bay", 1300, 1200},
	},
	{
		name = "Thoroughbred",
		["A_C_Horse_Thoroughbred_BlackChestnut"] = {"Black Chestnut", 5500, 5350},
		["A_C_Horse_Thoroughbred_BloodBay"] = {"Blood Bay", 5500, 5350},
		["A_C_Horse_Thoroughbred_Brindle"] = {"Brindle", 5500, 5350},
		["A_C_Horse_Thoroughbred_ReverseDappleBlack"] = {"Reverse Dapple Black", 5500, 5350},
		["A_C_Horse_Thoroughbred_DappleGrey"] = {"Dapple Grey", 1300, 1550},
	},
	{
		name = "Andalusian",
		["A_C_Horse_Andalusian_Perlino"] = {"Perlino", 4500, 4350},
		["A_C_Horse_Andalusian_RoseGray"] = {"Rose Gray", 4400, 4350},
		["A_C_Horse_Andalusian_DarkBay"] = {"Dark Bay", 1400, 1350},
	},
	{
		name = "Dutch Warmblood",
		["A_C_Horse_DutchWarmblood_ChocolateRoan"] = {"Chocolate Roan", 4500, 4350},
		["A_C_Horse_DutchWarmblood_SealBrown"] = {"Seal Brown", 1500, 1350},
		["A_C_Horse_DutchWarmblood_SootyBuckskin"] = {"Sooty Buckskin", 1500, 1350},
	},
	{
		name = "Nokota",
		["A_C_Horse_Nokota_ReverseDappleRoan"] = {"Reverse Dapple Roan", 4500, 4350},
		["A_C_Horse_Nokota_BlueRoan"] = {"Blue Roan", 1300, 1300},
		["A_C_Horse_Nokota_WhiteRoan"] = {"White Roan", 1300, 1300},
	},
	{
		name = "American Paint",
		["A_C_Horse_AmericanPaint_Greyovero"] = {"Grey Overo", 4250, 4200},
		["A_C_Horse_AmericanPaint_SplashedWhite"] = {"Splashed White", 1400, 1325},
		["A_C_Horse_AmericanPaint_Tobiano"] = {"Tobiano", 1400, 1325},
		["A_C_Horse_AmericanPaint_Overo"] = {"Overo", 1300, 1255},
	},
	{
		name = "American Standardbred",
		["A_C_Horse_AmericanStandardbred_SilverTailBuckskin"] = {"Silver Tail Buckskin", 4300, 4250},
		["A_C_Horse_AmericanStandardbred_PalominoDapple"] = {"Palomino Dapple", 1800, 1750},
		["A_C_Horse_AmericanStandardbred_Black"] = {"Black", 1600, 1500},
		["A_C_Horse_AmericanStandardbred_Buckskin"] = {"Buckskin", 1600, 1550},
	},
	{
		name = "Kentucky Saddle",
		["A_C_Horse_KentuckySaddle_ButterMilkBuckskin_PC"] = {"Butter Milk Buckskin", 2600, 2500},
		["A_C_Horse_KentuckySaddle_Black"] = {"Black", 500, 455},
		["A_C_Horse_KentuckySaddle_ChestnutPinto"] = {"Chestnut Pinto", 545, 425},
		["A_C_Horse_KentuckySaddle_Grey"] = {"Grey", 525, 435},
		["A_C_Horse_KentuckySaddle_SilverBay"] = {"Silver Bay", 555, 465},
	},
	{
		name = "Hungarian Halfbred",
		["A_C_Horse_HungarianHalfbred_DarkDappleGrey"] = {"Dark Dapple Grey", 1700, 1650},
		["A_C_Horse_HungarianHalfbred_LiverChestnut"] = {"Liver Chestnut", 1700, 1645},
		["A_C_Horse_HungarianHalfbred_FlaxenChestnut"] = {"Flaxen Chestnut", 1600, 1565},
		["A_C_Horse_HungarianHalfbred_PiebaldTobiano"] = {"Piebald Tobiano", 1600, 1585},
	},
	{
		name = "Suffolk Punch",
		["A_C_Horse_SuffolkPunch_RedChestnut"] = {"Red Chestnut", 1800, 1750},
		["A_C_Horse_SuffolkPunch_Sorrel"] = {"Sorrel", 1800, 1500},
	},
	{
		name = "Tennessee Walker",
		["A_C_Horse_TennesseeWalker_FlaxenRoan"] = {"Flaxen Roan", 1800, 1750},
		["A_C_Horse_TennesseeWalker_BlackRabicano"] = {"Black Rabicano", 900, 800},
		["A_C_Horse_TennesseeWalker_Chestnut"] = {"Chestnut", 900, 800},
		["A_C_Horse_TennesseeWalker_DappleBay"] = {"Dapple Bay", 900, 750},
		["A_C_Horse_TennesseeWalker_MahoganyBay"] = {"Mahogany Bay", 900, 750},
		["A_C_Horse_TennesseeWalker_RedRoan"] = {"Red Roan", 900, 775},
		["A_C_Horse_TennesseeWalker_GoldPalomino_PC"] = {"Gold Palomino", 900, 775},
	},
	{
		name = "Shire",
		["A_C_Horse_Shire_LightGrey"] = {"Light Grey", 1600, 1500},
		["A_C_Horse_Shire_RavenBlack"] = {"Raven Black", 1600, 1525},
		["A_C_Horse_Shire_DarkBay"] = {"Dark Bay", 1600, 1495},
	},
	{
		name = "Belgian Draft",
		["A_C_Horse_Belgian_BlondChestnut"] = {"Blond Chestnut", 1600, 1350},
		["A_C_Horse_Belgian_MealyChestnut"] = {"Mealy Chestnut", 1600, 1355},
	},
	{
		name = "Morgan",
		["A_C_Horse_Morgan_Palomino"] = {"Palomino", 800, 750},
		["A_C_Horse_Morgan_Bay"] = {"Bay", 400, 368},
		["A_C_Horse_Morgan_BayRoan"] = {"Bay Roan", 850, 775},
		["A_C_Horse_Morgan_FlaxenChestnut"] = {"Flaxen Chestnut", 850, 785},
		["A_C_Horse_Morgan_LiverChestnut_PC"] = {"Liver Chestnut", 850, 785},
	},
	{
		name = "Other",
		["A_C_Horse_Gang_Dutch"] = {"Gang Duch", 3400, 3250},
		["A_C_HorseMule_01"] = {"Mule", 210, 200},
		["A_C_HorseMulePainted_01"] = {"Zebra", 200, 175},
		["A_C_Donkey_01"] = {"Donkey", 200, 170},
		["A_C_Horse_MP_Mangy_Backup"] = {"Mangy Backup", 200, 165},
	},
	{
		name = "Other2",
		["a_c_horse_gypsycob_palominoblagdon"] = {"Palominob Lagdon", 16650, 16450},
		["a_c_horse_gypsycob_piebald"] = {"Piebald", 15950, 15850},
		["a_c_horse_gypsycob_skewbald"] = {"Skew Bald", 16550, 15650},
		["a_c_horse_gypsycob_splashedbay"] = {"Splashed Bay", 16550, 15550},
		["a_c_horse_gypsycob_splashedpiebald"] = {"Splashed Piebald", 16550, 15550},
		["a_c_horse_gypsycob_whiteblagdon"] = {"White Blagdon", 16550, 15550},
	}
	
}


Config.Language = { -- space is very important edit your language here ! 
	["asteaptacalmort"] = "Trebuie sa astepti ",
	["horsemax"] = "your horse cant carry more items, saddle limit is ",
	["wagonmax"] = "your wagon cant store more items, inventory limit limit is ",
	["carry"] = "You cant carry more items",
    ["limit"] = "You reached the limit for this item",
    ["givehorse"] = "You gave your horse to ",
    ["givewagon"] = "You gave your wagon to ",
    ["receiveHorse"] = "You received a horse ownership deed from ",
    ["receivewagon"] = "You received a wagon ownership deed from ",
    ["horselimit"] = " tried to give you a horse but you are at your stables slot limit",
    ["wagonlimit"] = " tried to give you a wagon but you are at your stables wagon limit",
    ["horselimit2"] = " is at stable slot limit",
    ["wagonlimit2"] = " is at stable slot limit",
	["wrongid"] = "Wrong ID",
	["nogold"] = "Not Enough Gold",
	["nocash"] = "Not Enough Cash",
	["limitwagon"] = "You cant buy more wagons.",
	["limithorse"] = "You cant buy more horses.",
	["horsesold"] = "You have sold your horse",
	["wagonsold"] = "You have sold your wagon",
	["open"] = "Open Stable",
	["stable"] = "Stable",
	["name"] = "Name your horse:",
	["name2"] = "Name your wagon:",
	["nowagon"] = "you dont have a wagon selected",
	["nohorse"] = "you dont have a horse selected",
	["horseinfo"] = "Detalii Cal:",
	["wagoninfo"] = "Detalii Caruta:",
	["sure"] = "Are You Sure?",
	["horsename"] = "Nume Cal: ",
	["horsetrainlevel"] = "Level Antrenament Cal: ",
	["horsetrainexp"] = "Level Experienta Cal: ",
	["givehorseowner"] = "In Curand Ofera Cal",
	["saddlebags"] = "Inventar Cal",
	["wagonname"] = "Nume Caruta: ",
	["dismiss"] = "Parcheaza Caruta",
	["givewagonowner"] = "In Curand Ofera Caruta",
	["wagoninv"] = "Inventar Caruta",
	["yes"] = "Da",
	["no"] = "Nu",
	["wagon"] = "Caruta",
	["tired"] = "you are too tired to train your horse",
	["tired2"] = "you need some rest. horse training stopped wait 5 minutes",
	["better"] = "you feel better and can train your horse",
	["level2"] = "you need horse training level 2",
	["level3"] = "you need horse training level 3",
	["level4"] = "you need horse training level 4",
	["water"] = "your horse is not in water",
	["deadhorse"] = "Calul tau este Bolnav, Incearca mai tarziu", 
	["payfordead"] = "your horse was healed by the vet, you paid ",
	["equipment"] = "Outfitter Menu",
	["sex"] = "Horse Sex",
	["cancel"] = "Cancel Buying",
	["male"] = "Male",
	["female"] = "Female",
	["toofarfromstable"] = "Too Far From Stable",
	["someonesearch"] = "Someone is Searching already",
	["tooclosetown"] = "too close to town",
	["waypoint"] = "Waypoint", -- new line
	["processing"] = "Please Wait",
	["attemptybuy"] = "Attempted Buy",
	["attemptybuy2"] = "Attempted buying via exploit. by logging out after naming",
	["boughthorse"] = "buy",
	["seoldhorse"] = "sold",
	["withdrawhorse"] = "withdraw item from horse",
	["depohorse"] = "deposit item to horse",
	["depowagon"] = "deposit item to wagon",
	["withdrawwagon"] = "withdraw item from wagon",
	["information"] = "info: ",
	["discord1"] = "Discord of user:",
	["discord2"] = "username of user:",
	["discord3"] = "Discord of owner:",
}




