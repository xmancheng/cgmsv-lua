local Module = ModuleBase:createModule('manaPool')
local _ = require "lua/Modules/underscore"
local itemList = {
  { name = 'Ѫ���a�䣨1000LP��', image = 27243, price = 1500, desc = '�a��Ѫ��ʹ����1000�c', count = 1, maxCount = 999, value = 1000, type = 'lp' },
  { name = 'Ѫ���a�䣨10000LP��', image = 27243, price = 14500, desc = '�a��Ѫ��ʹ����10000�c', count = 1, maxCount = 999, value = 10000, type = 'lp' },
  { name = 'Ѫ���a�䣨50000LP��', image = 27243, price = 70000, desc = '�a��Ѫ��ʹ����50000�c', count = 1, maxCount = 999, value = 50000, type = 'lp' },
  { name = 'ħ���a�䣨1000FP��', image = 26206, price = 1700, desc = '�a��ħ��ʹ����1000�c', count = 1, maxCount = 999, value = 1000, type = 'fp' },
  { name = 'ħ���a�䣨10000FP��', image = 26206, price = 16500, desc = '�a��ħ��ʹ����10000�c', count = 1, maxCount = 999, value = 10000, type = 'fp' },
  { name = 'ħ���a�䣨50000FP��', image = 26206, price = 80000, desc = '�a��ħ��ʹ����50000�c', count = 1, maxCount = 999, value = 50000, type = 'fp' },
}

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  local npc = self:NPC_createNormal('Ѫħ���a��T', 99262,{ map=777, x=33, y=34, direction=0, mapType=0})
  self:NPC_regTalkedEvent(npc, Func.bind(self.onSellerTalked, self))
  self:NPC_regWindowTalkedEvent(npc, Func.bind(self.onSellerSelected, self));
  --self:regCallback('BattleStartEvent', Func.bind(self.onbattleStartEventCallback, self))
  --self:regCallback('ResetCharaBattleStateEvent', Func.bind(self.onBattleReset, self))
  self:regCallback('BattleOverEvent', Func.bind(self.onBattleOver, self))
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self))

  self.manaPoolNPC = self:NPC_createNormal('Ѫħ�ع���T', 99262,{ map=777, x=34, y=34, direction=0, mapType=0})
  self:NPC_regWindowTalkedEvent(self.manaPoolNPC,Func.bind(self.click,self))
  self:NPC_regTalkedEvent(self.manaPoolNPC,Func.bind(self.facetonpc,self))
end

--Զ�̰�ťUI����
function Module:manaPoolInfo(npc, player)
		local LpFpSet = Field.Get(player, 'LpFpSet');
		local part = string.split(LpFpSet, ',');
		local setLp_c=nil; local setFp_c=nil; local setLp_p=nil; local setFp_p=nil;
		for k,v in ipairs(part) do
			if k==1 then
				setLp_c=tonumber(v)
			elseif k==2 then
				setFp_c=tonumber(v)
			elseif k==3 then
 				setLp_p=tonumber(v)
			elseif k==4 then
				setFp_p=tonumber(v)
			end
		end
		if (setLp_c==nil or setFp_c==nil or setLp_p==nil or setFp_p==nil) then
			Field.Set(player, 'LpFpSet', tostring("100,100,100,100"));
		end
		local LpFpSet = Field.Get(player, 'LpFpSet');
		local part = string.split(LpFpSet, ',');
		for k,v in ipairs(part) do
			if k==1 then
				setLp_c=tonumber(v)
			elseif k==2 then
				setFp_c=tonumber(v)
			elseif k==3 then
 				setLp_p=tonumber(v)
			elseif k==4 then
				setFp_p=tonumber(v)
			end
		end
		local lpPool = tonumber(Field.Get(player, 'LpPool')) or 0;
		local fpPool = tonumber(Field.Get(player, 'FpPool')) or 0;
		local maxLp_Limit = Char.GetData(player, CONST.CHAR_���Ѫ)*30;
		local maxFp_Limit = Char.GetData(player, CONST.CHAR_���ħ)*30;
		local msg = "5\\n������������������Ѫħ�ؿ��YӍ��\\n"
					.. "����ݔ��ָ��/add����Ʒ��[����ˎˮ]ȫ��ע��\\n"
					.. "�����ȼ��D�Q%:45,50,55,60,65,70,75,80,85,90\\n"
					.. "����Ѫ�ع�:"..lpPool.."/"..maxLp_Limit..",ħ�ع�:"..fpPool.."/"..maxFp_Limit.."\\n\\n"
					.. "���������O������֏͡�Ѫ��:" ..setLp_c.. "%\\n"
					.. "���������O������֏͡�ħ��:" ..setFp_c.. "%\\n"
					.. "���������O�Ì���֏͡�Ѫ��:" ..setLp_p.. "%\\n"
					.. "���������O�Ì���֏͡�ħ��:" ..setFp_p.. "%\\n"
		NLG.ShowWindowTalked(player, self.manaPoolNPC, CONST.����_ѡ���, CONST.��ť_�ر�, 1, msg);
