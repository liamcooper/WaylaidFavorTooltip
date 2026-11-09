-- Fill options for empty Waylaid Crates.
-- Each crate accepts any one bundle; the tooltip picks the cheapest priced option.

WaylaidFavorTooltip = WaylaidFavorTooltip or {}

-- itemID = quantity. Classic item IDs.
local R = {
  -- Herbs
  Peacebloom = 2447,
  Silverleaf = 765,
  Earthroot = 2449,
  Mageroyal = 785,
  Briarthorn = 2450,
  Stranglekelp = 3820,
  Bruiseweed = 2453,
  WildSteelbloom = 3355,
  GraveMoss = 3369,
  Kingsblood = 3356,
  Liferoot = 3357,
  Fadeleaf = 3818,
  Goldthorn = 3821,
  KhadgarsWhisker = 3358,
  Wintersbite = 3819,
  Firebloom = 4625,
  PurpleLotus = 8831,
  ArthasTears = 8836,
  GoldenSansam = 13464,
  Sungrass = 8838,
  Blindweed = 8839,
  GhostMushroom = 8845,
  Gromsblood = 8846,
  Dreamfoil = 13463,
  MountainSilversage = 13465,
  Plaguebloom = 13466,
  Icecap = 13467,
  -- Ore
  CopperOre = 2770,
  TinOre = 2771,
  SilverOre = 2775,
  IronOre = 2772,
  GoldOre = 2776,
  MithrilOre = 3858,
  TruesilverOre = 7911,
  ThoriumOre = 10620,
  DarkIronOre = 11370,
  -- Textiles
  LinenCloth = 2589,
  LightLeather = 2318,
  WoolCloth = 2592,
  SilkCloth = 4306,
  MediumLeather = 2319,
  MageweaveCloth = 4338,
  HeavyLeather = 4234,
  Runecloth = 14047,
  ThickLeather = 4304,
  RuggedLeather = 8170,
  -- Curiosities
  StrangeDust = 10940,
  GreaterMagicEssence = 10939,
  SmallGlimmeringShard = 10978,
  LargeGlimmeringShard = 11084,
  SoulDust = 11083,
  GreaterAstralEssence = 11082,
  SmallGlowingShard = 11138,
  LargeGlowingShard = 11139,
  VisionDust = 11137,
  GreaterMysticEssence = 11135,
  SmallRadiantShard = 11177,
  LargeRadiantShard = 11178,
  DreamDust = 11176,
  GreaterNetherEssence = 11175,
  SmallBrilliantShard = 14343,
  LargeBrilliantShard = 14344,
  -- Fabrics
  CuredLightHide = 4231,
  BoltOfLinenCloth = 2996,
  BoltOfWoolenCloth = 2997,
  BoltOfSilkCloth = 4305,
  CuredMediumHide = 4233,
  BoltOfMageweave = 4339,
  CuredHeavyHide = 4236,
  BoltOfRunecloth = 14048,
  CuredThickHide = 8172,
  -- Ingots
  CopperBar = 2840,
  TinBar = 3576,
  BronzeBar = 2841,
  SilverBar = 2842,
  IronBar = 3575,
  MithrilBar = 3860,
  SteelBar = 3859,
  GoldBar = 3577,
  DarkIronBar = 11371,
  TruesilverBar = 6037,
  ThoriumBar = 12359,
  -- Parts
  HandfulOfCopperBolts = 4359,
  CopperTube = 4361,
  CopperModulator = 4363,
  BronzeTube = 4371,
  WhirringBronzeGizmo = 4375,
  BronzeFramework = 4382,
  GoldPowerCore = 10558,
  IronStrut = 4387,
  MithrilTube = 10559,
  UnstableTrigger = 10560,
  MithrilCasing = 10561,
  ThoriumWidget = 15994,
  TruesilverTransformer = 18631,
  ThoriumTube = 16000,
}

local function B(itemID, qty)
  return { itemID = itemID, qty = qty }
end

