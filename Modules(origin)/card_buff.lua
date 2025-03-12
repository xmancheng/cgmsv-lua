-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
--ahsin做的：图鉴收集buff系统
--版本：20241107
--本lua必须运行在m佬的新框架下
--首发论坛 www.cnmlb.com 获取最新版本

--由于功能比较丰富，免费分享归免费。过来b站点个赞、一键三连不过分吧？
--https://space.bilibili.com/21127109
--qq群：85199642

--本lua只支持cgmsv+新框架，不然100%跑不起来
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

--模块类
local card_buffModule = ModuleBase:createModule('card_buff')

--加载模块钩子
function card_buffModule:onLoad()
	self:logInfo('load')
	card_npc = self:NPC_createNormal('圖鑒管家',14592,{x=225,y=83,mapType=0,map=1000,direction=4})--图鉴buff npc
	self:NPC_regTalkedEvent(card_npc,Func.bind(self.face2npc,self))--面向npc触发
	self:NPC_regWindowTalkedEvent(card_npc,Func.bind(self.window_select,self))--npc窗口按钮触发
	self:regCallback('LoginEvent',Func.bind(self.login,self))--登入时触发
	self:regCallback('AfterCalcCharaStatusEvent',Func.bind(self.onStatusUpdate,self))--刷新临时属性
	--[[self:regCallback('StatusCalcEvent', function(charIndex)
		if Char.IsPlayer(charIndex) then
			--print(charIndex)
		end
	end)]]
end

