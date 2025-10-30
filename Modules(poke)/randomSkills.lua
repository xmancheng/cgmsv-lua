---ģ����
local Module = ModuleBase:createModule('randomSkills')

local KScope_skillId = { 551, 552, 553, 554, 555, 556, 557,}
local Kaleidoscope = {
  { 0, 551, "������", "��Ӱʮ�֔�", {26303,0,0,530,0,0,0,0,0,0,0,30,2000,2000,30,25,0,0,0,20,0,} },
  { 1, 552, "������", "�����_�Ի�ȭ", {26306,1,1,549,0,0,0,0,22,0,0,0,2000,2000,0,0,30,0,25,20,0,} },
  { 2, 553, "������", "�_�x�ƻ˓�", {26310,2,0,552,0,0,0,0,0,0,25,0,2000,2000,25,0,30,0,0,20,0,} },
  { 3, 554, "���ȡ�", "��ʹ֮��", {26318,3,0,280,0,0,560,200,0,0,0,20,1800,1800,0,0,25,30,0,20,350,} },
  { 4, 555, "������", "���}���R", {26313,4,1,519,0,0,0,0,16,0,0,20,1800,1800,0,30,0,0,25,20,0,} },
  { 5, 556, "С����", "�L�ݣ����L��", {26325,5,1,493,0,0,0,0,0,0,20,14,1800,1800,30,0,25,0,0,20,0,} },
  { 6, 557, "�����S", "ˮ�ݣ�ˮ�Д�", {26321,6,1,551,0,0,0,0,0,0,16,20,1800,1800,0,0,0,30,25,20,0,} },
}

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('ItemAttachEvent', Func.bind(self.itemAttachCallback, self))
  self:regCallback('ItemDetachEvent', Func.bind(self.itemDetachCallback, self))

  self:regCallback("ItemString", Func.bind(self.KaleidoScope, self), 'LUA_useScope');
  self.ScopeNPC = self:NPC_createNormal('��Ӱ���S', 14682, { x = 38, y = 35, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.ScopeNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local msg = "\\n\\n\\n\\n@c�]���m�ô�׃�Q���S�Ļ�Ӱ����\\n\\n";
          NLG.ShowWindowTalked(player, self.ScopeNPC, CONST.����_��Ϣ��, CONST.��ť_�ر�, 2, msg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.ScopeNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --print(data)
    local ScopeSlot = ScopeSlot;
    local ScopeIndex = Char.GetItemIndex(player,ScopeSlot);
    local weaponSlot = Char.FindItemId(player, 75035);
    local weaponIndex = Char.HaveItem(player, 75035);
    if select > 0 then
    else
      if (seqno == 1 and select == CONST.��ť_�ر�) then
         return;
      elseif (seqno == 2 and select == CONST.��ť_�ر�) then
         return;
      end
      if (seqno == 1 and data >= 1) then
          local chooseType = data-1;
          local ItemId = Item.GetData(weaponIndex, CONST.����_ID);
          local ItemType = Item.GetData(weaponIndex, CONST.����_����);
          if (weaponSlot<=7) then
             NLG.SystemMessage(player,"[ϵ�y]Ոж��������׃�Q��");
             return;
          end
          if (chooseType==ItemType) then
             NLG.SystemMessage(player,"[ϵ�y]�x��׃�Q�����������ͬ��");
             return;
          end
          if (ItemId==75035) then
              for k,v in ipairs(Kaleidoscope) do
                --print(data,chooseType,Kaleidoscope[k][1])
                if (chooseType==Kaleidoscope[k][1]) then
                  Item.SetData(weaponIndex, CONST.����_ͼ, Kaleidoscope[k][5][1]);
                  Item.SetData(weaponIndex, CONST.����_����, Kaleidoscope[k][5][2]);
                  Item.SetData(weaponIndex, CONST.����_˫��, Kaleidoscope[k][5][3]);
                  Item.SetData(weaponIndex, CONST.����_����, Kaleidoscope[k][5][4]);
                  Item.SetData(weaponIndex, CONST.����_����, Kaleidoscope[k][5][5]);
                  Item.SetData(weaponIndex, CONST.����_����, Kaleidoscope[k][5][6]);
                  Item.SetData(weaponIndex, CONST.����_����, Kaleidoscope[k][5][7]);
                  Item.SetData(weaponIndex, CONST.����_�ظ�, Kaleidoscope[k][5][8]);
                  Item.SetData(weaponIndex, CONST.����_��ɱ, Kaleidoscope[k][5][9]);
                  Item.SetData(weaponIndex, CONST.����_����, Kaleidoscope[k][5][10]);
                  Item.SetData(weaponIndex, CONST.����_����, Kaleidoscope[k][5][11]);
                  Item.SetData(weaponIndex, CONST.����_����, Kaleidoscope[k][5][12]);
                  Item.SetData(weaponIndex, CONST.����_����, Kaleidoscope[k][5][13]);
                  Item.SetData(weaponIndex, CONST.����_ħ��, Kaleidoscope[k][5][14]);
                  Item.SetData(weaponIndex, CONST.����_����, Kaleidoscope[k][5][15]);
                  Item.SetData(weaponIndex, CONST.����_˯��, Kaleidoscope[k][5][16]);
                  Item.SetData(weaponIndex, CONST.����_ʯ��, Kaleidoscope[k][5][17]);
                  Item.SetData(weaponIndex, CONST.����_��, Kaleidoscope[k][5][18]);
                  Item.SetData(weaponIndex, CONST.����_�ҿ�, Kaleidoscope[k][5][19]);
                  Item.SetData(weaponIndex, CONST.����_����, Kaleidoscope[k][5][20]);
                  Item.SetData(weaponIndex, CONST.����_ħ��, Kaleidoscope[k][5][21]);
                  Item.UpItem(player, weaponSlot);
                  NLG.UpChar(player);
                  NLG.SystemMessage(player,"[ϵ�y]�������׃�Q��"..Kaleidoscope[k][3].."��");
                end
              end

              local ScopeDur_MIN = Item.GetData(ScopeIndex,CONST.����_�;�);
              if (ScopeDur_MIN>1) then
                 Item.SetData(ScopeIndex,CONST.����_�;�, ScopeDur_MIN-1);
                 Item.UpItem(player, ScopeSlot);
                 if (ScopeDur_MIN==2) then NLG.SystemMessage(player,"[ϵ�y]����׃�����S��ʹ�ôΔ�ʣ��1�Ρ�"); end
              else
                 Char.DelItemBySlot(player, ScopeSlot);
              end
          end
      end
    end
  end)

end

function Module:KaleidoScope(charIndex,targetIndex,itemSlot)
    ItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    ScopeSlot = itemSlot;
    local ScopeIndex = Char.GetItemIndex(charIndex,ScopeSlot);
    local weaponSlot = Char.FindItemId(charIndex, 75035);
    local weaponIndex = Char.HaveItem(charIndex, 75035);
    if weaponIndex>=0 then
          local msg = "2|\\n���x��Ҫ׃�Q��������ͣ��K���b��r�@�ü���\\n\\n";
          for k,v in ipairs(Kaleidoscope) do
             msg = msg .. "���������:"..Kaleidoscope[k][3].. "������["..Kaleidoscope[k][4].."]\\n";
          end
          NLG.ShowWindowTalked(charIndex, self.ScopeNPC, CONST.����_ѡ���, CONST.��ť_�ر�, 1, msg);
    else
          local msg = "\\n\\n\\n\\n@c�]���m�ô�׃�Q���S�Ļ�Ӱ����\\n\\n";
          NLG.ShowWindowTalked(charIndex, self.ScopeNPC, CONST.����_��Ϣ��, CONST.��ť_�ر�, 2, msg);
    end
    return 1;
end


--װ���ӿ�
function Module:itemAttachCallback(charIndex, fromItemIndex)
      if Char.IsDummy(charIndex) or Char.IsPet(charIndex) then
        return 0;
      end
      local ItemId = Item.GetData(fromItemIndex, CONST.����_ID);
      local ItemType = Item.GetData(fromItemIndex, CONST.����_����);
      if (ItemId==75035) then
          for i,v in ipairs(KScope_skillId) do
              if (Char.HaveSkill(charIndex,v)>=0) then
                  Char.DelSkill(charIndex,v,1);
                  NLG.UpChar(charIndex);
              end
          end
          if Char.GetSkillNum(charIndex)==Char.GetData(charIndex, CONST.����_������) then
              NLG.SystemMessage(charIndex,"[ϵ�y]���ܸ������㣬Ո�h��һ�����ܡ�");
              return;
          end
          for k,v in ipairs(Kaleidoscope) do
            if (Kaleidoscope[k][1]==ItemType) then
              Char.AddSkill(charIndex,Kaleidoscope[k][2],0,1);
              Char.SetSkillLevel(charIndex, Char.HaveSkill(charIndex,Kaleidoscope[k][2]),1,1);
              --Char.SetSkillExp(charIndex, Char.HaveSkill(charIndex,Kaleidoscope[k][2]),19800,0);
              NLG.SystemMessage(charIndex,"�õ���"..Kaleidoscope[k][4].."�ļ��ܣ�");
            end
          end
          --NLG.SystemMessage(charIndex,"[ϵ�y]�����B���У���o�@�ü���Ո���µ��롣");
          NLG.UpChar(charIndex);
          Char.SaveToDb(charIndex);
      end
  return 0;
end
--ж�½ӿ�
function Module:itemDetachCallback(charIndex, fromItemIndex)
      if Char.IsDummy(charIndex) or Char.IsPet(charIndex) then
        return 0;
      end
      local ItemId = Item.GetData(fromItemIndex, CONST.����_ID);
      local ItemType = Item.GetData(fromItemIndex, CONST.����_����);
      if (ItemId==75035) then
          for i,v in ipairs(KScope_skillId) do
              if (Char.HaveSkill(charIndex,v)>=0) then
                  Char.DelSkill(charIndex,v,1);
                  NLG.UpChar(charIndex);
              end
          end
          NLG.SystemMessage(charIndex,"[ϵ�y]���������У���Ҫ׃�Q����Ո�����b�䡣");
          Char.SaveToDb(charIndex);

          --��Ӱ����
          local toItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_����);
          if (toItemIndex > 0) then
            local toItemId = Item.GetData(toItemIndex, CONST.����_ID);
            local toItemType = Item.GetData(toItemIndex, CONST.����_����);
            if (toItemId==75035) then
              for k,v in ipairs(Kaleidoscope) do
                if (Kaleidoscope[k][1]==toItemType) then
                  Char.AddSkill(charIndex,Kaleidoscope[k][2],0,1);
                  Char.SetSkillLevel(charIndex, Char.HaveSkill(charIndex,Kaleidoscope[k][2]),10,1);
                  --Char.SetSkillExp(charIndex, Char.HaveSkill(charIndex,Kaleidoscope[k][2]),19800,0);
                  NLG.SystemMessage(charIndex,"�õ���"..Kaleidoscope[k][4].."�ļ��ܣ�");
                end
              end
              --NLG.SystemMessage(charIndex,"[ϵ�y]�����B���У���o�@�ü���Ո���µ��롣");
              NLG.UpChar(charIndex);
              Char.SaveToDb(charIndex);
            end
          end
          local toItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_����);
          if (toItemIndex > 0) then
            local toItemId = Item.GetData(toItemIndex, CONST.����_ID);
            local toItemType = Item.GetData(toItemIndex, CONST.����_����);
            if (toItemId==75035) then
              for k,v in ipairs(Kaleidoscope) do
                if (Kaleidoscope[k][1]==toItemType) then
                  Char.AddSkill(charIndex,Kaleidoscope[k][2],0,1);
                  Char.SetSkillLevel(charIndex, Char.HaveSkill(charIndex,Kaleidoscope[k][2]),10,1);
                  --Char.SetSkillExp(charIndex, Char.HaveSkill(charIndex,Kaleidoscope[k][2]),19800,0);
                  NLG.SystemMessage(charIndex,"�õ���"..Kaleidoscope[k][4].."�ļ��ܣ�");
                end
              end
              --NLG.SystemMessage(charIndex,"[ϵ�y]�����B���У���o�@�ü���Ո���µ��롣");
              NLG.UpChar(charIndex);
              Char.SaveToDb(charIndex);
            end
          end
      end
  return 0;
end

Char.GetSkillNum = function(charIndex)
  local Number=0;
  for Slot=0,14 do
    local SkillID=Char.GetSkillID(charIndex,Slot);
    if SkillID>0 then
        Number=Number+1;
    end
  end
  return Number;
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
