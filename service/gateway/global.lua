local Global = {}

Global.conns = {} -- fd -> conn，连接和玩家的关联
Global.players = {} -- playerid -> gate_player，玩家和agent的关联

return Global
