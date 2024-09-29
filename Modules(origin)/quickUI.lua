local QuickUI = ModuleBase:createModule('quickUI')

local PartyMember={}

function QuickUI:shortcut(player, actionID)
  if actionID == %����_����% then
    self:petinfo(player);
  end
end

function QuickUI:walkingspeed(npc, player)
      local msg = "\\n@c���ƄӼ��١�����΄��������������·�ٶȣ�\\n\\n1.���m�ن�ʿ�wƝ[���߽�ָ]��150��\\n\\n2.Ů���B[����֮��]��200��\\n\\n3.�܂���Ů��[ɭ�_�f��]��250��\\n\\n4.ِ��÷��֮��[ʧ��֮��]��300��\\n";
      NLG.ShowWindowTalked(player, self.speedNpc, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 1, msg);
end

function QuickUI:teamfever(npc, player)
      local msg = "\\n\\n@c��һ�Iȫ꠴򿨡�\\n\\n�Ǵ򿨠�B���򿨠�B\\n\\n�򿨠�B���Ǵ򿨠�B\\n\\n[�_��]��ȫ��M�д�|ȫ꠵Ĵ򿨽Y��\\n";
      NLG.ShowWindowTalked(player, self.feverNpc, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 2, msg);
end

function QuickUI:teamheal(npc, player)
      local msg = "\\n\\n@c�؏�ħ��ֵ��+��������ֵ��\\n\\n�؏�����ֵ\\n\\n�؏͌��������ֵ��ħ��ֵ\\n\\nһ�I�؏�ȫ�����͌���ħ��������\\n";
      NLG.ShowWindowTalked(player, self.healNpc, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 3, msg);
end

function QuickUI:gather(player)
      local playerMapType = Char.GetData(player, CONST.CHAR_��ͼ����);
      local playerMap = Char.GetData(player, CONST.CHAR_��ͼ);
      local playerX = Char.GetData(player, CONST.CHAR_X);
      local playerY = Char.GetData(player, CONST.CHAR_Y);
      if Char.PartyNum(player)>0 and player==Char.GetPartyMember(player,0) then
            for slot = 1,4 do
                local p = Char.GetPartyMember(player,slot)
                if(p>=0) then
                      Char.Warp(p, playerMapType, playerMap, playerX, playerY);
                end
            end
      else
            NLG.SystemMessage(player, '��L�ſ�ʹ�ã�');
      end
end

function QuickUI:partyenter(player)
      local cdk = Char.GetData(player,CONST.����_CDK);
      local playerMapType = Char.GetData(player, CONST.CHAR_��ͼ����);
      local playerMap = Char.GetData(player, CONST.CHAR_��ͼ);
      local playerX = Char.GetData(player, CONST.CHAR_X);
      local playerY = Char.GetData(player, CONST.CHAR_Y);
      if Char.PartyNum(player)>0 and player==Char.GetPartyMember(player,0) then
             PartyMember[cdk] = {}
             for partySlot = 0,4 do 
                    local targetcharIndex = Char.GetPartyMember(player,partySlot);
                    if targetcharIndex >= 0  then
                          table.insert(PartyMember[cdk], partySlot+1, targetcharIndex);
                    else
                          table.insert(PartyMember[cdk], partySlot+1, -1);
                    end
             end
             table.insert(PartyMember[cdk],cdk);
             NLG.SystemMessage(player, '���ɆT�o��ꮅ��');
      else
            NLG.SystemMessage(player, '��L�ſ�ʹ�ã�');
      end
end

function QuickUI:partyform(player)
      local cdk = Char.GetData(player,CONST.����_CDK);
      local playerMapType = Char.GetData(player, CONST.CHAR_��ͼ����);
      local playerMap = Char.GetData(player, CONST.CHAR_��ͼ);
      local playerX = Char.GetData(player, CONST.CHAR_X);
      local playerY = Char.GetData(player, CONST.CHAR_Y);
      if PartyMember[cdk] ~= nill and cdk == PartyMember[cdk][6] then
            if Char.PartyNum(player) == -1 then
                  for i,v in ipairs(PartyMember[cdk]) do
                        local memberMap = Char.GetData(v, CONST.CHAR_��ͼ);
                        local memberX = Char.GetData(v, CONST.CHAR_X);
                        local memberY = Char.GetData(v, CONST.CHAR_Y);
                        if i<=5 and v>-1 and v~=player and memberMap == playerMap then
                              if memberX >= playerX-5 and memberX <= playerX+5 and memberY>= playerY-5 and memberY<= playerY+5 then
                                    Char.Warp(v, playerMapType, playerMap, playerX, playerY);
                                    Char.JoinParty(v, player);
                              else
                                    NLG.SystemMessage(player, '��꠆T���x�^�h���ʧ����');
                              end
                        end
                  end
            end
      else
            NLG.SystemMessage(player, 'Ո��ӛ䛻򸲌����ɆT��');
      end
