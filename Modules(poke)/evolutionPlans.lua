---ģ����
local Module = ModuleBase:createModule(evolutionPlans)

--�����������
local evolution_plan_name = {};
local evolution_plan_offering = {};
local evolution_plan_item = {};
local evolution_plan_gold = {};
local evolution_plan_pet = {};
local evolution_plan_requirement = {};
local evolution_plan_tech = {};
--
evolution_plan_name[1] = "���M���������";
evolution_plan_offering[1] = 406198;
evolution_plan_item[1] = 74095;
evolution_plan_gold[1] = 5000;
evolution_plan_pet[1] = 406199;
evolution_plan_requirement[1] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[1] = 310007;

evolution_plan_name[2] = "���M����������";
evolution_plan_offering[2] = 406199;
evolution_plan_item[2] = 74096;
evolution_plan_gold[2] = 15000;
evolution_plan_pet[2] = 406200;
evolution_plan_requirement[2] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[2] = 310008;

evolution_plan_name[3] = "���M��������������X";
evolution_plan_offering[3] = 406200;
evolution_plan_item[3] = 74097;
evolution_plan_gold[3] = 50000;
evolution_plan_pet[3] = 406201;
evolution_plan_requirement[3] = {{CONST.����_�ȼ�,100}, {CONST.����_������,20}, {CONST.����_�˺���,500}, {CONST.����_ɱ����,200}};
evolution_plan_tech[3] = 310005;

