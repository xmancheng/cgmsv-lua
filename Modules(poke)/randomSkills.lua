---模块类
local Module = ModuleBase:createModule('randomSkills')

local KScope_skillId = { 551, 552, 553, 554, 555, 556, 557,}
local Kaleidoscope = {
  { 0, 551, "　劍　", "幻影十字斬", {26303,0,0,530,0,0,0,0,0,0,0,30,2000,2000,30,25,0,0,0,20,0,} },
  { 1, 552, "　斧　", "阿修羅霸凰拳", {26306,1,1,549,0,0,0,0,22,0,0,0,2000,2000,0,0,30,0,25,20,0,} },
  { 2, 553, "　槍　", "羅剎破凰擊", {26310,2,0,552,0,0,0,0,0,0,25,0,2000,2000,25,0,30,0,0,20,0,} },
  { 3, 554, "　杖　", "天使之擊", {26318,3,0,280,0,0,560,200,0,0,0,20,1800,1800,0,0,25,30,0,20,350,} },
  { 4, 555, "　弓　", "神聖降臨", {26313,4,1,519,0,0,0,0,16,0,0,20,1800,1800,0,30,0,0,25,20,0,} },
  { 5, 556, "小　刀", "風遁．旋風刃", {26325,5,1,493,0,0,0,0,0,0,20,14,1800,1800,30,0,25,0,0,20,0,} },
  { 6, 557, "回力鏢", "水遁．水刃斬", {26321,6,1,551,0,0,0,0,0,0,16,20,1800,1800,0,0,0,30,25,20,0,} },
}

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('ItemAttachEvent', Func.bind(self.itemAttachCallback, self))
  self:regCallback('ItemDetachEvent', Func.bind(self.itemDetachCallback, self))

  self:regCallback("ItemString", Func.bind(self.KaleidoScope, self), 'LUA_useScope');
  self.ScopeNPC = self:NPC_createNormal('幻影卷軸', 14682, { x = 38, y = 35, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.ScopeNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local msg = "\\n\\n\\n\\n@c沒有適用此變換卷軸的幻影武器\\n\\n";
          NLG.ShowWindowTalked(player, self.ScopeNPC, CONST.窗口_信息框, CONST.按钮_关闭, 2, msg);
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
      if (seqno == 1 and select == CONST.按钮_关闭) then
         return;
      elseif (seqno == 2 and select == CONST.按钮_关闭) then
         return;
      end
      if (seqno == 1 and data >= 1) then
          local chooseType = data-1;
          local ItemId = Item.GetData(weaponIndex, CONST.道具_ID);
          local ItemType = Item.GetData(weaponIndex, CONST.道具_类型);
          if (weaponSlot<=7) then
             NLG.SystemMessage(player,"[系統]請卸下武器再變換。");
             return;
          end
          if (chooseType==ItemType) then
             NLG.SystemMessage(player,"[系統]選擇變換的武器類型相同。");
             return;
          end
          if (ItemId==75035) then
              for k,v in ipairs(Kaleidoscope) do
                --print(data,chooseType,Kaleidoscope[k][1])
                if (chooseType==Kaleidoscope[k][1]) then
                  Item.SetData(weaponIndex, CONST.道具_图, Kaleidoscope[k][5][1]);
                  Item.SetData(weaponIndex, CONST.道具_类型, Kaleidoscope[k][5][2]);
                  Item.SetData(weaponIndex, CONST.道具_双手, Kaleidoscope[k][5][3]);
                  Item.SetData(weaponIndex, CONST.道具_攻击, Kaleidoscope[k][5][4]);
                  Item.SetData(weaponIndex, CONST.道具_防御, Kaleidoscope[k][5][5]);
                  Item.SetData(weaponIndex, CONST.道具_敏捷, Kaleidoscope[k][5][6]);
                  Item.SetData(weaponIndex, CONST.道具_精神, Kaleidoscope[k][5][7]);
                  Item.SetData(weaponIndex, CONST.道具_回复, Kaleidoscope[k][5][8]);
                  Item.SetData(weaponIndex, CONST.道具_必杀, Kaleidoscope[k][5][9]);
                  Item.SetData(weaponIndex, CONST.道具_反击, Kaleidoscope[k][5][10]);
                  Item.SetData(weaponIndex, CONST.道具_命中, Kaleidoscope[k][5][11]);
                  Item.SetData(weaponIndex, CONST.道具_闪躲, Kaleidoscope[k][5][12]);
                  Item.SetData(weaponIndex, CONST.道具_生命, Kaleidoscope[k][5][13]);
                  Item.SetData(weaponIndex, CONST.道具_魔力, Kaleidoscope[k][5][14]);
                  Item.SetData(weaponIndex, CONST.道具_毒抗, Kaleidoscope[k][5][15]);
                  Item.SetData(weaponIndex, CONST.道具_睡抗, Kaleidoscope[k][5][16]);
                  Item.SetData(weaponIndex, CONST.道具_石抗, Kaleidoscope[k][5][17]);
                  Item.SetData(weaponIndex, CONST.道具_醉抗, Kaleidoscope[k][5][18]);
                  Item.SetData(weaponIndex, CONST.道具_乱抗, Kaleidoscope[k][5][19]);
                  Item.SetData(weaponIndex, CONST.道具_忘抗, Kaleidoscope[k][5][20]);
                  Item.SetData(weaponIndex, CONST.道具_魔攻, Kaleidoscope[k][5][21]);
                  Item.UpItem(player, weaponSlot);
                  NLG.UpChar(player);
                  NLG.SystemMessage(player,"[系統]武器類型變換為"..Kaleidoscope[k][3].."。");
                end
              end

              local ScopeDur_MIN = Item.GetData(ScopeIndex,CONST.道具_耐久);
              if (ScopeDur_MIN>1) then
                 Item.SetData(ScopeIndex,CONST.道具_耐久, ScopeDur_MIN-1);
                 Item.UpItem(player, ScopeSlot);
                 if (ScopeDur_MIN==2) then NLG.SystemMessage(player,"[系統]武器變化卷軸可使用次數剩下1次。"); end
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
          local msg = "2|\\n　選擇要變換的武器類型，並在裝備時獲得技能\\n\\n";
          for k,v in ipairs(Kaleidoscope) do
             msg = msg .. "　　　類型:"..Kaleidoscope[k][3].. "　技能["..Kaleidoscope[k][4].."]\\n";
          end
          NLG.ShowWindowTalked(charIndex, self.ScopeNPC, CONST.窗口_选择框, CONST.按钮_关闭, 1, msg);
    else
          local msg = "\\n\\n\\n\\n@c沒有適用此變換卷軸的幻影武器\\n\\n";
          NLG.ShowWindowTalked(charIndex, self.ScopeNPC, CONST.窗口_信息框, CONST.按钮_关闭, 2, msg);
    end
    return 1;
end


--装备接口
function Module:itemAttachCallback(charIndex, fromItemIndex)
      if Char.IsDummy(charIndex) or Char.IsPet(charIndex) then
        return 0;
      end
      local ItemId = Item.GetData(fromItemIndex, CONST.道具_ID);
      local ItemType = Item.GetData(fromItemIndex, CONST.道具_类型);
      if (ItemId==75035) then
          for i,v in ipairs(KScope_skillId) do
              if (Char.HaveSkill(charIndex,v)>=0) then
                  Char.DelSkill(charIndex,v,1);
                  NLG.UpChar(charIndex);
              end
          end
          if Char.GetSkillNum(charIndex)==Char.GetData(charIndex, CONST.对象_技能栏) then
              NLG.SystemMessage(charIndex,"[系統]技能格數量不足，請刪除一個技能。");
              return;
          end
          for k,v in ipairs(Kaleidoscope) do
            if (Kaleidoscope[k][1]==ItemType) then
              Char.AddSkill(charIndex,Kaleidoscope[k][2],0,1);
              Char.SetSkillLevel(charIndex, Char.HaveSkill(charIndex,Kaleidoscope[k][2]),1,1);
              --Char.SetSkillExp(charIndex, Char.HaveSkill(charIndex,Kaleidoscope[k][2]),19800,0);
              NLG.SystemMessage(charIndex,"得到了"..Kaleidoscope[k][4].."的技能！");
            end
          end
          --NLG.SystemMessage(charIndex,"[系統]技能連接中，如無獲得技能請重新登入。");
          NLG.UpChar(charIndex);
          Char.SaveToDb(charIndex);
      end
  return 0;
end
--卸下接口
function Module:itemDetachCallback(charIndex, fromItemIndex)
      if Char.IsDummy(charIndex) or Char.IsPet(charIndex) then
        return 0;
      end
      local ItemId = Item.GetData(fromItemIndex, CONST.道具_ID);
      local ItemType = Item.GetData(fromItemIndex, CONST.道具_类型);
      if (ItemId==75035) then
          for i,v in ipairs(KScope_skillId) do
              if (Char.HaveSkill(charIndex,v)>=0) then
                  Char.DelSkill(charIndex,v,1);
                  NLG.UpChar(charIndex);
              end
          end
          NLG.SystemMessage(charIndex,"[系統]技能消除中，如要變換技能請重新裝備。");
          Char.SaveToDb(charIndex);

          --幻影武器
          local toItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_左手);
          if (toItemIndex > 0) then
            local toItemId = Item.GetData(toItemIndex, CONST.道具_ID);
            local toItemType = Item.GetData(toItemIndex, CONST.道具_类型);
            if (toItemId==75035) then
              for k,v in ipairs(Kaleidoscope) do
                if (Kaleidoscope[k][1]==toItemType) then
                  Char.AddSkill(charIndex,Kaleidoscope[k][2],0,1);
                  Char.SetSkillLevel(charIndex, Char.HaveSkill(charIndex,Kaleidoscope[k][2]),10,1);
                  --Char.SetSkillExp(charIndex, Char.HaveSkill(charIndex,Kaleidoscope[k][2]),19800,0);
                  NLG.SystemMessage(charIndex,"得到了"..Kaleidoscope[k][4].."的技能！");
                end
              end
              --NLG.SystemMessage(charIndex,"[系統]技能連接中，如無獲得技能請重新登入。");
              NLG.UpChar(charIndex);
              Char.SaveToDb(charIndex);
            end
          end
          local toItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_右手);
          if (toItemIndex > 0) then
            local toItemId = Item.GetData(toItemIndex, CONST.道具_ID);
            local toItemType = Item.GetData(toItemIndex, CONST.道具_类型);
            if (toItemId==75035) then
              for k,v in ipairs(Kaleidoscope) do
                if (Kaleidoscope[k][1]==toItemType) then
                  Char.AddSkill(charIndex,Kaleidoscope[k][2],0,1);
                  Char.SetSkillLevel(charIndex, Char.HaveSkill(charIndex,Kaleidoscope[k][2]),10,1);
                  --Char.SetSkillExp(charIndex, Char.HaveSkill(charIndex,Kaleidoscope[k][2]),19800,0);
                  NLG.SystemMessage(charIndex,"得到了"..Kaleidoscope[k][4].."的技能！");
                end
              end
              --NLG.SystemMessage(charIndex,"[系統]技能連接中，如無獲得技能請重新登入。");
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

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
