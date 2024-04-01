---ģ����
local Module = ModuleBase:createModule('mazeHorcrux')

local worldHorcrux = {
  { "[����һ�����", 70258, 301, 119010 },
  { "[���ڶ������", 70260, 302, 119022 },
  { "[���������ŭ", 70262, 303, 119020 },
  { "[�����������", 70264, 304, 119018 },
  { "[�������؝��", 70266, 305, 119021 },
  { "[���������ʳ", 70267, 306, 119019 },
  { "[�������ɫ�j", 70270, 307, 119011 },
}

--- ҳ������
local function calcWarp()
  local totalpage = math.modf(#worldHorcrux / 6) + 1
  local remainder = math.fmod(#worldHorcrux, 6)
  return totalpage, remainder
end

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('LoginEvent', Func.bind(self.onLoginEvent, self));
  self:regCallback('LogoutEvent', Func.bind(self.onLogoutEvent, self));
  self:regCallback('DropEvent', Func.bind(self.LogoutEvent, self));

  local HorcruxNPC = self:NPC_createNormal('����������b', 104840, { map = 1000, x = 241, y = 70, direction = 0, mapType = 0 })
  self:NPC_regWindowTalkedEvent(HorcruxNPC, function(npc, player, _seqno, _select, _data)
    local column = tonumber(_data)
    local page = tonumber(_seqno)
    local warpPage = page;
    local winMsg = "3\\n@c�x�������Ļ���ȡ�����＼��\\n"
                           .."\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n";
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
          winButton = CONST.BUTTON_��ȡ��
        end
      elseif _select == 2 then
        warpPage = 1
        return
      end
      local count = 6 * (warpPage - 1)
      if warpPage == totalPage then
        for i = 1 + count, remainder + count do
          local flagEvent = Char.EndEvent(player,worldHorcrux[i][1]);
          if (flagEvent == 1) then
              winMsg = winMsg .. worldHorcrux[i][1] .. "�������ц���]\\n"
          else
              winMsg = winMsg .. worldHorcrux[i][1] .. "������δ����]\\n"
          end
        end
      else
        for i = 1 + count, 6 + count do
          local flagEvent = Char.EndEvent(player,worldHorcrux[i][1]);
          if (flagEvent == 1) then
              winMsg = winMsg .. worldHorcrux[i][1] .. "�������ц���]\\n"
          else
              winMsg = winMsg .. worldHorcrux[i][1] .. "������δ����]\\n"
          end
        end
      end
      NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, winButton, warpPage, winMsg);
    else
      local count = 6 * (warpPage - 1) + column
      local short = worldHorcrux[count]
      local flagEvent = Char.EndEvent(player, short[3]);
      if (flagEvent == 1) then
          NLG.SetHeadIcon(player, short[4]);
          Char.SetExtData(player, "Saligia", short[4]);
      else
          NLG.SystemMessage(player,"[ϵ�y]��δ������ߴ����������");
          return;
      end
    end
  end)
  self:NPC_regTalkedEvent(HorcruxNPC, function(npc, player)
    local cdk = Char.GetData(player,CONST.����_CDK);
    if (NLG.CanTalk(npc, player) == true) then
      local winCase = CONST.����_ѡ���
      local winButton = CONST.BUTTON_�ر�;
      local msg = "3\\n@c�x�������Ļ���ȡ�����＼��\\n"
                           .."\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n";
      for i = 1,7 do
        local flagEvent = Char.EndEvent(player,worldHorcrux[i][3]);
        if (flagEvent == 1) then
            msg = msg .. worldHorcrux[i][1] .. "�������ц���]\\n"
        else
            msg = msg .. worldHorcrux[i][1] .. "������δ����]\\n"
        end
      end
      NLG.ShowWindowTalked(player, npc, winCase, winButton, 1, msg);
    end
    return
  end)

end


function Module:onLogoutEvent(player)
  local IconId = Char.GetExtData(player, "Saligia") or 0;
  --print(IconId)
end

function Module:onLoginEvent(player)
  local IconId = Char.GetExtData(player, "Saligia") or 0;
  if IconId > 0 then
     NLG.SetHeadIcon(player, IconId);
  end
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
