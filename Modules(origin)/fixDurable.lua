---模块类
local Module = ModuleBase:createModule('fixDurable')

local ItemPosName = {"頭 部", "身 体", "右 手", "左 手", "足 部", "飾品1", "飾品2", "水 晶"}

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self.maintainfixNPC = self:NPC_createNormal('波利達茲', 14510, { x =217 , y = 83, mapType = 0, map = 1000, direction = 0 });
  Char.SetData(self.maintainfixNPC,CONST.对象_ENEMY_PetFlg+2,0)--可穿透体
  self:NPC_regTalkedEvent(self.maintainfixNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local winMsg = "1\\n請選擇要快速修理的裝備(1耐久100G): \\n"
          for targetSlot = 0,7 do
                local targetItemIndex = Char.GetItemIndex(player, targetSlot);
                if targetItemIndex>=0 then
                        local tItemID = Item.GetData(targetItemIndex, CONST.道具_ID);
                        local tItemName = Item.GetData(targetItemIndex, CONST.道具_名字);
                        local targetDur_MIN = Item.GetData(targetItemIndex,CONST.道具_耐久);
                        local targetDur_MAX = Item.GetData(targetItemIndex,CONST.道具_最大耐久);
                        local msg = tItemName .. " "..targetDur_MIN.."/"..targetDur_MAX;
                        winMsg = winMsg .. ItemPosName[targetSlot+1] .. "：" .. msg .. "\n"
                else
                        winMsg = winMsg .. ItemPosName[targetSlot+1] .. "：" .. "\n"
                end
          end
          NLG.ShowWindowTalked(player, self.maintainfixNPC, CONST.窗口_选择框, CONST.按钮_关闭, 1, winMsg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.maintainfixNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --print(data)
    local tPlayerGold = Char.GetData(player, CONST.对象_金币);
    if select > 0 then
      if (seqno == 1 and select == CONST.按钮_关闭) then
                 return;
      end
    else
      if (seqno == 1 and data >= 1) then
          local targetSlot = data-1;  --装备格参数 (选项少1)
          local targetItemIndex = Char.GetItemIndex(player, targetSlot);
          if (targetItemIndex>0) then
              local tItemID = Item.GetData(targetItemIndex, CONST.道具_ID);
              local tItemName = Item.GetData(targetItemIndex, CONST.道具_名字);
              --local tNeedGold = Item.GetData(targetItemIndex, CONST.道具_等级)*1000;
              local durPlus = NLG.Rand(1, 80);
              if (durPlus ~=nil) then
                  local targetDur_MIN = Item.GetData(targetItemIndex,CONST.道具_耐久);
                  local targetDur_MAX = Item.GetData(targetItemIndex,CONST.道具_最大耐久);
                  if (targetDur_MIN>=targetDur_MAX) then
                      NLG.SystemMessage(player, "[系統] 裝備不需要進行修理。");
                      return;
                  end
                  local tNeedGold = (targetDur_MAX-targetDur_MIN)*100;
                  if (tPlayerGold<tNeedGold) then
                      NLG.SystemMessage(player, "[系統] 修理需要" .. tNeedGold .. "G，所需金幣不足。");
                      return;
                  else
                      Char.SetData(player, CONST.对象_金币, tPlayerGold-tNeedGold);
                      if (durPlus<=80) then
                          Item.SetData(targetItemIndex,CONST.道具_耐久, targetDur_MAX);
                          Item.UpItem(player, targetSlot);
                          NLG.UpChar(player);
                          NLG.SystemMessage(player, "[系統] 快速修理成功，回復耐久到滿。");
                      elseif (durPlus>80 and durPlus<=90) then
                          Item.SetData(targetItemIndex,CONST.道具_耐久, math.ceil(targetDur_MIN * 0.9) );
                          Item.UpItem(player, targetSlot);
                          NLG.UpChar(player);
                          NLG.SystemMessage(player, "[系統] 快速修理失敗，裝備耐久下滑！");
                      elseif (durPlus>90 and durPlus<=100) then
                          Item.SetData(targetItemIndex,CONST.道具_最大耐久, math.ceil(targetDur_MAX * 0.8) );
                          local targetDur_MAX_2 = Item.GetData(targetItemIndex,CONST.道具_最大耐久);
                          if (targetDur_MIN>=targetDur_MAX_2) then
                              Item.SetData(targetItemIndex,CONST.道具_耐久, targetDur_MAX_2);
                          end
                          Item.UpItem(player, targetSlot);
                          NLG.UpChar(player);
                          NLG.SystemMessage(player, "[系統] 快速修理大失敗，裝備最大耐久降低！");
                      end
                  end
              end
          end
      end

    end
  end)


end


--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
