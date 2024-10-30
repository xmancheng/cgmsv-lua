# cgmsv-lua
cgmsv lua Module/Modules

適用cgmsv_24.10e/cgmsv_21.2a/cgmsv_24.2b之Lua
(越新的Lua，引擎可能也須跟著升級更新)

◎舊框架 (原始cgmsv自帶) 的Module

◎新框架 (https://github.com/Muscipular/cgmsv-lua) 的v0.3.0 Modules

◎新框架 (https://github.com/Muscipular/cgmsv-lua) 的v0.3.1 Modules

模組加載皆在ModuleConfig.lua操作

## 舊框架Module
### 功能擴增
模組加載代碼 | 說明 
--- | --- 
useModule('LoginRewards');|登入獎勵系統
useModule('AutoRecovery');|戰鬥自動恢復&自動整理背包&天使祝福
useModule('Makeover');|角色變裝系統
useModule('RecordPoint');|座標紀錄系統
useModule('Subsidy');|製造補貼系統
useModule('ItemUse');|戰鬥暫時增益道具


### 寵物相關
模組加載代碼 | 說明 
--- | --- 
useModule('AllExpEvent');|寵物學習裝置&經驗加倍券
useModule('PetTalk');|寵物說話互動(X)
useModule('getpetBp');|寵物算檔
useModule('PetAttrib');|寵物洗檔
useModule('PetMirage');|寵物變身&超靈體in水晶
useModule('PetMchange');|寵物附身合體
useModule('PetConvert');|寵物改造
useModule('PetMutation');|寵物異變
useModule('PetTechLetter');|寵物技能卷
useModule('PetLevelUpEvent');|寵物技能升級
useModule('ModularPet');|自定義寵物(X)
useModule('PetBreeding');|寵物配種
useModule('PetBerry');|寵物樹果


### 裝備相關
模組加載代碼 | 說明 
--- | --- 
useModule('Blacksmiths');|精煉強化
useModule('Craftsman');|濃縮精煉
useModule('EquipCard');|裝備插卡
useModule('AccessoriesCube');|淺能方塊
useModule('ShadowWeapon');|影子武器
useModule('StarPower');|星力水晶
useModule('card');|卡片加成

### 副本相關
模組加載代碼 | 說明 
--- | --- 
useModule('WildBoss');|野外挑戰
useModule('ActivityScript');|活動副本
useModule('BravadoScript');|單人挑戰
useModule('DailyScript');|曜日副本
useModule('RankingScript');|頭目挑戰(X)


## 新框架Modules
### 未完善
模組加載代碼 | 說明 
--- | --- 
loadModule('uniShop')|鏡像擺攤(未完善)
loadModule('autoRanking')|自助天梯(未完善)(X)
### 職業成就相關
模組加載代碼 | 說明 
--- | --- 
loadModule('achieveGoal')|技能成就系統
loadModule('achieveMagician')|大魔導師之路
loadModule('achieveAres')|狂勇戰神成就
loadModule('achieveElfRanger')|精靈遊俠成就
loadModule('achieveShadow')|暗夜幻影成就
loadModule('achieveTitanAsura')|泰坦修羅成就
loadModule('setupBattleEX')|狂勇戰神增強補正
### 傷害相關
模組加載代碼 | 說明 
--- | --- 
loadModule('ybPetSkill')|寵物性格、覺醒、被動、傷害調整、傭兵技能強化
loadModule('specialSkill')|人物種族特異能力、人物種族技能強化(X)
loadModule('attackSkill')|七大罪技能、手下留情、大師武器、法術附加狀態、合擊增傷
loadModule('powerLinked')|新版本人物增減傷(P)
loadModule('setupMagicAttr')|魔法屬性技能(X)
loadModule('disguiseSpell')|變形咒語增傷、攻魔無效果
loadModule('playerSkill')|人物增益技能(Origin)
loadModule('petSkill')|寵物被動與增益(Origin)
### 傭兵相關
模組加載代碼 | 說明 
--- | --- 
loadModule('hbSummonLuac')|一鍵召喚鏡像寵物夥伴
loadModule('hbReinforceLuac')|動作技能卡、經驗儲存物品
loadModule('autoBattle')|鏡像寵物夥伴自動戰鬥
loadModule('pokeSummonLuac')|寶可夢夥伴、自動戰鬥(P)
### 野外相關
模組加載代碼 | 說明 
--- | --- 
loadModule('itemThrow')|投擲擊殺式抓寵
loadModule('encountEX')|滿怪香水
loadModule('setupGetProfit')|限制獲取
loadModule('bossField')|魔物增強
loadModule('legendBoss')|傳說霸主(P)
loadModule('palParade')|野外遭遇(P)
loadModule('setupItemBox')|迷宮寶箱(P)
loadModule('sealZone')|封印新系統(Origin)
### 寵物強化相關
模組加載代碼 | 說明 
--- | --- 
loadModule('petHeadIcon')|0檔寵物特效
loadModule('petPalHelp')|帕魯幫助
loadModule('petEvolution')|寵物覺醒(寵裝強化)
loadModule('randPetAbility')|野怪BP覺醒(P)
loadModule('techMachine')|寵物招式機
loadModule('petRush')|練寵懸賞(P)
loadModule('petMega')|寵物超級進化(P)
loadModule('petEmpower')|寵物持有賦能(P)
loadModule('petMaster')|寵物星級超量(Origin)
loadModule('convertPlans')|寵物異變改造(Origin)
### 裝備強化相關
模組加載代碼 | 說明 
--- | --- 
loadModule('strAddEffect')|強化效果、附念效果、影子效果
loadModule('setupItemType')|副武器擴充
loadModule('addTK')|副武器附念
loadModule('sprayPaint')|噴漆鍍膜
loadModule('incDurable')|魂魄保養
loadModule('Strengthen')|魔力賦予
loadModule('StrengthShop')|魔法卷軸倉庫
loadModule('ghostHunter')|獵鬼強化(P)
loadModule('equipSlot')|裝備插槽(Origin)
### 特殊副本
模組加載代碼 | 說明 
--- | --- 
loadModule('battleMirrorDevil')|水鏡惡魔
loadModule('deathJJC')|死亡競技
loadModule('huntingZone')|狩獵地帶
loadModule('mazeWorld')|裏空間區域
loadModule('mazeBoss')|裏空間王戰(X)
loadModule('mazeBoss1')|裏空間1王戰(~7)
loadModule('mazeHorcrux')|裏空間魂器
loadModule('worldBoss')|世界強敵
loadModule('taskWarp')|每日副本(P)
loadModule('demonSlayer')|無限城鬼滅(P)
loadModule('pokeGym')|寶可夢道館戰(P)
### 其他功能
模組加載代碼 | 說明 
--- | --- 
loadModule('quickUI')|動作快捷
loadModule('manaPool')|自設血魔池
loadModule('petHatching')|飼育小屋
loadModule('matchDraw')|抽獎背包
loadModule('petHeadIcon')|寵物頭飾
loadModule('easyPet')|簡易寵物
loadModule('ichibanKuji')|一番賞抽獎
loadModule('monOven')|炙燒烤爐
loadModule('mysteryShop')|神秘商店
loadModule('trashCan')|垃圾處理
loadModule('skillSheet')|人物技能秘笈(P)
loadModule('imageMachine')|寵物形象轉換機(P)
loadModule('featuresLuac')|寵物相關道具(P)
loadModule('pokeHatching')|寶可夢蛋(P)
loadModule('swapPet')|寶可夢交換(P)
loadModule('uniqueSkills')|角色獨特技能(Origin)
loadModule('SigninSheet')|每日簽到(Origin)