end

function Module:click(npc,player,_seqno,_select,_data)--�����е������
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
	local LpFpSet = Field.Get(player, 'LpFpSet');
	local part = string.split(LpFpSet, ',');
	for k,v in ipairs(part) do
		if k==1 then
			setLp_c=tonumber(v)
		elseif k==2 then
			setFp_c=tonumber(v)
		elseif k==3 then
 			setLp_p=tonumber(v)
		elseif k==4 then
			setFp_p=tonumber(v)
		end
	end
	--��ҳ16 ��ҳ32 ȡ��2
	if select > 0 then
		if (seqno == 1 and select == CONST.��ť_�ر�) then
			return;
		elseif (select == CONST.��ť_��) then
			return;
		elseif (seqno == 11 and select == CONST.��ť_�� and data >= 0) then
			if (math.ceil(data)==data and data<=100) then
				Field.Set(player, 'LpFpSet', tostring(""..data..","..setFp_c..","..setLp_p..","..setFp_p..""));
				NLG.SystemMessage(player, '[Ѫħ��]���� Ѫ��:' ..data.. '%,ħ��:' ..setFp_c.. '%������ Ѫ��:' ..setLp_p.. '%,ħ��:' ..setFp_p.. '%��');
			end
		elseif (seqno == 12 and select == CONST.��ť_�� and data >= 0) then
			if (math.ceil(data)==data and data<=100) then
				Field.Set(player, 'LpFpSet', tostring(""..setLp_c..","..data..","..setLp_p..","..setFp_p..""));
				NLG.SystemMessage(player, '[Ѫħ��]���� Ѫ��:' ..setLp_c.. '%,ħ��:' ..data.. '%������ Ѫ��:' ..setLp_p.. '%,ħ��:' ..setFp_p.. '%��');
			end
		elseif (seqno == 13 and select == CONST.��ť_�� and data >= 0) then
			if (math.ceil(data)==data and data<=100) then
				Field.Set(player, 'LpFpSet', tostring(""..setLp_c..","..setFp_c..","..data..","..setFp_p..""));
				NLG.SystemMessage(player, '[Ѫħ��]���� Ѫ��:' ..setLp_c.. '%,ħ��:' ..setFp_c.. '%������ Ѫ��:' ..data.. '%,ħ��:' ..setFp_p.. '%��');
			end
		elseif (seqno == 14 and select == CONST.��ť_�� and data >= 0) then
			if (math.ceil(data)==data and data<=100) then
				Field.Set(player, 'LpFpSet', tostring(""..setLp_c..","..setFp_c..","..setLp_p..","..data..""));
				NLG.SystemMessage(player, '[Ѫħ��]���� Ѫ��:' ..setLp_c.. '%,ħ��:' ..setFp_c.. '%������ Ѫ��:' ..setLp_p.. '%,ħ��:' ..data.. '%��');
			end
		end
	else
		if (data==1) then
			local winMsg = "����������������$1��Ѫħ�ػ֏��O�á�\\n"
				.."�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
				.."����$4����Ѫ��$0��춶��ٰٷֱȆ����Ԅӻ֏�\\n\\n"
				.."����ݔ��0�t$5�P�]$0�Ԅӻ֏�����Ѫ��\\n\\n"
				.."\\n"
				.."\\nՈ�_�Jݔ��֮�ٷֱȣ�\\n";
			NLG.ShowWindowTalked(player, self.manaPoolNPC, CONST.����_�����, CONST.��ť_�Ƿ�, 11, winMsg);
		elseif (data==2) then
			local winMsg = "����������������$1��Ѫħ�ػ֏��O�á�\\n"
				.."�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
				.."����$4����ħ��$0��춶��ٰٷֱȆ����Ԅӻ֏�\\n\\n"
				.."����ݔ��0�t$5�P�]$0�Ԅӻ֏�����ħ��\\n\\n"
				.."\\n"
				.."\\nՈ�_�Jݔ��֮�ٷֱȣ�\\n";
			NLG.ShowWindowTalked(player, self.manaPoolNPC, CONST.����_�����, CONST.��ť_�Ƿ�, 12, winMsg);
		elseif (data==3) then
			local winMsg = "����������������$1��Ѫħ�ػ֏��O�á�\\n"
				.."�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
				.."����$4����Ѫ��$0��춶��ٰٷֱȆ����Ԅӻ֏�\\n\\n"
				.."����ݔ��0�t$5�P�]$0�Ԅӻ֏͌���Ѫ��\\n\\n"
				.."\\n"
				.."\\nՈ�_�Jݔ��֮�ٷֱȣ�\\n";
			NLG.ShowWindowTalked(player, self.manaPoolNPC, CONST.����_�����, CONST.��ť_�Ƿ�, 13, winMsg);
		elseif (data==4) then
			local winMsg = "����������������$1��Ѫħ�ػ֏��O�á�\\n"
				.."�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
				.."����$4����ħ��$0��춶��ٰٷֱȆ����Ԅӻ֏�\\n\\n"
				.."����ݔ��0�t$5�P�]$0�Ԅӻ֏͌���ħ��\\n\\n"
				.."\\n"
				.."\\nՈ�_�Jݔ��֮�ٷֱȣ�\\n";
			NLG.ShowWindowTalked(player, self.manaPoolNPC, CONST.����_�����, CONST.��ť_�Ƿ�, 14, winMsg);
		end
	end
