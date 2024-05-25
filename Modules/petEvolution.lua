---模块类
local Module = ModuleBase:createModule('petEvolution')

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self.awakeningNPC = self:NPC_createNormal('占卜幻獸師', 104905, { x = 28, y = 40, mapType = 0, map = 60010, direction = 6 });
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
              local PetNameColor = Char.GetData(petIndex, CONST.CHAR_名色);
              local PetCrystalIndex,targetSlot = Pet.GetCrystal(petIndex);
              local PetCrystal_Name = Item.GetData(PetCrystalIndex, CONST.道具_名字);
              local bindId = Item.GetData(PetCrystalIndex, CONST.道具_特殊类型) or 0;
              local typeId = Item.GetData(PetCrystalIndex, CONST.道具_子参一) or 0;
              local typeLv = Item.GetData(PetCrystalIndex, CONST.道具_子参二) or 0;
              if (PetNameColor<4) then
                 NLG.SystemMessage(player, "[系統]寵物尚未轉生！");
                 return;
              elseif (PetNameColor==5) then
                 NLG.SystemMessage(player, "[系統]寵物尚未超級進化！");
                 return;
              end
              if (PetCrystalIndex<0) then
                 NLG.SystemMessage(player, "[系統]寵物尚未裝備任何水晶！");
                 return;
              end
              if (bindId==0 and typeId==0 and typeLv==0) then
                 if (Char.ItemNum(player, 69163)>=100 and Char.ItemNum(player, 69164)>=100 and Char.ItemNum(player, 69165)>=100 and Char.ItemNum(player, 69166)>=100) then
                     --删除需要的材料
                     Char.DelItem(player, 69163, 100);
                     Char.DelItem(player, 69164, 100);
                     Char.DelItem(player, 69165, 100);
                     Char.DelItem(player, 69166, 100);
                     --鉴定宠物型态
                     local TL = Pet.GetArtRank(petIndex, CONST.PET_体成);
                     local GJ = Pet.GetArtRank(petIndex, CONST.PET_力成);
                     local FY = Pet.GetArtRank(petIndex, CONST.PET_强成);
                     local MJ = Pet.GetArtRank(petIndex, CONST.PET_敏成);
                     local MF = Pet.GetArtRank(petIndex, CONST.PET_魔成);
                     if TL>GJ and TL>=40 then
                         PetType=1;
                         Identify="強化型";
                     elseif GJ>MJ and GJ>=40 then
                         PetType=2;
                         Identify="放出型";
                     elseif FY>TL and FY>=40 then
                         PetType=3;
                         Identify="變化型";
                     elseif MJ>GJ and MJ>=40 then
                         PetType=4;
                         Identify="操作型";
                     elseif MF>GJ and MF>=40 then
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
                     Item.UpItem(petIndex, targetSlot);
                     Pet.UpPet(player, petIndex);
                     NLG.SystemMessage(player, "[系統]寵物鑑定完成，牠是"..Identify.."！");
                     NLG.UpChar(player);
                 else
                     NLG.SystemMessage(player, "[系統]屬性結晶數量不足無法鑑定！");
                     return;
                 end
              elseif (bindId~=0 and typeId~=0 and typeLv>=1) then
                 local itemMaterial = (typeLv+1)*100;
                 if (Char.ItemNum(player, 69163)>=itemMaterial and Char.ItemNum(player, 69164)>=itemMaterial and Char.ItemNum(player, 69165)>=itemMaterial and Char.ItemNum(player, 69166)>=itemMaterial) then
                     --删除需要的材料
                     Char.DelItem(player, 69163, itemMaterial);
                     Char.DelItem(player, 69164, itemMaterial);
                     Char.DelItem(player, 69165, itemMaterial);
                     Char.DelItem(player, 69166, itemMaterial);
                     --升级更新
                     local Aname = Item.GetData(PetCrystalIndex,CONST.道具_鉴前名);
                     local typeLv_New = typeLv+1;
                     local Newname = Aname.."+"..typeLv_New;
                     Item.SetData(PetCrystalIndex,CONST.道具_名字, Newname);
                     Item.SetData(PetCrystalIndex,CONST.道具_子参二, typeLv_New);
                     Item.SetData(PetCrystalIndex,CONST.道具_生命, Item.GetData(PetCrystalIndex,CONST.道具_生命)+500);
                     Item.SetData(PetCrystalIndex,CONST.道具_魔力, Item.GetData(PetCrystalIndex,CONST.道具_魔力)+500);
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
