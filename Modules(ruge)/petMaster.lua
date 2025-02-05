---ģ����
local Module = ModuleBase:createModule('petMaster')

local StarSysOn = 0;
local StarRequireLevel = {10, 30, 50, 70, 100};
local StarRequireGold = {1000, 15000, 20000, 40000, 50000};

local StarEnable_check= {700066,700067,700068,700069,};
local StarEnable_list = {};
--StarEnable_list[700066] = { 1 };		--��1��:������LV3������100�㡢�����塢����������LV7
--StarEnable_list[700067] = { 2 };		--��2��:����(4�x1)LV3��ħ��100�㡢�����塢��������LV7
--StarEnable_list[700068] = { 3 };		--��3��:����(4�x1)LV3���ٶ�70��ħ��30�㡢�����塢��������LV7
--StarEnable_list[700069] = { 4 };		--��4��:�o��(4�x1)LV3������70��ħ��30�㡢�����塢�����o��LV7
StarEnable_list[700101] = {3, 1};		--��1��:ֻ���M��3��(ÿ�M��һ�������o����BP)
StarEnable_list[700102] = {3, 1};
StarEnable_list[700103] = {3, 2};		--��2��:ֻ���M��3��(ÿ�M��һ�������o��ħBP)
StarEnable_list[700104] = {3, 1};
StarEnable_list[700105] = {3, 1};
StarEnable_list[700106] = {3, 2};
StarEnable_list[700107] = {3, 2};
StarEnable_list[700108] = {3, 2};
StarEnable_list[700109] = {3, 2};
StarEnable_list[700110] = {3, 2};
StarEnable_list[700111] = {3, 1};
StarEnable_list[700112] = {3, 1};
StarEnable_list[700113] = {3, 2};
StarEnable_list[700114] = {3, 1};
StarEnable_list[700115] = {3, 1};
StarEnable_list[700116] = {3, 1};
StarEnable_list[700117] = {3, 1};
StarEnable_list[700118] = {3, 1};
StarEnable_list[700119] = {3, 2};
StarEnable_list[700120] = {3, 2};
StarEnable_list[700121] = {3, 2};
StarEnable_list[700122] = {5, 3};		--��3��:ֻ���M��5��(ÿ�M��һ�������o����BP)
StarEnable_list[700123] = {5, 3};
StarEnable_list[700124] = {5, 3};
StarEnable_list[700125] = {5, 3};
StarEnable_list[700126] = {5, 4};		--��4��:ֻ���M��5��(ÿ�M��һ�������o��ħBP)
StarEnable_list[700127] = {5, 4};
StarEnable_list[700128] = {5, 3};
StarEnable_list[700129] = {5, 3};
StarEnable_list[700130] = {5, 3};
StarEnable_list[700131] = {5, 4};
StarEnable_list[700132] = {5, 4};
StarEnable_list[700133] = {5, 3};

StarEnable_list[700201] = {5, 4};
StarEnable_list[700202] = {5, 3};
StarEnable_list[700203] = {5, 3};
StarEnable_list[700204] = {5, 4};
StarEnable_list[700205] = {5, 3};
StarEnable_list[700206] = {5, 4};
StarEnable_list[700207] = {5, 3};
StarEnable_list[700208] = {5, 3};