end

function Module:facetonpc(npc,player)
	if NLG.CanTalk(npc,player) == true then
		local LpFpSet = Field.Get(player, 'LpFpSet');
		local part = string.split(LpFpSet, ',');
		local setLp_c=nil; local setFp_c=nil; local setLp_p=nil; local setFp_p=nil;
		for k,v in ipairs(part) do
			if k==1 then
				setLp_c=tonumber(v)
			elseif k==2 then
				setFp_c=tonumber(v)
			elseif k==3 then
 				setLp_p=tonumber(v)
			elseif k==4 then
				setFp_p=tonumber(v)
			end
		end
		if (setLp_c==nil or setFp_c==nil or setLp_p==nil or setFp_p==nil) then
			Field.Set(player, 'LpFpSet', tostring("100,100,100,100"));
		end
		local LpFpSet = Field.Get(player, 'LpFpSet');
		local part = string.split(LpFpSet, ',');
		for k,v in ipairs(part) do
			if k==1 then
				setLp_c=tonumber(v)
			elseif k==2 then
				setFp_c=tonumber(v)
			elseif k==3 then
 				setLp_p=tonumber(v)
			elseif k==4 then
				setFp_p=tonumber(v)
			end
		end
		local lpPool = tonumber(Field.Get(player, 'LpPool')) or 0;
		local fpPool = tonumber(Field.Get(player, 'FpPool')) or 0;
		local maxLp_Limit = Char.GetData(player, CONST.CHAR_���Ѫ)*30;
		local maxFp_Limit = Char.GetData(player, CONST.CHAR_���ħ)*30;
		local msg = "5\\n������������������Ѫħ�ؿ��YӍ��\\n"
					.. "����ݔ��ָ��/add����Ʒ��[����ˎˮ]ȫ��ע��\\n"
					.. "�����ȼ��D�Q%:45,50,55,60,65,70,75,80,85,90\\n"
					.. "����Ѫ�ع�:"..lpPool.."/"..maxLp_Limit..",ħ�ع�:"..fpPool.."/"..maxFp_Limit.."\\n\\n"
					.. "���������O������֏͡�Ѫ��:" ..setLp_c.. "%\\n"
					.. "���������O������֏͡�ħ��:" ..setFp_c.. "%\\n"
					.. "���������O�Ì���֏͡�Ѫ��:" ..setLp_p.. "%\\n"
					.. "���������O�Ì���֏͡�ħ��:" ..setFp_p.. "%\\n"
		NLG.ShowWindowTalked(player, self.manaPoolNPC, CONST.����_ѡ���, CONST.��ť_�ر�, 1, msg);
	end
	return
