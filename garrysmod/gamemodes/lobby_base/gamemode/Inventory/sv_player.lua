
local _Player = FindMetaTable("Player")

function _Player:GiveItem( Name, slot, extra )
	local ID = tonumber( self:UniqueID() )
	slot = slot or self:GetNextAvailableSlot( )
	extra = extra or ""
	
	if ( LobbyItem.Get( Name ) ) then
		
		LobbyInventory.MySQL.Cache[ ID ][slot] = { Name, extra }
		LobbyInventory.MySQL.Save( ID )
		self:UpdateClientInventory()
		
		for k,v in pairs( player.GetAll() ) do
			v:UpdateOtherClientsInventory()
		end
		
		LobbyInventory.MySQL.Cache[ ID ][slot][3] = LobbyItem.CreateInstance( Name , slot, extra, self )
		
		hook.Call( "InventoryPlayerRecievedItem", GAMEMODE, self, Name, slot, extra )
		
	end
end

function _Player:GetItems( )
	local ID = tonumber( self:UniqueID() )
	return LobbyInventory.MySQL.GetUser( ID )
end

function _Player:GetItem( slot )
	return self:GetItems()[slot] or false
end

function _Player:UpdateClientInventory()

	net.Start( "Lobby.UpdateInventory" )
	local inv = LobbyInventory.MySQL.GetUser( tonumber(self:UniqueID()) )
	local data = {}
	for k,v in pairs( inv ) do
		data[k] = {v[1],v[2]}
	end
	net.WriteTable( data )
	net.Send( self )
	
end

function _Player:UpdateOtherClientsInventory()

	net.Start( "Lobby.UpdateOtherClientsInventory" )
	local inv = LobbyInventory.MySQL.GetUser( tonumber(self:UniqueID()) )
	local data = {}
	for plID, inv in pairs( LobbyInventory.MySQL.Cache ) do
		local _player = player.GetByUniqueID( tostring(plID) )
		if _player and _player != self then -- Don't resend to the client his inventory, only send others
			data[_player] = {}
			for k,v in pairs( inv ) do
				data[_player][k] = {v[1],v[2]}
			end
		end
	end
	net.WriteTable( data )
	net.Send( self )
	
end

function _Player:InitItems()
	for slot,v in pairs( self:GetItems() ) do
		local name = v[1]
		local extra = v[2]
		
		v[3] = LobbyItem.CreateInstance( name , slot, extra, self )
		if ( string.len( extra ) > 0 and v[3].SetCustom ) then
			v[3]:SetCustom( extra )
		end
		
	end
	
	self:UpdateClientInventory()
	for k,v in pairs( player.GetAll() ) do
		v:UpdateOtherClientsInventory()
	end
end

function _Player:BuyItem( name, slot, extra )
	local ID = tonumber( self:UniqueID() )
	slot = slot or #LobbyInventory.MySQL.GetUser( ID ) + 1
	extra = extra or ""
	local item = LobbyItem.Get( name )
	if item then
		local price = item.Price
		if self:CanAfford( price ) then
			self:TakeMoney( price )
			self:GiveItem( name, slot, extra )
			return true
		end
	end
	return false
end

function _Player:DestroyItem( slot )
	local item = self:GetItem( slot )
	if item then
		LobbyItem.DestroyInstance( item[3], self, slot )
		LobbyInventory.MySQL.GetUser( tonumber(self:UniqueID()) )[slot] = nil
		LobbyInventory.MySQL.Save( ID )
		self:UpdateClientInventory()
		for k,v in pairs( player.GetAll() ) do
			v:UpdateOtherClientsInventory()
		end
	end
end

function _Player:MoveItemToSlot( slot1, slot2 )
	local uni = tonumber( self:UniqueID() )
	local item = self:GetItem( slot1 )
	if item then
		local item2 = self:GetItem( slot2 )
		if item2 then -- Switch slots
		
			LobbyItem.DestroyInstance( item2[3], self, slot2 )
			LobbyItem.DestroyInstance( item[3], self, slot1 )
			
			local name1, custom1, name2, custom2 = LobbyInventory.MySQL.GetUser(uni )[slot1][1], LobbyInventory.MySQL.GetUser(uni )[slot1][2], LobbyInventory.MySQL.GetUser(uni )[slot2][1], LobbyInventory.MySQL.GetUser(uni )[slot2][2]
			
			LobbyInventory.MySQL.GetUser(uni )[slot1] = nil
			LobbyInventory.MySQL.GetUser(uni )[slot2] = nil
			
			LobbyInventory.MySQL.GetUser(uni )[slot1] = { 
				name1,
				custom1,
				LobbyItem.CreateInstance( name1 , slot1, custom1, self )
			}
			
			if ( string.len( LobbyInventory.MySQL.GetUser(uni )[slot1][2][2] ) > 0 and LobbyInventory.MySQL.GetUser(uni )[slot1][3].SetCustom ) then
				LobbyInventory.MySQL.GetUser(uni )[slot1][3]:SetCustom( extra )
			end
			
			LobbyInventory.MySQL.GetUser(uni )[slot2] = { 
				name2,
				custom2,
				LobbyItem.CreateInstance( name2, slot2, custom2, self )
			}
			
			if ( string.len( LobbyInventory.MySQL.GetUser(uni )[slot2][2][2] ) > 0 and LobbyInventory.MySQL.GetUser(uni )[slot2][3].SetCustom ) then
				LobbyInventory.MySQL.GetUser(uni )[slot2][3]:SetCustom( LobbyInventory.MySQL.GetUser(uni )[slot2][2] )
			end

		
		else -- simple move
			
			LobbyInventory.MySQL.GetUser(uni )[slot2] = { 
				item[1],
				item[2],
				LobbyItem.CreateInstance( item[1] , slot2, item[2], self )
			}
			
			LobbyItem.DestroyInstance( item[3], self, slot1 )
			LobbyInventory.MySQL.GetUser(uni )[slot1] = nil

			if ( string.len( LobbyInventory.MySQL.GetUser(uni )[slot2][2] ) > 0 and LobbyInventory.MySQL.GetUser(uni )[slot2][3].SetCustom ) then
				LobbyInventory.MySQL.GetUser(uni )[slot2][3]:SetCustom( LobbyInventory.MySQL.GetUser(uni )[slot2][2] )
			end
		end
		LobbyInventory.MySQL.Save( uni )
		self:UpdateClientInventory()
		for k,v in pairs( player.GetAll() ) do
			v:UpdateOtherClientsInventory()
		end
	end
	
end

function _Player:GetNextAvailableSlot( )
	for i=1, 50 do
		if ( not self:GetItem( i ) ) then return i end
	end
	return false
end

function _Player:SetItemCustom( slot, custom )
	local item = self:GetItem( slot )
	if item then
		item[2] = custom
		item[3]:SetCustom( custom )
		LobbyInventory.MySQL.Save( tonumber(self:UniqueID()) )
		self:UpdateClientInventory()
		for k,v in pairs( player.GetAll() ) do
			v:UpdateOtherClientsInventory()
		end
	end
end

function _Player:GetItemCustom( slot )
	local item = self:GetItem( slot )
	if item then return item[2] end
end