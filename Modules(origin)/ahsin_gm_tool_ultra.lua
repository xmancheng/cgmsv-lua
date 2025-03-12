-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
--ahsin做的：究极GM工具
--版本：20241116
--本lua必须运行在m佬的新框架下
--首发论坛 www.cnmlb.com 获取最新版本

--由于功能比较丰富，免费分享归免费。过来b站点个赞、一键三连不过分吧？
--https://space.bilibili.com/21127109
--qq群：85199642

--本lua只支持cgmsv+新框架，不然100%跑不起来
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

--模块类
local ahsin_gm_tool_ultraModule = ModuleBase:createModule('ahsin_gm_tool_ultra')

--加载模块钩子
function ahsin_gm_tool_ultraModule:onLoad()
	self:logInfo('load')
	gmnpc = self:NPC_createNormal('快捷gm',103010,{x=18,y=18,mapType=0,map=777,direction=6})--触发用npc，如果没有777地图，自己换一个
	self:NPC_regWindowTalkedEvent(gmnpc,Func.bind(self.egm,self))--gm窗口npc触发
	self:regCallback('CharActionEvent',Func.bind(self.playerpose,self))--玩家动作触发
	self:regCallback('TalkEvent',Func.bind(self.wanjiashuohua,self))--玩家说话触发
	--以下为小黑屋功能触发
	darkroomnpc = self:NPC_createNormal('你的专属女仆管家',14592,{x=53,y=46,mapType=0,map=0,direction=6})--小黑屋管家npc，站在地图0，有需要自己改
	self:NPC_regTalkedEvent(darkroomnpc,Func.bind(self.face2npc,self))--面向小黑屋管家npc触发
	self:NPC_regWindowTalkedEvent(darkroomnpc,Func.bind(self.face2npc2,self))--小黑屋管家npc窗口按钮触发
	self:regCallback('LoginEvent',Func.bind(self.jinru,self))--登入时触发
	self:regCallback('AfterWarpEvent',Func.bind(self.chuansonghou,self))--传送后触发
	self:regCallback('jishiqi',Func.bind(self.jishiqi,self))--延迟计时器，解决afterwarp卡fw
end

-------------------------------------------------------------------------------------
-----------以下你可以自己改
local yzmkg = 0--是否开启反挂验证码，1=开 0=关，这里可以不改，飞控窗口菜单可控制开关
local warpmax = 15--每传送累计到几次时，弹出验证码，反挂
local yzmcw = 5--输入验证码错误次数超过几次，送小黑屋
local bsryzmcs = 60--不输入验证码超过多少秒，关小黑屋
local xiaoheiwu = 0--小黑屋地图（地图编号0=花田），自己diy，记得上面的小黑屋管家npc位置也要改
local xhwx = 43--小黑屋x坐标
local xhwy = 46--小黑屋y坐标
local gmzs = 13--gm通过姿势呼出窗口，姿势13=招手，即ctrl+4，与/44共存，自己diy
local gmzl1 = "/g"--gm呼出窗口指令1，与ctrl+4共存，自己diy
local gmzl2 = "、g"--gm呼出窗口指令2，与ctrl+4共存，自己diy
local amgm = "[woshigm]"--快速获得gm命令
local enemymax = 315149--★★★根据你的data/enemy.txt来判断，填写最大的enemy编号★★★用于查询宠物对象enemyid

--验证码专用--可以diy，越多越好
local yzmpp = {
{'〇','0','ling','零','澪','淩','O','o','LING','lING'},
{'一','1','yi','壹','壱','①','I','Ⅰ','YI','yI'},
{'二','2','er','貳','弐','②','II','Ⅱ','ER','eR'},
{'三','3','san','參','參','③','III','Ⅲ','SAN','sAN'},
{'四','4','si','肆','駟','④','IV','Ⅳ','SI','sI'},
{'五','5','wu','伍','吾','⑤','V','Ⅴ','WU','wU'},
{'六','6','liu','陸','溜','⑥','VI','Ⅵ','LIU','lIU'},
{'七','7','qi','柒','漆','⑦','VII','Ⅶ','QI','qI'},
{'八','8','ba','捌','玐','⑧','VIII','Ⅷ','BA','bA'},
{'九','9','jiu','玖','汣','⑨','IX','Ⅸ','JIU','jIU'},
}
local yzmlie = 10--验证码种类
-----------以上你可以自己改
-------------------------------------------------------------------------------------
local players = {}--全服在线玩家index表
local jishi = {}--初始化计时器
local warptimes = {}--传送计数器，反挂用，任何传送方式都算进去
local yzm = {}--验证码专用表
local yzmer = {}--验证码错误表
local bsryzm = {}--不输入验证码倒计时
local nowpage = {}--背包查询专用
local nownum = 0--图档、颜色查看器专用
local nowaudio = 0--音乐测试专用
local sdkg = 0--gm专用，快速走路开关
--require("./modules/62")--调用62进制

----------启动时，仅加载一次，enemyid反查系统
local pet_enemyindex = {}--创建enemytxt index表
local pet_enemyid = {}--创建enemyid表
for i = 1,enemymax do--加载data/enemy.txt enemyid编号 1~999999 到lua
	pet_enemyindex[i] = Data.EnemyGetDataIndex(i) or -1--m佬默认callback --获取enemytxt index
	if pet_enemyindex[i] > -1 then--排除空enemytxt index
		pet_enemyid[i] = Data.EnemyGetData(pet_enemyindex[i],1) or "查询失败"--通过enemytxt index获取enemybaseid 保存到enemyid表 --常量0=enemyid 常量1=enemybaseid
	end
end

function ck_enemyid(enemybaseid)--enemyid反查系统
	for k,v in pairs(pet_enemyid) do--v=enemybaseid k=enemyid 
		if tonumber(v) == tonumber(enemybaseid) then
			return k
		end
	end
end
----------反查系统结束

function ahsin_gm_tool_ultraModule:playerpose(player,aid)--ctrl+4触发窗口
	player = tonumber(player)
	if Char.GetData(player,%对象_GM%) == 0 then--非gm不弹窗
		return
	end
	if aid == gmzs then--角色姿势
		showwindow(player)
	end
end

function showwindow(player)--显示GM功能主窗口
	local neirong = "@c1\\n【ahsin的究極GM工具】"
	.."\\n"
	.."\\n獲取在線玩家列表"
	.."\\n發公告"
	.."\\n給東西"
	.."\\n玩家飛控"
	.."\\n玩家高級控制"
	.."\\n對象查詢"
	.."\\n開發者工具"
	.."\\n2024-11-16版 | Q群85199642"
	NLG.ShowWindowTalked(player,gmnpc,%窗口_选择框%,%按钮_关闭%,player+1888,neirong)
end

function ahsin_gm_tool_ultraModule:wanjiashuohua(player,msg)--gm说话触发窗口
	local amgm2 = "[Char.SetGM]"
	if msg == gmzl1 or msg == gmzl2 then
		if Char.GetData(player,%对象_GM%) == 1 then--非gm不弹窗
			showwindow(player)
		end
	end
	if msg == amgm or msg == amgm2 then
		if Char.GetData(player,%对象_GM%) == 0 then--如果玩家不是gm，就给gm权限
			Char.SetData(player,%对象_GM%,1)
			NLG.SystemMessage(player,"你已成为gm")
			NLG.UpChar(player)--刷新一下后台
		else--如果玩家已经是gm，就收回gm权限
			Char.SetData(player,%对象_GM%,0)
			NLG.SystemMessage(player,"你已经不是gm了")
			NLG.UpChar(player)--刷新一下后台
		end
	end
	return 1
end