end

local Item_SHM_Lv = {45, 50, 55, 60, 65, 70, 75, 80, 85, 90}	--ҩˮ������ע��ٷֱ�

function Module:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="/add") then
		--local maxLp_Limit = Char.GetData(charIndex, CONST.CHAR_���Ѫ)*30;
		--local maxFp_Limit = Char.GetData(charIndex, CONST.CHAR_���ħ)*30;
		for slot=7,27 do
			local lpPool = tonumber(Field.Get(charIndex, 'LpPool')) or 0;
			local fpPool = tonumber(Field.Get(charIndex, 'FpPool')) or 0;
			local ItemIndex = Char.GetItemIndex(charIndex, slot);
			if (ItemIndex>0) then
				local itemType = Item.GetData(ItemIndex,CONST.����_����);
				local itemLv = Item.GetData(ItemIndex,CONST.����_�ȼ�);
				local ItemNum = tonumber(Item.GetData(ItemIndex,CONST.����_�ѵ���));
				if (itemType==43) then	--ҩƷ
					local Item_LV = (Item_SHM_Lv[itemLv] or 100)/100;
					local msg1 = Item.GetData(ItemIndex,CONST.����_���ò���);
					local val1,val2 = string.find(msg1,"LP");
					local msg_Lp = string.sub(msg1,val2+1,-1);
					local Lp1 = tonumber(msg_Lp) or 0;
					local totalLp = math.floor(Item_LV * Lp1 * ItemNum);
					Field.Set(charIndex, 'LpPool', tostring(lpPool + totalLp));
					Char.DelItemBySlot(charIndex, slot);
					NLG.UpChar(charIndex);	
				elseif (itemType==23) then	--����
					local Item_LV = (Item_SHM_Lv[itemLv] or 100)/100;
					local msg1 = Item.GetData(ItemIndex,CONST.����_���ò���);
					local val3,val4 = string.find(msg1,"FP");
					local msg_Fp = string.sub(msg1,val4+1,-1);
					local Fp1 = tonumber(msg_Fp) or 0;
					local totalFp = math.floor(Item_LV * Fp1 * ItemNum);
					Field.Set(charIndex, 'FpPool', tostring(fpPool + totalFp));
					Char.DelItemBySlot(charIndex, slot);
					NLG.UpChar(charIndex);
				end
			end
		end
		local lpPool = tonumber(Field.Get(charIndex, 'LpPool')) or 0;
		local fpPool = tonumber(Field.Get(charIndex, 'FpPool')) or 0;
		NLG.SystemMessage(charIndex, '[Ѫħ��] Ѫ�ع�: ' .. lpPool .. ', ħ�ع�: ' .. fpPool .. '��');
		return 0;
	elseif (msg=="/shm" or msg=="/SHM" ) then
		local lpPool = tonumber(Field.Get(charIndex, 'LpPool')) or 0;
		local fpPool = tonumber(Field.Get(charIndex, 'FpPool')) or 0;
		local maxLp_Limit = Char.GetData(charIndex, CONST.CHAR_���Ѫ)*30;
		local maxFp_Limit = Char.GetData(charIndex, CONST.CHAR_���ħ)*30;
		NLG.SystemMessage(charIndex, '[Ѫħ��] Ѫ�ع�: ' .. lpPool .. '/'..maxLp_Limit..', ħ�ع�: ' .. fpPool .. '/'..maxFp_Limit..'��');
		NLG.UpChar(charIndex);
		return 0;
	elseif check_msg(msg,"/shm ") then
		local value= string.find(msg,"%s");
		local LpFpSet = string.sub(msg,value+1);
		--print(LpFpSet)
		local part = string.split(LpFpSet, ',');
		local setLp_c=nil; local setFp_c=nil; local setLp_p=nil; local setFp_p=nil;
		for k,v in ipairs(part) do
			if k==1 then
				setLp_c=tonumber(v)
			elseif k==2 then
				setFp_c=tonumber(v)
			elseif k==3 then
 				setLp_p=tonumber(v)
			elseif k==4 then
				setFp_p=tonumber(v)
			end
		end
		if (setLp_c==nil or setFp_c==nil or setLp_p==nil or setFp_p==nil) then
			NLG.SystemMessage(charIndex, '�O����ʽ�e�`������: /shm 20,20,20,20');
			Field.Set(charIndex, 'LpFpSet', tostring("100,100,100,100"));
			return 0;
		else			
			NLG.SystemMessage(charIndex, '[Ѫħ��]���� Ѫ��:' ..setLp_c.. '%,ħ��:' ..setFp_c.. '%������ Ѫ��:' ..setLp_p.. '%,ħ��:' ..setFp_p.. '%��');
			Field.Set(charIndex, 'LpFpSet', tostring(LpFpSet));
			return 0;
		end
	end
	return 1;
