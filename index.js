
ygopro.ctos_follow_before('HS_TOOBSERVER', true, async (buffer, info, client, server, datas) => {
	return true;
});

ygopro.ctos_follow_before('HS_KICK', true, async (buffer, info, client, server, datas) => {
	return true;
});

ygopro.stoc_follow_before('HAND_RESULT', true, async (buffer, info, client, server, datas) => {
	return true;
});

ygopro.stoc_follow_before('JOIN_GAME', true, async (buffer, info, client, server, datas) => {
	const room = ROOM_all[client.rid];
	if (!room || !client.is_local) {
		return false;
	}
	room.determine_firstgo = client;
	return false;
});

ygopro.ctos_follow_before("JOIN_GAME", false, async (buffer, info, client, server, datas) => {
	if (client.is_local) {
		return false;
	}
	const struct = ygopro.structs.get("CTOS_JoinGame");
	struct._setBuff(buffer);
	struct.set("pass", "AI");
	buffer = struct.buffer;
	return false;
});
