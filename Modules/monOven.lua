---模块类
local Module = ModuleBase:createModule('monOven')

local reelList = {
  {14801,2,73801},{16900,90,73801},  {14802,2,73802},{16901,90,73802},  {14803,2,73803},{16902,90,73803},
  {14804,2,73804},{16903,90,73804},  {14805,2,73805},{16904,90,73805},  {14807,2,73807},{16906,90,73807},
  {14812,2,73812},{16911,90,73812},  {14813,2,73813},{16912,90,73813},  {14814,2,73814},{16913,90,73814},
  {14815,2,73815},{16914,90,73815},  {14822,2,73822},{16921,90,73822},  {14823,2,73823},{16922,90,73823},
  {14824,2,73824},{16923,90,73824},  {14825,2,73825},{16924,90,73825},  {14827,2,73827},{16926,90,73827},
  {14829,2,73829},{16928,90,73829},  {14832,2,73832},{16931,90,73832},  {14836,2,73836},{16935,90,73836},
  {14837,2,73837},{16936,90,73837},  {14838,2,73838},{16937,90,73838},  {14839,2,73839},{16938,90,73839},
  {14840,2,73840},{16939,90,73840},  {14846,2,73846},{16945,90,73846},  {14847,2,73847},{16946,90,73847},
  {14848,2,73848},{16947,90,73848},  {14849,2,73849},{16948,90,73849},  {14852,2,73852},{16951,90,73852},
  {14862,2,73862},{16961,90,73862},  {14864,2,73864},{16963,90,73864},  {14871,2,73871},{16970,90,73871},
  {14872,2,73872},{16971,90,73872},  {14873,2,73873},{16972,90,73873},  {14874,2,73874},{16973,90,73874},
  {14875,2,73875},{16974,90,73875},  {14879,2,73879},{16978,90,73879},  {14881,2,73881},{16980,90,73881},
  {14882,2,73882},{16981,90,73882},  {14883,2,73883},{16982,90,73883},  {14884,2,73884},{16983,90,73884},
  {14889,2,73889},{16988,90,73889},  {14892,2,73892},{16991,90,73892},  {14894,2,73894},{16993,90,73894},
  {14895,2,73895},{16994,90,73895},  {14896,2,73896},{16995,90,73896},  {14897,2,73897},{16996,90,73897},
  {14902,2,73902},{17001,90,73902},  {14903,2,73903},{17002,90,73903},  {14904,2,73904},{17003,90,73904},
  {14905,2,73905},{17004,90,73905},  {14915,2,73915},{17014,90,73915},  {14916,2,73916},{17015,90,73916},
  {14917,2,73917},{17016,90,73917},  {14918,2,73918},{17017,90,73918},  {14919,2,73919},{17018,90,73919},
  {14925,2,73925},{17024,90,73925},  {14926,2,73926},{17025,90,73926},  {14927,2,73927},{17026,90,73927},
  {14928,2,73928},{17027,90,73928},  {14929,2,73929},{17028,90,73929},  {14931,2,73931},{17030,90,73931},
  {14942,2,73942},{17041,90,73942},  {14943,2,73943},{17042,90,73943},  {14944,2,73944},{17043,90,73944},
  {14945,2,73945},{17044,90,73945},  {14950,2,73950},{17049,90,73950},  {14954,2,73954},{17053,90,73954},
  {14956,2,73956},{17055,90,73956},
  --精靈球
  {69100,75,75011},{69101,75,75011},{69102,75,75011},{69103,75,75011},{69104,75,75011},{69110,75,75011},{69111,75,75011},{69134,75,75011},
  --Lv3卷軸書冊
  {69203,50,900613},{69204,50,900613},{69205,50,900613},{69206,50,900613},{69207,50,900613},{69208,50,900613},{69209,50,900613},{69210,50,900613},
  --Lv4卷軸書冊
  {69226,90,900614},{69227,90,900614},{69228,90,900614},{69229,90,900614},
  --寵物裝備包裹
  {70150,20,900601},{70151,20,900601},{70152,20,900601},{70153,20,900601},{70154,20,900601},{70155,20,900601},{70156,20,900601},
  --龍魂寶玉
  {79258,40,66667},{79259,40,66667},{79260,40,66667},{79261,40,66667},{79262,40,66667},{79263,40,66667},{79264,40,66667},
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
                 local WasteID = Item.GetData(WasteIndex,CONST.道具_ID);
                 local WasteLv = Item.GetData(WasteIndex,CONST.道具_等级);
                 --WasteType = Item.GetData(WasteIndex,CONST.道具_类型);
                 local WasteName = Item.GetData(WasteIndex, CONST.道具_名字);
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
                 local checkWaste,whatWaste = GrillingMaterials(player,wasteSlot);
                 --Char.DelItem(player, WasteID, 1);
                 Char.DelItemBySlot(player, wasteSlot);
                 NLG.Say(player,-1,"將"..WasteName.."丟進烤爐。",4,3);
                 local SuccPlus= math.floor(OvenDur/100);
                 if (SuccPlus>60) then SuccPlus=60; end
                 local SuccRate = reelList[whatWaste][2]+SuccPlus;
                 print(SuccRate)
                 if (SuccRate>100) then SuccRate=100; end
                 if (type(SuccRate)=="number" and SuccRate>0) then
                      local tMin = 50 - math.floor(SuccRate/2) + 1;
                      local tMax = 50 + math.floor(SuccRate/2) + math.fmod(SuccRate,2);
                      local tLuck = math.random(1, 100);
                      if (tLuck>=tMin and tLuck<=tMax)  then
                           Item.SetData(OvenIndex,CONST.道具_幸运, Item.GetData(OvenIndex,CONST.道具_幸运)+1);
                           --Char.GiveItem(player, reelList[whatWaste][3], 1);
                           if (reelList[whatWaste][3]==66667) then
                                Char.GiveItem(player, reelList[whatWaste][3], 100);
                           else
                                Char.GiveItem(player, reelList[whatWaste][3], 1);
                           end
                           --if Item.GetData(OvenIndex,CONST.道具_幸运)+1 == 9 then
                           --    NLG.SystemMessage(player, "[系統]烤爐使用年限快到，剩下最後一次了！");
                           --elseif Item.GetData(OvenIndex,CONST.道具_幸运)+1 >= 10 then
                           --    Char.DelItemBySlot(player, OvenSlot);
                           --    NLG.SystemMessage(player, "[系統]烤爐崩解毀壞了！");
                           --end
                      end
                 end
                 Item.SetData(OvenIndex,CONST.道具_耐久, OvenDur+WasteLv);
                 Item.SetData(OvenIndex,CONST.道具_最大耐久, OvenDurMax);
                 Item.UpItem(player, OvenSlot);
                 NLG.UpChar(player);
      else
                 return;
      end
    else
      wasteSlot=data+22;
      WasteIndex = Char.GetItemIndex(player,wasteSlot);
      if (WasteIndex>0) then
          WasteID = Item.GetData(WasteIndex,CONST.道具_ID);
          WasteLv = Item.GetData(WasteIndex,CONST.道具_等级);
          WasteName = Item.GetData(WasteIndex, CONST.道具_名字);
      end
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
                 local WasteID = Item.GetData(WasteIndex,CONST.道具_ID);
                 local WasteLv = Item.GetData(WasteIndex,CONST.道具_等级);
                 local WasteType = Item.GetData(WasteIndex,CONST.道具_类型);
                 local WasteName = Item.GetData(WasteIndex, CONST.道具_名字);
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
          local checkWaste = 0;
          local whatWaste = 0;
          for k=1,#reelList do
                  if (reelList[k][1]==WasteID) then
                     local checkWaste = 1;
                     local whatWaste = k;
                     return checkWaste,whatWaste;
                  else
                     checkWaste = 0;
                  end
          end
          return checkWaste,whatWaste;
end
--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
