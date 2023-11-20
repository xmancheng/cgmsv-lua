local PetHatching = ModuleBase:createModule('petHatching')

petNpcIndex = {}
for list = 0,50 do
	petNpcIndex[list] = {}
                    petNpcIndex[list][1] = -1
                    petNpcIndex[list][2] = -1
end

-- NOTE �������������key
local petFields={
CONST.CHAR_����,
CONST.CHAR_����,
CONST.CHAR_ԭ��,
CONST.CHAR_MAP,
CONST.CHAR_��ͼ,
CONST.CHAR_X,
CONST.CHAR_Y,
CONST.CHAR_����,
CONST.CHAR_�ȼ�,
CONST.CHAR_Ѫ,
CONST.CHAR_ħ,
CONST.CHAR_����,
CONST.CHAR_����,
CONST.CHAR_ǿ��,
CONST.CHAR_�ٶ�,
CONST.CHAR_ħ��,
CONST.CHAR_����,
CONST.CHAR_����,
CONST.CHAR_������,
CONST.CHAR_ˮ����,
CONST.CHAR_������,
CONST.CHAR_������,
CONST.CHAR_����,
CONST.CHAR_��˯,
CONST.CHAR_��ʯ,
CONST.CHAR_����,
CONST.CHAR_����,
CONST.CHAR_����,
CONST.CHAR_��ɱ,
CONST.CHAR_����,
CONST.CHAR_����,
CONST.CHAR_����,
CONST.CHAR_������,
CONST.CHAR_������,
CONST.CHAR_������,
CONST.CHAR_�˺���,
CONST.CHAR_ɱ����,
CONST.CHAR_ռ��ʱ��,
CONST.CHAR_����,
CONST.CHAR_�Ƽ�,
CONST.CHAR_ѭʱ,
CONST.CHAR_����,
CONST.CHAR_������,
CONST.CHAR_ͼ��,
CONST.CHAR_��ɫ,
CONST.CHAR_����,
CONST.CHAR_ԭʼͼ��,
CONST.CHAR_����,
CONST.CHAR_ԭ��,
CONST.CHAR_���Ѫ,
CONST.CHAR_���ħ,
CONST.CHAR_������,
CONST.CHAR_������,
CONST.CHAR_����,
CONST.CHAR_����,
CONST.CHAR_�ظ�,
CONST.CHAR_��þ���,
CONST.CHAR_ħ��,
CONST.CHAR_ħ��,
CONST.CHAR_EnemyBaseId,
CONST.PET_����RegistNumber,
CONST.PET_DepartureBattleStatus,
CONST.PET_PetID,
CONST.PET_������,
CONST.PET_��ȡʱ�ȼ�,
CONST.CHAR_����CD,
CONST.CHAR_��������,
CONST.CHAR_����ԭ��,
}

-- NOTE ����ɳ�����key
local petRankFields={
CONST.PET_���,
CONST.PET_����,
CONST.PET_ǿ��,
CONST.PET_����,
CONST.PET_ħ��,
}