end

function QuickUI:petinfo(player)
      for petSlot = 0,4 do
            local petIndex = Char.GetPet(player, petSlot);
            local petname = Char.GetData(petIndex, CONST.CHAR_����);
            local arr_rank1 = Pet.GetArtRank(petIndex,CONST.PET_���);
            local arr_rank2 = Pet.GetArtRank(petIndex,CONST.PET_����);
            local arr_rank3 = Pet.GetArtRank(petIndex,CONST.PET_ǿ��);
            local arr_rank4 = Pet.GetArtRank(petIndex,CONST.PET_����);
            local arr_rank5 = Pet.GetArtRank(petIndex,CONST.PET_ħ��);
            local a6, a1, a2, a3, a4, a5 = Char.GetPetRank(player,petSlot);
            local TrueName = Char.GetData(petIndex,CONST.����_ԭ��);
            local last = string.find(TrueName, "���N", 1) or nil;
            local a61 = arr_rank1+arr_rank2+arr_rank3+arr_rank4+arr_rank5;
            if last~=nil then
                  NLG.SystemMessage(player, '---------------------------------------');
                  NLG.SystemMessage(player, ''..TrueName..'�������ǡ�'..a61..'�����L�n��');
                  NLG.SystemMessage(player, '�w���L'..arr_rank1..' �����L'..arr_rank2..' �����L'..arr_rank3..' �ٳ��L'..arr_rank4..' ħ���L'..arr_rank5);
            elseif last==nil and a6 >= 0 then
                  NLG.SystemMessage(player, '---------------------------------------');
                  NLG.SystemMessage(player, ''..petname..'������-'..a6..'�n�Σ�');
                  NLG.SystemMessage(player, '�w'..arr_rank1..'(-'..a1..')��'..arr_rank2..'(-'..a2..')��'..arr_rank3..'(-'..a3..')��'..arr_rank4..'(-'..a4..')ħ'..arr_rank5..'(-'..a5..')');
            end
      end
      NLG.SystemMessage(player, '---------------------------------------');
end

function QuickUI:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="/book") then
		local msg = "2\\n@c�������ݹ����x��\\n"
			.."�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
			.."�����M�һ�I�򿨡�\\n"
			.."�����M�һ�I�֏͡�\\n"
			.."�������ɆT�o䛡�\\n"
			.."�������ɆT���Y��\\n"
			.."�����ɆT����һ�c��\\n"
			.."������·�ƄӼ��١�\\n"
			.."��������һ�I��n��\\n";
		NLG.ShowWindowTalked(charIndex, self.quickUInpc, CONST.����_ѡ���, CONST.��ť_�ر�, 1, msg);
		return 0;
	end
	return 1;
end

