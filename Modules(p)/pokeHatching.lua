---模块类
local Module = ModuleBase:createModule('pokeHatching')

local petList = {
petList[75003]={ {600018,600019}, }		  --徽章
petList[75004]={ {600018,600019}, }
petList[75005]={ {600018,600019}, }
petList[75006]={ {600018,600019}, }
petList[75007]={ {600018,600019}, }
petList[75008]={ {600018,600019}, }
petList[75009]={ {600018,600019}, }
petList[75010]={ {600018,600019}, }
}

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('ItemOverLapEvent', Func.bind(self.OnItemOverLapEvent, self));
  --self.ItemOverLap = self:regCallback(Func.bind(self.OnItemOverLapEvent, self));
  --NL.RegItemOverLapEvent("./lua/Modules/pokeHatching.lua", self.ItemOverLap);
  self:regCallback('ItemString', Func.bind(self.hatchTools, self),"LUA_useHatch");
  self.IncubatorNPC = self:NPC_createNormal('寶可夢孵蛋器', 14682, { x = 38, y = 33, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.IncubatorNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local winMsg = "【寶可夢蛋孵蛋流程】\\n"
                         .."═════════════════════\\n"
                         .."↓拖曳一種屬性道館徽章至此蛋↓\\n\\n"
                         .."　　　　持續提供徽章提升稀有寵物機率\\n"
                         .."　　　　並且在綁定後計算行走100步以上\\n"
                         .."\\n\\n是否確定雙擊將孵化此蛋？\\n";
        NLG.ShowWindowTalked(player, self.IncubatorNPC, CONST.窗口_信息框, CONST.BUTTON_是否, 1, winMsg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.IncubatorNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --孵化工具
    local OvenIndex =Char.HaveItemID(player, ItemID);
    local OvenSlot = Char.FindItemId(player, ItemID);
    local OvenName = Item.GetData(OvenIndex, CONST.道具_名字);
    local OvenDur = 100;
    --注入的徽章ID
    local fromItemID = Item.GetData(OvenIndex,CONST.道具_子参一);
    local typeNum = Item.GetData(OvenIndex,CONST.道具_子参二);
    if select > 0 then
      --确认执行
      if (seqno == 12 and select == CONST.BUTTON_否) then
                 return;
      elseif (seqno == 12 and select == CONST.BUTTON_是)  then
                 local SuccPlus= math.floor(typeNum/5);
                 if (SuccPlus>60) then SuccPlus=60; end
                 local SuccRate = petList[fromItemID][2]+SuccPlus;
                 print(SuccRate)
                 if (SuccRate>100) then SuccRate=100; end
                 if (type(SuccRate)=="number" and SuccRate>0) then
                      local tMin = 50 - math.floor(SuccRate/2) + 1;
                      local tMax = 50 + math.floor(SuccRate/2) + math.fmod(SuccRate,2);
                      local tLuck = math.random(1, 100);
                      if (tLuck>=tMin and tLuck<=tMax)  then
                           Char.AddPet(player, petList[fromItemID][3]);
                      end
                 end
                 Char.DelItemBySlot(player, OvenSlot);
                 NLG.UpChar(player);
      else
                 return;
      end
    else
    end
  end)


end


function Module:hatchTools(charIndex,targetIndex,itemSlot)
    ItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    OvenSlot =itemSlot;
    local OvenIndex = Char.GetItemIndex(charIndex,itemSlot);
    local winMsg = "【寶可夢蛋孵蛋流程】\\n"
                         .."═════════════════════\\n"
                         .."↓拖曳一種屬性道館徽章至此蛋↓\\n\\n"
                         .."　　　　持續提供徽章提升稀有寵物機率\\n"
                         .."　　　　並且在綁定後計算行走100步以上\\n"
                         .."\\n\\n是否確定雙擊將孵化此蛋？\\n";
        NLG.ShowWindowTalked(charIndex, self.IncubatorNPC, CONST.窗口_信息框, CONST.BUTTON_是否, 1, winMsg);
    return 1;
end

function Module:OnItemOverLapEvent(charIndex, fromIndex, targetIndex, Num)
    local fromItemID = Item.GetData(fromIndex,0);
    local targetItemID = Item.GetData(targetIndex,0);
    local walkOn = Item.GetData(targetIndex,CONST.道具_幸运);
    print(fromItemID,targetItemID)
    if (targetItemID==75001 and walkOn==0) then
        if (fromItemID==75003 or fromItemID==75004 or fromItemID==75005 or fromItemID==75006 or fromItemID==75007 or fromItemID==75008 or fromItemID==75009 or fromItemID==75010) then
                 local walkCount = Char.GetData(charIndex,CONST.CHAR_走动次数);
                 Item.SetData(targetIndex,CONST.道具_幸运, walkCount);
                 Item.SetData(targetIndex,CONST.道具_名字,"["..Item.GetData(fromIndex,CONST.道具_名字).."]蛋");
                 Item.SetData(targetIndex,CONST.道具_子参一, fromItemID);
                 Item.SetData(targetIndex,CONST.道具_子参二, 1);
                 Item.SetData(targetIndex,CONST.道具_丢地消失, 1);
                 Item.SetData(targetIndex,CONST.道具_宠邮, 0);
                 Char.DelItem(charIndex, fromItemID, 1);
                 Item.UpItem(charIndex, Char.FindItemId(charIndex, targetItemID));
                 NLG.UpChar(charIndex);
                 NLG.SystemMessage(charIndex, "[系統]注意！蛋丟地會消失、無法交易！");
                 return 1;
        end
    elseif (targetItemID==75001 and walkOn>=1) then
        if (fromItemID==75003 or fromItemID==75004 or fromItemID==75005 or fromItemID==75006 or fromItemID==75007 or fromItemID==75008 or fromItemID==75009 or fromItemID==75010) then
            local setItemID = Item.GetData(targetIndex,CONST.道具_子参一);
            local setCount = Item.GetData(targetIndex,CONST.道具_子参二);
            local typeNum = setCount+1;
            if (setItemID==fromItemID) then
                 local walkCount = Char.GetData(charIndex,CONST.CHAR_走动次数);
                 local Count = walkCount-walkOn;
                 Item.SetData(targetIndex,CONST.道具_名字, "["..Item.GetData(fromIndex,CONST.道具_名字).."]蛋"..Count.."步");
                 Item.SetData(targetIndex,CONST.道具_子参二, setCount+1);
                 Char.DelItem(charIndex, fromItemID, 1);
                 Item.UpItem(charIndex, Char.FindItemId(charIndex, targetItemID));
                 NLG.UpChar(charIndex);
                 NLG.SystemMessage(charIndex, "[系統]累積 "..Item.GetData(fromIndex,CONST.道具_名字).." 數量:"..typeNum..);
                 return 1;
            else
                 NLG.SystemMessage(charIndex, "[系統]蛋種已綁定只能再加入相同的徽章提升機率！");
                 return 0;
            end
        end
    end
    return 0;
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
