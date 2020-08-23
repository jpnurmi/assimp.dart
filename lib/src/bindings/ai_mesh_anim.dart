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

import 'ai_key.dart';
import 'ai_string.dart';

// ignore_for_file: unused_field

// pahole libassimpd.so -M -C aiMeshAnim 2>/dev/null
class aiMeshAnim extends Struct {
  // struct aiString            mName;                /*     0  1028 */
  Pointer<aiString> get mName => Pointer.fromAddress(addressOf.address + 0);

  @Uint32()
  int _slen;
  @Uint8()
  int _s0, _s1, _s2, _s3, _s4, _s5, _s6, _s7;
  @Uint8()
  int _s8, _s9, _s10, _s11, _s12, _s13, _s14, _s15;
  @Uint8()
  int _s16, _s17, _s18, _s19, _s20, _s21, _s22, _s23;
  @Uint8()
  int _s24, _s25, _s26, _s27, _s28, _s29, _s30, _s31;
  @Uint8()
  int _s32, _s33, _s34, _s35, _s36, _s37, _s38, _s39;
  @Uint8()
  int _s40, _s41, _s42, _s43, _s44, _s45, _s46, _s47;
  @Uint8()
  int _s48, _s49, _s50, _s51, _s52, _s53, _s54, _s55;
  @Uint8()
  int _s56, _s57, _s58, _s59, _s60, _s61, _s62, _s63;
  @Uint8()
  int _s64, _s65, _s66, _s67, _s68, _s69, _s70, _s71;
  @Uint8()
  int _s72, _s73, _s74, _s75, _s76, _s77, _s78, _s79;
  @Uint8()
  int _s80, _s81, _s82, _s83, _s84, _s85, _s86, _s87;
  @Uint8()
  int _s88, _s89, _s90, _s91, _s92, _s93, _s94, _s95;
  @Uint8()
  int _s96, _s97, _s98, _s99, _s100, _s101, _s102, _s103;
  @Uint8()
  int _s104, _s105, _s106, _s107, _s108, _s109, _s110, _s111;
  @Uint8()
  int _s112, _s113, _s114, _s115, _s116, _s117, _s118, _s119;
  @Uint8()
  int _s120, _s121, _s122, _s123, _s124, _s125, _s126, _s127;
  @Uint8()
  int _s128, _s129, _s130, _s131, _s132, _s133, _s134, _s135;
  @Uint8()
  int _s136, _s137, _s138, _s139, _s140, _s141, _s142, _s143;
  @Uint8()
  int _s144, _s145, _s146, _s147, _s148, _s149, _s150, _s151;
  @Uint8()
  int _s152, _s153, _s154, _s155, _s156, _s157, _s158, _s159;
  @Uint8()
  int _s160, _s161, _s162, _s163, _s164, _s165, _s166, _s167;
  @Uint8()
  int _s168, _s169, _s170, _s171, _s172, _s173, _s174, _s175;
  @Uint8()
  int _s176, _s177, _s178, _s179, _s180, _s181, _s182, _s183;
  @Uint8()
  int _s184, _s185, _s186, _s187, _s188, _s189, _s190, _s191;
  @Uint8()
  int _s192, _s193, _s194, _s195, _s196, _s197, _s198, _s199;
  @Uint8()
  int _s200, _s201, _s202, _s203, _s204, _s205, _s206, _s207;
  @Uint8()
  int _s208, _s209, _s210, _s211, _s212, _s213, _s214, _s215;
  @Uint8()
  int _s216, _s217, _s218, _s219, _s220, _s221, _s222, _s223;
  @Uint8()
  int _s224, _s225, _s226, _s227, _s228, _s229, _s230, _s231;
  @Uint8()
  int _s232, _s233, _s234, _s235, _s236, _s237, _s238, _s239;
  @Uint8()
  int _s240, _s241, _s242, _s243, _s244, _s245, _s246, _s247;
  @Uint8()
  int _s248, _s249, _s250, _s251, _s252, _s253, _s254, _s255;
  @Uint8()
  int _s256, _s257, _s258, _s259, _s260, _s261, _s262, _s263;
  @Uint8()
  int _s264, _s265, _s266, _s267, _s268, _s269, _s270, _s271;
  @Uint8()
  int _s272, _s273, _s274, _s275, _s276, _s277, _s278, _s279;
  @Uint8()
  int _s280, _s281, _s282, _s283, _s284, _s285, _s286, _s287;
  @Uint8()
  int _s288, _s289, _s290, _s291, _s292, _s293, _s294, _s295;
  @Uint8()
  int _s296, _s297, _s298, _s299, _s300, _s301, _s302, _s303;
  @Uint8()
  int _s304, _s305, _s306, _s307, _s308, _s309, _s310, _s311;
  @Uint8()
  int _s312, _s313, _s314, _s315, _s316, _s317, _s318, _s319;
  @Uint8()
  int _s320, _s321, _s322, _s323, _s324, _s325, _s326, _s327;
  @Uint8()
  int _s328, _s329, _s330, _s331, _s332, _s333, _s334, _s335;
  @Uint8()
  int _s336, _s337, _s338, _s339, _s340, _s341, _s342, _s343;
  @Uint8()
  int _s344, _s345, _s346, _s347, _s348, _s349, _s350, _s351;
  @Uint8()
  int _s352, _s353, _s354, _s355, _s356, _s357, _s358, _s359;
  @Uint8()
  int _s360, _s361, _s362, _s363, _s364, _s365, _s366, _s367;
  @Uint8()
  int _s368, _s369, _s370, _s371, _s372, _s373, _s374, _s375;
  @Uint8()
  int _s376, _s377, _s378, _s379, _s380, _s381, _s382, _s383;
  @Uint8()
  int _s384, _s385, _s386, _s387, _s388, _s389, _s390, _s391;
  @Uint8()
  int _s392, _s393, _s394, _s395, _s396, _s397, _s398, _s399;
  @Uint8()
  int _s400, _s401, _s402, _s403, _s404, _s405, _s406, _s407;
  @Uint8()
  int _s408, _s409, _s410, _s411, _s412, _s413, _s414, _s415;
  @Uint8()
  int _s416, _s417, _s418, _s419, _s420, _s421, _s422, _s423;
  @Uint8()
  int _s424, _s425, _s426, _s427, _s428, _s429, _s430, _s431;
  @Uint8()
  int _s432, _s433, _s434, _s435, _s436, _s437, _s438, _s439;
  @Uint8()
  int _s440, _s441, _s442, _s443, _s444, _s445, _s446, _s447;
  @Uint8()
  int _s448, _s449, _s450, _s451, _s452, _s453, _s454, _s455;
  @Uint8()
  int _s456, _s457, _s458, _s459, _s460, _s461, _s462, _s463;
  @Uint8()
  int _s464, _s465, _s466, _s467, _s468, _s469, _s470, _s471;
  @Uint8()
  int _s472, _s473, _s474, _s475, _s476, _s477, _s478, _s479;
  @Uint8()
  int _s480, _s481, _s482, _s483, _s484, _s485, _s486, _s487;
  @Uint8()
  int _s488, _s489, _s490, _s491, _s492, _s493, _s494, _s495;
  @Uint8()
  int _s496, _s497, _s498, _s499, _s500, _s501, _s502, _s503;
  @Uint8()
  int _s504, _s505, _s506, _s507, _s508, _s509, _s510, _s511;
  @Uint8()
  int _s512, _s513, _s514, _s515, _s516, _s517, _s518, _s519;
  @Uint8()
  int _s520, _s521, _s522, _s523, _s524, _s525, _s526, _s527;
  @Uint8()
  int _s528, _s529, _s530, _s531, _s532, _s533, _s534, _s535;
  @Uint8()
  int _s536, _s537, _s538, _s539, _s540, _s541, _s542, _s543;
  @Uint8()
  int _s544, _s545, _s546, _s547, _s548, _s549, _s550, _s551;
  @Uint8()
  int _s552, _s553, _s554, _s555, _s556, _s557, _s558, _s559;
  @Uint8()
  int _s560, _s561, _s562, _s563, _s564, _s565, _s566, _s567;
  @Uint8()
  int _s568, _s569, _s570, _s571, _s572, _s573, _s574, _s575;
  @Uint8()
  int _s576, _s577, _s578, _s579, _s580, _s581, _s582, _s583;
  @Uint8()
  int _s584, _s585, _s586, _s587, _s588, _s589, _s590, _s591;
  @Uint8()
  int _s592, _s593, _s594, _s595, _s596, _s597, _s598, _s599;
  @Uint8()
  int _s600, _s601, _s602, _s603, _s604, _s605, _s606, _s607;
  @Uint8()
  int _s608, _s609, _s610, _s611, _s612, _s613, _s614, _s615;
  @Uint8()
  int _s616, _s617, _s618, _s619, _s620, _s621, _s622, _s623;
  @Uint8()
  int _s624, _s625, _s626, _s627, _s628, _s629, _s630, _s631;
  @Uint8()
  int _s632, _s633, _s634, _s635, _s636, _s637, _s638, _s639;
  @Uint8()
  int _s640, _s641, _s642, _s643, _s644, _s645, _s646, _s647;
  @Uint8()
  int _s648, _s649, _s650, _s651, _s652, _s653, _s654, _s655;
  @Uint8()
  int _s656, _s657, _s658, _s659, _s660, _s661, _s662, _s663;
  @Uint8()
  int _s664, _s665, _s666, _s667, _s668, _s669, _s670, _s671;
  @Uint8()
  int _s672, _s673, _s674, _s675, _s676, _s677, _s678, _s679;
  @Uint8()
  int _s680, _s681, _s682, _s683, _s684, _s685, _s686, _s687;
  @Uint8()
  int _s688, _s689, _s690, _s691, _s692, _s693, _s694, _s695;
  @Uint8()
  int _s696, _s697, _s698, _s699, _s700, _s701, _s702, _s703;
  @Uint8()
  int _s704, _s705, _s706, _s707, _s708, _s709, _s710, _s711;
  @Uint8()
  int _s712, _s713, _s714, _s715, _s716, _s717, _s718, _s719;
  @Uint8()
  int _s720, _s721, _s722, _s723, _s724, _s725, _s726, _s727;
  @Uint8()
  int _s728, _s729, _s730, _s731, _s732, _s733, _s734, _s735;
  @Uint8()
  int _s736, _s737, _s738, _s739, _s740, _s741, _s742, _s743;
  @Uint8()
  int _s744, _s745, _s746, _s747, _s748, _s749, _s750, _s751;
  @Uint8()
  int _s752, _s753, _s754, _s755, _s756, _s757, _s758, _s759;
  @Uint8()
  int _s760, _s761, _s762, _s763, _s764, _s765, _s766, _s767;
  @Uint8()
  int _s768, _s769, _s770, _s771, _s772, _s773, _s774, _s775;
  @Uint8()
  int _s776, _s777, _s778, _s779, _s780, _s781, _s782, _s783;
  @Uint8()
  int _s784, _s785, _s786, _s787, _s788, _s789, _s790, _s791;
  @Uint8()
  int _s792, _s793, _s794, _s795, _s796, _s797, _s798, _s799;
  @Uint8()
  int _s800, _s801, _s802, _s803, _s804, _s805, _s806, _s807;
  @Uint8()
  int _s808, _s809, _s810, _s811, _s812, _s813, _s814, _s815;
  @Uint8()
  int _s816, _s817, _s818, _s819, _s820, _s821, _s822, _s823;
  @Uint8()
  int _s824, _s825, _s826, _s827, _s828, _s829, _s830, _s831;
  @Uint8()
  int _s832, _s833, _s834, _s835, _s836, _s837, _s838, _s839;
  @Uint8()
  int _s840, _s841, _s842, _s843, _s844, _s845, _s846, _s847;
  @Uint8()
  int _s848, _s849, _s850, _s851, _s852, _s853, _s854, _s855;
  @Uint8()
  int _s856, _s857, _s858, _s859, _s860, _s861, _s862, _s863;
  @Uint8()
  int _s864, _s865, _s866, _s867, _s868, _s869, _s870, _s871;
  @Uint8()
  int _s872, _s873, _s874, _s875, _s876, _s877, _s878, _s879;
  @Uint8()
  int _s880, _s881, _s882, _s883, _s884, _s885, _s886, _s887;
  @Uint8()
  int _s888, _s889, _s890, _s891, _s892, _s893, _s894, _s895;
  @Uint8()
  int _s896, _s897, _s898, _s899, _s900, _s901, _s902, _s903;
  @Uint8()
  int _s904, _s905, _s906, _s907, _s908, _s909, _s910, _s911;
  @Uint8()
  int _s912, _s913, _s914, _s915, _s916, _s917, _s918, _s919;
  @Uint8()
  int _s920, _s921, _s922, _s923, _s924, _s925, _s926, _s927;
  @Uint8()
  int _s928, _s929, _s930, _s931, _s932, _s933, _s934, _s935;
  @Uint8()
  int _s936, _s937, _s938, _s939, _s940, _s941, _s942, _s943;
  @Uint8()
  int _s944, _s945, _s946, _s947, _s948, _s949, _s950, _s951;
  @Uint8()
  int _s952, _s953, _s954, _s955, _s956, _s957, _s958, _s959;
  @Uint8()
  int _s960, _s961, _s962, _s963, _s964, _s965, _s966, _s967;
  @Uint8()
  int _s968, _s969, _s970, _s971, _s972, _s973, _s974, _s975;
  @Uint8()
  int _s976, _s977, _s978, _s979, _s980, _s981, _s982, _s983;
  @Uint8()
  int _s984, _s985, _s986, _s987, _s988, _s989, _s990, _s991;
  @Uint8()
  int _s992, _s993, _s994, _s995, _s996, _s997, _s998, _s999;
  @Uint8()
  int _s1000, _s1001, _s1002, _s1003, _s1004, _s1005, _s1006, _s1007;
  @Uint8()
  int _s1008, _s1009, _s1010, _s1011, _s1012, _s1013, _s1014, _s1015;
  @Uint8()
  int _s1016, _s1017, _s1018, _s1019, _s1020, _s1021, _s1022, _s1023;

  // unsigned int               mNumKeys;             /*  1028     4 */
  @Uint32()
  int mNumKeys;

  // class aiMeshKey *          mKeys;                /*  1032     8 */
  Pointer<aiMeshKey> mKeys;

  /* size: 1040, members: 3 */
}
