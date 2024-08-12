---模块类
local Module = ModuleBase:createModule('petMega')

local MegaKind_check= {600073};				--enemy编号
local MegaKind_list = {};
MegaKind_list[600073] = {119740, 200500, 200509, 'DD:', 30, 'AN:', 10 , 'AM:', 10};		--形象、techID、techID、option、val
MegaKind_list[600074] = {119751, 400, 409, 'DD:', 80, 'AN:', 10 , 'AM:', 10};
MegaKind_list[600075] = {119753, 400, 409, 'DD:', 80, 'AN:', 10 , 'AM:', 10};
MegaKind_list[600076] = {119755, 400, 409, 'DD:', 80, 'AN:', 10 , 'AM:', 10};
MegaKind_list[600077] = {119757, 400, 409, 'DD:', 80, 'AN:', 10 , 'AM:', 10};
MegaKind_list[600078] = {119759, 400, 409, 'DD:', 80, 'AN:', 10 , 'AM:', 10};
MegaKind_list[600079] = {119761, 400, 409, 'DD:', 80, 'AN:', 10 , 'AM:', 10};
MegaKind_list[600080] = {119763, 400, 409, 'DD:', 80, 'AN:', 10 , 'AM:', 10};
MegaKind_list[600081] = {119765, 400, 409, 'DD:', 80, 'AN:', 10 , 'AM:', 10};

function CheckInTable(_idTab, _idVar) ---循环函数
	for k,v in pairs(_idTab) do
		if v==_idVar then
			return true
		end
	end
	return false
end

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('ItemString', Func.bind(self.onMegaUse, self), 'LUA_useMega');  --鑰石手環和Mega石
  self:regCallback('BattleOverEvent', Func.bind(self.battleOverEventCallback, self));
  self:regCallback('LoginEvent', Func.bind(self.onLoginEvent, self));
  self:regCallback('LogoutEvent', Func.bind(self.onLogoutEvent, self));
  self:regCallback('TechOptionEvent', Func.bind(self.OnTechOptionEventCallBack, self));
  self:regCallback('CalcCriticalRateEvent', Func.bind(self.OnCalcCriticalRateEvent, self));
  self:regCallback('BattleDodgeRateEvent', Func.bind(self.OnBattleDodgeRateEvent, self));
  --self:regCallback('BattleCounterRateEvent', Func.bind(self.OnBattleCounterRateEvent, self));
end

--获取宠物装备-項圈
Pet.GetCollar = function(petIndex)
  local ItemIndex = Char.GetItemIndex(petIndex, CONST.宠道栏_颈圈);
  if ItemIndex >= 0 and Item.GetData(ItemIndex, CONST.道具_类型)==CONST.道具类型_宠物颈圈 then
    return ItemIndex,CONST.宠道栏_颈圈;
  end
  return -1,-1;
end

--Mega石使用
function Module:onMegaUse(charIndex, targetCharIndex, itemSlot)
  local itemIndex = Char.GetItemIndex(charIndex,itemSlot);
  local battleIndex = Char.GetBattleIndex(charIndex);
  local ItemID = Item.GetData(itemIndex, CONST.道具_ID);
  local Target_FloorId = Char.GetData(charIndex,CONST.CHAR_地图);
  if (Item.GetData(itemIndex, CONST.道具_类型)==26) then
      if (ItemID==69172 and battleIndex==-1 and Battle.IsWaitingCommand(charIndex)<=0) then
               NLG.SystemMessage(charIndex,"[道具提示]戰鬥中才能使用的道具");
      elseif (ItemID==69172) then
            --if (Target_FloorId~=20233) then
            --    NLG.SystemMessage(charIndex,"[道具提示]只能在限定地圖使用的道具");
            --else
                for Slot=0,4 do
                    local petIndex = Char.GetPet(charIndex, Slot);
                    if (petIndex>0 and Char.GetData(petIndex,CONST.PET_DepartureBattleStatus)==CONST.PET_STATE_战斗) then
                        local Mega = Char.GetTempData(charIndex, 'MegaOn') or 0;
                        local PetId = Char.GetData(petIndex,CONST.PET_PetID);
                        if (Mega==0 and CheckInTable(MegaKind_check,PetId)==true) then
                            --local petImage = Char.GetData(petIndex, CONST.CHAR_原形);
                            local PetCollarIndex = Pet.GetCollar(petIndex);
                            local StoneID = Item.GetData(PetCollarIndex, CONST.道具_ID);
                            if (StoneID == 69080)  then
                                Char.SetData(petIndex, CONST.CHAR_形象, MegaKind_list[PetId][1]);
                                --Char.SetData(petIndex, CONST.CHAR_可视, 119741);
                                NLG.UpChar(petIndex);
                                Char.SetTempData(charIndex, 'MegaOn', 1);
                                NLG.SystemMessage(charIndex,"[系統]寵物即將超級進化！");
                                --全體攻擊無效1回合
                                for  i=0, 19 do
                                    local player = Battle.GetPlayIndex(battleIndex, i)
                                     if player>=0 then
                                          if Char.IsPlayer(player) or Char.IsPet(player) then
                                              Char.SetData(player, CONST.对象_DamageVanish, 2);
                                              NLG.UpChar(player);
                                          end
                                     end
                                end
                            end
                        elseif (Mega==1) then
                            NLG.SystemMessage(charIndex,"[系統]寵物已經Mega！");
                        else
                            NLG.SystemMessage(charIndex,"[系統]不可牽絆進化的寵物！");
                        end
                    end
                end
            --end
      else
      end
  end
