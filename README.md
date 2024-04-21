# cgmsv-lua
cgmsv lua Module/Modules

適用cgmsv_21.2a/cgmsv_24.2b之Lua

舊框架 (原始cgmsv自帶) 的Module

新框架 (https://github.com/Muscipular/cgmsv-lua) 的v0.3.0 Modules

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
useModule('PetTalk');|寵物說話互動
useModule('getpetBp');|寵物算檔
useModule('PetAttrib');|寵物洗檔
useModule('PetMirage');|寵物變身&超靈體in水晶
useModule('PetMchange');|寵物附身合體
useModule('PetConvert');|寵物改造
useModule('PetMutation');|寵物異變
useModule('PetTechLetter');|寵物技能卷
useModule('PetLevelUpEvent');|寵物技能升級
useModule('ModularPet');|自定義寵物
useModule('PetBreeding');|寵物配種
useModule('PetBerry');|寵物樹果


### 裝備相關
模組加載代碼 | 說明 
--- | --- 
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
useModule('RankingScript');|頭目挑戰


## 新框架Modules
### 未完善
模組加載代碼 | 說明 
--- | --- 
loadModule('uniShop')|鏡像擺攤(未完善)
loadModule('autoRanking')|自助天梯(未完善)
### 傷害相關
模組加載代碼 | 說明 
--- | --- 
loadModule('ybPetSkill')|寵物被動技能、寵物魔法傷害調整、傭兵技能強化
loadModule('specialSkill')|人物種族特異能力、人物種族技能強化
loadModule('attackSkill')|七大罪特殊技能、手下留情、法術附加狀態、合擊增傷
loadModule('setupMagicAttr')|魔法屬性技能
loadModule('disguiseSpell')|變形咒語增傷、攻魔無效果
### 傭兵相關
模組加載代碼 | 說明 
--- | --- 
loadModule('hbSummonLuac')|一鍵召喚鏡像寵物夥伴
loadModule('hbReinforceLuac')|動作技能卡、經驗儲存物品
loadModule('autoBattle')|鏡像寵物夥伴自動戰鬥
### 野外相關
模組加載代碼 | 說明 
--- | --- 
loadModule('itemThrow')|投擲擊殺式抓寵
loadModule('encountEX')|滿怪香水
### 裝備強化相關
模組加載代碼 | 說明 
--- | --- 
loadModule('strAddEffect')|強化效果、附念效果、影子效果
loadModule('setupItemType')|副武器擴充
loadModule('addTK')|副武器附念
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
### 其他功能
模組加載代碼 | 說明 
--- | --- 
loadModule('quickUI')|動作快捷
loadModule('petHatching')|飼育小屋
loadModule('matchDraw')|抽獎背包
loadModule('petHeadIcon')|寵物頭飾
loadModule('easyPet')|簡易寵物