function PetHatching:onLoad()
  self:logInfo('load');
  --����ѵ����үү
  self.seniorNpc = self:NPC_createNormal('����ѵ����үү', 231085, { x = 17, y = 13, mapType = 0, map = 25010, direction = 6 });
  self:NPC_regTalkedEvent(self.seniorNpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local seniorCheck = Char.GetExtData(player, "�����S") or 0;
      if seniorCheck <=0 then
          local msg = "3|\\n�����Ҏ�æӖ������᣿ÿ��ֻ��Ӗ��һ�b����ҕ�����K�@�õĽ��ֵ�M�����M��\\n\\n";
          for i=0,4 do
                local pet = Char.GetPet(player,i);
                if(pet<0)then
                      msg = msg .. "��\\n";
                else
                      msg = msg .. ""..Char.GetData(pet,CONST.CHAR_����).."\\n";
                end
          end
          NLG.ShowWindowTalked(player, self.seniorNpc, CONST.����_ѡ���, CONST.��ť_�ر�, 1, msg);
      elseif seniorCheck >0 then
          local SBTime = Char.GetExtData(player, "�����STime");
          local days = tonumber(os.date("%j",os.time())) - tonumber(os.date("%j",SBTime));
          local hours = tonumber(os.date("%H",os.time())) - tonumber(os.date("%H",SBTime));
          local minutes = tonumber(os.date("%M",os.time())) - tonumber(os.date("%M",SBTime));
          totalMinutes = days*24*60+hours*60+minutes;
          totalGold = totalMinutes*10;
          if (totalGold>=432000) then
              totalMinutes = 43200;       --��߱�������30�콛�4�f3200
              totalGold = 432000;           --������M����30���43�f2000
          end
          local msg = "\\n\\n@cĿǰ��Ӗ���r�g�� "..totalMinutes.." ��\\n\\n\\n�F��Ҫ�I�،���᣿\\n\\n������Ҫ��"..totalGold.."ħ��\\n\\n";
          NLG.ShowWindowTalked(player, self.seniorNpc, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 2, msg);
      end
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.seniorNpc, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.����_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --���܌����A��
    if select == 0 then
      if seqno == 1 and data >= 1 then
        local slot = data-1;
        local petIndex = Char.GetPet(player,slot);
        if petIndex>=0 then
             local data = self:extractPetData(petIndex);
             local pet_name = Char.GetData(petIndex,CONST.CHAR_����);
             local pet_image = Char.GetData(petIndex,CONST.CHAR_����);
             local Pet_ID = Char.GetData(petIndex,CONST.PET_PetID);
             Char.SetExtData(player, "�����S", Pet_ID);
             Char.SetExtData(player, "�����STime", os.time() );
             Char.SetExtData(player, "�����SPet", JSON.encode(data) );
             petNpcIndex[player][1] = Char.CreateDummy()
             Char.TradePet(player, slot, petNpcIndex[player][1]);
             self:regCallback('LoopEvent', Func.bind(self.pnloop,self))
             self:regCallback('pnloop', function(NpcIndex)
                     local dir = math.random(0, 7);
                     local walk = 1;
                     NLG.SetAction(NpcIndex,walk);
                     NLG.WalkMove(NpcIndex,dir);
                     NLG.UpChar(NpcIndex);
             end)
             Char.SetLoopEvent(nil, 'pnloop', petNpcIndex[player][1], math.random(1000,5000));
             Char.SetData(petNpcIndex[player][1], CONST.CHAR_����, pet_name);
             Char.SetData(petNpcIndex[player][1], CONST.CHAR_����, pet_image);
             Char.SetData(petNpcIndex[player][1], CONST.CHAR_ԭ��, pet_image);
             Char.SetData(petNpcIndex[player][1], CONST.CHAR_ԭʼͼ��, pet_image);
             NLG.UpChar(petNpcIndex[player][1]);
             Char.Warp(petNpcIndex[player][1], 0, 25010, math.random(6,14), math.random(2,17));
             NLG.SystemMessage(player, '���������MȥӖ��');
        end
      end
    --ȡ�،����A��
    elseif select > 0 then
      if seqno == 2 and select == CONST.��ť_�� then
        local gold = Char.GetData(player, CONST.CHAR_���);
        if gold < totalGold then
                NLG.SystemMessage(player, '���Ų���o���I�،���');
                return
        else
            if Char.GetEmptyPetSlot(player) < 0 then
                NLG.SystemMessage(player, '����]�л؁�Ŀ�λ');
                return
            else
                local petData= {}
                local Pet_ID = Char.GetExtData(player, "�����S");
                local data = Char.GetExtData(player, "�����SPet");
                local petData = JSON.decode(data);
                --ȡ�ý��ֵ
                if petNpcIndex[player][1]==-1 then
                    petNpcIndex[player][1] = Char.CreateDummy()
                    petIndex = Char.GetPet(petNpcIndex[player][1],0);
                    if petIndex<0 then
                        Char.AddPet(petNpcIndex[player][1], Pet_ID);
                        petIndex = Char.GetPet(petNpcIndex[player][1],0);
                        self:insertPetData(petIndex,petData);
                        Pet.UpPet(petNpcIndex[player][1],petIndex);
                    end
                elseif petNpcIndex[player][1]>=0 then
                    petIndex = Char.GetPet(petNpcIndex[player][1],0);
                end
                local level = Char.GetData(petIndex, CONST.CHAR_�ȼ�);
                local exp = Char.GetData(petIndex, CONST.CHAR_����);
                local plusExp = totalMinutes * level * 12;
                Char.SetData(petIndex, CONST.CHAR_����, exp+plusExp);
                Pet.UpPet(petNpcIndex[player][1], petIndex);
                --ȡ�،���
                Char.TradePet(petNpcIndex[player][1], 0, player);
                Char.AddGold(player, -totalGold);
                Char.DelDummy(petNpcIndex[player][1])
                petNpcIndex[player][1] = -1
                Char.SetExtData(player, "�����S", 0);
                Char.SetExtData(player, "�����STime", 0);
                Char.SetExtData(player, "�����SPet", 0);
                NLG.UpChar(player);
                NLG.SystemMessage(player, '����ص������߅');
            end
        end
      end

    end
  end)
  --��������������231089
  self.juniorNpc = self:NPC_createNormal('��������������', 231089, { x = 17, y = 10, mapType = 0, map = 25010, direction = 6 });
  self:NPC_regTalkedEvent(self.juniorNpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local juniorCheck = Char.GetExtData(player, "�����J") or 0;
      if juniorCheck <=0 then
          local msg = "3|\\n�ҿ��Ԏ�æ����B���ÿ��ֻ����Bһ�b����ҳ��˫@�ý��ֵ߀�����àI�B�\\n\\n";
          for i=0,4 do
                local pet = Char.GetPet(player,i);
                if(pet<0)then
                      msg = msg .. "��\\n";
                else
                      msg = msg .. ""..Char.GetData(pet,CONST.CHAR_����).."\\n";
                end
          end
          NLG.ShowWindowTalked(player, self.juniorNpc, CONST.����_ѡ���, CONST.��ť_�ر�, 1, msg);
      elseif juniorCheck >0 then
          local JBTime = Char.GetExtData(player, "�����JTime");
          local days = tonumber(os.date("%j",os.time())) - tonumber(os.date("%j",JBTime));
          local hours = tonumber(os.date("%H",os.time())) - tonumber(os.date("%H",JBTime));
          local minutes = tonumber(os.date("%M",os.time())) - tonumber(os.date("%M",JBTime));
          totalMinutes = days*24*60+hours*60+minutes;
          totalGold = totalMinutes*10;
          if (totalGold>=432000) then
              totalMinutes = 43200;       --��߱�������30�콛�4�f3200
              totalGold = 432000;           --������M����30���43�f2000
          end
          local msg = "\\n\\n@cĿǰ��Ӗ���r�g�� "..totalMinutes.." ��\\n\\n\\n�F��Ҫ�I�،���᣿\\n\\n������Ҫ��"..totalGold.."ħ��\\n\\n";
          NLG.ShowWindowTalked(player, self.juniorNpc, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 2, msg);
      end
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.juniorNpc, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.����_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --���܌����A��
    if select == 0 then
      if seqno == 1 and data >= 1 then
        local slot = data-1;
        local petIndex = Char.GetPet(player,slot);
        if petIndex>=0 then
             local data = self:extractPetData(petIndex);
             local pet_name = Char.GetData(petIndex,CONST.CHAR_����);
             local pet_image = Char.GetData(petIndex,CONST.CHAR_����);
             local Pet_ID = Char.GetData(petIndex,CONST.PET_PetID);
             Char.SetExtData(player, "�����J", Pet_ID);
             Char.SetExtData(player, "�����JTime", os.time() );
             Char.SetExtData(player, "�����JPet", JSON.encode(data) );
             petNpcIndex[player][2] = Char.CreateDummy()
             Char.TradePet(player, slot, petNpcIndex[player][2]);
             self:regCallback('LoopEvent', Func.bind(self.pnloop,self))
             self:regCallback('pnloop', function(NpcIndex)
                     local dir = math.random(0, 7);
                     local walk = 1;
                     NLG.SetAction(NpcIndex,walk);
                     NLG.WalkMove(NpcIndex,dir);
                     NLG.UpChar(NpcIndex);
             end)
             Char.SetLoopEvent(nil, 'pnloop', petNpcIndex[player][2], math.random(1000,5000));
             Char.SetData(petNpcIndex[player][2], CONST.CHAR_����, pet_name);
             Char.SetData(petNpcIndex[player][2], CONST.CHAR_����, pet_image);
             Char.SetData(petNpcIndex[player][2], CONST.CHAR_ԭ��, pet_image);
             Char.SetData(petNpcIndex[player][2], CONST.CHAR_ԭʼͼ��, pet_image);
             NLG.UpChar(petNpcIndex[player][2]);
             Char.Warp(petNpcIndex[player][2], 0, 25010, math.random(6,14), math.random(2,17));
             NLG.SystemMessage(player, '���������MȥӖ��');
        end
      end
    --ȡ�،����A��
    elseif select > 0 then
      if seqno == 2 and select == CONST.��ť_�� then
        local gold = Char.GetData(player, CONST.CHAR_���);
        if gold < totalGold then
                NLG.SystemMessage(player, '���Ų���o���I�،���');
                return
        else
            if Char.GetEmptyPetSlot(player) < 0 then
                NLG.SystemMessage(player, '����]�л؁�Ŀ�λ');
                return
            else
                local petData= {}
                local Pet_ID = Char.GetExtData(player, "�����J");
                local data = Char.GetExtData(player, "�����JPet");
                local petData = JSON.decode(data);
                --ȡ�ý��ֵ
                if petNpcIndex[player][2]==-1 then
                    petNpcIndex[player][2] = Char.CreateDummy()
                    petIndex = Char.GetPet(petNpcIndex[player][2],0);
                    if petIndex<0 then
                        Char.AddPet(petNpcIndex[player][2], Pet_ID);
                        petIndex = Char.GetPet(petNpcIndex[player][2],0);
                        self:insertPetData(petIndex,petData);
                        Pet.UpPet(petNpcIndex[player][2],petIndex);
                    end
                elseif petNpcIndex[player][2]>=0 then
                    petIndex = Char.GetPet(petNpcIndex[player][2],0);
                end
                local level = Char.GetData(petIndex, CONST.CHAR_�ȼ�);
                local exp = Char.GetData(petIndex, CONST.CHAR_����);
                local plusExp = totalMinutes * level * 10;
                Char.SetData(petIndex, CONST.CHAR_����, exp+plusExp);
                Pet.UpPet(petNpcIndex[player][2], petIndex);
                --ȡ�،���
                if Char.ItemSlot(player)<20 then
                    if (totalMinutes>=60 and totalMinutes<180) then
                        Char.GiveItem(player, 900504, math.random(1,2), '�@�������I�B��');
                    elseif (totalMinutes>=180 and totalMinutes<480) then
                        Char.GiveItem(player, 900504, math.random(4,8), '�@�������I�B��');
                    elseif (totalMinutes>=480) then
                        Char.GiveItem(player, 900504, math.random(8,10), '�@�������I�B��');
                    end
                else
                    NLG.SystemMessage(player, '��Ʒ�ڛ]�п�λ');
                    return
                end
                Char.TradePet(petNpcIndex[player][2], 0, player);
                Char.AddGold(player, -totalGold);
                Char.DelDummy(petNpcIndex[player][2])
                petNpcIndex[player][2] = -1
                Char.SetExtData(player, "�����J", 0);
                Char.SetExtData(player, "�����JTime", 0);
                Char.SetExtData(player, "�����JPet", 0);
                NLG.UpChar(player);
                NLG.SystemMessage(player, '����ص������߅');
            end
        end
      end

    end
  end)



