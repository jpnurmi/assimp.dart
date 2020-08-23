/*
---------------------------------------------------------------------------
Open Asset Import Library (assimp)
---------------------------------------------------------------------------

Copyright (c) 2006-2019, assimp team



All rights reserved.

Redistribution and use of this software in source and binary forms,
with or without modification, are permitted provided that the following
conditions are met:

* Redistributions of source code must retain the above
  copyright notice, this list of conditions and the
  following disclaimer.

* Redistributions in binary form must reproduce the above
  copyright notice, this list of conditions and the
  following disclaimer in the documentation and/or other
  materials provided with the distribution.

* Neither the name of the assimp team, nor the names of its
  contributors may be used to endorse or promote products
  derived from this software without specific prior
  written permission of the assimp team.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
---------------------------------------------------------------------------
*/

import 'dart:ffi';

import 'package:ffi/ffi.dart';

// ignore_for_file: unused_field

// pahole libassimpd.so -M -C aiString
class aiString extends Struct {
  static Pointer<aiString> alloc() => allocate<aiString>()..ref.length = 0;

  // ai_uint32                  length;               /*     0     4 */
  @Uint32() // ai_uint32
  int length;

  // char                       data[1024];           /*     4  1024 */
  Pointer<Utf8> get data => Pointer<Utf8>.fromAddress(addressOf.address + 4);

