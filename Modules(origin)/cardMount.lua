local Module = ModuleBase:createModule('cardMount')

local MountEnable_check= {71050,71051,71052,71053,71054,71055,71056,71057,};
local sittingImages={}	--���T����
sittingImages[71050] = 149032;
sittingImages[71051] = 149027;
sittingImages[71052] = 104865;
sittingImages[71053] = 104923;
sittingImages[71054] = 104877;
sittingImages[71055] = 108021;
sittingImages[71056] = 104901;
sittingImages[71057] = 108087;

local sittingCards={}	--��|��|��|��|��|Ѫ|ħ
sittingCards[71050] = "0|0|0|150|0|0|0";		--���w�W�������T��.����+150
sittingCards[71051] = "150|0|0|0|0|0|0";		--�������ࡿ���T��.����+150
sittingCards[71052] = "0|0|0|0|0|0|0";			--�������i�������T��.
sittingCards[71053] = "100|0|0|0|0|0|0";		--����ü�i�������T��.����+100
sittingCards[71054] = "0|100|0|0|0|0|0";		--�������i�������T��.���R+100
sittingCards[71055] = "0|0|100|0|0|0|0";		--�������i�������T��.����+100
sittingCards[71056] = "0|0|0|100|0|0|0";		--���������������T��.����+100
sittingCards[71057] = "0|0|0|0|100|0|0";		--���G�c���������T��.�؏�+100
---------------------------------------------------------------------
--Զ�̰�ťUI����
--[[function Module:walkingspeed(npc, player)
      local msg = "\\n�����ƄӼ��١��ռ��Ļ�֮�񏊻���ľ��`֮�꣡\\n\\n��Lv1��110������Lv6��180�����������T�����\\n��Lv2��120������Lv7��200��\\n��Lv3��130������Lv8��220��\\n��Lv4��140������Lv9��250��\\n��Lv5��160������Lv10��300��\\n";
      if (Char.ItemNum(player, Agni_itemId)==0 and Char.ItemNum(player, Aqua_itemId)==1 and Char.ItemNum(player, Ventus_itemId)==0 and Char.ItemNum(player, Terra_itemId)==0) then
          local itemIndex = Char.HaveItem(player, Aqua_itemId);
          local sitting_image= Item.GetData(itemIndex,CONST.����_����);
          local imageText = "@g,"..sitting_image..",15,7,6,0@"
          msg = imageText .. msg;
      elseif (Char.ItemNum(player, Agni_itemId)==1 and Char.ItemNum(player, Aqua_itemId)==0 and Char.ItemNum(player, Ventus_itemId)==0 and Char.ItemNum(player, Terra_itemId)==0) then
          local itemIndex = Char.HaveItem(player, Agni_itemId);
          local sitting_image= Item.GetData(itemIndex,CONST.����_����);
          local imageText = "@g,"..sitting_image..",15,7,6,0@"
          msg = imageText .. msg;
      elseif (Char.ItemNum(player, Agni_itemId)==0 and Char.ItemNum(player, Aqua_itemId)==0 and Char.ItemNum(player, Ventus_itemId)==1 and Char.ItemNum(player, Terra_itemId)==0) then
          local itemIndex = Char.HaveItem(player, Ventus_itemId);
          local sitting_image= Item.GetData(itemIndex,CONST.����_����);
          local imageText = "@g,"..sitting_image..",15,7,6,0@"
          msg = imageText .. msg;
      elseif (Char.ItemNum(player, Agni_itemId)==0 and Char.ItemNum(player, Aqua_itemId)==0 and Char.ItemNum(player, Ventus_itemId)==0 and Char.ItemNum(player, Terra_itemId)==1) then
          local itemIndex = Char.HaveItem(player, Terra_itemId);
          local sitting_image= Item.GetData(itemIndex,CONST.����_����);
          local imageText = "@g,"..sitting_image..",15,7,6,0@"
          msg = imageText .. msg;
      else
          msg = msg;
      end
      NLG.ShowWindowTalked(player, self.speedNpc, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 1, msg);
end
]]
-------------------------------------------------------------------------------------------------------------------------------------
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
--[[
  --�Ƅ��ٶ�
  self.speedNpc = self:NPC_createNormal('�ٶȿ��', 98972, { x = 37, y = 37, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.speedNpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "\\n�����ƄӼ��١��ռ��Ļ�֮�񏊻���ľ��`֮�꣡\\n\\n��Lv1��110������Lv6��180�����������T�����\\n��Lv2��120������Lv7��200��\\n��Lv3��130������Lv8��220��\\n��Lv4��140������Lv9��250��\\n��Lv5��160������Lv10��300��\\n";
      if (Char.ItemNum(player, Agni_itemId)==0 and Char.ItemNum(player, Aqua_itemId)==1 and Char.ItemNum(player, Ventus_itemId)==0 and Char.ItemNum(player, Terra_itemId)==0) then
          local itemIndex = Char.HaveItem(player, Aqua_itemId);
          local sitting_image= Item.GetData(itemIndex,CONST.����_����);
          local imageText = "@g,"..sitting_image..",15,7,6,0@"
          msg = imageText .. msg;
      elseif (Char.ItemNum(player, Agni_itemId)==1 and Char.ItemNum(player, Aqua_itemId)==0 and Char.ItemNum(player, Ventus_itemId)==0 and Char.ItemNum(player, Terra_itemId)==0) then
          local itemIndex = Char.HaveItem(player, Agni_itemId);
          local sitting_image= Item.GetData(itemIndex,CONST.����_����);
          local imageText = "@g,"..sitting_image..",15,7,6,0@"
          msg = imageText .. msg;
      elseif (Char.ItemNum(player, Agni_itemId)==0 and Char.ItemNum(player, Aqua_itemId)==0 and Char.ItemNum(player, Ventus_itemId)==1 and Char.ItemNum(player, Terra_itemId)==0) then
          local itemIndex = Char.HaveItem(player, Ventus_itemId);
          local sitting_image= Item.GetData(itemIndex,CONST.����_����);
          local imageText = "@g,"..sitting_image..",15,7,6,0@"
          msg = imageText .. msg;
      elseif (Char.ItemNum(player, Agni_itemId)==0 and Char.ItemNum(player, Aqua_itemId)==0 and Char.ItemNum(player, Ventus_itemId)==0 and Char.ItemNum(player, Terra_itemId)==1) then
          local itemIndex = Char.HaveItem(player, Terra_itemId);
          local sitting_image= Item.GetData(itemIndex,CONST.����_����);
          local imageText = "@g,"..sitting_image..",15,7,6,0@"
          msg = imageText .. msg;
      else
          msg = msg;
      end
      NLG.ShowWindowTalked(player, self.speedNpc, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 1, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.speedNpc, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.����_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select > 0 then
      if seqno == 1 and select == CONST.��ť_ȷ�� then
          if (Char.ItemNum(player, Agni_itemId)==0 and Char.ItemNum(player, Aqua_itemId)==1 and Char.ItemNum(player, Ventus_itemId)==0 and Char.ItemNum(player, Terra_itemId)==0) then
                itemIndex = Char.HaveItem(player, Aqua_itemId);
                local level = Item.GetData(itemIndex,CONST.����_�ȼ�);
                Char.SetData(player, CONST.����_����, WingSpeed_List[level]);
                Char.SetTempData(player, 'MountOn',1);
                NLG.UpChar(player)
                --NLG.SetHeadIcon(player, WingKind_List[Aqua_itemId][level]);
          elseif (Char.ItemNum(player, Agni_itemId)==1 and Char.ItemNum(player, Aqua_itemId)==0 and Char.ItemNum(player, Ventus_itemId)==0 and Char.ItemNum(player, Terra_itemId)==0) then
                itemIndex = Char.HaveItem(player, Agni_itemId);
                local level = Item.GetData(itemIndex,CONST.����_�ȼ�);
                Char.SetData(player, CONST.����_����, WingSpeed_List[level]);
                Char.SetTempData(player, 'MountOn',1);
                NLG.UpChar(player)
                --NLG.SetHeadIcon(player, WingKind_List[Agni_itemId][level]);
          elseif (Char.ItemNum(player, Agni_itemId)==0 and Char.ItemNum(player, Aqua_itemId)==0 and Char.ItemNum(player, Ventus_itemId)==1 and Char.ItemNum(player, Terra_itemId)==0) then
                itemIndex = Char.HaveItem(player, Ventus_itemId);
                local level = Item.GetData(itemIndex,CONST.����_�ȼ�);
                Char.SetData(player, CONST.����_����, WingSpeed_List[level]);
                Char.SetTempData(player, 'MountOn',1);
                NLG.UpChar(player)
                --NLG.SetHeadIcon(player, WingKind_List[Ventus_itemId][level]);
          elseif (Char.ItemNum(player, Agni_itemId)==0 and Char.ItemNum(player, Aqua_itemId)==0 and Char.ItemNum(player, Ventus_itemId)==0 and Char.ItemNum(player, Terra_itemId)==1) then
                itemIndex = Char.HaveItem(player, Terra_itemId);
                local level = Item.GetData(itemIndex,CONST.����_�ȼ�);
                Char.SetData(player, CONST.����_����, WingSpeed_List[level]);
                Char.SetTempData(player, 'MountOn',1);
                NLG.UpChar(player)
                --NLG.SetHeadIcon(player, WingKind_List[Terra_itemId][level]);
          else
                Char.SetData(player, CONST.����_����,100);
                NLG.UpChar(player)
          end
      elseif seqno == 1 and select == CONST.��ť_�ر� then
                Char.SetData(player, CONST.����_����,100);
                Char.SetTempData(player, 'MountOn',0);
                NLG.UpChar(player)
      end
      --����
      if (itemIndex~=nil) then
          local sitting_image = Item.GetData(itemIndex,CONST.����_����);
          local MountOn = Char.GetTempData(player, 'MountOn') or -1;
          if (sitting_image>0 and MountOn>=1) then
              local MapId = Char.GetData(player,CONST.����_��ͼ����);
              local FloorId = Char.GetData(player,CONST.����_��ͼ);
              local X = Char.GetData(player,CONST.����_X);
              local Y = Char.GetData(player,CONST.����_Y);
              local objNum,objTbl = Obj.GetObject(MapId, FloorId, X, Y);
              --print(objNum,objTbl)
              players = NLG.GetPlayer();
              for k, v in ipairs(objTbl) do
                    local playerIndex = Obj.GetCharIndex(v)
                    local sittingIndex = tonumber(playerIndex)+1;
                    --print(playerIndex,sittingIndex,objTbl[1])
                    if (Obj.GetType(v)==1) then	---1���Ƿ� | 0��δʹ�� | 1����ɫ | 2������ | 3����� | 4�����͵� | 5���� | 6���ؾ�
                        --Protocol.Send(v,'NI',from10to62(objTbl[1])..'|'..x..'|'..y..'|70|0|101001|650|-1')	--���1 70
                        Protocol.Send(playerIndex,'NI',from10to62(objTbl[1])..'|'..X..'|'..Y..'|70|'..sittingIndex..'|'..sitting_image..'|650|-1')
                        for k, v in ipairs(players) do
                            local names = Char.GetData(v,CONST.����_ԭ��) or -1;
                            local maps = Char.GetData(v,CONST.����_��ͼ) or -1;
                            if names~=-1 and maps==FloorId then 
                                 Protocol.Send(v,'NI',from10to62(objTbl[1])..'|'..X..'|'..Y..'|70|'..sittingIndex..'|'..sitting_image..'|650|-1')
                            end
                        end
                    end
              end
          end
      else
      end
    end
  end)
]]

  --���T������NPC
  self:regCallback('ItemString', Func.bind(self.sittingCard, self),"LUA_useMount");
  self.setupMountNPC = self:NPC_createNormal('���T����', 14682, { x =34 , y = 31, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.setupMountNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local ElvesIndex = Char.GetItemIndex(player,8);		--��Ʒ�ڵ�һ��
      if (ElvesIndex>0) then
        ElvesId = Item.GetData(ElvesIndex,CONST.����_ID);	--���`֮��id
      else
        return;
      end
      if (ElvesId==70196 or ElvesId==70197 or ElvesId==70198 or ElvesId==70199) then
        sittingId = Item.GetData(ElvesIndex,CONST.����_����);	--���`֮��(���T����)
      else
        return;
      end
      if (sittingId==0) then
        local msg = "@c�����T�{�C��\\n"
                 .. "\\n\\n\\n �_��ʹ�ô����T���󿨆᣿\\n\\n"
        NLG.ShowWindowTalked(player, self.setupMountNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 1, msg);
      elseif (sittingId>0) then
        local msg = "@c�����T�{�C��\\n"
                 .. "\\n\\n\\n �_�����w�F�е����T����᣿\\n\\n"
        NLG.ShowWindowTalked(player, self.setupMountNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 2, msg);
      else
      end
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.setupMountNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local MountIndex = MountIndex;
    local MountSlot = MountSlot;
    local MountId = Item.GetData(MountIndex,CONST.����_ID);	--���T��
    local MountName = Item.GetData(MountIndex,CONST.����_����);	--���T����
    local ElvesIndex = Char.GetItemIndex(player,8);		--��Ʒ�ڵ�һ��

    --���T������
    if select > 0 then
      if seqno == 1 and select == CONST.��ť_�� then
                 return;
      elseif seqno == 2 and select == CONST.��ť_�� then
                 return;
      elseif seqno == 1 and select == CONST.��ť_�� then
        if (ElvesIndex>0) then
          local ElvesId = Item.GetData(ElvesIndex,CONST.����_ID);	--���`֮��id
          if (ElvesId==70196 or ElvesId==70197 or ElvesId==70198 or ElvesId==70199) then
              if ( CheckInTable(MountEnable_check, MountId)==true ) then
                  Char.DelItem(player, MountId, 1);
                  setItemStrData(ElvesIndex, sittingCards[MountId])
                  Item.SetData(ElvesIndex,CONST.����_����,sittingImages[MountId]);
                  Item.UpItem(player,8);
                  NLG.UpChar(player);
                  NLG.PlaySe(player, 212, Char.GetData(player,CONST.����_X), Char.GetData(player,CONST.����_Y));
                  NLG.SystemMessage(player, "[ϵͳ]"..MountName.." �ɹ���ꑡ�")
              else
              end
          else
              NLG.SystemMessage(player,"[ϵ�y]��Ʒ�ڵ�һ��δ�о��`֮�ꡣ");
              return;
          end
        else
            return;
        end
      elseif seqno == 2 and select == CONST.��ť_�� then
        if (ElvesIndex>0) then
          local ElvesId = Item.GetData(ElvesIndex,CONST.����_ID);		--���`֮��id
          local sittingId = tonumber(Item.GetData(ElvesIndex,CONST.����_����));		--���`֮��(���T����)
          --print(sittingId,sittingImages[MountId])
          if (sittingId==sittingImages[MountId]) then
              NLG.SystemMessage(player,"[ϵ�y]�����������ѵ��ʹ�á�");
              return;
          end
          if (ElvesId==70196 or ElvesId==70197 or ElvesId==70198 or ElvesId==70199) then
              if ( CheckInTable(MountEnable_check, MountId)==true ) then
                  Char.DelItem(player, MountId, 1);
                  for k,v in pairs(sittingCards) do
                    if (sittingImages[k]==sittingId) then
                      setItemRevertData(ElvesIndex, sittingCards[k])	--���Ƴ�
                    end
                  end
                  Item.UpItem(player,8);
                  NLG.UpChar(player);
                  setItemStrData(ElvesIndex, sittingCards[MountId])			--���ؼ�
                  Item.SetData(ElvesIndex,CONST.����_����,sittingImages[MountId]);
                  Item.UpItem(player,8);
                  NLG.UpChar(player);
                  NLG.PlaySe(player, 212, Char.GetData(player,CONST.����_X), Char.GetData(player,CONST.����_Y));
                  NLG.SystemMessage(player, "[ϵͳ]"..MountName.." �ɹ���ꑡ�")
              else
              end
          else
              NLG.SystemMessage(player,"[ϵ�y]��Ʒ�ڵ�һ��δ�о��`֮�ꡣ");
              return;
          end
        else
            return;
        end
      else
          return;
      end

    else
    end
  end)


end

--���T��
function Module:sittingCard(charIndex,targetIndex,itemSlot)
    --ItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    MountSlot = itemSlot;
    MountIndex = Char.GetItemIndex(charIndex,itemSlot);
    local MountId = Item.GetData(MountIndex,CONST.����_ID);	--���T��
    local ElvesIndex = Char.GetItemIndex(charIndex,8);		--��Ʒ�ڵ�һ��
    if (ElvesIndex>0) then
      ElvesId = Item.GetData(ElvesIndex,CONST.����_ID);	--���`֮��id
    else
      NLG.SystemMessage(charIndex,"[ϵ�y]��Ʒ�ڵ�һ��δ�о��`֮�ꡣ");
      return 1;
    end
    if (ElvesId==70196 or ElvesId==70197 or ElvesId==70198 or ElvesId==70199) then
      sittingId = Item.GetData(ElvesIndex,CONST.����_����);	--���`֮��(���T����)
    else
      NLG.SystemMessage(charIndex,"[ϵ�y]��Ʒ�ڵ�һ��δ�о��`֮�ꡣ");
      return 1;
    end
    if (sittingId==0) then
        local msg = "@c�����T�{�C��\\n"
                 .. "\\n\\n\\n �_��ʹ�ô����T���󿨆᣿\\n\\n"
        NLG.ShowWindowTalked(charIndex, self.setupMountNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 1, msg);
    elseif (sittingId>0) then
        local msg = "@c�����T�{�C��\\n"
                 .. "\\n\\n\\n �_�����w�F�е����T����᣿\\n\\n"
        NLG.ShowWindowTalked(charIndex, self.setupMountNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 2, msg);
    else
    end
    return 1;
end
------------------------------------------------------------------------------------------
--��������
function setItemStrData( _ItemIndex, _Card)
	local Plus_buffer = {}
	local tItemStat = tostring( _Card);
	if (string.find(tItemStat, "|")==nil) then
		return;
	else
		local strData = {18, 19, 20, 21, 22, 27, 28}	--%����_����%,%����_����%,%����_����%,%����_����%,%����_�ظ�%,%����_HP%,%����_MP%
		local Plus_buffer = string.split(tItemStat, "|");

		for k,v in pairs(strData) do
			Item.SetData(_ItemIndex, strData[k], Item.GetData(_ItemIndex, strData[k]) + tonumber(Plus_buffer[k]));
		end
	end
end

--��ԭ����
function setItemRevertData( _ItemIndex, _Card)
	local Plus_buffer = {}
	local tItemStat = tostring( _Card);
	if (string.find(tItemStat, "|")==nil) then
		return;
	else
		local strData = {18, 19, 20, 21, 22, 27, 28}	--%����_����%,%����_����%,%����_����%,%����_����%,%����_�ظ�%,%����_HP%,%����_MP%
		local Plus_buffer = string.split(tItemStat, "|");

		for k,v in pairs(strData) do
			Item.SetData(_ItemIndex, strData[k], Item.GetData(_ItemIndex, strData[k]) - tonumber(Plus_buffer[k]));
		end
	end
end

function CheckInTable(_idTab, _idVar) ---ѭ������
	for k,v in pairs(_idTab) do
		if v==_idVar then
			return true
		end
	end
	return false
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
