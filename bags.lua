---------------------------------------------------------------------------------------------
-- AddOn Name: AsphyxiaUI 7.x
-- Author: Sinaris @ Das Syndikat, Vaecia @ Blackmoore
-- Description: AsphyxiaUI
-- Credits:
---------------------------------------------------------------------------------------------

local S, C, L, G = unpack( select( 2, ... ) )

if( C["bags"]["enable"] ~= true ) then return end

local bags_BACKPACK = { 0, 1, 2, 3, 4 }
local bags_BANK = { -1, 5, 6, 7, 8, 9, 10, 11 }
local ST_NORMAL = 1
local ST_FISHBAG = 2
local ST_SPECIAL = 3
local bag_bars = 0

InterfaceOptionsDisplayPanelShowFreeBagSpace:Hide()

Stuffing = CreateFrame ( "Frame", nil, UIParent )
Stuffing:RegisterEvent( "ADDON_LOADED" )
Stuffing:RegisterEvent( "PLAYER_ENTERING_WORLD" )
Stuffing:SetScript( "OnEvent", function( this, event, ... )
	Stuffing[event]( this, ... )
end )

local Loc = setmetatable( {}, {
	__index = function ( t, v )
		t[v] = v
		return v
	end
} )

local function Print( x )
	DEFAULT_CHAT_FRAME:AddMessage( "|cffC495DDAsphyxiaUI:|r " .. x )
end

local function Stuffing_Sort( args )
	if( not args ) then
		args = ""
	end

	Stuffing.itmax = 0
	Stuffing:SetBagsForSorting( args )
	Stuffing:SortBags()
end

local function ForceUpdate()
	Stuffing:PLAYERBANKSLOTS_CHANGED( 29 )

	for i = 0, #bags_BACKPACK - 1 do
		Stuffing:BAG_UPDATE(i)
	end
end

local function Stuffing_OnShow()
	ForceUpdate()
	Stuffing:Layout()
	Stuffing:SearchReset()
end

local function StuffingBank_OnHide()
	CloseBankFrame()

	if( Stuffing.frame:IsShown() ) then
		Stuffing.frame:Hide()
	end
end

local function Stuffing_OnHide()
	if( Stuffing.bankFrame and Stuffing.bankFrame:IsShown() ) then
		Stuffing.bankFrame:Hide()
	end
end

local function Stuffing_Open()
	Stuffing.frame:Show()
end

local function Stuffing_Close()
	Stuffing.frame:Hide()
end

local function Stuffing_Toggle()
	if( Stuffing.frame:IsShown() ) then
		Stuffing.frame:Hide()
	else
		Stuffing.frame:Show()
	end
end

local function Stuffing_ToggleBag( id )
	Stuffing_Toggle()
end

local trashParent = CreateFrame( "Frame", nil, UIParent )
local trashButton = {}
local trashBag = {}
local StuffingTT = nil
local QUEST_ITEM_STRING = nil

