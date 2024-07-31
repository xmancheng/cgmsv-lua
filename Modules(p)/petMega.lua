---ģ����
local Module = ModuleBase:createModule('petMega')

local MegaKind_check= {600073};				--enemy���
local MegaKind_list = {};
MegaKind_list[600073] = {119740, 200500, 200509, 'DD:', 30};		--����techID��techID��option��val

function CheckInTable(_idTab, _idVar) ---ѭ������
	for k,v in pairs(_idTab) do
		if v==_idVar then
			return true
		end
	end
	return false
end

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('ItemString', Func.bind(self.onMegaUse, self), 'LUA_useMega');  --�ʯ�֭h��Megaʯ
  self:regCallback('BattleOverEvent', Func.bind(self.battleOverEventCallback, self));
  self:regCallback('LoginEvent', Func.bind(self.onLoginEvent, self));
  self:regCallback('LogoutEvent', Func.bind(self.onLogoutEvent, self));
  self:regCallback('TechOptionEvent', Func.bind(self.OnTechOptionEventCallBack, self));
end

--��ȡ����װ��-�Ȧ
Pet.GetCollar = function(petIndex)
  local ItemIndex = Char.GetItemIndex(petIndex, CONST.�����_��Ȧ);
  if ItemIndex >= 0 and Item.GetData(ItemIndex, CONST.����_����)==CONST.��������_���ﾱȦ then
    return ItemIndex,CONST.�����_��Ȧ;
  end
  return -1,-1;
end

--Megaʯʹ��
function Module:onMegaUse(charIndex, targetCharIndex, itemSlot)
  local itemIndex = Char.GetItemIndex(charIndex,itemSlot);
  local battleIndex = Char.GetBattleIndex(charIndex);
  local ItemID = Item.GetData(itemIndex, CONST.����_ID);
  local Target_FloorId = Char.GetData(charIndex,CONST.CHAR_��ͼ);
  if (Item.GetData(itemIndex, CONST.����_����)==26) then
      if (ItemID==69172 and battleIndex==-1 and Battle.IsWaitingCommand(charIndex)<=0) then
               NLG.SystemMessage(charIndex,"[������ʾ]���Y�в���ʹ�õĵ���");
      elseif (ItemID==69172) then
            if (Target_FloorId~=20233) then
                NLG.SystemMessage(charIndex,"[������ʾ]ֻ�����޶��؈Dʹ�õĵ���");
            else
                for Slot=0,4 do
                    local petIndex = Char.GetPet(charIndex, Slot);
                    if (petIndex>0 and Char.GetData(petIndex,CONST.PET_DepartureBattleStatus)==CONST.PET_STATE_ս��) then
                        local Mega = Char.GetTempData(charIndex, 'MegaOn') or 0;
                        local PetId = Char.GetData(petIndex,CONST.PET_PetID);
                        if (Mega==0 and CheckInTable(MegaKind_check,PetId)==true) then
                            --local petImage = Char.GetData(petIndex, CONST.CHAR_ԭ��);
                            local PetCollarIndex = Pet.GetCollar(petIndex);
                            local StoneID = Item.GetData(PetCollarIndex, CONST.����_ID);
                            if (StoneID == 69080)  then
                                Char.SetData(petIndex, CONST.CHAR_����, MegaKind_list[PetId][1]);
                                --Char.SetData(petIndex, CONST.CHAR_����, 119741);
                                NLG.UpChar(petIndex);
                                Char.SetTempData(charIndex, 'MegaOn', 1);
                                NLG.SystemMessage(charIndex,"[ϵ�y]���Ｔ�������M����");
                            end
                        elseif (Mega==1) then
                            NLG.SystemMessage(charIndex,"[ϵ�y]�����ѽ�Mega��");
                        else
                            NLG.SystemMessage(charIndex,"[ϵ�y]���ɠ��O�M���Č��");
                        end
                    end
                end
            end
      else
      end
  end
end

--������ע����ʼ��
function Module:battleOverEventCallback(battleIndex)
  for i = 0, 9 do
        local charIndex = Battle.GetPlayer(battleIndex, i);
        if charIndex >= 0 then
              local Mega = Char.GetTempData(charIndex, 'MegaOn') or 0;
              if Mega==1 then
                 for Slot=0,4 do
                     local petIndex = Char.GetPet(charIndex, Slot);
                     if (petIndex>0) then
                         local petImage = Char.GetData(petIndex, CONST.CHAR_ԭ��);
                         Char.SetData(petIndex, CONST.CHAR_����, petImage);
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
	local Mega = Char.GetTempData(charIndex, 'MegaOn');
	if Mega then
		for Slot=0,4 do
			local petIndex = Char.GetPet(charIndex, Slot);
			if (petIndex>0) then
				local petImage = Char.GetData(petIndex, CONST.CHAR_ԭ��);
				Char.SetData(petIndex, CONST.CHAR_����, petImage);
				Pet.UpPet(charIndex, petIndex);
				NLG.UpChar(charIndex);
			end
		end
		Char.SetTempData(charIndex, 'MegaOn', 0);
	end
end
function Module:onLoginEvent(charIndex)
	local Mega = Char.GetTempData(charIndex, 'MegaOn');
	if Mega then
		for Slot=0,4 do
			local petIndex = Char.GetPet(charIndex, Slot);
			if (petIndex>0) then
				local petImage = Char.GetData(petIndex, CONST.CHAR_ԭ��);
				Char.SetData(petIndex, CONST.CHAR_����, petImage);
				Pet.UpPet(charIndex, petIndex);
				NLG.UpChar(charIndex);
			end
		end
		Char.SetTempData(charIndex, 'MegaOn', 0);
	end
end

--����������ǿ����Ч��
function Module:OnTechOptionEventCallBack(charIndex, option, techID, val)
      --self:logDebug('OnTechOptionEventCallBack', charIndex, option, techID, val)
      local battleIndex = Char.GetBattleIndex(charIndex)
      local leader1 = Battle.GetPlayer(battleIndex,0)
      local leader2 = Battle.GetPlayer(battleIndex,5)
      local leader = leader1
      if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
            leader = leader2
      end
      if Char.IsPet(charIndex) then
          local PetCollarIndex = Pet.GetCollar(charIndex);
          local StoneID = Item.GetData(PetCollarIndex, CONST.����_ID);
          local PetId = Char.GetData(charIndex,CONST.PET_PetID);
          local playerOwner= Pet.GetOwner(charIndex);
          local Mega = Char.GetTempData(playerOwner, 'MegaOn') or 0;
          if Mega==1 and StoneID == 69080 then
                  if techID >= MegaKind_list[PetId][2] and techID <= MegaKind_list[PetId][3]  then
                        if option == MegaKind_list[PetId][4] then
                              if Char.GetData(playerOwner,%����_���Ŀ���%) == 1  then
                                  NLG.Say(playerOwner,charIndex,"�������С�����",4,3);
                              end
                              return val + MegaKind_list[PetId][5];
                        end
                        return val
                  end
          end
      else
      end
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