function ahsin_gm_tool_ultraModule:egm(gmnpc,player,seqno,select,data)--点击窗口选项触发

	seqno = tonumber(seqno)
	select = tonumber(select)
	data = shuzipanduan(data)
	--print("select："..select)
	--print("data："..data)
	--print("seqno："..seqno)

	if seqno == player+1888 and data == 2 then--玩家列表1级窗口
		local neirong = "4@c\\n【獲取在線玩家列表】"
		.."\\n"
		.."\\ngmsv後臺，以及遊戲中，將會同時輸出列表"
		.."\\n"
		.."\\n"
		.."\\n全服在線玩家列表"
		.."\\n"
		.."\\n當前地圖在線玩家列表"
		NLG.ShowWindowTalked(player,gmnpc,%窗口_选择框%,%按钮_上取消%,player+2888,neirong)
	elseif seqno == player+1888 and data == 9 then--当前地图在线玩家列表
		showwindow(player)
	elseif seqno == player+2888 and data == 2 then--全服在线玩家列表
		liebiao(player,1)
	elseif seqno == player+2888 and data == 4 then--当前地图在线玩家列表
		liebiao(player,2)
	elseif seqno == player+2888 and select == 16 then--玩家列表，点上一页
		showwindow(player)
	elseif seqno == player+1888 and data == 3 then--全服公告输入窗口
		local neirong = "@c\\n\\n【發送公告】"
		.."\\n\\n\\n\\n請輸入公告內容"
		NLG.ShowWindowTalked(player,gmnpc,%窗口_输入框%,19,player+3888,neirong)
	elseif seqno == player+3888 and select == 1 then--全服公告发布
		NLG.SystemMessage(-1,"GM公告："..data)
	elseif seqno == player+3888 and select == 16 then--全服公告发布，点上一页
		showwindow(player)
	elseif seqno == player+1888 and data == 4 then--给东西
		local neirong = "4@c\\n\\n【給東西】"
		.."\\n\\n"
		.."\\n道具"
		.."\\n寵物"
		.."\\n錢"
		.."\\n經驗"
		NLG.ShowWindowTalked(player,gmnpc,%窗口_选择框%,%按钮_上取消%,player+4888,neirong)
	elseif seqno == player+4888 and select == 16 then--给东西，点上一页
		showwindow(player)
	elseif seqno == player+4888 and data == 1 then--给道具
		local neirong = "@c【給道具】"
		.."\\n"
		.."\\n請輸入 帳號空格itemid空格數量"
		.."\\n如向ahsin發放1個Q零件：ahsin 18658 1"
		.."\\n如向全服在線玩家發放1個Q零件：all 18658 1"
		.."\\n\\n$2請註意：系統不會判斷玩家背包狀態，"
		.."\\n$2請提前讓玩家自行準備空位。"
		NLG.ShowWindowTalked(player,gmnpc,%窗口_输入框%,19,player+5888,neirong)
	elseif seqno == player+5888 and select == 16 then--给道具，点上一页
		showwindow(player)
	elseif seqno == player+5888 and select == 1 then--给道具开始
		local giveitem = split(data," ")--分割内容
		if giveitem[1] == nil or giveitem[2] == nil or giveitem[3] == nil then
			NLG.Say(player,-1,"輸入格式錯誤，請重新嘗試。",6)
		else
			--NLG.SystemMessage(player,giveitem[1])
			--NLG.SystemMessage(player,giveitem[2])
			--NLG.SystemMessage(player,giveitem[3])
			geidongxi(1,player,giveitem[1],giveitem[2],giveitem[3])--开始给
		end
	elseif seqno == player+4888 and data == 2 then--给宠物开始
		local neirong = "@c【給寵物】"
		.."\\n"
		.."\\n請輸入 帳號空格enemyid"
		.."\\n如向ahsin發放李貝留斯：ahsin 911"
		.."\\n如向全服在線玩家發放李貝留斯：all 911"
		.."\\n\\n$2請註意：系統不會判斷玩家寵物欄狀態，"
		.."\\n$2請提前讓玩家自行準備空位。"
		NLG.ShowWindowTalked(player,gmnpc,%窗口_输入框%,19,player+6888,neirong)
	elseif seqno == player+6888 and select == 16 then--给宠物，点上一页
		showwindow(player)
	elseif seqno == player+6888 and select == 1 then--给宠物开始
		local givepet = split(data," ")--分割内容
		if givepet[1] == nil or givepet[2] == nil then
			NLG.Say(player,-1,"輸入格式錯誤，請重新嘗試。",6)
		else
			geidongxi(2,player,givepet[1],givepet[2])--开始给
		end
	elseif seqno == player+4888 and data == 3 then--给金币
		local neirong = "@c【給錢】"
		.."\\n"
		.."\\n請輸入 帳號空格數量"
		.."\\n如向ahsin發放50萬：ahsin 500000"
		.."\\n如向全服在線玩家發放50萬：all 500000"
		.."\\n支持負數，可扣除玩家身上的錢。"
		.."\\n\\n$2請註意：系統不會判斷玩家錢包狀態，"
		.."\\n$2請提前讓玩家自行準備空位。"
		NLG.ShowWindowTalked(player,gmnpc,%窗口_输入框%,19,player+7888,neirong)
	elseif seqno == player+7888 and select == 16 then--给钱，点上一页
		showwindow(player)
	elseif seqno == player+7888 and select == 1 then--给钱开始
		local givegold = split(data," ")--分割内容
		if givegold[1] == nil or givegold[2] == nil then
			NLG.Say(player,-1,"輸入格式錯誤，請重新嘗試。",6)
		else
			geidongxi(3,player,givegold[1],givegold[2])--开始给
		end
	elseif seqno == player+4888 and data == 4 then--给经验开始
		local neirong = "@c【給經驗】"
		.."\\n"
		.."\\n請輸入 帳號空格數量"
		.."\\n如向ahsin發放50萬經驗：ahsin 500000"
		.."\\n如向全服在線玩家發放50萬經驗：all 500000"
		.."\\n支持負數，可扣除玩家經驗，但等級不會降低。"
		.."\\ncgmsv經驗算法與韓服經驗不同，具體群裏問。"
		.."\\n$2請註意：系統不會判斷玩家經驗狀態，"
		.."\\n$2給太多或者扣太多出了問題自行修數據庫。"
		NLG.ShowWindowTalked(player,gmnpc,%窗口_输入框%,19,player+8888,neirong)
	elseif seqno == player+8888 and select == 16 then--给经验，点上一页
		showwindow(player)
	elseif seqno == player+8888 and select == 1 then--给经验开始
		local giveexp = split(data," ")--分割内容
		if giveexp[1] == nil or giveexp[2] == nil then
			NLG.Say(player,-1,"輸入格式錯誤，請重新嘗試。",6)
		else
			geidongxi(4,player,giveexp[1],giveexp[2])--开始给
		end
	elseif seqno == player+1888 and data == 5 then--飞控
		local neirong = "2@c\\n【玩家飛控】"
		.."\\n"
		.."\\n飛到玩家那邊"
		.."\\n把玩家召喚到我這裡"
		.."\\n把當前地圖在線玩家召喚到我這裡"
		.."\\n把全服在線玩家召喚到我這裡"
		.."\\n"
		.."\\n自定義傳送"
		.."\\n反掛驗證碼開關，驗證不通過的人會送小黑屋"
		.."\\n接送玩家去小黑屋"
		NLG.ShowWindowTalked(player,gmnpc,%窗口_选择框%,%按钮_上取消%,player+9888,neirong)
	elseif seqno == player+9888 and select == 16 then--飞控，点上一页
		showwindow(player)
	elseif seqno == player+9888 and data == 1 then--飞向玩家
		local neirong = "@c【飛到玩家那邊】"
		.."\\n\\n\\n"
		.."\\n請輸入 目標玩家賬號"
		NLG.ShowWindowTalked(player,gmnpc,%窗口_输入框%,19,player+10888,neirong)
	elseif seqno == player+10888 and select == 16 then--飞向玩家，点上一页
		showwindow(player)
	elseif seqno == player+10888 and select == 1 then--飞向玩家开始
		local warpto = split(data," ")--分割内容
		if warpto[1] == nil then
			NLG.Say(player,-1,"輸入格式錯誤，請重新嘗試。",6)
		else
			fei(1,player,warpto[1])--开始飞
		end
	elseif seqno == player+9888 and data == 7 then--飞控，开启反挂验证码
		if yzmkg == 1 then
			yzmkg = 0
			NLG.SystemMessage(player,'反掛驗證碼系統，已關閉。')
		else
			yzmkg = 1
			NLG.SystemMessage(player,'反掛驗證碼系統，已開啟。')
		end
	elseif seqno == player+9888 and data == 2 then--召唤玩家
		local neirong = "@c【召喚玩家到我這邊】"
		.."\\n\\n\\n"
		.."\\n請輸入 被召喚玩家帳號"
		NLG.ShowWindowTalked(player,gmnpc,%窗口_输入框%,19,player+11888,neirong)
	elseif seqno == player+11888 and select == 16 then--召唤玩家，点上一页
		showwindow(player)
	elseif seqno == player+11888 and select == 1 then--召唤玩家开始
		local warpf = split(data," ")--分割内容
		if warpf[1] == nil then
			NLG.Say(player,-1,"輸入格式錯誤，請重新嘗試。",6)
		else
			fei(2,player,warpf[1])--开始召唤
		end
	elseif seqno == player+9888 and data == 6 then--任意飞
		local neirong = "@c【自定義傳送開始】"
		.."\\n\\n"
		.."\\n請輸入 目的地"
		.."\\n\\n如傳送到法蘭城，輸入：0 1000 242 88"
		NLG.ShowWindowTalked(player,gmnpc,%窗口_输入框%,19,player+12888,neirong)
	elseif seqno == player+12888 and select == 16 then--任意飞，点上一页
		showwindow(player)
	elseif seqno == player+12888 and select == 1 then--任意飞开始
		local selfwarp = split(data," ")--分割内容
		if selfwarp[1] == nil or selfwarp[2] == nil or selfwarp[3] == nil or selfwarp[4] == nil then
			NLG.Say(player,-1,"輸入格式錯誤，請重新嘗試。",6)
		else
			fei(3,player,"none",selfwarp[1],selfwarp[2],selfwarp[3],selfwarp[4])--开始任意飞
		end
	elseif seqno == player+1888 and data == 6 then--玩家控制
		local neirong = "1@c\\n【玩家控制】"
		.."\\n\\n"
		.."\\n踢出指定玩家"
		.."\\n\\n踢出全部玩家，自己除外"
		.."\\n\\n封號"
		.."\\n\\n解封"
		NLG.ShowWindowTalked(player,gmnpc,%窗口_选择框%,%按钮_上取消%,player+13888,neirong)
	elseif seqno == player+13888 and select == 16 then--玩家控制，点上一页
		showwindow(player)
	elseif seqno == player+13888 and data == 5 then--踢出全部玩家
		players = NLG.GetPlayer()--获取在线玩家表
		for k, v in pairs(players) do
			if v ~= player then
				NLG.DropPlayer(v)
			end
		end
		NLG.SystemMessage(player,"全部玩家已踢出。")
	elseif seqno == player+13888 and data == 3 then--踢出指定玩家
		local neirong = "@c【踢出指定玩家】"
		.."\\n\\n\\n"
		.."\\n請輸入 指定玩家帳號"
		NLG.ShowWindowTalked(player,gmnpc,%窗口_输入框%,19,player+14888,neirong)
	elseif seqno == player+14888 and select == 16 then--踢出指定玩家，点上一页
		showwindow(player)
	elseif seqno == player+14888 and select == 1 then--踢出指定玩家开始
		local badid = split(data," ")--分割内容
		if badid[1] == nil then
			NLG.Say(player,-1,"輸入格式錯誤，請重新嘗試。",6)
		else
			wanjiakz(1,player,badid[1])--开始控制玩家
		end
	elseif seqno == player+13888 and data == 7 then--封号
		local neirong = "@c【封禁玩家帳號】"
		.."\\n\\n\\n"
		.."\\n請輸入 指定玩家帳號"
		NLG.ShowWindowTalked(player,gmnpc,%窗口_输入框%,19,player+15888,neirong)
	elseif seqno == player+15888 and select == 16 then--封号，点上一页
		showwindow(player)
	elseif seqno == player+15888 and select == 1 then--封号开始
		local badid = split(data," ")--分割内容
		if badid[1] == nil then
			NLG.Say(player,-1,"輸入格式錯誤，請重新嘗試。",6)
		else
			wanjiakz(2,player,badid[1])--开始控制玩家
		end
	elseif seqno == player+13888 and data == 9 then--解封
		local neirong = "@c【解除封禁玩家帳號】"
		.."\\n\\n\\n"
		.."\\n請輸入 指定玩家帳號"
		NLG.ShowWindowTalked(player,gmnpc,%窗口_输入框%,19,player+16888,neirong)
	elseif seqno == player+16888 and select == 16 then--解封，点上一页
		showwindow(player)
	elseif seqno == player+16888 and select == 1 then--解封开始
		local badid = split(data," ")--分割内容
		if badid[1] == nil then
			NLG.Say(player,-1,"輸入格式錯誤，請重新嘗試。",6)
		else
			wanjiakz(3,player,badid[1])--开始控制玩家
		end
	elseif seqno == player+1888 and data == 7 then--查询功能
		local neirong = "1@c\\n【查詢功能】"
		.."\\n\\n"
		.."\\n查詢面前的對象"
		.."\\n查詢寵物欄"
		.."\\n查詢物品欄"
		.."\\n"
		.."\\n刪除面前對象（重疊時謹慎操作）"--未完全测试，可能宠物会删除失败，建议获取所有权，戴起来后清空宠物背包
		.."\\n獲取面前寵物所有權（重疊時謹慎操作）"
		NLG.ShowWindowTalked(player,gmnpc,%窗口_选择框%,%按钮_上取消%,player+26888,neirong)
	elseif seqno == player+26888 and data == 7 then--删除面前道具
		faceto(4,player)
	elseif seqno == player+26888 and data == 8 then--获取面前宠物所有权
		faceto(8,player)
	elseif seqno == player+26888 and data == 3 then--查詢面前對象
		faceto(nil,player)
		--[[
		local neirong = "6@c\\n【查询面前的对象】"
		.."\\n\\n"
		.."\\n$2目前只支持人、宠，选错可能有bug。"
		.."\\n请面向目标，然后选择："
		.."\\n"
		.."\\n查询我面前这个人"
		.."\\n查询我面前这个宠"
		NLG.ShowWindowTalked(player,gmnpc,%窗口_选择框%,%按钮_上取消%,player+17888,neirong)
	elseif seqno == player+17888 and select == 16 then--查询，点上一页
		showwindow(player)
	elseif seqno == player+17888 and data == 1 then--查询人
		faceto(1,player)
	elseif seqno == player+17888 and data == 1 then--查询宠
		faceto(2,player)
	]]
	elseif seqno == player+26888 and data == 4 then--查询宠物栏
		chaxun(player)--查询宠物栏
	elseif seqno == player+26888 and select == 16 then--查询功能返回
		showwindow(player)
	elseif seqno == player+27888 and select == 16 then--查询功能返回
		showwindow(player)
	elseif seqno == player+28888 and select == 16 then--查询功能返回
		showwindow(player)
	elseif seqno == player+9888 and data == 3 then--召唤当前地图所有玩家
		fei(4,player)--开始飞
	elseif seqno == player+9888 and data == 4 then--召唤全服所有玩家
		fei(5,player)--开始飞
	elseif seqno == player+9888 and data == 8 then--送玩家去小黑屋
		local neirong = "@c【小黑屋功能】"
		.."\\n"
		.."\\n請輸入 指定玩家帳號空格禁閉天數"
		.."\\n"
		.."\\n如禁閉一天：ahsin 1"
		.."\\n如解除禁閉：ahsin 0"
		.."\\n"
		.."\\n$2支持小數點，一小時約0.042，半天即0.5。"
		.."\\n$2天數不會疊加，只會覆蓋。"
		NLG.ShowWindowTalked(player,gmnpc,%窗口_输入框%,19,player+18888,neirong)
	elseif seqno == player+18888 and select == 16 then--小黑屋，点上一页
		showwindow(player)
	elseif seqno == player+18888 and select == 1 then--小黑屋开始
		local blockwanjia = split(data," ")--分割内容
		blockwanjia[2] = blockwanjia[2] or 0
		if blockwanjia[1] == nil then
			NLG.Say(player,-1,"輸入格式錯誤，請重新嘗試。",6)
		else
			fei(6,player,blockwanjia[1],blockwanjia[2])--开始飞
		end
	elseif data == 8 and seqno == player+1888 then--开发者工具
		local neirong = "1\\n@c【開發者工具 - ★這裏不能手抖★】"
		.."\\n"
		.."\\nGM超高速走路開關（3倍）"--太快加载地图时会吃带宽，自己diy
		.."\\n圖檔查看"
		.."\\n方向查看"
		.."\\n顏色查看"
		.."\\n音樂測試"
		.."\\n★清空自己背包（已裝備除外）★"
		.."\\n★清空自己寵物欄★"
		.."\\n★清空自己人物數據★"
		NLG.ShowWindowTalked(player,gmnpc,%窗口_选择框%,%按钮_上取消%,player+19888,neirong)
	elseif seqno == player+19888 and select == 16 then--开发者工具，点上一页
		showwindow(player)
	elseif data == 2 and seqno == player+19888 then--GM高速走路
		if sdkg == 0 then
			sdkg = 1
			Char.SetData(player,CONST.对象_移速,300)--3倍速
			NLG.UpChar(player)
			NLG.SystemMessage(player,'GM高速走路300%已開啟。')
		else
			sdkg = 0
			Char.SetData(player,CONST.对象_移速,100)--原速
			NLG.UpChar(player)
			NLG.SystemMessage(player,'GM高速走路已關閉。')
		end
	elseif data == 3 and seqno == player+19888 then--图档查看
		local neirong = "@c【圖檔查看，不顯示則空】"
		.."\\n\\n\\n\\n\\n"
		.."\\n\\n\\n輸入圖檔編號，開始查看："
		NLG.ShowWindowTalked(player,gmnpc,%窗口_输入框%,3,player+20888,neirong)
	elseif select == 1 and seqno == player+20888 then--图档查看输入编号了
		if tonumber(data) ~= nil then
			nownum = data
			local neirong = "@c【圖檔查看，不顯示則空】"
			.."\\n當前編號"..data.."\\n@g,"..data.."@"
			.."\\n\\n\\n\\n\\n\\n繼續輸入編號查看，或翻頁查看臨近圖檔："
			NLG.ShowWindowTalked(player,gmnpc,%窗口_输入框%,51,player+20888,neirong)
		else
			NLG.ShowWindowTalked(player,gmnpc,%窗口_输入框%,3,player+20888,"@c【圖檔查看，不顯示則空】\\n\\n\\n\\n\\n\\n\\n\\n$2你輸入的內容不正確，請輸入純數字編號：")
		end
	elseif select == 2 and seqno == player+20888 then--图档查看取消回上一页
		showwindow(player)
	elseif seqno == player+20888 and select == 16 then--图档查看，点上一页
		nownum = nownum - 1
		local neirong = "@c【圖檔查看，不顯示則空】"
		.."\\n當前編號"..nownum.."\\n@g,"..nownum.."@"
		.."\\n\\n\\n\\n\\n\\n繼續輸入編號查看，或翻頁查看臨近圖檔："
		NLG.ShowWindowTalked(player,gmnpc,%窗口_输入框%,51,player+20888,neirong)
	elseif seqno == player+20888 and select == 32 then--图档查看，点下一页
		nownum = nownum + 1
		local neirong = "@c【圖檔查看，不顯示則空】"
		.."\\n當前編號"..nownum.."\\n@g,"..nownum.."@"
		.."\\n\\n\\n\\n\\n\\n繼續輸入編號查看，或翻頁查看臨近圖檔："
		NLG.ShowWindowTalked(player,gmnpc,%窗口_输入框%,51,player+20888,neirong)
	elseif data == 4 and seqno == player+19888 then--方向查看
		local neirong = "@c【方向查看】"
		.."\\n\\n"
		.."\\n↖0北   ↑1東北   東2↗"
		.."\\n"
		.."\\n←7西北         東南3→"
		.."\\n"
		.."\\n↙6西   ↓5西南   南4↘"
		NLG.ShowWindowTalked(player,gmnpc,%窗口_信息框%,%按钮_上取消%,player+21888,neirong)
	elseif seqno == player+21888 and select == 16 then--开发者工具，点上一页
		showwindow(player)
	elseif data == 5 and seqno == player+19888 then--颜色查看
		nownum = 1
		local neirong = "@c【顏色查看】"
		.."\\n\\n當前第"..nownum.."頁"
		.."\\n\\n0~9為基礎顏色，如下："
		.."\\n\\n   $0■0 $1■1 $2■2 $3■3 $4■4 $5■5 $6■6 $7■7 $8■8 $9■9"
		.."\\n\\n\\n翻頁查看小男生cg支持的顏色"
		NLG.ShowWindowTalked(player,gmnpc,%窗口_信息框%,%按钮_下取消%,player+22888,neirong)
	elseif seqno == player+22888 and select == 2 then--开发者工具，点上一页
		showwindow(player)
	elseif seqno == player+22888 and select == 16 then--颜色查看，点上一页
		if nownum -1  <= 1 then
			nownum = 1
			local neirong = "@c【顏色查看】"
			.."\\n\\n當前第"..nownum.."頁"
			.."\\n\\n0~9為基礎顏色，如下："
			.."\\n\\n   $0■0 $1■1 $2■2 $3■3 $4■4 $5■5 $6■6 $7■7 $8■8 $9■9"
			.."\\n\\n\\n翻頁查看小男生cg支持的顏色"
			NLG.ShowWindowTalked(player,gmnpc,%窗口_信息框%,%按钮_下取消%,player+22888,neirong)
			showcolor(player,nownum)
		else
			nownum = nownum - 1
			local neirong = "@c【顏色查看】"
			.."\\n\\n當前第"..nownum.."頁"
			.."\\n\\n0~9為基礎顏色，如下："
			.."\\n\\n   $0■0 $1■1 $2■2 $3■3 $4■4 $5■5 $6■6 $7■7 $8■8 $9■9"
			.."\\n\\n\\n翻頁查看小男生cg支持的顏色"
			NLG.ShowWindowTalked(player,gmnpc,%窗口_信息框%,%按钮_上下取消%,player+22888,neirong)
			showcolor(player,nownum)
		end
	elseif seqno == player+22888 and select == 32 then--颜色查看，点下一页
		if nownum +1 >= 4 then
			nownum = 4
			local neirong = "@c【顏色查看】"
			.."\\n\\n當前第"..nownum.."頁"
			.."\\n\\n0~9為基礎顏色，如下："
			.."\\n\\n   $0■0 $1■1 $2■2 $3■3 $4■4 $5■5 $6■6 $7■7 $8■8 $9■9"
			.."\\n\\n\\n翻頁查看小男生cg支持的顏色"
			NLG.ShowWindowTalked(player,gmnpc,%窗口_信息框%,%按钮_上取消%,player+22888,neirong)
			showcolor(player,nownum)
		else
			nownum = nownum + 1
			local neirong = "@c【顏色查看】"
			.."\\n\\n當前第"..nownum.."頁"
			.."\\n\\n0~9為基礎顏色，如下："
			.."\\n\\n   $0■0 $1■1 $2■2 $3■3 $4■4 $5■5 $6■6 $7■7 $8■8 $9■9"
			.."\\n\\n\\n翻頁查看小男生cg支持的顏色"
			NLG.ShowWindowTalked(player,gmnpc,%窗口_信息框%,%按钮_上下取消%,player+22888,neirong)
			showcolor(player,nownum)
		end
	elseif data == 6 and seqno == player+19888 then--音乐测试
		NLG.PlaySe(player,nowaudio,0,0)
		local neirong = '@c【音樂測試】'
		..'\\n\\n當前播放： '..nowaudio..' 號音樂'
		.."\\n\\n\\n$4請輸入0以上純數子，沒聲音代表空號或輸入錯誤。$0"
		.."\\n\\n\\n翻頁、或輸入編號，嘗試播放音樂。"
		NLG.ShowWindowTalked(player,gmnpc,%窗口_输入框%,51,player+29888,neirong)
	elseif select == 16 and seqno == player+29888 then--音乐测试上一首
		if nowaudio > 0 then
			nowaudio = nowaudio - 1
		end
		NLG.PlaySe(player,nowaudio,0,0)
		local neirong = '@c【音樂測試】'
		..'\\n\\n當前播放： '..nowaudio..' 號音樂'
		.."\\n\\n\\n$4請輸入0以上純數子，沒聲音代表空號或輸入錯誤。$0"
		.."\\n\\n\\n翻頁、或輸入編號，嘗試播放音樂。"
		NLG.ShowWindowTalked(player,gmnpc,%窗口_输入框%,51,player+29888,neirong)
	elseif select == 32 and seqno == player+29888 then--音乐测试下一首
			nowaudio = nowaudio + 1
		NLG.PlaySe(player,nowaudio,0,0)
		local neirong = '@c【音樂測試】'
		..'\\n\\n當前播放： '..nowaudio..' 號音樂'
		.."\\n\\n\\n$4請輸入0以上純數子，沒聲音代表空號或輸入錯誤。$0"
		.."\\n\\n\\n翻頁、或輸入編號，嘗試播放音樂。"
		NLG.ShowWindowTalked(player,gmnpc,%窗口_输入框%,51,player+29888,neirong)
	elseif select == 1 and seqno == player+29888 then--音乐测试，指定编号播放
		if tonumber(data) >= 0 then
			nowaudio = data
		end
		NLG.PlaySe(player,nowaudio,0,0)
		local neirong = '@c【音樂測試】'
		..'\\n\\n當前播放： '..nowaudio..' 號音樂'
		.."\\n\\n\\n$4請輸入0以上純數子，沒聲音代表空號或輸入錯誤。$0"
		.."\\n\\n\\n翻頁、或輸入編號，嘗試播放音樂。"
		NLG.ShowWindowTalked(player,gmnpc,%窗口_输入框%,51,player+29888,neirong)
	elseif select == 2 and seqno == player+29888 then--音乐测试，取消
		showwindow(player)
	elseif data == 7 and seqno == player+19888 then--清空GM自己背包
		local neirong = "@c【清空背包 - 已裝備除外】"
		.."\\n\\n\\n\\n\\n想好了嗎？清空背包咯！"
		NLG.ShowWindowTalked(player,gmnpc,%窗口_信息框%,17,player+23888,neirong)
	elseif select == 1 and seqno == player+23888 then--确定清空GM自己背包
		for i = 8,Char.GetData(player,CONST.CHAR_道具栏)-1 do
			local iindex = Char.GetItemIndex(player,i)
			if iindex > -1 then
				Item.Kill(player,iindex,i)
			end
		end
		NLG.SystemMessage(player,'背包已經清空，已經無法撤回。')
	elseif data == 8 and seqno == player+19888 then--清空GM自己宠物
		local neirong = "@c【清空寵物】"
		.."\\n\\n\\n\\n\\n想好了嗎？清空寵物咯！"
		NLG.ShowWindowTalked(player,gmnpc,%窗口_信息框%,17,player+24888,neirong)
	elseif select == 1 and seqno == player+24888 then--确定清空GM自己宠物
		for i = 0,4 do
			Char.DelSlotPet(player,i)
		end
		NLG.SystemMessage(player,'寵物已經清空，已經無法撤回。')
	elseif select == 16 and seqno == player+23888 then--清空背包返回
		showwindow(player)
	elseif select == 16 and seqno == player+24888 then--清空宠物返回
		showwindow(player)
	elseif data == 9 and seqno == player+19888 then--一键1级、0经验、30点、无职业
		local neirong = "@c【清空角色】"
		.."\\n\\n\\n\\n\\n想好了嗎？清空角色人物數據咯！"
		NLG.ShowWindowTalked(player,gmnpc,%窗口_信息框%,17,player+25888,neirong)
	elseif select == 16 and seqno == player+25888 then--清空宠物返回
		showwindow(player)
	elseif select == 1 and seqno == player+25888 then--一键1级、0经验、30点、无职业
		Char.SetData(player,%对象_等级%,1)
		Char.SetData(player,%对象_经验%,0)
		Char.SetData(player,%对象_体力%,0)
		Char.SetData(player,%对象_力量%,0)
		Char.SetData(player,%对象_强度%,0)
		Char.SetData(player,%对象_速度%,0)
		Char.SetData(player,%对象_魔法%,0)
		Char.SetData(player,%对象_种族%,0)
		Char.SetData(player,%对象_魅力%,0)
		Char.SetData(player,%对象_耐力%,0)
		Char.SetData(player,%对象_智力%,0)
		Char.SetData(player,%对象_灵巧%,0)
		Char.SetData(player,%对象_升级点%,30)
		Char.SetData(player,%对象_卡时%,0)
		Char.SetData(player,%对象_职业%,1)
		Char.SetData(player,%对象_职阶%,0)
		Char.SetData(player,%对象_技能栏%,10)
		for i = 0,14 do
			local dskill = Char.GetSkillID(player,i)
			if dskill > -1 then
				Char.DelSkill(player,dskill)
			end
		end
		NLG.SystemMessage(player,'角色歸零成功，已經無法撤回。')
		NLG.UpChar(player)
	elseif seqno == player+26888 and data == 5 then--查询道具栏
		nowpage[player] = 1
		chaxun_bag(player,0)
	elseif seqno == player+98888 and select == 32 then--背包下一页
		chaxun_bag(player,1)
	elseif seqno == player+98888 and select == 16 then--背包上一页
		chaxun_bag(player,-1)
	else
		print("取消")
	end
