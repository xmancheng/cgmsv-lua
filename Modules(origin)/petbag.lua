---ģ����
local Module = ModuleBase:createModule('petbag')

local petbag_list = {
    1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,
}

Module:addMigration(1, "migrate2", function()
  local res = SQL.QueryEx("select * from lua_petdata");
  if res.rows then
    for i, row in ipairs(res.rows) do
      pcall(function()
        local data = JSON.decode(row.data);
        local regId = row.id;
        local cdkey = row.cdkey;
        if data.petbag and data.petbagIndex then
          for i = 1, 5 do		--5ҳ�����
            for j = 1, 8 do		--ÿҳ8�b����
              if data.petbag[i] and data.petbag[i][j] then
                SQL.QueryEx("insert into hook_charaext (cdKey, regNo, sKey, val, valType) values (?,?,?,?,?,?)",
                  cdkey, regId, string.format("petbag-%d-%d", i, j), JSON.encode(data.petbag[i][j]), 0);
              end
            end
          end
          --SQL.QueryEx("insert into hook_charaext (cdKey, regNo, sKey, val, valType) values (?,?,?,?,?,?)",
          --  cdkey, regId, "petbag-index", data.petbagIndex, 1);
        end
      end)
    end
  end
end)

local petFields={
  CONST.����_����,
  CONST.����_����,
  CONST.����_ԭ��,
  CONST.����_MAP,
  CONST.����_��ͼ,
  CONST.����_X,
  CONST.����_Y,
  CONST.����_����,
  CONST.����_�ȼ�,
  CONST.����_Ѫ,
  CONST.����_ħ,
  CONST.����_����,
  CONST.����_����,
  CONST.����_ǿ��,
  CONST.����_�ٶ�,
  CONST.����_ħ��,
  CONST.����_����,
  CONST.����_����,
  CONST.����_������,
  CONST.����_ˮ����,
  CONST.����_������,
  CONST.����_������,
  CONST.����_����,
  CONST.����_��˯,
  CONST.����_��ʯ,
  CONST.����_����,
  CONST.����_����,
  CONST.����_����,
  CONST.����_��ɱ,
  CONST.����_����,
  CONST.����_����,
  CONST.����_����,
  CONST.����_������,
  CONST.����_������,
  CONST.����_������,
  CONST.����_�˺���,
  CONST.����_ɱ����,
  CONST.����_ռ��ʱ��,
  CONST.����_����,
  CONST.����_�Ƽ�,
  CONST.����_ѭʱ,
  CONST.����_����,
  CONST.����_������,
  CONST.����_ͼ��,
  CONST.����_��ɫ,
  CONST.����_����,
  CONST.����_ԭʼͼ��,
  CONST.����_����,
  CONST.����_���Ѫ,
  CONST.����_���ħ,
  CONST.����_������,
  CONST.����_������,
  CONST.����_����,
  CONST.����_����,
  CONST.����_�ظ�,
  CONST.����_��þ���,
  CONST.����_EnemyBaseId,
  CONST.PET_DepartureBattleStatus,
  CONST.PET_PetID,
  CONST.PET_������,
  CONST.����_��ɫ,
  CONST.����_��ȡʱ�ȼ�,
  CONST.����_�����ҳ�,
  CONST.����_��׽�Ѷ�,
  CONST.����_�ҳ�,
}

-- NOTE ����ɳ�����key
local petRankFields={
  CONST.PET_���,
  CONST.PET_����,
  CONST.PET_ǿ��,
  CONST.PET_����,
  CONST.PET_ħ��,
}

