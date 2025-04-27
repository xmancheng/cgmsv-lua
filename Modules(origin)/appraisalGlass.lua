---模块类
local Module = ModuleBase:createModule('appraisalGlass')

local specialEffects = {
  {4,20,35,1640736},	--記載著拉傑法爾的偷襲心得
  {4,55,35,1020716},	--裝備上就會擁有王者的保護，可以輕鬆的襲擊魔族
  --{12,50,0,3012354},	--能力值變為50級的狀態
  --{13,0,0,3012354},	--偷取敵人物品時，同時能給予敵人傷害力
  --{13,1,0,3004870},	--使用護衛技能時能發動反擊
  --{13,3,0,3004873},	--使用明鏡止水技能時隨機回避敵人的攻擊
  {2,62,50,1645959},	--可使技能‘強力補血’耗魔減半
  {2,23,50,1645960},	--可使技能‘強力隕石’耗魔減半
  {2,24,50,1645961},	--可使技能‘強力冰凍’耗魔減半
  {2,25,50,1645962},	--可使技能‘強力火焰’耗魔減半
  {2,26,50,1645963},	--可使技能‘強力風刃’耗魔減半
  {2,61,50,1645972},	--可使技能‘補血魔法’耗魔減半
  {2,40,50,1645973},	--可使技能‘強力石化’耗魔減半
  {2,39,50,1645974},	--可使技能‘強力昏睡’耗魔減半
  {2,42,50,1645975},	--可使技能‘強力混亂’耗魔減半
  {2,43,50,1645976},	--可使技能‘強力遺忘’耗魔減半
  {2,44,50,1645977},	--可使技能‘強力中毒’耗魔減半
  {2,41,50,1645978},	--可使技能‘強力酒醉’耗魔減半
  {6,8,0,1645919},	--可以變化成金屬系
  {6,7,0,1645918},	--可以變化成特殊系
  {6,6,0,1645917},	--可以變化成野獸系
  {6,5,0,1645916},	--可以變化成植物系
  {6,4,0,1645915},	--可以變化成昆蟲系
  {6,3,0,1645914},	--可以變化成飛行系
  {6,2,0,1645913},	--可以變化成不死系
  {6,1,0,1645912},	--可以變化成龍系
}