-- crate itemID -> list of fill bundles (any one fills the crate)
WaylaidFavorTooltip.FillRecipes = {
  -- Apprentice
  [248682] = { -- Herbs
    B(R.Peacebloom, 20), B(R.Silverleaf, 20), B(R.Earthroot, 10), B(R.Mageroyal, 10), B(R.Briarthorn, 10),
  },
  [248683] = { -- Ore
    B(R.CopperOre, 20), B(R.TinOre, 20),
  },
  [248684] = { -- Textiles
    B(R.LinenCloth, 40), B(R.LightLeather, 20),
  },
  [248685] = { -- Curiosities
    B(R.StrangeDust, 20), B(R.GreaterMagicEssence, 4), B(R.SmallGlimmeringShard, 6), B(R.LargeGlimmeringShard, 2),
  },
  [248702] = { -- Fabrics
    B(R.CuredLightHide, 2), B(R.BoltOfLinenCloth, 20),
  },
  [248703] = { -- Ingots
    B(R.CopperBar, 20), B(R.TinBar, 20), B(R.BronzeBar, 10),
  },
  [248704] = { -- Parts
    B(R.HandfulOfCopperBolts, 16), B(R.CopperTube, 16), B(R.CopperModulator, 4),
  },

  -- Journeyman
  [248686] = { -- Herbs
    B(R.Stranglekelp, 10), B(R.Bruiseweed, 10), B(R.WildSteelbloom, 10), B(R.GraveMoss, 10), B(R.Kingsblood, 10),
  },
  [248687] = { -- Ore
    B(R.SilverOre, 10), B(R.IronOre, 20),
  },
  [248688] = { -- Textiles
    B(R.WoolCloth, 20), B(R.SilkCloth, 40), B(R.MediumLeather, 20),
  },
  [248689] = { -- Curiosities
    B(R.SoulDust, 20), B(R.GreaterAstralEssence, 4), B(R.SmallGlowingShard, 6), B(R.LargeGlowingShard, 2),
  },
  [248705] = { -- Fabrics
    B(R.BoltOfWoolenCloth, 6), B(R.BoltOfSilkCloth, 10), B(R.CuredMediumHide, 2),
  },
  [248706] = { -- Ingots
    B(R.SilverBar, 10), B(R.IronBar, 20),
  },
  [248707] = { -- Parts
    B(R.BronzeTube, 8), B(R.WhirringBronzeGizmo, 7), B(R.BronzeFramework, 4), B(R.GoldPowerCore, 45),
  },

  -- Expert
  [248690] = { -- Earthly Expert Herbs
    B(R.Liferoot, 20), B(R.Fadeleaf, 10), B(R.Goldthorn, 10), B(R.KhadgarsWhisker, 10),
  },
  [248691] = { -- Flowering Expert Herbs
    B(R.Wintersbite, 10), B(R.Firebloom, 10), B(R.PurpleLotus, 20), B(R.ArthasTears, 10),
  },
  [248692] = { -- Ore
    B(R.GoldOre, 10), B(R.MithrilOre, 20),
  },
  [248693] = { -- Textiles
    B(R.MageweaveCloth, 40), B(R.HeavyLeather, 20),
  },
  [248694] = { -- Curiosities
    B(R.VisionDust, 20), B(R.GreaterMysticEssence, 4), B(R.SmallRadiantShard, 6), B(R.LargeRadiantShard, 2),
  },
  [248708] = { -- Fabrics
    B(R.BoltOfMageweave, 8), B(R.CuredHeavyHide, 2),
  },
  [248709] = { -- Ingots
    B(R.MithrilBar, 20), B(R.SteelBar, 15), B(R.GoldBar, 10),
  },
  [248710] = { -- Parts
    B(R.IronStrut, 8), B(R.MithrilTube, 5), B(R.UnstableTrigger, 12), B(R.MithrilCasing, 5),
  },

  -- Artisan
  [248695] = { -- Earthly Artisan Herbs
    B(R.GoldenSansam, 10), B(R.Sungrass, 20), B(R.Blindweed, 10), B(R.GhostMushroom, 10), B(R.Gromsblood, 10),
  },
  [248696] = { -- Flowering Artisan Herbs
    B(R.Dreamfoil, 20), B(R.MountainSilversage, 20), B(R.Plaguebloom, 20), B(R.Icecap, 20),
  },
  [248697] = { -- Ore
    B(R.TruesilverOre, 10), B(R.ThoriumOre, 20), B(R.DarkIronOre, 20),
  },
  [248698] = { -- Textiles
    B(R.Runecloth, 40), B(R.ThickLeather, 20), B(R.RuggedLeather, 20),
  },
  [248699] = { -- Curiosities
    B(R.DreamDust, 20), B(R.GreaterNetherEssence, 4), B(R.SmallBrilliantShard, 6), B(R.LargeBrilliantShard, 2),
  },
  [248711] = { -- Fabrics
    B(R.BoltOfRunecloth, 8), B(R.CuredThickHide, 2),
  },
  [248712] = { -- Ingots
    B(R.DarkIronBar, 2), B(R.TruesilverBar, 10), B(R.ThoriumBar, 20),
  },
  [248713] = { -- Parts
    B(R.ThoriumWidget, 5), B(R.TruesilverTransformer, 5), B(R.ThoriumTube, 2),
  },
}