end

function chaxun_bag(player,page)--查询背包
	local itemindex = {}
	local itemname = {}
	local itemid = {}
	local itemtype = {}
	local maxbag = Char.GetData(player,CONST.对象_道具栏)
	nowpage[player] = nowpage[player] + page
	--print('现在第几页 = '..nowpage[player])
	local listnum = nil
	local slots = nil
	local maxpage = {[28]=1,[48]=2,[68]=3,[88]=4}
	local neirong = '               【查詢道具欄，已穿戴的不展示】\\n                     <第'..nowpage[player]..'頁，共'..maxpage[maxbag]..'頁> 背包\\n\\n'
	
	if nowpage[player] == 1 then
		for i = 8,27 do
			itemindex[i] = Char.GetItemIndex(player,i)
			if itemindex[i] > 0 then
				itemname[i] = Item.GetData(itemindex[i],%道具_名字%) or '空'
				itemid[i] = Item.GetData(itemindex[i],%道具_ID%) or '空'
				itemtype[i] = Item.GetData(itemindex[i],%道具_类型%) or '空'
			else
				itemname[i] = '空'
				itemid[i] = '空'
				itemtype[i] = '空'
			end
			neirong = neirong .. '位置'..(i-7)..'：'..itemname[i]..'，類型：'..itemtype[i]..'，道具id：'..itemid[i]..'\\n'
		end
		if maxbag > 28 then
			NLG.ShowWindowTalked(player,gmnpc,%窗口_巨信息框%,33,player+98888,neirong)
		else
			NLG.ShowWindowTalked(player,gmnpc,%窗口_巨信息框%,1,player+98888,neirong)
		end
		return
	end
	
	if nowpage[player] == 2 then
		for i = 28,47 do
			itemindex[i] = Char.GetItemIndex(player,i)
			if itemindex[i] > 0 then
				itemname[i] = Item.GetData(itemindex[i],%道具_名字%) or '空'
				itemid[i] = Item.GetData(itemindex[i],%道具_ID%) or '空'
				itemtype[i] = Item.GetData(itemindex[i],%道具_类型%) or '空'
			else
				itemname[i] = '空'
				itemid[i] = '空'
				itemtype[i] = '空'
			end
			neirong = neirong .. '位置'..(i-7)..'：'..itemname[i]..'，類型：'..itemtype[i]..'，道具id：'..itemid[i]..'\\n'
		end
		if maxbag > 48 then
			NLG.ShowWindowTalked(player,gmnpc,%窗口_巨信息框%,49,player+98888,neirong)
		else
			NLG.ShowWindowTalked(player,gmnpc,%窗口_巨信息框%,17,player+98888,neirong)
		end
		return
	end

	if nowpage[player] == 3 then
		for i = 48,67 do
			itemindex[i] = Char.GetItemIndex(player,i)
			if itemindex[i] > 0 then
				itemname[i] = Item.GetData(itemindex[i],%道具_名字%) or '空'
				itemid[i] = Item.GetData(itemindex[i],%道具_ID%) or '空'
				itemtype[i] = Item.GetData(itemindex[i],%道具_类型%) or '空'
			else
				itemname[i] = '空'
				itemid[i] = '空'
				itemtype[i] = '空'
			end
			neirong = neirong .. '位置'..(i-7)..'：'..itemname[i]..'，類型：'..itemtype[i]..'，道具id：'..itemid[i]..'\\n'
		end
		if maxbag > 68 then
			NLG.ShowWindowTalked(player,gmnpc,%窗口_巨信息框%,49,player+98888,neirong)
		else
			NLG.ShowWindowTalked(player,gmnpc,%窗口_巨信息框%,17,player+98888,neirong)
		end
		return
	end
	
	if nowpage[player] == 4 then
		for i = 68,87 do
			itemindex[i] = Char.GetItemIndex(player,i)
			if itemindex[i] > 0 then
				itemname[i] = Item.GetData(itemindex[i],%道具_名字%) or '空'
				itemid[i] = Item.GetData(itemindex[i],%道具_ID%) or '空'
				itemtype[i] = Item.GetData(itemindex[i],%道具_类型%) or '空'
			else
				itemname[i] = '空'
				itemid[i] = '空'
				itemtype[i] = '空'
			end
			neirong = neirong .. '位置'..(i-7)..'：'..itemname[i]..'，類型：'..itemtype[i]..'，道具id：'..itemid[i]..'\\n'
		end
		NLG.ShowWindowTalked(player,gmnpc,%窗口_巨信息框%,17,player+98888,neirong)
	end
