local Module = ModuleBase:createModule('manaPool')
local _ = require "lua/Modules/underscore"
local itemList = {
  { name = 'Ѫ���a�䣨1000LP��', image = 27243, price = 1500, desc = '�a��Ѫ��ʹ����1000�c', count = 1, maxCount = 999, value = 1000, type = 'lp' },
  { name = 'Ѫ���a�䣨10000LP��', image = 27243, price = 14500, desc = '�a��Ѫ��ʹ����10000�c', count = 1, maxCount = 999, value = 10000, type = 'lp' },
  { name = 'Ѫ���a�䣨50000LP��', image = 27243, price = 70000, desc = '�a��Ѫ��ʹ����50000�c', count = 1, maxCount = 999, value = 50000, type = 'lp' },
  { name = 'ħ���a�䣨1000FP��', image = 26206, price = 1700, desc = '�a��ħ��ʹ����1000�c', count = 1, maxCount = 999, value = 1000, type = 'fp' },
  { name = 'ħ���a�䣨10000FP��', image = 26206, price = 17500, desc = '�a��ħ��ʹ����10000�c', count = 1, maxCount = 999, value = 10000, type = 'fp' },
  { name = 'ħ���a�䣨50000FP��', image = 26206, price = 87000, desc = '�a��ħ��ʹ����50000�c', count = 1, maxCount = 999, value = 50000, type = 'fp' },
  -- { name = '�ظ�������ף��', image = 494861, price = 10000, desc = 'Я��ʱ, ս��������ɫ�����ָ�200, ħ���ָ�200', count = 1, maxCount = 1, value = 100000, type = ''}
}

local �Զ���ħʯ = true
local soldrate=1
local maxMoney=10000000

-- ȫ�ֵ������
local itemSetting={
  -- {����id���������Сֵ����������ֵ�����1~1000}
  {60056,1,50}, --���������ʯ
  -- {20211055,950,980},
}


--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  local npc = self:NPC_createNormal('Ѫħ��', 99262, { x = 230, y = 58, mapType = 0, map = 1000, direction = 6 })
  self:NPC_regTalkedEvent(npc, Func.bind(self.onSellerTalked, self))
  self:NPC_regWindowTalkedEvent(npc, Func.bind(self.onSellerSelected, self));
  -- self:regCallback('BattleStartEvent', Func.bind(self.onBattleStart, self))
  self:regCallback('BattleOverEvent', Func.bind(self.onBattleOver, self))
end



function Module:onBattleOver(battleIndex)
  local poss={}
  for i = 0, 9 do
    table.insert(poss,i)
  end

  _.each(poss,function(pos) 
    local charIndex = Battle.GetPlayer(battleIndex, pos);

    if Char.GetData(charIndex,CONST.CHAR_����)~=CONST.��������_�� then
      return
    end

    NLG.SortItem(charIndex);
    
    if Char.IsDummy(charIndex) then
      return
    end

    -- ��ȡӶ��
    local campHeroesData = getModule('heroesFn'):getCampHeroesData(charIndex)
    -- ����Լ���Ѫħ
    self:heal(charIndex,charIndex)

    -- ��ҵ�Ӷ����Ѫħ
    for k,v in pairs(campHeroesData) do
      self:heal(charIndex,v.index)
      if Char.GetData(charIndex,%����_���׿���%) == 1 then
        self:clearBag(charIndex,v.index)
      end
      NLG.UpChar(v.index);
      Item.UpItem(v.index, -1);
    end

    if Char.GetData(charIndex,%����_���׿���%) == 1 then
      self:clearBag(charIndex,charIndex)
      NLG.Say(charIndex,-1,"�z�y�����_���˽��ף����Y������Ԅ������ꮅ��",1,3);
    end

      --��ʼ���� ����
    local randValue = NLG.Rand(1,1000);
    for i = 1,#itemSetting do
      local min= itemSetting[i][2]
      local max = itemSetting[i][3]
      local itemId = itemSetting[i][1]
      if randValue>=min and randValue<=max then
        itemIndex = Char.GiveItem(charIndex,itemId,1);
        if itemIndex<0 then
          --NLG.Say(charIndex,-1,"��������" ,CONST.��ɫ_��ɫ,0)
          return
        end
        Item.SetData( itemIndex , CONST.����_�Ѽ��� ,1)
        goto continue;
      end
      ::continue::
    end

    NLG.UpChar(charIndex);
    Item.UpItem(charIndex, -1);
  end)
end


