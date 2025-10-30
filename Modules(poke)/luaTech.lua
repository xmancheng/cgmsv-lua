---ģ����
local Module = ModuleBase:createModule('luaTech')


--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleLuaSkillEvent', Func.bind(self.OnBattleLuaSkillEventCallback, self))

end


function Module:OnBattleLuaSkillEventCallback(battleIndex, charIndex, SKLFunc, DMGFunc)
  local charSide = Char.GetData(charIndex,CONST.����_ս��Side);
  local attkSlot = Char.GetData(charIndex,CONST.CHAR_BattleCom2);
  --print(charSide,attkSlot)
  local attkSlot = real_slot(battleIndex,attkSlot);
  local userTechId = Char.GetData(charIndex,CONST.CHAR_BattleCom3);
  local techIndex = Tech.GetTechIndex(userTechId);
  local tech_PM = Tech.GetData(techIndex, CONST.TECH_OPTION);
  local techlv = Tech.GetData(techIndex, CONST.TECH_NECESSARYLV);
  --local techrange = Tech.GetData(techIndex, CONST.TECH_TARGET);
  --Ŀ���D�Q�ɾ����
  local attkSlot_list = {};
  if (attkSlot<20) then
    table.insert(attkSlot_list, attkSlot);
  elseif (attkSlot>=20 and attkSlot<=29) then
    attkSlot_list = calcTarget(attkSlot);
  elseif (attkSlot>=30 and attkSlot<=39) then
    attkSlot_list = calcTarget(attkSlot);
  elseif (attkSlot==40) then
    attkSlot_list = {0,1,2,3,4,5,6,7,8,9};
  elseif (attkSlot==41) then
    attkSlot_list = {10,11,12,13,14,15,16,17,18,19};
  end
  local skillId = Tech.GetData(techIndex, CONST.TECH_SKILLID);
  local skillIndex = Skill.GetSkillIndex(skillId);
  local skilltype = Skill.GetData(skillIndex, CONST.SKILL_WHICHASSORT);		--0���� 1���Y 3ħ��

  --����и�Ŀ�����g
  table.forEach(attkSlot_list, function(e)
  local targetEnemy = Battle.GetPlayer(battleIndex, e);
  if (targetEnemy>0) then
    --������ʽ
    local dmg = calcDMG(skilltype,charIndex,targetEnemy);
    --tech�����ϵ�skill
    local skilltech = math.floor(tonumber(userTechId)/100)
    --print(e,targetEnemy,skilltech)
    if (skilltech==2009) then
      --���܄Ӯ��D�n
      --local techId = 200899+tonumber(techlv);
      local techId = 3019+tonumber(techlv);
      if e==attkSlot_list[1] then	--�޶�ֻ�lһ�βŲ���
        SKLFunc(techId);
      end
      --�@ʾ����ֵ
      Char.SetData(targetEnemy,CONST.����_Ѫ,Char.GetData(targetEnemy,CONST.����_Ѫ)-dmg);
      --���܄Ӯ����g(��ͬBM_FLAG)
      local targetEnemy_Com1 = Char.GetData(targetEnemy,CONST.CHAR_BattleCom1);
      local targetEnemy_Com2 = Char.GetData(targetEnemy,CONST.CHAR_BattleCom2);
      local targetEnemy_Com3 = Char.GetData(targetEnemy,CONST.CHAR_BattleCom3);
      --print(targetEnemy_Com1,targetEnemy_Com2,targetEnemy_Com3)
      if (targetEnemy_Com1==1 or targetEnemy_Com1==43) then		--GUARD=0x1.SPECIALGARD=0x2B
        local cri_rate = Char.GetData(charIndex,CONST.����_��ɱ);
        if ( cri_rate >= math.random(1,100) ) then
          local dmg = dmg*1.25;
          if ( Char.GetData(targetEnemy,CONST.����_Ѫ)<=0 ) then
            if (targetEnemy_Com1==1) then
              local dmg = dmg*0.8;
              DMGFunc(attkSlot,38,dmg);		--����0x20.��ɱ0x2.�������0x4
            elseif (targetEnemy_Com1==43) then
              local dmg = dmg*0.5;
              DMGFunc(attkSlot,1058,dmg);		--����0x20.��ɱ0x2.�}��0x400
            end
            Char.SetData(targetEnemy,CONST.����_ս��,1);
          else
            if (targetEnemy_Com1==1) then
              local dmg = dmg*0.8;
              DMGFunc(e,6,dmg);		--�ؚ����R
            elseif (targetEnemy_Com1==43) then
              local dmg = dmg*0.5;
              DMGFunc(e,1026,dmg);		--�ؚ��}��
            end
          end
        else
          if ( Char.GetData(targetEnemy,CONST.����_Ѫ)<=0 ) then
            if (targetEnemy_Com1==1) then
              local dmg = dmg*0.8;
              DMGFunc(attkSlot,37,dmg);		--����0x20.��ͨ0x1.�������0x4
            elseif (targetEnemy_Com1==43) then
              local dmg = dmg*0.5;
              DMGFunc(attkSlot,1057,dmg);		--����0x20.��ͨ0x1.�}��0x400
            end
            Char.SetData(targetEnemy,CONST.����_ս��,1);
          else
            if (targetEnemy_Com1==1) then
              local dmg = dmg*0.8;
              DMGFunc(e,5,dmg);			--��ͨ���R
            elseif (targetEnemy_Com1==43) then
              local dmg = dmg*0.5;
              DMGFunc(e,1025,dmg);		--��ͨ�}��
            end
          end
        end
        --���Еr�oĿ���O�Ô���(����Ч��)
        Char.SetData(targetEnemy,CONST.����_������, Char.GetData(targetEnemy,CONST.����_������)-10);
        Char.SetData(targetEnemy,CONST.CHAR_BattleModPoison,2);		--�ж�
        Char.SetData(targetEnemy,CONST.����_ENEMY_HeadGraNo,114175);
        NLG.UpChar(targetEnemy);
        NLG.UpChar(charIndex);
      elseif (targetEnemy_Com1==19 or targetEnemy_Com1==41) then		--EDGE=0x13.P_DODGE=0x29
        if (targetEnemy_Com1==41) then 
          DMGFunc(e,256,0);		--����W��
        else 
          DMGFunc(e,8,0);		--��ͨ�W��
        end
      elseif (skilltype==1 and (targetEnemy_Com1==51 or targetEnemy_Com1==52 or targetEnemy_Com1==53)) then		--�������o0x33~0x35
        if (targetEnemy_Com1==51) then DMGFunc(e,8192,0); end
        if (targetEnemy_Com1==52) then DMGFunc(e,16384,0); end
        if (targetEnemy_Com1==53) then DMGFunc(e,32768,0); end
      elseif (skilltype==3 and (targetEnemy_Com1==54 or targetEnemy_Com1==55 or targetEnemy_Com1==56)) then		--ħ�����o0x36~0x38
        if (targetEnemy_Com1==54) then DMGFunc(e,65536,0); end
        if (targetEnemy_Com1==55) then DMGFunc(e,131072,0); end
        if (targetEnemy_Com1==56) then DMGFunc(e,262144,0); end
      else
        --�Ƿ��R���}�ܓ��Еr(�Ƚ������o�l������)
        local cri_rate = Char.GetData(charIndex,CONST.����_��ɱ);
        if ( cri_rate >= math.random(1,100) ) then
          local dmg = dmg*1.25;
          if ( Char.GetData(targetEnemy,CONST.����_Ѫ)<=0 ) then
            if (dmg >= 2*Char.GetData(targetEnemy,CONST.����_���Ѫ)) then
              local AKO = math.random(1,2);
              if AKO==1 then DMGFunc(attkSlot,97,dmg); end
              if AKO==2 then DMGFunc(attkSlot,162,dmg); end
            else
              DMGFunc(attkSlot,34,dmg);		--����0x20.��ɱ0x2
            end
            Char.SetData(targetEnemy,CONST.����_ս��,1);
          else
            DMGFunc(e,2,dmg);		--�ؚ�
          end
        else
          if ( Char.GetData(targetEnemy,CONST.����_Ѫ)<=0 ) then
            if (dmg >= 2*Char.GetData(targetEnemy,CONST.����_���Ѫ)) then
              local AKO = math.random(1,2);
              if AKO==1 then DMGFunc(attkSlot,97,dmg); end
              if AKO==2 then DMGFunc(attkSlot,161,dmg); end
            else
              DMGFunc(attkSlot,33,dmg);		--����0x20.��ͨ0x1
            end
            Char.SetData(targetEnemy,CONST.����_ս��,1);
          else
            DMGFunc(e,1,dmg);		--��ͨ
          end
        end
        --���Еr�oĿ���O�Ô���(����Ч��)
        Char.SetData(targetEnemy,CONST.����_������, Char.GetData(targetEnemy,CONST.����_������)-10);
        Char.SetData(targetEnemy,CONST.CHAR_BattleModPoison,2);		--�ж�
        Char.SetData(targetEnemy,CONST.����_ENEMY_HeadGraNo,114175);
        NLG.UpChar(targetEnemy);
        NLG.UpChar(charIndex);
      end

    else
    end

  end
  end)


