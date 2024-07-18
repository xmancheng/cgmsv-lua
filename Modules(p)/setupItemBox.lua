---Ä£¿éÀà
local Module = ModuleBase:createModule('setupItemBox')

local itemBox = {
    { boxItem_id=900504, boxItem_count=1},	--±¦Ïä¿É¿ª³öµÄµÀ¾ß±àºÅ¡¢µÀ¾ßÊıÁ¿
    { boxItem_id=900504, boxItem_count=3},
    { boxItem_id=900504, boxItem_count=5},
}

local enemyBox = {
    {606025, 50, 0,606026, 50, 0,606027, 50, 0},	-- id£¬µÈ¼¶£¬Ëæ»úµÈ¼¶£¬Àı×Ó£º{0, 100, 5, 1, 1, 0}Éú³É0ºÅ¹ÖÎï100-105¼¶£¬1ºÅ¹ÖÎï1¼¶
}
--- ¼ÓÔØÄ£¿é¹³×Ó
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('ItemBoxGenerateEvent', function(mapId, floor, itemBoxType, adm)
      local n = NLG.Rand(1, 100);
      -- 1% ºÚ±¦Ïä£¬1%°×±¦Ïä£¬ 98%ÆÕÍ¨±¦Ïä
      if n > 99 then
        return { 18003, adm }	--°×±¦Ïä
      end
      if n > 98 then
        return { 18004, adm }	--ºÚ±¦Ïä
      end
      return { 18002, adm }; 	--ÆÕÍ¨±¦Ïä
  end)

  self:regCallback('ItemBoxLootEvent', function(charIndex, mapId, floor, X, Y, boxType, adm)
      if (boxType==18002) then	--ÆÕÍ¨±¦Ïä
          local rand = NLG.Rand(1,#itemBox);
          Char.GiveItem(charIndex, itemBox[rand].boxItem_id, itemBox[rand].boxItem_count);
          local PartyNum = Char.PartyNum(charIndex);
          if (PartyNum>1) then
                    for Slot=1,4 do
                              local TeamPlayer = Char.GetPartyMember(charIndex,Slot);
                              if Char.IsDummy(TeamPlayer)==false then
                                        local rand = NLG.Rand(1,#itemBox);
                                       Char.GiveItem(TeamPlayer, itemBox[rand].boxItem_id, itemBox[rand].boxItem_count);
                              end
                    end
          end
          return 1;	-- ·µ»Ø1À¹½ØÄ¬ÈÏÎïÆ·, ·µ»Ø0²»À¹½Ø
      elseif (boxType==18003 or boxType==18004) then	--ºÚ±¦Ïä£¬°×±¦Ïä
          Char.GiveItem(charIndex, 900504, 50);
          local PartyNum = Char.PartyNum(charIndex);
          if (PartyNum>1) then
                    for Slot=1,4 do
                              local TeamPlayer = Char.GetPartyMember(charIndex,Slot);
                              if Char.IsDummy(TeamPlayer)==false then
                                       Char.GiveItem(TeamPlayer, 900504, 50);
                              end
                    end
          end
          return 1;
      end
      return 1;
  end)

  self:regCallback('ItemBoxEncountRateEvent', function(charIndex, mapId, floor, X, Y, itemIndex)
      local n = NLG.Rand(1, 100);
      if n > 70 then
          Rate = 100;
      elseif n <= 70 then
          Rate = 0;
      end
      return Rate;	--ÓöµĞ¸ÅÂÊ
  end)

  self:regCallback('ItemBoxEncountEvent', function(charIndex, mapId, floor, X, Y, itemIndex)
      local rand = NLG.Rand(1,#enemyBox);
      enemy_tbl = enemyBox[rand];
      return enemy_tbl;		--·µ»Ønil²»À¹½Ø
  end)

end

--- Ğ¶ÔØÄ£¿é¹³×Ó
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
