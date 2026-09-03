---模块类
local Module = ModuleBase:createModule('uiMenu')
local TechArea = require "lua/Modules/techarea"

--------------------------------------------------
-- 客戶端封包通訊同步
--------------------------------------------------
function Module:Frontcg2dPackTrigger(fd,head,data)
    local player = tonumber(Protocol.GetCharByFd(fd))
    if head == 'uiMenu' then
      local packetNumber = tonumber(data[1])
      if packetNumber == 1 then
        Protocol.Send(player,'SyncAptitudeData')	--勇者適性
      elseif packetNumber == 2 then
        Protocol.Send(player,'SyncGatheringData')	--探索指引
      end
    end
end

------------------------------------------------
--- 玩家擴展資訊:接收要求後回傳
function Module:playerInfo_SendData(fd,head,data)
    local player = tonumber(Protocol.GetCharByFd(fd))
    if head == 'RequestPlayerInfoData' then
      local id1 = Char.GetExtData(player, '勇者等级') or 1;
      local id2 = Char.GetExtData(player, '勇者经验') or 0;
      local id3 = GetHeroExpNeed(id1) or 0;
      local id4 = Char.GetExtData(player, '探索等级') or 1;
      local id5 = Char.GetExtData(player, '探索经验') or 0;
      local id6 = GetExploreExpNeed(id4) or 0;
      Protocol.Send(player,'ResponsePlayerInfoData', id1.."|"..id2.."|"..id3.."|"..id4.."|"..id5.."|"..id6)
    end
    return 0
