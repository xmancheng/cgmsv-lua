---模块类
local Module = ModuleBase:createModule('pokeCatch')

local pokeCatchNPC = {
    { Type=1, goCatch={"小火龍", 123000, 20251,14,6, 4}, warpMap={20230,131,384}, NpcEnemy=406198, Success=7 },
    { Type=2, goCatch={"妙蛙種子", 123005, 20251,13,6, 4}, warpMap={20230,131,384}, NpcEnemy=406203, Success=7  },
    { Type=3, goCatch={"傑尼龜", 123009, 20251,15,6, 4}, warpMap={20230,131,384}, NpcEnemy=406207, Success=7  },
    { Type=4, goCatch={"皮卡丘", 123014, 20251,3,3, 2}, warpMap={20230,131,384}, NpcEnemy=406212, Success=8  },
    { Type=5, goCatch={"波波", 123028, 20230,133,364, 6}, warpMap={20230,132,364}, NpcEnemy=406226, Success=6  },
    { Type=6, goCatch={"尼多朗", 123079, 20230,67,267, 4}, warpMap={20230,67,268}, NpcEnemy=406277, Success=6  },
    { Type=7, goCatch={"超音蝠", 123076, 20230,117,287, 6}, warpMap={20230,121,297}, NpcEnemy=406274, Success=4  },
    { Type=8, goCatch={"穿山鼠", 123092, 20230,115,292, 2}, warpMap={20230,121,297}, NpcEnemy=406290, Success=7  },
    { Type=9, goCatch={"獨角犀牛", 123080, 20230,147,206, 2}, warpMap={20230,134,206}, NpcEnemy=406278, Success=7  },
    { Type=10, goCatch={"腕力", 123134, 20230,152,206, 6}, warpMap={20230,134,206}, NpcEnemy=406332, Success=5  },
    { Type=11, goCatch={"胖丁", 123032, 20230,123,215, 4}, warpMap={20230,123,216}, NpcEnemy=406230, Success=5  },
}

tbl_pokeCatchNPCIndex = tbl_pokeCatchNPCIndex or {}