--★★★推荐只作用到album1~album9，10开始玩家走路变卡，不要用★★★
local buff_use_for = 1--1=buff直接作用于人，2=buff玩家自主选择作用于道具
-------------------------------------------------------------------以下buff_use_for = 2时才有效
local ispay = 1--是否需要付钱
local cost = 500000--价格，魔币、道具币都是这个
local payment = 1--币种，1=魔币，2=道具币
local payitem = 70001--如果收道具币，道具id
local payitemname = '钻'--自定义收费道具名称
local buff_item_type = 22--自定义可注入buff的道具类型，22为水晶
local buff_item_name = '水晶'--自定义注入道具的类型名
--------------------------------------------------------------------以上buff_use_for = 2时才有效
local on = '√'--可diy
local off = '未開放 ×'--可diy
local can_buff = {}--储存激活的buff
local itempages = {}--道具选择页数
local pages = {}--图鉴查看页数
local add_buff = {}--获取buff增益效果
local cards = {}--图鉴缓存
local buff_item_index = {}--index缓存
local buffs = {--指定图鉴32*9album获取buff名
--buffs[i][1]=buff参数
--buffs[i][2]=buff文字介绍，最多17字节（中文占用3字节、符号英文占用1）
--buffs[i][3]=图鉴文字介绍
--血|魔|攻|防|敏|必|反|命|闪|毒|睡|石|醉|乱|忘|精神|魔攻|魔抗|回复
{'0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0','抗石+1','  1.虎人'},
{'0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0','抗毒+1','  2.貓妖'},
{'0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0','抗睡+1','  3.羅刹'},
{'0|0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0','抗醉+1','  4.貓人'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0','抗忘+1','  5.惡魔貓'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0','抗亂+1','  6.妖狐'},
{'0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0','反擊+1','  7.穴熊'},
{'0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0|0','必殺+1','  8.赤熊'},
{'0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0','命中+1','  9.北極熊'},
{'0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0','閃躲+1',' 10.赤目黑熊'},
{'0|0|0|0|0|3|3|3|3|0|0|0|0|0|0|0|0|0|0','全修正+3',' 11.貓熊'},
{'0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0','抗石+1',' 12.大地鼠'},
{'0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0','抗睡+1',' 13.惡夢鼠'},
{'0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0','抗毒+1',' 14.火焰鼠'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0','抗亂+1',' 15.寶石鼠'},
{'0|0|0|0|0|0|0|0|0|0|2|2|0|0|0|0|0|0|0','抗石+2.抗睡+2',' 16.水藍鼠'},
{'0|0|0|0|0|0|0|0|0|2|0|0|0|2|0|0|0|0|0','抗亂+2.抗毒+2',' 17.鼠王'},
{'0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0|0','必殺+1',' 18.地獄看門犬'},
{'0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0','反擊+1',' 19.巨狼'},
{'0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0','命中+1',' 20.地獄獵犬'},
{'0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0','閃躲+1',' 21.地獄妖犬'},
{'0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0|0','必殺+1',' 22.僵屍'},
{'0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0','反擊+1',' 23.喪屍'},
{'0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0','閃躲+1',' 24.食屍鬼'},
{'0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0','命中+1',' 25.腐屍'},
{'0|0|0|0|0|0|1|1|0|0|0|0|0|0|0|0|0|0|0','反擊+1.命中+1',' 26.木乃伊'},
{'0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0','命中+1',' 27.骷髏戰士'},
{'0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0|0','必殺+1',' 28.血骷髏'},
{'0|0|0|0|0|1|0|1|0|0|0|0|0|0|0|0|0|0|0','必殺+1.命中+1',' 29.地獄骷髏'},
{'0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0','閃躲+1',' 30.武裝骷髏'},
{'0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0','反擊+1',' 31.骷髏海盗'},
{'0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0|0','必殺+1',' 32.幽靈'},
{'0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0','反擊+1',' 33.鬼靈'},
{'0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0','命中+1',' 34.亡靈'},
{'0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0','閃躲+1',' 35.死靈'},
{'0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0','抗毒+1',' 36.小石像怪'},
{'0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0','抗睡+1',' 37.使魔'},
{'0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0','抗石+1',' 38.水藍鳥魔'},
{'0|0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0','抗醉+1',' 39.小惡魔'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0','抗亂+1',' 40.迷你石像怪'},
{'0|0|0|0|0|0|0|0|0|3|3|3|3|3|3|0|0|0|0','全抗性+3',' 41.丘比特'},
{'0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0','閃躲+1',' 42.石像怪'},
{'0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0','命中+1',' 43.血魔'},
{'0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0','反擊+1',' 44.墮天使'},
{'0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0|0','必殺+1',' 45.惡魔'},
{'0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0','抗睡+1',' 46.小蝙蝠'},
{'0|0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0','抗醉+1',' 47.掃把蝙蝠'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0','抗忘+1',' 48.迷你蝙蝠'},
{'0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0','抗石+1',' 49.水果蝙蝠'},
{'0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0','抗毒+1',' 50.惡魔蝙蝠'},
{'0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0','抗石+1',' 51.天使蝙蝠'},
{'0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0','命中+1',' 52.大蝙蝠'},
{'0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0','閃躲+1',' 53.巨蝙蝠'},
{'0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0','反擊+1',' 54.海蝙蝠'},
{'0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0|0','必殺+1',' 55.胖蝙蝠'},
{'0|0|0|0|0|1|0|0|1|0|0|0|0|0|0|0|0|0|0','必殺+1.閃躲+1',' 56.兔耳蝙蝠'},
{'0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0','反擊+1',' 57.藍蠍'},
{'0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0','命中+1',' 58.紅蠍'},
{'0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0|0','必殺+1',' 59.黃蠍'},
{'0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0','閃躲+1',' 60.殺手蠍'},
{'0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0|0','必殺+1',' 61.殺人蜂'},
{'0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0','命中+1',' 62.異型蜂'},
{'0|0|0|0|0|0|5|0|0|0|0|0|0|0|0|0|0|0|0','反擊+5',' 63.虎頭蜂'},
{'0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0|0','必殺+1',' 64.黃蜂'},
{'0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0','閃躲+1',' 65.死亡蜂'},
{'0|0|0|0|0|0|0|3|0|0|0|0|0|0|0|0|0|0|0','命中+3',' 66.螳螂'},
{'0|0|0|0|0|2|0|0|0|0|0|0|0|0|0|0|0|0|0','必殺+2',' 67.殺人螳螂'},
{'0|0|0|0|0|2|0|0|0|0|0|0|0|0|0|0|0|0|0','必殺+2',' 68.赤目螳螂'},
{'0|0|0|0|0|0|0|0|3|0|0|0|0|0|0|0|0|0|0','閃躲+3',' 69.死灰螳螂'},
{'0|0|0|0|0|0|0|3|0|0|0|0|0|0|0|0|0|0|0','命中+3',' 70.致命螳螂'},
{'0|0|0|0|0|0|2|0|0|0|0|0|0|0|0|0|0|0|0','反擊+2',' 71.土蜘蛛'},
{'0|0|0|0|0|0|2|0|0|0|0|0|0|0|0|0|0|0|0','反擊+2',' 72.水蜘蛛'},
{'0|0|0|0|0|0|2|0|0|0|0|0|0|0|0|0|0|0|0','反擊+2',' 73.火蜘蛛'},
{'0|0|0|0|0|0|2|0|0|0|0|0|0|0|0|0|0|0|0','反擊+2',' 74.風蜘蛛'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0','抗亂+1',' 75.樹精'},
{'0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0','抗睡+1',' 76.死亡樹精'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0','抗忘+1',' 77.黃金樹精'},
{'0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0','抗石+1',' 78.慘白樹精'},
{'0|0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0','抗醉+1',' 79.冰冷樹精'},
{'0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0','抗毒+1',' 80.沼澤樹精'},
{'0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0','反擊+1',' 81.妖草'},
{'0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0|0','必殺+1',' 82.蔓陀羅草'},
{'0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0','閃躲+1',' 83.妖花'},
{'0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0','命中+1',' 84.人魔草'},
{'0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0','抗毒+1',' 85.綠色口臭鬼'},
{'0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0','抗睡+1',' 86.黃色口臭鬼'},
{'0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0','抗石+1',' 87.藍色口臭鬼'},
{'0|0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0','抗醉+1',' 88.紅色口臭鬼'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0','抗亂+1',' 89.兇暴仙人掌'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0','抗忘+1',' 90.武術仙人掌'},
{'0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0','抗石+1',' 91.兔耳仙人掌'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0','抗亂+1',' 92.印地安仙人掌'},
{'0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0','抗睡+1',' 93.火焰舞者'},
{'0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0','閃躲+1',' 94.史萊姆'},
{'0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0','反擊+1',' 95.液態史萊姆'},
{'0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0|0','必殺+1',' 96.果凍史萊姆'},
{'0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0','命中+1',' 97.布丁史萊姆'},
{'0|0|0|0|0|10|0|0|0|0|0|0|0|0|0|0|0|0|0','必殺+10',' 98.火精'},
{'0|0|0|0|0|0|0|0|10|0|0|0|0|0|0|0|0|0|0','閃躲+10',' 99.風精'},
{'0|0|0|0|0|0|0|10|0|0|0|0|0|0|0|0|0|0|0','命中+10','100.水精'},
{'0|0|0|0|0|0|10|0|0|0|0|0|0|0|0|0|0|0|0','反擊+10','101.地精'},
{'0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0|0','必殺+1','102.頑皮炸彈'},
{'0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0','命中+1','103.寶貝炸彈'},
{'0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0','反擊+1','104.大炸彈'},
{'0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0','閃躲+1','105.飄浮炸彈'},
{'0|0|0|0|0|3|3|3|3|0|0|0|0|0|0|0|0|0|0','全修正+3','106.丸子炸彈'},
{'0|0|0|0|0|5|0|0|0|0|0|0|0|0|0|0|0|0|0','必殺+5','107.幻影'},
{'0|0|0|0|0|0|5|0|0|0|0|0|0|0|0|0|0|0|0','反擊+5','108.旋律影子'},
{'0|0|0|0|0|0|0|5|0|0|0|0|0|0|0|0|0|0|0','命中+5','109.闇影'},
{'0|0|0|0|0|0|0|0|5|0|0|0|0|0|0|0|0|0|0','閃躲+5','110.陰影'},
{'0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0','閃躲+1','111.血腥之刃'},
{'0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0|0','必殺+1','112.殺龍之刃'},
{'0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0','命中+1','113.火焰之刃'},
{'0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0','反擊+1','114.烈風之刃'},
{'0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0','抗睡+1','115.嚇人箱'},
{'0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0','抗毒+1','116.兔耳嚇人箱'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0','抗亂+1','117.紅魔嚇人箱'},
{'0|0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0','抗醉+1','118.藍魔嚇人箱'},
{'0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0','抗石+1','119.綠蛙嚇人箱'},
{'0|0|0|0|0|0|0|0|0|3|3|3|3|3|3|0|0|0|0','全抗性+3','120.純白嚇人箱'},
{'0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0','反擊+1','121.冰怪'},
{'0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0|0','必殺+1','122.石怪'},
{'0|0|0|0|0|5|0|5|0|0|0|0|0|0|0|0|0|0|0','必殺+5.命中+5','123.銀怪'},
{'0|0|0|0|0|5|0|0|5|0|0|0|0|0|0|0|0|0|0','必殺+5.閃躲+5','124.金怪'},
{'0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0','閃躲+1','125.惡魔螃蟹'},
{'0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0','反擊+1','126.水晶螃蟹'},
{'0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0','命中+1','127.鐵剪螃蟹'},
{'0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0|0','必殺+1','128.黃金螃蟹'},
{'0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0','閃躲+1','129.蜥蜴戰士'},
{'0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0','命中+1','130.蜥蜴鬥士'},
{'0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0|0','必殺+1','131.蜥蜴武士'},
{'0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0','反擊+1','132.獵豹蜥蜴'},
{'0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0','命中+1','133.大地翼龍'},
{'0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0|0','必殺+1','134.寒冰翼龍'},
{'0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0','反擊+1','135.火焰翼龍'},
{'0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0','閃躲+1','136.烈風翼龍'},
{'0|0|0|0|0|2|0|0|2|0|0|0|0|0|0|0|0|0|0','必殺+2.閃躲+2','137.翼龍'},
{'0|0|0|0|0|0|0|3|0|0|0|0|0|0|0|0|0|0|0','命中+3','138.地龍蜥'},
{'0|0|0|0|0|0|3|0|0|0|0|0|0|0|0|0|0|0|0','反擊+3','139.水龍蜥'},
{'0|0|0|0|0|3|0|0|0|0|0|0|0|0|0|0|0|0|0','必殺+3','140.火龍蜥'},
{'0|0|0|0|0|0|0|0|3|0|0|0|0|0|0|0|0|0|0','閃躲+3','141.風龍蜥'},
{'0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0','命中+1','142.哥布林'},
{'0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0|0','必殺+1','143.紅帽哥布林'},
{'0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0','閃躲+1','144.火焰哥布林'},
{'0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0','反擊+1','145.烈風哥布林'},
{'0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0','閃躲+1','146.巨人'},
{'0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0','反擊+1','147.單眼巨人'},
{'0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0|0','必殺+1','148.泰坦巨人'},
{'0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0','命中+1','149.亞特拉斯巨神'},
{'0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0','抗毒+1','150.盜贼'},
{'0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0|0','抗石+1','151.山贼'},
{'0|0|0|0|0|0|0|0|0|0|0|0|1|0|0|0|0|0|0','抗醉+1','152.海盗'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|5|0|0|0|0','抗忘+5','153.破壞狂'},
{'0|0|0|0|0|1|0|0|0|1|0|0|0|0|0|0|0|0|0','必殺+1.抗毒+1','154.鳥人'},
{'0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|0|0','必殺+1.抗石+1','155.幻歌妖'},
{'0|0|0|0|0|1|0|0|0|0|0|0|1|0|0|0|0|0|0','必殺+1.抗醉+1','156.狠毒鳥人'},
{'0|0|0|0|0|1|0|0|0|0|0|0|0|1|0|0|0|0|0','必殺+1.抗亂+1','157.烈風鳥人'},
{'0|0|0|0|0|1|0|0|0|0|0|0|0|0|1|0|0|0|0','必殺+1.抗忘+1','158.黑暗鳥人'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'159.山飛甲'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'160.獨角獸'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'161.天馬'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'162.麒麟'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'163.地底龜'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'164.海底龜'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'165.火焰龜'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'166.硬殼龜'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'167.鐮刀魔'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'168.僧侶僵屍'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'169.斬首者'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'170.冥界死神'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'171.牙骨'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'172.顎牙'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'173.巨牙'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'174.利牙'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'175.格利芬'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'176.變種格利芬'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'177.奔雷獸'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'178.依格羅斯'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'179.托羅帝鳥'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'180.岩地跑者'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'181.火焰啄木鳥'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'182.狂奔鳥'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'183.甲蟲'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'184.掘地蟲'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'185.鍬型蟲'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'186.獨角仙'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'187.翠綠菇'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'188.水藍菇'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'189.粉紅菇'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'190.星菇'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'191.綠煙'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'192.煙霧'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'193.煙羅'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'194.棉球'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'195.盾'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'196.潛盾'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'197.強盾'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'198.神盾'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'199.岩怪'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'200.爆岩'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'201.熔岩'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'202.影岩'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'203.希德拉'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'204.米茲奇'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'205.亞斯普'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'206.歐洛奇'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'207.口袋龍'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'208.迷你龍'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'209.雛龍'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'210.穴龍'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'211.大型半獸人'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'212.豬鬼'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'213.鋼鬼'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'214.半獸人'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'215.陸行鯊'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'216.沙地鯊'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'217.丘陵鯊'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'218.岩石鯊'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'219.雛鳥'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'220.鴨嘴獸'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'221.小鴨子'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'222.小兔子'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'223.蛋白石怪'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'224.紅寶石怪'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'225.岩蟲'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'226.水晶怪'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'227.刀雞'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'228.劍鴕鳥'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'229.大刀鴯苗'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'230.刀鋒阿姆鳥'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'231.火蜥蜴'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'232.毒蜥蜴'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'233.冰蜥蜴'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'234.金屬蜥蜴'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'235.戴靴怪'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'236.舞靴怪'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'237.潛靴怪'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'238.咚咚靴怪'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'239.大公雞'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'240.耶誕帽怪'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'241.鑽石怪'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'242.達斯公雞'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'243.銀獅'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'244.黃銅'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'245.鐵獅'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'246.紅銅'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'247.跳跳地雷'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'248.碎碎地雷'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'249.皮皮地雷'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'250.薩普地雷'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'251.龍骨'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'252.暗黑龍骨'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'253.黃金龍骨'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'254.毒龍骨'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'255.走路花妖'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'256.跑步花妖'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'257.舞蹈花妖'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'258.侯爵花妖'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'259.魟怪'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'260.羅亨魟怪'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'261.拉劄魟怪'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'262.拉賈魟怪'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'263.烏贼怪'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'264.亭登烏贼'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'265.賽修烏贼'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'266.西比亞烏贼'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'267.魔術機甲'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'268.魔術機乙'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'269.魔術機丙'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'270.魔術機丁'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'271.羅修'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'272.羅查'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'273.修美亞雷'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'274.維爾斯'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'275.獅面女神'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'276.貓臉女神'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'277.貓隊長'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'278.福爾菲斯'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'279.板龍'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'280.棱背龍'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'281.籃尾龍'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'282.潛地龍'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'283.布卡'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'284.寄生布卡'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'285.樹精布卡'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'286.妖化布卡'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'287.布卡四重奏'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'288.陣'},
--Char.GetData(player,CONST.ALBUM10)，开始失灵，后面没用了
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'289.连'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'290.军'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'291.玫瑰粉怪'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'292.牛奶粉怪'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'293.葡萄酒粉怪'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'294.马卡来粉怪'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'295.鲁帕斯'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'296.第七星阿尔多拉'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'297.大犬座'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'298.马优尔'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'299.魔法师之鬼'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'300.德鲁依之鬼'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'301.红鬼'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'302.巫师之鬼'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'303.尤拉蝙蝠'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'304.欧比尔蝙蝠'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'305.韦伯蝙蝠'},
{'0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0',on,'306.欧图蝙蝠'},
--以此类推
}

function card_buffModule:face2npc(npc,player)--面向npc触发
	buff_item_index[player] = {}
	pages[player] = 1
	cards_window(player,npc,pages[player])
end

function card_buffModule:window_select(npc,player,seq,sel,data)--npc窗口按钮触发
	--print('seq:'..seq..' ,sel:'..sel..' data:'..data)
	seq = tonumber(seq)
	sel = tonumber(sel)
	data = tonumber(data)
	for i = 1,8 do
		if seq == 50 and data - 1 == i then--选择道具
			local which = tonumber(i + (8 * itempages[player]))
			local itemindex = buff_item_index[player][which]
			--print('player,which',player,which)
			--print('itemindex：',buff_item_index[player][which])
			setitem(player,npc,itemindex)--开始操作
			return
		end
	end
	if seq == 2 and sel == 32 then--下一页
		pages[player] = pages[player] + 1
		cards_window(player,npc,pages[player])
	elseif seq == 2 and sel == 16 then--上一页
		pages[player] = pages[player] - 1
		cards_window(player,npc,pages[player])
	elseif seq == 2 and sel == 1 then--准备注入buff到道具，选择页
		itempages[player] = 0
		select_item(player,npc,itempages[player])
	elseif seq == 50 and sel == 32 then--准备注入buff到道具，选择页，下一页
		itempages[player] = itempages[player] + 1
		select_item(player,npc,itempages[player])
	elseif seq == 50 and sel == 16 then--准备注入buff到道具，选择页，上一页
		itempages[player] = itempages[player] - 1
		select_item(player,npc,itempages[player])
	elseif seq == 404 and sel == 16 then--准备注入buff到道具，选择页，上一页
		cards_window(player,npc,pages[player])
	end
	return
end

function select_item(player,npc,page)--选择道具
	local itemindex = {}
	local itemname = {}
	local itemtype = {}
	local tongji = {}
	tongji[player] = 0
	local maxbag = Char.GetData(player,CONST.对象_道具栏)
	local neirong = ''
	if payment == 1 then--魔币
		neirong = neirong .. '1@c\\n【请选择'..buff_item_name..'，收费'..cost..'魔币】\\n'
	else--道具币
		neirong = neirong .. '1@c\\n【请选择'..buff_item_name..'，收费'..cost..payitemname..'】\\n'
	end
	local neirong2 = ''
	local text = {}
	for i = 8,maxbag-1 do
		itemindex[i] = Char.GetItemIndex(player,i)
		if itemindex[i] > 0 then
			itemname[i] = Item.GetData(itemindex[i],%道具_名字%) or '无'
			itemtype[i] = Item.GetData(itemindex[i],%道具_类型%) or '无'
		else
			itemname[i] = -1
			itemtype[i] = -1
		end
		if itemtype[i] == buff_item_type then--道具符合
			tongji[player] = tongji[player] + 1
			local wz = i - 7
			local bb = '背包1'
			if wz > 60 then
				bb = '背包4'
			elseif wz > 40 then
				bb = '背包3'
			elseif wz > 20 then
				bb = '背包2'
			end
			local which = tonumber(tongji[player])
			buff_item_index[player][which] = itemindex[i]
			--print('buff_item_index[player]'..which,buff_item_index[player][which])
			--print('player',player)
			text[which] = '\\n'
			text[which] = text[which] .. bb ..'|位置'..wz..'：'..itemname[i]
			neirong2 = neirong2 .. text[which]
			--print('text'..which..' = '..text[which])
		end
	end
	if neirong2 == '' then--道具全部不符合
		neirong = neirong .. '\\n\\n\\n@c背包中没有找到可注入的'..buff_item_name
		NLG.ShowWindowTalked(player,npc,%窗口_信息框%,18,404,neirong)
		return
	end
	local realpage = math.ceil(tongji[player] / 8)
	--page = page + 1
	--print('realpage = '..realpage..'   page = '..page)
	--print('统计个数 = '..tongji[player])
	if realpage == page + 1  and page + 1 > 1 then--最后一页
		--print('这里1')
		for i = 1,8 do
			local nowpage = tonumber((8 * page) + i)
			if text[nowpage] then
				neirong = neirong .. text[nowpage]
			end
		end
		NLG.ShowWindowTalked(player,npc,%窗口_选择框%,18,50,neirong)
		return
	elseif realpage == page + 1 then--只有一页
		neirong = neirong .. neirong2
		NLG.ShowWindowTalked(player,npc,%窗口_选择框%,2,50,neirong)
		return
	elseif page + 1 < realpage and page + 1 == 1 then--第一页，有翻页
		neirong = neirong .. neirong2
		NLG.ShowWindowTalked(player,npc,%窗口_选择框%,34,50,neirong)
		return
	elseif page + 1 < realpage then--中间页
		for i = 1,8 do
			local nowpage = tonumber((8 * page) + i)
			neirong = neirong .. text[nowpage]
		end
		NLG.ShowWindowTalked(player,npc,%窗口_选择框%,50,50,neirong)
		return
	end
end

function cards_window(player,npc,page)--图鉴展示窗
	local p = {0,32,64,96,128,160,192,224,256,288}
	local buffadd = nil
	card_status(player)--获取图鉴状态
	--buffs[i][1]=buff参数
	--buffs[i][2]=buff文字介绍，最多17字节（中文占用3字节、符号英文占用1）
	--buffs[i][3]=图鉴文字介绍
	--血|魔|攻|防|敏|必|反|命|闪|毒|睡|石|醉|乱|忘|精神|魔攻|魔抗|回复
	local xue,mo,gong,fang,min,bi,fan,ming,shan,du,shui,shi,zui,luan,wang,jingshen,mogong,mokang,huifu = statuslook(player)--buff总合查看
	local xunxi = '　　　　　　　　　　【圖鑒收藏庫 - 全覽】'
	..'\\n$4已累計啟動之素質能力：$0'
	..'\\n$1生命$5'..xue..'$1 魔力$5'..mo..'$1 攻擊$5'..gong..'$1 防禦$5'..fang..'$1 敏捷$5'..min..'$8 必$5'..bi..'$8 反$5'..fan..'$8 命$5'..ming..'$8 閃$5'..shan
	..'\\n$2毒$5'..du..'$2 睡$5'..shui..'$2 石$5'..shi..'$2 醉$5'..zui..'$2 亂$5'..luan..'$2 忘$5'..wang..'$1 恢復$5'..huifu..'$1 精神$5'..jingshen..'$8 魔攻$5'..mogong..'$8 魔抗$5'..mokang

	for i = 1,16 do
		local nowpage = p[page]
		xunxi = xunxi .. '\\n'..left(buffs[i+nowpage][3],16)..left(cards[player][i+nowpage],17)..left(buffs[i+16+nowpage][3],16)..left(cards[player][i+16+nowpage],17)
	end

	xunxi = xunxi ..'\\n\\n                        $4< 第 '..pages[player]..'/9 頁>$0'
	if pages[player] == 1 then
		--xunxi = xunxi .. '\\n\\n            ▼▼▼ 点击【$4确 定$0】 开始注入 $1buff$0 到 '..buff_item_name
		--NLG.ShowWindowTalked(player,npc,%窗口_巨信息框%,35,2,xunxi)
		NLG.ShowWindowTalked(player,npc,%窗口_巨信息框%,34,2,xunxi)
	elseif pages[player] == 9 then
		--xunxi = xunxi .. '\\n\\n            ▼▼▼ 点击【$4确 定$0】 开始注入 $1buff$0 到 '..buff_item_name
		--NLG.ShowWindowTalked(player,npc,%窗口_巨信息框%,19,2,xunxi)
		NLG.ShowWindowTalked(player,npc,%窗口_巨信息框%,18,2,xunxi)
	else
		--xunxi = xunxi .. '\\n\\n         ▼▼▼ 点击【$4确 定$0】 开始注入 $1buff$0 到 '..buff_item_name
		--NLG.ShowWindowTalked(player,npc,%窗口_巨信息框%,51,2,xunxi)
		NLG.ShowWindowTalked(player,npc,%窗口_巨信息框%,50,2,xunxi)
	end
end

function setitem(player,npc,itemindex)--写入道具
	local itemname = Item.GetData(itemindex,CONST.道具_名字)
	if Item.GetData(itemindex,CONST.道具_自用参数) == 'card_buffed' then
		NLG.ShowWindowTalked(player,npc,%窗口_信息框%,1,999,'@c【图鉴管家】\\n\\n\\n'..itemname..' 已经注入过buff了，不可二次注入。')
		return
	end
	if ispay == 1 then
		if payment == 1 then--魔币
			if Char.GetData(player,CONST.对象_金币) < cost then
				NLG.ShowWindowTalked(player,npc,%窗口_信息框%,1,444,'@c【图鉴管家】\\n\\n\\n穷逼，你的钱不够。')
				return
			else
				--Char.AddGold(player,-cost)
				Char.SetData(player,CONST.对象_金币,Char.GetData(player,CONST.对象_金币)-cost)
			end
		else--道具币
			if Char.ItemNum(player,payitem) < cost then
				NLG.ShowWindowTalked(player,npc,%窗口_信息框%,1,444,'@c【图鉴管家】\\n\\n\\n穷逼，你的'..payitemname..'不够。')
				return
			else
				Char.DelItem(player,payitem,cost)
			end
		end
	end
	local xue,mo,gong,fang,min,bi,fan,ming,shan,du,shui,shi,zui,luan,wang,jingshen,mogong,mokang,havebuff = statuslook(player)--buff总合查看
	if havebuff then
		Item.SetData(itemindex,CONST.道具_生命,Item.GetData(itemindex,CONST.道具_生命)+xue)
		Item.SetData(itemindex,CONST.道具_魔力,Item.GetData(itemindex,CONST.道具_魔力)+mo)
		Item.SetData(itemindex,CONST.道具_攻击,Item.GetData(itemindex,CONST.道具_攻击)+gong)
		Item.SetData(itemindex,CONST.道具_防御,Item.GetData(itemindex,CONST.道具_防御)+fang)
		Item.SetData(itemindex,CONST.道具_敏捷,Item.GetData(itemindex,CONST.道具_敏捷)+min)
		Item.SetData(itemindex,CONST.道具_必杀,Item.GetData(itemindex,CONST.道具_必杀)+bi)
		Item.SetData(itemindex,CONST.道具_反击,Item.GetData(itemindex,CONST.道具_反击)+fan)
		Item.SetData(itemindex,CONST.道具_命中,Item.GetData(itemindex,CONST.道具_命中)+ming)
		Item.SetData(itemindex,CONST.道具_闪躲,Item.GetData(itemindex,CONST.道具_闪躲)+shan)
		Item.SetData(itemindex,CONST.道具_毒抗,Item.GetData(itemindex,CONST.道具_毒抗)+du)
		Item.SetData(itemindex,CONST.道具_睡抗,Item.GetData(itemindex,CONST.道具_睡抗)+shui)
		Item.SetData(itemindex,CONST.道具_石抗,Item.GetData(itemindex,CONST.道具_石抗)+shi)
		Item.SetData(itemindex,CONST.道具_醉抗,Item.GetData(itemindex,CONST.道具_醉抗)+zui)
		Item.SetData(itemindex,CONST.道具_乱抗,Item.GetData(itemindex,CONST.道具_乱抗)+luan)
		Item.SetData(itemindex,CONST.道具_忘抗,Item.GetData(itemindex,CONST.道具_忘抗)+wang)
		Item.SetData(itemindex,CONST.道具_精神,Item.GetData(itemindex,CONST.道具_精神)+jingshen)
		Item.SetData(itemindex,CONST.道具_魔攻,Item.GetData(itemindex,CONST.道具_魔攻)+mogong)
		Item.SetData(itemindex,CONST.道具_魔抗,Item.GetData(itemindex,CONST.道具_魔抗)+mokang)
		Item.SetData(itemindex,CONST.道具_回复,Item.GetData(itemindex,CONST.道具_回复)+huifu)
	end
	Item.SetData(itemindex,CONST.道具_自用参数,'card_buffed')
	Item.SetData(itemindex,CONST.道具_丢地消失,1)--丢地消失
	Item.SetData(itemindex,CONST.道具_宠邮,0)--不可交易
	NLG.PlaySe(player,283,0,0)
	Item.UpItem(player,-1)
	Char.UpCharStatus(player)
	Char.SaveToDb(player)
	local xunxi = '@c【图鉴管家】'
	..'\\n'
	..'\\n图鉴 $4buff$0 属性，叠加注入到'..itemname..'成功。'
	..'\\n'
	..'\\n$1本次总写入buff为（不显示装备自身原来属性）：$0'
	..left('\\n血$2'..xue..'$0 魔$2'..mo..'$0 攻$2'..gong..'$0 防$2'..fang..'$0 敏$2'..min,60)
	..left('\\n必$2'..bi..'$0 反$2'..fan..'$0 命$2'..ming..'$0 闪$2'..shan,60)
	..left('\\n毒$2'..du..'$0 睡$2'..shui..'$0 石$2'..shi..'$0 醉$2'..zui..'$0 乱$2'..luan..'$0 忘$2'..wang,60)
	..left('\\n精$2'..jingshen..'$0 魔攻$2'..mogong..'$0 魔抗$2'..mokang..'$0 回复$2'..huifu,60)
	NLG.ShowWindowTalked(player,npc,%窗口_信息框%,1,999,xunxi)
	NLG.SystemMessage(player,itemname..'好像获得了一股神秘得力量。')
	return
end

function statuslook(player)--buff总合查看
--buffs[i][1]=buff参数
--buffs[i][2]=buff文字介绍，最多17字节（中文占用3字节、符号英文占用1）
--buffs[i][3]=图鉴文字介绍
--血|魔|攻|防|敏|必|反|命|闪|毒|睡|石|醉|乱|忘|精神|魔攻|魔抗|回复
	add_buff[player] = {}
	local xue = 0
	local mo = 0
	local gong = 0
	local fang = 0
	local min = 0
	local bi = 0
	local fan = 0
	local ming = 0
	local shan = 0
	local du = 0
	local shui = 0
	local shi = 0
	local zui = 0
	local luan = 0
	local wang = 0
	local jingshen = 0
	local mogong = 0
	local mokang = 0
	local huifu = 0
	for i = 1,288 do
		if buffs[i][1] ~= '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0' and can_buff[player][i] == 1 then--获取buff增益效果
			add_buff[player][i] = split(buffs[i][1],'|')
			xue = xue + add_buff[player][i][1]
			mo = mo + add_buff[player][i][2]
			gong = gong + add_buff[player][i][3]
			fang = fang + add_buff[player][i][4]
			min = min + add_buff[player][i][5]
			bi = bi + add_buff[player][i][6]
			fan = fan + add_buff[player][i][7]
			ming = ming + add_buff[player][i][8]
			shan = shan + add_buff[player][i][9]
			du = du + add_buff[player][i][10]
			shui = shui + add_buff[player][i][11]
			shi = shi + add_buff[player][i][12]
			zui = zui + add_buff[player][i][13]
			luan = luan + add_buff[player][i][14]
			wang = wang + add_buff[player][i][15]
			jingshen = jingshen + add_buff[player][i][16]
			mogong = mogong + add_buff[player][i][17]
			mokang = mokang + add_buff[player][i][18]
			huifu = huifu + add_buff[player][i][19]
		end
	end
	if xue+mo+gong+fang+min+bi+fan+ming+shan+du+shui+shi+zui+luan+wang+jingshen+mogong+mokang+huifu == 0 then--一顿操作猛如虎，结果图鉴没buff
		return xue,mo,gong,fang,min,bi,fan,ming,shan,du,shui,shi,zui,luan,wang,jingshen,mogong,mokang,huifu,false
	else--有buff
		return xue,mo,gong,fang,min,bi,fan,ming,shan,du,shui,shi,zui,luan,wang,jingshen,mogong,mokang,huifu,true
	end
end

function card_status(player)--get图鉴
	local card = {
	Char.GetData(player,CONST.ALBUM1),Char.GetData(player,CONST.ALBUM2),Char.GetData(player,CONST.ALBUM3),Char.GetData(player,CONST.ALBUM4),
	Char.GetData(player,CONST.ALBUM5),Char.GetData(player,CONST.ALBUM6),Char.GetData(player,CONST.ALBUM7),Char.GetData(player,CONST.ALBUM8),
	Char.GetData(player,CONST.ALBUM9)}
	local page = {0,32,64,96,128,160,192,224,256,288}
	cards[player] = {}
	can_buff[player] = {}
	--buffs[i][1]=buff参数
	--buffs[i][2]=buff文字介绍，最多17字节（中文占用3字节、符号英文占用1）
	--buffs[i][3]=图鉴文字介绍
	--血|魔|攻|防|敏|必|反|命|闪|毒|睡|石|醉|乱|忘|精神|魔攻|魔抗
	for ab = 1,9 do
		card[ab] = to32bin(card[ab])
		for i = 1,32 do
			local nowpage = tonumber(i+page[ab])
			--print('nowpage = '..nowpage)
			if get1(card[ab],i) then
				--print('图鉴 '..i..' 有了')--报告指定第几位数字是1
				cards[player][nowpage] = '$5'..buffs[nowpage][2]..'$0'
				can_buff[player][nowpage] = 1
			else
				if buffs[nowpage][2] ~= on then
					cards[player][nowpage] = '$7'..buffs[nowpage][2]..'$0'
				else
					cards[player][nowpage] = '$9'..off..'$0'
				end
				can_buff[player][nowpage] = 0
			end
			--print('can buff page '..nowpage..' = '..can_buff[player][nowpage])
			--print(nowpage,cards[player][nowpage])
		end
	end
end

function to32bin(num)--魔力图鉴专用32位二进制换算
	local card32 = -2147483648--第32张图鉴
	local bin = ''--二进制数
	if num < 0 then--开了32张以及其它
		num = num - card32 * 2--+math.abs(card32)
	elseif num == -1 then--图鉴已全开
		return '11111111111111111111111111111111'
	end
	while num > 0 do
		bin = tostring(num % 2) .. bin--取余数并拼接到二进制数的前面
		num = math.floor(num / 2)--整除2
	end
	--print('明文：'..bin)
	--string反转开始
	local str_num = tostring(bin)
	local reversed_str = ''
	for i = 1, #str_num do
		reversed_str = string.sub(str_num, i, i) .. reversed_str
	end
	local reversed_num = tostring(reversed_str)
	--print('反转：'..reversed_num)
	--print('长度：'..#reversed_num)
	return reversed_num
end

function get1(number,n)--魔力图鉴专用找1在第几位
    local str = tostring(number)
    local len = string.len(str)
    if n <= 0 or n > len then
        --error('位置超出数字范围')
		return false
    end
    local digitChar = string.sub(str, n, n)
	if tonumber(digitChar) == 0 then
		return false
	else
		--return tostring(digitChar)
		return true
	end
end
----------------------------------------------------
function card_buffModule:login(player)--登入触发
	if buff_use_for == 1 then
		give_buff(player)
	end
	return 0
end

local Allow = {--别动，改完爆炸
[CONST.对象_最大血] = CONST.对象_最大血,
[CONST.对象_最大魔] = CONST.对象_最大魔,
[CONST.对象_攻击力] = CONST.对象_攻击力,
[CONST.对象_防御力] = CONST.对象_防御力,
[CONST.对象_敏捷] = CONST.对象_敏捷,
[CONST.对象_精神] = CONST.对象_精神,
[CONST.对象_回复] = CONST.对象_回复,
[CONST.对象_魔攻] = CONST.对象_魔攻,
[CONST.对象_魔抗] = CONST.对象_魔抗,
[CONST.对象_实际反击] = CONST.对象_实际反击,
[CONST.对象_实际必杀] = CONST.对象_实际必杀,
[CONST.对象_实际命中] = CONST.对象_实际命中,
[CONST.对象_实际闪躲] = CONST.对象_实际闪躲,
[CONST.对象_实际抗毒] = CONST.对象_实际抗毒,
[CONST.对象_实际抗乱] = CONST.对象_实际抗乱,
[CONST.对象_实际抗忘] = CONST.对象_实际抗忘,
[CONST.对象_实际抗睡] = CONST.对象_实际抗睡,
[CONST.对象_实际抗石] = CONST.对象_实际抗石,
[CONST.对象_实际抗醉] = CONST.对象_实际抗醉,
[CONST.对象_反击] = CONST.对象_实际反击,
[CONST.对象_必杀] = CONST.对象_实际必杀,
[CONST.对象_命中] = CONST.对象_实际命中,
[CONST.对象_闪躲] = CONST.对象_实际闪躲,
[CONST.对象_抗毒] = CONST.对象_实际抗毒,
[CONST.对象_抗乱] = CONST.对象_实际抗乱,
[CONST.对象_抗忘] = CONST.对象_实际抗忘,
[CONST.对象_抗睡] = CONST.对象_实际抗睡,
[CONST.对象_抗石] = CONST.对象_实际抗石,
[CONST.对象_抗醉] = CONST.对象_实际抗醉,
}

function addCharStatus(charIndex,t,val)--增加临时属性
	t = Allow[t]
	if (t == nil) then
		return false
	end
	Char.SetTempData(charIndex,'CSE_card_buff:Enable', 1)
	Char.SetTempData(charIndex,"CSE_card_buff:" .. t, tonumber(val))
	if (t == CONST.对象_最大血 or t == CONST.对象_最大魔) then
		Char.SetTempData(charIndex,"CSE_card_buff:L" .. t,Char.GetData(charIndex,t))
	end
	return true
end

function clearCharStatus(charIndex)--移除临时属性
	Char.SetTempData(charIndex,'CSE_card_buff:Enable', nil)
	for i, v in pairs(Allow) do
		Char.SetTempData(charIndex,'CSE_card_buff:' .. v,nil)
		if (tonumber(v) == CONST.对象_最大血 or tonumber(v) == CONST.对象_最大魔) then
			Char.SetTempData(charIndex,"CSE_card_buff:L" .. v,nil)
		end
	end
end

function card_buffModule:onStatusUpdate(charIndex)--刷新临时属性
	if (Char.GetTempData(charIndex,"CSE_card_buff:Enable") == 1) then
		local t = {CONST.对象_攻击力,CONST.对象_防御力,CONST.对象_敏捷,CONST.对象_精神,CONST.对象_回复,
		CONST.对象_实际反击,CONST.对象_实际必杀,CONST.对象_实际命中,CONST.对象_实际闪躲,
		CONST.对象_实际抗毒,CONST.对象_实际抗乱,CONST.对象_实际抗忘,CONST.对象_实际抗睡,
		CONST.对象_实际抗石,CONST.对象_实际抗醉}
		for i, v in ipairs(t) do
			local vx = tonumber(Char.GetTempData(charIndex,"CSE_card_buff:" .. v)) or 0
			if (vx ~= 0 and vx ~= nil) then
				Char.SetData(charIndex,v,Char.GetData(charIndex,v) + vx)
			end
		end
		if (Char.GetData(charIndex,CONST.CHAR_类型) == CONST.对象类型_人) then
			local t3 = {CONST.对象_魔攻,CONST.对象_魔抗}
			for i, v in ipairs(t3) do
				local vx = tonumber(Char.GetTempData(charIndex,"CSE_card_buff:" .. v)) or 0
				if (vx ~= 0 and vx ~= nil) then
					Char.SetData(charIndex,v,Char.GetData(charIndex,v) + vx)
				end
			end
		end
		local t2 = {{CONST.对象_最大血,CONST.对象_血},{CONST.对象_最大魔,CONST.对象_魔}}
		for i, v in ipairs(t2) do
			local vx = tonumber(Char.GetTempData(charIndex,"CSE_card_buff:" .. v[1])) or 0
			if (vx ~= 0 and vx ~= nil) then
				local vxL = tonumber(Char.GetTempData(charIndex,"CSE_card_buff:L" .. v[1])) or -1
				Char.SetTempData(charIndex,"CSE_card_buff:L" .. v[1], nil)
				local vo = Char.GetData(charIndex,v[1])
				local full = vo == Char.GetData(charIndex,v[2]) and vo == vxL
				Char.SetData(charIndex,v[1],vo + vx)
				if full then
					Char.SetData(charIndex,v[2],vo + vx)
				end
			end
		end
	end
end

function give_buff(player)--赋予玩家buff
	if Char.IsDummy(player) then
		return
	end
	if Char.IsPlayer(player) then
		card_status(player)
		local xue,mo,gong,fang,min,bi,fan,ming,shan,du,shui,shi,zui,luan,wang,jingshen,mogong,mokang,huifu,havebuff = statuslook(player)--buff总合查看
		if havebuff then
			clearCharStatus(player)--清空temp缓存
			clearCharStatus(player)--清空temp缓存
			addCharStatus(player,CONST.对象_最大血,xue)
			addCharStatus(player,CONST.对象_最大魔,mo)
			addCharStatus(player,CONST.对象_攻击力,gong)
			addCharStatus(player,CONST.对象_防御力,fang)
			addCharStatus(player,CONST.对象_敏捷,min)
			addCharStatus(player,CONST.对象_必杀,bi)
			addCharStatus(player,CONST.对象_反击,fan)
			addCharStatus(player,CONST.对象_命中,ming)
			addCharStatus(player,CONST.对象_闪躲,shan)
			addCharStatus(player,CONST.对象_抗毒,du)
			addCharStatus(player,CONST.对象_抗睡,shui)
			addCharStatus(player,CONST.对象_抗石,shi)
			addCharStatus(player,CONST.对象_抗醉,zui)
			addCharStatus(player,CONST.对象_抗乱,luan)
			addCharStatus(player,CONST.对象_抗忘,wang)
			addCharStatus(player,CONST.对象_精神,jingshen)
			addCharStatus(player,CONST.对象_魔攻,mogong)
			addCharStatus(player,CONST.对象_魔抗,mokang)
			addCharStatus(player,CONST.对象_回复,huifu)
			NLG.UpChar(player)
			Char.UpCharStatus(player)
			--NLG.SystemMessage(player,'图鉴收集 buff 已激活。')
		end
	end
end
----------------------------------------------------
function left(str,len)--居左
    local char = ' ' -- 填充空格
	if len-#str >= 0 then
		local padding = string.rep(char,len-#str)
		return str..padding
	else
		local text = '$4<太长请修改>$0'
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
function card_buffModule:onUnload()
	self:logInfo('unload')
end

return card_buffModule
