---模块类
local Module = ModuleBase:createModule('pokeTrainer')

local maxTrainerLevel = 100;
local PokeTrainer = {
      { palType=1, palNum=1, palName="捕蟲少年", palImage=105002, prestige=1000, gold=500,	--palNum数量(1不更动)、palImage外显形象(不重复)、声望、魔币
         popArea={map=80022,LX=59,LY=75, RX=59,RY=75}, watchArea={map=80022,LX=55,LY=73, RX=61,RY=80},		--出没范围(方形坐标)、监视范围(方形坐标)
         talk="捕蟲少年：讓你看看我抓到的蟲蟲。", loveItem={69014,69014,69014}, giftItem={607700,46630,75026,69088,73059}, },		--开战对话，礼物(1)礼物(∞)礼物(∞)，亲密度20、40、60、80、100之一次性奖励
      { palType=2, palNum=1, palName="養鳥人", palImage=106039, prestige=2000, gold=1000,
         popArea={map=80023,LX=47,LY=63, RX=47,RY=63}, watchArea={map=80023,LX=41,LY=61, RX=49,RY=66},
         talk="養鳥人：往來的旅行者接受我的挑戰吧。", loveItem={69013,69013,69013}, giftItem={607701,46631,75026,73023,73023}, },
      { palType=3, palNum=1, palName="登山男", palImage=106577, prestige=2000, gold=1000,
         popArea={map=80013,LX=38,LY=41, RX=38,RY=41}, watchArea={map=80013,LX=38,LY=35, RX=45,RY=42},
         talk="登山男：嘗嘗我的厲害。", loveItem={69011,69011,69011}, giftItem={607702,46632,75026,73056,73056}, },
      { palType=4, palNum=1, palName="赤紅", palImage=105039, prestige=2500, gold=1500,
         popArea={map=80023,LX=62,LY=84, RX=62,RY=84}, watchArea={map=80023,LX=57,LY=76, RX=66,RY=84},
         talk="赤紅：上吧！我的夥伴們。", loveItem={69014,69014,69014}, giftItem={607703,46633,75026,69084,69084}, },
      { palType=5, palNum=1, palName="青綠", palImage=105139, prestige=2500, gold=1500,
         popArea={map=80023,LX=83,LY=44, RX=83,RY=44}, watchArea={map=80023,LX=77,LY=40, RX=82,RY=48},
         talk="青綠：弱者還敢四處逛。", loveItem={69011,69011,69011}, giftItem={607704,46633,75026,69081,69081}, },
      { palType=6, palNum=1, palName="小藍", palImage=105258, prestige=2500, gold=1500,
         popArea={map=80023,LX=79,LY=67, RX=79,RY=67}, watchArea={map=80023,LX=74,LY=64, RX=77,RY=70},
         talk="小藍：華麗的噴射水柱。", loveItem={69012,69012,69012}, giftItem={607705,46632,75026,69083,69083}, },
      { palType=7, palNum=1, palName="祈祷師", palImage=106310, prestige=2000, gold=1000,
         popArea={map=80014,LX=53,LY=45, RX=53,RY=45}, watchArea={map=80014,LX=39,LY=45, RX=67,RY=54},
         talk="祈祷師：你見過幽靈嗎？你說沒看過！我就讓你看看！", loveItem={69013,69013,69013}, giftItem={607706,46631,75026,69082,69082}, },
      { palType=8, palNum=1, palName="空手道王", palImage=105170, prestige=2000, gold=1000,
         popArea={map=80011,LX=76,LY=72, RX=76,RY=72}, watchArea={map=80011,LX=64,LY=62, RX=77,RY=78},
         talk="空手道王：心靈合一。", loveItem={69011,69011,69011}, giftItem={607706,46630,75026,73016,73016}, },
      { palType=9, palNum=1, palName="遺跡迷", palImage=106008, prestige=2000, gold=1000,
         popArea={map=80019,LX=38,LY=71, RX=61,RY=71}, watchArea={map=80019,LX=38,LY=71, RX=61,RY=74},
         talk="遺跡迷：我愛遺跡，更愛從對戰中得到樂趣。", loveItem={69011,69011,69011}, giftItem={607707,46630,75026,69086,69086}, },
      { palType=10, palNum=1, palName="忍者小子", palImage=106053, prestige=2000, gold=1000,
         popArea={map=80013,LX=38,LY=47, RX=38,RY=47}, watchArea={map=80013,LX=37,LY=46, RX=43,RY=52},
         talk="忍者小子：你被忍者伏擊了。", loveItem={69011,69011,69011}, giftItem={607708,46631,75026,73014,73014}, },
      { palType=11, palNum=1, palName="泳褲小伙子", palImage=105114, prestige=2000, gold=1000,
         popArea={map=80024,LX=84,LY=62, RX=84,RY=62}, watchArea={map=80024,LX=77,LY=56, RX=84,RY=64},
         talk="泳褲小伙子：來場夏日對戰吧。", loveItem={69012,69012,69012}, giftItem={607709,46632,75026,69087,69087}, },
      { palType=12, palNum=1, palName="千金小姐", palImage=105277, prestige=2000, gold=5000,
         popArea={map=80024,LX=61,LY=48, RX=61,RY=48}, watchArea={map=80024,LX=60,LY=48, RX=61,RY=50},
         talk="千金小姐：你會願意輸給我吧。", loveItem={69013,69013,69013}, giftItem={607710,46633,75026,73042,73043}, },
      { palType=13, palNum=1, palName="超能力者", palImage=106283, prestige=2000, gold=1000,
         popArea={map=80017,LX=55,LY=68, RX=55,RY=68}, watchArea={map=80017,LX=48,LY=64, RX=62,RY=70},
         talk="超能力者：我想要操控世界的一切。", loveItem={69011,69011,69011}, giftItem={607711,46633,75026,69090,69090}, },
      { palType=14, palNum=1, palName="吹火人", palImage=105095, prestige=3000, gold=500,
         popArea={map=80016,LX=54,LY=63, RX=54,RY=63}, watchArea={map=80016,LX=51,LY=57, RX=58,RY=60},
         talk="吹火人：停下來觀賞我的表演！", loveItem={69014,69014,69014}, giftItem={607712,46632,75026,73028,73037}, },
      { palType=15, palNum=1, palName="馴龍師", palImage=105052, prestige=2000, gold=1000,
         popArea={map=80018,LX=45,LY=46, RX=45,RY=46}, watchArea={map=80018,LX=41,LY=46, RX=50,RY=58},
         talk="馴龍師：路過的旅行者，來場較量吧！", loveItem={69012,69012,69012}, giftItem={607713,46631,75026,69085,73062}, },
      { palType=16, palNum=1, palName="研究員", palImage=106095, prestige=1500, gold=1500,
         popArea={map=80025,LX=90,LY=67, RX=90,RY=67}, watchArea={map=80025,LX=77,LY=62, RX=90,RY=69},
         talk="研究員：你聽說過神秘之笛嗎？這就是它喚醒的怪物！", loveItem={69014,69014,69014}, giftItem={607714,46630,75026,69089,73038}, },
}
------------------------------------------------
local EnemySet = {}
local BaseLevelSet = {}
EnemySet[1] = {{416288, 0, 0, 0, 0, 0, 0, 0, 0, 0},{416289, 0, 0, 0, 0, 0, 0, 0, 0, 0}}	--0代表没有怪
BaseLevelSet[1] = {40, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[2] = {{416227, 416226, 416226, 0, 0, 0, 0, 0, 0, 0},{416228, 416227, 416227, 0, 0, 0, 0, 0, 0, 0}}	--0代表没有怪
BaseLevelSet[2] = {60, 50, 50, 0, 0, 0, 0, 0, 0, 0}
EnemySet[3] = {{416279, 0, 0, 0, 0, 0, 416290, 416290, 0, 0},{416280, 0, 0, 0, 0, 0, 416291, 416291, 0, 0}}	--0代表没有怪
BaseLevelSet[3] = {60, 0, 0, 0, 0, 0, 50, 50, 0, 0}
EnemySet[4] = {{0, 406200, 406200, 0, 0, 0, 416198, 416198, 0, 0},{0, 416201, 416202, 0, 0, 0, 416199, 416199, 0, 0}}	--0代表没有怪
BaseLevelSet[4] = {0, 70, 70, 0, 0, 0, 60, 60, 0, 0}
EnemySet[5] = {{406205, 0, 0, 0, 0, 416203, 416203, 416203, 0, 0},{416206, 0, 0, 0, 0, 416204, 416204, 416204, 0, 0}}	--0代表没有怪
BaseLevelSet[5] = {70, 0, 0, 0, 0, 60, 60, 60, 0, 0}
EnemySet[6] = {{406209, 0, 0, 0, 0, 416208, 0, 0, 416207, 416207},{416210, 0, 0, 0, 0, 416209, 0, 0, 416208, 416208}}	--0代表没有怪
BaseLevelSet[6] = {70, 0, 0, 0, 0, 60, 0, 0, 50, 50}
EnemySet[7] = {{406218, 0, 0, 416216, 416216, 0, 416216, 416216, 0, 0},{416219, 0, 0, 416217, 416217, 0, 416217, 416217, 0, 0}}	--0代表没有怪
BaseLevelSet[7] = {60, 0, 0, 50, 50, 0, 50, 50, 0, 0}
EnemySet[8] = {{416333, 0, 0, 0, 0, 416332, 416332, 416332, 416332, 416332},{416334, 0, 0, 0, 0, 416333, 416333, 416333, 416333, 416333}}	--0代表没有怪
BaseLevelSet[8] = {60, 0, 0, 0, 0, 50, 50, 50, 50, 50}
EnemySet[9] = {{416345, 416344, 416344, 0, 0, 0, 0, 0, 0, 0},{416346, 416345, 416345, 0, 0, 0, 0, 0, 0, 0}}	--0代表没有怪
BaseLevelSet[9] = {60, 50, 50, 0, 0, 0, 0, 0, 0, 0}
EnemySet[10] = {{416275, 416268, 416268, 0, 0, 0, 0, 0, 416271, 416271},{416276, 416269, 416269, 0, 0, 0, 0, 0, 416272, 416272}}	--0代表没有怪
BaseLevelSet[10] = {60, 50, 50, 0, 0, 0, 0, 0, 50, 50}
EnemySet[11] = {{416292, 416244, 416244, 416245, 416245, 0, 0, 0, 0, 0},{416293, 416245, 416245, 416246, 416246, 0, 0, 0, 0, 0}}	--0代表没有怪
BaseLevelSet[11] = {60, 50, 50, 50, 50, 0, 0, 0, 0, 0}
EnemySet[12] = {{416335, 416281, 416283, 416338, 416329, 0, 0, 0, 0, 0},{416336, 416281, 416283, 416338, 416329, 0, 0, 0, 0, 0}}	--0代表没有怪
BaseLevelSet[12] = {60, 50, 50, 50, 50, 0, 0, 0, 0, 0}
EnemySet[13] = {{416326, 0, 0, 0, 416347, 0, 416350, 0, 0, 0},{416327, 0, 0, 0, 416348, 0, 416351, 0, 0, 0}}	--0代表没有怪
BaseLevelSet[13] = {60, 0, 0, 0, 50, 0, 50, 0, 0, 0}
EnemySet[14] = {{416237, 0, 0, 0, 416283, 0, 416234, 0, 0, 0},{416238, 0, 0, 0, 416284, 0, 416235, 0, 0, 0}}	--0代表没有怪
BaseLevelSet[14] = {60, 0, 0, 0, 50, 0, 50, 0, 0, 0}
EnemySet[15] = {{416263, 0, 0, 416281, 416323, 0, 416242, 416339, 0, 0},{416264, 0, 0, 416282, 416324, 0, 416243, 416340, 0, 0}}	--0代表没有怪
BaseLevelSet[15] = {70, 0, 0, 50, 50, 0, 50, 50, 0, 0}
EnemySet[16] = {{416225, 0, 0, 0, 0, 0, 0, 0, 0, 0},{416225, 0, 0, 416224, 416224, 0, 416224, 416224, 0, 0}}	--0代表没有怪
BaseLevelSet[16] = {70, 0, 0, 50, 50, 0, 50, 50, 0, 0}
------------------------------------------------
local FTime = os.time();			--时间表
tbl_PokeTrainerNPCIndex = tbl_PokeTrainerNPCIndex or {}
------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('LoopEvent', Func.bind(self.PokeTrainer_LoopEvent,self))
  self:regCallback('LoopEvent', Func.bind(self.moveTrainer_LoopEvent,self))
  for k,v in pairs(PokeTrainer) do
    if (tbl_PokeTrainerNPCIndex[k] == nil) then
        tbl_PokeTrainerNPCIndex[k] = {}
    end
    for i=1, v.palNum do
       if (tbl_PokeTrainerNPCIndex[k][i] == nil) then
           local palX = NLG.Rand(v.popArea.LX, v.popArea.RX);
           local palY = NLG.Rand(v.popArea.LY, v.popArea.RY);
           local PokeTrainerNPC = self:NPC_createNormal(v.palName, v.palImage, { map = v.popArea.map, x = palX, y = palY, direction = 5, mapType = 0 })
           tbl_PokeTrainerNPCIndex[k][i] = PokeTrainerNPC
           Char.SetData(tbl_PokeTrainerNPCIndex[k][i],CONST.对象_移速,250);
           Char.SetData(tbl_PokeTrainerNPCIndex[k][i],CONST.对象_ENEMY_PetFlg+2,0);
           Char.SetLoopEvent('./lua/Modules/pokeTrainer.lua','PokeTrainer_LoopEvent',tbl_PokeTrainerNPCIndex[k][i], 2000);
           self:NPC_regWindowTalkedEvent(tbl_PokeTrainerNPCIndex[k][i], function(npc, player, _seqno, _select, _data)
             local cdk = Char.GetData(player,CONST.对象_CDK);
             local seqno = tonumber(_seqno)
             local select = tonumber(_select)
             local data = tonumber(_data)
             if seqno == 1 then  ----报名对战执行
              if select == 4 then
                NLG.SystemMessage(player, v.palName.."：今天對戰的很過癮，約定好明天再戰！");
              elseif select == 1 then
                local changed,flag = CheckAndGiveFriendReward(player,k,v.giftItem);
                local EliteTrainer,EliteLvel = GetTrainerInfo(player);
                if (EliteLvel[k]>=100) then
                  NLG.SystemMessage(player, v.palName.."：我們已經是最親密的夥伴了。");
                  --SetTrainerInfo(player,k,0,-100);	--timeStamp(0表不更新), 扣除亲密度(-100点)
                  --Char.GiveItem(player, v.giftItem[NLG.Rand(1,2)], 1);
                  return;
                else
                  NLG.SystemMessage(player, v.palName.."：讓我們更加熱絡來領取收藏品吧。");
                  return;
                end
              else
                --打招呼(每日限1增加少)
                local EliteTrainer,EliteLvel = GetTrainerInfo(player);
                if (data==1 and EliteTrainer[k]==tonumber(os.date("%d",os.time())) ) then
                    NLG.SystemMessage(player, v.palName.."：今天已經和我互動過了。");
                    return;
                elseif (data==1 and EliteTrainer[k]~=tonumber(os.date("%d",os.time())) ) then
                    SetTrainerInfo(player,k,1,2,0);	--timeStamp(1表更新), intimacy(1点),flag(0表不更新)
                    NLG.SetAction(npc,12);	--动作_招手
                    NLG.SystemMessage(player, v.palName.."：(揮揮手)友善的互動[親密度增加2點](每天限一次)");
                end
                --給禮物(同限1增加多)
                if (data==2 and Char.HaveItem(player, v.loveItem[1])<0) then
                    local ItemsetIndex_Goal = Data.ItemsetGetIndex(v.loveItem[1]);
                    local Item_name = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_TRUENAME);
                    NLG.SystemMessage(player, v.palName.."：你沒有"..Item_name.."。");
                    return;
                elseif (data==2 and EliteTrainer[k]==tonumber(os.date("%d",os.time())) ) then
                    NLG.SystemMessage(player, v.palName.."：今天已經和我互動過了。");
                    return;
                elseif (data==2 and Char.HaveItem(player, v.loveItem[1])>0 and EliteTrainer[k]~=tonumber(os.date("%d",os.time())) ) then
                    Char.DelItem(player,v.loveItem[1],1,1);
                    SetTrainerInfo(player,k,1,5,0);	--timeStamp(0表不更新1表更新), intimacy(5点),flag(0表不更新)
                    NLG.SystemMessage(player, v.palName.."：這是很好的禮物[親密度增加5點](每天限一次)");
                end
                --給禮物(不限次數)声望回礼
                if (data==3 and Char.HaveItem(player, v.loveItem[2])<0) then
                    local ItemsetIndex_Goal = Data.ItemsetGetIndex(v.loveItem[2]);
                    local Item_name = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_TRUENAME);
                    NLG.SystemMessage(player, v.palName.."：你沒有"..Item_name.."。");
                    return;
                elseif (data==3 and Char.HaveItem(player, v.loveItem[2])>0) then
                    local ItemsetIndex_Goal = Data.ItemsetGetIndex(v.loveItem[2]);
                    local Item_name = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_TRUENAME);
                    Char.DelItem(player,v.loveItem[2],1,1);
					local ratio = EliteLvel[k]/maxTrainerLevel;
					local fame = Char.GetData(player,CONST.对象_声望);
					local fame_plus = math.floor(v.prestige * ratio);
					Char.SetData(player,CONST.对象_声望, fame + fame_plus);
                    SetTrainerInfo(player,k,0,1,0);	--timeStamp(0表不更新), intimacy(1点),flag(0表不更新)
                    NLG.SystemMessage(player, v.palName.."：謝謝你的"..Item_name.."回禮聲望"..fame_plus.."點[親密度增加1點]");
                end
                --給禮物(不限次數)魔币回礼
                if (data==4 and Char.HaveItem(player, v.loveItem[3])<0) then
                    local ItemsetIndex_Goal = Data.ItemsetGetIndex(v.loveItem[3]);
                    local Item_name = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_TRUENAME);
                    NLG.SystemMessage(player, v.palName.."：你沒有"..Item_name.."。");
                    return;
                elseif (data==4 and Char.HaveItem(player, v.loveItem[3])>0) then
                    local ItemsetIndex_Goal = Data.ItemsetGetIndex(v.loveItem[3]);
                    local Item_name = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_TRUENAME);
                    Char.DelItem(player,v.loveItem[3],1,1);
					local ratio = EliteLvel[k]/maxTrainerLevel;
					local gold_plus = math.floor(v.gold * ratio);
					Char.AddGold(player, gold_plus);
                    SetTrainerInfo(player,k,0,1,0);	--timeStamp(0表不更新), intimacy(1点),flag(0表不更新)
                    NLG.SystemMessage(player, v.palName.."：謝謝你的"..Item_name.."回禮魔幣"..gold_plus.."G[親密度增加1點]");
                end

