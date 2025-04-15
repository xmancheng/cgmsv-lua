---ģ����
local Module = ModuleBase:createModule('resetStone')

--��װ��������
local player_skillAffixes_list = {300,301,302,303};		--skill�~�Y��̖�б�
local player_skillAffixes_info = {}
player_skillAffixes_info[300] = "������10%ʹ��ޒ����";
player_skillAffixes_info[301] = "ޒ�����Ă�������5%";
player_skillAffixes_info[302] = "������2%�����w";
player_skillAffixes_info[303] = "����ħ��5%�؏���ԁ��";

--��װ��������
local pet_skillAffixes_list = {500,501,502,503};		--skill�~�Y��̖�б�
local pet_skillAffixes_info = {}
pet_skillAffixes_info[500] = "�غϽY���r5%�O�޻�";
pet_skillAffixes_info[501] = "Ѫ��20%���¹�������10%";
pet_skillAffixes_info[502] = "Ѫ��35-65%���R����10%";
pet_skillAffixes_info[503] = "Ѫ��85%�����ٶ�����10%";
------------------------------------------------
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  --ϴ��ʯ����
  self:regCallback('ItemString', Func.bind(self.refiningStone, self),"LUA_useReStone");
  ResetStoneNPC = self:NPC_createNormal('�����~�lʯ', 14682, { x = 35, y = 30, mapType = 0, map = 777, direction = 6 });
  Char.SetData(ResetStoneNPC,CONST.����_ENEMY_PetFlg+2,0)--�ɴ�͸��
  self:NPC_regTalkedEvent(ResetStoneNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local targetItemIndex = Char.GetItemIndex(player, 8);
        if (targetItemIndex>=0) then
          local affix = string.split(Item.GetData(targetItemIndex, CONST.����_USEFUNC),",");
          if (type(affix)=="table") then
                if (tonumber(affix[1])==nil) then
                  return;
                end
                local tItemID = Item.GetData(targetItemIndex, CONST.����_ID);
                local tItemName = Item.GetData(targetItemIndex, CONST.����_����);
                local msg = "5\\n\\n���������������������~�lʯ��\\n"
                         .. "�������������b�����Q:".. tItemName .. "\\n"
                         .. "������������Ո�x��Ҫ������һ���~�l: \\n\\n";
                for i=1,#affix do
                  local skillId = tonumber(affix[i]);
                  if (skillId>0) then
                    msg = msg .. "������������"..player_skillAffixes_info[skillId].."\\n";
                  else
                    msg = msg;
                  end
                end
              NLG.ShowWindowTalked(player, ResetStoneNPC, CONST.����_ѡ���, CONST.��ť_�ر�, 1, msg);
          else
                local msg = "\\n\\n@c���~�lʯ��"
                  .."\\n\\n"
                  .."\\n��Ʒ�ڵ�һ���b��\\n"
                  .."\\n�]���κ��~�l��������\\n";
              NLG.ShowWindowTalked(player, ResetStoneNPC, CONST.����_��Ϣ��, CONST.��ť_�ر�, 1, msg);
          end
        else
                msg = "\\n\\n@c���~�lʯ��"
                  .."\\n\\n"
                  .."\\nՈ��Ҫ�����~�l���b��\\n"
                  .."\\n������Ʒ�ڵĵ�һ��\\n";
              NLG.ShowWindowTalked(player, ResetStoneNPC, CONST.����_��Ϣ��, CONST.��ť_�ر�, 1, msg);
        end
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(ResetStoneNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local StoneIndex = StoneIndex;
    local Stonelot = StoneSlot;
    if select > 0 then
      if select == CONST.��ť_�ر� then
          return;
      end
    else
      --print(data)
      local targetItemIndex = Char.GetItemIndex(player,8);
      if (seqno == 40 and data>0) then
        local affix = string.split(Item.GetData(targetItemIndex, CONST.����_USEFUNC),",");
        local skillId="";
        if (type(affix)=="table") then
          for i=1,#affix do
            if (i<#affix) then
              if (i==data) then
                repeat
                  rand = NLG.Rand(1,#player_skillAffixes_list);
                until ( player_skillAffixes_list[rand] ~= tonumber(affix[i]) )
                skillId = skillId .. player_skillAffixes_list[rand]..",";
              else
                skillId = skillId .. tonumber(affix[i])..",";
              end
            else
              if (i==data) then
                repeat
                  rand = NLG.Rand(1,#player_skillAffixes_list);
                until ( player_skillAffixes_list[rand] ~= tonumber(affix[i]) )
                skillId = skillId .. player_skillAffixes_list[rand];
              else
                skillId = skillId .. tonumber(affix[i]);
              end
            end
          end
          Item.SetData(targetItemIndex, CONST.����_USEFUNC, skillId);
          Item.UpItem(player,8);
          --Char.DelItemBySlot(player, Stonelot);
          Char.DelItem(player, 75032, 1);
          NLG.UpChar(player);
          NLG.SystemMessage(player,"[ϵͳ]��׃�~�l�ɹ�:"..player_skillAffixes_info[player_skillAffixes_list[rand]].."��");
        else
            return;
        end
      elseif (seqno == 41 and data>0) then
        local affix = string.split(Item.GetData(targetItemIndex, CONST.����_USEFUNC),",");
        local skillId="";
        if (affix~=nil) then
          for i=1,#affix do
            if (i<#affix) then
              if (i==data) then
                repeat
                  rand = NLG.Rand(1,#pet_skillAffixes_list);
                until ( pet_skillAffixes_list[rand] ~= tonumber(affix[i]) )
                skillId = skillId .. pet_skillAffixes_list[rand]..",";
              else
                skillId = skillId .. tonumber(affix[i])..",";
              end
            else
              if (i==data) then
                repeat
                  rand = NLG.Rand(1,#pet_skillAffixes_list);
                until ( pet_skillAffixes_list[rand] ~= tonumber(affix[i]) )
                skillId = skillId .. pet_skillAffixes_list[rand];
              else
                skillId = skillId .. tonumber(affix[i]);
              end
            end
          end
          Item.SetData(targetItemIndex, CONST.����_USEFUNC, skillId);
          Item.UpItem(player,8);
          --Char.DelItemBySlot(player, Stonelot);
          Char.DelItem(player, 75033, 1);
          NLG.UpChar(player);
          NLG.SystemMessage(player,"[ϵͳ]��׃�~�l�ɹ�:"..pet_skillAffixes_info[pet_skillAffixes_list[rand]].."��");
        else
            return;
        end
      end
    end
  end)

end
------------------------------------------------
----
function Module:refiningStone(charIndex,targetIndex,itemSlot)
    StoneItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    StoneSlot = itemSlot;
    StoneIndex = Char.GetItemIndex(charIndex,itemSlot);
    local targetItemIndex = Char.GetItemIndex(charIndex, 8);
    if (targetItemIndex>=0) then
      local itemtype = Item.GetData(targetItemIndex, CONST.����_����);
      local affix = string.split(Item.GetData(targetItemIndex, CONST.����_USEFUNC),",");
      if (type(affix)=="table") then
        local tItemID = Item.GetData(targetItemIndex, CONST.����_ID);
        local tItemName = Item.GetData(targetItemIndex, CONST.����_����);
        local msg = "5\\n\\n���������������������~�lʯ��\\n"
                 .. "�������������b�����Q:".. tItemName .. "\\n"
                 .. "������������Ո�x��Ҫ������һ���~�l: \\n\\n";
        --��װ�������40.��װ�������41
        if (StoneItemID==75032) then
            if (tonumber(affix[1])==nil) then
                local msg = "\\n\\n@c���~�lʯ��"
                  .."\\n\\n"
                  .."\\n��Ʒ�ڵ�һ����߲���\\n"
                  .."\\n�]���κ��~�l��������\\n";
              NLG.ShowWindowTalked(charIndex, ResetStoneNPC, CONST.����_��Ϣ��, CONST.��ť_�ر�, 1, msg);
              return;
            end
            if (itemtype~=0 and itemtype~=1 and itemtype~=2 and itemtype~=3 and itemtype~=4 and itemtype~=5 and itemtype~=6 and itemtype~=7 and itemtype~=8 and itemtype~=9 and itemtype~=10 and itemtype~=11 and itemtype~=12 and itemtype~=13 and itemtype~=14) then
              NLG.SystemMessage(charIndex,"[ϵͳ]�~�lʯֻ�܌������b��ʹ�á�");
              return;
            end
            for i=1,#affix do
              local skillId = tonumber(affix[i]);
              if (skillId>0) then
                    msg = msg .. "������������"..player_skillAffixes_info[skillId].."\\n";
              else
                    msg = msg;
              end
            end
            NLG.ShowWindowTalked(charIndex, ResetStoneNPC, CONST.����_ѡ���, CONST.��ť_�ر�, 40, msg);
        elseif (StoneItemID==75033) then
            if (tonumber(affix[1])==nil) then
                local msg = "\\n\\n@c���~�lʯ��"
                  .."\\n\\n"
                  .."\\n��Ʒ�ڵ�һ����߲���\\n"
                  .."\\n�]���κ��~�l��������\\n";
              NLG.ShowWindowTalked(charIndex, ResetStoneNPC, CONST.����_��Ϣ��, CONST.��ť_�ر�, 1, msg);
              return;
            end
            if (itemtype~=56 and itemtype~=57 and itemtype~=58 and itemtype~=59 and itemtype~=60 and itemtype~=61)then
              NLG.SystemMessage(charIndex,"[ϵͳ]�~�lʯֻ�܌������b��ʹ�á�");
              return;
            end
            for i=1,#affix do
              local skillId = tonumber(affix[i]);
              if (skillId>0) then
                    msg = msg .. "������������"..pet_skillAffixes_info[skillId].."\\n";
              else
                    msg = msg;
              end
            end
            NLG.ShowWindowTalked(charIndex, ResetStoneNPC, CONST.����_ѡ���, CONST.��ť_�ر�, 41, msg);
        end
      else
                local msg = "\\n\\n@c���~�lʯ��"
                  .."\\n\\n"
                  .."\\n��Ʒ�ڵ�һ���b��\\n"
                  .."\\n�]���κ��~�l��������\\n";
              NLG.ShowWindowTalked(charIndex, ResetStoneNPC, CONST.����_��Ϣ��, CONST.��ť_�ر�, 1, msg);
      end
    else
                msg = "\\n\\n@c���~�lʯ��"
                  .."\\n\\n"
                  .."\\nՈ��Ҫ�����~�l���b��\\n"
                  .."\\n������Ʒ�ڵĵ�һ��\\n";
              NLG.ShowWindowTalked(charIndex, ResetStoneNPC, CONST.����_��Ϣ��, CONST.��ť_�ر�, 1, msg);
    end
    return 1;
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;