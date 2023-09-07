local QuickUI = ModuleBase:createModule('quickUI')

function QuickUI:shortcut(player, actionID)
  if actionID == %����_�ܲ�% then
    self:walkingspeed(self.speedNpc,player);
  elseif actionID == %����_����% then
    self:teamfever(self.feverNpc,player);
  end
end

function QuickUI:walkingspeed(npc, player)
      local msg = "\\n\\n@c���ƄӼ��١�����΄��������������·�ٶȣ�\\n\\n1.���m�ن�ʿ�wƝ[���߽�ָ]��120��\\n\\n2.Ů���B[����֮��]��140��\\n";
      NLG.ShowWindowTalked(player, self.speedNpc, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 1, msg);
end

function QuickUI:teamfever(npc, player)
      local msg = "\\n\\n@c��һ�Iȫ꠴򿨡�\\n\\n�Ǵ򿨠�B���򿨠�B\\n\\n�򿨠�B���Ǵ򿨠�B\\n\\n[�_��]��ȫ��M�д򿨡�ȫ꠵Ĵ򿨽Y��\\n";
      NLG.ShowWindowTalked(player, self.feverNpc, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 2, msg);
end

function QuickUI:onLoad()
  self:logInfo('load');
  self:regCallback('CharActionEvent', Func.bind(self.shortcut, self))
  self.quickUINpc = self:NPC_createNormal('�������ͼʾ', 98972, { x = 36, y = 37, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.quickUINpc, Func.bind(self.shortcut, self))
  self:NPC_regWindowTalkedEvent(self.quickUINpc, Func.bind(self.shortcut, self))

  --�Ƅ��ٶ�
  self.speedNpc = self:NPC_createNormal('�ٶȿ��', 98972, { x = 37, y = 37, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.speedNpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "\\n\\n@c���ƄӼ��١�����΄��������������·�ٶȣ�\\n\\n1.���m�ن�ʿ�wƝ[���߽�ָ]��120��\\n\\n2.Ů���B[����֮��]��140��\\n";
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
            if Char.EndEvent(player,0) == 1 then
                local charPtr = Char.GetCharPointer(player)
                ffi.setMemoryInt32(charPtr + 0x5e8 + 0x188 + 0x18, 120);   --walkSpeed
                NLG.SetHeadIcon(player,114206);
                NLG.UpChar(player)
            end
            if Char.EndEvent(player,21) == 1 then
                local charPtr = Char.GetCharPointer(player)
                ffi.setMemoryInt32(charPtr + 0x5e8 + 0x188 + 0x18, 140);   --walkSpeed
                NLG.SetHeadIcon(player,114177);
                NLG.UpChar(player)
            end
      elseif seqno == 1 and select == CONST.��ť_�ر� then
                local charPtr = Char.GetCharPointer(player)
                ffi.setMemoryInt32(charPtr + 0x5e8 + 0x188 + 0x18, 100);   --walkSpeed
                NLG.SetHeadIcon(player,1);
                NLG.UpChar(player)
      end
    end
  end)
  --ȫ꠴�
  self.feverNpc = self:NPC_createNormal('�򿨿��', 98972, { x = 38, y = 37, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.feverNpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "\\n\\n@c��һ�Iȫ꠴򿨡�\\n\\n�Ǵ򿨠�B���򿨠�B\\n\\n�򿨠�B���Ǵ򿨠�B\\n\\n[�_��]��ȫ��M�д򿨡�ȫ꠵Ĵ򿨽Y��\\n";
      NLG.ShowWindowTalked(player, self.feverNpc, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 2, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.feverNpc, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.����_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select > 0 then
      if seqno == 2 and select == CONST.��ť_ȷ�� then
        for slot = 0,4 do
          local p = Char.GetPartyMember(player,slot)
          if(p>=0) then
                local daka = Char.GetData(p, 4008);
                local name = Char.GetData(p,CONST.CHAR_����);
                if daka == 1 then
                      Char.FeverStop(p);
                      NLG.UpChar(p);
                      NLG.SystemMessage(player, name.."�P�]�򿨡�");
                end
                if daka == 0 then
                      if Char.IsDummy(p) then
                          Char.SetData(p, CONST.CHAR_��ʱ, 24 * 3600);
                      end
                      Char.FeverStart(p);
                      NLG.UpChar(p);
                      NLG.SystemMessage(player, name.."�򿨳ɹ���");
                end
          else
                NLG.SystemMessage(player, "�Mꠠ�B�����ô�ȫ꠴򿨡�");
                return
          end
        end
      end
    end
  end)

end

function QuickUI:onUnload()
  self:logInfo('unload')
end

return QuickUI;
