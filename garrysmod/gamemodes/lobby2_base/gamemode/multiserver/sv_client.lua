--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, 2015
	
-----------------------------------------------------------]]--

GM.Multiserver = GM.Multiserver or { }
GM.Multiserver.Client = GM.Multiserver.Client or { }
GM.Multiserver.Client.Connections = GM.Multiserver.Client.Connections or {}

-- Port range: 44901 - 44999

require( "bromsock");

function GM.Multiserver.Client.New( IP, ServerID, packet, callback )

	local GM = GM or gmod.GetGamemode( )
	local port = GM.Multiserver.Server.StartPort + ServerID
	
	if GM.Multiserver.Client.Connections[ ServerID ] then GM.Multiserver.Client.Connections[ ServerID ]:Close() end
	GM.Multiserver.Client.Connections[ ServerID ] = BromSock()
	local client = GM.Multiserver.Client.Connections[ ServerID ]
	
	client:SetCallbackConnect(function(sock, ret, ip, port)
	
		if (not ret) then
			GM:Print( "[Multiserver] Failed to connect to ServerID %i", ServerID )
			return
		end

		client:Send( packet )
		GM.Multiserver.Client.HandleConnection( ServerID, client, sock, ret, ip, port )
		
		client:Receive()

	end)

	client:SetCallbackReceive(function(sock, rpacket)
		
		GM.Multiserver.Client.HandleResponse( ServerID, client, sock, rpacket, callback )
		sock:Disconnect()

	end)

	client:Connect( IP , port)
end

function GM.Multiserver.Client.HandleConnection( ServerID, client, sock, ret, ip, port )


end

function GM.Multiserver.Client.HandleResponse( ServerID, client, sock, packet, callback )

	callback( ServerID, client, sock, packet )

end