evolution_plan_name[4] = "���M��������������Y";
evolution_plan_offering[4] = 406200;
evolution_plan_item[4] = 74097;
evolution_plan_gold[4] = 50000;
evolution_plan_pet[4] = 406202;
evolution_plan_requirement[4] = {{CONST.����_�ȼ�,100}, {CONST.����_������,10}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[4] = 310008;

evolution_plan_name[5] = "���M�������ܲ�";
evolution_plan_offering[5] = 406203;
evolution_plan_item[5] = 74095;
evolution_plan_gold[5] = 5000;
evolution_plan_pet[5] = 406204;
evolution_plan_requirement[5] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[5] = 310107;

evolution_plan_name[6] = "���M�������ܻ�";
evolution_plan_offering[6] = 406204;
evolution_plan_item[6] = 74096;
evolution_plan_gold[6] = 15000;
evolution_plan_pet[6] = 406205;
evolution_plan_requirement[6] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[6] = 310108;

evolution_plan_name[7] = "���M�����������ܻ�";
evolution_plan_offering[7] = 406205;
evolution_plan_item[7] = 74097;
evolution_plan_gold[7] = 50000;
evolution_plan_pet[7] = 406206;
evolution_plan_requirement[7] = {{CONST.����_�ȼ�,100}, {CONST.����_������,10}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[7] = 310105;

evolution_plan_name[8] = "���M����������";
evolution_plan_offering[8] = 406207;
evolution_plan_item[8] = 74095;
evolution_plan_gold[8] = 5000;
evolution_plan_pet[8] = 406208;
evolution_plan_requirement[8] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[8] = 310101;

evolution_plan_name[9] = "���M����ˮ����";
evolution_plan_offering[9] = 406208;
evolution_plan_item[9] = 74096;
evolution_plan_gold[9] = 15000;
evolution_plan_pet[9] = 406209;
evolution_plan_requirement[9] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[9] = 310102;

evolution_plan_name[10] = "���M��������ˮ����";
evolution_plan_offering[10] = 406209;
evolution_plan_item[10] = 74097;
evolution_plan_gold[10] = 50000;
evolution_plan_pet[10] = 406210;
evolution_plan_requirement[10] = {{CONST.����_�ȼ�,100}, {CONST.����_������,10}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[10] = 310105;

evolution_plan_name[11] = "���M����Ƥ����";
evolution_plan_offering[11] = 406211;
evolution_plan_item[11] = 74095;
evolution_plan_gold[11] = 5000;
evolution_plan_pet[11] = 406212;
evolution_plan_requirement[11] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[11] = 310109;

evolution_plan_name[12] = "���M��������";
evolution_plan_offering[12] = 406212;
evolution_plan_item[12] = 74096;
evolution_plan_gold[12] = 15000;
evolution_plan_pet[12] = 406213;
evolution_plan_requirement[12] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[12] = 310010;

evolution_plan_name[13] = "���M�����M������";
evolution_plan_offering[13] = 406213;
evolution_plan_item[13] = 74097;
evolution_plan_gold[13] = 50000;
evolution_plan_pet[13] = 406214;
evolution_plan_requirement[13] = {{CONST.����_�ȼ�,100}, {CONST.����_������,10}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[13] = 310011;

evolution_plan_name[14] = "���M������˹ͨ";
evolution_plan_offering[14] = 406216;
evolution_plan_item[14] = 74095;
evolution_plan_gold[14] = 5000;
evolution_plan_pet[14] = 406217;
evolution_plan_requirement[14] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[14] = 310101;

evolution_plan_name[15] = "���M��������";
evolution_plan_offering[15] = 406217;
evolution_plan_item[15] = 74096;
evolution_plan_gold[15] = 15000;
evolution_plan_pet[15] = 406218;
evolution_plan_requirement[15] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[15] = 310102;

evolution_plan_name[16] = "���M������������";
evolution_plan_offering[16] = 406218;
evolution_plan_item[16] = 74097;
evolution_plan_gold[16] = 50000;
evolution_plan_pet[16] = 406219;
evolution_plan_requirement[16] = {{CONST.����_�ȼ�,100}, {CONST.����_������,20}, {CONST.����_�˺���,500}, {CONST.����_ɱ����,200}};
evolution_plan_tech[16] = 310005;

evolution_plan_name[17] = "���M�����ʹ��";
evolution_plan_offering[17] = 406220;
evolution_plan_item[17] = 74096;
evolution_plan_gold[17] = 15000;
evolution_plan_pet[17] = 406221;
evolution_plan_requirement[17] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[17] = 310107;

evolution_plan_name[18] = "���M�����M�����ϴ�";
evolution_plan_offering[18] = 406222;
evolution_plan_item[18] = 74096;
evolution_plan_gold[18] = 15000;
evolution_plan_pet[18] = 406223;
evolution_plan_requirement[18] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[18] = 310110;

evolution_plan_name[19] = "���M�������ȫF";
evolution_plan_offering[19] = 406224;
evolution_plan_item[19] = 74096;
evolution_plan_gold[19] = 15000;
evolution_plan_pet[19] = 406225;
evolution_plan_requirement[19] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[19] = 310001;

evolution_plan_name[20] = "���M�����ֶ�";
evolution_plan_offering[20] = 406229;
evolution_plan_item[20] = 74095;
evolution_plan_gold[20] = 5000;
evolution_plan_pet[20] = 406230;
evolution_plan_requirement[20] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[20] = 310101;

evolution_plan_name[21] = "���M�����ֿɶ�";
evolution_plan_offering[21] = 406230;
evolution_plan_item[21] = 74096;
evolution_plan_gold[21] = 15000;
evolution_plan_pet[21] = 406231;
evolution_plan_requirement[21] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[21] = 310102;

evolution_plan_name[22] = "���M���������F";
evolution_plan_offering[22] = 406232;
evolution_plan_item[22] = 74095;
evolution_plan_gold[22] = 5000;
evolution_plan_pet[22] = 406233;
evolution_plan_requirement[22] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[22] = 310007;

evolution_plan_name[23] = "���M���������׫F";
evolution_plan_offering[23] = 406233;
evolution_plan_item[23] = 74096;
evolution_plan_gold[23] = 15000;
evolution_plan_pet[23] = 406234;
evolution_plan_requirement[23] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[23] = 310008;

evolution_plan_name[24] = "���M����������F";
evolution_plan_offering[24] = 406234;
evolution_plan_item[24] = 74097;
evolution_plan_gold[24] = 50000;
evolution_plan_pet[24] = 406235;
evolution_plan_requirement[24] = {{CONST.����_�ȼ�,100}, {CONST.����_������,20}, {CONST.����_�˺���,500}, {CONST.����_ɱ����,200}};
evolution_plan_tech[24] = 310005;

evolution_plan_name[25] = "���M�����ͻ��";
evolution_plan_offering[25] = 406236;
evolution_plan_item[25] = 74095;
evolution_plan_gold[25] = 5000;
evolution_plan_pet[25] = 406237;
evolution_plan_requirement[25] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[25] = 310007;

evolution_plan_name[26] = "���M���������";
evolution_plan_offering[26] = 406237;
evolution_plan_item[26] = 74096;
evolution_plan_gold[26] = 15000;
evolution_plan_pet[26] = 406238;
evolution_plan_requirement[26] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[26] = 310008;

evolution_plan_name[27] = "���M�����M�������";
evolution_plan_offering[27] = 406238;
evolution_plan_item[27] = 74097;
evolution_plan_gold[27] = 50000;
evolution_plan_pet[27] = 406239;
evolution_plan_requirement[27] = {{CONST.����_�ȼ�,100}, {CONST.����_������,20}, {CONST.����_�˺���,500}, {CONST.����_ɱ����,200}};
evolution_plan_tech[27] = 310005;

evolution_plan_name[28] = "���M����ɭ������";
evolution_plan_offering[28] = 406240;
evolution_plan_item[28] = 74095;
evolution_plan_gold[28] = 5000;
evolution_plan_pet[28] = 406241;
evolution_plan_requirement[28] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[28] = 310107;

evolution_plan_name[29] = "���M����������";
evolution_plan_offering[29] = 406241;
evolution_plan_item[29] = 74096;
evolution_plan_gold[29] = 15000;
evolution_plan_pet[29] = 406242;
evolution_plan_requirement[29] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[29] = 310108;

evolution_plan_name[30] = "���M��������������";
evolution_plan_offering[30] = 406242;
evolution_plan_item[30] = 74097;
evolution_plan_gold[30] = 50000;
evolution_plan_pet[30] = 406243;
evolution_plan_requirement[30] = {{CONST.����_�ȼ�,100}, {CONST.����_������,10}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[30] = 310105;

evolution_plan_name[31] = "���M�������^��";
evolution_plan_offering[31] = 406244;
evolution_plan_item[31] = 74095;
evolution_plan_gold[31] = 5000;
evolution_plan_pet[31] = 406245;
evolution_plan_requirement[31] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[31] = 310101;

evolution_plan_name[32] = "���M�������R����";
evolution_plan_offering[32] = 406245;
evolution_plan_item[32] = 74096;
evolution_plan_gold[32] = 15000;
evolution_plan_pet[32] = 406246;
evolution_plan_requirement[32] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[32] = 310102;

evolution_plan_name[33] = "���M�����b�O���R����";
evolution_plan_offering[33] = 406246;
evolution_plan_item[33] = 74097;
evolution_plan_gold[33] = 50000;
evolution_plan_pet[33] = 406247;
evolution_plan_requirement[33] = {{CONST.����_�ȼ�,100}, {CONST.����_������,10}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[33] = 310105;

evolution_plan_name[34] = "���M����������";
evolution_plan_offering[34] = 406261;
evolution_plan_item[34] = 74095;
evolution_plan_gold[34] = 5000;
evolution_plan_pet[34] = 406262;
evolution_plan_requirement[34] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[34] = 310001;

evolution_plan_name[35] = "���M��������";
evolution_plan_offering[35] = 406262;
evolution_plan_item[35] = 74096;
evolution_plan_gold[35] = 15000;
evolution_plan_pet[35] = 406263;
evolution_plan_requirement[35] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[35] = 310002;

evolution_plan_name[36] = "���M�����M������";
evolution_plan_offering[36] = 406263;
evolution_plan_item[36] = 74097;
evolution_plan_gold[36] = 50000;
evolution_plan_pet[36] = 406264;
evolution_plan_requirement[36] = {{CONST.����_�ȼ�,100}, {CONST.����_������,10}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[36] = 310005;

evolution_plan_name[37] = "���M�������ع�";
evolution_plan_offering[37] = 406268;
evolution_plan_item[37] = 74095;
evolution_plan_gold[37] = 5000;
evolution_plan_pet[37] = 406269;
evolution_plan_requirement[37] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[37] = 310001;

evolution_plan_name[38] = "���M�����M�����ع�";
evolution_plan_offering[38] = 406269;
evolution_plan_item[38] = 74096;
evolution_plan_gold[38] = 15000;
evolution_plan_pet[38] = 406270;
evolution_plan_requirement[38] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[38] = 310002;

evolution_plan_name[39] = "���M�����p����˹";
evolution_plan_offering[39] = 406271;
evolution_plan_item[39] = 74095;
evolution_plan_gold[39] = 5000;
evolution_plan_pet[39] = 406272;
evolution_plan_requirement[39] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[39] = 310101;

evolution_plan_name[40] = "���M�����M���p����˹";
evolution_plan_offering[40] = 406272;
evolution_plan_item[40] = 74096;
evolution_plan_gold[40] = 15000;
evolution_plan_pet[40] = 406273;
evolution_plan_requirement[40] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[40] = 310102;

evolution_plan_name[41] = "���M����������";
evolution_plan_offering[41] = 406274;
evolution_plan_item[41] = 74095;
evolution_plan_gold[41] = 5000;
evolution_plan_pet[41] = 406275;
evolution_plan_requirement[41] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[41] = 310107;

evolution_plan_name[42] = "���M����������";
evolution_plan_offering[42] = 406275;
evolution_plan_item[42] = 74096;
evolution_plan_gold[42] = 15000;
evolution_plan_pet[42] = 406276;
evolution_plan_requirement[42] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[42] = 310108;

evolution_plan_name[43] = "���M����荽�Ϭ�F";
evolution_plan_offering[43] = 406278;
evolution_plan_item[43] = 74095;
evolution_plan_gold[43] = 5000;
evolution_plan_pet[43] = 406279;
evolution_plan_requirement[43] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[43] = 310104;

evolution_plan_name[44] = "���M�������׿�Ϭ";
evolution_plan_offering[44] = 406279;
evolution_plan_item[44] = 74096;
evolution_plan_gold[44] = 15000;
evolution_plan_pet[44] = 406280;
evolution_plan_requirement[44] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[44] = 310105;

evolution_plan_name[45] = "���M�����p������";
evolution_plan_offering[45] = 406281;
evolution_plan_item[45] = 74096;
evolution_plan_gold[45] = 15000;
evolution_plan_pet[45] = 406282;
evolution_plan_requirement[45] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[45] = 310104;

evolution_plan_name[46] = "���M����·�����W";
evolution_plan_offering[46] = 406283;
evolution_plan_item[46] = 74095;
evolution_plan_gold[46] = 5000;
evolution_plan_pet[46] = 406284;
evolution_plan_requirement[46] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[46] = 310001;

evolution_plan_name[47] = "���M��������·�����W";
evolution_plan_offering[47] = 406284;
evolution_plan_item[47] = 74096;
evolution_plan_gold[47] = 15000;
evolution_plan_pet[47] = 406285;
evolution_plan_requirement[47] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[47] = 310002;

evolution_plan_name[48] = "���M�������O·�����W";
evolution_plan_offering[48] = 406285;
evolution_plan_item[48] = 74097;
evolution_plan_gold[48] = 50000;
evolution_plan_pet[48] = 406286;
evolution_plan_requirement[48] = {{CONST.����_�ȼ�,100}, {CONST.����_������,10}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[48] = 310005;

evolution_plan_name[49] = "���M��������h";
evolution_plan_offering[49] = 406287;
evolution_plan_item[49] = 74095;
evolution_plan_gold[49] = 5000;
evolution_plan_pet[49] = 406288;
evolution_plan_requirement[49] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[49] = 310107;

evolution_plan_name[50] = "���M������������h";
evolution_plan_offering[50] = 406288;
evolution_plan_item[50] = 74096;
evolution_plan_gold[50] = 15000;
evolution_plan_pet[50] = 406289;
evolution_plan_requirement[50] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[50] = 310108;

evolution_plan_name[51] = "���M������ɽ��";
evolution_plan_offering[51] = 406290;
evolution_plan_item[51] = 74096;
evolution_plan_gold[51] = 15000;
evolution_plan_pet[51] = 406291;
evolution_plan_requirement[51] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[51] = 310105;

evolution_plan_name[52] = "���M�����M��������˹";
evolution_plan_offering[52] = 406292;
evolution_plan_item[52] = 74095;
evolution_plan_gold[52] = 5000;
evolution_plan_pet[52] = 406293;
evolution_plan_requirement[52] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[52] = 310101;

evolution_plan_name[53] = "���M��������������˹";
evolution_plan_offering[53] = 406293;
evolution_plan_item[53] = 74096;
evolution_plan_gold[53] = 15000;
evolution_plan_pet[53] = 406294;
evolution_plan_requirement[53] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[53] = 310102;

evolution_plan_name[54] = "���M���������˹";
evolution_plan_offering[54] = 406295;
evolution_plan_item[54] = 74095;
evolution_plan_gold[54] = 5000;
evolution_plan_pet[54] = 406296;
evolution_plan_requirement[54] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[54] = 310104;

evolution_plan_name[55] = "���M�������������˹";
evolution_plan_offering[55] = 406296;
evolution_plan_item[55] = 74096;
evolution_plan_gold[55] = 15000;
evolution_plan_pet[55] = 406297;
evolution_plan_requirement[55] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[55] = 310105;

evolution_plan_name[56] = "���M����������";
evolution_plan_offering[56] = 406298;
evolution_plan_item[56] = 74095;
evolution_plan_gold[56] = 5000;
evolution_plan_pet[56] = 406299;
evolution_plan_requirement[56] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[56] = 310107;

evolution_plan_name[57] = "���M��������������";
evolution_plan_offering[57] = 406299;
evolution_plan_item[57] = 74096;
evolution_plan_gold[57] = 15000;
evolution_plan_pet[57] = 406300;
evolution_plan_requirement[57] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[57] = 310005;

evolution_plan_name[58] = "���M����������ʯ����";
evolution_plan_offering[58] = 406322;
evolution_plan_item[58] = 74095;
evolution_plan_gold[58] = 5000;
evolution_plan_pet[58] = 406323;
evolution_plan_requirement[58] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[58] = 310105;

evolution_plan_name[59] = "���M����������ʯ����";
evolution_plan_offering[59] = 406323;
evolution_plan_item[59] = 74096;
evolution_plan_gold[59] = 15000;
evolution_plan_pet[59] = 406324;
evolution_plan_requirement[59] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[59] = 310005;

evolution_plan_name[60] = "���M����ƤƤ";
evolution_plan_offering[60] = 406325;
evolution_plan_item[60] = 74095;
evolution_plan_gold[60] = 5000;
evolution_plan_pet[60] = 406326;
evolution_plan_requirement[60] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[60] = 310110;

evolution_plan_name[61] = "���M����Ƥ����";
evolution_plan_offering[61] = 406326;
evolution_plan_item[61] = 74096;
evolution_plan_gold[61] = 15000;
evolution_plan_pet[61] = 406327;
evolution_plan_requirement[61] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[61] = 310111;

evolution_plan_name[62] = "���M����������";
evolution_plan_offering[62] = 406328;
evolution_plan_item[62] = 74095;
evolution_plan_gold[62] = 5000;
evolution_plan_pet[62] = 406329;
evolution_plan_requirement[62] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[62] = 310109;

evolution_plan_name[63] = "���M�������";
evolution_plan_offering[63] = 406329;
evolution_plan_item[63] = 74096;
evolution_plan_gold[63] = 15000;
evolution_plan_pet[63] = 406330;
evolution_plan_requirement[63] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[63] = 310010;

evolution_plan_name[64] = "���M�����������";
evolution_plan_offering[64] = 406330;
evolution_plan_item[64] = 74097;
evolution_plan_gold[64] = 50000;
evolution_plan_pet[64] = 406331;
evolution_plan_requirement[64] = {{CONST.����_�ȼ�,100}, {CONST.����_������,10}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[64] = 310011;

evolution_plan_name[65] = "���M��������";
evolution_plan_offering[65] = 406332;
evolution_plan_item[65] = 74095;
evolution_plan_gold[65] = 5000;
evolution_plan_pet[65] = 406333;
evolution_plan_requirement[65] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[65] = 310001;

evolution_plan_name[66] = "���M��������";
evolution_plan_offering[66] = 406333;
evolution_plan_item[66] = 74096;
evolution_plan_gold[66] = 15000;
evolution_plan_pet[66] = 406334;
evolution_plan_requirement[66] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[66] = 310002;

evolution_plan_name[67] = "���M�����Lβ���";
evolution_plan_offering[67] = 406335;
evolution_plan_item[67] = 74095;
evolution_plan_gold[67] = 5000;
evolution_plan_pet[67] = 406336;
evolution_plan_requirement[67] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[67] = 310007;

evolution_plan_name[68] = "���M��������t��";
evolution_plan_offering[68] = 406336;
evolution_plan_item[68] = 74096;
evolution_plan_gold[68] = 15000;
evolution_plan_pet[68] = 406337;
evolution_plan_requirement[68] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[68] = 310008;

evolution_plan_name[69] = "���M�����������";
evolution_plan_offering[69] = 406338;
evolution_plan_item[69] = 74095;
evolution_plan_gold[69] = 5000;
evolution_plan_pet[69] = 406339;
evolution_plan_requirement[69] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[69] = 310104;

evolution_plan_name[70] = "���M������ҧ���";
evolution_plan_offering[70] = 406339;
evolution_plan_item[70] = 74096;
evolution_plan_gold[70] = 15000;
evolution_plan_pet[70] = 406340;
evolution_plan_requirement[70] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[70] = 310105;

evolution_plan_name[71] = "���M����������ʿ�ɶ���";
evolution_plan_offering[71] = 406344;
evolution_plan_item[71] = 74095;
evolution_plan_gold[71] = 5000;
evolution_plan_pet[71] = 406345;
evolution_plan_requirement[71] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[71] = 310002;

evolution_plan_name[72] = "���M�������O��ʿ�ɶ���";
evolution_plan_offering[72] = 406345;
evolution_plan_item[72] = 74096;
evolution_plan_gold[72] = 15000;
evolution_plan_pet[72] = 406346;
evolution_plan_requirement[72] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[72] = 310105;


evolution_plan_name[73] = "���M����������������";
evolution_plan_offering[73] = 406362;
evolution_plan_item[73] = 74097;
evolution_plan_gold[73] = 30000;
evolution_plan_pet[73] = 406363;
evolution_plan_requirement[73] = {{CONST.����_�ȼ�,85}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[73] = 310210;

evolution_plan_name[74] = "���M����������·�׶�";
evolution_plan_offering[74] = 406366;
evolution_plan_item[74] = 74097;
evolution_plan_gold[74] = 30000;
evolution_plan_pet[74] = 406367;
evolution_plan_requirement[74] = {{CONST.����_�ȼ�,85}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[74] = 310201;

evolution_plan_name[75] = "���M��������霺���ķ";
evolution_plan_offering[75] = 406368;
evolution_plan_item[75] = 74097;
evolution_plan_gold[75] = 30000;
evolution_plan_pet[75] = 406369;
evolution_plan_requirement[75] = {{CONST.����_�ȼ�,85}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[75] = 310210;

evolution_plan_name[76] = "���M�������������ķ";
evolution_plan_offering[76] = 406388;
evolution_plan_item[76] = 74097;
evolution_plan_gold[76] = 30000;
evolution_plan_pet[76] = 406389;
evolution_plan_requirement[76] = {{CONST.����_�ȼ�,85}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[76] = 310310;

evolution_plan_name[77] = "���M�������������˹";
evolution_plan_offering[77] = 406370;
evolution_plan_item[77] = 74097;
evolution_plan_gold[77] = 30000;
evolution_plan_pet[77] = 406371;
evolution_plan_requirement[77] = {{CONST.����_�ȼ�,85}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[77] = 310210;

evolution_plan_name[78] = "���M��������������";
evolution_plan_offering[78] = 406374;
evolution_plan_item[78] = 74097;
evolution_plan_gold[78] = 30000;
evolution_plan_pet[78] = 406375;
evolution_plan_requirement[78] = {{CONST.����_�ȼ�,85}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[78] = 10628;

evolution_plan_name[79] = "���M��������������";
evolution_plan_offering[79] = 406376;
evolution_plan_item[79] = 74097;
evolution_plan_gold[79] = 30000;
evolution_plan_pet[79] = 406377;
evolution_plan_requirement[79] = {{CONST.����_�ȼ�,85}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[79] = 310207;

evolution_plan_name[80] = "���M������������B";
evolution_plan_offering[80] = 406381;
evolution_plan_item[80] = 74097;
evolution_plan_gold[80] = 30000;
evolution_plan_pet[80] = 406382;
evolution_plan_requirement[80] = {{CONST.����_�ȼ�,85}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[80] = 310201;

evolution_plan_name[81] = "���M���������ȿ�����";
evolution_plan_offering[81] = 406382;
evolution_plan_item[81] = 74097;
evolution_plan_gold[81] = 30000;
evolution_plan_pet[81] = 406383;
evolution_plan_requirement[81] = {{CONST.����_�ȼ�,85}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[81] = 10628;

evolution_plan_name[82] = "���M�����������";
evolution_plan_offering[82] = 406420;
evolution_plan_item[82] = 74097;
evolution_plan_gold[82] = 30000;
evolution_plan_pet[82] = 406421;
evolution_plan_requirement[82] = {{CONST.����_�ȼ�,85}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[82] = 310310;

evolution_plan_name[83] = "���M���������ٰ�ϣ";
evolution_plan_offering[83] = 406422;
evolution_plan_item[83] = 74097;
evolution_plan_gold[83] = 30000;
evolution_plan_pet[83] = 406423;
evolution_plan_requirement[83] = {{CONST.����_�ȼ�,85}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[83] = 310204;

evolution_plan_name[84] = "���M���������������_˹";
evolution_plan_offering[84] = 406440;
evolution_plan_item[84] = 74097;
evolution_plan_gold[84] = 30000;
evolution_plan_pet[84] = 406441;
evolution_plan_requirement[84] = {{CONST.����_�ȼ�,85}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[84] = 310307;

evolution_plan_name[85] = "���M���������޽��";
evolution_plan_offering[85] = 406448;
evolution_plan_item[85] = 74097;
evolution_plan_gold[85] = 30000;
evolution_plan_pet[85] = 406449;
evolution_plan_requirement[85] = {{CONST.����_�ȼ�,85}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[85] = 310310;

evolution_plan_name[86] = "���M�����������Q���";
evolution_plan_offering[86] = 406450;
evolution_plan_item[86] = 74097;
evolution_plan_gold[86] = 30000;
evolution_plan_pet[86] = 406451;
evolution_plan_requirement[86] = {{CONST.����_�ȼ�,85}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[86] = 10628;

evolution_plan_name[87] = "���M����������ҧ���";
evolution_plan_offering[87] = 406454;
evolution_plan_item[87] = 74097;
evolution_plan_gold[87] = 30000;
evolution_plan_pet[87] = 406455;
evolution_plan_requirement[87] = {{CONST.����_�ȼ�,85}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[87] = 310304;

evolution_plan_name[88] = "���M�����������񠖵�";
evolution_plan_offering[88] = 406446;
evolution_plan_item[88] = 74097;
evolution_plan_gold[88] = 30000;
evolution_plan_pet[88] = 406447;
evolution_plan_requirement[88] = {{CONST.����_�ȼ�,85}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[88] = 310307;

evolution_plan_name[89] = "���M������ź���";
evolution_plan_offering[89] = 406444;
evolution_plan_item[89] = 74097;
evolution_plan_gold[89] = 30000;
evolution_plan_pet[89] = 406445;
evolution_plan_requirement[89] = {{CONST.����_�ȼ�,85}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[89] = 310204;


evolution_plan_name[90] = "���M�����M��ѩ����";
evolution_plan_offering[90] = 406350;
evolution_plan_item[90] = 74096;
evolution_plan_gold[90] = 25000;
evolution_plan_pet[90] = 406351;
evolution_plan_requirement[90] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[90] = 6303;

evolution_plan_name[91] = "���M�������Oѩ����";
evolution_plan_offering[91] = 406351;
evolution_plan_item[91] = 74097;
evolution_plan_gold[91] = 60000;
evolution_plan_pet[91] = 406352;
evolution_plan_requirement[91] = {{CONST.����_�ȼ�,100}, {CONST.����_������,10}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[91] = 6306;

evolution_plan_name[92] = "���M�����M���׹�";
evolution_plan_offering[92] = 406256;
evolution_plan_item[92] = 74096;
evolution_plan_gold[92] = 25000;
evolution_plan_pet[92] = 406257;
evolution_plan_requirement[92] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[92] = 4203;

evolution_plan_name[93] = "���M�������O�׹�";
evolution_plan_offering[93] = 406257;
evolution_plan_item[93] = 74097;
evolution_plan_gold[93] = 60000;
evolution_plan_pet[93] = 406258;
evolution_plan_requirement[93] = {{CONST.����_�ȼ�,100}, {CONST.����_������,10}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[93] = 4206;

evolution_plan_name[94] = "���M�����M���׵�";
evolution_plan_offering[94] = 406316;
evolution_plan_item[94] = 74096;
evolution_plan_gold[94] = 25000;
evolution_plan_pet[94] = 406317;
evolution_plan_requirement[94] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[94] = 3803;

evolution_plan_name[95] = "���M�������O�׵�";
evolution_plan_offering[95] = 406317;
evolution_plan_item[95] = 74097;
evolution_plan_gold[95] = 60000;
evolution_plan_pet[95] = 406318;
evolution_plan_requirement[95] = {{CONST.����_�ȼ�,100}, {CONST.����_������,10}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[95] = 3806;

evolution_plan_name[96] = "���M�����M��ˮ��";
evolution_plan_offering[96] = 406319;
evolution_plan_item[96] = 74096;
evolution_plan_gold[96] = 25000;
evolution_plan_pet[96] = 406320;
evolution_plan_requirement[96] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[96] = 4003;

evolution_plan_name[97] = "���M�������Oˮ��";
evolution_plan_offering[97] = 406320;
evolution_plan_item[97] = 74097;
evolution_plan_gold[97] = 60000;
evolution_plan_pet[97] = 406321;
evolution_plan_requirement[97] = {{CONST.����_�ȼ�,100}, {CONST.����_������,10}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[97] = 4006;

evolution_plan_name[98] = "���M����ԭʼ������";
evolution_plan_offering[98] = 406301;
evolution_plan_item[98] = 74096;
evolution_plan_gold[98] = 25000;
evolution_plan_pet[98] = 406302;
evolution_plan_requirement[98] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[98] = 5004;

evolution_plan_name[99] = "���M�������O������";
evolution_plan_offering[99] = 406302;
evolution_plan_item[99] = 74097;
evolution_plan_gold[99] = 60000;
evolution_plan_pet[99] = 406303;
evolution_plan_requirement[99] = {{CONST.����_�ȼ�,100}, {CONST.����_������,10}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[99] = 5008;

evolution_plan_name[100] = "���M����ԭʼ�w�W��";
evolution_plan_offering[100] = 406304;
evolution_plan_item[100] = 74096;
evolution_plan_gold[100] = 25000;
evolution_plan_pet[100] = 406305;
evolution_plan_requirement[100] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[100] = 5104;

evolution_plan_name[101] = "���M�������O�w�W��";
evolution_plan_offering[101] = 406305;
evolution_plan_item[101] = 74097;
evolution_plan_gold[101] = 60000;
evolution_plan_pet[101] = 406306;
evolution_plan_requirement[101] = {{CONST.����_�ȼ�,100}, {CONST.����_������,10}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[101] = 5108;

evolution_plan_name[102] = "���M���������ҿ���";
evolution_plan_offering[102] = 406253;
evolution_plan_item[102] = 74096;
evolution_plan_gold[102] = 25000;
evolution_plan_pet[102] = 406254;
evolution_plan_requirement[102] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[102] = 5304;

evolution_plan_name[103] = "���M�������O�ҿ���";
evolution_plan_offering[103] = 406254;
evolution_plan_item[103] = 74097;
evolution_plan_gold[103] = 60000;
evolution_plan_pet[103] = 406255;
evolution_plan_requirement[103] = {{CONST.����_�ȼ�,100}, {CONST.����_������,10}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[103] = 5308;

evolution_plan_name[104] = "���M�����e�N�T���ۼ{";
evolution_plan_offering[104] = 406313;
evolution_plan_item[104] = 74096;
evolution_plan_gold[104] = 25000;
evolution_plan_pet[104] = 406314;
evolution_plan_requirement[104] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[104] = 5204;

evolution_plan_name[105] = "���M�����M���T���ۼ{";
evolution_plan_offering[105] = 406314;
evolution_plan_item[105] = 74097;
evolution_plan_gold[105] = 60000;
evolution_plan_pet[105] = 406315;
evolution_plan_requirement[105] = {{CONST.����_�ȼ�,100}, {CONST.����_������,10}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[105] = 5208;

evolution_plan_name[106] = "���M�������O�׼���˹";
evolution_plan_offering[106] = 406259;
evolution_plan_item[106] = 74097;
evolution_plan_gold[106] = 60000;
evolution_plan_pet[106] = 406260;
evolution_plan_requirement[106] = {{CONST.����_�ȼ�,100}, {CONST.����_������,10}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[106] = 5906;

evolution_plan_name[107] = "���M�����M�������R��";
evolution_plan_offering[107] = 406307;
evolution_plan_item[107] = 74096;
evolution_plan_gold[107] = 25000;
evolution_plan_pet[107] = 406308;
evolution_plan_requirement[107] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[107] = 6703;

evolution_plan_name[108] = "���M�������O�����R��";
evolution_plan_offering[108] = 406308;
evolution_plan_item[108] = 74097;
evolution_plan_gold[108] = 60000;
evolution_plan_pet[108] = 406309;
evolution_plan_requirement[108] = {{CONST.����_�ȼ�,100}, {CONST.����_������,10}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[108] = 6706;

evolution_plan_name[109] = "���M�����M����·�恆";
evolution_plan_offering[109] = 406310;
evolution_plan_item[109] = 74096;
evolution_plan_gold[109] = 25000;
evolution_plan_pet[109] = 406311;
evolution_plan_requirement[109] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[109] = 6803;

evolution_plan_name[110] = "���M�������O��·�恆";
evolution_plan_offering[110] = 406311;
evolution_plan_item[110] = 74097;
evolution_plan_gold[110] = 60000;
evolution_plan_pet[110] = 406312;
evolution_plan_requirement[110] = {{CONST.����_�ȼ�,100}, {CONST.����_������,10}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[110] = 6806;
-------------------------------------------------
local function calcWarp()
  local page = math.modf(#evolution_plan_name / 8) + 1
  local remainder = math.fmod(#evolution_plan_name, 8)
  return page, remainder
end

--Զ�̰�ťUI����
function Module:evolutionPlansInfo(npc, player)
          local winButton = CONST.BUTTON_�ر�;
          local msg = "1\\n�����������������������M���A�[��\\n"
          for i = 1,8 do
             msg = msg .. "�������Ŀ "..i.."��".. evolution_plan_name[i] .. "\\n"
             if (i>=8) then
                 winButton = CONST.BUTTON_��ȡ��;
             end
          end
          NLG.ShowWindowTalked(player, self.evolutionerNPC, CONST.����_ѡ���, winButton, 1, msg);
end

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load');
  self.evolutionerNPC = self:NPC_createNormal('�����M������', 400416, { x = 106, y = 108, mapType = 0, map = 80010, direction = 6 });
  self:NPC_regWindowTalkedEvent(self.evolutionerNPC, function(npc, player, _seqno, _select, _data)
    local column = tonumber(_data)
    local page = tonumber(_seqno)
    local warpPage = page;
    local winMsg = "1\\n�����������������������M���A�[��\\n"
    local winButton = CONST.BUTTON_�ر�;
    local totalPage, remainder = calcWarp()
    --��ҳ16 ��ҳ32 �ر�/ȡ��2
    if _select > 0 then
      if _select == CONST.��ť_ȷ�� then
          if (page>=1001) then
              local seqno = page - 1000;
              local msg = "�����������������������M���A�[��\\n"
              local msg = msg .. evolutionOfferingInfo(seqno)
              NLG.ShowWindowTalked(player, self.evolutionerNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 2000+seqno, msg);
              return
          else
              return
          end
      elseif _select == CONST.��ť_�ر� then
          if (page>=1001) then
              local winPage_temp = page - 1000;
              --ҳ����¼
              local page_temp = math.modf(winPage_temp / 8) + 1;
              if (math.fmod(winPage_temp,8)==0) then page_temp=page_temp-1; end
              --��ʼ��һ�б��
              local count_temp = 8 * (page_temp - 1)	
              --print(page,winPage_temp,page_temp,count_temp)

              local winButton = CONST.BUTTON_�ر�;
              local msg = "1\\n�����������������������M���A�[��\\n"
              if page_temp == totalPage then
                for i = 1 + count_temp, remainder + count_temp do
                    msg = msg .. "�������Ŀ "..i.."��".. evolution_plan_name[i] .. "\\n"
                end
              else
                for i = 1 + count_temp, 8 + count_temp do
                    msg = msg .. "�������Ŀ "..i.."��".. evolution_plan_name[i] .. "\\n"
                end
              end
              if page_temp == 1 then
                winButton = CONST.BUTTON_��ȡ��
              elseif page_temp == totalPage then
                winButton = CONST.BUTTON_��ȡ��
              else
                winButton = CONST.BUTTON_����ȡ��
              end
              NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, winButton, page_temp, msg);
              return
          else
              return
          end
      elseif _select == CONST.��ť_�� then
          if (page>=2001) then
              local seqno = page - 2000;
              local petSlot = Char.HavePet(player, evolution_plan_offering[seqno])
              evolutionMutation(seqno,player,petSlot)
              NLG.UpChar(player);
              return
          else
              return
          end
      elseif _select == CONST.��ť_�� then
          if (page>=2001) then
              local count = page - 2000;
              local msg = "�����������������������M���A�[��\\n"
              local msg = msg .. convertGoalInfo(count);
              NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 1000+count, msg);
              return
          else
              return
          end
      end
      if _select == CONST.BUTTON_��һҳ then
        warpPage = warpPage + 1
        if (warpPage == totalPage) or ((warpPage == (totalPage - 1) and remainder == 0)) then
          winButton = CONST.BUTTON_��ȡ��
        else
          winButton = CONST.BUTTON_����ȡ��
        end
      elseif _select == CONST.BUTTON_��һҳ then
        warpPage = warpPage - 1
        if warpPage == 1 then
          winButton = CONST.BUTTON_��ȡ��
        else
          winButton = CONST.BUTTON_����ȡ��
        end
      elseif _select == 2 then
        warpPage = 1
        return
      end
      local count = 8 * (warpPage - 1)
      if warpPage == totalPage then
        for i = 1 + count, remainder + count do
            winMsg = winMsg .. "�������Ŀ "..i.."��".. evolution_plan_name[i] .. "\\n"
        end
      else
        for i = 1 + count, 8 + count do
            winMsg = winMsg .. "�������Ŀ "..i.."��".. evolution_plan_name[i] .. "\\n"
        end
      end
      NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, winButton, warpPage, winMsg);
    else
      local count = 8 * (warpPage - 1) + column
      --print(count)
      local msg = "�����������������������M���A�[��\\n"
      local msg = msg .. convertGoalInfo(count);
      NLG.ShowWindowTalked(player, self.evolutionerNPC, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 1000+count, msg);
    end
  end)
  self:NPC_regTalkedEvent(self.evolutionerNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local winButton = CONST.BUTTON_�ر�;
      local msg = "1\\n�����������������������M���A�[��\\n"
      for i = 1,8 do
         msg = msg .. "�������Ŀ "..i.."��".. evolution_plan_name[i] .. "\\n"
         if (i>=8) then
             winButton = CONST.BUTTON_��ȡ��;
         end
      end
      NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, winButton, 1, msg);
    end
    return
  end)
end

---------------------------------------------------------------------------------------------------------------
--Ŀ����Ϣ
function convertGoalInfo(count)
      local EnemyDataIndex_Goal = Data.EnemyGetDataIndex(evolution_plan_pet[count]);
      local enemyBaseId_Goal = Data.EnemyGetData(EnemyDataIndex_Goal, CONST.Enemy_Base���);
      local EnemyBaseDataIndex_Goal = Data.EnemyBaseGetDataIndex(enemyBaseId_Goal);
      local Goal_name = Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_����);
      local Goal_DataPos_3 = Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_����);
      local Goal_DataPos_3 = Tribe(Goal_DataPos_3);
      local Goal_DataPos_4 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_����);
      local Goal_DataPos_5 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_����);
      local Goal_DataPos_6 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_ǿ��);
      local Goal_DataPos_7 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_�ٶ�);
      local Goal_DataPos_8 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, 8);
      local Goal_DataPos_12 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_����);
      local Goal_DataPos_13 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_��ɱ);
      local Goal_DataPos_14 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_������);
      local Goal_DataPos_15 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_ˮ����);
      local Goal_DataPos_16 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_������);
      local Goal_DataPos_17 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_������);
      local Goal_DataPos_18 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_����);
      local Goal_DataPos_19 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_����);
      local Goal_DataPos_20 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_��˯);
      local Goal_DataPos_21 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_������);
      local Goal_DataPos_22 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_��ʯ��);
      local Goal_DataPos_23 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_������);
      local Goal_DataPos_26 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_����);
      local Goal_DataPos_27 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_����);
      local Goal_DataPos_28 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_������);
      local Goal_DataPos_29 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_����);
      local imageText = "@g,"..Goal_DataPos_29..",2,8,6,0@"
      local Goal_DataPos_35 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_��������1);
      local Goal_DataPos_36 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_��������2);
      local Goal_DataPos_37 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_��������3);
      local Goal_DataPos_38 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_��������4);
      local Goal_DataPos_39 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_��������5);
      local Goal_DataPos_40 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_��������6);
      local Goal_DataPos_41 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_��������7);
      local Goal_DataPos_42 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_��������8);
      local Goal_DataPos_43 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_��������9);
      local Goal_DataPos_44 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_��������10);
      local TechIndex = Tech.GetTechIndex(evolution_plan_tech[count]);
      local TechName = Tech.GetData(TechIndex, CONST.TECH_NAME);
      local msg = imageText .. "����$4".. Goal_name .. "\\n"
                         .. "��������������" .. "$1�w�� ".. Goal_DataPos_4+2 .."��" .. "$8�ؚ� ".. Goal_DataPos_13 .."��" .. "$8���� ".. Goal_DataPos_27 .."\\n"
                         .. "��������������" .. "$1���� ".. Goal_DataPos_5+2 .."��" .. "$8���� ".. Goal_DataPos_12 .."��" .. "$8�W�� ".. Goal_DataPos_26 .."\\n"
                         .. "��������������" .. "$1���� ".. Goal_DataPos_6+2 .."��" .. "$2���� ".. Goal_DataPos_18 .."��" .. "$2���� ".. Goal_DataPos_19 .."\\n"
                         .. "��������������" .. "$1�ٶ� ".. Goal_DataPos_7+2 .."��" .. "$2��˯ ".. Goal_DataPos_20 .."��" .. "$2���� ".. Goal_DataPos_21 .."\\n"
                         .. "��������������" .. "$1ħ�� ".. Goal_DataPos_8+2 .."��" .. "$2��ʯ ".. Goal_DataPos_22 .."��" .. "$2���� ".. Goal_DataPos_23 .."\\n"
                         .. "��������������" .. "$5�� ".. Goal_DataPos_14/10 .."��" .."$5ˮ ".. Goal_DataPos_15/10 .."��" .."$5�� ".. Goal_DataPos_16/10 .."��" .."$5�L ".. Goal_DataPos_17/10 .."\\n"
                         .. "��������������" .. "$9�N�� ".. Goal_DataPos_3 .."��" .. "$9���� ".. TechName .."\\n"
      return msg;
end

--��Ʒ��Ϣ
function evolutionOfferingInfo(seqno)
              local msg = "";
              local EnemyDataIndex_1 = Data.EnemyGetDataIndex(evolution_plan_offering[seqno]);
              local enemyBaseId_1 = Data.EnemyGetData(EnemyDataIndex_1, CONST.Enemy_Base���);
              local EnemyBaseDataIndex_1 = Data.EnemyBaseGetDataIndex(enemyBaseId_1);
              --local offering_name_1 = Data.EnemyBaseGetData(EnemyBaseDataIndex_1, CONST.EnemyBase_����);
              local offering_image_1 = Data.EnemyBaseGetData(EnemyBaseDataIndex_1, CONST.EnemyBase_����);
              local EnemyDataIndex_3 = Data.EnemyGetDataIndex(evolution_plan_pet[seqno]);
              local enemyBaseId_3 = Data.EnemyGetData(EnemyDataIndex_3, CONST.Enemy_Base���);
              local EnemyBaseDataIndex_3 = Data.EnemyBaseGetDataIndex(enemyBaseId_3);
              --local offering_name_3 = Data.EnemyBaseGetData(EnemyBaseDataIndex_3, CONST.EnemyBase_����);
              local offering_image_3 = Data.EnemyBaseGetData(EnemyBaseDataIndex_3, CONST.EnemyBase_����);
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

              local msg = msg .. "\\n\\n\\n\\n\\n\\n��$5����: ".. Item_name .. "1��" .. "����$5ħ��: " .. Gold .. " G\\n"
                                              .. "��$4��l��:\\n"
                                              .. "��$4�ȼ�".. level .. "�� ����" .. dead_num .. "�� ����" .. hit_num .. "�� ����" .. kill_num .. "��"
      return msg;
end

--����ִ��
function evolutionMutation(seqno,player,petSlot)
              if (Char.ItemNum(player, evolution_plan_item[seqno])==0) then
                  NLG.SystemMessage(player,"[ϵ�y]ȱ���M����ʯ�^��");
                  return
              end
              if (Char.GetData(player, CONST.����_���)<evolution_plan_gold[seqno]) then
                  NLG.SystemMessage(player,"[ϵ�y]�M��������Ų��㡣");
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
                      NLG.SystemMessage(player,"[ϵ�y]ȱ���M�����茙�");
                      return
                end
                if ( level_num < evolution_plan_requirement[seqno][1][2] ) then
                      NLG.SystemMessage(player,"[ϵ�y]�ȼ�δ�_�M���˜ʡ�");
                      return
                end
                if ( dead_num < evolution_plan_requirement[seqno][2][2] ) then
                      NLG.SystemMessage(player,"[ϵ�y]����������"..dead_num.."δ�_�M���˜ʡ�");
                      return
                end
                if ( hit_num < evolution_plan_requirement[seqno][3][2] ) then
                      NLG.SystemMessage(player,"[ϵ�y]���������"..hit_num.."δ�_�M���˜ʡ�");
                      return
                end
                if ( kill_num < evolution_plan_requirement[seqno][4][2] ) then
                      NLG.SystemMessage(player,"[ϵ�y]�������"..kill_num.."δ�_�M���˜ʡ�");
                      return
                end
              else
                      NLG.SystemMessage(player,"[ϵ�y]ȱ���M�����茙�");
                      return
              end
              Char.DelItem(player, evolution_plan_item[seqno], 1);
              Char.AddGold(player, -evolution_plan_gold[seqno]);

              --���μ�¼
              local a6, a1, a2, a3, a4, a5 = Char.GetPetRank(player,petSlot);
              -- ���＼�ܼ�¼
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

              --�����������ԭ����ͬ
              local evolution_petIndex = Char.GetPet(player,petSlot);
              Pet.SetArtRank(evolution_petIndex, CONST.PET_���,  Pet.FullArtRank(evolution_petIndex, CONST.PET_���) - a1 );
              Pet.SetArtRank(evolution_petIndex, CONST.PET_����,  Pet.FullArtRank(evolution_petIndex, CONST.PET_����) - a2 );
              Pet.SetArtRank(evolution_petIndex, CONST.PET_ǿ��,  Pet.FullArtRank(evolution_petIndex, CONST.PET_ǿ��) - a3 );
              Pet.SetArtRank(evolution_petIndex, CONST.PET_����,  Pet.FullArtRank(evolution_petIndex, CONST.PET_����) - a4 );
              Pet.SetArtRank(evolution_petIndex, CONST.PET_ħ��,  Pet.FullArtRank(evolution_petIndex, CONST.PET_ħ��) - a5 );
              Pet.ReBirth(player, evolution_petIndex);
              Pet.UpPet(player, evolution_petIndex);

              local arr_rank1_new = Pet.GetArtRank(evolution_petIndex,CONST.PET_���);
              local arr_rank2_new = Pet.GetArtRank(evolution_petIndex,CONST.PET_����);
              local arr_rank3_new = Pet.GetArtRank(evolution_petIndex,CONST.PET_ǿ��);
              local arr_rank4_new = Pet.GetArtRank(evolution_petIndex,CONST.PET_����);
              local arr_rank5_new = Pet.GetArtRank(evolution_petIndex,CONST.PET_ħ��);

              if(Level~=1) then
                Char.SetData(evolution_petIndex,CONST.����_������,Level-1);
                Char.SetData(evolution_petIndex,CONST.����_�ȼ�,Level);
                Char.SetData(evolution_petIndex,CONST.����_����, (Char.GetData(evolution_petIndex,CONST.����_����) + (arr_rank1_new * (1/24) * (Level - 1)*100)) );
                Char.SetData(evolution_petIndex,CONST.����_����, (Char.GetData(evolution_petIndex,CONST.����_����) + (arr_rank2_new * (1/24) * (Level - 1)*100)) );
                Char.SetData(evolution_petIndex,CONST.����_ǿ��, (Char.GetData(evolution_petIndex,CONST.����_ǿ��) + (arr_rank3_new * (1/24) * (Level - 1)*100)) );
                Char.SetData(evolution_petIndex,CONST.����_�ٶ�, (Char.GetData(evolution_petIndex,CONST.����_�ٶ�) + (arr_rank4_new * (1/24) * (Level - 1)*100)) );
                Char.SetData(evolution_petIndex,CONST.����_ħ��, (Char.GetData(evolution_petIndex,CONST.����_ħ��) + (arr_rank5_new * (1/24) * (Level - 1)*100)) );
                Pet.UpPet(player,evolution_petIndex);
              end
              -- ���＼��
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

--���μ���
Char.GetPetRank = function(playerIndex,slot)
  local petIndex = Char.GetPet(playerIndex, slot);
  if petIndex >= 0 then
    local arr_rank1 = Pet.GetArtRank(petIndex,CONST.PET_���);
    local arr_rank2 = Pet.GetArtRank(petIndex,CONST.PET_����);
    local arr_rank3 = Pet.GetArtRank(petIndex,CONST.PET_ǿ��);
    local arr_rank4 = Pet.GetArtRank(petIndex,CONST.PET_����);
    local arr_rank5 = Pet.GetArtRank(petIndex,CONST.PET_ħ��);
    local arr_rank11 = Pet.FullArtRank(petIndex, CONST.PET_���);
    local arr_rank21 = Pet.FullArtRank(petIndex, CONST.PET_����);
    local arr_rank31 = Pet.FullArtRank(petIndex, CONST.PET_ǿ��);
    local arr_rank41 = Pet.FullArtRank(petIndex, CONST.PET_����);
    local arr_rank51 = Pet.FullArtRank(petIndex, CONST.PET_ħ��);
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

--�����ַ���ת��
function Tribe(Tribe)
  if Tribe==0 then
    return "����ϵ"
  elseif Tribe == 1 then
    return "����ϵ"
  elseif Tribe == 2 then
    return "����ϵ"
  elseif Tribe == 3 then
    return "�w��ϵ"
  elseif Tribe == 4 then
    return "���xϵ"
  elseif Tribe == 5 then
    return "ֲ��ϵ"
  elseif Tribe == 6 then
    return "Ұ�Fϵ"
  elseif Tribe == 7 then
    return "����ϵ"
  elseif Tribe == 8 then
    return "����ϵ"
  elseif Tribe == 9 then
    return "аħϵ"
  elseif Tribe == 10 then
    return "����ϵ"
  elseif Tribe == 11 then
    return "���`ϵ"
  end
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