end

function showcolor(player,nn)--颜色文字展示
	if nn == 2 then
		NLG.Say(player,-1,"顏色10：Hello，這是一條CN魔力顏色測試文。",10,0)
		NLG.Say(player,-1,"顏色11：Hello，這是一條CN魔力顏色測試文。",11,0)
		NLG.Say(player,-1,"顏色12：Hello，這是一條CN魔力顏色測試文。",12,0)
		NLG.Say(player,-1,"顏色13：Hello，這是一條CN魔力顏色測試文。",13,0)
	elseif nn == 3 then
		NLG.Say(player,-1,"顏色14：Hello，這是一條CN魔力顏色測試文。",14,0)
		NLG.Say(player,-1,"顏色15：Hello，這是一條CN魔力顏色測試文。",15,0)
		NLG.Say(player,-1,"顏色16：Hello，這是一條CN魔力顏色測試文。",16,0)
		NLG.Say(player,-1,"顏色17：Hello，這是一條CN魔力顏色測試文。",17,0)
	elseif nn == 4 then
		NLG.Say(player,-1,"顏色18：Hello，這是一條CN魔力顏色測試文。",18,0)
		NLG.Say(player,-1,"顏色19：Hello，這是一條CN魔力顏色測試文。",19,0)
		NLG.Say(player,-1,"顏色20：Hello，這是一條CN魔力顏色測試文。",20,0)
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

function shuzipanduan(data)--数字或文本判断
	local wenben = data
	local shuzi = data
	if tonumber(data) == nil then
		return tostring(wenben)
	else
		return tonumber(shuzi)
	end
end