end

--结束、注销初始化
function Module:battleOverEventCallback(battleIndex)
  for i = 0, 9 do
        local charIndex = Battle.GetPlayer(battleIndex, i);
        if charIndex >= 0 then
              local Mega = Char.GetTempData(charIndex, 'MegaOn') or 0;
              if Mega==1 then
                 for Slot=0,4 do
                     local petIndex = Char.GetPet(charIndex, Slot);
                     if (petIndex>0) then
                         local petImage = Char.GetData(petIndex, CONST.CHAR_原形);
                         Char.SetData(petIndex, CONST.CHAR_形象, petImage);
                         Pet.UpPet(charIndex, petIndex);
                         NLG.UpChar(charIndex);
                     end
                 end
                 Char.SetTempData(charIndex, 'MegaOn', 0);
              end
        end
  end
end
function Module:onLogoutEvent(charIndex)
	local Mega = Char.GetTempData(charIndex, 'MegaOn') or 0;
	if Mega==1 then
		for Slot=0,4 do
			local petIndex = Char.GetPet(charIndex, Slot);
			if (petIndex>0) then
				local petImage = Char.GetData(petIndex, CONST.CHAR_原形);
				Char.SetData(petIndex, CONST.CHAR_形象, petImage);
				Pet.UpPet(charIndex, petIndex);
				NLG.UpChar(charIndex);
			end
		end
		Char.SetTempData(charIndex, 'MegaOn', 0);
	end
end
function Module:onLoginEvent(charIndex)
	local Mega = Char.GetTempData(charIndex, 'MegaOn') or 0;
	if Mega==1 then
		for Slot=0,4 do
			local petIndex = Char.GetPet(charIndex, Slot);
			if (petIndex>0) then
				local petImage = Char.GetData(petIndex, CONST.CHAR_原形);
				Char.SetData(petIndex, CONST.CHAR_形象, petImage);
				Pet.UpPet(charIndex, petIndex);
				NLG.UpChar(charIndex);
			end
		end
		Char.SetTempData(charIndex, 'MegaOn', 0);
	end
end