function QuickUI:onLoad()
  self:logInfo('load');
  self:regCallback('CharActionEvent', Func.bind(self.shortcut, self))
  self:regCallback('ItemString', Func.bind(self.imageCollection, self),"LUA_useMetamoCT");
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self));
  self.quickUInpc = self:NPC_createNormal('�������ͼʾ', 98972, { x = 36, y = 37, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.quickUInpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "2\\n@c�������ݹ����x��\\n"
            .."�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
            .."�����M�һ�I�򿨡�\\n"
            .."�����M�һ�I�֏͡�\\n"
            .."�������ɆT�o䛡�\\n"
            .."�������ɆT���Y��\\n"
            .."�����ɆT����һ�c��\\n"
            .."������·�ƄӼ��١�\\n"
            .."��������һ�I��n��\\n";
      NLG.ShowWindowTalked(player, self.quickUInpc, CONST.����_ѡ���, CONST.��ť_�ر�, 1, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.quickUInpc, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --print(data)
    if select > 0 then
    else
      if (seqno == 1 and select == CONST.��ť_�ر�) then
                 return;
      end
      if (seqno == 1 and data >= 1) then
          local menuSelect = data;
          if menuSelect == 1 then
            self:teamfever(self.feverNpc,player);
          elseif menuSelect == 2 then
            self:teamheal(self.healNpc,player);
          elseif menuSelect == 3 then
            self:partyenter(player);
          elseif menuSelect == 4 then
            self:partyform(player);
          elseif menuSelect == 5 then
            self:gather(player);
          elseif menuSelect == 6 then
            self:walkingspeed(self.speedNpc,player);
          elseif menuSelect == 7 then
            self:petinfo(player);
          end
      end
    end
  end)

  --�Ƅ��ٶ�
  self.speedNpc = self:NPC_createNormal('�ٶȿ��', 98972, { x = 37, y = 37, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.speedNpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "\\n@c���ƄӼ��١�����΄��������������·�ٶȣ�\\n\\n1.���m�ن�ʿ�wƝ[���߽�ָ]��130��\\n\\n2.Ů���B[����֮��]��150��\\n\\n3.�܂���Ů��[ɭ�_�f��]��170��\\n\\n4.ِ��÷��֮��[ʧ��֮��]��200��\\n";
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
                Char.SetData(player, CONST.����_����,150);
                NLG.UpChar(player)
                NLG.SetHeadIcon(player, 114206);
          end
          if  Char.EndEvent(player,21) == 1 then
                Char.SetData(player, CONST.����_����,200);
                NLG.UpChar(player)
                NLG.SetHeadIcon(player, 114177);
          end
          if  Char.EndEvent(player,21) == 1 and Char.EndEvent(player,105) == 1 then
                Char.SetData(player, CONST.����_����,250);
                NLG.UpChar(player)
                NLG.SetHeadIcon(player, 120054);
          end
          if  Char.EndEvent(player,21) == 1 and Char.EndEvent(player,105) == 1 and Char.EndEvent(player,143) == 1 then
                Char.SetData(player, CONST.����_����,300);
                NLG.UpChar(player)
                NLG.SetHeadIcon(player, 108510)
          end
      elseif seqno == 1 and select == CONST.��ť_�ر� then
                Char.SetData(player, CONST.����_����,100);
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
                local daka = Char.GetData(p, CONST.����_��);
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
                --NLG.SystemMessage(player, "�Mꠠ�B�����ô�ȫ꠴򿨡�");
                return
          end
        end
      end
    end
  end)
  --ȫ��aѪ
  self.healNpc = self:NPC_createNormal('��Ѫ���', 98972, { x = 39, y = 37, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.healNpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "\\n\\n@c�؏�ħ��ֵ��+��������ֵ��\\n\\n�؏�����ֵ\\n\\n�؏͌��������ֵ��ħ��ֵ\\n\\nһ�I�؏�ȫ�����͌���ħ��������\\n";
      NLG.ShowWindowTalked(player, self.healNpc, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 3, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.healNpc, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.����_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select > 0 then
      if seqno == 3 and select == CONST.��ť_ȷ�� then
        gold = Char.GetData(player, CONST.CHAR_���);
        totalGold = 0;
        FpGold = 0;
        LpGold = 0;
        --Ӌ��؏Ϳ����~
        for slot = 0,4 do
          local p = Char.GetPartyMember(player,slot)
          if(p>=0) then
                local lp = Char.GetData(p, CONST.CHAR_Ѫ)
                local maxLp = Char.GetData(p, CONST.CHAR_���Ѫ)
                local fp = Char.GetData(p, CONST.CHAR_ħ)
                local maxFp = Char.GetData(p, CONST.CHAR_���ħ)
                if fp <= maxFp then
                      FpGold = FpGold + maxFp - fp;
                end
                if lp <= maxLp then
                      LpGold = LpGold + maxLp - lp;
                end
          end
        end
        print(FpGold,LpGold)
        if FpGold*0.5 >= LpGold then
          totalGold = FpGold;
        else
          totalGold = FpGold + LpGold - FpGold*0.5;
        end
        local msg = "\\n\\n@cȫ꠻؏���Ҫ���M"..totalGold.."������\\n\\n�F�н��X��"..gold.."������\\n\\n\\nҪ�؏͆᣿\\n";
        NLG.ShowWindowTalked(player, self.healNpc, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 31, msg);
      --������aѪħ
      elseif seqno == 31 and select == CONST.��ť_�� then
        if gold < totalGold then
                NLG.SystemMessage(player, '���Ų���o���؏�');
                return
        else
                if Char.PartyNum(player)>0 and player==Char.GetPartyMember(player,0) then
                    for slot = 0,4 do
                       local p = Char.GetPartyMember(player,slot);
                       if(p>=0) then
                           local maxLp = Char.GetData(p, CONST.CHAR_���Ѫ);
                           local maxFp = Char.GetData(p, CONST.CHAR_���ħ);
                           Char.SetData(p, CONST.CHAR_Ѫ, maxLp);
                           Char.SetData(p, CONST.CHAR_ħ, maxFp);
                           NLG.UpChar(p);
                           for petSlot  = 0,4 do
                              local petIndex = Char.GetPet(p,petSlot);
                              if petIndex >= 0 then
                                  local maxLp = Char.GetData(petIndex, CONST.CHAR_���Ѫ);
                                  local maxFp = Char.GetData(petIndex, CONST.CHAR_���ħ);
                                  Char.SetData(petIndex, CONST.CHAR_Ѫ, maxLp);
                                  Char.SetData(petIndex, CONST.CHAR_ħ, maxFp);
                                  Pet.UpPet(p, petIndex);
                              end
                           end
                       end
                    end
                    Char.AddGold(player, -totalGold);
                    NLG.UpChar(player);
                else
                    NLG.SystemMessage(player, '��L�ſ�ʹ�ã�');
                end
        end

      end
    end
  end)


end

Char.GetPetRank = function(playerIndex,slot)
  local petIndex = Char.GetPet(playerIndex, slot);
  if petIndex >= 0 then
    local arr_rank1 = Pet.GetArtRank(petIndex,CONST.PET_���);
    local arr_rank2 = Pet.GetArtRank(petIndex,CONST.PET_����);
    local arr_rank3 = Pet.GetArtRank(petIndex,CONST.PET_ǿ��);
    local arr_rank4 = Pet.GetArtRank(petIndex,CONST.PET_����);
    local arr_rank5 = Pet.GetArtRank(petIndex,CONST.PET_ħ��);
    local arr_rank11 = Pet.FullArtRank(petIndex, CONST.PET_���);
    local arr_rank21 = Pet.FullArtRank(petIndex, CONST.PET_����);
    local arr_rank31 = Pet.FullArtRank(petIndex, CONST.PET_ǿ��);
    local arr_rank41 = Pet.FullArtRank(petIndex, CONST.PET_����);
    local arr_rank51 = Pet.FullArtRank(petIndex, CONST.PET_ħ��);
    local a1 = math.abs(arr_rank11 - arr_rank1);
    local a2 = math.abs(arr_rank21 - arr_rank2);
    local a3 = math.abs(arr_rank31 - arr_rank3);
    local a4 = math.abs(arr_rank41 - arr_rank4);
    local a5 = math.abs(arr_rank51 - arr_rank5);
    local a6 = a1 + a2+ a3+ a4+ a5;
    return a6, a1, a2, a3, a4, a5;
  end
  return -1;
end



Char.GetAccessory = function(charIndex)
  local itemType = {
    { type=15},{ type=16},{ type=17},{ type=18},{ type=19},{ type=20},{ type=21},
  }
  local ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_����1);
  if ItemIndex >= 0 then
    for k, v in ipairs(itemType) do
      if Item.GetData(ItemIndex, CONST.����_����)==v.type then
        return ItemIndex, CONST.EQUIP_����1;
      end
    end
  end
  ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_����2)
  if ItemIndex >= 0 then
    for k, v in ipairs(itemType) do
      if Item.GetData(ItemIndex, CONST.����_����)==v.type then
        return ItemIndex, CONST.EQUIP_����2;
      end
    end
  end
  return -1, -1;
end

function QuickUI:onUnload()
  self:logInfo('unload')
end

return QuickUI;