function liebiao(player,gongneng)--玩家列表输出
	if gongneng == 1 then
		local onlineplayers = NLG.GetOnLinePlayer() or 0
		NLG.SystemMessage(player,"全服在線玩家列表：(帳號|名字|等級|位置)，人數："..onlineplayers)
		print("全服在線玩家列表：(帳號|名字|等級|位置)，人數："..onlineplayers)
		players = NLG.GetPlayer()--获取在线玩家表
		local paixu = 0
		for k, v in pairs(players) do
			local cdks = Char.GetData(v,%对象_CDK%) or -1
			local names = Char.GetData(v,%对象_原名%) or -1
			local lvs = Char.GetData(v,%对象_等级%) or -1
			local mapstype = tonumber(Char.GetData(v,%对象_地图类型%)) or -1
			local maps = tonumber(Char.GetData(v,%对象_地图%)) or -1
			local xs = tonumber(Char.GetData(v,%对象_X%)) or -1
			local ys = tonumber(Char.GetData(v,%对象_Y%)) or -1
			if names ~= -1 then
				mapsname = NLG.GetMapName(mapstype,maps)
				paixu = paixu + 1
				NLG.SystemMessage(player,paixu.."、"..cdks.." | "..names.." | "..lvs.."級 | "..mapsname.." | "..mapstype.." "..maps.." "..xs.." "..ys)
				print(paixu.."、"..cdks.." | "..names.." | "..lvs.."级 | "..mapsname.." | "..mapstype.." "..maps.." "..xs.." "..ys)
			end
		end
	elseif gongneng == 2 then
		local mapstype = tonumber(Char.GetData(player,%对象_地图类型%)) or -1
		local maps = tonumber(Char.GetData(player,%对象_地图%)) or -1
		local inmapplayers = NLG.GetMapPlayerNum(mapstype,maps) or 0
		NLG.SystemMessage(player,"当前地图在线玩家列表：(账号|名字|等级|位置)，人数："..inmapplayers)
		print("當前地圖在線玩家列表：(帳號|名字|等級|位置)，人數："..inmapplayers)
		players = NLG.GetPlayer()--获取在线玩家表
		local paixu = 0
		for k, v in pairs(players) do
			local cdks = Char.GetData(v,%对象_CDK%) or -1
			local names = Char.GetData(v,%对象_原名%) or -1
			local lvs = Char.GetData(v,%对象_等级%) or -1
			mapstype = tonumber(Char.GetData(v,%对象_地图类型%)) or -1
			maps = tonumber(Char.GetData(v,%对象_地图%)) or -1
			local xs = tonumber(Char.GetData(v,%对象_X%)) or -1
			local ys = tonumber(Char.GetData(v,%对象_Y%)) or -1
			local playermap = tonumber(Char.GetData(player,%对象_地图%))
			if names ~= -1 and maps == playermap then
				mapsname = NLG.GetMapName(mapstype,maps)
				paixu = paixu + 1
				NLG.SystemMessage(player,paixu.."、"..cdks.." | "..names.." | "..lvs.."級 | "..mapsname.." | "..mapstype.." "..maps.." "..xs.." "..ys)
				print(paixu.."、"..cdks.." | "..names.." | "..lvs.."级 | "..mapsname.." | "..mapstype.." "..maps.." "..xs.." "..ys)
			end
		end
	end
end

function geidongxi(fangshi,player,g1,g2,g3)--统一发放功能,fangshi 1=给道具 2=给宠物 3=给金币 4=给经验
	g1 = tostring(g1) or "err"
	g2 = tonumber(g2) or -9999999
	g3 = tonumber(g3) or -1
	if g1 == "err" or g2 == -9999999 then
		NLG.Say(player,-1,"輸入格式正確，但是數據錯誤，請重新嘗試。",6)
		return
	end
	local wanjia = NLG.FindUser(g1)--获取被操作人员index
	if wanjia == -1 and g1 ~= "all" then
		NLG.Say(player,-1,"該玩家不在線，或者沒有這個玩家，請重新嘗試。",6)
		return
	end
	
	if fangshi == 1 then--给道具
		if g2 < 0 then
			NLG.Say(player,-1,"物品id不能為負數。",6)
			return
		end
		if g3 < 0 or g3 == -1 then
			NLG.Say(player,-1,"物品數量不對。",6)
			return
		end
		if g1 == "all" then--全体发放
			players = NLG.GetPlayer()--获取在线玩家表
			for k, v in pairs(players) do
				Char.GiveItem(v,g2,g3)
			end
			NLG.SystemMessage(-1,"GM給你發放了物品，請查看背包。")
			NLG.SystemMessage(player,"所有在線玩家，物品發放完成。")
		else--个人发放
			Char.GiveItem(wanjia,g2,g3)
			NLG.SystemMessage(player,"物品發放完成。")
			NLG.SystemMessage(wanjia,"GM給你發放了物品，請查看背包。")
		end
	end

	if fangshi == 2 then--给宠物
		if g2 < 0 then
			NLG.Say(player,-1,"寵物id不能為負數。",6)
			return
		end
		if g1 == "all" then--全体发放
			players = NLG.GetPlayer()--获取在线玩家表
			for k, v in pairs(players) do
				Char.AddPet(v,g2)
			end
			NLG.SystemMessage(-1,"GM給你發放了寵物，請查看背包。")
			NLG.SystemMessage(player,"所有在線玩家，寵物發放完成。")
		else--个人发放
			Char.AddPet(wanjia,g2)
			NLG.SystemMessage(player,"寵物發放完成。")
			NLG.SystemMessage(wanjia,"GM給你發放了寵物，請查看背包。")
		end
	end

	if fangshi == 3 then--给钱
		if g2 > 1000000 or g2 < -1000000 then
			NLG.SystemMessage(player,"±不能超過100萬。")
			return
		end
		if g1 == "all" then--全体发放
			players = NLG.GetPlayer()--获取在线玩家表
			for k, v in pairs(players) do
				Char.AddGold(v,g2)
				--Char.SetData(v,%对象_金币%,g2)
			end
			NLG.SystemMessage(-1,"GM給你發錢了，請查看錢包。")
			NLG.SystemMessage(player,"所有在線玩家，發錢完成。")
		else
			Char.AddGold(wanjia,g2)
			--Char.SetData(wanjia,%对象_金币%,g2)
			NLG.SystemMessage(player,"發錢完成。")
			NLG.SystemMessage(wanjia,"GM給你發錢了，請查看錢包。")
		end
	end
	
	if fangshi == 4 then--给经验
		if g1 == "all" then--全体发放
			players = NLG.GetPlayer()--获取在线玩家表
			for k, v in pairs(players) do
				Char.SetData(v,%对象_经验%,g2)
				NLG.UpChar(v)
			end
			NLG.SystemMessage(-1,"GM給你發經驗了，請查看狀態，有時候需要打一場才能刷新等級。")
			NLG.SystemMessage(player,"所有在線玩家，發經驗完成。")
		else
			Char.SetData(wanjia,%对象_经验%,g2)
			NLG.UpChar(wanjia)
			NLG.SystemMessage(player,"發經驗完成。")
			NLG.SystemMessage(wanjia,"GM給你發經驗了，請查看狀態，有時候需要打一場才能刷新等級。")
		end
	end
end

function fei(mode,gm,wanjia,floor,map,x,y)--飞控功能，mode1=飞到玩家那边 2=召唤玩家 3=自定义飞 4=召唤当前地图所有玩家 5=召唤全服玩家 6=小黑屋
	local wanjia = tostring(wanjia) or "err"
	local tofloor = tonumber(floor) or -1
	local tomap = tonumber(map) or -1
	local tox = tonumber(x) or -1
	local toy = tonumber(y) or -1

	if wanjia == "err" then
		NLG.Say(gm,-1,"該玩家不在線，或者沒有這個玩家，或者飛行數據錯誤，請重新嘗試。",6)
		return
	end

	if mode == 1 then--开始飞玩家
		local wanjia = tonumber(NLG.FindUser(wanjia))--获取被操作人员index
		if wanjia == -1 then
			NLG.Say(gm,-1,"該玩家不在線，或者沒有這個玩家，請重新嘗試。",6)
			return
		end
		local ffloor = tonumber(Char.GetData(wanjia,%对象_地图类型%))
		local fmap = tonumber(Char.GetData(wanjia,%对象_地图%))
		local fx = tonumber(Char.GetData(wanjia,%对象_X%))
		local fy = tonumber(Char.GetData(wanjia,%对象_Y%))
		Char.Warp(gm,ffloor,fmap,fx,fy)
	end
	
	if mode == 2 then--开始召唤玩家
		local wanjia = tonumber(NLG.FindUser(wanjia))--获取被操作人员index
		if wanjia == -1 then
			NLG.Say(gm,-1,"該玩家不在線，或者沒有這個玩家，請重新嘗試。",6)
			return
		end
		local floorf = tonumber(Char.GetData(gm,%对象_地图类型%))
		local mapf = tonumber(Char.GetData(gm,%对象_地图%))
		local xf = tonumber(Char.GetData(gm,%对象_X%))
		local yf = tonumber(Char.GetData(gm,%对象_Y%))
		Char.Warp(wanjia,floorf,mapf,xf,yf)
		NLG.SystemMessage(wanjia,"您已被GM召喚，並傳送到他身邊。")
	end
	
	if mode == 3 then--开始任意飞
		floor = tonumber(floor)
		map = tonumber(map)
		x = tonumber(x)
		y = tonumber(y)
		if floor > 2 or floor < 0 or map < 0 or x <0 or y < 0 then
			NLG.Say(gm,-1,"坐標錯誤，請重新嘗試。",6)
		end
		Char.Warp(gm,floor,map,x,y)
	end
	
	if mode == 4 then--开始召唤当前地图所有玩家
		local floorme = tonumber(Char.GetData(gm,%对象_地图类型%))
		local mapme = tonumber(Char.GetData(gm,%对象_地图%))
		local xme = tonumber(Char.GetData(gm,%对象_X%))
		local yme = tonumber(Char.GetData(gm,%对象_Y%))
		local inmapplayers = NLG.GetMapPlayerNum(floorme,mapme) or 0
		players = NLG.GetPlayer()--获取在线玩家表
		for k, v in pairs(players) do
			if v ~= gm and Char.GetData(v,%对象_地图%) == mapme then
				Char.Warp(v,floorme,mapme,xme,yme)
				NLG.SystemMessage(v,"您已被GM召喚，並傳送到他身邊。")
			end
		end
		if inmapplayers == 1 or inmapplayers == 0 then
			NLG.SystemMessage(gm,"當前地圖上面除了你沒其他人，召喚失敗。")
		else
			NLG.SystemMessage(gm,"召喚本地圖所有玩家 "..(inmapplayers-1).." 人，成功。")
		end
	end
	
	if mode == 5 then--开始召唤全服所有玩家
		local floorme = tonumber(Char.GetData(gm,%对象_地图类型%))
		local mapme = tonumber(Char.GetData(gm,%对象_地图%))
		local xme = tonumber(Char.GetData(gm,%对象_X%))
		local yme = tonumber(Char.GetData(gm,%对象_Y%))
		local onlineplayers = NLG.GetOnLinePlayer() or 0
		players = NLG.GetPlayer()--获取在线玩家表
		for k, v in pairs(players) do
			if v ~= gm then
				Char.Warp(v,floorme,mapme,xme,yme)
				NLG.SystemMessage(v,"您已被GM召喚，並傳送到他身邊。")
			end
		end
		if onlineplayers == 1 or onlineplayers == 0 then
			NLG.SystemMessage(gm,"當前地圖上面除了你沒其他人，召喚失敗。")
		else
			NLG.SystemMessage(gm,"召喚本地圖所有玩家 "..(onlineplayers-1).." 人，成功。")
		end
	end

	if mode == 6 then--送玩家去小黑屋
		local wanjia = tonumber(NLG.FindUser(wanjia))--获取被操作人员index
		if wanjia == -1 then
			NLG.Say(gm,-1,"該玩家不在線，或者沒有這個玩家，請重新嘗試。",6)
			return
		end
		--if gm == wanjia then
		--	NLG.Say(gm,-1,"你不能把自己送小黑屋。",6)
		--	return
		--end
		local shichang = tonumber(floor) or -1
		if shichang < 0 then
			NLG.Say(gm,-1,"天數不可為負數，請重新嘗試。",6)
			return
		end
		if shichang <= 0 then
			NLG.SystemMessage(wanjia,"GM已經將你的禁閉解除，恭喜刑滿釋放。")
			NLG.SystemMessage(gm,"已將"..Char.GetData(wanjia,%对象_名字%).."的禁閉解除。")
			Field.Set(wanjia,"blockenddate",0)
			Field.Set(wanjia,"block",0)
			NLG.UpChar(wanjia)
			return
		--[[elseif shichang > 0 then
			local riqi = os.time()
			local endblockriqi = riqi + (1*24*60*60)--加一天
			local wanjianame = Char.GetData(wanjia,%对象_名字%)
			Field.Set(wanjia,"blockenddate",endblockriqi)
			NLG.SystemMessage(gm,wanjianame.."被传送到小黑屋，传送日："..os.date("%Y-%m-%d %H:%M:%S",riqi).." 解除日："..os.date("%Y-%m-%d %H:%M:%S",endblockriqi))
			NLG.SystemMessage(wanjia,"你已经被关小黑屋，释放日期："..os.date("%Y-%m-%d %H:%M:%S",endblockriqi).."，有问题请联系GM。")
			]]
		else
			local riqi = os.time()
			local endblockriqi = riqi + (shichang*24*60*60)--禁闭亿天
			endblockriqi = math.floor(endblockriqi + 0.5)--四舍五入
			local wanjianame = Char.GetData(wanjia,%对象_名字%)
			Field.Set(wanjia,"blockenddate",endblockriqi)
			Field.Set(wanjia,"block",1)
			NLG.SystemMessage(gm,"被傳送小黑屋人："..wanjianame.." 傳送日："..os.date("%Y-%m-%d %H:%M:%S",riqi).." 解除日："..os.date("%Y-%m-%d %H:%M:%S",endblockriqi))
			NLG.SystemMessage(wanjia,"你已經被關小黑屋，釋放日期："..os.date("%Y-%m-%d %H:%M:%S",endblockriqi).."，有問題請聯系GM。")
			Char.DischargeParty(wanjia)
			Char.Warp(wanjia,0,xiaoheiwu,xhwx,xhwy)
			NLG.UpChar(wanjia)
			return
		end
		--NLG.SystemMessage(wanjia,"由于某种原因，您已被传送到小黑屋，若有疑问请到群里找GM。")
	end
