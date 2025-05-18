---ģ����
local Module = ModuleBase:createModule('pokeCatch')

local pokeCatchNPC = {
    { Type=1, goCatch={"С����", 123000, 20251,14,6, 4}, warpMap={20230,131,384}, NpcEnemy=406198, Success=7 },
    { Type=2, goCatch={"���ܷN��", 123005, 20251,13,6, 4}, warpMap={20230,131,384}, NpcEnemy=406203, Success=7  },
    { Type=3, goCatch={"������", 123009, 20251,15,6, 4}, warpMap={20230,131,384}, NpcEnemy=406207, Success=7  },
    { Type=4, goCatch={"Ƥ����", 123014, 20251,3,3, 2}, warpMap={20230,131,384}, NpcEnemy=406212, Success=8  },
    { Type=5, goCatch={"����", 123028, 20230,133,364, 6}, warpMap={20230,132,364}, NpcEnemy=406226, Success=6  },
    { Type=6, goCatch={"�����", 123079, 20230,67,267, 4}, warpMap={20230,67,268}, NpcEnemy=406277, Success=6  },
    { Type=7, goCatch={"������", 123076, 20230,117,287, 6}, warpMap={20230,121,297}, NpcEnemy=406274, Success=4  },
    { Type=8, goCatch={"��ɽ��", 123092, 20230,115,292, 2}, warpMap={20230,121,297}, NpcEnemy=406290, Success=7  },
    { Type=9, goCatch={"����Ϭţ", 123080, 20230,147,206, 2}, warpMap={20230,134,206}, NpcEnemy=406278, Success=7  },
    { Type=10, goCatch={"����", 123134, 20230,152,206, 6}, warpMap={20230,134,206}, NpcEnemy=406332, Success=5  },
    { Type=11, goCatch={"�ֶ�", 123032, 20230,123,215, 4}, warpMap={20230,123,216}, NpcEnemy=406230, Success=5  },
}

tbl_pokeCatchNPCIndex = tbl_pokeCatchNPCIndex or {}