end
function check_msg(msg,check_msg)
	if(msg == nil) then
		return;
	end

   if(string.sub(msg,1,string.len(check_msg))==check_msg)then
		return true;
   end
   return false;
end

function Module:onBattleOver(battleIndex)
  local poss={}
  for i = 0, 9 do
    table.insert(poss,i)
  end

 _.each(poss,function(pos) 
  local charIndex = Battle.GetPlayer(battleIndex, pos);
  if Char.IsDummy(charIndex) then
    return
  end
  local name = Char.GetData(charIndex,CONST.CHAR_����);
  local lpPool = tonumber(Field.Get(charIndex, 'LpPool')) or 0;
  local fpPool = tonumber(Field.Get(charIndex, 'FpPool')) or 0;
  if lpPool <= 0 and fpPool <= 0 then
    --NLG.SystemMessage(charIndex, '[Ѫħ��] ʣ�N�������㣬Ո���r�a�䡣');
    return
  end

  local LpFpSet = tostring(Field.Get(charIndex, 'LpFpSet')) or 0;
  local setLp_c=100; local setFp_c=100; local setLp_p=100; local setFp_p=100;
  if (type(LpFpSet)=="string") then
      local part = string.split(LpFpSet, ',');
      for k,v in ipairs(part) do
          if k==1 then
              setLp_c=tonumber(v)
          elseif k==2 then
              setFp_c=tonumber(v)
          elseif k==3 then
              setLp_p=tonumber(v)
          elseif k==4 then
              setFp_p=tonumber(v)
          end
      end
  else
      if (setLp_c==nil or setFp_c==nil or setLp_p==nil or setFp_p==nil) then
        Field.Set(charIndex, 'LpFpSet', tostring("100,100,100,100"));
        setLp_c=100;        setFp_c=100;        setLp_p=100;        setFp_p=100;
      end
  end

  local lp = Char.GetData(charIndex, CONST.CHAR_Ѫ)
  local maxLp = Char.GetData(charIndex, CONST.CHAR_���Ѫ)
  local fp = Char.GetData(charIndex, CONST.CHAR_ħ)
  local maxFp = Char.GetData(charIndex, CONST.CHAR_���ħ)
  if lpPool > 0 and lp < math.floor(maxLp*setLp_c/100) then
    if Char.GetData(charIndex,%����_��ӿ���%) == 1 then
      lpPool = lpPool - maxLp + lp;
      if lpPool < 0 then
        maxLp = maxLp + lpPool;
        lpPool = 0;
      end
    else
      maxLp = lp;
    end
    if Char.GetData(charIndex,%����_���Ŀ���%) == 1 then
        NLG.SystemMessage(charIndex, '[Ѫħ��] �ў�'..name..'�֏�: ' .. (maxLp - lp) .. 'LP, Ѫ��ʣ�N: ' .. lpPool);
    end
  else
    maxLp = lp;
  end

  if fpPool > 0 and fp < math.floor(maxFp*setFp_c/100) then
    if Char.GetData(charIndex,%����_��ӿ���%) == 1 then
      fpPool = fpPool - maxFp + fp;
      if fpPool < 0 then
        maxFp = maxFp + fpPool;
        fpPool = 0;
      end
    else
      maxFp = fp;
    end
    if Char.GetData(charIndex,%����_���Ŀ���%) == 1 then
        NLG.SystemMessage(charIndex, '[Ѫħ��] �ў�'..name..'�֏�: ' .. (maxFp - fp) .. 'FP, ħ��ʣ�N: ' .. fpPool);
    end
  else
    maxFp = fp;
  end

  Char.SetData(charIndex, CONST.CHAR_Ѫ, maxLp)
  Char.SetData(charIndex, CONST.CHAR_ħ, maxFp)
  NLG.UpChar(charIndex);

  local petIndex = Char.GetData(charIndex, CONST.CHAR_ս��);
  if petIndex >= 0 then
    petIndex = Char.GetPet(charIndex, petIndex);
    lp = Char.GetData(petIndex, CONST.CHAR_Ѫ)
    maxLp = Char.GetData(petIndex, CONST.CHAR_���Ѫ)
    fp = Char.GetData(petIndex, CONST.CHAR_ħ)
    maxFp = Char.GetData(petIndex, CONST.CHAR_���ħ)
    if lpPool > 0 and lp < math.floor(maxLp*setLp_p/100) then
      if Char.GetData(charIndex,%����_��ӿ���%) == 1 then
        lpPool = lpPool - maxLp + lp;
        if lpPool < 0 then
          maxLp = maxLp + lpPool;
          lpPool = 0;
        end
      else
        maxLp = lp;
      end
      if Char.GetData(charIndex,%����_���Ŀ���%) == 1 then
          NLG.SystemMessage(charIndex, '[Ѫħ��] �ѻ֏͌���: ' .. (maxLp - lp) .. 'LP, Ѫ��ʣ�N: ' .. lpPool);
      end
    else
      maxLp = lp;
    end

    if fpPool > 0 and fp < math.floor(maxFp*setFp_p/100) then
      if Char.GetData(charIndex,%����_��ӿ���%) == 1  then
        fpPool = fpPool - maxFp + fp;
        if fpPool < 0 then
          maxFp = maxFp + fpPool;
          fpPool = 0;
        end
      else
        maxFp = fp;
      end
      if Char.GetData(charIndex,%����_���Ŀ���%) == 1 then
          NLG.SystemMessage(charIndex, '[Ѫħ��] �ѻ֏͌���: ' .. (maxFp - fp) .. 'FP, ħ��ʣ�N: ' .. fpPool);
      end
    else
      maxFp = fp;
    end

    Char.SetData(petIndex, CONST.CHAR_Ѫ, maxLp)
    Char.SetData(petIndex, CONST.CHAR_ħ, maxFp)
    NLG.UpChar(petIndex);
  end

  Field.Set(charIndex, 'LpPool', tostring(lpPool));
  Field.Set(charIndex, 'FpPool', tostring(fpPool));

  end)
