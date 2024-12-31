local Module = ModuleBase:createModule('equipEffects')

local WingKindSpeed_List = {};
WingKindSpeed_List[69060] = 130;
WingKindSpeed_List[69061] = 130;
WingKindSpeed_List[69062] = 130;
WingKindSpeed_List[69063] = 130;

local MountKindDuration_List = {};
MountKindDuration_List[71058] = {101001,120000};			--120��
local MountItem = {
    { type=62, name="���T", defaultImage=25044, place=6, flags=0, job=1, level=10 },
    { type=62, name="���T", defaultImage=25044, place=6, flags=0, job=2011, level=10 },
    { type=62, name="���T", defaultImage=25044, place=6, flags=0, job=2021, level=10 },
    { type=62, name="���T", defaultImage=25044, place=6, flags=0, job=2041, level=10 },
    { type=62, name="���T", defaultImage=25044, place=6, flags=0, job=2031, level=10 },
    { type=62, name="���T", defaultImage=25044, place=6, flags=128, job=145, level=10 },
}

-------------------------------------------------------------------------------------------------------------------------------------
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('ItemAttachEvent', Func.bind(self.itemAttachCallback, self))
  self:regCallback('ItemDetachEvent', Func.bind(self.itemDetachCallback, self))
  self:regCallback('LoginEvent', Func.bind(self.onLoginEvent, self));

  self:regCallback('LoopEvent', Func.bind(self.qmloop, self))
  self:regCallback('mountloop', function(player)
    local MountOn = Char.GetTempData(player, 'MountOn') or -1;
    if (Char.GetData(player,CONST.����_�����п���)==1 and MountOn>=1) then
      if MountOn==2 then
        Char.SetTempData(player, 'MountOn',1);
      elseif MountOn==1 then
        Char.SetData(player,%����_�����п���%,0);
        Char.UnsetLoopEvent(player);
        Char.SetTempData(player, 'MountOn',0);
        NLG.UpChar(player);
        NLG.SystemMessage(player,'�������P�]��Ո�����������T��')
      end
    end
  end)

  for k, v in ipairs(MountItem) do
      Item.CreateNewItemType(v.type, v.name, v.defaultImage, v.place, v.flags)
      Item.SetItemTypeEquipLevelForJob(v.job, v.type, v.level)
  end

end

--װ���ӿ�
function Module:itemAttachCallback(charIndex, fromItemIndex)
      local itemId = Item.GetData(fromItemIndex, CONST.����_ID);
      local type = Item.GetData(fromItemIndex, CONST.����_����);
      setItemEffectData(charIndex, fromItemIndex, itemId, type);
  return 0;
end

--ж�½ӿ�
function Module:itemDetachCallback(charIndex, fromItemIndex)
      local itemId = Item.GetData(fromItemIndex, CONST.����_ID);
      local type = Item.GetData(fromItemIndex, CONST.����_����);
      setItemReEffectData(charIndex, fromItemIndex, itemId, type);
  return 0;
end

function Module:onLoginEvent(charIndex)
      local slotItemIndex_2 = Char.GetItemIndex(charIndex, 2)		--����(2)
      local itemId_2 = Item.GetData(slotItemIndex_2, CONST.����_ID);
      local type_2 = Item.GetData(slotItemIndex_2, CONST.����_����);
      setItemEffectData(charIndex, slotItemIndex_2, itemId_2, type_2);

      local slotItemIndex_5 = Char.GetItemIndex(charIndex, 5)		--��Ʒ1(5)
      local itemId_5 = Item.GetData(slotItemIndex_5, CONST.����_ID);
      local type_5 = Item.GetData(slotItemIndex_5, CONST.����_����);
      setItemEffectData(charIndex, slotItemIndex_5, itemId_5, type_5);

      local slotItemIndex_6 = Char.GetItemIndex(charIndex, 6)		--��Ʒ2(6)
      local itemId_6 = Item.GetData(slotItemIndex_6, CONST.����_ID);
      local type_6 = Item.GetData(slotItemIndex_6, CONST.����_����);
      setItemEffectData(charIndex, slotItemIndex_6, itemId_6, type_6);
end