---------------------------------------------------------------------
local StarTech_list = {};
StarTech_list[700101] = { 1442 };		--���ܷN��.ïʢ
StarTech_list[700102] = { 1443 };		--С����.�ͻ�
StarTech_list[700103] = { 1444 };		--������.����
StarTech_list[700104] = { 1442 };		--ľľ�n.ïʢ
StarTech_list[700105] = { 1443 };		--�����.�ͻ�
StarTech_list[700106] = { 1444 };		--���򺣪{.����
StarTech_list[700107] = { 1442 };		--�ղ��~.ïʢ
StarTech_list[700108] = { 1443 };		--������.�ͻ�
StarTech_list[700109] = { 1444 };		--С��{.����
StarTech_list[700110] = { 1442 };		--ľ�،m.ïʢ
StarTech_list[700111] = { 1443 };		--�����u.�ͻ�
StarTech_list[700112] = { 1444 };		--ˮ�S�~.����
StarTech_list[700113] = { 1442 };		--������.ïʢ
StarTech_list[700114] = { 1443 };		--С�����.�ͻ�
StarTech_list[700115] = { 1444 };		--������.����
StarTech_list[700116] = { 1442 };		--������.ïʢ
StarTech_list[700117] = { 1443 };		--ůů�i.�ͻ�
StarTech_list[700118] = { 1444 };		--ˮˮ�H.����
StarTech_list[700119] = { 1442 };		--������.ïʢ
StarTech_list[700120] = { 1443 };		--�����.�ͻ�
StarTech_list[700121] = { 1444 };		--��������.����
StarTech_list[700122] = { 1445 };		--Ƥ����.�o�
StarTech_list[700123] = { 1446 };		--�׻���˹.����
StarTech_list[700124] = { 1441 };		--����.�����ؼ�
StarTech_list[700125] = { 1453 };		--���W·.����֮��
StarTech_list[700126] = { 1452 };		--���_��.����֮�|
StarTech_list[700127] = { 1447 };		--�A���.ɳ�[
StarTech_list[700128] = { 1452 };		--�ԒԶ�.����֮�|
StarTech_list[700129] = { 1448 };		--������Ɲ.���
StarTech_list[700130] = { 1450 };		--����.�m����
StarTech_list[700131] = { 1449 };		--�r����.�h��
StarTech_list[700132] = { 1449 };		--���{��.�h��
StarTech_list[700133] = { 1440 };		--���Ķ�.�J��Ŀ��

StarTech_list[700201] = { 1446 };		--���_��.����
StarTech_list[700202] = { 1450 };		--������.�m����
StarTech_list[700203] = { 1441 };		--С��ȸ.�����ؼ�
StarTech_list[700204] = { 1444 };		--���R����.����
StarTech_list[700205] = { 1442 };		--�����n.ïʢ
StarTech_list[700206] = { 1451 };		--¶������.���ȸ�
StarTech_list[700207] = { 1451 };		--�������ךW.���ȸ�
StarTech_list[700208] = { 1451 };		--�ο���Ɲ��.���ȸ�

-------------------------------------------------------------------------------------------------------------------------------------
--Զ�̰�ťUI����
function Module:petMasterInfo(npc, player)
          local msg = "�����������������������Ǽ�������\\n"
                              .. "����������$1��һ�����Ҫ�����Ǽ�����Ҫ����\\n"
                              .. "��������$2ע��:  ���Nλ�Ì����r����ό���^\\n"
          local petIndex = Char.GetPet(player,0);	--����̶���������һ��
          local PetId = Char.GetData(petIndex,CONST.PET_PetID);
          if (petIndex>=0 and CheckInTable(StarEnable_check, PetId)==true) then
              --��Ҫ����
              local PetName_1 = Char.GetData(petIndex,CONST.����_ԭ��);
              local PetImage_1 = Char.GetData(petIndex,CONST.����_����);
              local imageText_1 = "@g,"..PetImage_1..",3,8,6,0@"
              msg = msg .. "$4��Ҫ��: "..PetName_1
              --���ϳ���
              local materialPetIndex,mSlot = Char.GetMaterialPet(player,PetId);
              if (materialPetIndex>0) then
                  StarSysOn = 1;
                  local mSlot = mSlot+1;
                  local PetName_2 = Char.GetData(materialPetIndex,CONST.����_ԭ��);
                  local PetImage_2 = Char.GetData(materialPetIndex,CONST.����_����);
                  local imageText_2 = "@g,"..PetImage_2..",13,8,6,0@"
                  msg = msg .. "����$2���ό�(��"..mSlot.."��): "..PetName_2.."\\n"
                                        .. imageText_1 .. imageText_2;
              else
                  StarSysOn = 0;
                  msg = msg .. "����$2���ό�(��X��): �o����\\n"
                                        .. imageText_1;
              end
          else
              StarSysOn = 0;
              msg = msg .. "��Ҫ��: �ǿ��Ǽ������Č���" .. "\\n\\n\\n���ό�(��X��): �o����\\n";
          end
          NLG.ShowWindowTalked(player, self.MStarNPC, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 1, msg);
end

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('PetFieldEvent', function(player, petIndex, PetPos)
    local StarLv = Char.GetPetStar(player,PetPos);
    if (StarLv>=4) then
        Char.SetData(petIndex, CONST.����_PET_HeadGraNo,119646);
        NLG.UpChar(petIndex);
    end
    return 0;
  end)
  self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStarCommand, self))
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.OnbattleStarCommand, self))
  self.MStarNPC = self:NPC_createNormal('�����Ǽ�����', 104675, { x = 235, y = 116, mapType = 0, map = 1000, direction = 6 });
  self:NPC_regTalkedEvent(self.MStarNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local msg = "�����������������������Ǽ�������\\n"
                              .. "����������$1��һ�����Ҫ�����Ǽ�����Ҫ����\\n"
                              .. "��������$2ע��:  ���Nλ�Ì����r����ό���^\\n"
          local petIndex = Char.GetPet(player,0);	--����̶���������һ��
          local PetId = Char.GetData(petIndex,CONST.PET_PetID);
          if (petIndex>=0 and CheckInTable(StarEnable_check, PetId)==true) then
              --��Ҫ����
              local PetName_1 = Char.GetData(petIndex,CONST.����_ԭ��);
              local PetImage_1 = Char.GetData(petIndex,CONST.����_����);
              local imageText_1 = "@g,"..PetImage_1..",3,8,6,0@"
              msg = msg .. "$4��Ҫ��: "..PetName_1
              --���ϳ���
              local materialPetIndex,mSlot = Char.GetMaterialPet(player,PetId);
              if (materialPetIndex>0) then
                  StarSysOn = 1;
                  local mSlot = mSlot+1;
                  local PetName_2 = Char.GetData(materialPetIndex,CONST.����_ԭ��);
                  local PetImage_2 = Char.GetData(materialPetIndex,CONST.����_����);
                  local imageText_2 = "@g,"..PetImage_2..",13,8,6,0@"
                  msg = msg .. "����$2���ό�(��"..mSlot.."��): "..PetName_2.."\\n"
                                        .. imageText_1 .. imageText_2;
              else
                  StarSysOn = 0;
                  msg = msg .. "����$2���ό�(��X��): �o����\\n"
                                        .. imageText_1;
              end
          else
              StarSysOn = 0;
              msg = msg .. "��Ҫ��: �ǿ��Ǽ������Č���" .. "\\n\\n\\n���ό�(��X��): �o����\\n";
          end
          NLG.ShowWindowTalked(player, self.MStarNPC, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 1, msg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.MStarNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local tPlayerGold = Char.GetData(player, CONST.����_���);
    --print(data)
    if select > 0 then
      if (seqno == 1 and select == CONST.��ť_�ر�) then
                 return;
      elseif (seqno == 1 and select == CONST.��ť_ȷ��) then
          if (StarSysOn == 1) then
              local petIndex = Char.GetPet(player,0);
              local PetId = Char.GetData(petIndex,CONST.PET_PetID);
              local MaxStarLv = StarEnable_list[PetId][1];
              local Type = StarEnable_list[PetId][1];
              local PetName_1 = Char.GetData(petIndex,CONST.����_ԭ��);
              local PetLevel_1 = Char.GetData(petIndex,CONST.����_�ȼ�);
              local materialPetIndex,mSlot = Char.GetMaterialPet(player,PetId);
              local PetName_2 = Char.GetData(materialPetIndex,CONST.����_ԭ��);
              local PetGetLevel_2 = Char.GetData(materialPetIndex,CONST.����_��ȡʱ�ȼ�);
              if (PetGetLevel_2~=1) then
                  NLG.SystemMessage(player, "[ϵ�y] ���ό���Ǐ�1��Ӗ���Č�����");
                  return;
              end
              local last = string.find(PetName_1, "��", 1);
              if (last==nil) then
                  --���ͳԸ߻���
                  local last_2 = string.find(PetName_2, "��", 1);
                  if (last_2==nil) then StarLv_2 = 0; else StarLv_2=tonumber(string.sub(PetName_2, last_2+2, -1)); end
                  if ( 1<StarLv_2 ) then
                      NLG.SystemMessage(player, "[ϵ�y] Ո�_�J���ό�����Ǽ���");
                      return;
                  end
                  if (PetLevel_1<StarRequireLevel[1]) then
                      NLG.SystemMessage(player, "[ϵ�y] ��Ҫ����ĵȼ�δ�_".. StarRequireLevel[1] .."��");
                      return;
                  end
                  if (tPlayerGold<StarRequireGold[1]) then
                      NLG.SystemMessage(player, "[ϵ�y] �Ǽ�ϵ�y�����M�� "..StarRequireGold[1].."G��������Ų��㡣");
                      return;
                  end
                  local PetRawName = PetName_1;
                  Char.SetData(petIndex,CONST.����_ԭ��, PetRawName .. "��1");
                  RunStar(petIndex, Type, 1);
                  Char.DelSlotPet(player, mSlot);
                  Pet.UpPet(player,petIndex);
                  Char.AddGold(player, -StarRequireGold[1]);
                  NLG.UpChar(player);
                  NLG.SystemMessage(player, "[ϵ�y] ".. PetRawName .."�ɹ��M�����1��");
              elseif (last~=nil) then
                  local StarLv = tonumber(string.sub(PetName_1, last+2, -1));
                  local PetRawName = string.sub(PetName_1, 1, last-1);
                  if (StarLv>=1 and StarLv<MaxStarLv) then
                      --���ͳԸ߻���
                      local last_2 = string.find(PetName_2, "��", 1);
                      if (last_2==nil) then StarLv_2 = 0; else StarLv_2=tonumber(string.sub(PetName_2, last_2+2, -1)); end
                      if ( StarLv<StarLv_2 ) then
                          NLG.SystemMessage(player, "[ϵ�y] Ո�_�J���ό�����Ǽ���");
                          return;
                      end
                      local StarLv=StarLv+1;		--�������Ǽ�Lv
                      if (PetLevel_1<StarRequireLevel[StarLv]) then
                          NLG.SystemMessage(player, "[ϵ�y] ��Ҫ����ĵȼ�δ�_".. StarRequireLevel[StarLv] .."��");
                          return;
                      end
                      if (tPlayerGold<StarRequireGold[StarLv]) then
                          NLG.SystemMessage(player, "[ϵ�y] �Ǽ�ϵ�y�����M�� "..StarRequireGold[StarLv].."G��������Ų��㡣");
                          return;
                      end
                      Char.SetData(petIndex,CONST.����_ԭ��, PetRawName .. "��".. StarLv);
                      RunStar(petIndex, Type, StarLv);
                      Char.DelSlotPet(player, mSlot);
                      Pet.UpPet(player,petIndex);
                      Char.AddGold(player, -StarRequireGold[StarLv]);
                      NLG.UpChar(player);
                      NLG.SystemMessage(player, "[ϵ�y] ".. PetRawName .."�ɹ��M�����".. StarLv .."��");
                  else
                      NLG.SystemMessage(player, "[ϵ�y] �Ǽ����_Ŀǰ�_�����ޡ�");
                      return;
                  end
              end
          elseif (StarSysOn == 0) then
              NLG.SystemMessage(player, "[ϵ�y] �l�������ϣ��Ǽ�ϵ�yֹͣ������");
              return;
          end
      end
    else

    end
  end)


end

function Module:OnbattleStarCommand(battleIndex)
    for i=0, 19 do
        local petIndex = Battle.GetPlayIndex(battleIndex, i)
        if (petIndex>=0 and Char.IsPet(petIndex)) then
            local PetName = Char.GetData(petIndex,CONST.����_ԭ��);
            local last = string.find(PetName, "��", 1);
            if (last==nil) then
                    NLG.UpChar(petIndex);
            elseif (last~=nil) then
                local StarLv = tonumber(string.sub(PetName, last+2, -1));
                if (StarLv>=4) then
                    Char.SetData(petIndex, CONST.����_PET_HeadGraNo,119646);
                    NLG.UpChar(petIndex);
                else
                    NLG.UpChar(petIndex);
                end
            end
        end
    end
end


--�����ͳ�������ִ��
function RunStar(petIndex,Type,StarLv)
	local PetId = Char.GetData(petIndex,CONST.PET_PetID);
	if (Type==1) then
		if (StarLv==1) then		--��1
			Char.SetData(petIndex,CONST.����_����, Char.GetData(petIndex,CONST.����_����)+500);
			Char.SetData(petIndex,CONST.����_�ٶ�, Char.GetData(petIndex,CONST.����_�ٶ�)+500);
		elseif (StarLv==2) then	--��2
			Char.SetData(petIndex,CONST.����_����, Char.GetData(petIndex,CONST.����_����)+1000);
			Char.SetData(petIndex,CONST.����_�ٶ�, Char.GetData(petIndex,CONST.����_�ٶ�)+1000);
		elseif (StarLv==3) then	--��3
			Char.SetData(petIndex,CONST.����_����, Char.GetData(petIndex,CONST.����_����)+2000);
			Char.SetData(petIndex,CONST.����_�ٶ�, Char.GetData(petIndex,CONST.����_�ٶ�)+2000);
			if StarTech_list[PetId][1]>0 then
				Pet.AddSkill(petIndex,StarTech_list[PetId][1],8);
			end
		end
	elseif (Type==2) then
		if (StarLv==1) then		--��1
			Char.SetData(petIndex,CONST.����_ħ��, Char.GetData(petIndex,CONST.����_ħ��)+500);
			Char.SetData(petIndex,CONST.����_�ٶ�, Char.GetData(petIndex,CONST.����_�ٶ�)+500);
		elseif (StarLv==2) then	--��2
			Char.SetData(petIndex,CONST.����_ħ��, Char.GetData(petIndex,CONST.����_ħ��)+1000);
			Char.SetData(petIndex,CONST.����_�ٶ�, Char.GetData(petIndex,CONST.����_�ٶ�)+1000);
		elseif (StarLv==3) then	--��3
			Char.SetData(petIndex,CONST.����_ħ��, Char.GetData(petIndex,CONST.����_ħ��)+2000);
			Char.SetData(petIndex,CONST.����_�ٶ�, Char.GetData(petIndex,CONST.����_�ٶ�)+2000);
			if StarTech_list[PetId][1]>0 then
				Pet.AddSkill(petIndex,StarTech_list[PetId][1],8);
			end
		end
	elseif (Type==3) then
		if (StarLv==1) then		--��1
			Char.SetData(petIndex,CONST.����_����, Char.GetData(petIndex,CONST.����_����)+500);
			Char.SetData(petIndex,CONST.����_�ٶ�, Char.GetData(petIndex,CONST.����_�ٶ�)+500);
		elseif (StarLv==2) then	--��2
			Char.SetData(petIndex,CONST.����_����, Char.GetData(petIndex,CONST.����_����)+800);
			Char.SetData(petIndex,CONST.����_�ٶ�, Char.GetData(petIndex,CONST.����_�ٶ�)+800);
		elseif (StarLv==3) then	--��3
			Char.SetData(petIndex,CONST.����_����, Char.GetData(petIndex,CONST.����_����)+1200);
			Char.SetData(petIndex,CONST.����_�ٶ�, Char.GetData(petIndex,CONST.����_�ٶ�)+1200);
		elseif (StarLv==4) then	--��4
			Char.SetData(petIndex,CONST.����_����, Char.GetData(petIndex,CONST.����_����)+1500);
			Char.SetData(petIndex,CONST.����_�ٶ�, Char.GetData(petIndex,CONST.����_�ٶ�)+1500);
			if StarTech_list[PetId][1]>0 then
				Pet.AddSkill(petIndex,StarTech_list[PetId][1],8);
			else
				local techSet = {1440,1441}
				local techRand = NLG.Rand(1,2);
				Pet.AddSkill(petIndex, techSet[techRand],8);
			end
		elseif (StarLv==5) then	--��5
			Char.SetData(petIndex,CONST.����_����, Char.GetData(petIndex,CONST.����_����)+3000);
			Char.SetData(petIndex,CONST.����_�ٶ�, Char.GetData(petIndex,CONST.����_�ٶ�)+3000);
		end
	elseif (Type==4) then
		if (StarLv==1) then		--��1
			Char.SetData(petIndex,CONST.����_ħ��, Char.GetData(petIndex,CONST.����_ħ��)+500);
			Char.SetData(petIndex,CONST.����_�ٶ�, Char.GetData(petIndex,CONST.����_�ٶ�)+500);
		elseif (StarLv==2) then	--��2
			Char.SetData(petIndex,CONST.����_ħ��, Char.GetData(petIndex,CONST.����_ħ��)+800);
			Char.SetData(petIndex,CONST.����_�ٶ�, Char.GetData(petIndex,CONST.����_�ٶ�)+800);
		elseif (StarLv==3) then	--��3
			Char.SetData(petIndex,CONST.����_ħ��, Char.GetData(petIndex,CONST.����_ħ��)+1200);
			Char.SetData(petIndex,CONST.����_�ٶ�, Char.GetData(petIndex,CONST.����_�ٶ�)+1200);
		elseif (StarLv==4) then	--��4
			Char.SetData(petIndex,CONST.����_ħ��, Char.GetData(petIndex,CONST.����_ħ��)+1500);
			Char.SetData(petIndex,CONST.����_�ٶ�, Char.GetData(petIndex,CONST.����_�ٶ�)+1500);
			if StarTech_list[PetId][1]>0 then
				Pet.AddSkill(petIndex,StarTech_list[PetId][1],8);
			else
				local techSet = {1440,1441}
				local techRand = NLG.Rand(1,2);
				Pet.AddSkill(petIndex, techSet[techRand],8);
			end
		elseif (StarLv==5) then	--��5
			Char.SetData(petIndex,CONST.����_ħ��, Char.GetData(petIndex,CONST.����_ħ��)+3000);
			Char.SetData(petIndex,CONST.����_�ٶ�, Char.GetData(petIndex,CONST.����_�ٶ�)+3000);
		end
--[[
	if (Type==1) then
		if (StarLv==1) then		--��1
			Pet.AddSkill(petIndex, 402);
		elseif (StarLv==2) then	--��2
			Char.SetData(petIndex,CONST.����_����, Char.GetData(petIndex,CONST.����_����)+10000);
		elseif (StarLv==3) then	--��3
			Char.SetData(petIndex,CONST.����_����, 11);
		elseif (StarLv==4) then	--��4
			for i = 0,9 do
				if (Pet.GetSkill(petIndex,i)==402) then
					Pet.DelSkill(petIndex,i);
					Pet.AddSkill(petIndex,406);
				end
			end
		end
	elseif (Type==2) then
		if (StarLv==1) then		--��1
			local magicSet = {2702,2802,2902,3002}
			local magicRand = NLG.Rand(1,4);
			Pet.AddSkill(petIndex, magicSet[magicRand]);
		elseif (StarLv==2) then	--��2
			Char.SetData(petIndex,CONST.����_ħ��, Char.GetData(petIndex,CONST.����_ħ��)+10000);
		elseif (StarLv==3) then	--��3
			Char.SetData(petIndex,CONST.����_����, 11);
		elseif (StarLv==4) then	--��4
			for i = 0,9 do
				if (Pet.GetSkill(petIndex,i)==2702) then
					Pet.DelSkill(petIndex,i);
					Pet.AddSkill(petIndex,2706);
				elseif (Pet.GetSkill(petIndex,i)==2802) then
					Pet.DelSkill(petIndex,i);
					Pet.AddSkill(petIndex,2806);
				elseif (Pet.GetSkill(petIndex,i)==2902) then
					Pet.DelSkill(petIndex,i);
					Pet.AddSkill(petIndex,2906);
				elseif (Pet.GetSkill(petIndex,i)==3002) then
					Pet.DelSkill(petIndex,i);
					Pet.AddSkill(petIndex,3006);
				end
			end
		end
	elseif (Type==3) then
		if (StarLv==1) then		--��1
			local magicSet = {4402,4502,4602,4802}
			local magicRand = NLG.Rand(1,4);
			Pet.AddSkill(petIndex, magicSet[magicRand]);
		elseif (StarLv==2) then	--��2
			Char.SetData(petIndex,CONST.����_�ٶ�, Char.GetData(petIndex,CONST.����_�ٶ�)+7000);
			Char.SetData(petIndex,CONST.����_ħ��, Char.GetData(petIndex,CONST.����_ħ��)+3000);
		elseif (StarLv==3) then	--��3
			Char.SetData(petIndex,CONST.����_����, 11);
		elseif (StarLv==4) then	--��4
			for i = 0,9 do
				if (Pet.GetSkill(petIndex,i)==4402) then
					Pet.DelSkill(petIndex,i);
					Pet.AddSkill(petIndex,4406);
				elseif (Pet.GetSkill(petIndex,i)==4502) then
					Pet.DelSkill(petIndex,i);
					Pet.AddSkill(petIndex,4506);
				elseif (Pet.GetSkill(petIndex,i)==4602) then
					Pet.DelSkill(petIndex,i);
					Pet.AddSkill(petIndex,4606);
				elseif (Pet.GetSkill(petIndex,i)==4802) then
					Pet.DelSkill(petIndex,i);
					Pet.AddSkill(petIndex,4806);
				end
			end
		end
	elseif (Type==4) then
		if (StarLv==1) then		--��1
			local magicSet = {6302,6602,6702,6802}
			local magicRand = NLG.Rand(1,4);
			Pet.AddSkill(petIndex, magicSet[magicRand]);
		elseif (StarLv==2) then	--��2
			Char.SetData(petIndex,CONST.����_����, Char.GetData(petIndex,CONST.����_����)+7000);
			Char.SetData(petIndex,CONST.����_ħ��, Char.GetData(petIndex,CONST.����_ħ��)+3000);
		elseif (StarLv==3) then	--��3
			Char.SetData(petIndex,CONST.����_����, 11);
		elseif (StarLv==4) then	--��4
			for i = 0,9 do
				if (Pet.GetSkill(petIndex,i)==6302) then
					Pet.DelSkill(petIndex,i);
					Pet.AddSkill(petIndex,6306);
				elseif (Pet.GetSkill(petIndex,i)==6602) then
					Pet.DelSkill(petIndex,i);
					Pet.AddSkill(petIndex,6606);
				elseif (Pet.GetSkill(petIndex,i)==6702) then
					Pet.DelSkill(petIndex,i);
					Pet.AddSkill(petIndex,6706);
				elseif (Pet.GetSkill(petIndex,i)==6802) then
					Pet.DelSkill(petIndex,i);
					Pet.AddSkill(petIndex,6806);
				end
			end
		end
]]
	else
	end
end

--����ӿ�
Char.GetMaterialPet = function(charIndex,enemyid)
  for Slot=1,4 do
      local PetIndex = Char.GetPet(charIndex, Slot);
      if (PetIndex >= 0) then
          local MPetId = Char.GetData(PetIndex,CONST.PET_PetID);
          --print(PetIndex,enemyid,MPetId);
          if (enemyid==MPetId) then
              return PetIndex,Slot;
          end
      end
  end
  return -1,-1;
end

Char.GetPetStar = function(playerIndex,slot)
  local petIndex = Char.GetPet(playerIndex, slot);
  if petIndex >= 0 then
    local PetName = Char.GetData(petIndex,CONST.����_ԭ��);
    local last = string.find(PetName, "��", 1);
    if (last==nil) then
        local StarLv = 0;
        return StarLv;
    elseif (last~=nil) then
        local StarLv = tonumber(string.sub(PetName, last+2, -1));
        return StarLv;
    end
  end
  return -1;
end

function CheckInTable(_idTab, _idVar) ---ѭ������
	for k,v in pairs(_idTab) do
		if v==_idVar then
			return true
		end
	end
	return false
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
