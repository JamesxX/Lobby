
local Commandhelp = {}
local faq = { }


function AddFAQ( Name , Answer )
	faq[ #faq+1 ] = { Name , Answer }
end

AddFAQ( "What Is the Lobby?" , "A gamemode developed by CitronGamers" )
AddFAQ( "What can I do in the lobby?" , "Minigames, Achievemets, Explore, Play with friends, Shop for upgrades, etc" )
AddFAQ( "How do I earn Diamonds?" , "Minigames, Achievemets, Playing on our servers" )
AddFAQ( "How do I change to thirdperson?" , "Use your scroll bar to zoom in or out" )

local function usmg_addhelp( um )
	local newentry = {}
	newentry[1] = um:ReadString()
	newentry[2] = um:ReadString()
		
	Commandhelp[newentry[1]] = newentry
	//table.insert( Commandhelp, newentry )
end
usermessage.Hook( "addhelp", usmg_addhelp )

function HUDDrawHelpScreen( startX, startY, bWidth )
	local Captions = { {"Command",20}, {"Info",80} }
	local bHeight = 0
	
	// Get the font height
	surface.SetFont( "ScoreboardText" )
	local txWidth, txHeight = surface.GetTextSize( "W" )		
	local RowHeight = txHeight + 4
	txWidth, txHeight = nil, nil
	
	// Global informations/help
	local infoheight = RowHeight * ( ( #faq + 1/2 ) * 3 )
	-- I've got to make this more dynamic..
	
	SetDrawColor( BGCOLOR, CELLALPHA )
	surface.DrawRect( startX, startY+5, bWidth, infoheight )
	
	SetTextColor( HIGHLIGHT )
	surface.SetTextPos( startX+16, startY+6 + RowHeight*0 )
	surface.DrawText( "	FAQs:"  )

	
	for k,v in ipairs( faq ) do
		surface.SetTextPos( startX+16, startY+6 + RowHeight*( (k*3) - 1 ) )
		surface.DrawText( v[1]  )
		
		surface.SetTextPos( startX+16, startY+6 + RowHeight*( k*3 ) )
		surface.DrawText( " 	" .. v[2]  )
	end
		
	startY = startY + infoheight
	
	// Column width definitions
	local ColWidths = {}
	for k, v in pairs( Captions ) do
		local tcol = {}
		tcol.width = math.floor( ( v[2]/100 ) * ( bWidth ) )
		tcol.start = 0
		if #ColWidths > 0 then
			for _, i in pairs( ColWidths ) do
				tcol.start = tcol.start + i.width
			end
		end
		ColWidths[k] = tcol
	end
	
	// Helpscreen table creation	
	local SBT = {}
	
	// - The row with the captions
	local CaptionRow = {}
	CaptionRow.TYPE = "Captions"
	CaptionRow.Color = BGCOLOR
	CaptionRow.TColor = Color( 255, 255, 255, 255 )
	CaptionRow.TColor = HIGHLIGHT
	CaptionRow.Cols = {}
	for k, v in pairs( Captions ) do
		table.insert( CaptionRow.Cols, v[1] )
	end
	table.insert( SBT, #SBT+1, CaptionRow )
	CaptionRow = nil
	
	// - The rows with the help text
	for hid, hinfo in pairs( Commandhelp ) do
		local tcolorn = Color( 250, 250, 250, CELLALPHA )
		local tcolorh = Color( 230, 230, 250, CELLALPHA )
		local trow = {}
		trow.TYPE = "Info"
		trow.Color = tcolorn
		if ( ( #SBT % 2 ) == 0 ) then
			trow.Color = tcolorh
		end
		trow.TColor = BGCOLOR
		trow.Cols = hinfo
		table.insert( SBT, #SBT+1, trow )
	end
	
	// Draw the help table
	bHeight = #SBT * RowHeight + 10
	
	startY = startY + 5
	
	local ry = 0
	for rid, row in pairs( SBT ) do
		ry = startY + (rid - 1) * RowHeight
		SetDrawColor( row.Color )
		surface.DrawRect( startX, ry, bWidth, RowHeight )
		SetTextColor( row.TColor )	
		for cid, col in pairs( row.Cols ) do
			local rx = startX + ColWidths[cid].start
			local rw = ColWidths[cid].width
			local txWidth, txHeight = surface.GetTextSize( tostring( col or "ERROR" ) )
			rx = rx + ( rw / 2 ) - ( txWidth / 2 )		
			surface.SetFont( "ScoreboardText" )
			surface.SetTextPos( math.floor( rx ), math.floor( ry ) + 2 )
			surface.DrawText( col )
		end 
	end		
	SetDrawColor( BGCOLOR )
	surface.DrawRect( startX, ry + RowHeight, bWidth, 10 )
	
	for _, col in pairs( ColWidths ) do
		if col.start > startX then
			surface.DrawLine( startX + col.start, startY, startX + col.start, startY + bHeight )
		end
	end
	
	SetDrawColor( BGCOLOR )
	surface.DrawOutlinedRect( startX, startY-infoheight, bWidth, bHeight+infoheight )
	
	surface.SetDrawColor( 45, 144, 208, 127 )
	surface.DrawOutlinedRect( startX-1, startY-1-infoheight, bWidth+2, bHeight+2+infoheight )
end