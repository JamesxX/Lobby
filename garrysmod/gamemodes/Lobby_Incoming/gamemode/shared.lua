GM.Name     				= "Lobby: Incoming"
GM.Author   				= "Neo and Oss"

GM.ScoreboardName			= "Incoming"
GM.Community				= "CitronGamers"
GM.Website  				= "http://www.citrongamers.com/"
GM.ScoreboardTeamBased		= true -- Change variable name, makes weird DFrame base\gamemode\cl_pickteam.lua:12

DeriveGamemode("Lobby_Base")  

LobbyModules.LoadModules( {
	"translations",
	"money",
	"scoreboard2",
	"thirdperson"
} )

team.SetUp( 1, "Alive", Color( 255, 255, 100, 255 ) )
team.SetUp( 2, "Dead", Color( 100, 100, 50, 255 ) )