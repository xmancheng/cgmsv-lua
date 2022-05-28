# cgmsv-lua
cgmsv lua Module/Modules

適用cgmsv_21.2a之Lua

舊框架 (原始cgmsv_21.2a自帶) 的Module

新框架 (https://github.com/Muscipular/cgmsv-lua) 的Modules

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


## 新框架Modules
模組加載代碼 | 說明 
--- | --- 
loadModule('uniShop')|鏡像擺攤
loadModule('autoRanking')|自助天梯
loadModule('ybNenSkill')|寵物被動、傭兵技能強化
loadModule('specialSkill')|人物種族[特異能力、技能強化]
loadModule('magicSkill')|魔法屬性技能、刀背攻擊、狀態增傷
