-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
--ahsin做的：精简佣兵
--版本：20250721c
--本lua必须运行在m佬的新框架下
--首发论坛 www.cnmlb.com 获取最新版本

--由于功能比较丰富，免费分享归免费。过来b站点个赞、一键三连不过分吧？
--https://space.bilibili.com/21127109
--qq群：85199642

--本lua只支持cgmsv+新框架，不然100%跑不起来
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

--模块类
local 精简佣兵Module = ModuleBase:createModule('精简佣兵')--精简佣兵

--加载模块钩子
function 精简佣兵Module:onLoad()
	self:logInfo('load')
	self:regCallback('LoginEvent', Func.bind(self.上线触发, self))--上线触发
	self:regCallback('LoginGateEvent', Func.bind(self.登回出生点, self))--登回出生点触发
	self:regCallback('ResetCharaBattleStateEvent', Func.bind(self.登回出生点, self))--战斗后触发2
	self:regCallback('BattleOverEvent', Func.bind(self.战斗结束触发, self))--战斗结束触发
	self:regCallback('BeforeBattleTurnEvent', Func.bind(self.回合开始前触发, self))--回合开始前触发
	self:regCallback('TalkEvent', Func.bind(self.玩家说话, self))--玩家说话
	self:regCallback('AfterWarpEvent', Func.bind(self.传送触发, self))--传送触发
	self:regCallback('LogoutEvent', Func.bind(self.下线掉线触发, self))--下线触发
	self:regCallback('DropEvent', Func.bind(self.下线掉线触发, self))--掉线触发
	ai_npc = self:NPC_createNormal('ai佣兵管理',104862,{x=234,y=70,mapType=0,map=1000,direction=6})--ai佣兵管理npc
	self:NPC_regWindowTalkedEvent(ai_npc,Func.bind(self.弹窗触发,self))--ai佣兵管理npc窗口按钮触发
	self:NPC_regTalkedEvent(ai_npc,Func.bind(self.面向npc触发,self))--面向ai_npc触发
	local 在线玩家表 = NLG.GetPlayer() or false--获取在线玩家表，并清空老佣兵
	if 在线玩家表 ~= -1 then
		for k,v in pairs(在线玩家表) do
			if Char.IsDummy(v) then
				Char.LeaveParty(v)
				Char.DelDummy(v)
			end
		end
		在线玩家表 = nil
	end
end

--职业统计： 弓-44 | 剑-14 | 斧-24 | 骑-34 | 格-144 | 魔-74 | 传-64 | 巫-134 | 咒-84 | 忍-154
--武器统计： 水龙弓215 | 201村正 | 206帕鲁凯斯 | 211天空 | 220水龙杖 | 250水龙之服-格斗 ,本lua只有格斗会自动判断给穿衣服，其它职业默认带武器
--20250721开始，支持篡改佣兵手持武器属性，从此佣兵不需要装备穿满，带一把武器就够了，抗性就不做了，即使忍者也已略bt，不能给抗
--创建ai = {序,ai名字,职业显示,图档id,job,jobrank,武器id,'武器血|武器魔|武器攻|武器防|武器敏|武器精|武器魔攻|武器魔抗|武器反|武器命|武器必|武器闪|武器回|武器魅',开通价格}
--武器各单项属性不改用默认的，写‘不改’即可，其它给数字即可，支持负数
local ai_list = {
{1,'青鳶','弓箭手',120119,44,40,215,'不改|不改|不改|不改|不改|不改|不改|不改|不改|不改|不改|15|200|999',100},
{2,'斬月','剑士',105509,14,10,201,'不改|不改|不改|不改|不改|不改|不改|不改|不改|不改|不改|不改|200|999',100},
{3,'破軍','战斧斗士',105150,24,20,206,'不改|不改|不改|不改|不改|不改|不改|不改|不改|不改|不改|不改|200|999',100},
{4,'龍野','骑士',105061,34,30,211,'不改|不改|不改|不改|不改|不改|不改|不改|不改|不改|不改|不改|200|999',100},
{5,'修羅','格斗',105102,144,140,250,'不改|不改|不改|不改|不改|不改|不改|不改|不改|不改|不改|15|200|999',100},
{6,'烏兒','魔法师',105266,74,70,220,'不改|不改|不改|不改|不改|不改|不改|不改|不改|不改|不改|不改|200|999',100},
{7,'沁心','传教士',105285,64,60,220,'500|不改|不改|不改|不改|不改|不改|不改|不改|不改|不改|不改|800|999',200},
{8,'莫邪','巫师',105416,134,130,220,'500|不改|不改|不改|不改|不改|不改|不改|不改|不改|不改|不改|800|999',200},

{9,'GM青鳶','弓箭手',120119,44,40,215,'2000|不改|500|不改|不改|不改|不改|不改|不改|不改|不改|15|200|999',100},
{10,'GM斬月','剑士',105509,14,10,201,'2000|不改|500|不改|不改|不改|不改|不改|不改|不改|不改|不改|200|999',100},
{11,'GM破軍','战斧斗士',105150,24,20,206,'2000|不改|500|不改|不改|不改|不改|100|不改|不改|不改|不改|200|999',100},
{12,'GM龍野','骑士',105061,34,30,211,'2000|不改|500|不改|不改|不改|不改|100|不改|70|不改|不改|200|999',100},
{13,'GM修羅','格斗',105102,144,140,250,'2000|不改|500|不改|不改|不改|不改|不改|不改|不改|不改|15|200|999',100},
{14,'GM烏兒','魔法师',105266,74,70,220,'2000|1000|不改|不改|不改|1000|350|不改|不改|不改|不改|不改|200|999',100},
{15,'GM沁心','传教士',105285,64,60,220,'5000|1000|不改|不改|不改|不改|不改|不改|不改|不改|不改|不改|800|999',200},
{16,'GM莫邪','巫师',105416,134,130,220,'5000|1000|不改|不改|500|不改|不改|不改|不改|不改|不改|不改|800|999',200},
--{9,'贱人','剑士',108324,14,10,201,'不改|不改|不改|不改|不改|不改|不改|不改|不改|不改|不改|不改|200|999',150},
--{10,'司波深雪','咒术师',108233,84,80,220,'500|不改|不改|不改|不改|不改|不改|不改|不改|不改|不改|不改|800|999',300},
--{11,'宇智波鼬','忍者',102860,154,150,201,'500|不改|不改|不改|250|不改|不改|200|15|15|15|15|800|999',500},--boss战做了不暗杀设定，如果你某些普通战斗中也设有boss，搞不定推荐注释暗杀技能
--{12,'GM','GM',170001,481,480,220,'999|999|999|999|999|999|999|999|999|999|999|999|999|999',1000},--测试职业，如果你的job里没有481，或觉得变态请注释
}
local 开通币种 = 1--0魔币，1自定义币
local 自定义币名 = 'CN币'
local 自定义币itemid = 88888
local ai最低等级 = 70--如果玩家等级小于70，ai等级强制为70，玩家等级高于70，ai等级则根据人的等级来
local ai人口限制 = 999999999--diy限制每线路服务器ai人口上限
local 玩家招募佣兵需求等级 = 20
local ai人口统计 = 0--初始化数据
local 战斗对象表 = {}--初始化战斗对象表
local 玩家持有ai表 = {}--初始化玩家数据表
local 现在页 = {}--初始化玩家翻页数据表
local 玩家预购清单 = {}--初始化玩家预购清单
local 装备常量表 = {--初始化快捷装备参数常量
	CONST.道具_生命,CONST.道具_魔力,CONST.道具_攻击,CONST.道具_防御,CONST.道具_敏捷,CONST.道具_精神,CONST.道具_魔攻,
	CONST.道具_魔抗,CONST.道具_反击,CONST.道具_命中,CONST.道具_必杀,CONST.道具_闪躲,CONST.道具_回复,CONST.道具_魅力,
}