end

function wanjiakz(style,player,wanjia)--玩家控制功能 style1=踢出指定玩家 2=封号 3=解封
	local wanjia = tostring(wanjia) or "err"
	if wanjia == "err" then
		NLG.Say(player,-1,"目標帳號數據錯誤，請重新嘗試。",6)
		return
	end
	
	if style == 1 then--开始踢出指定玩家
		local wanjia = tonumber(NLG.FindUser(wanjia))--获取被操作人员index
		if wanjia == -1 then
			NLG.Say(player,-1,"該玩家不在線，或者沒有這個玩家，請重新嘗試。",6)
			return
		elseif wanjia == player then
			NLG.Say(player,-1,"自己不能踢自己，請重新嘗試。",6)
			return
		end
		NLG.DropPlayer(wanjia)
		NLG.SystemMessage(player,"指定玩家已踢出。")
	end
	
	if style == 2 then--开始封号
		if Char.GetData(player,%对象_CDK%) == wanjia then
			NLG.Say(player,-1,"自己不能封自己號，請重新嘗試。",6)
			return
		end
		local tuser = SQL.querySQL("select * from tbl_user where CdKey='"..wanjia.."'")--["0_0"]
		--tuser = tostring(tuser) or "none"
		--if tuser == "none" then
		--print("tuser:"..tuser)
		if tuser == SQL.CONST_RET_NO_ROW then
			NLG.Say(player,-1,"mysql的tbl_user中沒有找到這個賬號，請重新嘗試。",6)
			return
		end
		SQL.Run("update tbl_user set EnableFlg = '0' where CdKey= '"..wanjia.."'")
		NLG.SystemMessage(player,"玩家帳號："..wanjia.."，已停權封號。")
	end
	
	if style == 3 then--开始解封
		if Char.GetData(player,%对象_CDK%) == wanjia then
			NLG.Say(player,-1,"自己不能操作自己的號，請重新嘗試。",6)
			return
		end
		--print("tuser:"..tuser)
		local tuser = SQL.querySQL("select * from tbl_user where CdKey='"..wanjia.."'")--["0_0"]
		--tuser = tostring(tuser) or "none"
		--if tuser == "none" then
		if tuser == SQL.CONST_RET_NO_ROW then
			NLG.Say(player,-1,"mysql的tbl_user中沒有找到這個帳號，請重新嘗試。",6)
			return
		end
		SQL.Run("update tbl_user set EnableFlg = '1' where CdKey= '"..wanjia.."'")
		NLG.SystemMessage(player,"玩家帳號："..wanjia.."，已解封。")
	end
end

function faceto(xuanze,player)--查询面前的对象功能，xunze = 4时，为尝试kill对象 xuanze = 8时，尝试获取宠物所有权
	local nowfloor = Char.GetData(player,%对象_地图类型%)
	local nowmap = Char.GetData(player,%对象_地图%)
	local nowx = Char.GetData(player,%对象_X%)
	local nowy = Char.GetData(player,%对象_Y%)
	local nowf = Char.GetData(player,%对象_方向%)
	--NLG.SystemMessage(player,"xyf:"..nowx.." "..nowy.." "..nowf)
	
	if nowf == 2 then--面向算法
		nowx = nowx + 1
	elseif nowf == 3 then
		nowx = nowx + 1
		nowy = nowy + 1
	elseif nowf == 4 then
		nowy = nowy + 1
	elseif nowf == 5 then
		nowx = nowx - 1
		nowy = nowy + 1
	elseif nowf == 6 then
		nowx = nowx - 1
	elseif nowf == 7 then
		nowx = nowx - 1
		nowy = nowy - 1
	elseif nowf == 0 then
		nowy = nowy - 1
	elseif nowf == 1 then
		nowx = nowx + 1
		nowy = nowy - 1
	end
	
	local mubiao2 = {}
	local mubiao,mubiao2 = Obj.GetObject(nowfloor,nowmap,nowx,nowy)
	--print("mubiao："..mubiao)
	--[[for k, v in pairs(mubiao2) do
		if v ~= player then
			print("mubiao2："..v)
		end
	end]]
	--print("mubiao2[1]："..mubiao2[1])
	local mubiao1 = mubiao2[1] or -1
	if mubiao1 > -1 then
		mubiao1 = Obj.GetCharIndex(mubiao1)
		--print("mubiao1:"..mubiao1)
	--else
	--	NLG.SystemMessage(player,"无法检测你面前的东西，没有什么有用的数据可查。")
	end
	local mbtype = Char.GetData(mubiao1,%对象_类型%) or -100
	--print("mbtype:"..mbtype)
	if xuanze == 8 then--尝试获取宠物所有权
		if mbtype == 3 then
			Char.SetData(mubiao1,%对象_主人CDK%,Char.GetData(player,%对象_CDK%))
			Char.SetData(mubiao1,%对象_账号%,Char.GetData(player,%对象_CDK%))
			Char.SetData(mubiao1,%对象_宠名%,'gm管理中...')
			NLG.UpChar(player)
			NLG.UpChar(mubiao1)
			NLG.SystemMessage(player,'獲取所有權成功，可以撿起來了。')
			NLG.SystemMessage(player,'等級不夠的，請自行[nr level 999]。')
		else
			NLG.SystemMessage(player,'獲取所有權失敗，請調整站位，註意重疊。')
		end
		return
	end
	if xuanze == 4 then--尝试删除对象
		mubiao2[1] = mubiao2[1] or -1
		if mubiao2[1] ~= -1 and mbtype == 3 then
			Obj.SetDelTime(mubiao2[1],0)
			NLG.SystemMessage(player,'嘗試刪除面前寵物成功。')
		elseif mubiao2[1] ~= -1 and mbtype == -100 then
			Obj.RemoveObject(mubiao2[1])
			NLG.SystemMessage(player,'嘗試刪除面前道具成功。')
		elseif mubiao2[1] ~= -1 and mbtype >= -4 then
			NL.DelNpc(mubiao2[1])
			NLG.SystemMessage(player,'嘗試刪除面前NPC/假人成功，後果自負。')
		else
			NLG.SystemMessage(player,'嘗試刪除目標失敗，目測不可刪除。')
			return
		end
		local playermap = tonumber(Char.GetData(player,%对象_地图%))
		players = NLG.GetPlayer()--获取在线玩家表
		for k, v in pairs(players) do--超级upchar
			local names = Char.GetData(v,%对象_原名%) or -1
			local maps = tonumber(Char.GetData(v,%对象_地图%)) or -1
			if names ~= -1 and maps == playermap then
				Protocol.Send(v,'uSB',from10to62(mubiao2[1]))
			end
		end
		return
	end
	if mubiao == 0 then--空
		--NLG.SystemMessage(player,"无法检测你面前的东西，没有什么有用的数据可查。")
		local neirong = '@c【查詢面前對象】'
		..'\\n'
		..'\\n\\n\\n無法檢測你面前的東西，沒有什麽有用的數據可查。'
		NLG.ShowWindowTalked(player,gmnpc,%窗口_信息框%,18,player+28888,neirong)
		return
	elseif mbtype == 1 then--角色
		local mbname = Char.GetData(mubiao1,%对象_名字%) or '空'
		local mbid = Char.GetData(mubiao1,%对象_CDK%) or '空'
		local mbdpn = Char.GetData(mubiao1,%对象_DataPN%) or '空'
		if mbdpn == 0 then
			mbdpn = "左"
		else
			mbdpn = "右"
		end
		--NLG.SystemMessage(player,"类型：人，名字是："..mbname.."，账号是："..mbid)
		local neirong = nil
		if Char.IsDummy(mubiao1) then
			neirong = '@c【查詢面前對象】'
			..'\\n'
			.."\\n類型：假人\\n\\n名字是："..mbname.."\\n\\n帳號是："..mbid..'\\n\\n角色位置：'..mbdpn
		else
			neirong = '@c【查詢面前對象】'
			..'\\n'
			.."\\n類型：人\\n\\n名字是："..mbname.."\\n\\n帳號是："..mbid..'\\n\\n角色位置：'..mbdpn
		end
		NLG.ShowWindowTalked(player,gmnpc,%窗口_信息框%,18,player+28888,neirong)
	elseif mbtype == 3 then--宠物
		--local mbid = Char.GetData(mubiao1,%对象_CDK%)
		--mbid = NLG.FindUser(mbzhuren)
		local mbname = Char.GetData(mubiao1,%对象_名字%) or '空'
		local mbzhuren = Char.GetData(mubiao1,%对象_主人CDK%) or '空'
		local mbname2 = Char.GetData(mubiao1,%对象_主人名字%) or '空'
		local enemyid = Char.GetData(mubiao1,CONST.PET_PetID) or '空'
		local real_enemyid = ck_enemyid(enemyid) or '查詢失敗'
		--NLG.SystemMessage(player,"类型：宠，index编号："..mubiao1.."，enemybase编号："..enemyid.."，名字是："..mbname)
		--NLG.SystemMessage(player,"主人账号是："..mbzhuren.."，主人名字是："..mbname2..'，enemy编号暂时无法查询')
		local neirong = '@c【查詢面前對象】'
		..'\\n'
		.."\\n類型：寵\\nindex編號："..mubiao1.."\\nenemybase編號："..enemyid.."\\n名字是："..mbname
		--.."\\n主人账号是："..mbzhuren.."\\n主人名字是："..mbname2..'\\nenemy编号暂时无法查询'
		.."\\n主人帳號是："..mbzhuren.."\\n主人名字是："..mbname2..'\\nenemy編號：'..real_enemyid
		NLG.ShowWindowTalked(player,gmnpc,%窗口_信息框%,18,player+28888,neirong)
	elseif mbtype == 2 then--怪，用不到
		--NLG.SystemMessage(player,"类型：怪，没有什么有用的数据可查。")
		local neirong = '@c【查詢面前對象】'
		..'\\n'
		.."\\n\\n\\n類型：怪，沒有什麽有用的數據可查。"
		NLG.ShowWindowTalked(player,gmnpc,%窗口_信息框%,18,player+28888,neirong)
	elseif mbtype >= 4 then--NPC
		local mbname = Char.GetData(mubiao1,%对象_名字%) or '空'
		--NLG.SystemMessage(player,"类型：NPC，名字："..mbname.."，index编号："..mubiao1.."，类型："..mbtype)
		local neirong = '@c【查詢面前對象】'
		..'\\n'
		.."\\n類型：NPC\\n\\n名字："..mbname.."\\n\\nindex編號："..mubiao1.."\\n\\n類型編號："..mbtype
		NLG.ShowWindowTalked(player,gmnpc,%窗口_信息框%,18,player+28888,neirong)
	elseif mbtype == -100 then--道具，为钱的时候有报错，但不影响
		local itemname = Item.GetData(mubiao1,%道具_名字%) or '空'
		local itemid = Item.GetData(mubiao1,%道具_ID%) or '空'
		local itemtype = Item.GetData(mubiao1,%道具_类型%) or '空'
		--NLG.SystemMessage(player,"类型：道具，名字："..itemname.."，index编号："..mubiao1)
		--NLG.SystemMessage(player,"typeid："..itemtype.."，数量"..mubiao.."，道具id："..itemid)
		local neirong = '@c【查詢面前對象】'
		..'\\n'
		.."\\n類型：道具\\n名字："..itemname.."\\nindex編號："..mubiao1
		.."\\ntypeid："..itemtype.."\\n數量："..mubiao.."\\n道具id："..itemid
		NLG.ShowWindowTalked(player,gmnpc,%窗口_信息框%,18,player+28888,neirong)
	end
