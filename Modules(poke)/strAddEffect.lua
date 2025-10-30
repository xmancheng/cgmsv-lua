---模块类
local Module = ModuleBase:createModule('strAddEffect')

local Affixes = {"初源","雙生","三相","方陣","五芒","六界","七曜","八方","九環","終律",}

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('ItemString', Func.bind(self.RuneStone, self),"LUA_useRune");
  self.runeNPC = self:NPC_createNormal('符文石附魔', 14682, { x = 36, y = 33, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.runeNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
    local msg = "\\n@c【符文石附魔】\\n"
              .."\\n對身上裝備的武器進行附魔"
              .."\\n可重複使用符文機率使得武器+1至+10"
              .."\\n並且玩家增加百分比1至10傷害";	
         NLG.ShowWindowTalked(player, self.runeNPC, CONST.窗口_信息框, CONST.按钮_确定关闭, 1, msg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.runeNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local stoneItemID = ItemID;
    local WeaponIndex,slot,type = Char.GetWeapon(player);                --左右手
    if select > 0 then
      if seqno == 1 and select == CONST.按钮_关闭 then
          return;
      end
      if seqno == 1 and select == CONST.按钮_确定 then
          if (WeaponIndex<0) then
              NLG.SystemMessage(player, "[系統]未裝備任何武器！");
              return;
          elseif (WeaponIndex>0) then
              local Weapon_Name = Item.GetData(WeaponIndex, CONST.道具_名字);
              local StrAdd = 0;
		      if Weapon_Name~=nil then
			      local StrPlus = string.find(Weapon_Name, "◎");
			      if StrPlus~=nil then
				    --StrAdd = tonumber(string.sub(Weapon_Name, StrPlus+1, -1));
				    Entry = string.sub(Weapon_Name, StrPlus+2, -1);
		            StrAdd = swtich(Entry);
			      end
		      end
              if (StrAdd>=10) then
                  NLG.SystemMessage(player, "[系統]武器已經是最高+10上限！");
                  return;
              elseif (StrAdd==0) then
                  Item.SetData(WeaponIndex,CONST.道具_鉴前名, Item.GetData(WeaponIndex,CONST.道具_名字));
                  Item.UpItem(player,slot);
              end
              Char.DelItem(player, stoneItemID,1);
              local scrollRateTable ={0,10,30,50,69,79,84,89,94,97,100}		--个别机率10,20,20,19,10,5,5,5,3,3
              local SRate = math.random(1,100);
              for k=1,10 do
                if (SRate>scrollRateTable[k] and SRate<=scrollRateTable[k+1]) then
                  --Item.SetData(WeaponIndex,CONST.道具_Explanation1, 7000211);
                  Item.SetData(WeaponIndex,CONST.道具_名字, Item.GetData(WeaponIndex,CONST.道具_鉴前名).."◎"..Affixes[tonumber(k)]);
                  NLG.SystemMessage(player, "[系統]符文附魔結果: "..Item.GetData(WeaponIndex,CONST.道具_鉴前名).."◎"..Affixes[tonumber(k)].."。");
                end
              end
              Item.UpItem(player,slot);
              NLG.UpChar(player);
          end
      end

    end
  end)


end


function Module:RuneStone(charIndex,targetIndex,itemSlot)
    ItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    StoneSlot = itemSlot;
    local msg = "\\n@c【符文石附魔】\\n"
              .."\\n對身上裝備的武器進行附魔"
              .."\\n可重複使用符文機率使得武器+1至+10"
              .."\\n並且玩家增加百分比1至10傷害";	
    NLG.ShowWindowTalked(charIndex, self.runeNPC, CONST.窗口_信息框, CONST.按钮_确定关闭, 1, msg);
    return 1;
end


function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
	--self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	--print(charIndex)
	if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
		leader = leader2
	end
	if flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_人  then
		local WeaponIndex,slot,type = Char.GetWeapon(charIndex);                --左右手
		if (WeaponIndex>0) then Weapon_Name = Item.GetData(WeaponIndex, CONST.道具_名字); end
		local StrAdd = 0;
		if Weapon_Name~=nil then
			local StrPlus = string.find(Weapon_Name, "◎");
			if StrPlus~=nil then
				--StrAdd = tonumber(string.sub(Weapon_Name, StrPlus+1, -1));
				Entry = string.sub(Weapon_Name, StrPlus+2, -1);
				StrAdd = swtich(Entry);
			end
		end
		if ( StrAdd >= 0 ) then
			local StrEffect = 1 + (StrAdd*0.01);
			--print(StrEffect)
			damage = damage * StrEffect;
			--NLG.Say(charIndex,-1,"武器符文效果每+1傷害提升1%，目前傷害"..(StrAdd*1).."%",4,3);
			--print(damage)
			return damage;
		end
		return damage;
	elseif flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.GetData(defCharIndex, CONST.CHAR_类型) == CONST.对象类型_人  then
		return damage;
	end
	return damage;
end

function swtich(Entry)
	for k,v in ipairs(Affixes) do
		--print(Entry,v)
		if (Entry==v) then
			return k;
		end
	end
	return 0;
end


--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