------------------------------------------------
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  --�ɲ�׽�ı�����
 for k,v in pairs(pokeCatchNPC) do
 if tbl_pokeCatchNPCIndex[k] == nil then
  local pokeCatchNPC = self:NPC_createNormal(v.goCatch[1], v.goCatch[2], { x = v.goCatch[4], y = v.goCatch[5], mapType = 0, map = v.goCatch[3], direction = v.goCatch[6] });
  tbl_pokeCatchNPCIndex[k] = pokeCatchNPC
  Char.SetData(pokeCatchNPC,CONST.����_ENEMY_PetFlg+2,0)--�ɴ�͸��
  self:NPC_regTalkedEvent(tbl_pokeCatchNPCIndex[k], function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local msg = "\\n@c���շ��r�g��" ..	"\\n\\n\\n�_��Ҫ�Lԇʹ�ò�׽���M���շ���";
        NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 1, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(tbl_pokeCatchNPCIndex[k], function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --local Target_FloorId = Char.GetData(player,CONST.����_��ͼ)--��ͼ���
    --local Target_X = Char.GetData(player,CONST.����_X)--��ͼx
    --local Target_Y = Char.GetData(player,CONST.����_Y)--��ͼy
    --local playerLv = Char.GetData(player,CONST.����_�ȼ�);
    Field.Set(player, 'goCatch', k);
    local Type = tonumber(Field.Get(player, 'goCatch'));
    if (Type==v.Type) then
        --NPC�ĳ���
        local EnemyId = v.NpcEnemy;
        local EnemyBaseId = Data.GetEnemyBaseIdByEnemyId(EnemyId);
        local EnemyBaseDataIndex = Data.EnemyBaseGetDataIndex(EnemyBaseId);
        local EnemyName = Data.EnemyBaseGetData(EnemyBaseDataIndex, CONST.EnemyBase_����);
        --local EnemyId = Data.EnemyBaseGetData(EnemyBaseDataIndex, CONST.EnemyBase_���);
        --local EnemyDataIndex = Data.EnemyGetDataIndex(EnemyId)
        --local enemyLevel = Data.EnemyGetData(EnemyDataIndex, CONST.Enemy_��ߵȼ�);

        if select > 0 then
          if seqno == 1 and Char.PetNum(player)==5 and select == CONST.��ť_�� then
                NLG.SystemMessage(player,"[ϵ�y]�����λ���ѝM��");
                 return;
          elseif seqno == 1 and select == CONST.��ť_�� then
                 return;
          elseif seqno == 1 and select == CONST.��ť_�� then
              if (EnemyId ~=nil and EnemyId>0) then
                  local CoinNo = 0;
                  if (Char.HaveItem(player,74087)>0) then	--���־���Ӳ����
                    local CoinNo = 10;
                    local heads,reverses,same = heads(CoinNo);
                    local extraRate = v.Success;					--��׽�ɹ������Ҫ��5����
                    if (heads < extraRate) then
                      Char.DelItem(player, 74087, 1);		--������
                      NLG.Say(player,player,"�շ��ɣ���",14,3);
                      if (Char.GetData(player,CONST.����_���Ŀ���) == 1) then
                        NLG.SystemMessage(player,"�S������"..heads.."�� �ɹ���ȡ��Ҫ"..extraRate.."�����档");
                      end
                      NLG.PlaySe(player, 258, Char.GetData(player,CONST.����_X), Char.GetData(player,CONST.����_Y));
                      Char.DischargeParty(player);
                      Char.Warp(player,0, v.warpMap[1], v.warpMap[2], v.warpMap[3]);
                      NLG.SystemMessage(player,"[ϵ�y]�շ�ʧ����");
                      return;
                    else
                      Char.GivePet(player,EnemyId,0);
                      Char.DelItem(player, 74087, 1);		--������
                      NLG.Say(player,player,"�շ��ɣ���",14,3);
                      NLG.PlaySe(player, 257, Char.GetData(player,CONST.����_X), Char.GetData(player,CONST.����_Y));
                      Char.DischargeParty(player);
                      Char.Warp(player,0, v.warpMap[1], v.warpMap[2], v.warpMap[3]);
                      NLG.SystemMessage(player, "[ϵͳ]"..EnemyName.."�ɹ��շ���");
                    end
                  elseif (Char.HaveItem(player,74088)>0) then	--���־���Ӳ����
                    local CoinNo = 12;
                    local heads,reverses,same = heads(CoinNo);
                    local extraRate = v.Success;					--��׽�ɹ������Ҫ��5����
                    if (heads < extraRate) then
                      Char.DelItem(player, 74088, 1);		--������
                      NLG.Say(player,player,"�շ��ɣ���",14,3);
                      if (Char.GetData(player,CONST.����_���Ŀ���) == 1) then
                        NLG.SystemMessage(player,"�S������"..heads.."�� �ɹ���ȡ��Ҫ"..extraRate.."�����档");
                      end
                      NLG.PlaySe(player, 258, Char.GetData(player,CONST.����_X), Char.GetData(player,CONST.����_Y));
                      Char.DischargeParty(player);
                      Char.Warp(player,0, v.warpMap[1], v.warpMap[2], v.warpMap[3]);
                      NLG.SystemMessage(player,"[ϵ�y]�շ�ʧ����");
                      return;
                    else
                      Char.GivePet(player,EnemyId,0);
                      Char.DelItem(player, 74088, 1);		--������
                      NLG.Say(player,player,"�շ��ɣ���",14,3);
                      NLG.PlaySe(player, 257, Char.GetData(player,CONST.����_X), Char.GetData(player,CONST.����_Y));
                      Char.DischargeParty(player);
                      Char.Warp(player,0, v.warpMap[1], v.warpMap[2], v.warpMap[3]);
                      NLG.SystemMessage(player, "[ϵͳ]"..EnemyName.."�ɹ��շ���");
                    end
                  else
                    Char.DischargeParty(player);
                    Char.Warp(player,0, v.warpMap[1], v.warpMap[2], v.warpMap[3]);
                    NLG.SystemMessage(player,"[ϵ�y]�]���κ�������M���շ���");
                    return;
                  end
                  --local CoinNo = math.modf(playerLv/10);
                  --local heads,reverses,same = heads(CoinNo);
                  --local extraRate = math.modf(enemyLevel/15);
              elseif (EnemyId ==nil) then
                  Char.Warp(player,0, v.warpMap[1], v.warpMap[2], v.warpMap[3]);
                  NLG.SystemMessage(player,"[ϵ�y]�@߅�o���M���շ���");
                  return;
              end
          else
              return;
          end
        end
    end
  end)
 end
 end


end
------------------------------------------------
-------��������
function heads(CoinNo)
	local h,r,s = 0,0,0;
	local result_tbl = {};
	for i=1,CoinNo do
		local result = NLG.Rand(0,1);
		table.insert(result_tbl,result);
	end
	for k,v in pairs(result_tbl) do
		if (v==1) then
			h = h + 1;
		elseif (v==0) then
			r = r + 1;
		end
	end
	if (h==#result_tbl or r==#result_tbl) then
		s = 1;
	end
	return h,r,s
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;