end

function chaxun(player)--查询 1=宠物栏 2=道具栏
	local pet = {}
	local petname = {}
	local petenemyid = {}
	local real_enemyid2 = {}
	for i = 0,4 do
		pet[i] = Char.GetPet(player,i)--slot
		if pet[i] == -1 then
			petname[i] = '空'
			petenemyid[i] = '空'
			real_enemyid2[i] = '空'
		else
			petname[i] = Char.GetData(pet[i],%对象_原名%) or '空'
			petenemyid[i] = Char.GetData(pet[i],CONST.PET_PetID) or '空'
			if petenemyid[i] ~= '空' then
				real_enemyid2[i] = ck_enemyid(petenemyid[i])
			else
				real_enemyid2[i] = '空'
			end
		end
	end

	local neirong = '@c【查詢寵物欄】'
	..'\\n\\n'
	..'\\n'
	..'\\n名字：'..petname[0]..'，enemybase編號：'..petenemyid[0]..'，enemy編號：'..real_enemyid2[0]
	..'\\n'
	..'\\n名字：'..petname[1]..'，enemybase編號：'..petenemyid[1]..'，enemy編號：'..real_enemyid2[1]
	..'\\n'
	..'\\n名字：'..petname[2]..'，enemybase編號：'..petenemyid[2]..'，enemy編號：'..real_enemyid2[2]
	..'\\n'
	..'\\n名字：'..petname[3]..'，enemybase編號：'..petenemyid[3]..'，enemy編號：'..real_enemyid2[3]
	..'\\n'
	..'\\n名字：'..petname[4]..'，enemybase編號：'..petenemyid[4]..'，enemy編號：'..real_enemyid2[4]
	NLG.ShowWindowTalked(player,gmnpc,%窗口_巨信息框%,18,player+27888,neirong)
end

--[[
function ahsin_gm_tool_ultraModule:smallblackhouse(player)--小黑屋，登出回城点触发
	local isblocked = tonumber(Field.Get(player,"block")) or 0--小黑屋状态
	if isblocked == 1 then
		local endblockdate = tonumber(Field.Get(player,"blockenddate")) or -1--小黑屋结束日期
		--print("isblocked1："..isblocked)
		if endblockdate < os.time() then
			NLG.SystemMessage(player,"恭喜你服刑期满，禁闭解除刑满释放。")
			--NLG.SystemMessage(gm,"已将"..Char.GetData(player,%对象_名字%).."的禁闭解除。")
			Field.Set(player,"blockenddate",0)
			Field.Set(player,"block",0)
			NLG.UpChar(player)
			return 0
		end
		if endblockdate > os.time() then
			local riqi = os.date("%Y-%m-%d %H:%M:%S",endblockdate)
			Char.DischargeParty(player)
			Char.Warp(player,0,xiaoheiwu,xhwx,xhwy)
			NLG.SystemMessage(player,"你已经被关小黑屋，释放日期："..riqi.."，有问题请联系GM。")
			NLG.UpChar(player)
			return 0
		end
	end
	return 0
end
]]

function ahsin_gm_tool_ultraModule:jinru(player)--小黑屋，登入触发
	local isblocked = tonumber(Field.Get(player,"block")) or 0--小黑屋状态
	if isblocked == 1 then
		local endblockdate = tonumber(Field.Get(player,"blockenddate")) or -1--小黑屋结束日期
		--print("isblocked1："..isblocked)
		if endblockdate < os.time() then
			NLG.SystemMessage(player,"恭喜你服刑期滿，禁閉解除刑滿釋放。")
			--NLG.SystemMessage(gm,"已将"..Char.GetData(player,%对象_名字%).."的禁闭解除。")
			Field.Set(player,"blockenddate",0)
			Field.Set(player,"block",0)
			NLG.UpChar(player)
			return 0
		end
		if endblockdate > os.time() then
			local riqi = os.date("%Y-%m-%d %H:%M:%S",endblockdate)
			Char.DischargeParty(player)
			Char.Warp(player,0,xiaoheiwu,xhwx,xhwy)
			NLG.SystemMessage(player,"你已經被關小黑屋，釋放日期："..riqi.."，有問題請聯系GM。")
			NLG.UpChar(player)
			return 0
		end
	end
	return 0
end

--[[
function ahsin_gm_tool_ultraModule:youjian(fd)--封包玩家行动触发
	local Rplayer = tonumber(Protocol.GetCharByFd(fd))
	local whereme = Char.GetData(Rplayer,%对象_地图%)
	--print("玩家小动作触发了")
	if whereme ~= xiaoheiwu then
		local isblocked = tonumber(Field.Get(Rplayer,"block")) or 0--小黑屋状态
		--print("isblock:"..isblocked)
		if isblocked == 1 then
			local endblockdate = tonumber(Field.Get(Rplayer,"blockenddate")) or -1--小黑屋结束日期
			if endblockdate < os.time() then
				NLG.SystemMessage(Rplayer,"恭喜你服刑期满，禁闭解除刑满释放。")
				Field.Set(Rplayer,"blockenddate",0)
				Field.Set(Rplayer,"block",0)
				NLG.UpChar(Rplayer)
			else
				local riqi = os.date("%Y-%m-%d %H:%M:%S",endblockdate)
				Char.DischargeParty(Rplayer)
				Char.Warp(Rplayer,0,xiaoheiwu,xhwx,xhwy)
				NLG.UpChar(Rplayer)
				NLG.SystemMessage(Rplayer,"您正在被关小黑屋，释放日期："..riqi.."，有问题请联系GM。")
			end
		end
	end
	return 0
end
]]

function ahsin_gm_tool_ultraModule:chuansonghou(player)--传送后触发
	jishi[player] = 2
	--print("计时器1："..jishi[player])
	Char.SetLoopEvent(nil,"jishiqi",player,1000)--call计时器2秒延迟
end