--------------------------------------------------------------------
local function calcWarp()
  local page = math.modf(#petbag_list / 8) + 1
  local remainder = math.fmod(#petbag_list, 8)
  return page, remainder
end

--Զ�̰�ťUI����
function Module:petbagInfo(npc, player)
          local winButton = CONST.��ť_�ر�;
          local msg = "2\\n����������������������녶˂}�졿\\n\\n"
               .. "��������ȡ��ŵČ���\\n\\n"
               .. "������Ĵ����ϵČ���\\n\\n";
          NLG.ShowWindowTalked(player, self.petBankNPC, CONST.����_ѡ���, CONST.��ť_�ر�, 777, msg);
end

--------------------------------------------------------------------
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  --self:regCallback('LoginEvent', Func.bind(self.onLoginEvent, self));
  self.petBankNPC = self:NPC_createNormal('����녶˂}��', 14682, { x = 38, y = 30, mapType = 0, map = 777, direction = 6 });
  self:NPC_regWindowTalkedEvent(self.petBankNPC, function(npc, player, _seqno, _select, _data)
    local column = tonumber(_data)
    local page = tonumber(_seqno)
    local warpPage = page;
    --�ж�ʹ�ü�ҳ���
    --[[local petbag_list = {}
    for bagslot = 1, 5 do		--5ҳ�����
      for petslot = 1, 8 do
        local bagslotIndex = tonumber(bagslot);
        local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", bagslotIndex, petslot));
        pcall(function()
          if petbagPet then
            table.insert(petbag_list, string.format("petbag-%d-%d", bagslot, petslot));
          end
        end)
      end
    end]]
    local winMsg = "1\\n����������������������녶˂}�졿\\n"
    local winButton = CONST.��ť_�ر�;
    local totalPage, remainder = calcWarp()
    --��ҳ16 ��ҳ32 �ر�/ȡ��2
    if _select > 0 then
      if _select == CONST.��ť_�ر� then
          if (page==777 or page==778) then
              return
          end
      elseif _select == CONST.��ť_�� then
          if (page>=2001 and page<3000) then
              if (Char.PetNum(player)==5) then
                 NLG.SystemMessage(player,"[ϵ�y]�����λ���ѝM��");
                 return;
              end

              local petNo = petNo;
              local seqno = page - 2000;
              local petbagIndex = tonumber(seqno);
              if petbagIndex < 1 or petbagIndex > 5 then
                NLG.SystemMessage(player, '�oЧ������')
                return;
              end
              local petData = {};
              local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, petNo));
              pcall(function()
                if petbagPet then
                  petbagPet = JSON.decode(petbagPet);
                end
              end)
              if type(petbagPet) == 'table' then
                petData = petbagPet
                local EmptySlot = Char.GetPetEmptySlot(player);
                local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
                Char.GivePet(player, enemyId, 0);
                local petIndex = Char.GetPet(player,EmptySlot);
                self:insertPetData(petIndex,petData)
                Pet.UpPet(player, petIndex);
                NLG.UpChar(player);
              end
              Char.SetExtData(player, string.format("petbag-%d-%d", petbagIndex, petNo), nil);
              return;
          else
              return;
          end
      elseif _select == CONST.��ť_�� then
          if (page>=2001 and page<3000) then
              --��һҳ���
              for slot = 1, 8 do
                local petbagIndex = tonumber(1);
                --Char.SetExtData(player, "petbag-index", petbagIndex);
                local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, slot));
                pcall(function()
                  if petbagPet then
                    petbagPet = JSON.decode(petbagPet);
                  end
                end)
                if type(petbagPet) == 'table' then
                  local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
                  local Goal_name = petbagPet.attr[tostring(CONST.����_����)];
                  winMsg = winMsg .. "�������["..slot.."]̖λ: " .. Goal_name .."\\n";
                else
                  winMsg = winMsg .. "�������["..slot.."]̖λ: ��\\n";
                end
              end
              NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.��ť_��ȡ��, 1000+1, winMsg);
              return
          else
              return
          end
      end
      if (warpPage>=3001) then	--�Ĵ�
        local warpPage = warpPage - 3000;
        if _select == CONST.BUTTON_��һҳ then
          warpPage = warpPage + 1
          if (warpPage == totalPage) or ((warpPage == (totalPage - 1) and remainder == 0)) then
            winButton = CONST.BUTTON_��ȡ��
          else
            winButton = CONST.BUTTON_����ȡ��
          end
        elseif _select == CONST.BUTTON_��һҳ then
          warpPage = warpPage - 1
          if warpPage == 1 then
            winButton = CONST.BUTTON_��ȡ��
          else
            winButton = CONST.BUTTON_����ȡ��
          end
        elseif _select == 2 then
          warpPage = 1;
          return;
        end
        print(warpPage)
        local count = 8 * (warpPage - 1)
        if warpPage == totalPage then
          local petbagIndex = tonumber(warpPage);
          if petbagIndex < 1 or petbagIndex > 5 then
              NLG.SystemMessage(player, '�oЧ������')
              return;
          end
          --Char.SetExtData(player, "petbag-index", petbagIndex);
          for i = 1, 8  do
            local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, i));
            pcall(function()
              if petbagPet then
                petbagPet = JSON.decode(petbagPet);
              end
            end)
            if type(petbagPet) == 'table' then
              local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
              local Goal_name = petbagPet.attr[tostring(CONST.����_����)];
              winMsg = winMsg .. "�������["..i+count.."]̖λ: " .. Goal_name .."\\n";
            else
              winMsg = winMsg .. "�������["..i+count.."]̖λ: ��\\n";
            end
          end
        else
          local petbagIndex = tonumber(warpPage);
          if petbagIndex < 1 or petbagIndex > 5 then
              NLG.SystemMessage(player, '�oЧ������')
              return;
          end
          --Char.SetExtData(player, "petbag-index", petbagIndex);
          for i = 1, 8  do
            local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, i));
            pcall(function()
              if petbagPet then
                petbagPet = JSON.decode(petbagPet);
              end
            end)
            if type(petbagPet) == 'table' then
              local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
              local Goal_name = petbagPet.attr[tostring(CONST.����_����)];
              winMsg = winMsg .. "�������["..i+count.."]̖λ: " .. Goal_name .."\\n";
            else
              winMsg = winMsg .. "�������["..i+count.."]̖λ: ��\\n";
            end
          end
        end
        NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, winButton, 3000+warpPage, winMsg);
      elseif (warpPage>=1001 and warpPage<3000) then	--��ȡ
        local warpPage = warpPage - 1000;
        if _select == CONST.BUTTON_��һҳ then
          warpPage = warpPage + 1
          if (warpPage == totalPage) or ((warpPage == (totalPage - 1) and remainder == 0)) then
            winButton = CONST.BUTTON_��ȡ��
          else
            winButton = CONST.BUTTON_����ȡ��
          end
        elseif _select == CONST.BUTTON_��һҳ then
          warpPage = warpPage - 1
          if warpPage == 1 then
            winButton = CONST.BUTTON_��ȡ��
          else
            winButton = CONST.BUTTON_����ȡ��
          end
        elseif _select == 2 then
          warpPage = 1;
          return;
        end
        local count = 8 * (warpPage - 1)
        if warpPage == totalPage then
          local petbagIndex = tonumber(warpPage);
          if petbagIndex < 1 or petbagIndex > 5 then
              NLG.SystemMessage(player, '�oЧ������')
              return;
          end
          --Char.SetExtData(player, "petbag-index", petbagIndex);
          for i = 1, 8  do
            local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, i));
            pcall(function()
              if petbagPet then
                petbagPet = JSON.decode(petbagPet);
              end
            end)
            if type(petbagPet) == 'table' then
              local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
              local Goal_name = petbagPet.attr[tostring(CONST.����_����)];
              winMsg = winMsg .. "�������["..i+count.."]̖λ: " .. Goal_name .."\\n";
            else
              winMsg = winMsg .. "�������["..i+count.."]̖λ: ��\\n";
            end
          end
        else
          local petbagIndex = tonumber(warpPage);
          if petbagIndex < 1 or petbagIndex > 5 then
              NLG.SystemMessage(player, '�oЧ������')
              return;
          end
          --Char.SetExtData(player, "petbag-index", petbagIndex);
          for i = 1, 8  do
            local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, i));
            pcall(function()
              if petbagPet then
                petbagPet = JSON.decode(petbagPet);
              end
            end)
            if type(petbagPet) == 'table' then
              local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
              local Goal_name = petbagPet.attr[tostring(CONST.����_����)];
              winMsg = winMsg .. "�������["..i+count.."]̖λ: " .. Goal_name .."\\n";
            else
              winMsg = winMsg .. "�������["..i+count.."]̖λ: ��\\n";
            end
          end
        end
        NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, winButton, 1000+warpPage, winMsg);
      end
    else
      --print(column)
      if (page==777 and column==1) then			--��ȡ
        local warpPage = 1;
        local count = 8 * (warpPage - 1) + column;
        --print(count)

        --��һҳ���
        local petbagIndex = tonumber(warpPage);
        if petbagIndex < 1 or petbagIndex > 5 then
            NLG.SystemMessage(player, '�oЧ������')
            return;
        end
        --Char.SetExtData(player, "petbag-index", petbagIndex);
        for slot = 1, 8 do
          local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, slot));
          pcall(function()
            if petbagPet then
              petbagPet = JSON.decode(petbagPet);
            end
          end)
          if type(petbagPet) == 'table' then
            local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
            local Goal_name = petbagPet.attr[tostring(CONST.����_����)];
            winMsg = winMsg .. "�������["..slot.."]̖λ: " .. Goal_name .."\\n";
          else
            winMsg = winMsg .. "�������["..slot.."]̖λ: ��\\n";
          end
        end
        NLG.ShowWindowTalked(player, self.petBankNPC, CONST.����_ѡ���, CONST.��ť_��ȡ��, 1000+warpPage, winMsg);
      elseif (page==777 and column==3) then		--�Ĵ�
          local msg = "����������������������녶˂}�졿\\n"
          local msg = "2|\\n�x��Ҫ�Ĵ�녶���X�Č���:\\n\\n";
          for petSlot=0,4 do
                local petIndex = Char.GetPet(player,petSlot);
                if(petIndex<0)then
                      msg = msg .. "��\\n";
                else
                      msg = msg .. ""..Char.GetData(petIndex,CONST.����_����).."\\n";
                end
          end
          NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.��ť_�ر�, 778, msg);
      elseif (page==778) then
          updatedPetdata = column-1;
          local petIndex = Char.GetPet(player,updatedPetdata);
          if (petIndex<0) then
            NLG.SystemMessage(player, '[ϵ�y]�x���λ�Û]�Ќ��')
            return;
          end
          --��һҳ���
          local petbagIndex = tonumber(1);
          --Char.SetExtData(player, "petbag-index", petbagIndex);
          for slot = 1, 8 do
            local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, slot));
            pcall(function()
              if petbagPet then
                petbagPet = JSON.decode(petbagPet);
              end
            end)
            if type(petbagPet) == 'table' then
              local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
              local Goal_name = petbagPet.attr[tostring(CONST.����_����)];
              winMsg = winMsg .. "�������["..slot.."]̖λ: " .. Goal_name .."\\n";
            else
              winMsg = winMsg .. "�������["..slot.."]̖λ: ��\\n";
            end
          end
          NLG.ShowWindowTalked(player, self.petBankNPC, CONST.����_ѡ���, CONST.��ť_��ȡ��, 3000+1, winMsg);
      elseif (page>=3001) then
          local seqno = page - 3000;
          local petbagIndex = tonumber(seqno);
          --Char.SetExtData(player, "petbag-index", petbagIndex);
          local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, column));
          pcall(function()
            if petbagPet then
              petbagPet = JSON.decode(petbagPet);
            end
          end)
          if type(petbagPet) == 'table' then
            NLG.SystemMessage(player, '[ϵ�y]����ѽ��мĴ档')
            return;
          end
          local updatedPetdata = updatedPetdata;
          local petIndex = Char.GetPet(player,updatedPetdata);
          local petProfile = self:extractPetData(petIndex)
          --Char.SetExtData(player, "petbag-index", seqno);
          local onpetBagIndex = petbagIndex;
          local r = Char.DelSlotPet(player, updatedPetdata);
          Char.SetExtData(player, string.format("petbag-%d-%d", onpetBagIndex, column), JSON.encode(petProfile));
      elseif (page>=1001 and page<3000) then
          local seqno = page - 1000;
          petNo = column;
          local petbagIndex = tonumber(seqno);
          Char.SetExtData(player, "petbag-index", petbagIndex);

          local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, petNo));
          pcall(function()
            if petbagPet then
              petbagPet = JSON.decode(petbagPet);
            end
          end)
          if type(petbagPet) == 'table' then
            local msg = "����������������������녶˂}�졿\\n"
            local msg = msg .. pickupGoalInfo(player,petbagIndex,petNo);
            NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 2000+seqno, msg);
          else
            NLG.SystemMessage(player, '[ϵ�y]�x��ĸ��]�Ќ��')
            return;
          end
      else
          return;
      end
    end
  end)
  self:NPC_regTalkedEvent(self.petBankNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local winButton = CONST.BUTTON_�ر�;
      local msg = "2\\n����������������������녶˂}�졿\\n\\n"
           .. "��������ȡ��ŵČ���\\n\\n"
           .. "������Ĵ����ϵČ���\\n\\n";
      NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.��ť_�ر�, 777, msg);
    end
    return
  end)



