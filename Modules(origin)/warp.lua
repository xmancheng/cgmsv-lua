local Warp = ModuleBase:createModule('warp')

--��������������������
local warpPoints = {
  { "�}��������", 0, 100, 134, 218, 1000 },
  { "������", 0, 100, 681, 343, 1000 },
  { "�����ش�", 0, 100, 587, 51, 1000 },
  { "�S�Z����", 0, 100, 330, 480, 1000 },
  { "������", 0, 300, 273, 294, 1000 },
  { "�Ӽ{��", 0, 300, 702, 147, 1000 },
  { "���Z���", 0, 400, 217, 455, 1000 },
  { "���ȴ�", 0, 400, 570, 274, 1000 },
  { "������˹��", 0, 402, 183, 164, 1000 },
  { "���P������", 0, 33200, 99, 165, 1000 },
  { "����ؐ����", 0, 33500, 17, 76, 1000 },
  { "�������", 0, 43100, 120, 107, 1000 },
  { "������˹��", 0, 43000, 322, 883, 1000 },
  { "���Z������", 0, 43000, 431, 823, 1000 },
  { "�׿������", 0, 43000, 556, 313, 1000 },
  { "���Z����", 0, 30010, 150, 123, 1000 },
  { "��S������", 0, 30001, 600, 470, 1000 },
  { "�ךW�ȴ�", 0, 30014, 60, 52, 1000 },
  { "�����", 0, 30012, 32, 55, 1000 },
  { "Ħ�D��", 0, 30013, 92, 42, 1000 },
  { "�_���_��", 0, 32034, 19, 65, 1000 },
  { "���R������", 0, 57452, 64, 72, 1000 },
  { "����ɯ�³�", 0, 59520, 143, 108, 1000 },
  { "��÷��", 0, 59519, 26, 17, 1000 },
  { "�h���D��", 0, 32205, 127, 138, 1000 },
  { "���o��", 0, 32277, 33, 56, 1000 },
  { "��֮·", 0, 59505, 165, 83, 1000 },
  { "ѩ���", 0, 59906, 103, 21, 1000 },
}

local function calcWarp()
  local page = math.modf(#warpPoints / 8) + 1
  local remainder = math.fmod(#warpPoints, 8)
  return page, remainder
end

function Warp:onLoad()
  self:logInfo('load');
  local warpNPC = self:NPC_createNormal('���f����', 103010, { x = 246, y = 91, mapType = 0, map = 1000, direction = 0 });
  Char.SetData(warpNPC,CONST.����_ENEMY_PetFlg+2,0)--�ɴ�͸��
  self:NPC_regWindowTalkedEvent(warpNPC, function(npc, player, _seqno, _select, _data)
    local column = tonumber(_data)
    local page = tonumber(_seqno)
    local warpPage = page;
    local winMsg = "1\\n���������������ق����������f�����M���D��\\n"
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
      local msg = "1\\n���������������ق����������f�����M���D��\\n";
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