--[[
                if (data==1 and Char.HaveItem(player, 69011)<0) then
                    NLG.SystemMessage(player, v.palName.."：你沒有這個樹果。");
                    return;
                elseif (data==1 and Char.HaveItem(player, 69011)>0) then
                    Char.DelItem(player,69011,1,1);
                    if (v.loveItem==69011) then
                        SetTrainerInfo(player,k,0,5);	--timeStamp(0表不更新), intimacy(5点)
                        NLG.SystemMessage(player, v.palName.."：正需要此樹果，親密度增加5點");
                    else
                        SetTrainerInfo(player,k,0,1);	--timeStamp(0表不更新), intimacy(1点)
                        NLG.SystemMessage(player, v.palName.."：謝謝你的樹果，親密度增加1點");
                    end
                end
                if (data==2 and Char.HaveItem(player, 69012)<0) then
                    NLG.SystemMessage(player, v.palName.."：你沒有這個樹果。");
                    return;
                elseif (data==2 and Char.HaveItem(player, 69012)>0) then
                    Char.DelItem(player,69012,1,1);
                    if (v.loveItem==69012) then
                        SetTrainerInfo(player,k,0,5);	--timeStamp(0表不更新), intimacy(5点)
                        NLG.SystemMessage(player, v.palName.."：正需要此樹果，親密度增加5點");
                    else
                        SetTrainerInfo(player,k,0,1);	--timeStamp(0表不更新), intimacy(1点)
                        NLG.SystemMessage(player, v.palName.."：謝謝你的樹果，親密度增加1點");
                    end
                end
                if (data==3 and Char.HaveItem(player, 69013)<0) then
                    NLG.SystemMessage(player, v.palName.."：你沒有這個樹果。");
                    return;
                elseif (data==3 and Char.HaveItem(player, 69013)>0) then
                    Char.DelItem(player,69013,1,1);
                    if (v.loveItem==69013) then
                        SetTrainerInfo(player,k,0,5);	--timeStamp(0表不更新), intimacy(5点)
                        NLG.SystemMessage(player, v.palName.."：正需要此樹果，親密度增加5點");
                    else
                        SetTrainerInfo(player,k,0,1);	--timeStamp(0表不更新), intimacy(1点)
                        NLG.SystemMessage(player, v.palName.."：謝謝你的樹果，親密度增加1點");
                    end
                end
                if (data==4 and Char.HaveItem(player, 69014)<0) then
                    NLG.SystemMessage(player, v.palName.."：你沒有這個樹果。");
                    return;
                elseif (data==4 and Char.HaveItem(player, 69014)>0) then
                    Char.DelItem(player,69014,1,1);
                    if (v.loveItem==69014) then
                        SetTrainerInfo(player,k,0,5);	--timeStamp(0表不更新), intimacy(5点)
                        NLG.SystemMessage(player, v.palName.."：正需要此樹果，親密度增加5點");
                    else
                        SetTrainerInfo(player,k,0,1);	--timeStamp(0表不更新), intimacy(1点)
                        NLG.SystemMessage(player, v.palName.."：謝謝你的樹果，親密度增加1點");
                    end
                end
]]
              end
             end

           end)
           self:NPC_regTalkedEvent(tbl_PokeTrainerNPCIndex[k][i], function(npc, player)
             if(NLG.CheckInFront(player, npc, 1)==false) then
                 return;
             end
             if (NLG.CanTalk(npc, player) == true) then
                 local EliteCheck = Field.Get(player, 'EliteBattle') or "0";
                  local EliteCheck_raw = string.split(EliteCheck,",");
                  if (EliteCheck=="0" or #EliteCheck_raw < #PokeTrainer) then
                    local Trainer_string = "";
                    for i=1,#PokeTrainer do
                      if (i==#PokeTrainer) then
                        Trainer_string = Trainer_string .. "32|0|1";
                      else
                        Trainer_string = Trainer_string .. "32|0|1,";
                      end
                    end
                    Field.Set(player, 'EliteBattle', Trainer_string);
                    NLG.UpChar(player);
                  end
                  --查询资料
                  local EliteTrainer,EliteLvel = GetTrainerInfo(player);
                  local msg = "5\\n@c◇ 親密度：".. EliteLvel[k] .. " ◇\\n"
                            .."\\n每天可以送禮物提升親密度"
                            .."\\n　　————————————————————\\n\\n"
                            .."[　選項(1)  打招呼(1)(2)每日共1次　]\\n"
                            .."[　選項(2)  送禮物(1)(2)每日共1次　]\\n"
                            .."[　選項(3)  聲望回禮(不限次數∞)　]\\n"
                            .."[　選項(4)  魔幣回禮(不限次數∞)　]\\n";
                  NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, 13, 1, msg);	--CONST.按钮_是否+CONST.按钮_确定

             end
             return
           end)
       end
    end
  end


end
------------------------------------------------
-------功能设置
--侦测监控
function PokeTrainer_LoopEvent(npc)
	local CTime = tonumber(os.date("%H",FTime));
	for k,v in pairs(PokeTrainer) do
		local npcImage = Char.GetData(npc,CONST.对象_形象);
		local npcFloorId = Char.GetData(npc,CONST.对象_地图);
		if ( k==v.palType and npcImage==v.palImage and npcFloorId==v.popArea.map ) then
			local player_tbl = Char.GetTempData(npc, '追击对战') or nil;
			pcall(function()
				if player_tbl==nil then		--无锁定开始侦测
					local X = tonumber(Char.GetData(npc,CONST.对象_X));
					local Y = tonumber(Char.GetData(npc,CONST.对象_Y));
					for i=v.watchArea.LX, v.watchArea.RX do
						for j=v.watchArea.LY, v.watchArea.RY do
							local obj_tbl = {};
							local obj_num, obj_tbl = Obj.GetObject(0, v.popArea.map, i, j)
							if #obj_tbl > 0 then
								for m = 1, #obj_tbl do
									local player = Obj.GetCharIndex(obj_tbl[m]);
									local fight = Char.GetTempData(player,'菁英对战') or 0;
									if fight==0 and Char.GetData(player, CONST.对象_类型) == CONST.对象类型_人 and not Char.IsDummy(player) then
										if Char.GetData(player,CONST.对象_组队模式)==CONST.组队模式_无 or Char.GetData(player,CONST.对象_组队模式)== CONST.组队模式_队长 then
											--print(m,i,j)
											--初始化
											if Char.PartyNum(player)>0 and player==Char.GetPartyMember(player,0) then
												for slot=0,4 do
													local p = Char.GetPartyMember(player, slot);
													if(p>=0) then
														local EliteCheck = Field.Get(p, 'EliteBattle') or "0";
														local EliteCheck_raw = string.split(EliteCheck,",");
														if (EliteCheck=="0" or #EliteCheck_raw < #PokeTrainer) then
															local Trainer_string = "";
															for i=1,#PokeTrainer do
																if (i==#PokeTrainer) then
																	Trainer_string = Trainer_string .. "32|0|1";
																else
																	Trainer_string = Trainer_string .. "32|0|1,";
																end
															end
															Field.Set(p, 'EliteBattle', Trainer_string);
															NLG.UpChar(p);
														end
													end
												end
											elseif Char.PartyNum(player)==-1 then
												local EliteCheck = Field.Get(player, 'EliteBattle') or "0";
												local EliteCheck_raw = string.split(EliteCheck,",");
												if (EliteCheck=="0" or #EliteCheck_raw < #PokeTrainer) then
													local Trainer_string = "";
													for i=1,#PokeTrainer do
														if (i==#PokeTrainer) then
															Trainer_string = Trainer_string .. "32|0|1";
														else
															Trainer_string = Trainer_string .. "32|0|1,";
														end
													end
													Field.Set(player, 'EliteBattle', Trainer_string);
													NLG.UpChar(player);
													break
												end
											end
											--查询资料
											local EliteTrainer,EliteLvel = GetTrainerInfo(player);
											if ( EliteTrainer[k]~=tonumber(os.date("%d",os.time())) ) then
												Char.SetData(npc,CONST.对象_NPC_HeadGraNo,22337);	--111250.110402
												NLG.UpChar(npc);
												Char.SetTempData(npc, '追击对战', player);
												Char.SetLoopEvent('./lua/Modules/pokeTrainer.lua', 'PokeTrainer_LoopEvent', npc, 600);
												break
											else
												--print("本日已经对战过")
												break
											end
										end
									end
								end
							end
						end
					end
				elseif player_tbl then		--已锁定开始追击
					local player = player_tbl;
					local X = tonumber(Char.GetData(npc,CONST.对象_X));
					local Y = tonumber(Char.GetData(npc,CONST.对象_Y));
					local X1 = tonumber(Char.GetData(player,CONST.对象_X));
					local Y1 = tonumber(Char.GetData(player,CONST.对象_Y));
					local dir,allow = moveDir(X, Y, X1, Y1);
					NLG.SetAction(npc,1);
					NLG.WalkMove(npc,dir);
					NLG.UpChar(npc);
					--print(X, Y, X1, Y1)
					if (X1==nil or Y1==nil) then
						--Char.SetTempData(player,'菁英对战', 0);
						--进战斗开关
						if Char.PartyNum(player)>0 and player==Char.GetPartyMember(player,0) then
							for slot=0,4 do
								local p = Char.GetPartyMember(player, slot);
								if(p>=0) then
									Char.SetTempData(p,'菁英对战', 0);
								end
							end
						elseif Char.PartyNum(player)==-1 then
							Char.SetTempData(player,'菁英对战', 0);
						end

						Char.SetTempData(npc, '追击对战', nil);
						Char.SetLoopEvent('./lua/Modules/pokeTrainer.lua', 'PokeTrainer_LoopEvent', npc, 2000);
						return
					end

					if allow then
						local battleIndex = Char.GetBattleIndex(player);
						if battleIndex >= 0 then
							return
						end
						--强迫对战开始
						NLG.SystemMessage(player, v.talk);
						--查询资料
						local EliteTrainer,EliteLvel = GetTrainerInfo(player);
						--怪物组合(亲密度)
						local EnemyIdAr={}
						if (EliteLvel[k] < math.floor(maxTrainerLevel/2)) then
							EnemyIdAr = EnemySet[k][1];
						elseif (EliteLvel[k] >= math.floor(maxTrainerLevel/2)) then
							EnemyIdAr = EnemySet[k][2];
						end
						--怪物等级调整公式
						local BaseLevelAr={}
						for r,t in ipairs(BaseLevelSet[k]) do
							if tonumber(t)>0 then
								BaseLevelAr[r] = tonumber(t) + (EliteLvel[k] * 100/maxTrainerLevel);
							else
								BaseLevelAr[r] = 0;
							end
						end
						local battleIndex = Battle.PVE( player, player, nil, EnemyIdAr, BaseLevelAr, nil);
						Battle.SetWinEvent("./lua/Modules/pokeTrainer.lua", "PokeTrainerNPC_BattleWin", battleIndex);
						--进战斗开关
						if Char.PartyNum(player)>0 and player==Char.GetPartyMember(player,0) then
							for slot=0,4 do
								local p = Char.GetPartyMember(player, slot);
								if(p>=0) then
									Char.SetTempData(p,'菁英对战', 1);
								end
							end
						elseif Char.PartyNum(player)==-1 then
							Char.SetTempData(player,'菁英对战', 1);
						end

						pal_clear(player, npc, v.palType);
						Char.SetTempData(npc, '追击对战', nil);
						Char.SetLoopEvent('./lua/Modules/pokeTrainer.lua', 'PokeTrainer_LoopEvent', npc, 3000);
					else
						if ( X1>v.watchArea.RX or Y1>v.watchArea.RY) then		--逃离右侧范围
							--Char.SetTempData(player,'菁英对战', 0);
							--进战斗开关
							if Char.PartyNum(player)>0 and player==Char.GetPartyMember(player,0) then
								for slot=0,4 do
									local p = Char.GetPartyMember(player, slot);
									if(p>=0) then
										Char.SetTempData(p,'菁英对战', 0);
									end
								end
							elseif Char.PartyNum(player)==-1 then
								Char.SetTempData(player,'菁英对战', 0);
							end

							pal_clear(player, npc, v.palType);
							Char.SetTempData(npc, '追击对战', nil);
							Char.SetLoopEvent('./lua/Modules/pokeTrainer.lua', 'PokeTrainer_LoopEvent', npc, 2000);
						elseif ( X1<v.watchArea.LX or Y1<v.watchArea.LY) then	--逃离左侧范围
							--Char.SetTempData(player,'菁英对战', 0);
							--进战斗开关
							if Char.PartyNum(player)>0 and player==Char.GetPartyMember(player,0) then
								for slot=0,4 do
									local p = Char.GetPartyMember(player, slot);
									if(p>=0) then
										Char.SetTempData(p,'菁英对战', 0);
									end
								end
							elseif Char.PartyNum(player)==-1 then
								Char.SetTempData(player,'菁英对战', 0);
							end

							pal_clear(player, npc, v.palType);
							Char.SetTempData(npc, '追击对战', nil);
							Char.SetLoopEvent('./lua/Modules/pokeTrainer.lua', 'PokeTrainer_LoopEvent', npc, 2000);
						end
					end
				end
			end)
		end
	end
end


function pal_clear(player, npc, Type)
	--随机转移至起始监视位置
	for k,v in pairs(PokeTrainer) do
		if ( k==Type) then
			local palX = NLG.Rand(v.popArea.LX, v.popArea.RX);
			local palY = NLG.Rand(v.popArea.LY, v.popArea.RY);
			Char.SetData(npc,CONST.对象_X, palX);
			Char.SetData(npc,CONST.对象_Y, palY);
			Char.SetData(npc,CONST.对象_NPC_HeadGraNo,0);
			NLG.SetAction(npc,0);
			NLG.UpChar(npc);
		end
	end
end

function PokeTrainerNPC_BattleWin(battleIndex, charIndex)
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
		leader = leader2
	end

	--分配奖励
	for p=0,9 do
		local player = Battle.GetPlayIndex(battleIndex, p);
		if player>=0 and Char.GetData(player, CONST.对象_类型) == CONST.对象类型_人 then
			for k,v in pairs(PokeTrainer) do
				local charFloorId = Char.GetData(player,CONST.对象_地图);
				local X = Char.GetData(player,CONST.对象_X);
				local Y = Char.GetData(player,CONST.对象_Y);
				--print(charFloorId,X,Y)
				if ( k==v.palType and charFloorId==v.popArea.map and X>=v.watchArea.LX and X<=v.watchArea.RX and Y>=v.watchArea.LY and Y<=v.watchArea.RY ) then
					--计算更新时序、亲密度等级
					SetTrainerInfo(player,k,1,1);	--timeStamp(1表更新), intimacy(1点)
					--查询资料
					local EliteTrainer,EliteLvel = GetTrainerInfo(player);

					local ratio = EliteLvel[k]/maxTrainerLevel;
					local fame = Char.GetData(player,CONST.对象_声望);
					local fame_plus = math.floor(v.prestige * ratio);
					local gold_plus = math.floor(v.gold * ratio);
					Char.SetData(player,CONST.对象_声望, fame + math.floor(v.prestige*ratio));
					Char.AddGold(player, math.floor(v.gold*ratio));
					NLG.SystemMessage(player,"[系統]目前聲望:"..fame.."，勝利得到額外聲望"..fame_plus.."！");
					NLG.SystemMessage(player,"[系統]勝利時也從對手那得到魔幣"..gold_plus.."！");
					Char.SetTempData(player,'菁英对战', 0);
					NLG.UpChar(player);
				end
			end
		end
	end
	Battle.UnsetWinEvent(battleIndex);
end

function GetTrainerInfo(player)
	local EliteTrainer={}
	local EliteLvel={}
	local EliteFlag={}
	local EliteCheck = Field.Get(player, 'EliteBattle') or "0";
	local EliteCheck_raw = string.split(EliteCheck,",");
	--print(EliteCheck,#EliteCheck_raw)

	for a,b in ipairs(EliteCheck_raw) do
		local Trainer_raw = string.split(b,"|");
		for r,t in ipairs(Trainer_raw) do
			if (r==1) then
				table.insert(EliteTrainer,tonumber(t));
			elseif (r==2) then
				table.insert(EliteLvel,tonumber(t));
			elseif (r==3) then
				table.insert(EliteFlag,tonumber(t));
			end
		end
	end
	return EliteTrainer,EliteLvel,EliteFlag
end
function SetTrainerInfo(player,k,timeStamp,intimacy,flag)
	local EliteTrainer={}
	local EliteLvel={}
	local EliteFlag={}
	local EliteCheck = Field.Get(player, 'EliteBattle');
	local EliteCheck_raw = string.split(EliteCheck,",");
	for a,b in ipairs(EliteCheck_raw) do
		local Trainer_raw = string.split(b,"|");
		for r,t in ipairs(Trainer_raw) do
			if (k==a and r==1) then
				if (timeStamp==1) then
					table.insert(EliteTrainer,tonumber(os.date("%d",os.time())));
				else
					table.insert(EliteTrainer,tonumber(t));
				end
			elseif (k~=a and r==1) then
				table.insert(EliteTrainer,tonumber(t));
			elseif (k==a and r==2) then
				if (tonumber(t)<maxTrainerLevel) then		--菁英等级上限maxTrainerLevel
					if (tonumber(t) + intimacy>=100) then
						table.insert(EliteLvel,100);
					else
						table.insert(EliteLvel,tonumber(t) + intimacy);
					end
				else
					if (intimacy<0) then
						table.insert(EliteLvel,tonumber(t) + intimacy);
					else
						table.insert(EliteLvel,tonumber(t));
					end
				end
			elseif (k~=a and r==2) then
				table.insert(EliteLvel,tonumber(t));
			elseif (k==a and r==3) then
				if (tonumber(flag)>0)then
					table.insert(EliteFlag,tonumber(flag));
				else
					table.insert(EliteFlag,tonumber(t));
				end
			elseif (k~=a and r==3) then
				table.insert(EliteFlag,tonumber(t));
			end
		end
	end
	--表格转字串
	local Trainer_string = "";
	for i=1,#PokeTrainer do
		if (i==#PokeTrainer) then
			Trainer_string = Trainer_string .. EliteTrainer[i] .. "|" .. EliteLvel[i] .. "|" .. EliteFlag[i];
		else
			Trainer_string = Trainer_string .. EliteTrainer[i] .. "|" .. EliteLvel[i] .. "|" .. EliteFlag[i] .. ",";
		end
	end
	--print(Trainer_string)
	Field.Set(player, 'EliteBattle', Trainer_string);
	NLG.UpChar(player);
end

function CheckAndGiveFriendReward(player,k,giftItem)
	--local changed = false
	-- 為了確保順序，這邊用 ipairs + 陣列
	local levels = {20, 40, 60, 80, 100};

	for key, lv in ipairs(levels) do
		local EliteTrainer,EliteLvel,EliteFlag = GetTrainerInfo(player);
		if EliteLvel[k] >= lv then
			local bit = GetFriendRewardBit(lv);
			--print(key,EliteLvel[k],lv,bit,EliteFlag[k])
			if (bit > 0 and EliteFlag[k]==bit) then
				local reward = giftItem[key];
                Char.GiveItem(player, reward, 1);
				--NLG.SystemMessage(player, "[系統]已領取對應獎勵！");

				flag = 2^key;
				--print(flag)
				SetTrainerInfo(player,k,0,0,flag);
			end
		end
	end
end
-- bit旗標
function GetFriendRewardBit(lv)
	if lv == 20  then return 1 end
	if lv == 40  then return 2 end
	if lv == 60  then return 4 end
	if lv == 80  then return 8 end
	if lv == 100 then return 16 end
	return 0
end

function moveDir(X, Y, X1, Y1)
	if not X or not Y or not X1 or not Y1 then
		return
	end
	local dir = 8
	if X1 > X then
		if Y1 > Y then
			dir = 3
		elseif Y1 < Y then
			dir = 1
		else
			dir = 2
		end
	elseif X1 < X then
		if Y1 > Y then
			dir = 5
		elseif Y1 < Y then
			dir = 7
		else
			dir = 6
		end
	else
		if Y1 > Y then
			dir = 4
		elseif Y1 < Y then
			dir = 0
		end
	end
	local allow = false
	if math.abs(X-X1) < 1 and math.abs(Y-Y1) < 1 then
		allow = true
	end
	return dir, allow
end


Char.GetLocation = function(npc,dir)
	local X = Char.GetData(npc,CONST.对象_X)--地图x
	local Y = Char.GetData(npc,CONST.对象_Y)--地图y
	if dir==0 then
		Y=Y-1;
	elseif dir==1 then
		X=X+1;
		Y=Y-1;
	elseif dir==2 then
		X=X+1;
	elseif dir==3 then
		X=X+1;
		Y=Y+1;
	elseif dir==4 then
		Y=Y+1;
	elseif dir==5 then
		X=X-1;
		Y=Y+1;
	elseif dir==6 then
		X=X-1;
	elseif dir==7 then
		X=X-1;
		Y=Y-1;
	end
	return X,Y;
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
