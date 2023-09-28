local AddTK = ModuleBase:createModule('addTK')

local ItemTypeTable = {}
ItemTypeTable[71032] = 61
ItemTypeTable[71033] = 62
ItemTypeTable[71034] = 63
ItemTypeTable[71035] = 64
ItemTypeTable[71036] = 65

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
  self.addTKNpc = self:NPC_createNormal('��ҫ��˵����', 14682, { x = 36, y = 33, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.addTKNpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local msg = "\\n@c�����丽�" ..	"\\n\\n�˞鸱�䌣�õĘsҫ���f���S\\n\\nÿ�����丽������ޞ�10��\\n\\n��Փ�ɹ���ʧ�������p�ٴΔ�\\n\\nȫ�������_7�����ϳɹ��_������Ч����\\n\\n";	
        NLG.ShowWindowTalked(player, self.addTKNpc, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 1, msg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.addTKNpc, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local ViceWeaponIndex =Char.GetViceWeapon(player);                --������
    if select > 0 then
      if seqno == 1 and select == CONST.��ť_ȷ�� then
          if (ViceWeaponIndex ~= nil) then
              local ViceName = Item.GetData(ViceWeaponIndex, CONST.����_����);
              local ViceType = Item.GetData(ViceWeaponIndex,CONST.����_����);
              local Vicehint = Item.GetData(ViceWeaponIndex,CONST.����_Explanation1);                                   --ʣ�N�픵�����f��
              local Special = Item.GetData(ViceWeaponIndex,CONST.����_��������);
              local Para1 = tonumber(Item.GetData(ViceWeaponIndex,CONST.����_�Ӳ�һ));
              local Para2 = tonumber(Item.GetData(ViceWeaponIndex,CONST.����_�Ӳζ�));
              if (ViceType == ItemTypeTable[ItemID] and Vicehint == 189557 and Special ~= 14) then
                            Item.SetData(ViceWeaponIndex,CONST.����_��������, 14);
                            Item.SetData(ViceWeaponIndex,CONST.����_�Ӳ�һ, 6);
                            Item.SetData(ViceWeaponIndex,CONST.����_�Ӳζ�, 1);
                            Item.SetData(ViceWeaponIndex,CONST.����_Explanation1, 7000211);
                            Item.SetData(ViceWeaponIndex,CONST.����_����, 500);
                            Item.SetData(ViceWeaponIndex,CONST.����_ħ��, 500);
                            Item.UpItem(player,3);               --���ָ���
                            Char.DelItemBySlot(player, Char.FindItemId(player,ItemID));
                            NLG.SystemMessage(player, "��ϲ��"..ViceName.."�ĵ�1�θ���ɹ���");
                            NLG.UpChar(player);
              elseif (ViceType == ItemTypeTable[ItemID] and Special == 14 and Para1 == 6) then
                      local SRate = math.random(1,100);
                      for k, v in ipairs(TelekinesisTable) do
                            if (Vicehint == v.Info and SRate >= v.Rate) then
                                local Para2 = Para2 + 1;
                                Item.SetData(ViceWeaponIndex,CONST.����_Explanation1, v.Info+1);
                                Item.SetData(ViceWeaponIndex,CONST.����_�Ӳζ�, Para2);
                                Item.SetData(ViceWeaponIndex,CONST.����_����, Item.GetData(ViceWeaponIndex,CONST.����_����)+500);
                                Item.SetData(ViceWeaponIndex,CONST.����_ħ��, Item.GetData(ViceWeaponIndex,CONST.����_ħ��)+500);
                                Item.UpItem(player,3);
                                Char.DelItemBySlot(player, Char.FindItemId(player,ItemID));
                                NLG.SystemMessage(player, "��ϲ��"..ViceName.."�ѽ�����ɹ�"..Para2.."�Σ�");
                                NLG.UpChar(player);
                            elseif (Vicehint == v.Info and SRate < v.Rate) then
                                Item.SetData(ViceWeaponIndex,CONST.����_Explanation1, v.Info+1);
                                Item.UpItem(player,3);
                                Char.DelItemBySlot(player, Char.FindItemId(player,ItemID));
                                NLG.SystemMessage(player, "���"..ViceName.."�ĸ���ʧ���ˣ�");
                            end
                            local New_Vicehint = Item.GetData(ViceWeaponIndex,CONST.����_Explanation1);
                            local New_Para2 = tonumber(Item.GetData(ViceWeaponIndex,CONST.����_�Ӳζ�));
                            if (New_Vicehint == 7000220 and New_Para2 >= 7) then
                                local GameTime= math.random(0,3);
                                Item.SetData(ViceWeaponIndex,CONST.����_����, GameTime);
                                Item.SetData(ViceWeaponIndex,CONST.����_Explanation1, 7000221+GameTime);
                                Item.UpItem(player,3);
                                NLG.SystemMessage(player, "ע�⣡"..ViceName.."�Űl������Ч����");
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
    local msg = "\\n@c�����丽�" ..	"\\n\\n�˞鸱�䌣�õĘsҫ���f���S\\n\\nÿ�����丽������ޞ�10��\\n\\n��Փ�ɹ���ʧ�������p�ٴΔ�\\n\\nȫ�������_7�����ϳɹ��_������Ч����\\n\\n";	
    NLG.ShowWindowTalked(charIndex, self.addTKNpc, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 1, msg);
    return 1;
end


Char.GetViceWeapon = function(charIndex)
  local itemType = {
    { type=60},{ type=61},{ type=62},{ type=63},{ type=64},{ type=65},
  }
  local ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_����);
  if ItemIndex >= 0 then
    for k, v in ipairs(itemType) do
      if Item.GetData(ItemIndex, CONST.����_����)==v.type then
        return ItemIndex;
      end
    end
  end
  ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_����)
  if ItemIndex >= 0 then
    for k, v in ipairs(itemType) do
      if Item.GetData(ItemIndex, CONST.����_����)==v.type then
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