function 精简佣兵Module:面向npc触发(npc,player)--面向ai_npc触发
	if Char.GetData(player,CONST.对象_等级) < 玩家招募佣兵需求等级 then
		NLG.ShowWindowTalked(player,player,CONST.窗口_信息框,CONST.按钮_关闭,player+404404,'@c【CN魔力 AI雇佣兵系统】\\n\\n\\n\\n等你'..玩家招募佣兵需求等级..'级再来吧。')
		return
	end
	local 持有状态 = {}
	for i = 1,#ai_list do
		if not 玩家持有ai表[player] then
			self:上线触发(player)
		end
		if 玩家持有ai表[player][i] >= 1 then
			持有状态[i] = '炒鱿鱼'
		else
			持有状态[i] = '招募'
		end
	end
	local 占据行 = 2 + #ai_list
	local 分几页 = math.ceil(占据行/10)
	local 窗口内容 = '1|@c\\n【CN魔力 AI雇佣兵系统】'
	..'\\n--> 雇佣兵简介 <--'
	local GMcdk = Char.GetData(player,CONST.对象_GM);
	print(GMcdk)
	if GMcdk==0 then
		for j = 1,8 do
			j = j + ((现在页[player]-1)*8)
			窗口内容 = 窗口内容 .. left('\\n'..ai_list[j][2],15)..left(ai_list[j][3],15)..left(持有状态[j],11)
			--if j >= #ai_list then
			--	break
			--end
		end
	elseif GMcdk==1 then
		for j = 9,16 do
			j = j + ((现在页[player]-1)*8)
			窗口内容 = 窗口内容 .. left('\\n'..ai_list[j][2],15)..left(ai_list[j][3],15)..left(持有状态[j],11)
			if j >= #ai_list then
				break
			end
		end
	end
	if 现在页[player]-1 == 0 then--首页
		NLG.ShowWindowTalked(player,npc,CONST.窗口_选择框,CONST.按钮_关闭,player+3330,窗口内容)
	elseif 现在页[player] == 分几页 then--最后一页
		NLG.ShowWindowTalked(player,npc,CONST.窗口_选择框,CONST.按钮_关闭+CONST.按钮_上一页,player+3330,窗口内容)
	else--中间页
		NLG.ShowWindowTalked(player,npc,CONST.窗口_选择框,CONST.按钮_关闭+CONST.按钮_下一页+CONST.按钮_上一页,player+3330,窗口内容)
	end
end