--超级进化加强技能效果
function Module:OnTechOptionEventCallBack(charIndex, option, techID, val)
      --self:logDebug('OnTechOptionEventCallBack', charIndex, option, techID, val)
      local battleIndex = Char.GetBattleIndex(charIndex)
      local leader1 = Battle.GetPlayer(battleIndex,0)
      local leader2 = Battle.GetPlayer(battleIndex,5)
      local leader = leader1
      if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
            leader = leader2
      end
      if Char.IsPet(charIndex) then
          local PetCollarIndex = Pet.GetCollar(charIndex);
          local StoneID = Item.GetData(PetCollarIndex, CONST.道具_ID);
          local PetId = Char.GetData(charIndex,CONST.PET_PetID);
          local playerOwner= Pet.GetOwner(charIndex);
          local Mega = Char.GetTempData(playerOwner, 'MegaOn') or 0;
          if Mega==1 and StoneID == 69080 then
                  if techID >= MegaKind_list[PetId][2] and techID <= MegaKind_list[PetId][3]  then
                        if option == MegaKind_list[PetId][4] then
                              if Char.GetData(playerOwner,%对象_队聊开关%) == 1  then
                                  NLG.Say(playerOwner,charIndex,"【精神強刃】！！",4,3);
                              end
                              return val + MegaKind_list[PetId][5];
                        elseif option == MegaKind_list[PetId][6] then
                              if Char.GetData(playerOwner,%对象_队聊开关%) == 1  then
                                  --NLG.Say(playerOwner,charIndex,"【精神強刃】！！",4,3);
                              end
                              return val + MegaKind_list[PetId][7];
                        elseif option == MegaKind_list[PetId][8] then
                              if Char.GetData(playerOwner,%对象_队聊开关%) == 1  then
                                  --NLG.Say(playerOwner,charIndex,"【精神強刃】！！",4,3);
                              end
                              return val + MegaKind_list[PetId][9];
                        end
                        return val
                  end
          end
      else
      end
end

function Module:OnCalcCriticalRateEvent(aIndex, fIndex, rate)
      --self:logDebug('OnCalcCriticalRateCallBack', aIndex, fIndex, rate)
      local battleIndex = Char.GetBattleIndex(aIndex);
      if Char.IsPet(aIndex) and Char.IsEnemy(fIndex) then
          local PetCollarIndex = Pet.GetCollar(aIndex);
          local StoneID = Item.GetData(PetCollarIndex, CONST.道具_ID);
          local PetId = Char.GetData(aIndex,CONST.PET_PetID);
          local playerOwner= Pet.GetOwner(aIndex);
          local Mega = Char.GetTempData(playerOwner, 'MegaOn') or 0;
          if Mega==1 and StoneID == 69080 then
                  rate = 100;
                  return rate
          end
      else
      end
      return rate
end

function Module:OnBattleDodgeRateEvent(battleIndex, aIndex, fIndex, rate)
      --self:logDebug('OnBattleDodgeRateCallBack', battleIndex, aIndex, fIndex, rate)
      local battleIndex = Char.GetBattleIndex(aIndex);
      if Char.IsPet(aIndex) and Char.IsEnemy(fIndex) then	--必中
          local PetCollarIndex = Pet.GetCollar(aIndex);
          local StoneID = Item.GetData(PetCollarIndex, CONST.道具_ID);
          local PetId = Char.GetData(aIndex,CONST.PET_PetID);
          local playerOwner= Pet.GetOwner(aIndex);
          local Mega = Char.GetTempData(playerOwner, 'MegaOn') or 0;
          if Mega==1 and StoneID == 69080 then
                  rate = 0;
                  return rate
          end
      elseif Char.IsPet(fIndex) and Char.IsEnemy(aIndex) then	--必闪
          local PetCollarIndex = Pet.GetCollar(fIndex);
          local StoneID = Item.GetData(PetCollarIndex, CONST.道具_ID);
          local PetId = Char.GetData(fIndex,CONST.PET_PetID);
          local playerOwner= Pet.GetOwner(fIndex);
          local Mega = Char.GetTempData(playerOwner, 'MegaOn') or 0;
          if Mega==1 and StoneID == 69080 then
                  rate = 100;
                  return rate
          end
      else
      end
      return rate
end

function Module:OnBattleCounterRateEvent(battleIndex, aIndex, fIndex, rate)
         --self:logDebug('OnBattleCounterRateCallBack', battleIndex, aIndex, fIndex, rate)
      local battleIndex = Char.GetBattleIndex(aIndex);
      if Char.IsPet(aIndex) and Char.IsEnemy(fIndex) then
          local PetCollarIndex = Pet.GetCollar(aIndex);
          local StoneID = Item.GetData(PetCollarIndex, CONST.道具_ID);
          local PetId = Char.GetData(aIndex,CONST.PET_PetID);
          local playerOwner= Pet.GetOwner(aIndex);
          local Mega = Char.GetTempData(playerOwner, 'MegaOn') or 0;
          if Mega==1 and StoneID == 69080 then
                  rate = 100;
                  return rate
          end
      else
      end
      return rate
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
