var noOfPlayers;
noOfPlayers = ds_list_size(global.players);
if(global.dedicatedMode)
    noOfPlayers -= 1;

var lobbyBuffer;
lobbyBuffer = buffer_create();
set_little_endian(lobbyBuffer, false);

write_buffer(lobbyBuffer, global.lobbyRegProtocolId);
write_buffer(lobbyBuffer, global.serverId);
write_buffer(lobbyBuffer, global.gg2lobbyId);
write_ubyte(lobbyBuffer, 0); // TCP
write_ushort(lobbyBuffer, global.hostingPort);
write_ushort(lobbyBuffer, global.playerLimit);
write_ushort(lobbyBuffer, noOfPlayers);
write_ushort(lobbyBuffer, 0); // Number of bots
if(global.serverPassword != "")
    write_ubyte(lobbyBuffer, 1);
else
    write_ubyte(lobbyBuffer, 0);
write_ubyte(lobbyBuffer, 0); // Reserved flags

writeKeyValue(lobbyBuffer, "name", global.serverName);
writeKeyValue(lobbyBuffer, "game", "Gang Garrison 2");
writeKeyValue(lobbyBuffer, "game_short", "gg2");
writeKeyValue(lobbyBuffer, "game_ver", GAME_VERSION_STRING);
writeKeyValue(lobbyBuffer, "game_url", "http://www.ganggarrison.com/");
writeKeyValue(lobbyBuffer, "map", global.currentMap);
write_ubyte(lobbyBuffer, string_length("protocol_id"));
write_string(lobbyBuffer, "protocol_id");
write_ushort(lobbyBuffer, 16);
write_buffer(lobbyBuffer, global.protocolUuid);

udp_send(lobbyBuffer, LOBBY_SERVER_HOST, LOBBY_SERVER_PORT);
buffer_destroy(lobbyBuffer);