  @Uint8()
  int _d0, _d1, _d2, _d3, _d4, _d5, _d6, _d7;
  @Uint8()
  int _d8, _d9, _d10, _d11, _d12, _d13, _d14, _d15;
  @Uint8()
  int _d16, _d17, _d18, _d19, _d20, _d21, _d22, _d23;
  @Uint8()
  int _d24, _d25, _d26, _d27, _d28, _d29, _d30, _d31;
  @Uint8()
  int _d32, _d33, _d34, _d35, _d36, _d37, _d38, _d39;
  @Uint8()
  int _d40, _d41, _d42, _d43, _d44, _d45, _d46, _d47;
  @Uint8()
  int _d48, _d49, _d50, _d51, _d52, _d53, _d54, _d55;
  @Uint8()
  int _d56, _d57, _d58, _d59, _d60, _d61, _d62, _d63;
  @Uint8()
  int _d64, _d65, _d66, _d67, _d68, _d69, _d70, _d71;
  @Uint8()
  int _d72, _d73, _d74, _d75, _d76, _d77, _d78, _d79;
  @Uint8()
  int _d80, _d81, _d82, _d83, _d84, _d85, _d86, _d87;
  @Uint8()
  int _d88, _d89, _d90, _d91, _d92, _d93, _d94, _d95;
  @Uint8()
  int _d96, _d97, _d98, _d99, _d100, _d101, _d102, _d103;
  @Uint8()
  int _d104, _d105, _d106, _d107, _d108, _d109, _d110, _d111;
  @Uint8()
  int _d112, _d113, _d114, _d115, _d116, _d117, _d118, _d119;
  @Uint8()
  int _d120, _d121, _d122, _d123, _d124, _d125, _d126, _d127;
  @Uint8()
  int _d128, _d129, _d130, _d131, _d132, _d133, _d134, _d135;
  @Uint8()
  int _d136, _d137, _d138, _d139, _d140, _d141, _d142, _d143;
  @Uint8()
  int _d144, _d145, _d146, _d147, _d148, _d149, _d150, _d151;
  @Uint8()
  int _d152, _d153, _d154, _d155, _d156, _d157, _d158, _d159;
  @Uint8()
  int _d160, _d161, _d162, _d163, _d164, _d165, _d166, _d167;
  @Uint8()
  int _d168, _d169, _d170, _d171, _d172, _d173, _d174, _d175;
  @Uint8()
  int _d176, _d177, _d178, _d179, _d180, _d181, _d182, _d183;
  @Uint8()
  int _d184, _d185, _d186, _d187, _d188, _d189, _d190, _d191;
  @Uint8()
  int _d192, _d193, _d194, _d195, _d196, _d197, _d198, _d199;
  @Uint8()
  int _d200, _d201, _d202, _d203, _d204, _d205, _d206, _d207;
  @Uint8()
  int _d208, _d209, _d210, _d211, _d212, _d213, _d214, _d215;
  @Uint8()
  int _d216, _d217, _d218, _d219, _d220, _d221, _d222, _d223;
  @Uint8()
  int _d224, _d225, _d226, _d227, _d228, _d229, _d230, _d231;
  @Uint8()
  int _d232, _d233, _d234, _d235, _d236, _d237, _d238, _d239;
  @Uint8()
  int _d240, _d241, _d242, _d243, _d244, _d245, _d246, _d247;
  @Uint8()
  int _d248, _d249, _d250, _d251, _d252, _d253, _d254, _d255;
  @Uint8()
  int _d256, _d257, _d258, _d259, _d260, _d261, _d262, _d263;
  @Uint8()
  int _d264, _d265, _d266, _d267, _d268, _d269, _d270, _d271;
  @Uint8()
  int _d272, _d273, _d274, _d275, _d276, _d277, _d278, _d279;
  @Uint8()
  int _d280, _d281, _d282, _d283, _d284, _d285, _d286, _d287;
  @Uint8()
  int _d288, _d289, _d290, _d291, _d292, _d293, _d294, _d295;
  @Uint8()
  int _d296, _d297, _d298, _d299, _d300, _d301, _d302, _d303;
  @Uint8()
  int _d304, _d305, _d306, _d307, _d308, _d309, _d310, _d311;
  @Uint8()
  int _d312, _d313, _d314, _d315, _d316, _d317, _d318, _d319;
  @Uint8()
  int _d320, _d321, _d322, _d323, _d324, _d325, _d326, _d327;
  @Uint8()
  int _d328, _d329, _d330, _d331, _d332, _d333, _d334, _d335;
  @Uint8()
  int _d336, _d337, _d338, _d339, _d340, _d341, _d342, _d343;
  @Uint8()
  int _d344, _d345, _d346, _d347, _d348, _d349, _d350, _d351;
  @Uint8()
  int _d352, _d353, _d354, _d355, _d356, _d357, _d358, _d359;
  @Uint8()
  int _d360, _d361, _d362, _d363, _d364, _d365, _d366, _d367;
  @Uint8()
  int _d368, _d369, _d370, _d371, _d372, _d373, _d374, _d375;
  @Uint8()
  int _d376, _d377, _d378, _d379, _d380, _d381, _d382, _d383;
  @Uint8()
  int _d384, _d385, _d386, _d387, _d388, _d389, _d390, _d391;
  @Uint8()
  int _d392, _d393, _d394, _d395, _d396, _d397, _d398, _d399;
  @Uint8()
  int _d400, _d401, _d402, _d403, _d404, _d405, _d406, _d407;
  @Uint8()
  int _d408, _d409, _d410, _d411, _d412, _d413, _d414, _d415;
  @Uint8()
  int _d416, _d417, _d418, _d419, _d420, _d421, _d422, _d423;
  @Uint8()
  int _d424, _d425, _d426, _d427, _d428, _d429, _d430, _d431;
  @Uint8()
  int _d432, _d433, _d434, _d435, _d436, _d437, _d438, _d439;
  @Uint8()
  int _d440, _d441, _d442, _d443, _d444, _d445, _d446, _d447;
  @Uint8()
  int _d448, _d449, _d450, _d451, _d452, _d453, _d454, _d455;
  @Uint8()
  int _d456, _d457, _d458, _d459, _d460, _d461, _d462, _d463;
  @Uint8()
  int _d464, _d465, _d466, _d467, _d468, _d469, _d470, _d471;
  @Uint8()
  int _d472, _d473, _d474, _d475, _d476, _d477, _d478, _d479;
  @Uint8()
  int _d480, _d481, _d482, _d483, _d484, _d485, _d486, _d487;
  @Uint8()
  int _d488, _d489, _d490, _d491, _d492, _d493, _d494, _d495;
  @Uint8()
  int _d496, _d497, _d498, _d499, _d500, _d501, _d502, _d503;
  @Uint8()
  int _d504, _d505, _d506, _d507, _d508, _d509, _d510, _d511;
  @Uint8()
  int _d512, _d513, _d514, _d515, _d516, _d517, _d518, _d519;
  @Uint8()
  int _d520, _d521, _d522, _d523, _d524, _d525, _d526, _d527;
  @Uint8()
  int _d528, _d529, _d530, _d531, _d532, _d533, _d534, _d535;
  @Uint8()
  int _d536, _d537, _d538, _d539, _d540, _d541, _d542, _d543;
  @Uint8()
  int _d544, _d545, _d546, _d547, _d548, _d549, _d550, _d551;
  @Uint8()
  int _d552, _d553, _d554, _d555, _d556, _d557, _d558, _d559;
  @Uint8()
  int _d560, _d561, _d562, _d563, _d564, _d565, _d566, _d567;
  @Uint8()
  int _d568, _d569, _d570, _d571, _d572, _d573, _d574, _d575;
  @Uint8()
  int _d576, _d577, _d578, _d579, _d580, _d581, _d582, _d583;
  @Uint8()
  int _d584, _d585, _d586, _d587, _d588, _d589, _d590, _d591;
  @Uint8()
  int _d592, _d593, _d594, _d595, _d596, _d597, _d598, _d599;
  @Uint8()
  int _d600, _d601, _d602, _d603, _d604, _d605, _d606, _d607;
  @Uint8()
  int _d608, _d609, _d610, _d611, _d612, _d613, _d614, _d615;
  @Uint8()
  int _d616, _d617, _d618, _d619, _d620, _d621, _d622, _d623;
  @Uint8()
  int _d624, _d625, _d626, _d627, _d628, _d629, _d630, _d631;
  @Uint8()
  int _d632, _d633, _d634, _d635, _d636, _d637, _d638, _d639;
  @Uint8()
  int _d640, _d641, _d642, _d643, _d644, _d645, _d646, _d647;
  @Uint8()
  int _d648, _d649, _d650, _d651, _d652, _d653, _d654, _d655;
  @Uint8()
  int _d656, _d657, _d658, _d659, _d660, _d661, _d662, _d663;
  @Uint8()
  int _d664, _d665, _d666, _d667, _d668, _d669, _d670, _d671;
  @Uint8()
  int _d672, _d673, _d674, _d675, _d676, _d677, _d678, _d679;
  @Uint8()
  int _d680, _d681, _d682, _d683, _d684, _d685, _d686, _d687;
  @Uint8()
  int _d688, _d689, _d690, _d691, _d692, _d693, _d694, _d695;
  @Uint8()
  int _d696, _d697, _d698, _d699, _d700, _d701, _d702, _d703;
  @Uint8()
  int _d704, _d705, _d706, _d707, _d708, _d709, _d710, _d711;
  @Uint8()
  int _d712, _d713, _d714, _d715, _d716, _d717, _d718, _d719;
  @Uint8()
  int _d720, _d721, _d722, _d723, _d724, _d725, _d726, _d727;
  @Uint8()
  int _d728, _d729, _d730, _d731, _d732, _d733, _d734, _d735;
  @Uint8()
  int _d736, _d737, _d738, _d739, _d740, _d741, _d742, _d743;
  @Uint8()
  int _d744, _d745, _d746, _d747, _d748, _d749, _d750, _d751;
  @Uint8()
  int _d752, _d753, _d754, _d755, _d756, _d757, _d758, _d759;
  @Uint8()
  int _d760, _d761, _d762, _d763, _d764, _d765, _d766, _d767;
  @Uint8()
  int _d768, _d769, _d770, _d771, _d772, _d773, _d774, _d775;
  @Uint8()
  int _d776, _d777, _d778, _d779, _d780, _d781, _d782, _d783;
  @Uint8()
  int _d784, _d785, _d786, _d787, _d788, _d789, _d790, _d791;
  @Uint8()
  int _d792, _d793, _d794, _d795, _d796, _d797, _d798, _d799;
  @Uint8()
  int _d800, _d801, _d802, _d803, _d804, _d805, _d806, _d807;
  @Uint8()
  int _d808, _d809, _d810, _d811, _d812, _d813, _d814, _d815;
  @Uint8()
  int _d816, _d817, _d818, _d819, _d820, _d821, _d822, _d823;
  @Uint8()
  int _d824, _d825, _d826, _d827, _d828, _d829, _d830, _d831;
  @Uint8()
  int _d832, _d833, _d834, _d835, _d836, _d837, _d838, _d839;
  @Uint8()
  int _d840, _d841, _d842, _d843, _d844, _d845, _d846, _d847;
  @Uint8()
  int _d848, _d849, _d850, _d851, _d852, _d853, _d854, _d855;
  @Uint8()
  int _d856, _d857, _d858, _d859, _d860, _d861, _d862, _d863;
  @Uint8()
  int _d864, _d865, _d866, _d867, _d868, _d869, _d870, _d871;
  @Uint8()
  int _d872, _d873, _d874, _d875, _d876, _d877, _d878, _d879;
  @Uint8()
  int _d880, _d881, _d882, _d883, _d884, _d885, _d886, _d887;
  @Uint8()
  int _d888, _d889, _d890, _d891, _d892, _d893, _d894, _d895;
  @Uint8()
  int _d896, _d897, _d898, _d899, _d900, _d901, _d902, _d903;
  @Uint8()
  int _d904, _d905, _d906, _d907, _d908, _d909, _d910, _d911;
  @Uint8()
  int _d912, _d913, _d914, _d915, _d916, _d917, _d918, _d919;
  @Uint8()
  int _d920, _d921, _d922, _d923, _d924, _d925, _d926, _d927;
  @Uint8()
  int _d928, _d929, _d930, _d931, _d932, _d933, _d934, _d935;
  @Uint8()
  int _d936, _d937, _d938, _d939, _d940, _d941, _d942, _d943;
  @Uint8()
  int _d944, _d945, _d946, _d947, _d948, _d949, _d950, _d951;
  @Uint8()
  int _d952, _d953, _d954, _d955, _d956, _d957, _d958, _d959;
  @Uint8()
  int _d960, _d961, _d962, _d963, _d964, _d965, _d966, _d967;
  @Uint8()
  int _d968, _d969, _d970, _d971, _d972, _d973, _d974, _d975;
  @Uint8()
  int _d976, _d977, _d978, _d979, _d980, _d981, _d982, _d983;
  @Uint8()
  int _d984, _d985, _d986, _d987, _d988, _d989, _d990, _d991;
  @Uint8()
  int _d992, _d993, _d994, _d995, _d996, _d997, _d998, _d999;
  @Uint8()
  int _d1000, _d1001, _d1002, _d1003, _d1004, _d1005, _d1006, _d1007;
  @Uint8()
  int _d1008, _d1009, _d1010, _d1011, _d1012, _d1013, _d1014, _d1015;
  @Uint8()
  int _d1016, _d1017, _d1018, _d1019, _d1020, _d1021, _d1022, _d1023;

  /* size: 1028, members: 2 */
}
