-- Awesome halo Item

ITEM.ShopID 		= 1

ITEM.Name 			= "Awesome Halo"
ITEM.UniqueName 	= "AwesomeHalo"
ITEM.Description 	= "Adds an awesome halo to your player model"
ITEM.Price			= 200000

ITEM.Hooks			= {"PreDrawHalos"}
ITEM.Player			= false

function ITEM:OnEquip( _Player )
	self.Equiped = true
	self.Player = _Player
end

function ITEM:PreDrawHalos()
	if self.Equiped and self.Player then
		if self.Player:Alive() then
			halo.Add( {self.Player}, Color( math.random(0,255),math.random(0,255),math.random(0,255)),5,5,3 )
		else
			halo.Add( {self.Player:GetRagdollEntity()}, Color( math.random(0,255),math.random(0,255),math.random(0,255)),5,5,3 )
		end
	end
end

function ITEM:OnHolister( _Player )
	self.Equiped = false
	self.Player = false
end