end


function Module:onLoginEvent(charIndex)
  local bIndex = Char.GetExtData(charIndex, "petbag-index") or 1;
  Protocol.Send(charIndex, "petbagIndex",  tonumber(bIndex));
end


--Ŀ����Ϣ
function pickupGoalInfo(player,petbagIndex,petNo)
      local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, petNo));
      pcall(function()
        if petbagPet then
          petbagPet = JSON.decode(petbagPet);
        end
      end)

      if type(petbagPet) == 'table' then
        local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
        local Goal_name = petbagPet.attr[tostring(CONST.����_����)];
        local Goal_DataPos_3 = petbagPet.attr[tostring(CONST.����_����)];
        local Goal_DataPos_3 = Tribe(Goal_DataPos_3);
        local Goal_DataPos_5 = petbagPet.attr[tostring(CONST.����_������)];
        local Goal_DataPos_6 = petbagPet.attr[tostring(CONST.����_������)];
        local Goal_DataPos_7 = petbagPet.attr[tostring(CONST.����_����)];
        local Goal_DataPos_8 = petbagPet.attr[tostring(CONST.����_����)];
        local Goal_DataPos_9 = petbagPet.attr[tostring(CONST.����_�ظ�)];

        local Goal_DataPos_12 = petbagPet.attr[tostring(CONST.����_����)];
        local Goal_DataPos_13 = petbagPet.attr[tostring(CONST.����_��ɱ)];
        local Goal_DataPos_14 = petbagPet.attr[tostring(CONST.����_������)];
        local Goal_DataPos_15 = petbagPet.attr[tostring(CONST.����_ˮ����)];
        local Goal_DataPos_16 = petbagPet.attr[tostring(CONST.����_������)];
        local Goal_DataPos_17 = petbagPet.attr[tostring(CONST.����_������)];
        local Goal_DataPos_18 = petbagPet.attr[tostring(CONST.����_����)];
        local Goal_DataPos_19 = petbagPet.attr[tostring(CONST.����_����)];
        local Goal_DataPos_20 = petbagPet.attr[tostring(CONST.����_��˯)];
        local Goal_DataPos_21 = petbagPet.attr[tostring(CONST.����_����)];
        local Goal_DataPos_22 = petbagPet.attr[tostring(CONST.����_��ʯ)];
        local Goal_DataPos_23 = petbagPet.attr[tostring(CONST.����_����)];
        local Goal_DataPos_26 = petbagPet.attr[tostring(CONST.����_����)];
        local Goal_DataPos_27 = petbagPet.attr[tostring(CONST.����_����)];
        local Goal_DataPos_28 = petbagPet.attr[tostring(CONST.����_�ȼ�)];
        local Goal_DataPos_29 = petbagPet.attr[tostring(CONST.����_ԭ��)];
        local imageText = "@g,"..Goal_DataPos_29..",2,8,6,0@"

        msg = imageText .. "����$4".. Goal_name .. "\\n"
                         .. "��������������" .. "$1���� ".. Goal_DataPos_5 .."��" .. "$8�ؚ� ".. Goal_DataPos_13 .."��" .. "$8���� ".. Goal_DataPos_27 .."\\n"
                         .. "��������������" .. "$1���R ".. Goal_DataPos_6 .."��" .. "$8���� ".. Goal_DataPos_12 .."��" .. "$8�W�� ".. Goal_DataPos_26 .."\\n"
                         .. "��������������" .. "$1���� ".. Goal_DataPos_7 .."��" .. "$2���� ".. Goal_DataPos_18 .."��" .. "$2���� ".. Goal_DataPos_19 .."\\n"
                         .. "��������������" .. "$1���� ".. Goal_DataPos_8 .."��" .. "$2��˯ ".. Goal_DataPos_20 .."��" .. "$2���� ".. Goal_DataPos_21 .."\\n"
                         .. "��������������" .. "$1�֏� ".. Goal_DataPos_9 .."��" .. "$2��ʯ ".. Goal_DataPos_22 .."��" .. "$2���� ".. Goal_DataPos_23 .."\\n"
                         .. "��������������" .. "$5�� ".. Goal_DataPos_14/10 .."��" .."$5ˮ ".. Goal_DataPos_15/10 .."��" .."$5�� ".. Goal_DataPos_16/10 .."��" .."$5�L ".. Goal_DataPos_17/10 .."\\n"
                         .. "��������������" .. "$9�N�� ".. Goal_DataPos_3 .."��" .. "$9�ȼ� ".. Goal_DataPos_28 .."\\n"
      else
        msg = "\\n\\n\\n\\n@c�����F�e�`"
      end
      return msg;
