-- WaylaidFavorTooltip
-- Merchant's Favor + cheapest Auctionator fill cost on Waylaid / Sealed crate tooltips.

local ADDON_NAME = ...
WaylaidFavorTooltip = WaylaidFavorTooltip or {}

local CALLER_ID = "WaylaidFavorTooltip"

-- Favor by tier and item quality (1 = white/common, 2 = green/uncommon).
local FAVOR = {
  Apprentice = { [1] = 5, [2] = 10 },
  Journeyman = { [1] = 10, [2] = 20 },
  Expert = { [1] = 15, [2] = 30 },
}

local EMPTY_CRATE_FAVOR = {
  [248682] = 5, [248683] = 5, [248684] = 5, [248685] = 5,
  [248686] = 10, [248687] = 10, [248688] = 10, [248689] = 10,
  [248690] = 15, [248691] = 15, [248692] = 15, [248693] = 15, [248694] = 15,
  [248702] = 10, [248703] = 10, [248704] = 10,
  [248705] = 20, [248706] = 20, [248707] = 20,
  [248708] = 30, [248709] = 30, [248710] = 30,
}

local SEALED_TIER = {
  [248765] = "Apprentice", [248766] = "Journeyman", [248767] = "Expert",
  [248768] = "Artisan", [248769] = "Elite",
  [248770] = "Apprentice", [248771] = "Journeyman", [248772] = "Expert",
  [248773] = "Artisan", [248774] = "Elite",
  [248775] = "Apprentice", [248776] = "Journeyman", [248777] = "Expert",
  [248778] = "Artisan", [248779] = "Elite",
}

local annotated = {}

local function ItemIDFromLink(link)
  if not link then
    return nil
  end
  local id = link:match("item:(%d+)")
  return id and tonumber(id) or nil
end

local function TierFromName(name)
  if not name then
    return nil
  end
  if name:find("Apprentice", 1, true) then
    return "Apprentice"
  end
  if name:find("Journeyman", 1, true) then
    return "Journeyman"
  end
  if name:find("Expert", 1, true) then
    return "Expert"
  end
  if name:find("Artisan", 1, true) then
    return "Artisan"
  end
  if name:find("Elite", 1, true) then
    return "Elite"
  end
  return nil
end

local function IsWaylaidOrSealedName(name)
  if not name then
    return false
  end
  if name:find("Waylaid Crate", 1, true) then
    return true
  end
  if name:find("Sealed ", 1, true) and name:find("Crate", 1, true) then
    return true
  end
  return false
end

local function ResolveFavor(itemID, name, quality)
  if itemID and EMPTY_CRATE_FAVOR[itemID] then
    return EMPTY_CRATE_FAVOR[itemID], "known"
  end

  local tier = (itemID and SEALED_TIER[itemID]) or TierFromName(name)
  if not tier then
    return nil, nil
  end

  local byQuality = FAVOR[tier]
  if byQuality and quality and byQuality[quality] then
    return byQuality[quality], "known"
  end

  if tier == "Artisan" or tier == "Elite" then
    return nil, "unknown"
  end

  if quality and quality >= 3 then
    return nil, "unknown"
  end

  return nil, nil
end

local function FormatMoney(copper)
  if not copper then
    return nil
  end
  copper = math.floor(copper + 0.5)
  if GetCoinTextureString then
    return GetCoinTextureString(copper)
  end
  local gold = math.floor(copper / 10000)
  local silver = math.floor((copper % 10000) / 100)
  local c = copper % 100
  if gold > 0 then
    return string.format("%dg %ds %dc", gold, silver, c)
  end
  if silver > 0 then
    return string.format("%ds %dc", silver, c)
  end
  return string.format("%dc", c)
end

local function AuctionatorAPI()
  local a = _G.Auctionator
  return a and a.API and a.API.v1 or nil
end

local function GetUnitPrice(itemID)
  local api = AuctionatorAPI()
  if not api or type(api.GetAuctionPriceByItemID) ~= "function" then
    return nil, "no_auctionator"
  end
  local ok, price = pcall(api.GetAuctionPriceByItemID, CALLER_ID, itemID)
  if ok and type(price) == "number" and price > 0 then
    return price, nil
  end
  return nil, "no_price"
end

local function ItemLabel(itemID, qty)
  local name = GetItemInfo(itemID)
  if name then
    return string.format("%dx %s", qty, name)
  end
  return string.format("%dx item:%d", qty, itemID)
end