------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  --可捕捉的宝可梦
 for k,v in pairs(pokeCatchNPC) do
 if tbl_pokeCatchNPCIndex[k] == nil then
  local pokeCatchNPC = self:NPC_createNormal(v.goCatch[1], v.goCatch[2], { x = v.goCatch[4], y = v.goCatch[5], mapType = 0, map = v.goCatch[3], direction = v.goCatch[6] });
  tbl_pokeCatchNPCIndex[k] = pokeCatchNPC
  Char.SetData(pokeCatchNPC,CONST.对象_ENEMY_PetFlg+2,0)--可穿透体
  self:NPC_regTalkedEvent(tbl_pokeCatchNPCIndex[k], function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local msg = "\\n@c【收服時間】" ..	"\\n\\n\\n確定要嘗試使用捕捉球進行收服？";
        NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_是否, 1, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(tbl_pokeCatchNPCIndex[k], function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --local Target_FloorId = Char.GetData(player,CONST.对象_地图)--地图编号
    --local Target_X = Char.GetData(player,CONST.对象_X)--地图x
    --local Target_Y = Char.GetData(player,CONST.对象_Y)--地图y
    --local playerLv = Char.GetData(player,CONST.对象_等级);
    Field.Set(player, 'goCatch', k);
    local Type = tonumber(Field.Get(player, 'goCatch'));
    if (Type==v.Type) then
        --NPC的宠物
        local EnemyId = v.NpcEnemy;
        local EnemyBaseId = Data.GetEnemyBaseIdByEnemyId(EnemyId);
        local EnemyBaseDataIndex = Data.EnemyBaseGetDataIndex(EnemyBaseId);
        local EnemyName = Data.EnemyBaseGetData(EnemyBaseDataIndex, CONST.EnemyBase_名字);
        --local EnemyId = Data.EnemyBaseGetData(EnemyBaseDataIndex, CONST.EnemyBase_编号);
        --local EnemyDataIndex = Data.EnemyGetDataIndex(EnemyId)
        --local enemyLevel = Data.EnemyGetData(EnemyDataIndex, CONST.Enemy_最高等级);

        if select > 0 then
          if seqno == 1 and Char.PetNum(player)==5 and select == CONST.按钮_是 then
                NLG.SystemMessage(player,"[系統]寵物欄位置已滿。");
                 return;
          elseif seqno == 1 and select == CONST.按钮_否 then
                 return;
          elseif seqno == 1 and select == CONST.按钮_是 then
              if (EnemyId ~=nil and EnemyId>0) then
                  local CoinNo = 0;
                  if (Char.HaveItem(player,74087)>0) then	--球种决定硬币数
                    local CoinNo = 10;
                    local heads,reverses,same = heads(CoinNo);
                    local extraRate = v.Success;					--捕捉成功率最低要求5正面
                    if (heads < extraRate) then
                      Char.DelItem(player, 74087, 1);		--精灵球
                      NLG.Say(player,player,"收服吧！！",14,3);
                      if (Char.GetData(player,CONST.对象_队聊开关) == 1) then
                        NLG.SystemMessage(player,"擲出正面"..heads.."個 成功抽取需要"..extraRate.."個正面。");
                      end
                      NLG.PlaySe(player, 258, Char.GetData(player,CONST.对象_X), Char.GetData(player,CONST.对象_Y));
                      Char.DischargeParty(player);
                      Char.Warp(player,0, v.warpMap[1], v.warpMap[2], v.warpMap[3]);
                      NLG.SystemMessage(player,"[系統]收服失敗。");
                      return;
                    else
                      Char.GivePet(player,EnemyId,0);
                      Char.DelItem(player, 74087, 1);		--精灵球
                      NLG.Say(player,player,"收服吧！！",14,3);
                      NLG.PlaySe(player, 257, Char.GetData(player,CONST.对象_X), Char.GetData(player,CONST.对象_Y));
                      Char.DischargeParty(player);
                      Char.Warp(player,0, v.warpMap[1], v.warpMap[2], v.warpMap[3]);
                      NLG.SystemMessage(player, "[系统]"..EnemyName.."成功收服。");
                    end
                  elseif (Char.HaveItem(player,74088)>0) then	--球种决定硬币数
                    local CoinNo = 12;
                    local heads,reverses,same = heads(CoinNo);
                    local extraRate = v.Success;					--捕捉成功率最低要求5正面
                    if (heads < extraRate) then
                      Char.DelItem(player, 74088, 1);		--精灵球
                      NLG.Say(player,player,"收服吧！！",14,3);
                      if (Char.GetData(player,CONST.对象_队聊开关) == 1) then
                        NLG.SystemMessage(player,"擲出正面"..heads.."個 成功抽取需要"..extraRate.."個正面。");
                      end
                      NLG.PlaySe(player, 258, Char.GetData(player,CONST.对象_X), Char.GetData(player,CONST.对象_Y));
                      Char.DischargeParty(player);
                      Char.Warp(player,0, v.warpMap[1], v.warpMap[2], v.warpMap[3]);
                      NLG.SystemMessage(player,"[系統]收服失敗。");
                      return;
                    else
                      Char.GivePet(player,EnemyId,0);
                      Char.DelItem(player, 74088, 1);		--精灵球
                      NLG.Say(player,player,"收服吧！！",14,3);
                      NLG.PlaySe(player, 257, Char.GetData(player,CONST.对象_X), Char.GetData(player,CONST.对象_Y));
                      Char.DischargeParty(player);
                      Char.Warp(player,0, v.warpMap[1], v.warpMap[2], v.warpMap[3]);
                      NLG.SystemMessage(player, "[系统]"..EnemyName.."成功收服。");
                    end
                  else
                    Char.DischargeParty(player);
                    Char.Warp(player,0, v.warpMap[1], v.warpMap[2], v.warpMap[3]);
                    NLG.SystemMessage(player,"[系統]沒有任何球可以進行收服。");
                    return;
                  end
                  --local CoinNo = math.modf(playerLv/10);
                  --local heads,reverses,same = heads(CoinNo);
                  --local extraRate = math.modf(enemyLevel/15);
              elseif (EnemyId ==nil) then
                  Char.Warp(player,0, v.warpMap[1], v.warpMap[2], v.warpMap[3]);
                  NLG.SystemMessage(player,"[系統]這邊無法進行收服。");
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
-------功能设置
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

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;