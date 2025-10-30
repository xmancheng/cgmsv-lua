---ģ����
local Module = ModuleBase:createModule('strAddEffect')

local Affixes = {"��Դ","�p��","����","���","��â","����","����","�˷�","�ŭh","�K��",}

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('ItemString', Func.bind(self.RuneStone, self),"LUA_useRune");
  self.runeNPC = self:NPC_createNormal('����ʯ��ħ', 14682, { x = 36, y = 33, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.runeNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
    local msg = "\\n@c������ʯ��ħ��\\n"
              .."\\n�������b��������M�и�ħ"
              .."\\n�����}ʹ�÷��ęC��ʹ������+1��+10"
              .."\\n�K��������Ӱٷֱ�1��10����";	
         NLG.ShowWindowTalked(player, self.runeNPC, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 1, msg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.runeNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local stoneItemID = ItemID;
    local WeaponIndex,slot,type = Char.GetWeapon(player);                --������
    if select > 0 then
      if seqno == 1 and select == CONST.��ť_�ر� then
          return;
      end
      if seqno == 1 and select == CONST.��ť_ȷ�� then
          if (WeaponIndex<0) then
              NLG.SystemMessage(player, "[ϵ�y]δ�b���κ�������");
              return;
          elseif (WeaponIndex>0) then
              local Weapon_Name = Item.GetData(WeaponIndex, CONST.����_����);
              local StrAdd = 0;
		      if Weapon_Name~=nil then
			      local StrPlus = string.find(Weapon_Name, "��");
			      if StrPlus~=nil then
				    --StrAdd = tonumber(string.sub(Weapon_Name, StrPlus+1, -1));
				    Entry = string.sub(Weapon_Name, StrPlus+2, -1);
		            StrAdd = swtich(Entry);
			      end
		      end
              if (StrAdd>=10) then
                  NLG.SystemMessage(player, "[ϵ�y]�����ѽ������+10���ޣ�");
                  return;
              elseif (StrAdd==0) then
                  Item.SetData(WeaponIndex,CONST.����_��ǰ��, Item.GetData(WeaponIndex,CONST.����_����));
                  Item.UpItem(player,slot);
              end
              Char.DelItem(player, stoneItemID,1);
              local scrollRateTable ={0,10,30,50,69,79,84,89,94,97,100}		--�������10,20,20,19,10,5,5,5,3,3
              local SRate = math.random(1,100);
              for k=1,10 do
                if (SRate>scrollRateTable[k] and SRate<=scrollRateTable[k+1]) then
                  --Item.SetData(WeaponIndex,CONST.����_Explanation1, 7000211);
                  Item.SetData(WeaponIndex,CONST.����_����, Item.GetData(WeaponIndex,CONST.����_��ǰ��).."��"..Affixes[tonumber(k)]);
                  NLG.SystemMessage(player, "[ϵ�y]���ĸ�ħ�Y��: "..Item.GetData(WeaponIndex,CONST.����_��ǰ��).."��"..Affixes[tonumber(k)].."��");
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
    local msg = "\\n@c������ʯ��ħ��\\n"
              .."\\n�������b��������M�и�ħ"
              .."\\n�����}ʹ�÷��ęC��ʹ������+1��+10"
              .."\\n�K��������Ӱٷֱ�1��10����";	
    NLG.ShowWindowTalked(charIndex, self.runeNPC, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 1, msg);
    return 1;
end


function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
	--self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	--print(charIndex)
	if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
		leader = leader2
	end
	if flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.GetData(charIndex, CONST.CHAR_����) == CONST.��������_��  then
		local WeaponIndex,slot,type = Char.GetWeapon(charIndex);                --������
		if (WeaponIndex>0) then Weapon_Name = Item.GetData(WeaponIndex, CONST.����_����); end
		local StrAdd = 0;
		if Weapon_Name~=nil then
			local StrPlus = string.find(Weapon_Name, "��");
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
			--NLG.Say(charIndex,-1,"��������Ч��ÿ+1��������1%��Ŀǰ����"..(StrAdd*1).."%",4,3);
			--print(damage)
			return damage;
		end
		return damage;
	elseif flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.GetData(defCharIndex, CONST.CHAR_����) == CONST.��������_��  then
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


--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
