local Module = ModuleBase:createModule('magicScroll')

local ItemPosName = {"頭 部", "身 体", "右 手", "左 手", "足 部", "飾品1", "飾品2", "水 晶"}
local typeEnable_check = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,65,66,67,68,69,70}

local scrollRateTable={}
scrollRateTable[31] ={0,35,65,80,88,95,100,101}			--个别机率35,30,15,8,7,5
scrollRateTable[32] ={0,4,10,41,71,85,92,97,99,100,101}		--个别机率4,6,31,30,14,7,5,2,1
scrollRateTable[33] ={0,100,101}

local scrollTable={}	--攻|防|敏|精|回|血|魔|魔攻|魔抗|必|反|命|闪 (数值范围)
scrollTable[71032] = "15,20|0,0|0,0|0,0|0,0|15,20|15,20|0,0|0,0|1,2|0,0|1,2|0,0";
scrollTable[71033] = "12,20|0,0|0,0|0,0|0,0|12,20|12,20|0,0|0,0|0,2|0,0|0,2|0,0";
scrollTable[71034] = "14,14|0,0|0,0|0,0|0,0|14,14|14,14|0,0|0,0|1,1|0,0|1,1|0,0";
scrollTable[71035] = "0,0|0,0|0,0|15,20|0,0|15,20|15,20|15,20|0,0|0,0|0,0|0,0|1,2";
scrollTable[71036] = "0,0|0,0|0,0|12,20|0,0|12,20|12,20|12,20|0,0|0,0|0,0|0,0|0,2";
scrollTable[71037] = "0,0|0,0|0,0|14,14|0,0|14,14|14,14|14,14|0,0|0,0|0,0|0,0|1,1";

scrollTable[71038] = "10,15|10,15|10,15|10,15|0,0|10,15|10,15|0,0|10,15|0,0|0,0|0,0|0,0";
scrollTable[71039] = "7,15|7,15|7,15|7,15|0,0|7,15|7,15|0,0|7,15|0,0|0,0|0,0|0,0";
scrollTable[71040] = "9,9|9,9|9,9|9,9|0,0|9,9|9,9|0,0|9,9|0,0|0,0|0,0|0,0";
scrollTable[71041] = "10,15|10,15|10,15|10,15|0,0|10,15|10,15|0,0|10,15|0,0|0,0|0,0|0,0";
scrollTable[71042] = "7,15|7,15|7,15|7,15|0,0|7,15|7,15|0,0|7,15|0,0|0,0|0,0|0,0";
scrollTable[71043] = "9,9|9,9|9,9|9,9|0,0|9,9|9,9|0,0|9,9|0,0|0,0|0,0|0,0";
scrollTable[71044] = "10,15|10,15|10,15|10,15|0,0|10,15|10,15|0,0|10,15|0,0|0,0|0,0|0,0";
scrollTable[71045] = "7,15|7,15|7,15|7,15|0,0|7,15|7,15|0,0|7,15|0,0|0,0|0,0|0,0";
scrollTable[71046] = "9,9|9,9|9,9|9,9|0,0|9,9|9,9|0,0|9,9|0,0|0,0|0,0|0,0";