end

function Module:onSellerTalked(npc, player)
  if NLG.CanTalk(npc, player) then
    NLG.ShowWindowTalked(player, npc, CONST.����_�̵���, CONST.BUTTON_��, 0,
      self:NPC_buildBuyWindowData(101024, 'Ѫħ���a��', '��ֵѪħ��', '���X����', '�����ѝM', itemList))
  end
end

function Module:onSellerSelected(npc, player, seqNo, select, data)
  local items = string.split(data, '|');
  local lpPool = tonumber(Field.Get(player, 'LpPool')) or 0;
  local fpPool = tonumber(Field.Get(player, 'FpPool')) or 0;
  local gold = Char.GetData(player, CONST.CHAR_���)
  local totalGold = 0;
  local totalLp = 0;
  local totalFp = 0;
  for i = 1, #items / 2 do
    local c = itemList[items[(i - 1) * 2 + 1] + 1]
    if c then
      local count = (tonumber(items[(i - 1) * 2 + 2]) or 0);
      if c.type == 'lp' then
        totalLp = totalLp + c.value * count;
      else
        totalFp = totalFp + c.value * count;
      end
      totalGold = totalGold + c.price * count;
    end
  end
  maxLp_Limit = Char.GetData(player, CONST.CHAR_���Ѫ)*30;
  maxFp_Limit = Char.GetData(player, CONST.CHAR_���ħ)*30;
  if lpPool >= maxLp_Limit and fpPool >= maxFp_Limit then
    NLG.SystemMessage(player, 'Ѫ������:���ܳ��^'..maxLp_Limit..'��');
    NLG.SystemMessage(player, 'ħ������:���ܳ��^'..maxFp_Limit..'��');
    return
  elseif lpPool+totalLp >= maxLp_Limit and fpPool + totalFp >= maxFp_Limit then
    totalLp = (maxLp_Limit-lpPool);
    totalLpGold = (maxLp_Limit-lpPool)*1.5;
    if lpPool==maxLp_Limit then
        totalLp = 0;
        totalLpGold = 0;
    end
    totalFp = (maxFp_Limit-fpPool);
    totalFpGold = (maxFp_Limit-fpPool)*1.7;
    if fpPool==maxFp_Limit then
        totalFp = 0;
        totalFpGold = 0;
    end
    totalGold = totalLpGold+totalFpGold;
  elseif lpPool+totalLp >= maxLp_Limit and fpPool + totalFp < maxFp_Limit then
    totalLp = (maxLp_Limit-lpPool);
    totalLpGold = (maxLp_Limit-lpPool)*1.5;
    if lpPool==maxLp_Limit then
        totalLp = 0;
        totalLpGold = 0;
    end
    totalFp = totalFp;
    totalFpGold = totalFp*1.6;
    totalGold = totalLpGold+totalFpGold;
  elseif lpPool+totalLp < maxLp_Limit and fpPool + totalFp >= maxFp_Limit then
    totalLp = totalLp;
    totalLpGold = totalLp*1.4;
    totalFp = (maxFp_Limit-fpPool);
    totalFpGold = (maxFp_Limit-fpPool)*1.7;
    if fpPool==maxFp_Limit then
        totalFp = 0;
        totalFpGold = 0;
    end
    totalGold = totalLpGold+totalFpGold;
  end
  if gold < totalGold then
    NLG.SystemMessage(player, 'ُ�I���迂���~: '..totalGold..'������X����');
    return
  end
  Char.AddGold(player, -totalGold);
  Field.Set(player, 'LpPool', tostring(lpPool + totalLp));
  Field.Set(player, 'FpPool', tostring(fpPool + totalFp));
  NLG.UpChar(player);
  if totalLp > 0 then
    NLG.SystemMessage(player, '[Ѫħ��] �a��Ѫ��: ' .. totalLp .. ', ��: ' .. (lpPool + totalLp));
  end
  if totalFp > 0 then
    NLG.SystemMessage(player, '[Ѫħ��] �a��ħ��: ' .. totalFp .. ', ��: ' .. (fpPool + totalFp));
  end
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
