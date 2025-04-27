---ģ����
local Module = ModuleBase:createModule('digitalGate')


--��������
local Pts= 70075;		--70206��Ů��ƻ��.70075�����
------------------------------------------------
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  --�����ŵ���
  self:regCallback('ItemString', Func.bind(self.digitalTravel, self),"LUA_useDigiTrip");
  DigitalGateNPC = self:NPC_createNormal('���a����', 103013, { x = 42, y = 31, mapType = 0, map = 777, direction = 6 });
  Char.SetData(DigitalGateNPC,CONST.����_ENEMY_PetFlg+2,0)--�ɴ�͸��
  self:NPC_regTalkedEvent(DigitalGateNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
                local msg = "\\n\\n@c��ϵ�y֪ͨ��"
                  .."\\n\\n"
                  .."\\nδ֪�Ă����T���F\\n"
                  .."\\n�Ƿ��M�딵�a���磿\\n";
        NLG.ShowWindowTalked(player, DigitalGateNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 1, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(DigitalGateNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local ComIndex =ComIndex;
    local ComSlot = ComSlot;
    local Target_FloorId = Char.GetData(player,CONST.����_��ͼ)--��ͼ���
    local Target_X = Char.GetData(player,CONST.����_X)--��ͼx
    local Target_Y = Char.GetData(player,CONST.����_Y)--��ͼy
    --local playerLv = Char.GetData(player,CONST.����_�ȼ�);
    local playerLv = calcTeamLevel(player);
    if select > 0 then
      if seqno == 1 and select == CONST.��ť_�� then
          Char.SetData(npc,CONST.����_X, 42);
          Char.SetData(npc,CONST.����_Y, 31);
          Char.SetData(npc,CONST.����_��ͼ, 777);
          NLG.UpChar(npc); 
          return;
      elseif seqno == 1 and select == CONST.��ť_�� then
          if (Char.ItemNum(player, 75030)<=0) then
              NLG.SystemMessage(player,"[ϵ�y]��]���M���Y��");
              return;
          end
          if (playerLv>=1 and playerLv<=49) then
              Char.Warp(player,0, 25009, 78, 19);
              Char.DelItem(player, 75030, 1);
              NLG.SystemMessage(player, "[ϵͳ]�M�딵�a���硣")
          elseif (playerLv>=50 and playerLv<=100) then
              Char.Warp(player,0, 25009, 48, 19);
              Char.DelItem(player, 75030, 1);
              NLG.SystemMessage(player, "[ϵͳ]�M�딵�a���硣")
          elseif (playerLv>=101) then
              Char.Warp(player,0, 25009, 18, 19);
              Char.DelItem(player, 75030, 1);
              NLG.SystemMessage(player, "[ϵͳ]�M�딵�a���硣")
          end
          Char.SetData(npc,CONST.����_X, 42);
          Char.SetData(npc,CONST.����_Y, 31);
          Char.SetData(npc,CONST.����_��ͼ, 777);
          NLG.UpChar(npc); 
      else
          return;
      end
    end
  end)

end
------------------------------------------------
----
function Module:digitalTravel(charIndex,targetIndex,itemSlot)
    ComItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    ComSlot =itemSlot;
    ComIndex = Char.GetItemIndex(charIndex,itemSlot);
    local Target_FloorId = Char.GetData(charIndex,CONST.����_��ͼ);
	local Target_X = Char.GetData(charIndex,CONST.����_X);
	local Target_Y = Char.GetData(charIndex,CONST.����_Y);
	local warpX = NLG.Rand(Target_X-5, Target_X+5);
	local warpY = NLG.Rand(Target_Y-5, Target_Y+5);
	if (Target_FloorId~=25009) then
	  Char.SetData(DigitalGateNPC,CONST.����_X, warpX);
	  Char.SetData(DigitalGateNPC,CONST.����_Y, warpY);
	  Char.SetData(DigitalGateNPC,CONST.����_��ͼ, Target_FloorId);
	  NLG.UpChar(DigitalGateNPC);
      Char.Warp(charIndex,0, Target_FloorId, Target_X, Target_Y);
	  NLG.SystemMessage(charIndex,"[ϵ�y]δ֪�Ă����T���F�ڸ���("..warpX..","..warpY..")");
    else
      NLG.SystemMessage(charIndex,"[ϵ�y]���a�����Пo�����_�����T");
      return 1;
	end
--[[
                local msg = "\\n\\n@c��ϵ�y֪ͨ��"
                  .."\\n\\n"
                  .."\\nδ֪�Ă����T���F\\n"
                  .."\\n�Ƿ��M�딵�a���磿\\n";
    NLG.ShowWindowTalked(charIndex, DigitalGateNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 1, msg);
]]
    return 1;
end

function calcTeamLevel(player)
	local m = 0;
	local k = 0;
	for slot = 0,4 do
		local p = Char.GetPartyMember(player,slot);
		if (p>=0) then
			m = m + Char.GetData(p,CONST.����_�ȼ�);
			k = k+1;
		end
	end
	--����ƽ���ȼ����ȵ�
	local lv = math.floor(m/k);
	return lv;
end

function heads(CoinNo)
	local h,r,s = 0,0,0;
	local result_tbl = {};
	for i=1,CoinNo do
		local result = NLG.Rand(0,1);
		table.insert(result_tbl,result);
	end
	for k,v in pairs(result_tbl) do
		if (v==1) then
			h = h + 1;
		elseif (v==0) then
			r = r + 1;
		end
	end
	if (h==#result_tbl or r==#result_tbl) then
		s = 1;
	end
	return h,r,s
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;