---模块类
local Module = ModuleBase:createModule('petEvolution')

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self.awakeningNPC = self:NPC_createNormal('7進化寵物', 104905, { x = 34, y = 20, mapType = 0, map = 7100, direction = 6 });
  self:NPC_regTalkedEvent(self.awakeningNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local msg = "4|\\n你的寵物有水晶了嗎？傳聞屬性結晶能讓牠們覺醒。如果你帶來各100個屬性結晶，我就幫你鑑定出寵物的型態！後續還可以繼續升級覺醒等級。\\n\\n";
          for i=0,4 do
                local pet = Char.GetPet(player,i);
                if(pet<0)then
                      msg = msg .. "空\\n";
                else
                      msg = msg .. ""..Char.GetData(pet,CONST.CHAR_名字).."\\n";
                end
          end
          NLG.ShowWindowTalked(player, self.awakeningNPC, CONST.窗口_选择框, CONST.按钮_关闭, 1, msg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.awakeningNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    print(data)
    if select > 0 then

    else
      if (seqno == 1 and select == CONST.按钮_关闭) then
                 return;
      elseif (seqno == 1 and data >= 1) then
          local petSlot = data-1;
          local petIndex = Char.GetPet(player,petSlot);
          if (petIndex>=0) then
              local PetId = Char.GetData(petIndex,CONST.PET_PetID);
              local PetCrystalIndex,targetSlot = Pet.GetCrystal(petIndex);
              local PetCrystal_Name = Item.GetData(PetCrystalIndex, CONST.道具_名字);
              local bindId = Item.GetData(PetCrystalIndex, CONST.道具_特殊类型) or 0;
              local typeId = Item.GetData(PetCrystalIndex, CONST.道具_子参一) or 0;
              local typeLv = Item.GetData(PetCrystalIndex, CONST.道具_子参二) or 0;
              if (PetCrystalIndex<0) then
                 NLG.SystemMessage(player, "[系統]寵物尚未裝備任何水晶！");
                 return;
              end
              if (bindId==0 and typeId==0 and typeLv==0) then
                 if (Char.ItemNum(player, 510222)>=100 and Char.ItemNum(player, 510233)>=100 and Char.ItemNum(player, 510244)>=100 and Char.ItemNum(player, 510255)>=100) then
                     --删除需要的材料
                     Char.DelItem(player, 510222, 100);
                     Char.DelItem(player, 510233, 100);
                     Char.DelItem(player, 510244, 100);
                     Char.DelItem(player, 510255, 100);
                     --鉴定宠物型态
                     local TL = Pet.GetArtRank(petIndex, CONST.PET_体成);
                     local GJ = Pet.GetArtRank(petIndex, CONST.PET_力成);
                     local FY = Pet.GetArtRank(petIndex, CONST.PET_强成);
                     local MJ = Pet.GetArtRank(petIndex, CONST.PET_敏成);
                     local MF = Pet.GetArtRank(petIndex, CONST.PET_魔成);
                     if TL>GJ and TL>FY and TL>MJ and TL>MF and TL>40 then
                         PetType=1;
                         Identify="強化型";
                     elseif GJ>MJ and GJ>TL and GJ>FY and GJ>MF and GJ>40 then
                         PetType=2;
                         Identify="放出型";
                     elseif FY>TL and FY>GJ and FY>MJ and FY>MF and FY>=40 then
                         PetType=3;
                         Identify="變化型";
                     elseif MJ>TL and MJ>GJ and MJ>FY and MJ>MF and MJ>=40 then
                         PetType=4;
                         Identify="操作型";
                     elseif MF>TL and MF>GJ and MF>FY and MF>MJ and MF>=40 then
                         PetType=5;
                         Identify="具現化型";
                     else
                         PetType=6;
                         Identify="特質型";
                     end
                     --水晶启动效果记录
                     local Aname = "[" ..Identify.. "]"..PetCrystal_Name;
                     local Newname = "[" ..Identify.. "]"..PetCrystal_Name.."+1";
                     Item.SetData(PetCrystalIndex,CONST.道具_名字, Newname);
                     Item.SetData(PetCrystalIndex,CONST.道具_鉴前名, Aname);
                     Item.SetData(PetCrystalIndex,CONST.道具_特殊类型, PetId);
                     Item.SetData(PetCrystalIndex,CONST.道具_子参一, PetType);
                     Item.SetData(PetCrystalIndex,CONST.道具_子参二, 1);
                     Item.SetData(PetCrystalIndex,CONST.道具_生命, Item.GetData(PetCrystalIndex,CONST.道具_生命)+500);
                     Item.SetData(PetCrystalIndex,CONST.道具_魔力, Item.GetData(PetCrystalIndex,CONST.道具_魔力)+500);
                     Item.SetData(PetCrystalIndex,CONST.道具_攻击, Item.GetData(PetCrystalIndex,CONST.道具_攻击)+50);
                     Item.SetData(PetCrystalIndex,CONST.道具_防御, Item.GetData(PetCrystalIndex,CONST.道具_防御)+100);
                     Item.SetData(PetCrystalIndex,CONST.道具_敏捷, Item.GetData(PetCrystalIndex,CONST.道具_敏捷)+50);
                     Item.SetData(PetCrystalIndex,CONST.道具_精神, Item.GetData(PetCrystalIndex,CONST.道具_精神)+50);
                     Item.SetData(PetCrystalIndex,CONST.道具_回复, Item.GetData(PetCrystalIndex,CONST.道具_回复)+30);
                     Item.UpItem(petIndex, targetSlot);
                     Pet.UpPet(player, petIndex);
                     NLG.SystemMessage(player, "[系統]寵物鑑定完成，牠是"..Identify.."！");
                     NLG.UpChar(player);
                 else
                     NLG.SystemMessage(player, "[系統]屬性結晶數量不足無法鑑定！");
                     return;
                 end
              elseif (bindId~=0 and typeId~=0 and typeLv>=1 and typeLv<10) then
                 local itemMaterial = (typeLv+1)*100;
                 if (Char.ItemNum(player, 510222)>=itemMaterial and Char.ItemNum(player, 510233)>=itemMaterial and Char.ItemNum(player, 510244)>=itemMaterial and Char.ItemNum(player, 510255)>=itemMaterial) then
                     --删除需要的材料
                     Char.DelItem(player, 510222, itemMaterial);
                     Char.DelItem(player, 510233, itemMaterial);
                     Char.DelItem(player, 510244, itemMaterial);
                     Char.DelItem(player, 510255, itemMaterial);
                     --升级更新
                     local Aname = Item.GetData(PetCrystalIndex,CONST.道具_鉴前名);
                     local typeLv_New = typeLv+1;
                     local Newname = Aname.."+"..typeLv_New;
                     Item.SetData(PetCrystalIndex,CONST.道具_名字, Newname);
                     Item.SetData(PetCrystalIndex,CONST.道具_子参二, typeLv_New);
                     Item.SetData(PetCrystalIndex,CONST.道具_生命, Item.GetData(PetCrystalIndex,CONST.道具_生命)+500);
                     Item.SetData(PetCrystalIndex,CONST.道具_魔力, Item.GetData(PetCrystalIndex,CONST.道具_魔力)+500);
                     Item.SetData(PetCrystalIndex,CONST.道具_攻击, Item.GetData(PetCrystalIndex,CONST.道具_攻击)+50);
                     Item.SetData(PetCrystalIndex,CONST.道具_防御, Item.GetData(PetCrystalIndex,CONST.道具_防御)+100);
                     Item.SetData(PetCrystalIndex,CONST.道具_敏捷, Item.GetData(PetCrystalIndex,CONST.道具_敏捷)+50);
                     Item.SetData(PetCrystalIndex,CONST.道具_精神, Item.GetData(PetCrystalIndex,CONST.道具_精神)+50);
                     Item.SetData(PetCrystalIndex,CONST.道具_回复, Item.GetData(PetCrystalIndex,CONST.道具_回复)+30);
                     Item.UpItem(petIndex, targetSlot);
                     Pet.UpPet(player, petIndex);
                     NLG.SystemMessage(player, "[系統]寵物覺醒升級成功+"..typeLv_New.."！");
                     NLG.UpChar(player);
                 else
                     NLG.SystemMessage(player, "[系統]寵物覺醒升級所需的屬性結晶: "..itemMaterial.."個！");
                 end
              end
          end
      else
                 return;
      end
    end
  end)


  self.omenNPC = self:NPC_createNormal('轉換覺醒占卜', 14605, { x = 435, y = 410, mapType = 0, map = 20300, direction = 4 });
  self:NPC_regTalkedEvent(self.omenNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local msg = "4|\\n寵物水晶已經有覺醒了嗎？如果你不喜歡目前的類型，帶著特殊的樹果。我可以占卜出寵物的新型態！但是結果不一定正確。\\n\\n";
          for i=0,4 do
                local pet = Char.GetPet(player,i);
                if(pet<0)then
                      msg = msg .. "空\\n";
                else
                      msg = msg .. ""..Char.GetData(pet,CONST.CHAR_名字).."\\n";
                end
          end
          NLG.ShowWindowTalked(player, self.omenNPC, CONST.窗口_选择框, CONST.按钮_关闭, 1, msg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.omenNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    print(data)
    if select > 0 then

    else
      if (seqno == 1 and select == CONST.按钮_关闭) then
                 return;
      elseif (seqno == 1 and data >= 1) then
          local petSlot = data-1;
          local petIndex = Char.GetPet(player,petSlot);
          if (petIndex>=0) then
              local PetId = Char.GetData(petIndex,CONST.PET_PetID);
              local PetCrystalIndex,targetSlot = Pet.GetCrystal(petIndex);
              local PetCrystal_Name = Item.GetData(PetCrystalIndex, CONST.道具_名字);
              local bindId = Item.GetData(PetCrystalIndex, CONST.道具_特殊类型) or 0;
              local typeId = Item.GetData(PetCrystalIndex, CONST.道具_子参一) or 0;
              local typeLv = Item.GetData(PetCrystalIndex, CONST.道具_子参二) or 0;
              if (PetCrystalIndex<0) then
                 NLG.SystemMessage(player, "[系統]寵物尚未裝備任何水晶！");
                 return;
              end
              if (bindId==0 and typeId==0 and typeLv==0) then
                 NLG.SystemMessage(player, "[系統]這是尚未進行過鑑定的水晶！");
                 return;
              elseif (bindId~=0 and typeId~=0 and typeLv>=1 and typeLv<=10) then
                 local fruit_a = Char.ItemNum(player, 69016) or 0;
                 local fruit_b = Char.ItemNum(player, 69017) or 0;
                 local fruit_c = Char.ItemNum(player, 69018) or 0;
                 local fruit_d = Char.ItemNum(player, 69023) or 0;
                 local fruit_e = Char.ItemNum(player, 69028) or 0;
                 local itemMaterial = fruit_a+fruit_b+fruit_c+fruit_d+fruit_e;
                 if (itemMaterial>=160) then
                     --删除需要的材料
                     Char.DelItem(player, 69016, fruit_a);
                     Char.DelItem(player, 69017, fruit_b);
                     Char.DelItem(player, 69018, fruit_c);
                     Char.DelItem(player, 69023, fruit_d);
                     Char.DelItem(player, 69028, fruit_e);
                     --觉醒类型更新
                     local PetType = NLG.Rand(1,6);
                     if (PetType==1 or fruit_a >=60) then
                         PetType=1
                         Identify="強化型";
                     elseif (PetType==2 or fruit_b >=60) then
                         PetType=2
                         Identify="放出型";
                     elseif (PetType==3 or fruit_c >=60) then
                         PetType=3
                         Identify="變化型";
                     elseif (PetType==4 or fruit_d >=60) then
                         PetType=4
                         Identify="操作型";
                     elseif (PetType==5 or fruit_e >=60) then
                         PetType=5
                         Identify="具現化型";
                     elseif PetType==6 then
                         PetType=6
                         Identify="特質型";
                     else
                         PetType=6
                         Identify="特質型";
                     end
                     local Aname = "[" ..Identify.. "]".."寵物水晶";
                     local Newname = Aname.."+"..typeLv;
                     Item.SetData(PetCrystalIndex,CONST.道具_名字, Newname);
                     Item.SetData(PetCrystalIndex,CONST.道具_鉴前名, Aname);
                     Item.SetData(PetCrystalIndex,CONST.道具_子参一, PetType);
                     Item.UpItem(petIndex, targetSlot);
                     Pet.UpPet(player, petIndex);
                     NLG.SystemMessage(player, "[系統]寵物水晶類型已轉換" ..Identify.. "！");
                     NLG.UpChar(player);
                 else
                     NLG.SystemMessage(player, "[系統]覺醒占卜所需的樹果總量不足160！");
                 end
              end
          end
      else
                 return;
      end
    end
  end)


end

--获取宠物装备-水晶
Pet.GetCrystal = function(petIndex)
  local ItemIndex = Char.GetItemIndex(petIndex, CONST.宠道栏_水晶);
  if ItemIndex >= 0 and Item.GetData(ItemIndex, CONST.道具_类型)==CONST.道具类型_宠物水晶 then
    return ItemIndex,CONST.宠道栏_水晶;
  end
  return -1,-1;
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