function Module:clearBag(charIndex,targetIndex)
  
  for laji = 14801,15055 do--3.0ͼ��
    Char.DelItem(targetIndex,laji,1);
  end
  for laji2 = 606600,606691 do--7.0ͼ��
    Char.DelItem(targetIndex,laji2,99);
  end
  for laji3 = 18310,18313 do--ˮ����Ƭ
    Char.DelItem(targetIndex,laji3,99);
  end
  Char.DelItem(targetIndex,18194,99)--��ͷ��
  Char.DelItem(targetIndex,18195,99)--��ͷ��
  local price = 0
  local money = Char.GetData(charIndex, CONST.CHAR_���)
  for laji4 = 18005,18088 do--ħʯ
    if Char.HaveItem(targetIndex,laji4) > -1 then
      local msprice = Item.GetData(Char.HaveItem(targetIndex,laji4),%����_�۸�%)
      price = price + msprice
      Char.DelItem(targetIndex,laji4,1)
    end
  end
  if �Զ���ħʯ then
    local targetName = Char.GetData(targetIndex,CONST.CHAR_����)
    -- local soldrate = 20;  --20��
    local money1 = money+price*soldrate;
    if money1 <= maxMoney and price > 0 then
      Char.SetData(charIndex, CONST.CHAR_���, money1);
      NLG.SystemMessage(charIndex, targetName.."ħʯ���۳����@�á�" .. price*soldrate .. "��ħ�š�");
    elseif money1 > maxMoney then
      Char.SetData(charIndex, CONST.CHAR_���, maxMoney);
      NLG.SystemMessage(charIndex, "�X���M�ˣ�");
    end
  end
  --NLG.SortItem(player);
  -- Item.UpItem(player, -1);
  -- NLG.UpChar(player);
  
  
end

function Module:heal(charIndex,targetIndex)
  local name = Char.GetData(targetIndex,CONST.CHAR_����)
  local lpPool = tonumber(Field.Get(charIndex, 'LpPool')) or 0;
  local fpPool = tonumber(Field.Get(charIndex, 'FpPool')) or 0;
  if lpPool <= 0 and fpPool <= 0 then
    NLG.SystemMessage(charIndex, '[Ѫħ��] ʣ�N�������㣬Ո���r�a�䡣');
    return
  end
  
  local lp = Char.GetData(targetIndex, CONST.CHAR_Ѫ)
  local maxLp = Char.GetData(targetIndex, CONST.CHAR_���Ѫ)
  local fp = Char.GetData(targetIndex, CONST.CHAR_ħ)
  local maxFp = Char.GetData(targetIndex, CONST.CHAR_���ħ)
  if lpPool > 0 and lp < maxLp then
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

  if fpPool > 0 and fp < maxFp then
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
  
  Char.SetData(targetIndex, CONST.CHAR_Ѫ, maxLp)
  Char.SetData(targetIndex, CONST.CHAR_ħ, maxFp)
  
  local petSlot = Char.GetData(targetIndex, CONST.CHAR_ս��);
  if petSlot >= 0 then
    petIndex = Char.GetPet(targetIndex, petSlot);
    lp = Char.GetData(petIndex, CONST.CHAR_Ѫ)
    maxLp = Char.GetData(petIndex, CONST.CHAR_���Ѫ)
    fp = Char.GetData(petIndex, CONST.CHAR_ħ)
    maxFp = Char.GetData(petIndex, CONST.CHAR_���ħ)
    
    if lpPool > 0 and lp < maxLp then
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

    if fpPool > 0 and fp < maxFp then
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
end



function Module:onSellerTalked(npc, player)
  if NLG.CanTalk(npc, player) then
    local npcInfo = self:NPC_buildBuyWindowData(101024, 'Ѫħ���a��', '��ֵѪħ��', '���X����', '�����ѝM', itemList);
    NLG.ShowWindowTalked(player, npc, CONST.����_�̵���, CONST.BUTTON_��, 0,npcInfo)
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
  if gold < totalGold then
    NLG.SystemMessage(player, '����X����');
    return
  end
  if lpPool + totalLp > 50000 then
    NLG.SystemMessage(player, 'Ѫħ������:���ܳ��^50000��Ѫ��ʣ�N���~:'..(50000-lpPool)..'');
    return
  end
  if fpPool + totalFp > 50000 then
    NLG.SystemMessage(player, 'Ѫħ������:���ܳ��^50000��ħ��ʣ�N���~:'..(50000-fpPool)..'');
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