end


function real_slot(battleIndex,attkSlot)
  if (attkSlot<10) then
    local enemy = Battle.GetPlayer(battleIndex, attkSlot);
    local Slot = Battle.GetEntryPosition(battleIndex,enemy);
    return Slot
  elseif (attkSlot>=10 and attkSlot<20) then
    local enemy = Battle.GetPlayer(battleIndex, attkSlot);
    local Slot = Battle.GetEntryPosition(battleIndex,enemy);
    return Slot
  elseif (attkSlot>=20 and attkSlot<=29) then
    local enemy = Battle.GetPlayer(battleIndex, attkSlot-20);
    local Slot = Battle.GetEntryPosition(battleIndex,enemy);
    return Slot+20
  elseif (attkSlot>=30 and attkSlot<=39) then
    local enemy = Battle.GetPlayer(battleIndex, attkSlot-20);
    local Slot = Battle.GetEntryPosition(battleIndex,enemy);
    return Slot+20
  end
  return attkSlot
end

function calcTarget(attkSlot)
  local attkSlot_list = {};
  if attkSlot==20 then attkSlot_list = {0,1,2,5};
  elseif attkSlot==21 then attkSlot_list = {1,3,0,6};
  elseif attkSlot==22 then attkSlot_list = {2,5,0,7};
  elseif attkSlot==23 then attkSlot_list = {3,1,8};
  elseif attkSlot==24 then attkSlot_list = {4,2,9};
  elseif attkSlot==25 then attkSlot_list = {5,6,7,0};
  elseif attkSlot==26 then attkSlot_list = {6,8,5,1};
  elseif attkSlot==27 then attkSlot_list = {7,9,5,2};
  elseif attkSlot==28 then attkSlot_list = {8,6,3};
  elseif attkSlot==29 then attkSlot_list = {9,7,4};
  elseif attkSlot==30 then attkSlot_list = {10,11,12,15};
  elseif attkSlot==31 then attkSlot_list = {11,13,10,16};
  elseif attkSlot==32 then attkSlot_list = {12,15,10,17};
  elseif attkSlot==33 then attkSlot_list = {13,11,18};
  elseif attkSlot==34 then attkSlot_list = {14,12,19};
  elseif attkSlot==35 then attkSlot_list = {15,16,17,10};
  elseif attkSlot==36 then attkSlot_list = {16,18,15,11};
  elseif attkSlot==37 then attkSlot_list = {17,19,15,12};
  elseif attkSlot==38 then attkSlot_list = {18,16,13};
  elseif attkSlot==39 then attkSlot_list = {19,17,14};
  end
  return attkSlot_list