end




-- NOTE ��ȡ��������
function PetHatching:extractPetData(petIndex)
  local item = {
    attr={},
    rank={},
    skills={}
  };
  for _, v in pairs(petFields) do
    item.attr[tostring(v)] = Char.GetData(petIndex, v);
    
  end
  for _, v in pairs(petRankFields) do
    item.rank[tostring(v)] = Pet.GetArtRank(petIndex,v);
    
  end
  -- ���＼��
  local skillTable={}
  for i=0,9 do
    local tech_id = Pet.GetSkill(petIndex, i)
    if tech_id<0 then
      table.insert(skillTable,nil)
    else
      table.insert(skillTable,tech_id)
    end
  end
  item.skills=skillTable
  return item;
end
-- NOTE �����������
function PetHatching:insertPetData(petIndex,petData)
  -- ��������
  for key, v in pairs(petFields) do
    if petData.attr[tostring(v)] ~=nil  then
      Char.SetData(petIndex, v,petData.attr[tostring(v)]);
    end
  end
  -- �ҳ�
  -- Char.SetData(petIndex, 495,100);
  -- ����ɳ�
  for key, v in pairs(petRankFields) do
    if petData.rank[tostring(v)] ~=nil then
      Pet.SetArtRank(petIndex, v,petData.rank[tostring(v)]);
    end
  end
  -- ���＼��
  
  for i=0,9 do
    local tech_id = petData.skills[i+1]
    Pet.DelSkill(petIndex,i)
    if tech_id ~=nil then
      
      Pet.AddSkill(petIndex,tech_id)
    
    end
  end


end

function PetHatching:onUnload()
  self:logInfo('unload')
end

return PetHatching;
