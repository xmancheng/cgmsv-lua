local Module = ModuleBase:createModule('StrengthShop');

function Module:onLoad()
  self:logInfo('load')
  local StrengthShopNPC = self:NPC_createNormal('ħ�����S�}��', 231050, { x = 235, y = 114, mapType = 0, map = 1000, direction = 0 });
  self:NPC_regTalkedEvent(StrengthShopNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        -- �ص� data = 1:��, 2:��
        -- ���ݽṹ NPCͼ��|���ڱ���|NPC�Ի�|�������� 0:�ް�ť, 1:��, 2:��, 3:����|
        local windowStr = '231050|���S�}��|ħ�����S��ȡ����\n���r�����S����}��|3|'
        NLG.ShowWindowTalked(player, StrengthShopNPC, CONST.����_������, CONST.��ť_�ر�, 1, windowStr);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(StrengthShopNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    print(seqno,select,data)
    if seqno == 1 then
     if data == 1 then
        -- �ص� data = 0:��Ʒ���(���ڱ��ν���)|N:��������|��Ʒ2���|��Ʒ2����...
        -- ���ݽṹ NPCͼ��|���ڱ���|NPC�Ի�|Ǯ�����Ի�|�ò��»����������Ի�|��ƷN����|��ƷNͼ��|��ƷN�۸�|��ƷN����|��ƷN����|�ɷ���, 0����, 1��|
        local windowStr = '231050|���S�}��|�ʂ�ȡ�����S��\n�@Щ�������������\n��ʽ���ӵľ��SŶ|\n���X����|\n���ò�����|';
        for i=1, 20 do
                windowStr = windowStr..'��Ʒ'..i..'����|'..27131+i..'|0|$5��Ʒ'..i..'����|29|1|';
        end
        NLG.ShowWindowTalked(player, StrengthShopNPC, CONST.����_���, CONST.��ť_�ر�, 11, windowStr);
     elseif data == 2 then
        -- �ص� data = 0:��Ʒ���(���ڱ��ν���)|N:��������|��Ʒ2���|��Ʒ2����...
        -- ���ݽṹ NPCͼ��|���ڱ���|NPC�Ի�|��ƷN����|��ƷN��������|��ƷNͼ��|��ƷN����|��Ʒid,����ΪitemIndex|δ֪1|δ֪2|��ƷN����|�ɷ�����, 0����, 1��|��ƷNÿ������|
        local windowStr = '231050|���S�}��|�ʂ������S��\n�@Щ�����еĖ|��Ŷ|';
        for i=1, 20 do
                windowStr = windowStr..'��Ʒ'..i..'����|500|27132|0|'..10086+i..'|1|2|$5��Ʒ'..i..'����|1|3|';
        end
        NLG.ShowWindowTalked(player, StrengthShopNPC, CONST.����_����, CONST.��ť_�ر�, 12, windowStr);
     end
    end



  end)

end


function Module:onUnload()
    self:logInfo('unload')
end

return Module;