----------------------------------------------------------------------------------------------
function Module:onLoad()
  self:logInfo('load');
  self:regCallback('ItemString', Func.bind(self.telekinesis, self),"LUA_useScroll");
  self.witcheryNPC = self:NPC_createNormal('魔力卷軸大師', 14682, { x = 36, y = 33, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.witcheryNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local msg = "\\n@c【魔力卷軸】" ..	"\\n\\n此為魔力專用的卷軸\\n\\n分為救世、命运、黑暗三種類型的卷軸\\n\\n衝卷成功率皆為100%但結果為隨機素質！\\n\\n";	
        NLG.ShowWindowTalked(player, self.witcheryNPC, CONST.窗口_信息框, CONST.按钮_确定关闭, 1, msg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.witcheryNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local ScrollSpecial = Item.GetData(ScrollIndex,CONST.道具_特殊类型);	--卷轴种类
    local targetSlot = Item.GetData(ScrollIndex,CONST.道具_子参一);	--冲卷部位
    local targetIndex = Char.GetItemIndex(player, targetSlot);
    if select > 0 then
      if seqno == 1 and select == CONST.按钮_确定 then
          if (targetIndex >= 0) then
              local targetName = Item.GetData(targetIndex, CONST.道具_名字);
              local targetType = Item.GetData(targetIndex,CONST.道具_类型);
              local targethint = Item.GetData(targetIndex,CONST.道具_Explanation1);		--剩余卷数道具说明
              --local Para1 = tonumber(Item.GetData(targetIndex,CONST.道具_子参一));
              --local Para2 = tonumber(Item.GetData(targetIndex,CONST.道具_子参二));
              if (CheckInTable(typeEnable_check, targetType)==true and targethint == 7000220) then			--已7卷终了
                      NLG.SystemMessage(player, "[系統] "..targetName.." 剩餘卷數已衝完！");
                      return;
              elseif (CheckInTable(typeEnable_check, targetType)==true and targethint == 7000214) then		--第2卷
                      rateCalculate(ScrollSpecial,ItemID,targetIndex);
                      Item.SetData(targetIndex,CONST.道具_Explanation1, targethint+1);
                      Item.UpItem(player,targetSlot);
                      --Char.DelItemBySlot(player, Char.FindItemId(player,ItemID));
                      Char.DelItem(player, ItemID,1);
                      NLG.SystemMessage(player, "[系統] "..targetName.." 衝卷成功！");
                      NLG.UpChar(player);
              elseif (CheckInTable(typeEnable_check, targetType)==true and targethint ~= 7000214) then		--第1、3~7卷
                  if (targethint>=7000215 and targethint<=7000219) then					--第3~7卷
                      rateCalculate(ScrollSpecial,ItemID,targetIndex);
                      Item.SetData(targetIndex,CONST.道具_Explanation1, targethint+1);
                      Item.UpItem(player,targetSlot);
                      --Char.DelItemBySlot(player, Char.FindItemId(player,ItemID));
                      Char.DelItem(player, ItemID,1);
                      if (targethint == 7000219) then
                          NLG.SystemMessage(player, "[系統] "..targetName.." 最後1次衝卷成功！");
                      else
                          NLG.SystemMessage(player, "[系統] "..targetName.." 衝卷成功！");
                      end
                      NLG.UpChar(player);
                  else										--第1卷
                      rateCalculate(ScrollSpecial,ItemID,targetIndex);
                      Item.SetData(targetIndex,CONST.道具_Explanation1, 7000214);
                      Item.UpItem(player,targetSlot);
                      --Char.DelItemBySlot(player, Char.FindItemId(player,ItemID));
                      Char.DelItem(player, ItemID,1);
                      NLG.SystemMessage(player, "[系統] "..targetName.." 第1次衝卷成功！");
                      NLG.UpChar(player);
                  end
              end
          end
      else

      end

    end
  end)


end


function Module:telekinesis(charIndex,targetIndex,itemSlot)
    ItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    ScrollSlot =itemSlot;
    ScrollIndex = Char.GetItemIndex(charIndex,itemSlot);
    local ScrollName = Item.GetData(ScrollIndex,CONST.道具_名字);
    local ScrollSpecial = Item.GetData(ScrollIndex,CONST.道具_特殊类型);	--卷轴种类
    local targetSlot = Item.GetData(ScrollIndex,CONST.道具_子参一);	--冲卷部位
    local targetName = ItemPosName[targetSlot+1]
    local msg = "\\n@c"..ScrollName.."\\n"
                        .. "\\n此　卷　軸　部　位：$2"..targetName.."\\n"
                        .. "\\n衝　卷　成　功　率：$4" .. "100%\\n\\n";

    local ScrollInfo = string.split(scrollTable[ItemID], "|")
    local InfoName =string.split("攻擊|防禦|敏捷|精神|回復|生命|魔力|魔攻|魔抗|必殺|反擊|命中|閃躲", "|")
    local formCount = 0
    for i=1,13 do
        local ScrollStat = ScrollInfo[i]
        local StatName = InfoName[i]
        local ScrollSub = string.split(ScrollStat, ",");
        if (tonumber(ScrollSub[1])>0 or tonumber(ScrollSub[2])>0) then
            formCount = formCount+1
            msg = msg .. " $1" .. StatName .."(+".. ScrollSub[1] .. ",+" .. ScrollSub[2] ..") "
            if (math.fmod(formCount,3)==1) then
                msg = msg .."\\n"
            end
        end
    end
    NLG.ShowWindowTalked(charIndex, self.witcheryNPC, CONST.窗口_信息框, CONST.按钮_确定关闭, 1, msg);
    return 1;
end

function rateCalculate(ScrollSpecial,ItemID,targetIndex)
    local ScrollInfo = string.split(scrollTable[ItemID], "|")
    local strData = {18, 19, 20, 21, 22, 27, 28,74,55,23,24,25,26}
    for i=1,13 do
        local ScrollStat = ScrollInfo[i]
        local ScrollSub = string.split(ScrollStat, ",");
        local SRate = math.random(1,100);
        for k=1,#scrollRateTable[ScrollSpecial]-1 do
           if (SRate>scrollRateTable[ScrollSpecial][k] and SRate<=scrollRateTable[ScrollSpecial][k+1]) then
               if (tonumber(ScrollSub[2])>0) then
                   Item.SetData(targetIndex,strData[i], Item.GetData(targetIndex,strData[i])+tonumber(ScrollSub[1])+k-1);
               end
           end
        end
    end
    return 0;
end

function CheckInTable(_idTab, _idVar) ---循环函数
	for k,v in pairs(_idTab) do
		if v==_idVar then
			return true
		end
	end
	return false
end

function Module:onUnload()
  self:logInfo('unload')
end

return Module;
