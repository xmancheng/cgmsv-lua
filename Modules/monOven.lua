---模块类
local Module = ModuleBase:createModule('monOven')

local reelList = {
  {14801,2,73801},{16900,90,73801},
}

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('ItemString', Func.bind(self.roastTools, self),"LUA_useOven");
  self.bakerNPC = self:NPC_createNormal('魔物炙烤師傅', 14682, { x = 38, y = 33, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.bakerNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local winMsg = "2\\n請選擇要添加進去烤爐的柴火(道具消失)：\\n　　※有機率取得稀有的魔法卷軸\\n";
        for wasteSlot = 23,27 do
            WasteIndex = Char.GetItemIndex(player,wasteSlot);
            if (WasteIndex>0) then
                 WasteID = Item.GetData(WasteIndex,CONST.道具_ID);
                 WasteLv = Item.GetData(WasteIndex,CONST.道具_等级);
                 --WasteType = Item.GetData(WasteIndex,CONST.道具_类型);
                 WasteName = Item.GetData(WasteIndex, CONST.道具_名字);
                 local checkWaste = GrillingMaterials(player,wasteSlot);
                 if (checkWaste==1) then
                                  winMsg = winMsg .. "第".. wasteSlot-7 .."格:〈" .. WasteName .. "〉[添加Ｏ]\\n"
                 elseif (checkWaste==0) then
                                  winMsg = winMsg .. "第".. wasteSlot-7 .."格:〈" .. WasteName .. "〉[添加Ｘ]\\n"
                 end
            else
                 winMsg = winMsg .. "第".. wasteSlot-7 .."格:  無物品" .. "\\n"
            end
        end
        NLG.ShowWindowTalked(player, self.bakerNPC, CONST.窗口_选择框, CONST.BUTTON_关闭, 1, winMsg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.bakerNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --烧烤工具
    local OvenIndex =Char.HaveItemID(player, ItemID);
    local OvenSlot = Char.FindItemId(player, ItemID);
    local OvenDur = Item.GetData(OvenIndex, CONST.道具_耐久) or 0;
    local OvenDurMax = 10000;
    if select > 0 then
      --确认柴火后执行
      if (seqno == 12 and select == CONST.BUTTON_否) then
                 return;
      elseif (seqno == 12 and select == CONST.BUTTON_是)  then
                 --Char.DelItem(player, WasteID, 1);
                 Char.DelItemBySlot(player, wasteSlot);
                 Item.SetData(OvenIndex,CONST.道具_耐久, OvenDur+WasteLv);
                 Item.SetData(OvenIndex,CONST.道具_最大耐久, OvenDurMax);
                 Item.UpItem(OvenIndex, OvenSlot);
                 NLG.UpChar(player);
      else
                 return;
      end
    else
      local wasteSlot=data+22;
      local WasteIndex = Char.GetItemIndex(player,wasteSlot);
      --选择柴火
      if (seqno == 1 and select == CONST.按钮_关闭) then
                 return;
      elseif (seqno == 1 and WasteIndex<0) then
                 NLG.SystemMessage(player, "[系統]物品欄無物品！");
                 return;
      end
      if (seqno == 1 and data>0) then
          local checkWaste,whatWaste = GrillingMaterials(player,wasteSlot);
          if (checkWaste==0) then
                 NLG.SystemMessage(player, "[系統]無法添加進烤爐的柴火！");
                 return;
          end
          if (WasteIndex ~=nil) then
                local msg = "【炙燒專用烤爐】\\n"
                                           .."═════════════════════\\n"
                                           .."↓即將被銷毀的柴火↓\\n"
                                           .."\\n　　　名稱:".. WasteName .."　　Lv:"..WasteLv.."\\n"
                                           .."\\n　　　　　　　　　　　　　\\n"
                                           .."\\n是否確定將此物添加進去烤爐呢？\\n";
                 NLG.ShowWindowTalked(player, self.bakerNPC, CONST.窗口_信息框, CONST.BUTTON_是否, 12, msg);
          end
      else
                 return;
      end
    end
  end)


end


function Module:roastTools(charIndex,targetIndex,itemSlot)
    ItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    OvenSlot =itemSlot;
    local OvenIndex = Char.GetItemIndex(charIndex,itemSlot);
        local winMsg = "2\\n請選擇要添加進去烤爐的柴火(道具消失)：\\n　　※有機率取得稀有的魔法卷軸\\n";
        for wasteSlot = 23,27 do
            WasteIndex = Char.GetItemIndex(charIndex,wasteSlot);
            if (WasteIndex>0) then
                 WasteID = Item.GetData(WasteIndex,CONST.道具_ID);
                 WasteLv = Item.GetData(WasteIndex,CONST.道具_等级);
                 WasteType = Item.GetData(WasteIndex,CONST.道具_类型);
                 WasteName = Item.GetData(WasteIndex, CONST.道具_名字);
                 local checkWaste = GrillingMaterials(charIndex,wasteSlot);
                 if (checkWaste==1) then
                                  winMsg = winMsg .. "第".. wasteSlot-7 .."格:〈" .. WasteName .. "〉[添加Ｏ]\\n"
                 elseif (checkWaste==0) then
                                  winMsg = winMsg .. "第".. wasteSlot-7 .."格:〈" .. WasteName .. "〉[添加Ｘ]\\n"
                 end
            else
                 winMsg = winMsg .. "第".. wasteSlot-7 .."格:  無物品" .. "\\n"
            end
        end
        NLG.ShowWindowTalked(charIndex, self.bakerNPC, CONST.窗口_选择框, CONST.BUTTON_关闭, 1, winMsg);
    return 1;
end

function GrillingMaterials(player,wasteSlot)
          local WasteIndex = Char.GetItemIndex(player,wasteSlot);
          local WasteID = Item.GetData(WasteIndex,CONST.道具_ID);
          local checkWaste=0;
          local whatWaste=-1;
          table.forEach(reelList, function(e)
              for k=1,#reelList do
                  if (e[k][1]==WasteID) then
                     checkWaste=1;
                     whatWaste=e;
                     return checkWaste,whatWaste;
                  else
                     checkWaste=0;
                  end
              end
          end)
          return checkWaste,whatWaste;
end
--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
