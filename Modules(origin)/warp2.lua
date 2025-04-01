local Warp = ModuleBase:createModule('warp2')

--��������������������
local warpPoints = {
  { "�`��-Lv10", 0, 1538, 15, 18, 100 },
  { "�ﶴ-Lv20", 0, 32511, 24, 15, 500 },
  { "������-Lv25", 0, 32505, 9, 8, 500 },
  { "����-Lv25", 0, 59503, 72, 161, 500 },
  { "ѩɽ-Lv35", 0, 402, 84, 193, 1000 },
  { "�׶�-Lv40", 0, 15595, 3, 14, 1000 },
  { "�}�t��-Lv45", 0, 24044, 22, 5, 2000 },
  { "ѩ��50F", 0, 59850, 77, 59, 2000 },
  { "����-Lv55", 0, 32046, 63, 241, 1500 },
  { "ˮ��-Lv60", 0, 15542, 16, 25, 1500 },
  { "ѩ��70F", 0, 59870, 77, 55, 1500 },
  { "�M�^���LѨ", 0, 59670, 177, 135, 2500 },
  { "�h���D�̳�", 0, 32205, 125, 133, 4000 },
  { "ѩ��80F", 0, 59880, 162, 123, 3000 },
  { "�S��^-Lv80", 0, 32201, 169, 90, 4000 },
  { "ѩ��90F", 0, 59890, 61, 40, 3000 },
  { "����^-Lv90", 0, 32201, 190, 207, 4000 },
  { "���~ԭ-Lv100", 0, 32217, 55, 41, 3500 },
  { "���~�-Lv140", 0, 32215, 36, 19, 3500 },

}

local function calcWarp()
  local page = math.modf(#warpPoints / 8) + 1
  local remainder = math.fmod(#warpPoints, 8)
  return page, remainder
end

function Warp:onLoad()
  self:logInfo('load');
  local warpNPC = self:NPC_createNormal('���Ȃ���', 103010, { x = 246, y = 85, mapType = 0, map = 1000, direction = 0 });
  Char.SetData(warpNPC,CONST.����_ENEMY_PetFlg+2,0)--�ɴ�͸��
  self:NPC_regWindowTalkedEvent(warpNPC, function(npc, player, _seqno, _select, _data)
    local column = tonumber(_data)
    local page = tonumber(_seqno)
    local warpPage = page;
    local winMsg = "1\\n���������������ق������������^�����M���D��\\n"
    local winButton = CONST.BUTTON_�ر�;
    local totalPage, remainder = calcWarp()
    --��ҳ16 ��ҳ32 �ر�/ȡ��2
    if _select > 0 then
      if _select == CONST.BUTTON_��һҳ then
        warpPage = warpPage + 1
        if (warpPage == totalPage) or ((warpPage == (totalPage - 1) and remainder == 0)) then
          winButton = CONST.BUTTON_��ȡ��
        else
          winButton = CONST.BUTTON_����ȡ��
        end
      elseif _select == CONST.BUTTON_��һҳ then
        warpPage = warpPage - 1
        if warpPage == 1 then
          winButton = CONST.BUTTON_��ȡ��
        else
          winButton = CONST.BUTTON_����ȡ��
        end
      elseif _select == 2 then
        warpPage = 1
        return
      end
      local count = 8 * (warpPage - 1)
      if warpPage == totalPage then
        for i = 1 + count, remainder + count do
          --�����ʽ
          local name_len = #warpPoints[i][1];
          if (name_len < 12) then
              name_spacelen = 12 - name_len;
              name_spaceMsg = " ";
              for k = 1, math.modf(name_spacelen) do
                  name_spaceMsg = name_spaceMsg .." ";
              end
          else
              name_spaceMsg = " ";
          end
          winMsg = winMsg .. warpPoints[i][1] .. name_spaceMsg .. "  �����ÿ�˂����M: ".. warpPoints[i][6] .."\\n"
        end
      else
        for i = 1 + count, 8 + count do
          --�����ʽ
          local name_len = #warpPoints[i][1];
          if (name_len < 12) then
              name_spacelen = 12 - name_len;
              name_spaceMsg = " ";
              for k = 1, math.modf(name_spacelen) do
                  name_spaceMsg = name_spaceMsg .." ";
              end
          else
              name_spaceMsg = " ";
          end
          winMsg = winMsg .. warpPoints[i][1] .. name_spaceMsg .. "  �����ÿ�˂����M: ".. warpPoints[i][6] .."\\n"
        end
      end
      NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, winButton, warpPage, winMsg);
    else
      local count = 8 * (warpPage - 1) + column
      local short = warpPoints[count]
      local PartyNum = Char.PartyNum(player);
      if (PartyNum>0 and Char.GetData(player,CONST.����_���) >= short[6]*PartyNum) then
        local fee = short[6]*PartyNum;
		Char.SetData(player,CONST.����_���, Char.GetData(player,CONST.����_���) - fee);
		NLG.UpChar(player);
		NLG.SystemMessage(player,"��L������"..fee.."��");
        Char.Warp(player, short[2], short[3], short[4], short[5])
      elseif (PartyNum>0 and Char.GetData(player,CONST.����_���) < short[6]*PartyNum) then
		NLG.SystemMessage(player,"����֧��ȫꠂ����M�ã�Ո��ɢ��顣");
      elseif (Char.GetData(player,CONST.����_���) >= short[6]) then
		Char.SetData(player,CONST.����_���, Char.GetData(player,CONST.����_���) - short[6]);
		NLG.UpChar(player);
        Char.Warp(player, short[2], short[3], short[4], short[5])
      elseif (Char.GetData(player,CONST.����_���) < short[6]) then
		NLG.SystemMessage(player,"�����M�ò��㡣");
      end
    end
  end)
  self:NPC_regTalkedEvent(warpNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "1\\n���������������ق������������^�����M���D��\\n";
      for i = 1, 8 do
        --�����ʽ
        local name_len = #warpPoints[i][1];
        if (name_len < 12) then
            name_spacelen = 12 - name_len;
            name_spaceMsg = " ";
            for k = 1, math.modf(name_spacelen) do
                name_spaceMsg = name_spaceMsg .." ";
            end
        else
            name_spaceMsg = " ";
        end
        msg = msg .. warpPoints[i][1] .. name_spaceMsg .. "  �����ÿ�˂����M: ".. warpPoints[i][6] .."\\n"
      end
      NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.BUTTON_��ȡ��, 1, msg);
    end
    return
  end)
end

function Warp:onUnload()
  self:logInfo('unload')
end

return Warp;