end
--- 探索指引資訊:接收要求後回傳
function Module:gatherInfo_SendData(fd,head,data)
    local player = tonumber(Protocol.GetCharByFd(fd))
    if head == 'RequestGatheringData' then
      local floor = Char.GetData(player,CONST.对象_地图);
      local px = Char.GetData(player,CONST.对象_X);
      local py = Char.GetData(player,CONST.对象_Y);
      local area_225 = GetTechArea(floor, px, py, TechArea, 225);	--skillId225
      if (area_225==nil) then
        Ga_id1 = "無物品";
        Ga_id2 = "無物品";
        Ga_id3 = "無物品";
      else
        local drops = area_225.drops;
		local itemId = drops[1];
		local ItemsetIndex = Data.ItemsetGetIndex(itemId) or -1;
		Ga_id1 = Data.ItemsetGetData(ItemsetIndex, CONST.ITEMSET_TRUENAME) or "無物品";
		if ItemsetIndex==0 or Ga_id1==-1 then Ga_id1 = "無物品" end
		local itemId = drops[3];
		local ItemsetIndex = Data.ItemsetGetIndex(itemId) or -1;
		Ga_id2 = Data.ItemsetGetData(ItemsetIndex, CONST.ITEMSET_TRUENAME) or "無物品";
		if ItemsetIndex==0 or Ga_id2==-1 then Ga_id2 = "無物品" end
		local itemId = drops[5];
		local ItemsetIndex = Data.ItemsetGetIndex(itemId) or -1;
		Ga_id3 = Data.ItemsetGetData(ItemsetIndex, CONST.ITEMSET_TRUENAME) or "無物品";
		if ItemsetIndex==0 or Ga_id3==-1 then Ga_id3 = "無物品" end
      end
      local area_226 = GetTechArea(floor, px, py, TechArea, 226);	--skillId226
      if (area_226==nil) then
        Ga_id4 = "無物品";
        Ga_id5 = "無物品";
        Ga_id6 = "無物品";
      else
        local drops = area_226.drops;
		local itemId = drops[1];
		local ItemsetIndex = Data.ItemsetGetIndex(itemId) or -1;
		Ga_id4 = Data.ItemsetGetData(ItemsetIndex, CONST.ITEMSET_TRUENAME) or "無物品";
		if ItemsetIndex==0 or Ga_id4==-1 then Ga_id4 = "無物品" end
		local itemId = drops[3];
		local ItemsetIndex = Data.ItemsetGetIndex(itemId) or -1;
		Ga_id5 = Data.ItemsetGetData(ItemsetIndex, CONST.ITEMSET_TRUENAME) or "無物品";
		if ItemsetIndex==0 or Ga_id5==-1 then Ga_id5 = "無物品" end
		local itemId = drops[5];
		local ItemsetIndex = Data.ItemsetGetIndex(itemId) or -1;
		Ga_id6 = Data.ItemsetGetData(ItemsetIndex, CONST.ITEMSET_TRUENAME) or "無物品";
		if ItemsetIndex==0 or Ga_id6==-1 then Ga_id6 = "無物品" end
      end
      local area_227 = GetTechArea(floor, px, py, TechArea, 227);	--skillId227
      if (area_227==nil) then
        Ga_id7 = "無物品";
        Ga_id8 = "無物品";
        Ga_id9 = "無物品";
      else
        local drops = area_227.drops;
		local itemId = drops[1];
		local ItemsetIndex = Data.ItemsetGetIndex(itemId) or -1;
		Ga_id7 = Data.ItemsetGetData(ItemsetIndex, CONST.ITEMSET_TRUENAME) or "無物品";
		if ItemsetIndex==0 or Ga_id7==-1 then Ga_id7 = "無物品" end
		local itemId = drops[3];
		local ItemsetIndex = Data.ItemsetGetIndex(itemId) or -1;
		Ga_id8 = Data.ItemsetGetData(ItemsetIndex, CONST.ITEMSET_TRUENAME) or "無物品";
		if ItemsetIndex==0 or Ga_id8==-1 then Ga_id8 = "無物品" end
		local itemId = drops[5];
		local ItemsetIndex = Data.ItemsetGetIndex(itemId) or -1;
		Ga_id9 = Data.ItemsetGetData(ItemsetIndex, CONST.ITEMSET_TRUENAME) or "無物品";
		if ItemsetIndex==0 or Ga_id9==-1 then Ga_id9 = "無物品" end
      end
      Protocol.Send(player,'ResponseGatheringData', Ga_id1..","..Ga_id2..","..Ga_id3.."|"..Ga_id4..","..Ga_id5..","..Ga_id6.."|"..Ga_id7..","..Ga_id8..","..Ga_id9)
    end
    return 0
end
------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  -- 註冊 UI 封包請求
  self:regCallback('ProtocolOnRecv',Func.bind(self.Frontcg2dPackTrigger,self),'uiMenu')					--前端按鈕整合封包
  self:regCallback('ProtocolOnRecv',Func.bind(self.playerInfo_SendData,self),'RequestPlayerInfoData')	--接收前端玩家擴展資訊所要
  self:regCallback('ProtocolOnRecv',Func.bind(self.gatherInfo_SendData,self),'RequestGatheringData')	--接收前端探索指引資訊所要

end

---------------------
-- 勇者等級熟練度表
function GetHeroExpNeed(lv)
	if lv >= 100 then return 0 end
	return 20 * lv * lv + 80 * lv + 100
end
-- 探索等級熟練度表
function GetExploreExpNeed(lv)
	if lv >= 100 then return 0 end
	return 20 * lv * lv + 80 * lv + 100
end
-- 取得玩家可採集資料
function GetTechArea(floor, px, py, TechArea, skillId)
    local m = TechArea[floor]
    if not m then return nil end
    local areas = m[skillId]
    if not areas then return nil end
    for i = 1, #areas do
        local a = areas[i]
        if px >= a.x1 and px <= a.x2 and py >= a.y1 and py <= a.y2 then
            return a
        end
    end
    return nil
end




function CheckInTable(_idTab, _idVar) ---循环函数
	for k,v in pairs(_idTab) do
		if v==_idVar then
			return true
		end
	end
	return false
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;