function 精简佣兵Module:弹窗触发(npc,player,seq,sel,data)--ai佣兵管理npc窗口按钮触发
	seq = tonumber(seq)
	sel = tonumber(sel)
	data = shuzipanduan(data)
	--print('seq：'..seq)
	--print('sel：'..sel)
	--print('data：'..data)
	if sel == 2	then--取消
		print('ai佣兵弹窗，点取消')
		return
	end
	if sel == 16 and seq == player+404404 then--错误页点上一页
		self:面向npc触发(npc,player)
		return
	end
	if sel == 16 and seq == 0 then--上一页
		self:面向npc触发(npc,player)
		return
	end
	if sel == 16 and seq == player+8888 then--购买返回上一页
		self:面向npc触发(npc,player)
		return
	end
	if seq == player+3330 then--第一页
		if data == 1 then
			local 窗口内容 = '@c               【CN魔力 AI雇佣兵系统简介】'
			..'\\n'
			..'\\n1、每名玩家最多招募4名雇佣兵组成一队，雇佣兵背包已经塞满不会抢boss掉落。'
			..'\\n'
			..'\\n2、雇佣兵每次战斗后会自动治疗、招魂、回血、回魔、修理，无需任何干预。所以若雇佣兵战斗中死亡，也不影响后续继续战斗。'
			..'\\n'
			..'\\n3、雇佣兵在战斗中，没回合会自动满魔，所以无需担心战斗中的雇佣兵会没魔放技能。'
			..'\\n'
			..'\\n4、雇佣兵的属性、等级等会参考你的角色人物属性并浮动。水晶属性随机、法系魔法属性会略调高。'
			..'\\n'
			..'\\n5、雇佣兵战斗中部分随机使用本职业技能，雇佣兵的宠物随机使用常见丰富的宠物技能。它们具体会什么技能，请自行尝试。'
			..'\\n'
			..'\\n6、本系统主打陪伴，若玩家偷懒将雇佣兵作为主力输出使用时总有力不从心之时，遂我们仍然推荐玩家注重加强提升自己。'
			..'\\n'
			..'\\n7、其它快捷键：/killai 解雇所有雇佣兵 /aiback 雇佣兵瞬间归队'
			NLG.ShowWindowTalked(player,npc,CONST.窗口_巨信息框,CONST.按钮_关闭+CONST.按钮_上一页,0,窗口内容)
			return
		end
		if sel == 32 then--下一页
			现在页[player] = 现在页[player] + 1
			--print('现在页[player] = '..现在页[player])
			self:面向npc触发(npc,player)
			return
		end
		if sel == 16 then--上一页
			现在页[player] = 现在页[player] - 1
			--print('现在页[player] = '..现在页[player])
			self:面向npc触发(npc,player)
			return
		end
		for i = 2,9 do--点击招募/解雇
			if data == i then
				i = i + ((现在页[player]-1)*8) -1
				local GMcdk = Char.GetData(player,CONST.对象_GM);
				if GMcdk==1 then i=i+8; end
				local 是否开通 =  Char.GetExtData(player,'ai-'..ai_list[i][2]) or 'no'
				if 是否开通 == 'no' then
					玩家预购清单[player] = i
					local 单位 = false
					if 开通币种 == 0 then
						单位 = '魔币'
					else
						单位 = 自定义币名
					end
					local 窗口内容 = '@c【CN魔力 AI雇佣兵系统】'
					..'\\n\\n\\n['..ai_list[i][2]..'] 还没开通'
					..'\\n\\n价格：'..ai_list[i][9]..' '..单位
					..'\\n\\n\\n是否购买？'
					NLG.ShowWindowTalked(player,npc,CONST.窗口_信息框,CONST.按钮_是否+CONST.按钮_上一页,player+8888,窗口内容)
					return
				end
				招募ai(player,i)
				self:面向npc触发(npc,player)
				return
			end
		end
	end
	if seq == player+8888 and sel == 4 then--购买雇佣兵
		local 预购目标 = 玩家预购清单[player]
		local 收费价格 = ai_list[预购目标][9]
		print('玩家预购清单 = '..玩家预购清单[player])
		print('收费价格 = '..收费价格)
		if 开通币种 == 0 then--魔币
			if Char.GetGold(player) < 收费价格 then
				NLG.ShowWindowTalked(player,npc,CONST.窗口_信息框,CONST.按钮_上一页,player+404404,'@c【CN魔力 AI雇佣兵系统】\\n\\n\\n\\n你没钱了。')
				return
			elseif Char.GetGold(player) >= 收费价格 then
				Char.AddGold(player,-收费价格)
				NLG.ShowWindowTalked(player,npc,CONST.窗口_信息框,CONST.按钮_上一页,player+404404,'@c【CN魔力 AI雇佣兵系统】\\n\\n\\n\\您已成功购买 ['..ai_list[预购目标][2]..']。')
				NLG.Say(player,-1,'本次支付：'..收费价格..' 金币',CONST.颜色_黄色,CONST.字体_中)--发扣钱通知
				Char.SetExtData(player,'ai-'..ai_list[预购目标][2],'yes')
				Char.SaveToDb(player)
				return
			end
		elseif 开通币种 == 1 then--自定义币
			local 玩家持有的自定义币币数量 = Char.ItemNum(player,自定义币itemid)
			if 玩家持有的自定义币币数量 < 收费价格 then
				NLG.ShowWindowTalked(player,npc,CONST.窗口_信息框,CONST.按钮_上一页,player+404404,'@c【CN魔力 AI雇佣兵系统】\\n\\n\\n\\n你没'..自定义币名..'了。')
				return
			elseif 玩家持有的自定义币币数量 >= 收费价格 then
				Char.DelItem(player,自定义币itemid,收费价格,true)
				NLG.ShowWindowTalked(player,npc,CONST.窗口_信息框,CONST.按钮_上一页,player+404404,'@c【CN魔力 AI雇佣兵系统】\\n\\n\\n\\您已成功购买 ['..ai_list[预购目标][2]..']')
				Char.SetExtData(player,'ai-'..ai_list[预购目标][2],'yes')
				Char.SaveToDb(player)
				return
			end
		end
		return
	end
end

function 精简佣兵Module:登回出生点(player)--登回出生点触发
	if not 玩家持有ai表[player] then--reload后数据表初始化
		self:上线触发(player)
	end
	if 玩家持有ai表[player][0] >= 0 then
		self:玩家说话(player,'/aiback')
	end
	return 0
end

function 精简佣兵Module:上线触发(player)--上线触发，创建ai队友数据表
	玩家持有ai表[player] = {}
	现在页[player] = 1
	玩家持有ai表[player][0] = 0--ai队友数量统计
	for i = 1,#ai_list do
		玩家持有ai表[player][i] = -1
	end
	return 0
end

function 精简佣兵Module:传送触发(player,map,floor,x,y,aftermap,afterfloor,afterx,aftery)--传送触发
	if Char.IsDummy(player) then
		--print('ai_index编号：'..player)
		return
	else
		if not 玩家持有ai表[player] then--reload后数据表初始化
			self:上线触发(player)
		end
		--print('玩家index编号：'..player)
		if 玩家持有ai表[player][0] >= 0 then
			for i = 1,#ai_list do
				if Char.PartyNum(玩家持有ai表[player][i]) == -1 then
					Char.Warp(玩家持有ai表[player][i],aftermap,afterfloor,afterx,aftery)
					Char.SetData(player,CONST.对象_组队开关,1)
					Char.JoinParty(玩家持有ai表[player][i],player)
				end
			end
		end
	end
end

function 精简佣兵Module:下线掉线触发(player)--下线触发
	--print('玩家下线掉线触发')
	for i = 1,#ai_list do
		if 玩家持有ai表[player][i] > 0 then
			Char.DelDummy(玩家持有ai表[player][i])
			玩家持有ai表[player][0] = 0
		end
	end
	玩家持有ai表[player][0] = 0