-- Returns cheapest fill among bundles with AH prices.
local function CheapestFill(itemID)
  local recipes = WaylaidFavorTooltip.FillRecipes and WaylaidFavorTooltip.FillRecipes[itemID]
  if not recipes then
    return nil
  end

  local api = AuctionatorAPI()
  if not api then
    return { status = "no_auctionator" }
  end

  local bestCost, bestBundle
  local priced, total = 0, #recipes

  for i = 1, total do
    local bundle = recipes[i]
    local unit = GetUnitPrice(bundle.itemID)
    if unit then
      priced = priced + 1
      local cost = unit * bundle.qty
      if not bestCost or cost < bestCost then
        bestCost = cost
        bestBundle = bundle
      end
    end
  end

  if not bestBundle then
    return { status = "no_price", total = total }
  end

  return {
    status = (priced < total) and "partial" or "ok",
    cost = bestCost,
    bundle = bestBundle,
    priced = priced,
    total = total,
  }
end

local function AnnotateTooltip(tooltip, itemID, name, quality)
  if not tooltip or annotated[tooltip] then
    return
  end
  if not IsWaylaidOrSealedName(name) and not (itemID and (EMPTY_CRATE_FAVOR[itemID] or SEALED_TIER[itemID] or (WaylaidFavorTooltip.FillRecipes and WaylaidFavorTooltip.FillRecipes[itemID]))) then
    return
  end

  local favor, status = ResolveFavor(itemID, name, quality)
  local fill = itemID and CheapestFill(itemID) or nil

  if status ~= "known" and status ~= "unknown" and not fill then
    return
  end

  annotated[tooltip] = true
  tooltip:AddLine(" ")

  if status == "known" and favor then
    tooltip:AddDoubleLine("Merchant's Favor", tostring(favor), 0.40, 0.80, 1.00, 1.00, 0.82, 0.00)
    tooltip:AddDoubleLine("Hand-in coin", FormatMoney(favor * 50), 0.55, 0.55, 0.55, 1.00, 1.00, 1.00)
  elseif status == "unknown" then
    tooltip:AddDoubleLine("Merchant's Favor", "unknown", 0.40, 0.80, 1.00, 0.60, 0.60, 0.60)
  end

  if fill then
    if fill.status == "no_auctionator" then
      tooltip:AddDoubleLine("Cheapest fill", "Auctionator missing", 0.55, 0.55, 0.55, 0.60, 0.60, 0.60)
    elseif fill.status == "no_price" then
      tooltip:AddDoubleLine("Cheapest fill", "no AH price", 0.55, 0.55, 0.55, 0.60, 0.60, 0.60)
    else
      local label = "Cheapest fill"
      if fill.status == "partial" then
        label = string.format("Cheapest fill (%d/%d priced)", fill.priced, fill.total)
      end
      local right = FormatMoney(fill.cost)
      local via = ItemLabel(fill.bundle.itemID, fill.bundle.qty)
      tooltip:AddDoubleLine(label, right, 0.55, 0.55, 0.55, 1.00, 1.00, 1.00)
      tooltip:AddLine("  via " .. via, 0.45, 0.45, 0.45)
      if favor and favor > 0 and fill.cost then
        tooltip:AddDoubleLine("Cost per Favor", FormatMoney(fill.cost / favor), 0.55, 0.55, 0.55, 0.90, 0.90, 0.50)
      end
    end
  end
end

local function OnTooltipItem(tooltip, data)
  if not tooltip then
    return
  end

  local itemID, name, quality, link

  if data and data.id then
    itemID = data.id
  end

  if tooltip.GetItem then
    local itemName, itemLink = tooltip:GetItem()
    name = itemName
    link = itemLink
    if not itemID then
      itemID = ItemIDFromLink(itemLink)
    end
  end

  if itemID and (not name or not quality) then
    local itemName, _, itemQuality = GetItemInfo(itemID)
    name = name or itemName
    quality = quality or itemQuality
  end

  if link and not quality then
    local _, _, itemQuality = GetItemInfo(link)
    quality = itemQuality
  end

  AnnotateTooltip(tooltip, itemID, name, quality)
end

local function OnTooltipCleared(tooltip)
  annotated[tooltip] = nil
end

local function HookTooltip(tooltip)
  if not tooltip then
    return
  end
  tooltip:HookScript("OnTooltipCleared", OnTooltipCleared)
  if tooltip.HasScript and tooltip:HasScript("OnTooltipSetItem") then
    tooltip:HookScript("OnTooltipSetItem", function(self)
      OnTooltipItem(self, nil)
    end)
  end
end

local function Register()
  if TooltipDataProcessor and Enum and Enum.TooltipDataType and Enum.TooltipDataType.Item then
    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnTooltipItem)
  end

  HookTooltip(GameTooltip)
  HookTooltip(ItemRefTooltip)
  if ShoppingTooltip1 then
    HookTooltip(ShoppingTooltip1)
  end
  if ShoppingTooltip2 then
    HookTooltip(ShoppingTooltip2)
  end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(_, event, name)
  if event == "ADDON_LOADED" and name == ADDON_NAME then
    Register()
    frame:UnregisterEvent("ADDON_LOADED")
  end
end)
