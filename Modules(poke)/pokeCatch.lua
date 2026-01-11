---模块类
local Module = ModuleBase:createModule('pokeCatch')

local pokeCatchNPC = {
    { Type=1, goCatch={"阿勃梭魯", 120000, 20334,35,54, 6}, warpMap={1000,242,88}, NpcItemId=76000, Success=7 },
    { Type=2, goCatch={"化石翼龍", 120002, 20334,63,13, 4}, warpMap={1000,242,88}, NpcItemId=76001, Success=7  },
    { Type=3, goCatch={"波士可多拉", 120005, 20334,81,78, 4}, warpMap={1000,242,88}, NpcItemId=76002, Success=7  },
    { Type=4, goCatch={"電龍", 120007, 20334,82,25, 6}, warpMap={1000,242,88}, NpcItemId=76003, Success=8  },
    { Type=5, goCatch={"砰頭小丑", 120017, 20334,59,67, 4}, warpMap={1000,242,88}, NpcItemId=76008, Success=6  },
    { Type=6, goCatch={"火焰雞", 120021, 20334,82,29, 6}, warpMap={1000,242,88}, NpcItemId=76010, Success=8  },
    { Type=7, goCatch={"幸福蛋", 120023, 20334,7,19, 5}, warpMap={1000,242,88}, NpcItemId=76011, Success=6  },
    { Type=8, goCatch={"快龍", 120037, 20334,81,52, 2}, warpMap={1000,242,88}, NpcItemId=76018, Success=12  },
    { Type=9, goCatch={"沙漠蜻蜓", 120047, 20334,16,79, 4}, warpMap={1000,242,88}, NpcItemId=76023, Success=7  },
    { Type=10, goCatch={"呱頭蛙", 120049, 20334,22,45, 6}, warpMap={1000,242,88}, NpcItemId=76024, Success=5  },
    { Type=11, goCatch={"尖牙陸鯊", 120051, 20334,82,33, 6}, warpMap={1000,242,88}, NpcItemId=76025, Success=7  },
    { Type=12, goCatch={"沙奈朵", 120053, 20334,69,61, 2}, warpMap={1000,242,88}, NpcItemId=76026, Success=10  },
    { Type=13, goCatch={"耿鬼", 120055, 20334,91,18, 2}, warpMap={1000,242,88}, NpcItemId=76027, Success=10  },
    { Type=14, goCatch={"黏美龍", 120061, 20334,62,31, 3}, warpMap={1000,242,88}, NpcItemId=76030, Success=10  },
    { Type=15, goCatch={"黑魯加", 120077, 20334,44,56, 4}, warpMap={1000,242,88}, NpcItemId=76038, Success=10  },
    { Type=16, goCatch={"三首惡龍", 120079, 20334,56,56, 4}, warpMap={1000,242,88}, NpcItemId=76039, Success=9  },
    { Type=17, goCatch={"銀伴戰獸", 120196, 20334,48,76, 4}, warpMap={1000,242,88}, NpcItemId=76065, Success=9  },
    { Type=18, goCatch={"瑪狃拉", 120218, 20334,41,56, 4}, warpMap={1000,242,88}, NpcItemId=76076, Success=9  },

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
        local msg = "\\n@c【解救喚獸】" ..	"\\n\\n\\n確定要使用身上的球收服他嗎？";
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
        local MonsName = v.goCatch[1];
        --[[local EnemyId = v.NpcEnemy;
        local EnemyBaseId = Data.GetEnemyBaseIdByEnemyId(EnemyId);
        local EnemyBaseDataIndex = Data.EnemyBaseGetDataIndex(EnemyBaseId);
        local EnemyName = Data.EnemyBaseGetData(EnemyBaseDataIndex, CONST.EnemyBase_名字);]]
        --local EnemyId = Data.EnemyBaseGetData(EnemyBaseDataIndex, CONST.EnemyBase_编号);
        --local EnemyDataIndex = Data.EnemyGetDataIndex(EnemyId)
        --local enemyLevel = Data.EnemyGetData(EnemyDataIndex, CONST.Enemy_最高等级);

        if select > 0 then
          if seqno == 1 and Char.ItemSlot(player)==Char.GetData(player,CONST.对象_道具栏) and select == CONST.按钮_是 then
                 NLG.SystemMessage(player,"[系統]物品欄位置已滿。");
                 return;
          elseif seqno == 1 and select == CONST.按钮_否 then
                 return;
          elseif seqno == 1 and select == CONST.按钮_是 then
              --if (EnemyName~=nil and EnemyId>0) then
                  local CoinNo = 0;
                  if (Char.HaveItem(player,74087)>0) then	--球种决定硬币数
                    local CoinNo = 12;
                    local heads,reverses,same = heads(CoinNo);
                    local extraRate = v.Success;					--捕捉成功率最低要求5正面
                    if (heads < extraRate) then
                      Char.DelItem(player, 74087, 1);		--精灵球
                      NLG.Say(player,player,"收服吧！！",14,3);
                      if (Char.GetData(player,CONST.对象_队聊开关) == 1) then
                        NLG.SystemMessage(player,"擲出正面"..heads.."個 成功收服需要"..extraRate.."個正面。");
                      end
                      NLG.PlaySe(player, 258, Char.GetData(player,CONST.对象_X), Char.GetData(player,CONST.对象_Y));
                      --Char.DischargeParty(player);
                      --Char.Warp(player,0, v.warpMap[1], v.warpMap[2], v.warpMap[3]);
                      NLG.SystemMessage(player,"[系統]收服失敗。");
                      return;
                    else
                      Char.DelItem(player, 74087, 1);		--精灵球
                      Char.GiveItem(player, v.NpcItemId, 1);	--唤兽球
                      NLG.Say(player,player,"收服吧！！",14,3);
                      NLG.PlaySe(player, 257, Char.GetData(player,CONST.对象_X), Char.GetData(player,CONST.对象_Y));
                      --Char.DischargeParty(player);
                      --Char.Warp(player,0, v.warpMap[1], v.warpMap[2], v.warpMap[3]);
                      NLG.SystemMessage(player, "[系统]"..MonsName.."成功收服。");
                    end
                  elseif (Char.HaveItem(player,74088)>0) then	--球种决定硬币数
                    local CoinNo = 18;
                    local heads,reverses,same = heads(CoinNo);
                    local extraRate = v.Success;					--捕捉成功率最低要求5正面
                    if (heads < extraRate) then
                      Char.DelItem(player, 74088, 1);		--精灵球
                      NLG.Say(player,player,"收服吧！！",14,3);
                      if (Char.GetData(player,CONST.对象_队聊开关) == 1) then
                        NLG.SystemMessage(player,"擲出正面"..heads.."個 成功收服需要"..extraRate.."個正面。");
                      end
                      NLG.PlaySe(player, 258, Char.GetData(player,CONST.对象_X), Char.GetData(player,CONST.对象_Y));
                      --Char.DischargeParty(player);
                      --Char.Warp(player,0, v.warpMap[1], v.warpMap[2], v.warpMap[3]);
                      NLG.SystemMessage(player,"[系統]收服失敗。");
                      return;
                    else
                      Char.DelItem(player, 74088, 1);		--精灵球
                      Char.GiveItem(player, v.NpcItemId, 1);	--唤兽球
                      NLG.Say(player,player,"收服吧！！",14,3);
                      NLG.PlaySe(player, 257, Char.GetData(player,CONST.对象_X), Char.GetData(player,CONST.对象_Y));
                      --Char.DischargeParty(player);
                      --Char.Warp(player,0, v.warpMap[1], v.warpMap[2], v.warpMap[3]);
                      NLG.SystemMessage(player, "[系统]"..MonsName.."成功收服。");
                    end
                  elseif (Char.HaveItem(player,74090)>0) then	--球种决定硬币数
                    local CoinNo = 30;
                    local heads,reverses,same = heads(CoinNo);
                    local extraRate = v.Success;					--捕捉成功率最低要求5正面
                    if (heads < extraRate) then
                      Char.DelItem(player, 74090, 1);		--精灵球
                      NLG.Say(player,player,"收服吧！！",14,3);
                      if (Char.GetData(player,CONST.对象_队聊开关) == 1) then
                        NLG.SystemMessage(player,"擲出正面"..heads.."個 成功收服需要"..extraRate.."個正面。");
                      end
                      NLG.PlaySe(player, 258, Char.GetData(player,CONST.对象_X), Char.GetData(player,CONST.对象_Y));
                      --Char.DischargeParty(player);
                      --Char.Warp(player,0, v.warpMap[1], v.warpMap[2], v.warpMap[3]);
                      NLG.SystemMessage(player,"[系統]收服失敗。");
                      return;
                    else
                      Char.DelItem(player, 74090, 1);		--精灵球
                      Char.GiveItem(player, v.NpcItemId, 1);	--唤兽球
                      NLG.Say(player,player,"收服吧！！",14,3);
                      NLG.PlaySe(player, 257, Char.GetData(player,CONST.对象_X), Char.GetData(player,CONST.对象_Y));
                      --Char.DischargeParty(player);
                      --Char.Warp(player,0, v.warpMap[1], v.warpMap[2], v.warpMap[3]);
                      NLG.SystemMessage(player, "[系统]"..MonsName.."成功收服。");
                    end
                  else
                    --Char.DischargeParty(player);
                    --Char.Warp(player,0, v.warpMap[1], v.warpMap[2], v.warpMap[3]);
                    NLG.SystemMessage(player,"[系統]沒有任何球可以進行收服。");
                    return;
                  end
                  --local CoinNo = math.modf(playerLv/10);
                  --local heads,reverses,same = heads(CoinNo);
                  --local extraRate = math.modf(enemyLevel/15);
              --elseif (EnemyName==nil) then
              --    Char.Warp(player,0, v.warpMap[1], v.warpMap[2], v.warpMap[3]);
              --    NLG.SystemMessage(player,"[系統]這邊無法進行收服。");
              --    return;
              --end
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