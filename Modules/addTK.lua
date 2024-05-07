local AddTK = ModuleBase:createModule('addTK')

local ItemTypeTable = {}
ItemTypeTable[71032] = 66
ItemTypeTable[71033] = 67
ItemTypeTable[71034] = 68
ItemTypeTable[71035] = 69
ItemTypeTable[71036] = 70

local TelekinesisTable = {
             { Info=7000211, Rate=10},
             { Info=7000212, Rate=15},
             { Info=7000213, Rate=20},
             { Info=7000214, Rate=25},
             { Info=7000215, Rate=30},
             { Info=7000216, Rate=35},
             { Info=7000217, Rate=40},
             { Info=7000218, Rate=45},
             { Info=7000219, Rate=50},
}

function AddTK:onLoad()
  self:logInfo('load');
  self:regCallback('ItemString', Func.bind(self.telekinesis, self),"LUA_useAddTK");
  self.addTKNpc = self:NPC_createNormal('荣耀传说卷轴', 14682, { x = 36, y = 33, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.addTKNpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local msg = "\\n@c【副武附念】" ..	"\\n\\n此為副武專用的榮耀傳說卷軸\\n\\n每個副武附念的上限為10次\\n\\n不論成功或失敗都會減少次數\\n\\n全附念完達7次以上成功開啟特殊效果！\\n\\n";	
        NLG.ShowWindowTalked(player, self.addTKNpc, CONST.窗口_信息框, CONST.按钮_确定关闭, 1, msg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.addTKNpc, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local ViceWeaponIndex =Char.GetViceWeapon(player);                --左右手
    if select > 0 then
      if seqno == 1 and select == CONST.按钮_确定 then
          if (ViceWeaponIndex ~= nil) then
              local ViceName = Item.GetData(ViceWeaponIndex, CONST.道具_名字);
              local ViceType = Item.GetData(ViceWeaponIndex,CONST.道具_类型);
              local Vicehint = Item.GetData(ViceWeaponIndex,CONST.道具_Explanation1);                                   --剩餘卷數道具說明
              local Special = Item.GetData(ViceWeaponIndex,CONST.道具_特殊类型);
              local Para1 = tonumber(Item.GetData(ViceWeaponIndex,CONST.道具_子参一));
              local Para2 = tonumber(Item.GetData(ViceWeaponIndex,CONST.道具_子参二));
              if (ViceType == ItemTypeTable[ItemID] and Vicehint == 189557 and Special ~= 14) then
                            Item.SetData(ViceWeaponIndex,CONST.道具_特殊类型, 14);
                            Item.SetData(ViceWeaponIndex,CONST.道具_子参一, 6);
                            Item.SetData(ViceWeaponIndex,CONST.道具_子参二, 1);
                            Item.SetData(ViceWeaponIndex,CONST.道具_Explanation1, 7000211);
                            Item.SetData(ViceWeaponIndex,CONST.道具_生命, 500);
                            Item.SetData(ViceWeaponIndex,CONST.道具_魔力, 500);
                            Item.UpItem(player,3);               --右手副武
                            --Char.DelItemBySlot(player, Char.FindItemId(player,ItemID));
                            Char.DelItem(player, ItemID,1);
                            NLG.SystemMessage(player, "恭喜！"..ViceName.."的第1次附念成功！");
                            NLG.UpChar(player);
              elseif (ViceType == ItemTypeTable[ItemID] and Special == 14 and Para1 == 6) then
                      local SRate = math.random(1,100);
                      for k, v in ipairs(TelekinesisTable) do
                            if (Vicehint == v.Info and SRate >= v.Rate) then
                                local Para2 = Para2 + 1;
                                Item.SetData(ViceWeaponIndex,CONST.道具_Explanation1, v.Info+1);
                                Item.SetData(ViceWeaponIndex,CONST.道具_子参二, Para2);
                                Item.SetData(ViceWeaponIndex,CONST.道具_生命, Item.GetData(ViceWeaponIndex,CONST.道具_生命)+500);
                                Item.SetData(ViceWeaponIndex,CONST.道具_魔力, Item.GetData(ViceWeaponIndex,CONST.道具_魔力)+500);
                                Item.UpItem(player,3);
                                --Char.DelItemBySlot(player, Char.FindItemId(player,ItemID));
                                Char.DelItem(player, ItemID,1);
                                NLG.SystemMessage(player, "恭喜！"..ViceName.."已經附念成功"..Para2.."次！");
                                NLG.UpChar(player);
                            elseif (Vicehint == v.Info and SRate < v.Rate) then
                                Item.SetData(ViceWeaponIndex,CONST.道具_Explanation1, v.Info+1);
                                Item.UpItem(player,3);
                                --Char.DelItemBySlot(player, Char.FindItemId(player,ItemID));
                                Char.DelItem(player, ItemID,1);
                                NLG.SystemMessage(player, "殘念！"..ViceName.."的附念失敗了！");
                            end
                            local New_Vicehint = Item.GetData(ViceWeaponIndex,CONST.道具_Explanation1);
                            local New_Para2 = tonumber(Item.GetData(ViceWeaponIndex,CONST.道具_子参二));
                            if (New_Vicehint == 7000220 and New_Para2 >= 7) then
                                local GameTime= math.random(0,3);
                                Item.SetData(ViceWeaponIndex,CONST.道具_幸运, GameTime);
                                Item.SetData(ViceWeaponIndex,CONST.道具_Explanation1, 7000221+GameTime);
                                Item.UpItem(player,3);
                                NLG.SystemMessage(player, "注意！"..ViceName.."迸發出特殊效果！");
                            end
                      end
              end
          end
      else

      end

    end
  end)


end



function AddTK:telekinesis(charIndex,targetIndex,itemSlot)
    ItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    local msg = "\\n@c【副武附念】" ..	"\\n\\n此為副武專用的榮耀傳說卷軸\\n\\n每個副武附念的上限為10次\\n\\n不論成功或失敗都會減少次數\\n\\n全附念完達7次以上成功開啟特殊效果！\\n\\n";	
    NLG.ShowWindowTalked(charIndex, self.addTKNpc, CONST.窗口_信息框, CONST.按钮_确定关闭, 1, msg);
    return 1;
end


Char.GetViceWeapon = function(charIndex)
  local itemType = {
    { type=65},{ type=66},{ type=67},{ type=68},{ type=69},{ type=70},
  }
  local ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_左手);
  if ItemIndex >= 0 then
    for k, v in ipairs(itemType) do
      if Item.GetData(ItemIndex, CONST.道具_类型)==v.type then
        return ItemIndex;
      end
    end
  end
  ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_右手)
  if ItemIndex >= 0 then
    for k, v in ipairs(itemType) do
      if Item.GetData(ItemIndex, CONST.道具_类型)==v.type then
        return ItemIndex;
      end
    end
  end
  return -1;
end

function AddTK:onUnload()
  self:logInfo('unload')
end

return AddTK;