function ahsin_gm_tool_ultraModule:jishiqi(player)--计时器延时判断，解决afterwarp循环fw导致不可用
	if yzmkg == 0 then
		goto xhwpd
	end
	if tonumber(Field.Get(player,"block")) == 1 then
	--if Char.GetData(player,%对象_地图%) == xiaoheiwu then--人还在小黑屋
		--Char.DischargeParty(player)
		--Char.Warp(player,0,xiaoheiwu,xhwx,xhwy)
		goto xhwpd
	end
	if warptimes[player] == nil or warptimes[player] == "" then--传送计数，反挂专用
		warptimes[player] = 1
	elseif warptimes[player] < warpmax then--计数累加
		warptimes[player] = warptimes[player] + 1
	elseif warptimes[player] == warpmax then--次数已满，未验证
		warptimes[player] = warpmax
		Char.SetLoopEvent(nil,"jishiqi",player,7000)--计时器设置未为7秒1次
	end
	--print('传送次数累计：'..warptimes[player])
	if warptimes[player] == warpmax then--次数满
		if bsryzm[player] == false or bsryzm[player] == 0 or bsryzm[player] == nil or bsryzm[player] == "" then--不输入验证码超时计算
			bsryzm[player] = bsryzmcs/5
		end
		bsryzm[player] = bsryzm[player] - 1
		--print('超时：'..bsryzm[player])
		NLG.SystemMessage(player,'請註意：超時不輸入驗證碼、驗證碼多次輸入錯誤，將會被關小黑屋。')
		if bsryzm[player] == 0 then--超时
			Field.Set(player,"block",1)
			Field.Set(player,"blockenddate",(os.time()+3600))
			Char.DischargeParty(player)
			Char.Warp(player,0,xiaoheiwu,xhwx,xhwy)
			NLG.UpChar(player)
			NLG.SystemMessage(player,"由於您長時間未輸入驗證碼超過"..bsryzmcs.."秒，受到關小黑屋1小時處罰。")
			NLG.Say(player,-1,"放棄抵抗，老實交代。坦白從寬，抗拒從嚴。",25)
			NLG.SystemMessage(player,"有問題請聯系GM。")
			warptimes[player] = 0
			jishi[player] = 2
			bsryzm[player] = 0
			Char.SetLoopEvent(nil,"jishiqi",player,0)--计时器归零
			Char.UnsetLoopEvent(player)--卸载计时器
			return
		end
		local yzm1 = math.random(1,10)--第一位
		local yzm2 = math.random(1,10)--第二位
		local yzm3 = math.random(1,10)--干扰组
		local yzm4 = math.random(1,10)--干扰组
		local yzm5 = math.random(1,10)--干扰组
		local yzm6 = math.random(1,10)--干扰组
		yzm[player] = (yzm1-1)..(yzm2-1)--两位连接
		local yzmxx = math.random(1,yzmlie)--验证码匹配1
		local yzmxx2 = math.random(1,yzmlie)--验证码匹配2
		local yzmxx3 = math.random(1,yzmlie)--验证码匹配3--干扰组
		local yzmxx4 = math.random(1,yzmlie)--验证码匹配4--干扰组
		local yzmxx5 = math.random(1,yzmlie)--验证码匹配5--干扰组
		local yzmxx6 = math.random(1,yzmlie)--验证码匹配6--干扰组
		--print('验证码随机数：'..yzmxx..yzmxx2)
		local fhs = math.random(1,10)
		local fuhao = {'↓','↓↓','↓↓↓','↓↓↓↓','↓↓↓↓↓','↓↓↓↓↓↓','↓↓↓↓↓↓↓↓','↓↓↓↓↓↓↓↓','↓↓↓↓↓↓↓↓↓','↓↓↓↓↓↓↓↓↓↓','↓↓↓↓↓↓↓↓↓↓↓'}
		--print('箭头数：'..fhs..'，符号:'..fuhao[fhs])
		--print('验证码：'..yzm[player])
		local yzmmsg = "@c\\n魔力智能反掛系統，"
		.."\\n"
		.."\\n"
		.."\\n--#//'→       "..yzmpp[yzm1][yzmxx]..' .. '..yzmpp[yzm2][yzmxx2].."       ←'//#--"
		.."\\n"
		.."\\n"
		.."\\n請在10秒內，輸入2位驗證碼（純數字）"
		.."\\n"..fuhao[fhs]
		.."\\n"..yzmpp[yzm3][yzmxx3]..' .. '..yzmpp[yzm4][yzmxx4]--干扰组
		.."\\n"..yzmpp[yzm5][yzmxx5]..' .. '..yzmpp[yzm6][yzmxx6]--干扰组
		.."\\n"..yzmpp[yzm3][yzmxx4]..' .. '..yzmpp[yzm5][yzmxx6]--干扰组
		.."\\n"..yzmpp[yzm6][yzmxx5]..' .. '..yzmpp[yzm4][yzmxx3]--干扰组
		NLG.ShowWindowTalked(player,darkroomnpc,%窗口_输入框%,%按钮_是%,player+404404,yzmmsg)
	end
	::xhwpd::
	local whereme = Char.GetData(player,%对象_地图%)
	if whereme == xiaoheiwu then--人还在小黑屋，退出计时器
		Char.SetLoopEvent(nil,"jishiqi",player,0)--计时器归零
		Char.UnsetLoopEvent(player)--卸载计时器
		jishi[player] = 2
		--print("小黑屋判定：地图正确，退出。")
	elseif whereme ~= xiaoheiwu and warptimes[player] ~= warpmax then--人不在小黑屋
		local isblocked = tonumber(Field.Get(player,"block")) or 0--获取禁闭状态
		if isblocked == 1 then--状态为禁闭中
			jishi[player] = jishi[player] - 1--倒计时开始
			--print("计时器2："..jishi[player])
			--print("小黑屋判定：小黑屋禁闭人员。")
			if jishi[player] <= 0 then--倒计时达标
				local endblockdate = tonumber(Field.Get(player,"blockenddate")) or -1--小黑屋结束日期
				if endblockdate < os.time() then--刑期已满，释放
					NLG.SystemMessage(player,"恭喜你服刑期滿，禁閉解除刑滿釋放。")
					Field.Set(player,"blockenddate",0)
					Field.Set(player,"block",0)
					NLG.UpChar(player)
					Char.SetLoopEvent(nil,"jishiqi",player,0)--计时器归零
					Char.UnsetLoopEvent(player)--卸载计时器
					jishi[player] = 2
				else--仍需服刑
					local riqi = os.date("%Y-%m-%d %H:%M:%S",endblockdate)
					Char.DischargeParty(player)
					Char.Warp(player,0,xiaoheiwu,xhwx,xhwy)
					NLG.UpChar(player)
					NLG.SystemMessage(player,"=========================")
					NLG.SystemMessage(player,"您現在正處於小黑屋禁閉期間：")
					NLG.Say(player,-1,"放棄抵抗，老實交代。坦白從寬，抗拒從嚴。",25)
					NLG.SystemMessage(player,"釋放日期："..riqi.."，有問題請聯系GM。")
					Char.SetLoopEvent(nil,"jishiqi",player,0)--计时器归零
					Char.UnsetLoopEvent(player)--卸载计时器
					jishi[player] = 2
				end
			end
		else--状态为非禁闭人员
			--print("计时器3："..jishi[player])
			--print("小黑屋判定：非禁闭人员，退出。")
			Char.SetLoopEvent(nil,"jishiqi",player,0)--计时器归零
			Char.UnsetLoopEvent(player)--卸载计时器
			jishi[player] = 2
		end
--else--意料之外的地图判定，冗余
--	print("计时器4："..jishi[player])
--	print("小黑屋判定：玩家传送后，地图判断出错，强制传送回小黑屋。")
--	Char.DischargeParty(player)
--	Char.Warp(player,0,xiaoheiwu,xhwx,xhwy)
--	Char.SetLoopEvent(nil,"jishiqi",player,0)--计时器归零
--	Char.UnsetLoopEvent(player)--卸载计时器
--	jishi[player] = 2
	end
end

function ahsin_gm_tool_ultraModule:face2npc(dnpc,dplayer,seq,sel,data)--小黑屋管家npc
	local xunxi = "@c\\n年輕人，不好受吧？"
	.."\\n"
	.."\\n上一次我搞事的時候，還是在20年前..."
	.."\\n慢慢熬，好日子總會到頭的..."
	.."\\n隨便逛逛吧，這裡還挺大的..."
	.."\\n"
	.."\\n"
	.."\\n想不想讓我幫你問問典獄長，你什麽時候能出去？"
	NLG.ShowWindowTalked(dplayer,dnpc,%窗口_信息框%,%按钮_是否%,dplayer+29989,xunxi)
end

function ahsin_gm_tool_ultraModule:face2npc2(dnpc,dplayer,seq,sel,data)--小黑屋管家npc查询
	--print("seq:"..seq.." ,sel:"..sel.." data:"..data)
	if seq == dplayer+404404 and tonumber(data) ~= tonumber(yzm[dplayer]) then
		NLG.SystemMessage(dplayer,'驗證碼輸入錯誤，請再次嘗試。')
		if yzmer[dplayer] == false or yzmer[dplayer] == nil or yzmer[dplayer] == "" or yzmer[dplayer] == 0 then
			yzmer[dplayer] = yzmcw
		end
		yzmer[dplayer] = yzmer[dplayer] - 1
		if yzmer[dplayer] == 0 then--验证码错误次数过多
			Field.Set(dplayer,"block",1)
			Field.Set(dplayer,"blockenddate",(os.time()+3600))
			Char.DischargeParty(dplayer)
			Char.Warp(dplayer,0,xiaoheiwu,xhwx,xhwy)
			NLG.UpChar(dplayer)
			NLG.SystemMessage(dplayer,"由於您驗證碼輸入錯誤超過"..yzmcw.."次，受到關小黑屋1小時處罰。")
			NLG.Say(dplayer,-1,"放棄抵抗，老實交代。坦白從寬，抗拒從嚴。",25)
			NLG.SystemMessage(dplayer,"有問題請聯系GM。")
			warptimes[dplayer] = 0
			jishi[dplayer] = 2
			bsryzm[dplayer] = 0
			Char.SetLoopEvent(nil,"jishiqi",dplayer,0)--计时器归零
			Char.UnsetLoopEvent(dplayer)--卸载计时器
		end
	elseif seq == dplayer+404404 and tonumber(data) == tonumber(yzm[dplayer]) then
		NLG.SystemMessage(dplayer,'驗證碼正確，遊玩快樂。')
		warptimes[dplayer] = 0
		jishi[dplayer] = 2
		bsryzm[dplayer] = 0
		Char.SetLoopEvent(nil,"jishiqi",dplayer,0)--计时器归零
		Char.UnsetLoopEvent(dplayer)--卸载计时器
	end
	if seq == dplayer+29989 and sel == 4 then
		local outday = tonumber(Field.Get(dplayer,"blockenddate")) or -1--小黑屋结束日期
		if outday > os.time() then
			outday = os.date("%Y-%m-%d %H:%M:%S",outday)
			local xunxi = "@c\\n【公告欄】"
			.."\\n"
			.."\\n"
			.."\\n"..Char.GetData(dplayer,%对象_名字%)
			.."\\n"
			.."\\n你的刑滿釋放日期為："..outday
			NLG.ShowWindowTalked(dplayer,dnpc,%窗口_信息框%,%按钮_关闭%,dplayer+29789,xunxi)
		else
			Field.Set(dplayer,"blockenddate",0)
			Field.Set(dplayer,"block",0)
			NLG.UpChar(dplayer)
			local xunxi = "@c\\n【公告欄】"
			.."\\n"
			.."\\n"..Char.GetData(dplayer,%对象_名字%)
			.."\\n"
			.."\\n你已經刑滿釋放，隨時可以離開。"
			.."\\n"
			.."\\n歡迎再來！"
			NLG.ShowWindowTalked(dplayer,dnpc,%窗口_信息框%,%按钮_关闭%,dplayer+29789,xunxi)
		end
	end
end

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
--K佬分享的：62进制转换工具
--版本：20240813
--本lua必须运行在m佬的新框架下
--首发论坛 www.cnmlb.com 获取最新版本

--由于功能比较丰富，免费分享归免费。过来b站点个赞、一键三连不过分吧？
--https://space.bilibili.com/21127109
--qq群：85199642

--本lua只支持cgmsv+新框架，不然100%跑不起来
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

local num62Tbl={
'0','1','2','3','4','5','6','7','8','9',
'a','b','c','d','e','f','g','h','i','j',
'k','l','m','n','o','p','q','r','s','t',
'u','v','w','x','y','z','A','B','C','D',
'E','F','G','H','I','J','K','L','M','N',
'O','P','Q','R','S','T','U','V','W','X',
'Y','Z',
}

--将十进制数值转换为62进制
--@param num integer @十进制数值
--@return string num62 @62进制字符串
function from10to62(num)
	if num == nil then
	return nil
	end

	num = tonumber(num)
	local num62 =''
	while num > 0 do
		local remainder = math.qy(num,62)
		num62 = num62Tbl[remainder+1]..num62
		num = math.qs(num,62)
	end
	return num62
end

--将62进制字符串转为十进制数值
--@param num62 string @62进制字符串
--@return integer num @十进制数值
function from62to10(num62)
	if num62 == nil then
		return nil
	end
	local num = 0
	num62 = tostring(num62)
	local len = #num62
	for i= 1,len do
		local key = num62:sub(i,i)
		local idx=-1
		for j=1,#num62Tbl do
			if num62Tbl[j] == key then
				idx = j
				break
			end
		end
		num = num * 62 + idx - 1
	end
	return num
end

--取余运算
--@param a integer @被除数
--@param b integer @除数
--@return integer @余数
function math.qy(a,b)
	return a - math.floor(a / b) * b
end

--取商运算
--@param a integer @被除数
--@param b integer @除数
--@return integer @商
function math.qs(a,b)
	return math.floor(a /b)
end

--卸载模块钩子
function ahsin_gm_tool_ultraModule:onUnload()
	self:logInfo('unload')
end

return ahsin_gm_tool_ultraModule