end

function 精简佣兵Module:玩家说话(player,msg,color,range,size)--玩家说话
	if not 玩家持有ai表[player] then--reload后数据表初始化
		self:上线触发(player)
	end
	if msg == '/aiyb' or msg == '、aiyb' then
		self:面向npc触发(ai_npc,player)
		return 0
	end
	if msg == '/aiback' or msg == '、aiback' then
		if 玩家持有ai表[player][0] <= 0 then
			return 0
		end
		local wjmap = Char.GetData(player,CONST.对象_MAP)
		local wjfloor = Char.GetData(player,CONST.对象_地图)
		local wjx = Char.GetData(player,CONST.对象_X)
		local wjy = Char.GetData(player,CONST.对象_Y)
		for i = 1,#ai_list do
			if Char.PartyNum(玩家持有ai表[player][i]) == -1 then
				Char.Warp(玩家持有ai表[player][i],wjmap,wjfloor,wjx,wjy)
				Char.SetData(player,CONST.对象_组队开关,1)
				Char.JoinParty(玩家持有ai表[player][i],player)
			end
		end
		return 0
	end
	if msg == '/killai' or msg == '、killai' then--干掉ai的命令
		for i = 1,#ai_list do
			if 玩家持有ai表[player][i] > 0 then
				Char.DelDummy(玩家持有ai表[player][i])
				玩家持有ai表[player][i] = -1
				玩家持有ai表[player][0] = 0
			end
		end
		NLG.PlaySe(player,72,0,0)
		Char.DischargeParty(player)
		NLG.SystemMessage(player, '已开除所有佣兵。' )
		return 0
	end
	return 1--pass talk
end

function 精简佣兵Module:战斗结束触发(battleindex)--战后触发
	战斗对象表[battleindex] = nil
	for i = 0,19 do--ai自动满血满魔、招魂、治疗
		local ai = Battle.GetPlayer(battleindex,i) or -1
		if Char.IsDummy(ai) then--ai判定
			--print('ai掉魂状态：'..Char.GetData(ai,CONST.对象_掉魂))
			--print('ai受伤状态：'..Char.GetData(ai,CONST.对象_受伤))
			Char.SetData(ai,CONST.对象_掉魂,0)
			NLG.UpChar(ai)
			Char.SetData(ai,CONST.对象_受伤,0)
			NLG.UpChar(ai)
			Char.SetData(ai,CONST.对象_血,Char.GetData(ai,CONST.对象_最大血))
			Char.SetData(ai,CONST.对象_魔,Char.GetData(ai,CONST.对象_最大魔))
			local 装备index = false
			if Char.GetData(ai,CONST.对象_职类ID) == 140 then--格斗获取衣服index
				装备index = Char.GetItemIndex(ai,CONST.位置_身)
			else--其它职业获取武器index
				装备index = Char.GetItemIndex(ai,CONST.位置_左手)
			end
			local 水晶index = Char.GetItemIndex(ai,CONST.位置_水晶)
			Item.SetData(装备index,CONST.道具_耐久,9999)--修装备
			Item.SetData(装备index,CONST.道具_最大耐久,9999)--修装备
			Item.SetData(水晶index,CONST.道具_耐久,9999)--修装备
			Item.SetData(水晶index,CONST.道具_最大耐久,9999)--修装备
			local ai_petslot = Char.GetData(ai,CONST.对象_战宠) or -1--ai宠物判定
			if ai_petslot > -1 then--如果有宠物
				local ai_pet = Char.GetPet(ai,ai_petslot)
				Char.SetData(ai_pet,CONST.对象_受伤,0)
				Char.SetData(ai_pet,CONST.对象_忠诚,100)
				Char.SetData(ai_pet,CONST.对象_基础忠诚,100)
				Char.SetPetDepartureState(ai, 0, CONST.PET_STATE_战斗)
				Char.SetData(ai, CONST.CHAR_战宠, 0)
				Char.SetData(ai_pet,CONST.PET_DepartureBattleStatus, CONST.PET_STATE_战斗)
				Char.SetData(ai_pet,CONST.对象_血,Char.GetData(ai_pet,CONST.对象_最大血))
				Char.SetData(ai_pet,CONST.对象_魔,Char.GetData(ai_pet,CONST.对象_最大魔))
				Pet.UpPet(ai,ai_pet)
				NLG.UpChar(ai_pet)
			end
			NLG.UpChar(ai)
		end
		if Char.IsPlayer(ai) then--玩家判定
			self:玩家说话(ai,'/aiback')
		end
	end
	return 0
end

