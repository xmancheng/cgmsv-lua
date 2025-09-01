---模块类
local Module = ModuleBase:createModule(evolutionPlans)

--分类自行添加
local evolution_plan_name = {};
local evolution_plan_offering = {};
local evolution_plan_item = {};
local evolution_plan_gold = {};
local evolution_plan_pet = {};
local evolution_plan_requirement = {};
local evolution_plan_tech = {};
--
evolution_plan_name[1] = "《進化》火恐龍";
evolution_plan_offering[1] = 406198;
evolution_plan_item[1] = 74095;
evolution_plan_gold[1] = 5000;
evolution_plan_pet[1] = 406199;
evolution_plan_requirement[1] = {{CONST.对象_等级,50}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[1] = 310007;

evolution_plan_name[2] = "《進化》噴火龍";
evolution_plan_offering[2] = 406199;
evolution_plan_item[2] = 74096;
evolution_plan_gold[2] = 15000;
evolution_plan_pet[2] = 406200;
evolution_plan_requirement[2] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[2] = 310008;

evolution_plan_name[3] = "《進化》超級噴火龍X";
evolution_plan_offering[3] = 406200;
evolution_plan_item[3] = 74097;
evolution_plan_gold[3] = 50000;
evolution_plan_pet[3] = 406201;
evolution_plan_requirement[3] = {{CONST.对象_等级,100}, {CONST.对象_死亡数,20}, {CONST.对象_伤害数,500}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[3] = 310005;

evolution_plan_name[4] = "《進化》超級噴火龍Y";
evolution_plan_offering[4] = 406200;
evolution_plan_item[4] = 74097;
evolution_plan_gold[4] = 50000;
evolution_plan_pet[4] = 406202;
evolution_plan_requirement[4] = {{CONST.对象_等级,100}, {CONST.对象_死亡数,10}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[4] = 310008;

evolution_plan_name[5] = "《進化》妙蛙草";
evolution_plan_offering[5] = 406203;
evolution_plan_item[5] = 74095;
evolution_plan_gold[5] = 5000;
evolution_plan_pet[5] = 406204;
evolution_plan_requirement[5] = {{CONST.对象_等级,50}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[5] = 310107;

evolution_plan_name[6] = "《進化》妙蛙花";
evolution_plan_offering[6] = 406204;
evolution_plan_item[6] = 74096;
evolution_plan_gold[6] = 15000;
evolution_plan_pet[6] = 406205;
evolution_plan_requirement[6] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[6] = 310108;

evolution_plan_name[7] = "《進化》超級妙蛙花";
evolution_plan_offering[7] = 406205;
evolution_plan_item[7] = 74097;
evolution_plan_gold[7] = 50000;
evolution_plan_pet[7] = 406206;
evolution_plan_requirement[7] = {{CONST.对象_等级,100}, {CONST.对象_死亡数,10}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[7] = 310105;

evolution_plan_name[8] = "《進化》卡咪龜";
evolution_plan_offering[8] = 406207;
evolution_plan_item[8] = 74095;
evolution_plan_gold[8] = 5000;
evolution_plan_pet[8] = 406208;
evolution_plan_requirement[8] = {{CONST.对象_等级,50}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[8] = 310101;

evolution_plan_name[9] = "《進化》水箭龜";
evolution_plan_offering[9] = 406208;
evolution_plan_item[9] = 74096;
evolution_plan_gold[9] = 15000;
evolution_plan_pet[9] = 406209;
evolution_plan_requirement[9] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[9] = 310102;

evolution_plan_name[10] = "《進化》超級水箭龜";
evolution_plan_offering[10] = 406209;
evolution_plan_item[10] = 74097;
evolution_plan_gold[10] = 50000;
evolution_plan_pet[10] = 406210;
evolution_plan_requirement[10] = {{CONST.对象_等级,100}, {CONST.对象_死亡数,10}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[10] = 310105;

evolution_plan_name[11] = "《進化》皮卡丘";
evolution_plan_offering[11] = 406211;
evolution_plan_item[11] = 74095;
evolution_plan_gold[11] = 5000;
evolution_plan_pet[11] = 406212;
evolution_plan_requirement[11] = {{CONST.对象_等级,50}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[11] = 310109;

evolution_plan_name[12] = "《進化》雷丘";
evolution_plan_offering[12] = 406212;
evolution_plan_item[12] = 74096;
evolution_plan_gold[12] = 15000;
evolution_plan_pet[12] = 406213;
evolution_plan_requirement[12] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[12] = 310010;

evolution_plan_name[13] = "《進化》進擊雷丘";
evolution_plan_offering[13] = 406213;
evolution_plan_item[13] = 74097;
evolution_plan_gold[13] = 50000;
evolution_plan_pet[13] = 406214;
evolution_plan_requirement[13] = {{CONST.对象_等级,100}, {CONST.对象_死亡数,10}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[13] = 310011;

evolution_plan_name[14] = "《進化》鬼斯通";
evolution_plan_offering[14] = 406216;
evolution_plan_item[14] = 74095;
evolution_plan_gold[14] = 5000;
evolution_plan_pet[14] = 406217;
evolution_plan_requirement[14] = {{CONST.对象_等级,50}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[14] = 310101;

evolution_plan_name[15] = "《進化》耿鬼";
evolution_plan_offering[15] = 406217;
evolution_plan_item[15] = 74096;
evolution_plan_gold[15] = 15000;
evolution_plan_pet[15] = 406218;
evolution_plan_requirement[15] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[15] = 310102;

evolution_plan_name[16] = "《進化》超級耿鬼";
evolution_plan_offering[16] = 406218;
evolution_plan_item[16] = 74097;
evolution_plan_gold[16] = 50000;
evolution_plan_pet[16] = 406219;
evolution_plan_requirement[16] = {{CONST.对象_等级,100}, {CONST.对象_死亡数,20}, {CONST.对象_伤害数,500}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[16] = 310005;

evolution_plan_name[17] = "《進化》巴大蝶";
evolution_plan_offering[17] = 406220;
evolution_plan_item[17] = 74096;
evolution_plan_gold[17] = 15000;
evolution_plan_pet[17] = 406221;
evolution_plan_requirement[17] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[17] = 310107;

evolution_plan_name[18] = "《進化》進擊喵老大";
evolution_plan_offering[18] = 406222;
evolution_plan_item[18] = 74096;
evolution_plan_gold[18] = 15000;
evolution_plan_pet[18] = 406223;
evolution_plan_requirement[18] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[18] = 310110;

evolution_plan_name[19] = "《進化》卡比獸";
evolution_plan_offering[19] = 406224;
evolution_plan_item[19] = 74096;
evolution_plan_gold[19] = 15000;
evolution_plan_pet[19] = 406225;
evolution_plan_requirement[19] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[19] = 310001;

evolution_plan_name[20] = "《進化》胖丁";
evolution_plan_offering[20] = 406229;
evolution_plan_item[20] = 74095;
evolution_plan_gold[20] = 5000;
evolution_plan_pet[20] = 406230;
evolution_plan_requirement[20] = {{CONST.对象_等级,50}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[20] = 310101;

evolution_plan_name[21] = "《進化》胖可丁";
evolution_plan_offering[21] = 406230;
evolution_plan_item[21] = 74096;
evolution_plan_gold[21] = 15000;
evolution_plan_pet[21] = 406231;
evolution_plan_requirement[21] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[21] = 310102;

evolution_plan_name[22] = "《進化》鴨嘴火獸";
evolution_plan_offering[22] = 406232;
evolution_plan_item[22] = 74095;
evolution_plan_gold[22] = 5000;
evolution_plan_pet[22] = 406233;
evolution_plan_requirement[22] = {{CONST.对象_等级,50}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[22] = 310007;

evolution_plan_name[23] = "《進化》鴨嘴炎獸";
evolution_plan_offering[23] = 406233;
evolution_plan_item[23] = 74096;
evolution_plan_gold[23] = 15000;
evolution_plan_pet[23] = 406234;
evolution_plan_requirement[23] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[23] = 310008;

evolution_plan_name[24] = "《進化》鴨嘴擊獸";
evolution_plan_offering[24] = 406234;
evolution_plan_item[24] = 74097;
evolution_plan_gold[24] = 50000;
evolution_plan_pet[24] = 406235;
evolution_plan_requirement[24] = {{CONST.对象_等级,100}, {CONST.对象_死亡数,20}, {CONST.对象_伤害数,500}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[24] = 310005;

evolution_plan_name[25] = "《進化》猛火猴";
evolution_plan_offering[25] = 406236;
evolution_plan_item[25] = 74095;
evolution_plan_gold[25] = 5000;
evolution_plan_pet[25] = 406237;
evolution_plan_requirement[25] = {{CONST.对象_等级,50}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[25] = 310007;

evolution_plan_name[26] = "《進化》烈焰猴";
evolution_plan_offering[26] = 406237;
evolution_plan_item[26] = 74096;
evolution_plan_gold[26] = 15000;
evolution_plan_pet[26] = 406238;
evolution_plan_requirement[26] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[26] = 310008;

evolution_plan_name[27] = "《進化》進擊烈焰猴";
evolution_plan_offering[27] = 406238;
evolution_plan_item[27] = 74097;
evolution_plan_gold[27] = 50000;
evolution_plan_pet[27] = 406239;
evolution_plan_requirement[27] = {{CONST.对象_等级,100}, {CONST.对象_死亡数,20}, {CONST.对象_伤害数,500}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[27] = 310005;

evolution_plan_name[28] = "《進化》森林蜥蜴";
evolution_plan_offering[28] = 406240;
evolution_plan_item[28] = 74095;
evolution_plan_gold[28] = 5000;
evolution_plan_pet[28] = 406241;
evolution_plan_requirement[28] = {{CONST.对象_等级,50}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[28] = 310107;

evolution_plan_name[29] = "《進化》蜥蜴王";
evolution_plan_offering[29] = 406241;
evolution_plan_item[29] = 74096;
evolution_plan_gold[29] = 15000;
evolution_plan_pet[29] = 406242;
evolution_plan_requirement[29] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[29] = 310108;

evolution_plan_name[30] = "《進化》超級蜥蜴王";
evolution_plan_offering[30] = 406242;
evolution_plan_item[30] = 74097;
evolution_plan_gold[30] = 50000;
evolution_plan_pet[30] = 406243;
evolution_plan_requirement[30] = {{CONST.对象_等级,100}, {CONST.对象_死亡数,10}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[30] = 310105;

evolution_plan_name[31] = "《進化》呱頭蛙";
evolution_plan_offering[31] = 406244;
evolution_plan_item[31] = 74095;
evolution_plan_gold[31] = 5000;
evolution_plan_pet[31] = 406245;
evolution_plan_requirement[31] = {{CONST.对象_等级,50}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[31] = 310101;

evolution_plan_name[32] = "《進化》甲賀忍蛙";
evolution_plan_offering[32] = 406245;
evolution_plan_item[32] = 74096;
evolution_plan_gold[32] = 15000;
evolution_plan_pet[32] = 406246;
evolution_plan_requirement[32] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[32] = 310102;

evolution_plan_name[33] = "《進化》羈絆甲賀忍蛙";
evolution_plan_offering[33] = 406246;
evolution_plan_item[33] = 74097;
evolution_plan_gold[33] = 50000;
evolution_plan_pet[33] = 406247;
evolution_plan_requirement[33] = {{CONST.对象_等级,100}, {CONST.对象_死亡数,10}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[33] = 310105;

evolution_plan_name[34] = "《進化》哈克龍";
evolution_plan_offering[34] = 406261;
evolution_plan_item[34] = 74095;
evolution_plan_gold[34] = 5000;
evolution_plan_pet[34] = 406262;
evolution_plan_requirement[34] = {{CONST.对象_等级,50}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[34] = 310001;

evolution_plan_name[35] = "《進化》快龍";
evolution_plan_offering[35] = 406262;
evolution_plan_item[35] = 74096;
evolution_plan_gold[35] = 15000;
evolution_plan_pet[35] = 406263;
evolution_plan_requirement[35] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[35] = 310002;

evolution_plan_name[36] = "《進化》進擊快龍";
evolution_plan_offering[36] = 406263;
evolution_plan_item[36] = 74097;
evolution_plan_gold[36] = 50000;
evolution_plan_pet[36] = 406264;
evolution_plan_requirement[36] = {{CONST.对象_等级,100}, {CONST.对象_死亡数,10}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[36] = 310005;

evolution_plan_name[37] = "《進化》阿柏怪";
evolution_plan_offering[37] = 406268;
evolution_plan_item[37] = 74095;
evolution_plan_gold[37] = 5000;
evolution_plan_pet[37] = 406269;
evolution_plan_requirement[37] = {{CONST.对象_等级,50}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[37] = 310001;

evolution_plan_name[38] = "《進化》進擊阿柏怪";
evolution_plan_offering[38] = 406269;
evolution_plan_item[38] = 74096;
evolution_plan_gold[38] = 15000;
evolution_plan_pet[38] = 406270;
evolution_plan_requirement[38] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[38] = 310002;

evolution_plan_name[39] = "《進化》雙彈瓦斯";
evolution_plan_offering[39] = 406271;
evolution_plan_item[39] = 74095;
evolution_plan_gold[39] = 5000;
evolution_plan_pet[39] = 406272;
evolution_plan_requirement[39] = {{CONST.对象_等级,50}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[39] = 310101;

evolution_plan_name[40] = "《進化》進擊雙彈瓦斯";
evolution_plan_offering[40] = 406272;
evolution_plan_item[40] = 74096;
evolution_plan_gold[40] = 15000;
evolution_plan_pet[40] = 406273;
evolution_plan_requirement[40] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[40] = 310102;

evolution_plan_name[41] = "《進化》大嘴蝠";
evolution_plan_offering[41] = 406274;
evolution_plan_item[41] = 74095;
evolution_plan_gold[41] = 5000;
evolution_plan_pet[41] = 406275;
evolution_plan_requirement[41] = {{CONST.对象_等级,50}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[41] = 310107;

evolution_plan_name[42] = "《進化》叉字蝠";
evolution_plan_offering[42] = 406275;
evolution_plan_item[42] = 74096;
evolution_plan_gold[42] = 15000;
evolution_plan_pet[42] = 406276;
evolution_plan_requirement[42] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[42] = 310108;

evolution_plan_name[43] = "《進化》鑽角犀獸";
evolution_plan_offering[43] = 406278;
evolution_plan_item[43] = 74095;
evolution_plan_gold[43] = 5000;
evolution_plan_pet[43] = 406279;
evolution_plan_requirement[43] = {{CONST.对象_等级,50}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[43] = 310104;

evolution_plan_name[44] = "《進化》超甲狂犀";
evolution_plan_offering[44] = 406279;
evolution_plan_item[44] = 74096;
evolution_plan_gold[44] = 15000;
evolution_plan_pet[44] = 406280;
evolution_plan_requirement[44] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[44] = 310105;

evolution_plan_name[45] = "《進化》雙斧戰龍";
evolution_plan_offering[45] = 406281;
evolution_plan_item[45] = 74096;
evolution_plan_gold[45] = 15000;
evolution_plan_pet[45] = 406282;
evolution_plan_requirement[45] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[45] = 310104;

evolution_plan_name[46] = "《進化》路卡利歐";
evolution_plan_offering[46] = 406283;
evolution_plan_item[46] = 74095;
evolution_plan_gold[46] = 5000;
evolution_plan_pet[46] = 406284;
evolution_plan_requirement[46] = {{CONST.对象_等级,50}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[46] = 310001;

evolution_plan_name[47] = "《進化》超級路卡利歐";
evolution_plan_offering[47] = 406284;
evolution_plan_item[47] = 74096;
evolution_plan_gold[47] = 15000;
evolution_plan_pet[47] = 406285;
evolution_plan_requirement[47] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[47] = 310002;

evolution_plan_name[48] = "《進化》究極路卡利歐";
evolution_plan_offering[48] = 406285;
evolution_plan_item[48] = 74097;
evolution_plan_gold[48] = 50000;
evolution_plan_pet[48] = 406286;
evolution_plan_requirement[48] = {{CONST.对象_等级,100}, {CONST.对象_死亡数,10}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[48] = 310005;

evolution_plan_name[49] = "《進化》大針鋒";
evolution_plan_offering[49] = 406287;
evolution_plan_item[49] = 74095;
evolution_plan_gold[49] = 5000;
evolution_plan_pet[49] = 406288;
evolution_plan_requirement[49] = {{CONST.对象_等级,50}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[49] = 310107;

evolution_plan_name[50] = "《進化》超級大針鋒";
evolution_plan_offering[50] = 406288;
evolution_plan_item[50] = 74096;
evolution_plan_gold[50] = 15000;
evolution_plan_pet[50] = 406289;
evolution_plan_requirement[50] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[50] = 310108;

evolution_plan_name[51] = "《進化》穿山王";
evolution_plan_offering[51] = 406290;
evolution_plan_item[51] = 74096;
evolution_plan_gold[51] = 15000;
evolution_plan_pet[51] = 406291;
evolution_plan_requirement[51] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[51] = 310105;

evolution_plan_name[52] = "《進化》進擊拉普拉斯";
evolution_plan_offering[52] = 406292;
evolution_plan_item[52] = 74095;
evolution_plan_gold[52] = 5000;
evolution_plan_pet[52] = 406293;
evolution_plan_requirement[52] = {{CONST.对象_等级,50}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[52] = 310101;

evolution_plan_name[53] = "《進化》究擊拉普拉斯";
evolution_plan_offering[53] = 406293;
evolution_plan_item[53] = 74096;
evolution_plan_gold[53] = 15000;
evolution_plan_pet[53] = 406294;
evolution_plan_requirement[53] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[53] = 310102;

evolution_plan_name[54] = "《進化》班基拉斯";
evolution_plan_offering[54] = 406295;
evolution_plan_item[54] = 74095;
evolution_plan_gold[54] = 5000;
evolution_plan_pet[54] = 406296;
evolution_plan_requirement[54] = {{CONST.对象_等级,50}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[54] = 310104;

evolution_plan_name[55] = "《進化》超級班基拉斯";
evolution_plan_offering[55] = 406296;
evolution_plan_item[55] = 74096;
evolution_plan_gold[55] = 15000;
evolution_plan_pet[55] = 406297;
evolution_plan_requirement[55] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[55] = 310105;

evolution_plan_name[56] = "《進化》暴鯉龍";
evolution_plan_offering[56] = 406298;
evolution_plan_item[56] = 74095;
evolution_plan_gold[56] = 5000;
evolution_plan_pet[56] = 406299;
evolution_plan_requirement[56] = {{CONST.对象_等级,50}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[56] = 310107;

evolution_plan_name[57] = "《進化》超級暴鯉龍";
evolution_plan_offering[57] = 406299;
evolution_plan_item[57] = 74096;
evolution_plan_gold[57] = 15000;
evolution_plan_pet[57] = 406300;
evolution_plan_requirement[57] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[57] = 310005;

evolution_plan_name[58] = "《進化》超級化石翼龍";
evolution_plan_offering[58] = 406322;
evolution_plan_item[58] = 74095;
evolution_plan_gold[58] = 5000;
evolution_plan_pet[58] = 406323;
evolution_plan_requirement[58] = {{CONST.对象_等级,50}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[58] = 310105;

evolution_plan_name[59] = "《進化》究擊化石翼龍";
evolution_plan_offering[59] = 406323;
evolution_plan_item[59] = 74096;
evolution_plan_gold[59] = 15000;
evolution_plan_pet[59] = 406324;
evolution_plan_requirement[59] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[59] = 310005;

evolution_plan_name[60] = "《進化》皮皮";
evolution_plan_offering[60] = 406325;
evolution_plan_item[60] = 74095;
evolution_plan_gold[60] = 5000;
evolution_plan_pet[60] = 406326;
evolution_plan_requirement[60] = {{CONST.对象_等级,50}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[60] = 310110;

evolution_plan_name[61] = "《進化》皮可西";
evolution_plan_offering[61] = 406326;
evolution_plan_item[61] = 74096;
evolution_plan_gold[61] = 15000;
evolution_plan_pet[61] = 406327;
evolution_plan_requirement[61] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[61] = 310111;

evolution_plan_name[62] = "《進化》茸茸羊";
evolution_plan_offering[62] = 406328;
evolution_plan_item[62] = 74095;
evolution_plan_gold[62] = 5000;
evolution_plan_pet[62] = 406329;
evolution_plan_requirement[62] = {{CONST.对象_等级,50}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[62] = 310109;

evolution_plan_name[63] = "《進化》電龍";
evolution_plan_offering[63] = 406329;
evolution_plan_item[63] = 74096;
evolution_plan_gold[63] = 15000;
evolution_plan_pet[63] = 406330;
evolution_plan_requirement[63] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[63] = 310010;

evolution_plan_name[64] = "《進化》超級電龍";
evolution_plan_offering[64] = 406330;
evolution_plan_item[64] = 74097;
evolution_plan_gold[64] = 50000;
evolution_plan_pet[64] = 406331;
evolution_plan_requirement[64] = {{CONST.对象_等级,100}, {CONST.对象_死亡数,10}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[64] = 310011;

evolution_plan_name[65] = "《進化》豪力";
evolution_plan_offering[65] = 406332;
evolution_plan_item[65] = 74095;
evolution_plan_gold[65] = 5000;
evolution_plan_pet[65] = 406333;
evolution_plan_requirement[65] = {{CONST.对象_等级,50}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[65] = 310001;

evolution_plan_name[66] = "《進化》怪力";
evolution_plan_offering[66] = 406333;
evolution_plan_item[66] = 74096;
evolution_plan_gold[66] = 15000;
evolution_plan_pet[66] = 406334;
evolution_plan_requirement[66] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[66] = 310002;

evolution_plan_name[67] = "《進化》長尾火狐";
evolution_plan_offering[67] = 406335;
evolution_plan_item[67] = 74095;
evolution_plan_gold[67] = 5000;
evolution_plan_pet[67] = 406336;
evolution_plan_requirement[67] = {{CONST.对象_等级,50}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[67] = 310007;

evolution_plan_name[68] = "《進化》妖火紅狐";
evolution_plan_offering[68] = 406336;
evolution_plan_item[68] = 74096;
evolution_plan_gold[68] = 15000;
evolution_plan_pet[68] = 406337;
evolution_plan_requirement[68] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[68] = 310008;

evolution_plan_name[69] = "《進化》尖牙陸鯊";
evolution_plan_offering[69] = 406338;
evolution_plan_item[69] = 74095;
evolution_plan_gold[69] = 5000;
evolution_plan_pet[69] = 406339;
evolution_plan_requirement[69] = {{CONST.对象_等级,50}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[69] = 310104;

evolution_plan_name[70] = "《進化》烈咬陸鯊";
evolution_plan_offering[70] = 406339;
evolution_plan_item[70] = 74096;
evolution_plan_gold[70] = 15000;
evolution_plan_pet[70] = 406340;
evolution_plan_requirement[70] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[70] = 310105;

evolution_plan_name[71] = "《進化》超級波士可多拉";
evolution_plan_offering[71] = 406344;
evolution_plan_item[71] = 74095;
evolution_plan_gold[71] = 5000;
evolution_plan_pet[71] = 406345;
evolution_plan_requirement[71] = {{CONST.对象_等级,50}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[71] = 310002;

evolution_plan_name[72] = "《進化》究極波士可多拉";
evolution_plan_offering[72] = 406345;
evolution_plan_item[72] = 74096;
evolution_plan_gold[72] = 15000;
evolution_plan_pet[72] = 406346;
evolution_plan_requirement[72] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[72] = 310105;


evolution_plan_name[73] = "《進化》超級阿勃梭魯";
evolution_plan_offering[73] = 406362;
evolution_plan_item[73] = 74097;
evolution_plan_gold[73] = 30000;
evolution_plan_pet[73] = 406363;
evolution_plan_requirement[73] = {{CONST.对象_等级,85}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[73] = 310210;

evolution_plan_name[74] = "《進化》超級艾路雷朵";
evolution_plan_offering[74] = 406366;
evolution_plan_item[74] = 74097;
evolution_plan_gold[74] = 30000;
evolution_plan_pet[74] = 406367;
evolution_plan_requirement[74] = {{CONST.对象_等级,85}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[74] = 310201;

evolution_plan_name[75] = "《進化》超級闇黑雷姆";
evolution_plan_offering[75] = 406368;
evolution_plan_item[75] = 74097;
evolution_plan_gold[75] = 30000;
evolution_plan_pet[75] = 406369;
evolution_plan_requirement[75] = {{CONST.对象_等级,85}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[75] = 310210;

evolution_plan_name[76] = "《進化》超級焰白雷姆";
evolution_plan_offering[76] = 406388;
evolution_plan_item[76] = 74097;
evolution_plan_gold[76] = 30000;
evolution_plan_pet[76] = 406389;
evolution_plan_requirement[76] = {{CONST.对象_等级,85}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[76] = 310310;

evolution_plan_name[77] = "《進化》超級班基拉斯";
evolution_plan_offering[77] = 406370;
evolution_plan_item[77] = 74097;
evolution_plan_gold[77] = 30000;
evolution_plan_pet[77] = 406371;
evolution_plan_requirement[77] = {{CONST.对象_等级,85}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[77] = 310210;

evolution_plan_name[78] = "《進化》超級暴鯉龍";
evolution_plan_offering[78] = 406374;
evolution_plan_item[78] = 74097;
evolution_plan_gold[78] = 30000;
evolution_plan_pet[78] = 406375;
evolution_plan_requirement[78] = {{CONST.对象_等级,85}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[78] = 10628;

evolution_plan_name[79] = "《進化》超級暴噬龜";
evolution_plan_offering[79] = 406376;
evolution_plan_item[79] = 74097;
evolution_plan_gold[79] = 30000;
evolution_plan_pet[79] = 406377;
evolution_plan_requirement[79] = {{CONST.对象_等级,85}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[79] = 310207;

evolution_plan_name[80] = "《進化》超級大比鳥";
evolution_plan_offering[80] = 406381;
evolution_plan_item[80] = 74097;
evolution_plan_gold[80] = 30000;
evolution_plan_pet[80] = 406382;
evolution_plan_requirement[80] = {{CONST.对象_等级,85}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[80] = 310201;

evolution_plan_name[81] = "《進化》超級比克提尼";
evolution_plan_offering[81] = 406382;
evolution_plan_item[81] = 74097;
evolution_plan_gold[81] = 30000;
evolution_plan_pet[81] = 406383;
evolution_plan_requirement[81] = {{CONST.对象_等级,85}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[81] = 10628;

evolution_plan_name[82] = "《進化》超級電龍";
evolution_plan_offering[82] = 406420;
evolution_plan_item[82] = 74097;
evolution_plan_gold[82] = 30000;
evolution_plan_pet[82] = 406421;
evolution_plan_requirement[82] = {{CONST.对象_等级,85}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[82] = 310310;

evolution_plan_name[83] = "《進化》超級蒂安希";
evolution_plan_offering[83] = 406422;
evolution_plan_item[83] = 74097;
evolution_plan_gold[83] = 30000;
evolution_plan_pet[83] = 406423;
evolution_plan_requirement[83] = {{CONST.对象_等级,85}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[83] = 310204;

evolution_plan_name[84] = "《進化》超級赫拉克羅斯";
evolution_plan_offering[84] = 406440;
evolution_plan_item[84] = 74097;
evolution_plan_gold[84] = 30000;
evolution_plan_pet[84] = 406441;
evolution_plan_requirement[84] = {{CONST.对象_等级,85}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[84] = 310307;

evolution_plan_name[85] = "《進化》超級巨金怪";
evolution_plan_offering[85] = 406448;
evolution_plan_item[85] = 74097;
evolution_plan_gold[85] = 30000;
evolution_plan_pet[85] = 406449;
evolution_plan_requirement[85] = {{CONST.对象_等级,85}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[85] = 310310;

evolution_plan_name[86] = "《進化》超級巨鉗螳螂";
evolution_plan_offering[86] = 406450;
evolution_plan_item[86] = 74097;
evolution_plan_gold[86] = 30000;
evolution_plan_pet[86] = 406451;
evolution_plan_requirement[86] = {{CONST.对象_等级,85}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[86] = 10628;

evolution_plan_name[87] = "《進化》超級烈咬陸鯊";
evolution_plan_offering[87] = 406454;
evolution_plan_item[87] = 74097;
evolution_plan_gold[87] = 30000;
evolution_plan_pet[87] = 406455;
evolution_plan_requirement[87] = {{CONST.对象_等级,85}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[87] = 310304;

evolution_plan_name[88] = "《進化》超級基格爾德";
evolution_plan_offering[88] = 406446;
evolution_plan_item[88] = 74097;
evolution_plan_gold[88] = 30000;
evolution_plan_pet[88] = 406447;
evolution_plan_requirement[88] = {{CONST.对象_等级,85}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[88] = 310307;

evolution_plan_name[89] = "《進化》解放胡帕";
evolution_plan_offering[89] = 406444;
evolution_plan_item[89] = 74097;
evolution_plan_gold[89] = 30000;
evolution_plan_pet[89] = 406445;
evolution_plan_requirement[89] = {{CONST.对象_等级,85}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[89] = 310204;


evolution_plan_name[90] = "《進化》進擊雪拉比";
evolution_plan_offering[90] = 406350;
evolution_plan_item[90] = 74096;
evolution_plan_gold[90] = 25000;
evolution_plan_pet[90] = 406351;
evolution_plan_requirement[90] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[90] = 6303;

evolution_plan_name[91] = "《進化》究極雪拉比";
evolution_plan_offering[91] = 406351;
evolution_plan_item[91] = 74097;
evolution_plan_gold[91] = 60000;
evolution_plan_pet[91] = 406352;
evolution_plan_requirement[91] = {{CONST.对象_等级,100}, {CONST.对象_死亡数,10}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[91] = 6306;

evolution_plan_name[92] = "《進化》進擊雷公";
evolution_plan_offering[92] = 406256;
evolution_plan_item[92] = 74096;
evolution_plan_gold[92] = 25000;
evolution_plan_pet[92] = 406257;
evolution_plan_requirement[92] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[92] = 4203;

evolution_plan_name[93] = "《進化》究極雷公";
evolution_plan_offering[93] = 406257;
evolution_plan_item[93] = 74097;
evolution_plan_gold[93] = 60000;
evolution_plan_pet[93] = 406258;
evolution_plan_requirement[93] = {{CONST.对象_等级,100}, {CONST.对象_死亡数,10}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[93] = 4206;

evolution_plan_name[94] = "《進化》進擊炎帝";
evolution_plan_offering[94] = 406316;
evolution_plan_item[94] = 74096;
evolution_plan_gold[94] = 25000;
evolution_plan_pet[94] = 406317;
evolution_plan_requirement[94] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[94] = 3803;

evolution_plan_name[95] = "《進化》究極炎帝";
evolution_plan_offering[95] = 406317;
evolution_plan_item[95] = 74097;
evolution_plan_gold[95] = 60000;
evolution_plan_pet[95] = 406318;
evolution_plan_requirement[95] = {{CONST.对象_等级,100}, {CONST.对象_死亡数,10}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[95] = 3806;

evolution_plan_name[96] = "《進化》進擊水君";
evolution_plan_offering[96] = 406319;
evolution_plan_item[96] = 74096;
evolution_plan_gold[96] = 25000;
evolution_plan_pet[96] = 406320;
evolution_plan_requirement[96] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[96] = 4003;

evolution_plan_name[97] = "《進化》究極水君";
evolution_plan_offering[97] = 406320;
evolution_plan_item[97] = 74097;
evolution_plan_gold[97] = 60000;
evolution_plan_pet[97] = 406321;
evolution_plan_requirement[97] = {{CONST.对象_等级,100}, {CONST.对象_死亡数,10}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[97] = 4006;

evolution_plan_name[98] = "《進化》原始固拉多";
evolution_plan_offering[98] = 406301;
evolution_plan_item[98] = 74096;
evolution_plan_gold[98] = 25000;
evolution_plan_pet[98] = 406302;
evolution_plan_requirement[98] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[98] = 5004;

evolution_plan_name[99] = "《進化》究極固拉多";
evolution_plan_offering[99] = 406302;
evolution_plan_item[99] = 74097;
evolution_plan_gold[99] = 60000;
evolution_plan_pet[99] = 406303;
evolution_plan_requirement[99] = {{CONST.对象_等级,100}, {CONST.对象_死亡数,10}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[99] = 5008;

evolution_plan_name[100] = "《進化》原始蓋歐卡";
evolution_plan_offering[100] = 406304;
evolution_plan_item[100] = 74096;
evolution_plan_gold[100] = 25000;
evolution_plan_pet[100] = 406305;
evolution_plan_requirement[100] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[100] = 5104;

evolution_plan_name[101] = "《進化》究極蓋歐卡";
evolution_plan_offering[101] = 406305;
evolution_plan_item[101] = 74097;
evolution_plan_gold[101] = 60000;
evolution_plan_pet[101] = 406306;
evolution_plan_requirement[101] = {{CONST.对象_等级,100}, {CONST.对象_死亡数,10}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[101] = 5108;

evolution_plan_name[102] = "《進化》超級烈空座";
evolution_plan_offering[102] = 406253;
evolution_plan_item[102] = 74096;
evolution_plan_gold[102] = 25000;
evolution_plan_pet[102] = 406254;
evolution_plan_requirement[102] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[102] = 5304;

evolution_plan_name[103] = "《進化》究極烈空座";
evolution_plan_offering[103] = 406254;
evolution_plan_item[103] = 74097;
evolution_plan_gold[103] = 60000;
evolution_plan_pet[103] = 406255;
evolution_plan_requirement[103] = {{CONST.对象_等级,100}, {CONST.对象_死亡数,10}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[103] = 5308;

evolution_plan_name[104] = "《進化》別種騎拉帝納";
evolution_plan_offering[104] = 406313;
evolution_plan_item[104] = 74096;
evolution_plan_gold[104] = 25000;
evolution_plan_pet[104] = 406314;
evolution_plan_requirement[104] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[104] = 5204;

evolution_plan_name[105] = "《進化》進擊騎拉帝納";
evolution_plan_offering[105] = 406314;
evolution_plan_item[105] = 74097;
evolution_plan_gold[105] = 60000;
evolution_plan_pet[105] = 406315;
evolution_plan_requirement[105] = {{CONST.对象_等级,100}, {CONST.对象_死亡数,10}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[105] = 5208;

evolution_plan_name[106] = "《進化》究極雷吉艾斯";
evolution_plan_offering[106] = 406259;
evolution_plan_item[106] = 74097;
evolution_plan_gold[106] = 60000;
evolution_plan_pet[106] = 406260;
evolution_plan_requirement[106] = {{CONST.对象_等级,100}, {CONST.对象_死亡数,10}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[106] = 5906;

evolution_plan_name[107] = "《進化》進擊帝牙盧卡";
evolution_plan_offering[107] = 406307;
evolution_plan_item[107] = 74096;
evolution_plan_gold[107] = 25000;
evolution_plan_pet[107] = 406308;
evolution_plan_requirement[107] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[107] = 6703;

evolution_plan_name[108] = "《進化》究極帝牙盧卡";
evolution_plan_offering[108] = 406308;
evolution_plan_item[108] = 74097;
evolution_plan_gold[108] = 60000;
evolution_plan_pet[108] = 406309;
evolution_plan_requirement[108] = {{CONST.对象_等级,100}, {CONST.对象_死亡数,10}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[108] = 6706;

evolution_plan_name[109] = "《進化》進擊帕路奇亞";
evolution_plan_offering[109] = 406310;
evolution_plan_item[109] = 74096;
evolution_plan_gold[109] = 25000;
evolution_plan_pet[109] = 406311;
evolution_plan_requirement[109] = {{CONST.对象_等级,70}, {CONST.对象_死亡数,5}, {CONST.对象_伤害数,250}, {CONST.对象_杀宠数,200}};
evolution_plan_tech[109] = 6803;

evolution_plan_name[110] = "《進化》究極帕路奇亞";
evolution_plan_offering[110] = 406311;
evolution_plan_item[110] = 74097;
evolution_plan_gold[110] = 60000;
evolution_plan_pet[110] = 406312;
evolution_plan_requirement[110] = {{CONST.对象_等级,100}, {CONST.对象_死亡数,10}, {CONST.对象_伤害数,200}, {CONST.对象_杀宠数,100}};
evolution_plan_tech[110] = 6806;
-------------------------------------------------
local function calcWarp()
  local page = math.modf(#evolution_plan_name / 8) + 1
  local remainder = math.fmod(#evolution_plan_name, 8)
  return page, remainder
end

--远程按钮UI呼叫
function Module:evolutionPlansInfo(npc, player)
          local winButton = CONST.BUTTON_关闭;
          local msg = "1\\n　　　　　　　　【寵物進化預覽】\\n"
          for i = 1,8 do
             msg = msg .. "　　◎項目 "..i.."　".. evolution_plan_name[i] .. "\\n"
             if (i>=8) then
                 winButton = CONST.BUTTON_下取消;
             end
          end
          NLG.ShowWindowTalked(player, self.evolutionerNPC, CONST.窗口_选择框, winButton, 1, msg);
end

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load');
  self.evolutionerNPC = self:NPC_createNormal('寵物進化看板', 400416, { x = 106, y = 108, mapType = 0, map = 80010, direction = 6 });
  self:NPC_regWindowTalkedEvent(self.evolutionerNPC, function(npc, player, _seqno, _select, _data)
    local column = tonumber(_data)
    local page = tonumber(_seqno)
    local warpPage = page;
    local winMsg = "1\\n　　　　　　　　【寵物進化預覽】\\n"
    local winButton = CONST.BUTTON_关闭;
    local totalPage, remainder = calcWarp()
    --上页16 下页32 关闭/取消2
    if _select > 0 then
      if _select == CONST.按钮_确定 then
          if (page>=1001) then
              local seqno = page - 1000;
              local msg = "　　　　　　　　【寵物進化預覽】\\n"
              local msg = msg .. evolutionOfferingInfo(seqno)
              NLG.ShowWindowTalked(player, self.evolutionerNPC, CONST.窗口_信息框, CONST.按钮_是否, 2000+seqno, msg);
              return
          else
              return
          end
      elseif _select == CONST.按钮_关闭 then
          if (page>=1001) then
              local winPage_temp = page - 1000;
              --页数纪录
              local page_temp = math.modf(winPage_temp / 8) + 1;
              if (math.fmod(winPage_temp,8)==0) then page_temp=page_temp-1; end
              --起始第一列编号
              local count_temp = 8 * (page_temp - 1)	
              --print(page,winPage_temp,page_temp,count_temp)

              local winButton = CONST.BUTTON_关闭;
              local msg = "1\\n　　　　　　　　【寵物進化預覽】\\n"
              if page_temp == totalPage then
                for i = 1 + count_temp, remainder + count_temp do
                    msg = msg .. "　　◎項目 "..i.."　".. evolution_plan_name[i] .. "\\n"
                end
              else
                for i = 1 + count_temp, 8 + count_temp do
                    msg = msg .. "　　◎項目 "..i.."　".. evolution_plan_name[i] .. "\\n"
                end
              end
              if page_temp == 1 then
                winButton = CONST.BUTTON_下取消
              elseif page_temp == totalPage then
                winButton = CONST.BUTTON_上取消
              else
                winButton = CONST.BUTTON_上下取消
              end
              NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, winButton, page_temp, msg);
              return
          else
              return
          end
      elseif _select == CONST.按钮_是 then
          if (page>=2001) then
              local seqno = page - 2000;
              local petSlot = Char.HavePet(player, evolution_plan_offering[seqno])
              evolutionMutation(seqno,player,petSlot)
              NLG.UpChar(player);
              return
          else
              return
          end
      elseif _select == CONST.按钮_否 then
          if (page>=2001) then
              local count = page - 2000;
              local msg = "　　　　　　　　【寵物進化預覽】\\n"
              local msg = msg .. convertGoalInfo(count);
              NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_确定关闭, 1000+count, msg);
              return
          else
              return
          end
      end
      if _select == CONST.BUTTON_下一页 then
        warpPage = warpPage + 1
        if (warpPage == totalPage) or ((warpPage == (totalPage - 1) and remainder == 0)) then
          winButton = CONST.BUTTON_上取消
        else
          winButton = CONST.BUTTON_上下取消
        end
      elseif _select == CONST.BUTTON_上一页 then
        warpPage = warpPage - 1
        if warpPage == 1 then
          winButton = CONST.BUTTON_下取消
        else
          winButton = CONST.BUTTON_上下取消
        end
      elseif _select == 2 then
        warpPage = 1
        return
      end
      local count = 8 * (warpPage - 1)
      if warpPage == totalPage then
        for i = 1 + count, remainder + count do
            winMsg = winMsg .. "　　◎項目 "..i.."　".. evolution_plan_name[i] .. "\\n"
        end
      else
        for i = 1 + count, 8 + count do
            winMsg = winMsg .. "　　◎項目 "..i.."　".. evolution_plan_name[i] .. "\\n"
        end
      end
      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, winButton, warpPage, winMsg);
    else
      local count = 8 * (warpPage - 1) + column
      --print(count)
      local msg = "　　　　　　　　【寵物進化預覽】\\n"
      local msg = msg .. convertGoalInfo(count);
      NLG.ShowWindowTalked(player, self.evolutionerNPC, CONST.窗口_信息框, CONST.按钮_确定关闭, 1000+count, msg);
    end
  end)
  self:NPC_regTalkedEvent(self.evolutionerNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local winButton = CONST.BUTTON_关闭;
      local msg = "1\\n　　　　　　　　【寵物進化預覽】\\n"
      for i = 1,8 do
         msg = msg .. "　　◎項目 "..i.."　".. evolution_plan_name[i] .. "\\n"
         if (i>=8) then
             winButton = CONST.BUTTON_下取消;
         end
      end
      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, winButton, 1, msg);
    end
    return
  end)
end

---------------------------------------------------------------------------------------------------------------
--目标信息
function convertGoalInfo(count)
      local EnemyDataIndex_Goal = Data.EnemyGetDataIndex(evolution_plan_pet[count]);
      local enemyBaseId_Goal = Data.EnemyGetData(EnemyDataIndex_Goal, CONST.Enemy_Base编号);
      local EnemyBaseDataIndex_Goal = Data.EnemyBaseGetDataIndex(enemyBaseId_Goal);
      local Goal_name = Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_名字);
      local Goal_DataPos_3 = Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_种族);
      local Goal_DataPos_3 = Tribe(Goal_DataPos_3);
      local Goal_DataPos_4 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_体力);
      local Goal_DataPos_5 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_力量);
      local Goal_DataPos_6 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_强度);
      local Goal_DataPos_7 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_速度);
      local Goal_DataPos_8 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, 8);
      local Goal_DataPos_12 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_命中);
      local Goal_DataPos_13 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_必杀);
      local Goal_DataPos_14 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_地属性);
      local Goal_DataPos_15 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_水属性);
      local Goal_DataPos_16 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_火属性);
      local Goal_DataPos_17 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_风属性);
      local Goal_DataPos_18 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_抗毒);
      local Goal_DataPos_19 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_抗醉);
      local Goal_DataPos_20 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_抗睡);
      local Goal_DataPos_21 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_抗混乱);
      local Goal_DataPos_22 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_抗石化);
      local Goal_DataPos_23 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_抗遗忘);
      local Goal_DataPos_26 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_闪躲);
      local Goal_DataPos_27 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_反击);
      local Goal_DataPos_28 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_技能栏);
      local Goal_DataPos_29 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_形象);
      local imageText = "@g,"..Goal_DataPos_29..",2,8,6,0@"
      local Goal_DataPos_35 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_出生技能1);
      local Goal_DataPos_36 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_出生技能2);
      local Goal_DataPos_37 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_出生技能3);
      local Goal_DataPos_38 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_出生技能4);
      local Goal_DataPos_39 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_出生技能5);
      local Goal_DataPos_40 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_出生技能6);
      local Goal_DataPos_41 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_出生技能7);
      local Goal_DataPos_42 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_出生技能8);
      local Goal_DataPos_43 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_出生技能9);
      local Goal_DataPos_44 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_出生技能10);
      local TechIndex = Tech.GetTechIndex(evolution_plan_tech[count]);
      local TechName = Tech.GetData(TechIndex, CONST.TECH_NAME);
      local msg = imageText .. "　　$4".. Goal_name .. "\\n"
                         .. "　　　　　　　" .. "$1體力 ".. Goal_DataPos_4+2 .."　" .. "$8必殺 ".. Goal_DataPos_13 .."　" .. "$8反擊 ".. Goal_DataPos_27 .."\\n"
                         .. "　　　　　　　" .. "$1力量 ".. Goal_DataPos_5+2 .."　" .. "$8命中 ".. Goal_DataPos_12 .."　" .. "$8閃躲 ".. Goal_DataPos_26 .."\\n"
                         .. "　　　　　　　" .. "$1強度 ".. Goal_DataPos_6+2 .."　" .. "$2抗毒 ".. Goal_DataPos_18 .."　" .. "$2抗醉 ".. Goal_DataPos_19 .."\\n"
                         .. "　　　　　　　" .. "$1速度 ".. Goal_DataPos_7+2 .."　" .. "$2抗睡 ".. Goal_DataPos_20 .."　" .. "$2抗混 ".. Goal_DataPos_21 .."\\n"
                         .. "　　　　　　　" .. "$1魔法 ".. Goal_DataPos_8+2 .."　" .. "$2抗石 ".. Goal_DataPos_22 .."　" .. "$2抗忘 ".. Goal_DataPos_23 .."\\n"
                         .. "　　　　　　　" .. "$5地 ".. Goal_DataPos_14/10 .."　" .."$5水 ".. Goal_DataPos_15/10 .."　" .."$5火 ".. Goal_DataPos_16/10 .."　" .."$5風 ".. Goal_DataPos_17/10 .."\\n"
                         .. "　　　　　　　" .. "$9種族 ".. Goal_DataPos_3 .."　" .. "$9技能 ".. TechName .."\\n"
      return msg;
end

--祭品信息
function evolutionOfferingInfo(seqno)
              local msg = "";
              local EnemyDataIndex_1 = Data.EnemyGetDataIndex(evolution_plan_offering[seqno]);
              local enemyBaseId_1 = Data.EnemyGetData(EnemyDataIndex_1, CONST.Enemy_Base编号);
              local EnemyBaseDataIndex_1 = Data.EnemyBaseGetDataIndex(enemyBaseId_1);
              --local offering_name_1 = Data.EnemyBaseGetData(EnemyBaseDataIndex_1, CONST.EnemyBase_名字);
              local offering_image_1 = Data.EnemyBaseGetData(EnemyBaseDataIndex_1, CONST.EnemyBase_形象);
              local EnemyDataIndex_3 = Data.EnemyGetDataIndex(evolution_plan_pet[seqno]);
              local enemyBaseId_3 = Data.EnemyGetData(EnemyDataIndex_3, CONST.Enemy_Base编号);
              local EnemyBaseDataIndex_3 = Data.EnemyBaseGetDataIndex(enemyBaseId_3);
              --local offering_name_3 = Data.EnemyBaseGetData(EnemyBaseDataIndex_3, CONST.EnemyBase_名字);
              local offering_image_3 = Data.EnemyBaseGetData(EnemyBaseDataIndex_3, CONST.EnemyBase_形象);
              --local offering_image_ix = 3 + 7*(i-1);
              local imageText_1 = "@g,"..offering_image_1..",5,6,4,0@"
              local imageText_2 = "@g,246691,10,4,4,0@"
              local imageText_3 = "@g,"..offering_image_3..",15,6,4,0@"
              local msg = msg .. imageText_1 .. "  " .. imageText_2 .. "  " .. imageText_3

              local Gold = evolution_plan_gold[seqno];
              local ItemsetIndex = Data.ItemsetGetIndex(evolution_plan_item[seqno]);
              local Item_name= Data.ItemsetGetData( ItemsetIndex, CONST.ITEMSET_TRUENAME);

              local level = evolution_plan_requirement[seqno][1][2];
              local dead_num = evolution_plan_requirement[seqno][2][2];
              local hit_num = evolution_plan_requirement[seqno][3][2];
              local kill_num = evolution_plan_requirement[seqno][4][2];

              local msg = msg .. "\\n\\n\\n\\n\\n\\n　$5道具: ".. Item_name .. "1個" .. "　　$5魔幣: " .. Gold .. " G\\n"
                                              .. "　$4◎條件:\\n"
                                              .. "　$4等級".. level .. "↑ 死亡" .. dead_num .. "↑ 傷害" .. hit_num .. "↑ 殺敵" .. kill_num .. "↑"
      return msg;
end

--进化执行
function evolutionMutation(seqno,player,petSlot)
              if (Char.ItemNum(player, evolution_plan_item[seqno])==0) then
                  NLG.SystemMessage(player,"[系統]缺少進化的石頭。");
                  return
              end
              if (Char.GetData(player, CONST.对象_金币)<evolution_plan_gold[seqno]) then
                  NLG.SystemMessage(player,"[系統]進化所需金幣不足。");
                  return
              end
              local petIndex = Char.GetPet(player,petSlot);
              if (petIndex>=0) then
                local PetID = Char.GetData(petIndex, CONST.PET_PetID);
                local level_num = Char.GetData(petIndex, evolution_plan_requirement[seqno][1][1]);
                Level = level_num;
                local dead_num = Char.GetData(petIndex, evolution_plan_requirement[seqno][2][1]);
                local hit_num = Char.GetData(petIndex, evolution_plan_requirement[seqno][3][1]);
                local kill_num = Char.GetData(petIndex, evolution_plan_requirement[seqno][4][1]);
                if (PetID~=evolution_plan_offering[seqno]) then
                      NLG.SystemMessage(player,"[系統]缺少進化所需寵物。");
                      return
                end
                if ( level_num < evolution_plan_requirement[seqno][1][2] ) then
                      NLG.SystemMessage(player,"[系統]等級未達進化標準。");
                      return
                end
                if ( dead_num < evolution_plan_requirement[seqno][2][2] ) then
                      NLG.SystemMessage(player,"[系統]寵物死亡數"..dead_num.."未達進化標準。");
                      return
                end
                if ( hit_num < evolution_plan_requirement[seqno][3][2] ) then
                      NLG.SystemMessage(player,"[系統]寵物傷害數"..hit_num.."未達進化標準。");
                      return
                end
                if ( kill_num < evolution_plan_requirement[seqno][4][2] ) then
                      NLG.SystemMessage(player,"[系統]寵物殺敵數"..kill_num.."未達進化標準。");
                      return
                end
              else
                      NLG.SystemMessage(player,"[系統]缺少進化所需寵物。");
                      return
              end
              Char.DelItem(player, evolution_plan_item[seqno], 1);
              Char.AddGold(player, -evolution_plan_gold[seqno]);

              --档次纪录
              local a6, a1, a2, a3, a4, a5 = Char.GetPetRank(player,petSlot);
              -- 宠物技能纪录
              local skillTable={}
              for i=0,9 do
                local tech_id = Pet.GetSkill(petIndex, i)
                if (tech_id<0) then
                  table.insert(skillTable,nil)
                else
                  table.insert(skillTable,tech_id)
                end
              end

              Char.DelSlotPet(player, petSlot);
              Char.GivePet(player,evolution_plan_pet[seqno],0);

              --进化后调整与原宠相同
              local evolution_petIndex = Char.GetPet(player,petSlot);
              Pet.SetArtRank(evolution_petIndex, CONST.PET_体成,  Pet.FullArtRank(evolution_petIndex, CONST.PET_体成) - a1 );
              Pet.SetArtRank(evolution_petIndex, CONST.PET_力成,  Pet.FullArtRank(evolution_petIndex, CONST.PET_力成) - a2 );
              Pet.SetArtRank(evolution_petIndex, CONST.PET_强成,  Pet.FullArtRank(evolution_petIndex, CONST.PET_强成) - a3 );
              Pet.SetArtRank(evolution_petIndex, CONST.PET_敏成,  Pet.FullArtRank(evolution_petIndex, CONST.PET_敏成) - a4 );
              Pet.SetArtRank(evolution_petIndex, CONST.PET_魔成,  Pet.FullArtRank(evolution_petIndex, CONST.PET_魔成) - a5 );
              Pet.ReBirth(player, evolution_petIndex);
              Pet.UpPet(player, evolution_petIndex);

              local arr_rank1_new = Pet.GetArtRank(evolution_petIndex,CONST.PET_体成);
              local arr_rank2_new = Pet.GetArtRank(evolution_petIndex,CONST.PET_力成);
              local arr_rank3_new = Pet.GetArtRank(evolution_petIndex,CONST.PET_强成);
              local arr_rank4_new = Pet.GetArtRank(evolution_petIndex,CONST.PET_敏成);
              local arr_rank5_new = Pet.GetArtRank(evolution_petIndex,CONST.PET_魔成);

              if(Level~=1) then
                Char.SetData(evolution_petIndex,CONST.对象_升级点,Level-1);
                Char.SetData(evolution_petIndex,CONST.对象_等级,Level);
                Char.SetData(evolution_petIndex,CONST.对象_体力, (Char.GetData(evolution_petIndex,CONST.对象_体力) + (arr_rank1_new * (1/24) * (Level - 1)*100)) );
                Char.SetData(evolution_petIndex,CONST.对象_力量, (Char.GetData(evolution_petIndex,CONST.对象_力量) + (arr_rank2_new * (1/24) * (Level - 1)*100)) );
                Char.SetData(evolution_petIndex,CONST.对象_强度, (Char.GetData(evolution_petIndex,CONST.对象_强度) + (arr_rank3_new * (1/24) * (Level - 1)*100)) );
                Char.SetData(evolution_petIndex,CONST.对象_速度, (Char.GetData(evolution_petIndex,CONST.对象_速度) + (arr_rank4_new * (1/24) * (Level - 1)*100)) );
                Char.SetData(evolution_petIndex,CONST.对象_魔法, (Char.GetData(evolution_petIndex,CONST.对象_魔法) + (arr_rank5_new * (1/24) * (Level - 1)*100)) );
                Pet.UpPet(player,evolution_petIndex);
              end
              -- 宠物技能
              for i=0,9 do
                local tech_id = skillTable[i+1];
                Pet.DelSkill(evolution_petIndex,i);
                if (tech_id~=nil) then
                  Pet.AddSkill(evolution_petIndex,tech_id,i);
                end
              end
              Pet.AddSkill(evolution_petIndex, evolution_plan_tech[seqno]);
              Pet.UpPet(player,evolution_petIndex);
end

--档次计算
Char.GetPetRank = function(playerIndex,slot)
  local petIndex = Char.GetPet(playerIndex, slot);
  if petIndex >= 0 then
    local arr_rank1 = Pet.GetArtRank(petIndex,CONST.PET_体成);
    local arr_rank2 = Pet.GetArtRank(petIndex,CONST.PET_力成);
    local arr_rank3 = Pet.GetArtRank(petIndex,CONST.PET_强成);
    local arr_rank4 = Pet.GetArtRank(petIndex,CONST.PET_敏成);
    local arr_rank5 = Pet.GetArtRank(petIndex,CONST.PET_魔成);
    local arr_rank11 = Pet.FullArtRank(petIndex, CONST.PET_体成);
    local arr_rank21 = Pet.FullArtRank(petIndex, CONST.PET_力成);
    local arr_rank31 = Pet.FullArtRank(petIndex, CONST.PET_强成);
    local arr_rank41 = Pet.FullArtRank(petIndex, CONST.PET_敏成);
    local arr_rank51 = Pet.FullArtRank(petIndex, CONST.PET_魔成);
    local a1 = math.abs(arr_rank11 - arr_rank1);
    local a2 = math.abs(arr_rank21 - arr_rank2);
    local a3 = math.abs(arr_rank31 - arr_rank3);
    local a4 = math.abs(arr_rank41 - arr_rank4);
    local a5 = math.abs(arr_rank51 - arr_rank5);
    local a6 = a1 + a2+ a3+ a4+ a5;
    return a6, a1, a2, a3, a4, a5;
  end
  return -1;
end

--种族字符串转换
function Tribe(Tribe)
  if Tribe==0 then
    return "人型系"
  elseif Tribe == 1 then
    return "龍族系"
  elseif Tribe == 2 then
    return "不死系"
  elseif Tribe == 3 then
    return "飛行系"
  elseif Tribe == 4 then
    return "昆蟲系"
  elseif Tribe == 5 then
    return "植物系"
  elseif Tribe == 6 then
    return "野獸系"
  elseif Tribe == 7 then
    return "特殊系"
  elseif Tribe == 8 then
    return "金屬系"
  elseif Tribe == 9 then
    return "邪魔系"
  elseif Tribe == 10 then
    return "神族系"
  elseif Tribe == 11 then
    return "精靈系"
  end
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