------------------------------------------------------------------------------------------
--���ܺ���
--װ��ʱ
function setItemEffectData(_CharIndex, _ItemIndex, _ItemId, _Type)
	if (_Type==0 or _Type==1 or _Type==2 or _Type==3 or _Type==4 or _Type==5 or _Type==6) then
		local imageId = Item.GetData(_ItemIndex, CONST.����_���ò���);
		local Image_buffer = string.split(imageId, "|")
		change_imageId = tonumber(Image_buffer[1]) or 0;			--�ӳ�����
		orichange_imageId = tonumber(Image_buffer[2]) or 0;			--���ԭ����
		print(change_imageId,orichange_imageId)
		if (change_imageId>0) then
			local playerImageId = Char.GetData(_CharIndex, CONST.����_ԭʼͼ��);
			local tStat = change_imageId.."|" ..playerImageId;
			Item.SetData(_ItemIndex, CONST.����_���ò���, tStat);
			Item.UpItem(_CharIndex, -1);
			--Char.SetData(_CharIndex, CONST.����_����, change_imageId);
			--Char.SetData(_CharIndex, CONST.����_����, change_imageId);
			Char.SetData(_CharIndex, CONST.����_ԭ��, change_imageId);
			NLG.UpChar(_CharIndex);
		end
	elseif (_Type==55) then			--ͷ��
		Char.SetData(_CharIndex, CONST.����_����, WingKindSpeed_List[_ItemId]);
		NLG.UpChar(_CharIndex)
	elseif (_Type==62) then			--����
		--�����й���
		if (Char.GetData(_CharIndex,CONST.����_�㲽��)>0) then
			NLG.SystemMessage(_CharIndex,"����ʹ�ò����������o�����ò�������");
		elseif (Char.GetData(_CharIndex,CONST.����_�����п���)==1) then
			Char.SetData(_CharIndex,CONST.����_�����п���,0);
			Char.UnsetLoopEvent(_CharIndex);
			Char.SetTempData(_CharIndex, 'MountOn',0);
			NLG.UpChar(_CharIndex);
			NLG.SystemMessage(_CharIndex,"���T��B�������P�]��");
		else
			Char.SetData(_CharIndex,CONST.����_�����п���,1);
			Char.SetLoopEvent(nil,'mountloop',_CharIndex, MountKindDuration_List[_ItemId][2]);	--�޸���ħ����ʱ�䣬��λ����
			Char.SetTempData(_CharIndex, 'MountOn',2);
			NLG.UpChar(_CharIndex);
			NLG.SystemMessage(_CharIndex,"���T��B�������_����");
		end
		--�T�����T
		local sitting_image = MountKindDuration_List[_ItemId][1]
		local MapId = Char.GetData(_CharIndex,CONST.����_��ͼ����);
		local FloorId = Char.GetData(_CharIndex,CONST.����_��ͼ);
		local X = Char.GetData(_CharIndex,CONST.����_X);
		local Y = Char.GetData(_CharIndex,CONST.����_Y);
		local objNum,objTbl = Obj.GetObject(MapId, FloorId, X, Y);
		--print(objNum,objTbl)
		players = NLG.GetPlayer();
		for k, v in ipairs(objTbl) do
			local playerIndex = Obj.GetCharIndex(v)
			local sittingIndex = tonumber(playerIndex)+1;
			--print(playerIndex,sittingIndex,objTbl[1])
			if (Obj.GetType(v)==1) then	---1���Ƿ� | 0��δʹ�� | 1����ɫ | 2������ | 3����� | 4�����͵� | 5���� | 6���ؾ�
				--Protocol.Send(v,'NI',from10to62(objTbl[1])..'|'..x..'|'..y..'|70|0|101001|650|-1')	--���1 70
				Protocol.Send(playerIndex,'NI',from10to62(objTbl[1])..'|'..X..'|'..Y..'|70|'..sittingIndex..'|'..sitting_image..'|650|-1')
				for k, v in ipairs(players) do
					local names = Char.GetData(v,CONST.����_ԭ��) or -1;
					local maps = Char.GetData(v,CONST.����_��ͼ) or -1;
					if names~=-1 and maps==FloorId then 
						Protocol.Send(v,'NI',from10to62(objTbl[1])..'|'..X..'|'..Y..'|70|'..sittingIndex..'|'..sitting_image..'|650|-1')
					end
				end
			end
		end
	end
end

--ж��ʱ
function setItemReEffectData(_CharIndex, _ItemIndex, _ItemId, _Type)
	if (_Type==0 or _Type==1 or _Type==2 or _Type==3 or _Type==4 or _Type==5 or _Type==6) then
		local imageId = Item.GetData(_ItemIndex, CONST.����_���ò���);
		local Image_buffer = string.split(imageId, "|")
		change_imageId = tonumber(Image_buffer[1]) or 0;			--�ӳ�����
		orichange_imageId = tonumber(Image_buffer[2]) or 0;			--���ԭ����
		print(change_imageId,orichange_imageId)
		if (change_imageId>0) then
			local playerImageId = Char.GetData(_CharIndex, CONST.����_ԭʼͼ��);
			local tStat = change_imageId.."|" ..playerImageId;
			Item.SetData(_ItemIndex, CONST.����_���ò���, tStat);
			Item.UpItem(_CharIndex, -1);
			--Char.SetData(_CharIndex, CONST.����_����, orichange_imageId);
			--Char.SetData(_CharIndex, CONST.����_����, orichange_imageId);
			Char.SetData(_CharIndex, CONST.����_ԭ��, orichange_imageId);
			NLG.UpChar(_CharIndex);
		end
	elseif (_Type==55) then			--ͷ��
		Char.SetData(_CharIndex, CONST.����_����, 100);
		NLG.UpChar(_CharIndex)
	elseif (_Type==62) then			--����
		--�����й���
		if (Char.GetData(_CharIndex,CONST.����_�����п���)==1) then
			Char.SetData(_CharIndex,CONST.����_�����п���,0);
			Char.UnsetLoopEvent(_CharIndex);
			Char.SetTempData(_CharIndex, 'MountOn',0);
			NLG.UpChar(_CharIndex);
			NLG.SystemMessage(_CharIndex,"���T��B�������P�]��");
		end
		--��������
		NLG.UpChar(_CharIndex)
	end
end

function from10to62(num)
	local dict = {"0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
		"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"};--������
	local result = ''
	--local bin = ''
	while num > 0 do
		result = tostring(dict[(num % 62)+1]) .. result--ȡ������ƴ�ӵ���������ǰ��
		num = math.floor(num / 62)--����62
	end
	return result
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
