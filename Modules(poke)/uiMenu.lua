---模块类
local Module = ModuleBase:createModule('uiMenu')

--------------------------------------------------
-- 客戶端封包通訊同步
--------------------------------------------------
function Module:Frontcg2dPackTrigger(fd,head,data)
    local player = tonumber(Protocol.GetCharByFd(fd))
    if head == 'uiMenu' then
      local packetNumber = tonumber(data[1])
      if packetNumber == 1 then
        Protocol.Send(player,'SyncAptitudeData')	--勇者適性
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

------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  -- 註冊 UI 封包請求
  self:regCallback('ProtocolOnRecv',Func.bind(self.Frontcg2dPackTrigger,self),'uiMenu')					--前端按鈕整合封包
  self:regCallback('ProtocolOnRecv',Func.bind(self.playerInfo_SendData,self),'RequestPlayerInfoData')	--接收前端玩家擴展資訊所要

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