function Stuffing:SlotUpdate( b )
	if( b.Cooldown and ( AspUIBags and AspUIBags:IsShown() ) or ( AspUIBank and AspUIBank:IsShown() ) ) then
		local cd_start, cd_finish, cd_enable = GetContainerItemCooldown( b.bag, b.slot )

		CooldownFrame_SetTimer( b.Cooldown, cd_start, cd_finish, cd_enable )
	end

	local texture, count, locked = GetContainerItemInfo( b.bag, b.slot )
	local clink = GetContainerItemLink( b.bag, b.slot )
	local name, _, rarity, iType

	if( clink ) then
		name, _, rarity, _, _, iType = GetItemInfo( clink )
	end

	if( texture == b.texture and b.count == count and b.rarity == rarity and b.lock == locked ) then return end

	b.texture = texture
	b.count = count
	b.name = name
	b.rarity = rarity
	b.lock = locked

	if( not b.frame.lock ) then
		--b.frame:SetBackdropBorderColor( unpack( C["media"]["bordercolor"] ) )
	end

	b.frame.questIcon:Hide()

	if( clink ) then
		if( clink ) then
			if( not b.frame.lock and b.rarity and b.rarity > 1 and not ( isQuestItem or questId ) ) then
				b.frame:SetBackdropBorderColor( GetItemQualityColor( b.rarity ) )
			end
		else
			b.name, b.rarity = nil, nil
		end

		if( not StuffingTT ) then
			StuffingTT = CreateFrame( "GameTooltip", "StuffingTT", nil, "GameTooltipTemplate" )
			StuffingTT:Hide()
		end

		if( QUEST_ITEM_STRING == nil ) then
			local t = {
				GetAuctionItemClasses()
			}

			QUEST_ITEM_STRING = t[#t]
		end

		StuffingTT:SetOwner( WorldFrame, "ANCHOR_NONE" )
		StuffingTT:ClearLines()
		StuffingTT:SetBagItem( b.bag, b.slot )
		for i = 1, StuffingTT:NumLines() do
			local txt = getglobal( "StuffingTTTextLeft" .. i )

			if( txt ) then
				local text = txt:GetText()

				if( string.find ( txt:GetText(), ITEM_BIND_QUEST ) ) then
					iType = QUEST_ITEM_STRING
				end
			end
		end

		if( iType and iType == QUEST_ITEM_STRING ) then
			b.qitem = true
			b.frame.questIcon:Show()
		else
			b.qitem = nil
		end
	else
		b.name, b.rarity, b.qitem = nil, nil, nil
	end

	SetItemButtonTexture( b.frame, texture )
	SetItemButtonCount( b.frame, count )
	SetItemButtonDesaturated( b.frame, locked, 0.5, 0.5, 0.5 )

	local scount = _G[b.frame:GetName() .. "Count"]
	scount:SetFont( unpack( S.FontTemplate.BagsItemCount.BuildFont ) )
	scount:Point( "BOTTOMRIGHT", 0, 2 )
	b.scount = scount

	b.frame:Show()
end

function Stuffing:BagSlotUpdate( bag )
	if( not self.buttons ) then
		return
	end

	for _, v in ipairs( self.buttons ) do
		if( v.bag == bag ) then
			self:SlotUpdate( v )
		end
	end
end

function Stuffing:BagFrameSlotNew( slot, p )
	for _, v in ipairs( self.bagframe_buttons ) do
		if( v.slot == slot ) then
			return v, false
		end
	end

	local ret = {}
	local tpl

	if( slot > 3 ) then
		ret.slot = slot
		slot = slot - 4
		tpl = "BankItemButtonBagTemplate"
		ret.frame = CreateFrame( "CheckButton", "AspUIBankBag" .. slot, p, tpl )
		ret.frame:StyleButton()
		ret.frame:SetTemplate( "Transparent" )

		local icon = _G["AspUIBankBag" .. slot .. "IconTexture"]
		local border = _G["AspUIBankBag" .. slot .. "NormalTexture"]

		icon:SetTexCoord( 0.08, 0.92, 0.08, 0.92 )
		icon:ClearAllPoints()
		icon:Point( "TOPLEFT", 2, -2 )
		icon:Point( "BOTTOMRIGHT", -2, 2 )
		border:SetTexture( "" )
		ret.frame:SetID( slot + 4 )

		table.insert( self.bagframe_buttons, ret )

		BankFrameItemButton_Update( ret.frame )
		BankFrameItemButton_UpdateLocked( ret.frame )

		if( not ret.frame.tooltipText ) then
			ret.frame.tooltipText = ""
		end
	else
		tpl = "BagSlotButtonTemplate"
		ret.frame = CreateFrame( "CheckButton", "AspUIBackBag" .. slot .. "Slot", p, tpl )
		ret.frame:StyleButton()
		ret.frame:SetTemplate( "Transparent" )

		local icon = _G["AspUIBackBag" .. slot .. "SlotIconTexture"]
		local border = _G["AspUIBackBag" .. slot .. "SlotNormalTexture"]

		icon:SetTexCoord( 0.08, 0.92, 0.08, 0.92 )
		icon:ClearAllPoints()
		icon:Point( "TOPLEFT", 2, -2 )
		icon:Point( "BOTTOMRIGHT", -2, 2 )
		border:SetTexture("")
		ret.slot = slot

		table.insert( self.bagframe_buttons, ret )
	end

	return ret
end

function Stuffing:SlotNew( bag, slot )
	for _, v in ipairs( self.buttons ) do
		if( v.bag == bag and v.slot == slot ) then
			return v, false
		end
	end

	local tpl = "ContainerFrameItemButtonTemplate"

	if( bag == -1 ) then
		tpl = "BankItemButtonGenericTemplate"
	end

	local ret = {}

	if( #trashButton > 0 ) then
		local f = -1

		for i, v in ipairs( trashButton ) do
			local b, s = v:GetName():match( "(%d+)_(%d+)" )

			b = tonumber( b )
			s = tonumber( s )

			if( b == bag and s == slot ) then
				f = i
				break
			end
		end

		if( f ~= -1 ) then
			ret.frame = trashButton[f]
			table.remove( trashButton, f )
		end
	end

	if( not ret.frame ) then
		ret.frame = CreateFrame( "Button", "AspUIBag_" .. bag .. "_" .. slot, self.bags[bag], tpl )
		ret.frame:SetTemplate( "Transparent" )
		ret.frame:Height( 31 )
		ret.frame:Width( 31 )
		ret.frame:SetPushedTexture( "" )
		ret.frame:SetNormalTexture( "" )
		ret.frame:StyleButton()

		_G[ret.frame:GetName() .. "IconQuestTexture"]:SetTexture( "Interface\\GossipFrame\\AvailableQuestIcon" )
		_G[ret.frame:GetName() .. "IconQuestTexture"]:SetInside( ret.frame )
		_G[ret.frame:GetName() .. "IconQuestTexture"]:SetTexCoord( -0.1, 1.2, 0, 1 )
		_G[ret.frame:GetName() .. "IconQuestTexture"]:Hide()
		ret.frame.questIcon = _G[ret.frame:GetName() .. "IconQuestTexture"]
	end

	ret.bag = bag
	ret.slot = slot
	ret.frame:SetID( slot )

	ret.Cooldown = _G[ret.frame:GetName() .. "Cooldown"]
	ret.Cooldown:Show()

	self:SlotUpdate( ret )

	return ret, true
end

local BAGTYPE_PROFESSION = 0x0008 + 0x0010 + 0x0020 + 0x0040 + 0x0080 + 0x0200 + 0x0400
local BAGTYPE_FISHING = 32768

function Stuffing:BagType( bag )
	local bagType = select( 2, GetContainerNumFreeSlots( bag ) )

	if( bit.band( bagType, BAGTYPE_FISHING ) > 0 ) then
		return ST_FISHBAG
	elseif( bit.band( bagType, BAGTYPE_PROFESSION ) > 0 ) then
		return ST_SPECIAL
	end

	return ST_NORMAL
end

function Stuffing:BagNew( bag, f )
	for i, v in pairs( self.bags ) do
		if( v:GetID() == bag ) then
			v.bagType = self:BagType( bag )
			return v
		end
	end

	local ret

	if( #trashBag > 0 ) then
		local f = -1
		for i, v in pairs( trashBag ) do
			if( v:GetID() == bag ) then
				f = i
				break
			end
		end

		if( f ~= -1 ) then
			ret = trashBag[f]
			table.remove( trashBag, f )
			ret:Show()
			ret.bagType = self:BagType( bag )
			return ret
		end
	end

	ret = CreateFrame( "Frame", "StuffingBag" .. bag, f )
	ret.bagType = self:BagType( bag )

	ret:SetID(bag)
	return ret
end

function Stuffing:SearchUpdate( str )
	str = string.lower( str )

	for _, b in ipairs( self.buttons ) do
		if( b.frame and not b.name ) then
			b.frame:SetAlpha( 0.2 )
		end

		if( b.name ) then
			if( not string.find( string.lower( b.name ), str, 1, true ) ) then
				SetItemButtonDesaturated( b.frame, 1, 1, 1, 1 )
				b.frame:SetAlpha( 0.2 )
			else
				SetItemButtonDesaturated( b.frame, 0, 1, 1, 1 )
				b.frame:SetAlpha( 1 )
			end
		end
	end
end

function Stuffing:SearchReset()
	for _, b in ipairs( self.buttons ) do
		b.frame:SetAlpha( 1 )
		SetItemButtonDesaturated( b.frame, 0, 1, 1, 1 )
	end
end

local Stuffing_DDMenu = CreateFrame( "Frame", "Stuffing_DropDownMenu" )
Stuffing_DDMenu.displayMode = "MENU"
Stuffing_DDMenu.info = {}
Stuffing_DDMenu.HideMenu = function()
	if( UIDROPDOWNMENU_OPEN_MENU == Stuffing_DDMenu ) then
		CloseDropDownMenus()
	end
end

function Stuffing:CreateBagFrame( w )
	local n = "AspUI"  .. w
	local f = CreateFrame ( "Frame", n, UIParent )

	f:EnableMouse( 1 )
	f:SetMovable( 1 )
	f:SetToplevel( 1 )
	f:SetFrameStrata( "HIGH" )
	f:SetFrameLevel( 20 )

	if( w == "Bank" ) then
		if( C["chat"]["background"] ~= true ) then
			f:SetPoint( "BOTTOMLEFT", AsphyxiaUIDataPanelLeft, "TOPLEFT", 0, 3 )
		else
			f:SetPoint( "BOTTOMLEFT", AsphyxiaUIChatBackgroundLeft, "TOPLEFT", 0, 3 )
		end
	else
		if( C["actionbar"]["enable"] ~= true ) then
			if( C["chat"]["background"] ~= true ) then
				f:SetPoint( "BOTTOMLEFT", AsphyxiaUIDataPanelRight, "TOPLEFT", 0, 3 )
			else
				f:SetPoint( "BOTTOMRIGHT", AsphyxiaUIChatBackgroundRight, "TOPRIGHT", 0, 3 )
			end
		else
			if( C["chat"]["background"] ~= true ) then
				f:SetPoint( "BOTTOMLEFT", AsphyxiaUIDataPanelRight, "TOPLEFT", 0, 3 )
			elseif( HasPetUI() ) then
				if( C["actionbar"]["vertical_rightbars"] == true ) then
					f:SetPoint( "BOTTOMRIGHT", AsphyxiaUIChatBackgroundRight, "TOPRIGHT", 0, 3 )
				else
					f:SetPoint( "BOTTOM", AsphyxiaUIPetActionBar, "TOP", 0, 3 )
				end
			elseif( UnitHasVehicleUI( "player" ) ) then
				f:SetPoint( "BOTTOMRIGHT", AsphyxiaUIChatBackgroundRight, "TOPRIGHT", 0, 3 )
			else
				if( C["actionbar"]["vertical_rightbars"] == true ) then
					f:SetPoint( "BOTTOMRIGHT", AsphyxiaUIChatBackgroundRight, "TOPRIGHT", 0, 3 )
				else
					if( AsphyxiaUI_Data["rightbars"] >= 1 ) then
						f:SetPoint( "BOTTOMRIGHT", AsphyxiaUIActionBarRightBar, "TOPRIGHT", 0, 3 )
					else
						f:SetPoint( "BOTTOMRIGHT", AsphyxiaUIChatBackgroundRight, "TOPRIGHT", 0, 3 )
					end
				end
			end
		end
	end

	f.b_close = CreateFrame( "Button", "Stuffing_CloseButton" .. w, f, "UIPanelCloseButton" )
	f.b_close:Size( 50, 20 )
	f.b_close:Point( "TOPRIGHT", -3, -3 )
	f.b_close:SetScript( "OnClick", function( self, btn )
		if( self:GetParent():GetName() == "AspUIBags" and btn == "RightButton" ) then
			if( Stuffing_DDMenu.initialize ~= Stuffing.Menu ) then
				CloseDropDownMenus()
				Stuffing_DDMenu.initialize = Stuffing.Menu
			end

			ToggleDropDownMenu( nil, nil, Stuffing_DDMenu, self:GetName(), 0, 0 )
			return
		end
		self:GetParent():Hide()
	end )

	f.b_close:RegisterForClicks( "AnyUp" )
	f.b_close:SetTemplate( "Transparent" )
	f.b_close:SetFrameStrata("HIGH")

	f.b_text = f.b_close:CreateFontString( nil, "OVERLAY" )
	f.b_text:SetFont( unpack( S.FontTemplate.BagsCloseBtn.BuildFont ) )
	f.b_text:SetPoint( "CENTER", f.b_close, "CENTER", 0, 1 )
	f.b_text:SetText( S.datacolor .. CLOSE )

	f.b_close:CreateOverlay( f.b_close )
	f.b_close:SetWidth( f.b_text:GetWidth() + 10 )

	f.b_close:SetNormalTexture( "" )
	f.b_close:SetPushedTexture( "" )
	f.b_close:SetHighlightTexture( "" )
	--f.b_close:SkinCloseButton()

	f.b_close:HookScript( "OnEnter", S.ModifiedBackdrop )
	f.b_close:HookScript( "OnLeave", S.OriginalBackdrop )

	local fb = CreateFrame( "Frame", n .. "BagsFrame", f )
	fb:Point( "BOTTOMLEFT", f, "TOPLEFT", 0, 2 )
	fb:SetFrameStrata( "HIGH" )
	fb:SetTemplate( "Transparent" )
	fb:CreateShadow( "Default" )

	f.bags_frame = fb

	if( w == "Bank" ) then
		local cnt, full = GetNumBankSlots()
	
		purchaseBagButton = CreateFrame( "Button", nil, f )
		purchaseBagButton:Size( 150, 20 )
		purchaseBagButton:Point( "TOP", f, "TOP", 0, -4 )
		purchaseBagButton:CreateOverlay( purchaseBagButton )
		purchaseBagButton:SetTemplate( "Transparent" )
	
		purchaseBagButton.Text = S.SetFontString( purchaseBagButton, unpack( S.FontTemplate.BagsDetail.BuildFont ) )
		purchaseBagButton.Text:Point( "CENTER", purchaseBagButton, "CENTER", 0, 1 )
	
		if( full ) then
			purchaseBagButton.Text:SetText( S.datacolor .. "No Slots available" )
		else
			purchaseBagButton.Text:SetText( S.datacolor .. "Buy Bankslot (" .. GetBankSlotCost() / 10000 .. " Gold)" )
		end
	
		purchaseBagButton:SetScript( "OnEnter", S.SetModifiedBackdrop )
		purchaseBagButton:SetScript( "OnLeave", S.SetOriginalBackdrop )
		purchaseBagButton:SetScript( "OnClick", function()
			local cnt, full = GetNumBankSlots()
	
			if( full ) then
				print( "No Slots" )
				return
			end
	
			PurchaseSlot()
			print( string.format( L.bags_costs, GetBankSlotCost() / 10000 ) )
		end )
	end

	return f
end

function Stuffing:InitBank()
	if( self.bankFrame ) then
		return
	end

	local f = self:CreateBagFrame( "Bank" )
	f:SetScript( "OnHide", StuffingBank_OnHide )
	self.bankFrame = f
end

local parent_startmoving = function( self )
	StartMoving( self:GetParent() )
end

local parent_stopmovingorsizing = function( self )
	StopMoving( self:GetParent() )
end

function Stuffing:InitBags()
	if( self.frame ) then
		return
	end

	self.buttons = {}
	self.bags = {}
	self.bagframe_buttons = {}

	local f = self:CreateBagFrame( "Bags" )
	f:SetScript( "OnShow", Stuffing_OnShow )
	f:SetScript( "OnHide", Stuffing_OnHide )

	local editbox = CreateFrame( "EditBox", nil, f )
	editbox:Hide()
	editbox:SetAutoFocus( true )
	editbox:Height( 32 )
	editbox:SetTemplate( "Transparent" )

	local resetAndClear = function( self )
		self:GetParent().detail:Show()
		self:GetParent().gold:Show()
		self:ClearFocus()
		Stuffing:SearchReset()
	end

	local updateSearch = function( self, t )
		if( t == true ) then
			Stuffing:SearchUpdate( self:GetText() )
		end
	end

	editbox:SetScript( "OnEscapePressed", resetAndClear )
	editbox:SetScript( "OnEnterPressed", resetAndClear )
	editbox:SetScript( "OnEditFocusLost", editbox.Hide )
	editbox:SetScript( "OnEditFocusGained", editbox.HighlightText )
	editbox:SetScript( "OnTextChanged", updateSearch )
	editbox:SetText( L.bags_search )

	local detail = f:CreateFontString( nil, "ARTWORK", "GameFontHighlightLarge" )
	detail:Point( "TOPLEFT", f, 12, -10 )
	detail:Point( "RIGHT", -( 16 + 24 ), 0 )
	detail:SetJustifyH( "LEFT" )
	detail:SetText( "|cff9999ff" .. "Search" )
	editbox:SetAllPoints( detail )

	local gold = f:CreateFontString( nil, "ARTWORK", "GameFontHighlightLarge" )
	gold:SetJustifyH( "RIGHT" )
	gold:Point( "RIGHT", f.b_close, "LEFT", -3, 0 )

	f:SetScript( "OnEvent", function( self, e )
		self.gold:SetText( GetMoneyString( GetMoney(), 12 ) )
	end )

	f:RegisterEvent( "PLAYER_MONEY" )
	f:RegisterEvent( "PLAYER_LOGIN" )
	f:RegisterEvent( "PLAYER_TRADE_MONEY" )
	f:RegisterEvent( "TRADE_MONEY_CHANGED" )

	local OpenEditbox = function( self )
		self:GetParent().detail:Hide()
		self:GetParent().gold:Hide()
		self:GetParent().editbox:Show()
		self:GetParent().editbox:HighlightText()
	end

	local button = CreateFrame( "Button", nil, f )
	button:EnableMouse( 1 )
	button:RegisterForClicks( "LeftButtonUp", "RightButtonUp" )
	button:SetAllPoints( detail )
	button:SetScript( "OnClick", function( self, btn )
		if( btn == "RightButton" ) then
			OpenEditbox(self)
		else
			if( self:GetParent().editbox:IsShown() ) then
				self:GetParent().editbox:Hide()
				self:GetParent().editbox:ClearFocus()
				self:GetParent().detail:Show()
				self:GetParent().gold:Show()
				Stuffing:SearchReset()
			end
		end
	end )

	local tooltip_hide = function()
		GameTooltip:Hide()
	end

	local tooltip_show = function( self )
		GameTooltip:SetOwner( self, "ANCHOR_CURSOR" )
		GameTooltip:ClearLines()
		GameTooltip:SetText( L.bags_rightclick_search )
	end

	button:SetScript( "OnEnter", tooltip_show )
	button:SetScript( "OnLeave", tooltip_hide )

	f.editbox = editbox
	f.detail = detail
	f.button = button
	f.gold = gold
	self.frame = f
	f:Hide()
end


function Stuffing:Layout( lb )
	local slots = 0
	local rows = 0
	local off = 26
	local cols
	local f
	local bs

	local bgvalue = 0
	if( C["chat"]["background"] ~= true ) then
		bgvalue = 10
	end

	if( lb ) then
		bs = bags_BANK
		cols = ( floor( ( S.InfoLeftRightWidth - bgvalue ) / 370 * 10 ) + 1 )

		f = self.bankFrame
	else
		bs = bags_BACKPACK
		cols = ( floor( ( S.InfoLeftRightWidth - bgvalue ) /370 * 10 ) + 1 )

		f = self.frame

		f.gold:SetText(GetMoneyString(GetMoney(), 12))
		f.editbox:SetFont( unpack( S.FontTemplate.BagsEditBox.BuildFont ) )
		f.detail:SetFont( unpack( S.FontTemplate.BagsDetail.BuildFont ) )
		f.gold:SetFont( unpack( S.FontTemplate.BagsGold.BuildFont ) )

		f.detail:ClearAllPoints()
		f.detail:Point( "TOPLEFT", f, 12, -10 )
		f.detail:Point("RIGHT", -( 16 + 24 ), 0 )
	end

	f:SetClampedToScreen( 1 )
	f:SetTemplate( "Transparent" )
	f:CreateShadow( "Default" )

	local fb = f.bags_frame

	if( bag_bars == 1 ) then
		fb:SetClampedToScreen( 1 )

		local bsize = 24
		if( lb ) then
			bsize = 23.3
		end

		local w = 2 * 12

		w = w + ( ( #bs - 1 ) * bsize )
		w = w + ( 12 * ( #bs - 2 ) )

		fb:Height( 2 * 12 + bsize )
		fb:Width( w )
		fb:Show()
	else
		fb:Hide()
	end

	local idx = 0
	for _, v in ipairs( bs ) do
		if( ( not lb and v <= 3 ) or ( lb and v ~= -1 ) ) then
			local bsize = 30

			if( lb ) then
				bsize = 30
			end

			local b = self:BagFrameSlotNew( v, fb )
			local xoff = 12

			xoff = xoff + ( idx * bsize )
			xoff = xoff + ( idx * 4 )

			b.frame:ClearAllPoints()
			b.frame:Point( "LEFT", fb, "LEFT", xoff, 0 )
			b.frame:Show()

			local iconTex = _G[b.frame:GetName() .. "IconTexture"]
			iconTex:SetTexCoord( 0.09, 0.91, 0.09, 0.91 )
			iconTex:Point( "TOPLEFT", b.frame, 2, -2 )
			iconTex:Point( "BOTTOMRIGHT", b.frame, -2, 2 )

			iconTex:Show()
			b.iconTex = iconTex

			b.frame:SetTemplate( "Transparent" )
			b.frame:CreateShadow( "Default" )
			b.frame:SetBackdropColor( 0, 0, 0 )
			b.frame:StyleButton()

			idx = idx + 1
		end
	end

	for _, i in ipairs( bs ) do
		local x = GetContainerNumSlots( i )

		if( x > 0 ) then
			if( not self.bags[i] ) then
				self.bags[i] = self:BagNew( i, f )
			end

			slots = slots + GetContainerNumSlots( i )
		end
	end

	rows = floor( slots / cols )
	if( ( slots % cols ) ~= 0 ) then
		rows = rows + 1
	end

	f:Width( C["chat"]["width"] - bgvalue )
	f:Height( rows * 30 + ( rows - 1 ) * 2 + off + 12 * 2 )

	local sf = CreateFrame( "Frame", "SlotFrame", f )
	sf:Width( ( 31 + 1 ) * cols )
	sf:Height( f:GetHeight() - ( 6 ) )
	sf:Point( "BOTTOM", f, "BOTTOM" )

	local idx = 0
	for _, i in ipairs( bs ) do
		local bag_cnt = GetContainerNumSlots( i )

		if( bag_cnt > 0 ) then
			self.bags[i] = self:BagNew( i, f )
			local bagType = self.bags[i].bagType

			self.bags[i]:Show()
			for j = 1, bag_cnt do
				local b, isnew = self:SlotNew( i, j )
				local xoff
				local yoff
				local x = ( idx % cols )
				local y = floor( idx / cols )

				if( isnew ) then
					table.insert( self.buttons, idx + 1, b )
				end

				xoff = ( x * 31 ) + ( x * 1 )
				yoff = off + 12 + ( y * 30 ) + ( ( y - 1 ) * 2 )
				yoff = yoff * -1

				b.frame:ClearAllPoints()
				b.frame:Point( "TOPLEFT", sf, "TOPLEFT", xoff, yoff )
				b.frame:Height( 29 )
				b.frame:Width( 29 )
				b.frame:SetPushedTexture( "" )
				b.frame:SetNormalTexture( "" )
				b.frame:Show()
				b.frame:SetTemplate( "Transparent" )
				b.frame:SetBackdropColor( 0, 0, 0 )
				b.frame:StyleButton()

				if( bagType == ST_FISHBAG ) then
					b.frame:SetBackdropBorderColor( 1, 0, 0 )
					b.frame.lock = true
				end

				if( bagType == ST_SPECIAL ) then
					b.frame:SetBackdropBorderColor( 255 / 255, 243 / 255, 82 / 255 )
					b.frame.lock = true
				end

				self:SlotUpdate( b )

				local iconTex = _G[b.frame:GetName() .. "IconTexture"]
				iconTex:SetTexCoord( 0.09, 0.91, 0.09, 0.91 )
				iconTex:Point( "TOPLEFT", b.frame, 2, -2 )
				iconTex:Point( "BOTTOMRIGHT", b.frame, -2, 2 )

				iconTex:Show()
				b.iconTex = iconTex

				idx = idx + 1
			end
		end
	end
end

function Stuffing:SetBagsForSorting( c )
	Stuffing_Open()

	self.sortBags = {}

	local cmd = ( ( c == nil or c == "" ) and { "d" } or { strsplit( "/", c ) } )

	for _, s in ipairs( cmd ) do
		if( s == "c" ) then
			self.sortBags = {}
		elseif( s == "d" ) then
			if( not self.bankFrame or not self.bankFrame:IsShown() ) then
				for _, i in ipairs( bags_BACKPACK ) do
					if( self.bags[i] and self.bags[i].bagType == ST_NORMAL ) then
						table.insert( self.sortBags, i )
					end
				end
			else
				for _, i in ipairs( bags_BANK ) do
					if( self.bags[i] and self.bags[i].bagType == ST_NORMAL ) then
						table.insert( self.sortBags, i )
					end
				end
			end
		elseif( s == "p" ) then
			if( not self.bankFrame or not self.bankFrame:IsShown() ) then
				for _, i in ipairs( bags_BACKPACK ) do
					if( self.bags[i] and self.bags[i].bagType == ST_SPECIAL ) then
						table.insert( self.sortBags, i )
					end
				end
			else
				for _, i in ipairs( bags_BANK ) do
					if( self.bags[i] and self.bags[i].bagType == ST_SPECIAL ) then
						table.insert( self.sortBags, i )
					end
				end
			end
		else
			if( tonumber( s ) == nil ) then
				Print( string.format( Loc["Error: don't know what \"%s\" means."], s ) )
			end

			table.insert( self.sortBags, tonumber( s ) )
		end
	end

	local bids = L.bags_bids
	for _, i in ipairs( self.sortBags ) do
		bids = bids .. i .. " "
	end

	Print( bids )
end

local function StuffingSlashCmd( Cmd )
	local cmd, args = strsplit( " ", Cmd:lower(), 2 )

	if( cmd == "config" ) then
		Stuffing_OpenConfig()
	elseif( cmd == "sort" ) then
		Stuffing_Sort( args )
	elseif( cmd == "psort" ) then
		Stuffing_Sort( "c/p" )
	elseif( cmd == "stack" ) then
		Stuffing:SetBagsForSorting( args )
		Stuffing:Restack()
	elseif( cmd == "test" ) then
		Stuffing:SetBagsForSorting( args )
	elseif( cmd == "purchase" ) then
		if( Stuffing.bankFrame and Stuffing.bankFrame:IsShown() ) then
			local cnt, full = GetNumBankSlots()

			if( full ) then
				Print( L.bags_noslots )
				return
			end

			if( args == "yes" ) then
				PurchaseSlot()
				return
			end

			Print( string.format( L.bags_costs, GetBankSlotCost() / 10000 ) )
			Print( L.bags_buyslots )
		else
			Print( L.bags_openbank )
		end
	else
		Print( "sort - " .. L.bags_sort )
		Print( "stack - " .. L.bags_stack )
		Print( "purchase - " .. L.bags_buybankslot )
	end
end

function Stuffing:ADDON_LOADED( addon )
	if( addon ~= "AsphyxiaUI" ) then
		return nil
	end

	self:RegisterEvent( "BAG_UPDATE" )
	self:RegisterEvent( "ITEM_LOCK_CHANGED" )
	self:RegisterEvent( "BANKFRAME_OPENED" )
	self:RegisterEvent( "BANKFRAME_CLOSED" )
	self:RegisterEvent( "PLAYERBANKSLOTS_CHANGED" )
	self:RegisterEvent( "BAG_CLOSED" )
	self:RegisterEvent( "BAG_UPDATE_COOLDOWN" )

	SlashCmdList["STUFFING"] = StuffingSlashCmd
	SLASH_STUFFING1 = "/bags"

	self:InitBags()

	tinsert( UISpecialFrames,"AspUIBags" )

	ToggleBackpack = Stuffing_Toggle
	ToggleBag = Stuffing_ToggleBag
	ToggleAllBags = Stuffing_Toggle
	OpenAllBags = Stuffing_Open
	OpenBackpack = Stuffing_Open
	CloseAllBags = Stuffing_Close
	CloseBackpack = Stuffing_Close

	BankFrame:UnregisterAllEvents()
end

function Stuffing:PLAYER_ENTERING_WORLD()
	Stuffing:UnregisterEvent( "PLAYER_ENTERING_WORLD" )

	ToggleBackpack()
	ToggleBackpack()
end

function Stuffing:BAG_UPDATE_COOLDOWN( self )
	ForceUpdate()
end

function Stuffing:PLAYERBANKSLOTS_CHANGED(id)
	if( id > 28 ) then
		for _, v in ipairs( self.bagframe_buttons ) do
			if( v.frame and v.frame.GetInventorySlot ) then

				BankFrameItemButton_Update( v.frame )
				BankFrameItemButton_UpdateLocked( v.frame )

				if( not v.frame.tooltipText ) then
					v.frame.tooltipText = ""
				end
			end
		end
	end

	if( self.bankFrame and self.bankFrame:IsShown() ) then
		self:BagSlotUpdate( -1 )
	end
end

function Stuffing:BAG_UPDATE( id )
	self:BagSlotUpdate( id )
end

function Stuffing:ITEM_LOCK_CHANGED( bag, slot )
	if( slot == nil ) then
		return
	end

	for _, v in ipairs( self.buttons ) do
		if( v.bag == bag and v.slot == slot ) then
			self:SlotUpdate( v )
			break
		end
	end
end

function Stuffing:BANKFRAME_OPENED()
	Stuffing_Open()

	if( not self.bankFrame ) then
		self:InitBank()
	end

	self:Layout( true )
	for _, x in ipairs( bags_BANK ) do
		self:BagSlotUpdate( x )
	end
	self.bankFrame:Show()
end

function Stuffing:BANKFRAME_CLOSED()
	if( not self.bankFrame ) then
		return
	end

	self.bankFrame:Hide()
end

function Stuffing:BAG_CLOSED( id )
	local b = self.bags[id]

	if( b ) then
		table.remove( self.bags, id )
		b:Hide()
		table.insert( trashBag, #trashBag + 1, b )
	end

	while true do
		local changed = false

		for i, v in ipairs( self.buttons ) do
			if( v.bag == id ) then
				v.frame:Hide()
				v.iconTex:Hide()

				table.insert( trashButton, #trashButton + 1, v.frame )
				table.remove( self.buttons, i )

				v = nil
				changed = true
			end
		end

		if( not changed ) then
			break
		end
	end
end

function Stuffing:SortOnUpdate( e )
	if( not self.elapsed ) then
		self.elapsed = 0
	end

	if( not self.itmax ) then
		self.itmax = 0
	end

	self.elapsed = self.elapsed + e

	if( self.elapsed < 0.1 ) then
		return
	end

	self.elapsed = 0
	self.itmax = self.itmax + 1

	local changed, blocked  = false, false

	if( self.sortList == nil or next( self.sortList, nil ) == nil ) then
		local locks = false

		for i, v in pairs( self.buttons ) do
			local _, _, l = GetContainerItemInfo( v.bag, v.slot )

			if( l ) then
				locks = true
			else
				v.block = false
			end
		end

		if( locks ) then
			return
		else
			self:SetScript( "OnUpdate", nil )
			self:SortBags()

			if( self.sortList == nil ) then
				return
			end
		end
	end

	for i, v in ipairs( self.sortList ) do
		repeat
			if( v.ignore ) then
				blocked = true
				break
			end

			if( v.srcSlot.block ) then
				changed = true
				break
			end

			if( v.dstSlot.block ) then
				changed = true
				break
			end

			local _, _, l1 = GetContainerItemInfo( v.dstSlot.bag, v.dstSlot.slot )
			local _, _, l2 = GetContainerItemInfo( v.srcSlot.bag, v.srcSlot.slot )

			if( l1 ) then
				v.dstSlot.block = true
			end

			if( l2 ) then
				v.srcSlot.block = true
			end

			if( l1 or l2 ) then
				break
			end

			if( v.sbag ~= v.dbag or v.sslot ~= v.dslot ) then
				if( v.srcSlot.name ~= v.dstSlot.name ) then
					v.srcSlot.block = true
					v.dstSlot.block = true
					PickupContainerItem( v.sbag, v.sslot )
					PickupContainerItem( v.dbag, v.dslot )
					changed = true
					break
				end
			end
		until true
	end

	self.sortList = nil

	if( ( not changed and not blocked ) or self.itmax > 250 ) then
		self:SetScript( "OnUpdate", nil )
		self.sortList = nil
		Print( L.bags_sortingbags )
	end
end

local function InBags( x )
	if( not Stuffing.bags[x] ) then
		return false
	end

	for _, v in ipairs( Stuffing.sortBags ) do
		if( x == v ) then
			return true
		end
	end
	return false
end

function Stuffing:SortBags()
	if( UnitAffectingCombat( "player" ) ) then return end

	local free
	local total = 0
	local bagtypeforfree

	if( StuffingFrameBank and StuffingFrameBank:IsShown() ) then
		for i = 5, 11 do
			free, bagtypeforfree = GetContainerNumFreeSlots( i )
			if( bagtypeforfree == 0 ) then
				total = free + total
			end
		end

		total = select( 1, GetContainerNumFreeSlots( -1 ) ) + total
	else
		for i = 0, 4 do
			free, bagtypeforfree = GetContainerNumFreeSlots( i )
			if( bagtypeforfree == 0 ) then
				total = free + total
			end
		end
	end

	if( total == 0 ) then
		print( "|cffff0000" .. ERROR_CAPS .. " - " .. ERR_INV_FULL .. "|r" )
		return
	end

	local bs = self.sortBags
	if( #bs < 1 ) then
		Print( L.bags_nothingsort )
		return
	end

	local st = {}
	local bank = false

	Stuffing_Open()

	for i, v in pairs( self.buttons ) do
		if( InBags( v.bag ) ) then
			self:SlotUpdate( v )

			if( v.name ) then
				local tex, cnt, _, _, _, _, clink = GetContainerItemInfo( v.bag, v.slot )
				local n, _, q, iL, rL, c1, c2, _, Sl = GetItemInfo( clink )
				table.insert( st, {
					srcSlot = v,
					sslot = v.slot,
					sbag = v.bag,
					sort = q .. c1 .. c2 .. rL .. n .. iL .. Sl .. ( #self.buttons - i ),
				} )
			end
		end
	end

	table.sort (st, function( a, b )
		return a.sort > b.sort
	end )

	local st_idx = #bs
	local dbag = bs[st_idx]
	local dslot = GetContainerNumSlots( dbag )

	for i, v in ipairs( st ) do
		v.dbag = dbag
		v.dslot = dslot
		v.dstSlot = self:SlotNew( dbag, dslot )
		dslot = dslot - 1

		if( dslot == 0 ) then
			while true do
				st_idx = st_idx - 1

				if( st_idx < 0 ) then
					break
				end

				dbag = bs[st_idx]

				if( Stuffing:BagType( dbag ) == ST_NORMAL or Stuffing:BagType( dbag ) == ST_SPECIAL or dbag < 1 ) then
					break
				end
			end
 
			dslot = GetContainerNumSlots( dbag )
		end
	end

	local changed = true
	while changed do
		changed = false

		for i, v in ipairs( st ) do
			if( ( v.sslot == v.dslot ) and ( v.sbag == v.dbag ) ) then
				table.remove( st, i )
				changed = true
			end
		end
	end

	if( st == nil or next( st, nil ) == nil ) then
		Print( L.bags_sortingbags )
		self:SetScript( "OnUpdate", nil )
	else
		self.sortList = st
		self:SetScript( "OnUpdate", Stuffing.SortOnUpdate )
	end
end

function Stuffing:RestackOnUpdate( e )
	if( not self.elapsed ) then
		self.elapsed = 0
	end

	self.elapsed = self.elapsed + e

	if( self.elapsed < 0.1 ) then
		return
	end

	self.elapsed = 0
	self:Restack()
end

function Stuffing:Restack()
	local st = {}

	Stuffing_Open()

	for i, v in pairs( self.buttons ) do
		if( InBags( v.bag ) ) then
			local tex, cnt, _, _, _, _, clink = GetContainerItemInfo( v.bag, v.slot )

			if( clink ) then
				local n, _, _, _, _, _, _, s = GetItemInfo( clink )

				if( cnt ~= s ) then
					if( not st[n] ) then
						st[n] = { {
							item = v,
							size = cnt,
							max = s
						} }
					else
						table.insert( st[n], {
							item = v,
							size = cnt,
							max = s
						} )
					end
				end
			end
		end
	end

	local did_restack = false

	for i, v in pairs( st ) do
		if( #v > 1 ) then
			for j = 2, #v, 2 do
				local a, b = v[j - 1], v[j]
				local _, _, l1 = GetContainerItemInfo( a.item.bag, a.item.slot )
				local _, _, l2 = GetContainerItemInfo( b.item.bag, b.item.slot )

				if( l1 or l2 ) then
					did_restack = true
				else
					PickupContainerItem( a.item.bag, a.item.slot )
					PickupContainerItem( b.item.bag, b.item.slot )
					did_restack = true
				end
			end
		end
	end

	if( did_restack ) then
		self:SetScript( "OnUpdate", Stuffing.RestackOnUpdate )
	else
		self:SetScript( "OnUpdate", nil )
		Print( L.bags_stackend )
	end
end

function Stuffing.Menu( self, level )
	if( not level ) then
		return
	end

	local info = self.info

	wipe( info )

	if( level ~= 1 ) then return end

	wipe( info )
	info.text = L.bags_sortmenu
	info.notCheckable = 1
	info.func = function()
		Stuffing_Sort( "d" )
	end
	UIDropDownMenu_AddButton( info, level )

	wipe( info )
	info.text = L.bags_sortspecial
	info.notCheckable = 1
	info.func = function()
		Stuffing_Sort( "c/p" )
	end
	UIDropDownMenu_AddButton( info, level )

	wipe( info )
	info.text = L.bags_stackmenu
	info.notCheckable = 1
	info.func = function()
		Stuffing:SetBagsForSorting( "d" )
		Stuffing:Restack()
	end
	UIDropDownMenu_AddButton( info, level )

	wipe( info )
	info.text = L.bags_stackspecial
	info.notCheckable = 1
	info.func = function()
		Stuffing:SetBagsForSorting( "c/p" )
		Stuffing:Restack()
	end
	UIDropDownMenu_AddButton( info, level )

	wipe( info )
	info.text = L.bags_showbags
	info.checked = function()
		return bag_bars == 1
	end

	info.func = function()
		if( bag_bars == 1 ) then
			bag_bars = 0
		else
			bag_bars = 1
		end

		Stuffing:Layout()
		if( Stuffing.bankFrame and Stuffing.bankFrame:IsShown() ) then
			Stuffing:Layout( true )
		end
	end
	UIDropDownMenu_AddButton( info, level )

	wipe( info )
	info.disabled = nil
	info.notCheckable = 1
	info.text = CLOSE
	info.func = self.HideMenu
	info.tooltipTitle = CLOSE
	UIDropDownMenu_AddButton( info, level )
end