end

--�����ַ���ת��
function Tribe(Tribe)
  if Tribe==0 then
    return "����ϵ"
  elseif Tribe == 1 then
    return "����ϵ"
  elseif Tribe == 2 then
    return "����ϵ"
  elseif Tribe == 3 then
    return "�w��ϵ"
  elseif Tribe == 4 then
    return "���xϵ"
  elseif Tribe == 5 then
    return "ֲ��ϵ"
  elseif Tribe == 6 then
    return "Ұ�Fϵ"
  elseif Tribe == 7 then
    return "����ϵ"
  elseif Tribe == 8 then
    return "����ϵ"
  elseif Tribe == 9 then
    return "аħϵ"
  elseif Tribe == 10 then
    return "����ϵ"
  elseif Tribe == 11 then
    return "���`ϵ"
  end
end

--------------------------------------------------------------------
-- NOTE ��ȡ��������
function Module:extractPetData(petIndex)
  local petProfile = {
    attr={},
    rank={},
    skills={}
  };
  for _, v in pairs(petFields) do
    petProfile.attr[tostring(v)] = Char.GetData(petIndex, v);
    
  end
  for _, v in pairs(petRankFields) do
    petProfile.rank[tostring(v)] = Pet.GetArtRank(petIndex,v);
    
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
  petProfile.skills=skillTable
  return petProfile;
end

-- NOTE �����������
function Module:insertPetData(petIndex,petData)
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

Char.GetPetEmptySlot = function(charIndex)
  for Slot=0,4 do
      local PetIndex = Char.GetPet(charIndex, Slot);
      --print(PetIndex);
      if (PetIndex < 0) then
          return Slot;
      end
  end
  return -1;
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