function 精简佣兵Module:回合开始前触发(battleindex)
	--职业统计： 弓-44 | 剑-14 | 斧-24 | 骑-34 | 格-144 | 魔-74 | 传-64 | 巫-134 | 咒-84 | 忍-154
	local 本局index = Battle.GetTurn(battleindex)
	if 战斗对象表[battleindex] == 本局index then
		return
	end
	战斗对象表[battleindex] = 本局index
	--print('回合开始前触发，battleindex：'..battleindex)
	--print('本局index：'..本局index)
	local player = {}--玩家存储
	for i = 0, 19 do
		local ai_index = Battle.GetPlayer(battleindex, i)
		if ai_index >= 0 then
			if Char.IsPlayer(ai_index) then--收录人的index
				player[i] = ai_index
			end
			if Char.IsDummy(ai_index) then--ai判断
				player[i] = ai_index
				if Char.GetData(ai_index,CONST.对象_魔) < 500 then--确保ai一直有魔够无限放技能
					Char.SetData(ai_index,CONST.对象_魔,Char.GetData(ai_index,CONST.对象_最大魔))
				end
				--print('ai自动战斗：',ai_index,petindex)
				if Battle.IsWaitingCommand(ai_index) then--职业使用技能判断
					local 职业类 = Char.GetData(ai_index,CONST.对象_职类ID)
					local 战斗指令接口 = CONST.BATTLE_COM--别改，会爆炸
					local 技能选择接口 = Battle.ActionSelect--别改，会爆炸
					if Battle.GetType(battleindex) == CONST.战斗_PVP then--PK跑路
						Char.SimpleLogout(ai_index)
						goto pk略过
					end
					--第1动
					if 职业类 == 40 then--弓
						local 技能表 = {
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_RANDOMSHOT,math.random(10,19),9509) end,--乱射
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_DELAYATTACK,math.random(10,19),25809) end,--一击必中
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_DODGE,math.random(10,19),909) end,--阳炎
						}
						if math.random(1,100) < 70 then--乱射释放概率70%
							pcall(技能表[1])
						else--其它技能随机施放
							local 随机施放 = math.random(1,#技能表)
							pcall(技能表[随机施放])
						end
					end
					if 职业类 == 10 then--剑
						local 技能表 = {
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_FIRSTATTACK,math.random(10,19),26209) end,--迅速
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_BLASTWAVE,math.random(10,19),200509) end,--剑气--请确认你的tech也是这个编号
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_PARAMETER,math.random(10,19),309) end,--乾坤
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_PARAMETER,math.random(10,19),109) end,--诸刃
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_RENZOKU,math.random(10,19),9) end,--连击破碎
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_RENZOKU,math.random(10,19),8) end,--连击乱舞
						}
						local 随机施放 = math.random(1,#技能表)
						pcall(技能表[随机施放])
					end
					if 职业类 == 20 then--斧
						local 技能表 = {
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_DELAYATTACK,math.random(10,19),25709) end,--戒骄戒躁
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_PARAMETER,math.random(10,19),309) end,--乾坤
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_PARAMETER,math.random(10,19),109) end,--诸刃
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_RENZOKU,math.random(10,19),9) end,--连击破碎
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_RENZOKU,math.random(10,19),8) end,--连击乱舞
						}
						if math.random(1,100) < 70 then--戒骄戒躁释放概率70%
							pcall(技能表[1])
						else--其它技能随机施放
							local 随机施放 = math.random(1,#技能表)
							pcall(技能表[随机施放])
						end
					end
					if 职业类 == 30 then--骑
						local 技能表 = {
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_BILLIARD,math.random(15,19),26009) end,--一石二鸟
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_PARAMETER,math.random(10,19),309) end,--乾坤
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_PARAMETER,math.random(10,19),109) end,--诸刃
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_RENZOKU,math.random(10,19),9) end,--连击破碎
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_RENZOKU,math.random(10,19),8) end,--连击乱舞
						}
						if math.random(1,100) < 50 then--一石二鸟释放概率50%
							pcall(技能表[1])
						else--其它技能随机施放
							local 随机施放 = math.random(1,#技能表)
							pcall(技能表[随机施放])
						end
					end
					if 职业类 == 140 then--格
						local 技能表 = {
							function() 技能选择接口(ai_index, 战斗指令接口.BATTLE_COM_P_SPIRACLESHOT,math.random(10,19),409) end,--气功弹
							function() 技能选择接口(ai_index, 战斗指令接口.BATTLE_COM_P_PANIC,math.random(10,19),9409) end,--混乱攻击
							function() 技能选择接口(ai_index, 战斗指令接口.BATTLE_COM_P_GUARDBREAK,math.random(10,19),509) end,--崩击
						}
						if math.random(1,100) < 70 then--气功弹释放概率70%
							pcall(技能表[1])
						else--其它技能随机施放
							local 随机施放 = math.random(1,#技能表)
							pcall(技能表[随机施放])
						end
					end
					if 职业类 == 70 then--魔
						local 技能表 = {
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_MAGIC,41,2709) end,--超陨
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_MAGIC,41,2809) end,--超冰
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_MAGIC,41,2909) end,--超火
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_MAGIC,41,3009) end,--超风
						}
						local 随机施放 = math.random(1,#技能表)
						pcall(技能表[随机施放])
					end
					if 职业类 == 60 then--传
						local 技能表 = {
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_HEAL,40,6309) end,--超强补血
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_HEAL,math.random(20,29),6209) end,--强力补血
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_HEAL,math.random(0,9),6109) end,--补血
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_REVIVE,math.random(0,9),6809) end,--气绝
						}
						if math.random(1,100) < 70 then--超强补血释放概率70%
							pcall(技能表[1])
						else--其它技能随机施放
							local 随机施放 = math.random(1,#技能表)
							pcall(技能表[随机施放])
						end
					end
					if 职业类 == 130 then--巫
						local 技能表 = {
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_LP_RECOVERY,40,6609) end,--超强恢复
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_STATUSRECOVER,40,6709) end,--洁净
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_REVIVE,math.random(0,9),6809) end,--气绝
						}
						local 随机施放 = math.random(1,#技能表)
						pcall(技能表[随机施放])
					end
					if 职业类 == 80 then--咒
						local 技能表 = {
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_STATUSCHANGE,41,4409) end,--超强毒
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_STATUSCHANGE,41,4509) end,--超强睡
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_STATUSCHANGE,41,4609) end,--超强石
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_STATUSCHANGE,41,4709) end,--超强醉
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_STATUSCHANGE,41,4809) end,--超强乱
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_STATUSCHANGE,41,4909) end,--超强忘
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_REVERSE_TYPE,math.random(0,19),5409) end,--属性反转
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_REFLECTION_PHYSICS,math.random(0,9),5509) end,--攻反
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_INEFFECTIVE_PHYSICS,math.random(0,9),5909) end,--攻无
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_ABSORB_PHYSICS,math.random(0,9),5709) end,--攻吸
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_REFLECTION_MAGIC,math.random(0,9),5609) end,--魔反
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_INEFFECTIVE_MAGIC,math.random(0,9),6009) end,--魔无
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_ABSORB_MAGIC,math.random(0,9),5809) end,--魔吸
						}
						if math.random(1,100) < 50 then--超咒放概率50%
							local 随机施放 = math.random(1,6)
							pcall(技能表[随机施放])
						else--其它技能随机施放
							local 随机施放 = math.random(7,#技能表)
							pcall(技能表[随机施放])
						end
					end
					if 职业类 == 150 then--忍
						local 技能表 = {
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_ASSASSIN,math.random(10,19),9609) end,--暗杀
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_DODGE,math.random(10,19),909) end,--阳炎
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_ATTACKALL,math.random(10,19),10601) end,--影分身--请确认你的tech也是这个编号
						}
						if Battle.GetType(battleindex) == CONST.战斗_BOSS战 then--boss战，不暗杀
							local 随机施放 = math.random(2,#技能表)
							pcall(技能表[随机施放])
						else
							if math.random(1,100) < 50 then--暗杀概率50%
								pcall(技能表[1])
							else
								local 随机施放 = math.random(2,#技能表)
								pcall(技能表[随机施放])
							end
						end
					end
					if Char.GetData(ai_index,CONST.对象_职业) == 481 then--GM测试
						local 技能表 = {
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_M_DEATH,math.random(0,19),8602) end,--单体即死--请确认你的tech也是这个编号
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_ASSASSIN,math.random(10,19),9609) end,--暗杀
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_M_EARTHQUAKE,math.random(40,41),9708) end,--大地之怒--请确认你的tech也是这个编号
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_DANCE,-1,9802) end,--变大
						}
						local 随机施放 = math.random(1,#技能表)
						pcall(技能表[随机施放])
					end
					--第2动
					--local petindex = Battle.GetPlayer(battleindex,math.fmod(i + 5,10))
					local petindex = Char.GetPet(ai_index,0)
					if petindex >= 0 then--如果带宠物，宠物使用技能
						--print('宠物名字 = '..Char.GetData(petindex,CONST.对象_名字))
						local 宠物技能表 = {--宠物施放的技能，需要宠物真的有学这个技能，否则无法施放，最多10个，人不用学，也无限制
							--function() 技能选择接口(petindex,战斗指令接口.BATTLE_COM_ATTACK,math.random(10,19),-1) end,--攻击
							--function() 技能选择接口(petindex,战斗指令接口.BATTLE_COM_GUARD,-1,-1) end,--防御
							function() 技能选择接口(petindex,战斗指令接口.BATTLE_COM_P_SPECIALGARD,-1,838) end,--圣盾
							function() 技能选择接口(petindex,战斗指令接口.BATTLE_COM_P_RENZOKU,math.random(10,19),38) end,--连击
							function() 技能选择接口(petindex,战斗指令接口.BATTLE_COM_P_PARAMETER,math.random(10,19),138) end,--诸刃
							function() 技能选择接口(petindex,战斗指令接口.BATTLE_COM_P_PARAMETER,math.random(10,19),338) end,--乾坤
							function() 技能选择接口(petindex,战斗指令接口.BATTLE_COM_P_MAGIC,math.random(30,39),2339) end,--强力陨石魔法
							function() 技能选择接口(petindex,战斗指令接口.BATTLE_COM_P_MAGIC,math.random(30,39),2439) end,--强力冰冻魔法
							function() 技能选择接口(petindex,战斗指令接口.BATTLE_COM_P_MAGIC,math.random(30,39),2539) end,--强力火焰魔法
							function() 技能选择接口(petindex,战斗指令接口.BATTLE_COM_P_MAGIC,math.random(30,39),2639) end,--强力风刃魔法
							function() 技能选择接口(petindex,战斗指令接口.BATTLE_COM_M_BLOODATTACK,math.random(10,19),8138) end,--吸血攻击
							function() 技能选择接口(petindex,战斗指令接口.BATTLE_COM_M_STATUSATTACK,math.random(10,19),7738) end,--石化攻击
						}
						local 随机施放 = math.random(1,#宠物技能表)
						--print('随机 = '..随机施放)
						pcall(宠物技能表[随机施放])
					else--没带宠物，ai佣兵2动普攻
						local 技能表 = {
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_ATTACK,10,-1) end,--攻击
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_GUARD,-1,-1) end,--防御
							function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_POSITION,-1,-1) end,--换位、定点移动
						}
						local 随机施放 = math.random(1, #技能表)
						pcall(技能表[随机施放])
					end
					::pk略过::
				end
			end
		end
	end
	if Battle.GetType(battleindex) == CONST.战斗_PVP then--PK只防御
		for k,v in pairs(player) do
			if Char.IsPlayer(v) then
				for d,j in pairs(player) do
					if Char.IsDummy(j) then
						NLG.Say(v,j,'我无法参与pk，只能跑路咯。',math.random(0,9),math.random(0,4))
					end
				end
			end
		end
	end
end

function 创建ai(player,ai序,ai名字,ai职业显示,ai造型,ai职业,ai职业类,ai装备,ai装备篡改参数)
	--职业统计： 弓-44 | 剑-14 | 斧-24 | 骑-34 | 格-144 | 魔-74 | 传-64 | 巫-134 | 咒-84 | 忍-154
	local 人_等级 = Char.GetData(player,CONST.对象_等级)
	local 人_体力 = Char.GetData(player,CONST.对象_体力)
	local 人_魔法 = Char.GetData(player,CONST.对象_魔法)
	local 人_攻击力 = Char.GetData(player,CONST.对象_力量)
	local 人_防御力 = Char.GetData(player,CONST.对象_强度)
	local 人_敏捷 = Char.GetData(player,CONST.对象_速度)
	local 随机数 = math.random(110,130)--生成110~130的随机数--然后ai参考裸体人物bp的110%~130%生成浮动bp
	if 人_等级 < ai最低等级 then--如果玩家等级小于70，ai等级强制为70，玩家等级高于70，ai等级则根据人的等级来
		人_等级 = ai最低等级
	end
	人_体力 = 人_体力 / 100 * 随机数
	人_魔法 = 人_魔法 / 100 * 随机数
	人_攻击力 = 人_攻击力 / 100 * 随机数
	人_防御力 = 人_防御力 / 100 * 随机数
	人_敏捷 = 人_敏捷 / 100 * 随机数
	if ai职业显示 == '魔法师' then--法师特殊设定
		if 人_体力 > 2500 then
			人_体力 = 2500
		end
		人_攻击力 = 0
		if 人_防御力 < 5000 then
			人_防御力 = 5000
		end
		if 人_魔法 < 50000 then
			人_魔法 = 50000
		end
	end
	if ai职业显示 == '传教士' or ai职业显示 == '巫师' or ai职业显示 == '咒术师' then--传巫特殊设定
		人_攻击力 = 0
		if 人_体力 < 50000 then
			人_体力 = 50000
		end
		if 人_魔法 < 25000 then
			人_魔法 = 25000
		end
	end
	local ai_index = Char.CreateDummy()--生成ai佣兵
	print('--------------------------------')
	print('成功招募佣兵，编号：'..ai_index)
	玩家持有ai表[player][0] = 玩家持有ai表[player][0] + 1--统计ai佣兵数量
	ai人口统计 = ai_index
	玩家持有ai表[player][ai序] = ai_index
	Char.SetData(ai_index, CONST.CHAR_X, Char.GetData(player, CONST.CHAR_X))
	Char.SetData(ai_index, CONST.CHAR_Y, Char.GetData(player, CONST.CHAR_Y))
	Char.SetData(ai_index, CONST.CHAR_地图, Char.GetData(player, CONST.CHAR_地图))
	Char.SetData(ai_index, CONST.CHAR_名字, ai名字)
	Char.SetData(ai_index, CONST.CHAR_地图类型, Char.GetData(player, CONST.CHAR_地图类型))
	Char.SetData(ai_index, CONST.CHAR_形象, ai造型)
	Char.SetData(ai_index, CONST.CHAR_原形, ai造型)
	Char.SetData(ai_index, CONST.CHAR_原始图档, ai造型)
	Char.SetData(ai_index, CONST.CHAR_体力, 人_体力)
	Char.SetData(ai_index, CONST.CHAR_力量, 人_攻击力)
	Char.SetData(ai_index, CONST.CHAR_强度, 人_防御力)
	Char.SetData(ai_index, CONST.CHAR_速度, 人_敏捷)
	Char.SetData(ai_index, CONST.CHAR_魔法, 人_魔法)
	Char.SetData(ai_index, CONST.CHAR_魅力, 100)
	Char.SetData(ai_index, CONST.CHAR_等级, 人_等级)
	Char.SetData(ai_index, CONST.CHAR_种族, 0)--人形系
	Char.SetData(ai_index, CONST.对象_职业, ai职业)
	Char.SetData(ai_index, CONST.对象_职类ID, ai职业类)
	Char.SetData(ai_index, CONST.对象_职阶, 3)--3转正式职业
	local itemindex = Char.GiveItem(ai_index, ai装备, 1)--给1件装备
	Item.SetData(itemindex,CONST.道具_已鉴定,1)
	Item.SetData(itemindex,CONST.道具_等级,1)--装备调整为1级，省得佣兵等级低带不上
	--创建ai = {序,ai名字,职业显示,图档id,job,jobrank,武器id,'武器血|武器魔|武器攻|武器防|武器敏|武器精|武器魔攻|武器魔抗|武器反|武器命|武器必|武器闪|武器回|武器魅',开通价格}
	local 装备篡改 = split(ai装备篡改参数,'|')
	for k,v in pairs(装备篡改) do
		if v == '不改' then
			装备篡改[k] = false
		else
			装备篡改[k] = tonumber(v)
		end
	end
	--for k,v in pairs(装备篡改) do
	--	print(k,v)
	--end
	for 项目 = 1,#装备篡改 do--开始篡改
		if 装备篡改[项目] then
			Item.SetData(itemindex,装备常量表[项目],装备篡改[项目])
		end
	end
	Item.UpItem(ai_index,-1)
	NLG.UpChar(ai_index)
	local nowitemslot = Char.GetItemSlot(ai_index, itemindex)
	--print('现在物品位置 = '..nowitemslot)
	local stat = false
	if ai职业显示 == '格斗士' then
		stat = Char.MoveItem(ai_index, nowitemslot, CONST.位置_身, -1)
	else
		stat = Char.MoveItem(ai_index, nowitemslot, CONST.位置_左手, -1)
	end
	--print('移动物品 = '..stat)
	print('武器：'..Item.GetData(itemindex,CONST.道具_已鉴定名))
	--print('是否鉴定？ = '..Item.GetData(itemindex,CONST.道具_已鉴定))
	--itemindex = false
	itemindex = Char.GiveItem(ai_index, math.random(9205,9240), 1)--给随机水晶
	Item.SetData(itemindex,CONST.道具_已鉴定,1)
	Item.UpItem(ai_index,-1)
	NLG.UpChar(ai_index)
	nowitemslot = Char.GetItemSlot(ai_index, itemindex)
	--print('现在物品位置 = '..nowitemslot)
	stat = Char.MoveItem(ai_index, nowitemslot, CONST.位置_水晶, -1)
	--print('移动物品 = '..stat)
	print('水晶：'..Item.GetData(itemindex,CONST.道具_已鉴定名))
	--print('是否鉴定？ = '..Item.GetData(itemindex,CONST.道具_已鉴定))
	Char.GiveItem(ai_index, 2, 100)--堵满背包
	--print('ai道具栏数量 = '..Char.GetData(ai_index,CONST.对象_道具栏)-8)
	--print('ai道具栏占用数量 = '..Char.ItemSlot(ai_index))
	Char.AddSkill(ai_index, 71)--调教
	Char.SetSkillLevel(ai_index,0,10)
	local petindex = -1
	repeat
		petindex = Char.GivePet(ai_index, math.random(1,904))--给随机宠物
	until petindex > 0
	Char.SetData(petindex,CONST.对象_忠诚,100)
	Char.SetData(petindex,CONST.对象_基础忠诚,100)
	Char.SetPetDepartureState(ai_index, 0, CONST.PET_STATE_战斗)
	Char.SetData(ai_index, CONST.CHAR_战宠, 0)
	Char.SetData(petindex,CONST.PET_DepartureBattleStatus, CONST.PET_STATE_战斗)
	Char.SetData(petindex,CONST.对象_等级,人_等级)
	Char.SetData(petindex,CONST.CHAR_体力, 人_等级*100*1.2)
	Char.SetData(petindex,CONST.CHAR_魔法, 人_等级*100*2)
	Char.SetData(petindex,CONST.CHAR_力量, 人_等级*100)
	Char.SetData(petindex,CONST.CHAR_强度, 人_等级*100*0.1)
	Char.SetData(petindex,CONST.CHAR_速度, 人_等级*100*0.5)
	Char.SetData(petindex,CONST.对象_技能栏,10)
	for killslot = 0,9 do--清除垃圾技能
		Pet.DelSkill(petindex,killslot)
	end
	--宠物最多给10个技能，请注意计算
	Pet.AddSkill(petindex, 838)--圣盾
	Pet.AddSkill(petindex, 38)--连击
	Pet.AddSkill(petindex, 138)--诸刃
	Pet.AddSkill(petindex, 338)--乾坤
	Pet.AddSkill(petindex, 2339)--强力陨石魔法
	Pet.AddSkill(petindex, 2439)--强力冰冻魔法
	Pet.AddSkill(petindex, 2539)--强力火焰魔法
	Pet.AddSkill(petindex, 2639)--强力风刃魔法
	Pet.AddSkill(petindex, 8138)--吸血攻击
	Pet.AddSkill(petindex, 7738)--石化攻击
	Char.SetData(player,CONST.对象_组队开关,1)
	Char.JoinParty(ai_index, player)
	NLG.UpChar(ai_index)
	NLG.UpChar(player)
	Char.SetData(ai_index, CONST.对象_血, Char.GetData(ai_index, CONST.对象_最大血))
	Char.SetData(ai_index, CONST.对象_魔, Char.GetData(ai_index, CONST.对象_最大魔))
	Char.SetData(petindex, CONST.对象_血, Char.GetData(petindex, CONST.对象_最大血))
	Char.SetData(petindex, CONST.对象_魔, Char.GetData(petindex, CONST.对象_最大魔))
	NLG.UpChar(ai_index)
	NLG.UpChar(player)
	Pet.UpPet(ai_index, petindex)
	local vital = Char.GetData(ai_index,CONST.对象_体力)
	local HP = Char.GetData(ai_index,CONST.对象_最大血)
	local magic = Char.GetData(ai_index,CONST.对象_魔法)
	local MP = Char.GetData(ai_index,CONST.对象_最大魔)
	local rec = Char.GetData(ai_index,CONST.对象_回复)
	local atk = Char.GetData(ai_index,CONST.对象_力量)
	local def = Char.GetData(ai_index,CONST.对象_强度)
	local quk = Char.GetData(ai_index,CONST.对象_速度)
	local js = Char.GetData(ai_index,CONST.对象_精神)
	local job = Char.GetData(ai_index,CONST.对象_职业)
	print('被创建的ai属性：'..job..' 体'..vital..' 魔'..magic..' 力'..atk..' 强'..def..' 敏'..quk..' HP'..HP..' MP'..MP..' 回'..rec..' 精'..js)--每100=1点bp
	print('--------------------------------')
end

function 招募ai(player,ai序)--招募ai
	--print('------------------ai序 = '..ai序)
	if 玩家持有ai表[player][ai序] >= 0 then
		NLG.PlaySe(player,72,0,0)
		Char.LeaveParty(玩家持有ai表[player][ai序])
		Char.DelDummy(玩家持有ai表[player][ai序])
		玩家持有ai表[player][ai序] = -1
		玩家持有ai表[player][0] = 玩家持有ai表[player][0] - 1
	elseif 玩家持有ai表[player][0] > 3 then
		NLG.ShowWindowTalked(player,ai_npc,CONST.窗口_信息框,CONST.按钮_上一页,player+404404,'@c【CN魔力 AI雇佣兵系统】\\n\\n\\n\\n您已经召唤了4位小伙伴了，不能再召唤了。')
	elseif ai人口统计 > ai人口限制 then
		NLG.ShowWindowTalked(player,ai_npc,CONST.窗口_信息框,CONST.按钮_上一页,player+404404,'@c【CN魔力 AI雇佣兵系统】\\n\\n\\n\\n当前线路人口爆满，无法添加佣兵了。')
	elseif Char.PartyNum(player) >= 5 then
		--print('队伍人数 = '..Char.PartyNum(player))
		NLG.ShowWindowTalked(player,ai_npc,CONST.窗口_信息框,CONST.按钮_上一页,player+404404,'@c【CN魔力 AI雇佣兵系统】\\n\\n\\n\\n你的队伍人数已满。')
	elseif 玩家持有ai表[player][ai序] == -1 then
		创建ai(player,ai_list[ai序][1],ai_list[ai序][2],ai_list[ai序][3],ai_list[ai序][4],ai_list[ai序][5],ai_list[ai序][6],ai_list[ai序][7],ai_list[ai序][8])
	end
end

function shuzipanduan(data)--数字或文本判断
	local wenben = data
	local shuzi = data
	if tonumber(data) == nil then
		return tostring(wenben)
	else
		return tonumber(shuzi)
	end
end

function left(str,len)--居左
    local char = ' ' -- 填充空格
	if len-#str >= 0 then
		local padding = string.rep(char,len-#str)
		return str..padding
	else
		local text = '数据太长请修改'
		local padding = string.rep(char,len-#text)
		return text..padding
	end
end

function split(str,split_char)--分割空格内容到table
    local sub_str_tab = {}
    while (true) do
		local pos = string.find(str, split_char)
		if (not pos) then
			sub_str_tab[#sub_str_tab + 1] = str
			break
		end
		local sub_str = string.sub(str, 1, pos - 1)
		sub_str_tab[#sub_str_tab + 1] = sub_str
		str = string.sub(str, pos + 1, #str)
    end
    return sub_str_tab
end

--卸载模块钩子
function 精简佣兵Module:onUnload()
	self:logInfo('unload')
end

return 精简佣兵Module
