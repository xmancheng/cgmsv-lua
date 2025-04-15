---模块类
local Module = ModuleBase:createModule('resetStone')

--人装词条技能
local player_skillAffixes_list = {300,301,302,303};		--skill詞綴編號列表
local player_skillAffixes_info = {}
player_skillAffixes_info[300] = "物理技能10%使出迴旋擊";
player_skillAffixes_info[301] = "迴旋擊的傷害增加5%";
player_skillAffixes_info[302] = "物理技能2%造成麻痺";
player_skillAffixes_info[303] = "攻擊魔法5%重強度詠唱";

--宠装词条技能
local pet_skillAffixes_list = {500,501,502,503};		--skill詞綴編號列表
local pet_skillAffixes_info = {}
pet_skillAffixes_info[500] = "回合結束時5%極巨化";
pet_skillAffixes_info[501] = "血量20%以下攻擊增加10%";
pet_skillAffixes_info[502] = "血量35-65%防禦增加10%";
pet_skillAffixes_info[503] = "血量85%以上速度增加10%";
------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  --洗练石道具
  self:regCallback('ItemString', Func.bind(self.refiningStone, self),"LUA_useReStone");
  ResetStoneNPC = self:NPC_createNormal('重置詞條石', 14682, { x = 35, y = 30, mapType = 0, map = 777, direction = 6 });
  Char.SetData(ResetStoneNPC,CONST.对象_ENEMY_PetFlg+2,0)--可穿透体
  self:NPC_regTalkedEvent(ResetStoneNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local targetItemIndex = Char.GetItemIndex(player, 8);
        if (targetItemIndex>=0) then
          local affix = string.split(Item.GetData(targetItemIndex, CONST.道具_USEFUNC),",");
          if (type(affix)=="table") then
                if (tonumber(affix[1])==nil) then
                  return;
                end
                local tItemID = Item.GetData(targetItemIndex, CONST.道具_ID);
                local tItemName = Item.GetData(targetItemIndex, CONST.道具_名字);
                local msg = "5\\n\\n　　　　　　　　　【詞條石】\\n"
                         .. "　　　　　　裝備名稱:".. tItemName .. "\\n"
                         .. "　　　　　　請選擇要重置哪一個詞條: \\n\\n";
                for i=1,#affix do
                  local skillId = tonumber(affix[i]);
                  if (skillId>0) then
                    msg = msg .. "　　　　　　"..player_skillAffixes_info[skillId].."\\n";
                  else
                    msg = msg;
                  end
                end
              NLG.ShowWindowTalked(player, ResetStoneNPC, CONST.窗口_选择框, CONST.按钮_关闭, 1, msg);
          else
                local msg = "\\n\\n@c【詞條石】"
                  .."\\n\\n"
                  .."\\n物品欄第一格裝備\\n"
                  .."\\n沒有任何詞條可以重置\\n";
              NLG.ShowWindowTalked(player, ResetStoneNPC, CONST.窗口_信息框, CONST.按钮_关闭, 1, msg);
          end
        else
                msg = "\\n\\n@c【詞條石】"
                  .."\\n\\n"
                  .."\\n請將要重置詞條的裝備\\n"
                  .."\\n放在物品欄的第一格\\n";
              NLG.ShowWindowTalked(player, ResetStoneNPC, CONST.窗口_信息框, CONST.按钮_关闭, 1, msg);
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
      if select == CONST.按钮_关闭 then
          return;
      end
    else
      --print(data)
      local targetItemIndex = Char.GetItemIndex(player,8);
      if (seqno == 40 and data>0) then
        local affix = string.split(Item.GetData(targetItemIndex, CONST.道具_USEFUNC),",");
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
          Item.SetData(targetItemIndex, CONST.道具_USEFUNC, skillId);
          Item.UpItem(player,8);
          --Char.DelItemBySlot(player, Stonelot);
          Char.DelItem(player, 75032, 1);
          NLG.UpChar(player);
          NLG.SystemMessage(player,"[系统]改變詞條成功:"..player_skillAffixes_info[player_skillAffixes_list[rand]].."。");
        else
            return;
        end
      elseif (seqno == 41 and data>0) then
        local affix = string.split(Item.GetData(targetItemIndex, CONST.道具_USEFUNC),",");
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
          Item.SetData(targetItemIndex, CONST.道具_USEFUNC, skillId);
          Item.UpItem(player,8);
          --Char.DelItemBySlot(player, Stonelot);
          Char.DelItem(player, 75033, 1);
          NLG.UpChar(player);
          NLG.SystemMessage(player,"[系统]改變詞條成功:"..pet_skillAffixes_info[pet_skillAffixes_list[rand]].."。");
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
      local itemtype = Item.GetData(targetItemIndex, CONST.道具_类型);
      local affix = string.split(Item.GetData(targetItemIndex, CONST.道具_USEFUNC),",");
      if (type(affix)=="table") then
        local tItemID = Item.GetData(targetItemIndex, CONST.道具_ID);
        local tItemName = Item.GetData(targetItemIndex, CONST.道具_名字);
        local msg = "5\\n\\n　　　　　　　　　【詞條石】\\n"
                 .. "　　　　　　裝備名稱:".. tItemName .. "\\n"
                 .. "　　　　　　請選擇要重置哪一個詞條: \\n\\n";
        --人装词条类别40.宠装词条类别41
        if (StoneItemID==75032) then
            if (tonumber(affix[1])==nil) then
                local msg = "\\n\\n@c【詞條石】"
                  .."\\n\\n"
                  .."\\n物品欄第一格道具不符\\n"
                  .."\\n沒有任何詞條可以重置\\n";
              NLG.ShowWindowTalked(charIndex, ResetStoneNPC, CONST.窗口_信息框, CONST.按钮_关闭, 1, msg);
              return;
            end
            if (itemtype~=0 and itemtype~=1 and itemtype~=2 and itemtype~=3 and itemtype~=4 and itemtype~=5 and itemtype~=6 and itemtype~=7 and itemtype~=8 and itemtype~=9 and itemtype~=10 and itemtype~=11 and itemtype~=12 and itemtype~=13 and itemtype~=14) then
              NLG.SystemMessage(charIndex,"[系统]詞條石只能對人物裝備使用。");
              return;
            end
            for i=1,#affix do
              local skillId = tonumber(affix[i]);
              if (skillId>0) then
                    msg = msg .. "　　　　　　"..player_skillAffixes_info[skillId].."\\n";
              else
                    msg = msg;
              end
            end
            NLG.ShowWindowTalked(charIndex, ResetStoneNPC, CONST.窗口_选择框, CONST.按钮_关闭, 40, msg);
        elseif (StoneItemID==75033) then
            if (tonumber(affix[1])==nil) then
                local msg = "\\n\\n@c【詞條石】"
                  .."\\n\\n"
                  .."\\n物品欄第一格道具不符\\n"
                  .."\\n沒有任何詞條可以重置\\n";
              NLG.ShowWindowTalked(charIndex, ResetStoneNPC, CONST.窗口_信息框, CONST.按钮_关闭, 1, msg);
              return;
            end
            if (itemtype~=56 and itemtype~=57 and itemtype~=58 and itemtype~=59 and itemtype~=60 and itemtype~=61)then
              NLG.SystemMessage(charIndex,"[系统]詞條石只能對寵物裝備使用。");
              return;
            end
            for i=1,#affix do
              local skillId = tonumber(affix[i]);
              if (skillId>0) then
                    msg = msg .. "　　　　　　"..pet_skillAffixes_info[skillId].."\\n";
              else
                    msg = msg;
              end
            end
            NLG.ShowWindowTalked(charIndex, ResetStoneNPC, CONST.窗口_选择框, CONST.按钮_关闭, 41, msg);
        end
      else
                local msg = "\\n\\n@c【詞條石】"
                  .."\\n\\n"
                  .."\\n物品欄第一格裝備\\n"
                  .."\\n沒有任何詞條可以重置\\n";
              NLG.ShowWindowTalked(charIndex, ResetStoneNPC, CONST.窗口_信息框, CONST.按钮_关闭, 1, msg);
      end
    else
                msg = "\\n\\n@c【詞條石】"
                  .."\\n\\n"
                  .."\\n請將要重置詞條的裝備\\n"
                  .."\\n放在物品欄的第一格\\n";
              NLG.ShowWindowTalked(charIndex, ResetStoneNPC, CONST.窗口_信息框, CONST.按钮_关闭, 1, msg);
    end
    return 1;
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;