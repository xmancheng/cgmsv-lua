local Module = ModuleBase:createModule('easyPet')

function Module:onLoad()
  self:logInfo('load');
  self:regCallback('ItemString', Func.bind(self.summon, self),"LUA_useEasyPet");
  self.easyPetNPC = self:NPC_createNormal('簡單寵物召喚師', 14682, { x = 66, y = 66, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.easyPetNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local msg = "\\n@c【五芒星召喚陣】" ..	"\\n\\n只要動動手指簡單的輸入形象編號\\n\\n就可以召喚出你的專屬魔物夥伴\\n\\n\\n請輸入形象編號：";	
        NLG.ShowWindowTalked(player, self.easyPetNPC, CONST.窗口_输入框, CONST.按钮_确定关闭, 1, msg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.easyPetNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select > 0 then
      if seqno == 1 and Char.PetNum(player)==5 and select == CONST.按钮_确定 then
                 NLG.SystemMessage(player,"[系統]寵物欄位置已滿。");
                 return;
      elseif seqno == 1 and Char.HavePet(player, 500009)>0 and select == CONST.按钮_确定 then
                 NLG.SystemMessage(player,"[系統]寵物欄不能有其他召喚寵。");
                 return;
      elseif seqno == 1 and select == CONST.按钮_确定 then
                 PetImage = tonumber("".._data.."")
                 local msg = "\\n@c【五芒星召喚陣】" ..	"\\n\\n\\n選『是』召喚攻寵35/55/20/30/10\\n\\n\\n選『否』召喚魔寵20/10/30/35/55\\n\\n";	
                 NLG.ShowWindowTalked(player, self.easyPetNPC, CONST.窗口_信息框, CONST.按钮_是否, 11, msg);
      end
      if seqno == 11 and select == CONST.按钮_是 then
          if (PetImage > 0) then
                 Char.AddPet(player,500009);
                 local Slot = Char.HavePet(player, 500009);
                 local PetIndex = Char.GetPet(player, Slot);
                 Pet.SetArtRank(PetIndex,CONST.PET_体成,35 - math.random(0,1));  --自定义分布后随机掉檔0~4
                 Pet.SetArtRank(PetIndex,CONST.PET_力成,55 - math.random(0,1));
                 Pet.SetArtRank(PetIndex,CONST.PET_强成,20 - math.random(0,1));
                 Pet.SetArtRank(PetIndex,CONST.PET_敏成,30 - math.random(0,1));
                 Pet.SetArtRank(PetIndex,CONST.PET_魔成,10 - math.random(0,1));
                 Pet.ReBirth(player,PetIndex);
                 Char.SetData(PetIndex,CONST.对象_必杀,0);
                 Char.SetData(PetIndex,CONST.对象_反击,0);
                 Char.SetData(PetIndex,CONST.对象_命中,0);
                 Char.SetData(PetIndex,CONST.对象_闪躲,0);
                 Char.SetData(PetIndex,CONST.对象_地属性,30);
                 Char.SetData(PetIndex,CONST.对象_水属性,30);
                 Char.SetData(PetIndex,CONST.对象_火属性,30);
                 Char.SetData(PetIndex,CONST.对象_风属性,30);
                 Char.SetData(PetIndex,CONST.对象_抗毒,100);
                 Char.SetData(PetIndex,CONST.对象_抗睡,100);
                 Char.SetData(PetIndex,CONST.对象_抗石,100);
                 Char.SetData(PetIndex,CONST.对象_抗醉,100);
                 Char.SetData(PetIndex,CONST.对象_抗乱,100);
                 Char.SetData(PetIndex,CONST.对象_抗忘,100);
                 Char.SetData(PetIndex,CONST.对象_形象,PetImage);
                 Char.SetData(PetIndex,CONST.对象_原形,PetImage);
                 Char.SetData(PetIndex,CONST.对象_名字,"攻擊型試作魔物");
                 Char.SetData(PetIndex,CONST.对象_名色,6);             --自定义宠物为红色名字
                 Pet.UpPet(player,PetIndex)
                 Char.DelItem(player,ItemID,1);
                 NLG.SystemMessage(player, "[系统]召喚魔物儀式完美結束。")
          else
                 NLG.SystemMessage(player,"[系統]輸入的形象編號不符合格式。");
                 return;
          end
      elseif seqno == 11 and select == CONST.按钮_否 then
          if (PetImage > 0) then
                 Char.AddPet(player,500009);
                 local Slot = Char.HavePet(player, 500009);
                 local PetIndex = Char.GetPet(player, Slot);
                 Pet.SetArtRank(PetIndex,CONST.PET_体成,20 - math.random(0,1));  --自定义分布后随机掉檔0~4
                 Pet.SetArtRank(PetIndex,CONST.PET_力成,10 - math.random(0,1));
                 Pet.SetArtRank(PetIndex,CONST.PET_强成,30 - math.random(0,1));
                 Pet.SetArtRank(PetIndex,CONST.PET_敏成,35 - math.random(0,1));
                 Pet.SetArtRank(PetIndex,CONST.PET_魔成,55 - math.random(0,1));
                 Pet.ReBirth(player,PetIndex);
                 Char.SetData(PetIndex,CONST.对象_必杀,0);
                 Char.SetData(PetIndex,CONST.对象_反击,0);
                 Char.SetData(PetIndex,CONST.对象_命中,0);
                 Char.SetData(PetIndex,CONST.对象_闪躲,0);
                 Char.SetData(PetIndex,CONST.对象_地属性,30);
                 Char.SetData(PetIndex,CONST.对象_水属性,30);
                 Char.SetData(PetIndex,CONST.对象_火属性,30);
                 Char.SetData(PetIndex,CONST.对象_风属性,30);
                 Char.SetData(PetIndex,CONST.对象_抗毒,100);
                 Char.SetData(PetIndex,CONST.对象_抗睡,100);
                 Char.SetData(PetIndex,CONST.对象_抗石,100);
                 Char.SetData(PetIndex,CONST.对象_抗醉,100);
                 Char.SetData(PetIndex,CONST.对象_抗乱,100);
                 Char.SetData(PetIndex,CONST.对象_抗忘,100);
                 Char.SetData(PetIndex,CONST.对象_形象,PetImage);
                 Char.SetData(PetIndex,CONST.对象_原形,PetImage);
                 Char.SetData(PetIndex,CONST.对象_名字,"魔法型試作魔物");
                 Char.SetData(PetIndex,CONST.对象_名色,6);             --自定义宠物为红色名字
                 Pet.UpPet(player,PetIndex)
                 Char.DelItem(player,ItemID,1);
                 NLG.SystemMessage(player, "[系统]召喚魔物儀式完美結束。")
          else
                 NLG.SystemMessage(player,"[系統]輸入的形象編號不符合格式。");
                 return;
          end
      else
                 return;
      end

    end
  end)


end


function Module:summon(charIndex,targetIndex,itemSlot)
    ItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    local msg = "\\n@c【五芒星召喚陣】" ..	"\\n\\n只要動動手指簡單的輸入形象編號\\n\\n就可以召喚出你的專屬魔物夥伴\\n\\n\\n請輸入形象編號：";	
    NLG.ShowWindowTalked(charIndex, self.easyPetNPC, CONST.窗口_输入框, CONST.按钮_确定关闭, 1, msg);
    return 1;
end

function Module:onUnload()
  self:logInfo('unload')
end

return Module;