local enemyPetId = {
  404001,404002,404003,404004,404005,404006,404007,404008,404009,404010,
  404011,404012,404013,404014,404015,404016,404017,404018,404019,404020,
  404021,404022,404023,404024,404025,
}
------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  --鑑定镜道具
  self:regCallback('ItemString', Func.bind(self.actifyGlass, self),"LUA_useActiGlas");
  AppraisalGlassNPC = self:NPC_createNormal('鑑定鏡', 14682, { x = 38, y = 33, mapType = 0, map = 777, direction = 6 });
  Char.SetData(AppraisalGlassNPC,CONST.对象_ENEMY_PetFlg+2,0)--可穿透体
  self:NPC_regTalkedEvent(AppraisalGlassNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local GoalIndex,GoalSlot = Char.GetUnidentifiedSlot(player);
        if (GoalIndex>0) then
          local GoalName = Item.GetData(GoalIndex,CONST.道具_名字);
                local msg = "\\n\\n@c【系統通知】"
                  .."\\n\\n"
                  .."\\n自動找尋未鑑定物品...\\n"
                  .."\\n確定要鑑定 $5"..GoalName.." $0？\\n";
          NLG.ShowWindowTalked(player, AppraisalGlassNPC, CONST.窗口_信息框, CONST.按钮_是否, 1, msg);
        else
                local msg = "\\n\\n@c【系統通知】"
                  .."\\n\\n"
                  .."\\n自動找尋未鑑定物品...\\n"
                  .."\\n物品欄中沒有需要鑑定的道具。\\n";
          NLG.ShowWindowTalked(player, AppraisalGlassNPC, CONST.窗口_信息框, CONST.按钮_关闭, 1, msg);
        end
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(AppraisalGlassNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local GlassIndex = GlassIndex;
    local GlassSlot = GlassSlot;
    local GoalIndex,GoalSlot = Char.GetUnidentifiedSlot(player);
    if select > 0 then
      if seqno == 1 and select == CONST.按钮_关闭 then
          return;
      elseif seqno == 1 and select == CONST.按钮_否 then
          return;
      elseif seqno == 1 and select == CONST.按钮_是 then
        if (GoalIndex>0) then
          local Special = Item.GetData(GoalIndex,CONST.道具_特殊类型);
          local Para1 = Item.GetData(GoalIndex,CONST.道具_子参一);
          local Para2 = Item.GetData(GoalIndex,CONST.道具_子参二);
          if (Special==0 and Item.GetData(GoalIndex, CONST.道具_类型)==62) then
              local rand = NLG.Rand(1,#specialEffects);
              Item.SetData(GoalIndex,CONST.道具_特殊类型, specialEffects[rand][1]);
              Item.SetData(GoalIndex,CONST.道具_子参一, specialEffects[rand][2]);
              Item.SetData(GoalIndex,CONST.道具_子参二, specialEffects[rand][3]);
              Item.SetData(GoalIndex,CONST.道具_Explanation1,specialEffects[rand][4]);
              Item.SetData(GoalIndex,CONST.道具_幸运, 66);
              Item.SetData(GoalIndex,CONST.道具_已鉴定,1);
              Item.UpItem(player, GoalSlot);
              NLG.UpChar(player);
              Char.DelItem(player, 75031, 1);
              NLG.SystemMessage(player,"[系统]"..Item.GetData(GoalIndex,CONST.道具_鉴前名).."鑑定成功 "..Item.GetData(GoalIndex,CONST.道具_名字).."。");
          elseif (Item.GetData(GoalIndex, CONST.道具_类型)==63) then
              local rand = NLG.Rand(1,#enemyPetId);
              local EnemyDataIndex = Data.EnemyGetDataIndex(enemyPetId[rand]);
              local enemyBaseId = Data.EnemyGetData(EnemyDataIndex, CONST.Enemy_Base编号);
              local EnemyBaseDataIndex = Data.EnemyBaseGetDataIndex(enemyBaseId);
              local Enemy_name = Data.EnemyBaseGetData(EnemyBaseDataIndex, CONST.EnemyBase_名字);
              Item.SetData(GoalIndex,CONST.道具_名字,"["..Enemy_name.."]封印卡牌");
              Item.SetData(GoalIndex,CONST.道具_幸运, enemyPetId[rand]);
              Item.SetData(GoalIndex,CONST.道具_已鉴定,1);
              Item.UpItem(player, GoalSlot);
              NLG.UpChar(player);
              Char.DelItem(player, 75031, 1);
              NLG.SystemMessage(player,"[系统]鑑定成功 "..Item.GetData(GoalIndex,CONST.道具_名字).."。");
          else
              Item.SetData(GoalIndex,CONST.道具_已鉴定,1);
              Item.UpItem(player, GoalSlot);
              NLG.UpChar(player);
              Char.DelItem(player, 75031, 1);
              NLG.SystemMessage(player,"[系统]"..Item.GetData(GoalIndex,CONST.道具_鉴前名).."鑑定成功 "..Item.GetData(GoalIndex,CONST.道具_名字).."。");
          end
        else
            return;
        end
      else
          return;
      end
    end
  end)


  --附加效果
  AdditionalEffectsNPC = self:NPC_createNormal('鑑定效果轉移', 14602, { x = 246, y = 76, mapType = 0, map = 1000, direction = 6 });
  Char.SetData(AdditionalEffectsNPC,CONST.对象_ENEMY_PetFlg+2,0)--可穿透体
  self:NPC_regTalkedEvent(AdditionalEffectsNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local ItemIndex = Char.GetItemIndex(player, CONST.EQUIP_首饰2);
        if (ItemIndex < 0) then
            NLG.SystemMessage(player,"[系統]飾品2位置沒有任何道具。");
            return;
        elseif (ItemIndex >= 0) then
            local CarrierIndex,CarrierSlot = Char.GetIdentifiedSlot(player);
            if (CarrierIndex>0 and Item.GetData(ItemIndex, CONST.道具_类型)==62) then
                local CarrierName = Data.GetMessage(Item.GetData(CarrierIndex,CONST.道具_Explanation1));
                local msg = "\\n\\n@c【系統通知】"
                    .."\\n\\n"
                    .."\\n確定要轉移 $5"..CarrierName.."\\n"
                    .."\\n覆蓋掉影鏡原有的特殊效果嗎？\\n";
                NLG.ShowWindowTalked(player, AdditionalEffectsNPC, CONST.窗口_信息框, CONST.按钮_是否, 1, msg);
            elseif (CarrierIndex>0 and Item.GetData(ItemIndex, CONST.道具_类型)~=62) then
                NLG.SystemMessage(player,"[系統]飾品2須裝備上影鏡。");
                return;
            elseif (CarrierIndex<0) then
                local msg = "\\n\\n@c【系統通知】"
                    .."\\n\\n"
                    .."\\n自動找尋已經鑑定的物品...\\n"
                    .."\\n$4※物品欄中沒有特殊效果的道具。\\n";
                NLG.ShowWindowTalked(player, AdditionalEffectsNPC, CONST.窗口_信息框, CONST.按钮_关闭, 1, msg);
            end
        end
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(AdditionalEffectsNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local ItemIndex = Char.GetItemIndex(player, CONST.EQUIP_首饰2);
    local CarrierIndex,CarrierSlot = Char.GetIdentifiedSlot(player);
    if select > 0 then
      if seqno == 1 and select == CONST.按钮_关闭 then
          return;
      elseif seqno == 1 and select == CONST.按钮_否 then
          return;
      elseif seqno == 1 and select == CONST.按钮_是 then
        if (ItemIndex>0 and CarrierIndex>0) then
          local Special = Item.GetData(CarrierIndex,CONST.道具_特殊类型);
          local Para1 = Item.GetData(CarrierIndex,CONST.道具_子参一);
          local Para2 = Item.GetData(CarrierIndex,CONST.道具_子参二);
          local info = Item.GetData(CarrierIndex,CONST.道具_Explanation1);

          Item.SetData(ItemIndex,CONST.道具_特殊类型, Special);
          Item.SetData(ItemIndex,CONST.道具_子参一, Para1);
          Item.SetData(ItemIndex,CONST.道具_子参二, Para2);
          Item.SetData(ItemIndex,CONST.道具_Explanation1, info);
          Item.UpItem(player, CONST.EQUIP_首饰2);
          Char.DelItemBySlot(player, CarrierSlot);
          NLG.UpChar(player);
          NLG.SystemMessage(player,"[系统]特殊效果轉移成功。");
        else
            return;
        end
      else
          return;
      end
    end
  end)

end
------------------------------------------------
----
function Module:actifyGlass(charIndex,targetIndex,itemSlot)
    GlassItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    GlassSlot =itemSlot;
    GlassIndex = Char.GetItemIndex(charIndex,itemSlot);
    local GoalIndex,GoalSlot = Char.GetUnidentifiedSlot(charIndex);
    if (GoalIndex>0) then
      local GoalName = Item.GetData(GoalIndex,CONST.道具_名字);
            local msg = "\\n\\n@c【系統通知】"
              .."\\n\\n"
              .."\\n自動找尋未鑑定物品...\\n"
              .."\\n確定要鑑定 $5"..GoalName.." $0？\\n";
      NLG.ShowWindowTalked(charIndex, AppraisalGlassNPC, CONST.窗口_信息框, CONST.按钮_是否, 1, msg);
    else
            local msg = "\\n\\n@c【系統通知】"
              .."\\n\\n"
              .."\\n自動找尋未鑑定物品...\\n"
              .."\\n物品欄中沒有需要鑑定的道具。\\n";
      NLG.ShowWindowTalked(charIndex, AppraisalGlassNPC, CONST.窗口_信息框, CONST.按钮_关闭, 1, msg);
    end
    return 1;
end

Char.GetUnidentifiedSlot = function(charIndex)
  for Slot=7,27 do
      local ItemIndex = Char.GetItemIndex(charIndex, Slot);
      --print(ItemIndex);
      if (ItemIndex > 0 and Item.GetData(ItemIndex,CONST.道具_已鉴定)==0) then
        local ItemId = Item.GetData(ItemIndex,CONST.道具_ID);
        return ItemIndex,Slot;
      end
  end
  return -1,-1;
end

Char.GetIdentifiedSlot = function(charIndex)
  for Slot=7,27 do
      local ItemIndex = Char.GetItemIndex(charIndex, Slot);
      --print(ItemIndex);
      if (ItemIndex > 0 and Item.GetData(ItemIndex,CONST.道具_幸运)==66) then
        local ItemId = Item.GetData(ItemIndex,CONST.道具_ID);
        return ItemIndex,Slot;
      end
  end
  return -1,-1;
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;