end

function calcDMG(skilltype,charIndex,targetEnemy)
    if (skilltype==1) then	--����������A��ʽ
      local ���ܹ����ӳ� = 100;	--Battle.GetTechOption(charIndex, DD:)
      local ���ܷ����ӳ� = 100;
      local ��幥�� = Char.GetData(charIndex,CONST.����_������);
      local ������ = Char.GetData(targetEnemy,CONST.����_������);
      local ���������չ��� = math.ceil((���ܹ����ӳ�)/ 100 * ��幥�� + ��幥��);
      local �����������շ��� = math.ceil((���ܷ����ӳ�) / 100 * ������ + ������);
      if ���������չ���>241 then ���չ��� = math.ceil((���������չ���-241)*0.3+241); else ���չ���=���������չ���; end
      if �����������շ���>241 then ���շ��� = math.ceil((�����������շ���-241)*0.3+241); else ���շ���=�����������շ���; end
      local �˺� = (���չ���*���չ���) / ( ���չ���/3+���շ��� );

      local ap = {}
      ap[1] = Char.GetData(charIndex, CONST.����_������);
      ap[2] = Char.GetData(charIndex, CONST.����_ˮ����);
      ap[3] = Char.GetData(charIndex, CONST.����_������);
      ap[4] = Char.GetData(charIndex, CONST.����_������);
      local dp = {}
      dp[1] = Char.GetData(charIndex, CONST.����_������);
      dp[2] = Char.GetData(charIndex, CONST.����_ˮ����);
      dp[3] = Char.GetData(charIndex, CONST.����_������);
      dp[4] = Char.GetData(charIndex, CONST.����_������);
      local ���Ԅw�� = Battle.CalcPropScore(ap, dp);
      local �N��w�� = Battle.CalcAttributeDmgRate(charIndex,targetEnemy);
      --print(���Ԅw��,�N��w��)
      local dmg = �˺� * ( 100 + ���Ԅw�� + �N��w�� ) / 100 * NLG.Rand(90,110) / 100 * math.ceil( 1 * 1 *  1.15 * ( 100 - 0 ) / 100 );		--���� * ( 100 + ���Ԅw�� + �N��w�� ) / 100 * rand(90,110) / 100 * [ ʯ���ۿ��� * Ұ��S������ *  ������������ * ( 100 - ��\�����p�� ) / 100 ]
      local dmg = math.floor(dmg);
      if (dmg<0) then dmg=20*(NLG.Rand(90,110)/100); end
      return dmg
    elseif (skilltype==3) then	--ħ���������A��ʽ
      local ���ܹ����ӳ� = 100;	--Battle.GetTechOption(charIndex, AR:)
      local ���ܷ����ӳ� = 100;
      local ��幥�� = Char.GetData(charIndex,CONST.����_����);
      local ������ = Char.GetData(targetEnemy,CONST.����_������)*0.5 + Char.GetData(targetEnemy,CONST.����_����)*1.15;
      local ���������չ��� = math.ceil((���ܹ����ӳ�)/ 100 * ��幥�� + ��幥��);
      local �����������շ��� = math.ceil((���ܷ����ӳ�) / 100 * ������ + ������);
      if ���������չ���>241 then ���չ��� = math.ceil((���������չ���-241)*0.3+241); else ���չ���=���������չ���; end
      if �����������շ���>241 then ���շ��� = math.ceil((�����������շ���-241)*0.3+241); else ���շ���=�����������շ���; end
      local �˺� = (���չ���*���չ���) / ( ���չ���/3+���շ��� );

      local ap = {}
      ap[1] = Char.GetData(charIndex, CONST.����_������);
      ap[2] = Char.GetData(charIndex, CONST.����_ˮ����);
      ap[3] = Char.GetData(charIndex, CONST.����_������);
      ap[4] = Char.GetData(charIndex, CONST.����_������);
      local dp = {}
      dp[1] = Char.GetData(charIndex, CONST.����_������);
      dp[2] = Char.GetData(charIndex, CONST.����_ˮ����);
      dp[3] = Char.GetData(charIndex, CONST.����_������);
      dp[4] = Char.GetData(charIndex, CONST.����_������);
      local ���Ԅw�� = Battle.CalcPropScore(ap, dp);
      local �N��w�� = Battle.CalcAttributeDmgRate(charIndex,targetEnemy);
      --print(���Ԅw��,�N��w��)
      local dmg = �˺� * ( 100 + (���Ԅw��*1.2) + �N��w�� ) / 100 * NLG.Rand(90,110) / 100 * math.ceil( 1 * 1 *  1.15 * ( 100 - 0 ) / 100 );		--���� * ( 100 + ���Ԅw�� + �N��w�� ) / 100 * rand(90,110) / 100 * [ ʯ���ۿ��� * Ұ��S������ *  ������������ * ( 100 - ��\�����p�� ) / 100 ]
      local dmg = math.floor(dmg);
      if (dmg<0) then dmg=20*(NLG.Rand(90,110)/100); end
      return dmg
    end
    return 1
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
