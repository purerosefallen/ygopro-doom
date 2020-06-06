
ygopro.ctos_follow_before('HS_TOOBSERVER', true, async (buffer, info, client, server, datas) => {
	return true;
});

ygopro.ctos_follow_before('HS_KICK', true, async (buffer, info, client, server, datas) => {
	return true;
});

ygopro.stoc_follow_before('HAND_RESULT', true, async (buffer, info, client, server, datas) => {
	return true;
});

ygopro.stoc_follow_after('SELECT_HAND', true, async (buffer, info, client, server, datas) => {
	var room = ROOM_all[client.rid];
	if (!room) {
		return false;
	}
	room.duel_stage = ygopro.constants.DUEL_STAGE.FINGER;
	ygopro.ctos_send(server, "HAND_RESULT", {
		res: client.is_local ? 2 : 1
	});
	return true;
});

ygopro.ctos_follow_before("JOIN_GAME", false, async (buffer, info, client, server, datas) => {
	if (client.is_local) {
		return false;
	}
	var struct = ygopro.structs["CTOS_JoinGame"];
	struct._setBuff(buffer);
	struct.set("pass", "AI");
	buffer = struct.buffer;
	return false;
});
