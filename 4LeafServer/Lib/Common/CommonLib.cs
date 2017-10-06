using System;
using System.Text;

namespace LeafServer
{
    public enum ITEM_SERIES
    {
        Accessories = 0,
        Apocalyse,
        Crimson,
        Event,
        Fantasy,
        G3P2,
        Gray,
        Life,
        Magnacarta,
        Morden,
        Original,
        Shivan,
        Sport,
        Student,
        Tempest,
        Weapone,
        WestWind,
    }

    public class CommonLib
    {
        #region Public
        public static readonly string DBConnConfig = "server=127.0.0.1;uid=root;pwd=leaf@server;database=4leaf";
        public static readonly string DBEncryptKey = "NS#4@Leaf&";
        public static readonly int MAX_AVATAR_COUNT = 1;

        /// <summary>
        /// Server Port
        /// </summary>
        public static readonly UInt16 SERVER_PORT = 33000;

        /// <summary>
        /// Server On/Off Status
        /// </summary>
        public static bool IsON = false;

        public static readonly string WorldMap_Eng = "WorldMap";
        public static readonly string WorldMap_Kor = "아노마라드 상공";

        /// <summary>
        /// 로그인 공지 메세지
        /// </summary>
        public static readonly string NoticeMessae = "Welcome NS Server ";
        /// <summary>
        /// 가입 확인 메세지
        /// </summary>
        public static readonly string RegisterMessage = "잘 읽어 주세요!\r\n" +
            " - 회원 가입 시 사용 할 주민등록 번호\r\n" +
            "   (남)800101 - 1000008 / (여)800101 - 2000001\r\n\r\n" +
            " - 아이디, 비번, 이름, 주민번호, 비번질문, 질문 답\r\n" +
            "   이렇게만 입력하면 가입 가능합니다.\r\n\r\n" +
            " - 실제로 저장되는 정보는 아이디와 비밀번호만 저장 됩니다.\r\n\r\n" +
            " - 작업이 성공적으로 완료 되었다는 메세지가 나타나면 클라종료 후,\r\n" +
            "   재 접속 하시면 됩니다.";
        #endregion

        public static bool CheckChatRegion(string inArea_Eng)
        { return inArea_Eng.Contains("CT_"); }

        public static int GetAreaIndex(string inArea)
        {
            if (inArea == WorldMap_Kor)
                return -1;
            else
                return LeafConnection.ConnUserList.FindAll(r =>
                    r.UserInfo.AvatarList[r.UserInfo.AvatarOrder].Name != null
                    && r.UserInfo.AvatarList[r.UserInfo.AvatarOrder].Name.Length > 0
                    && r.CurrentArea == inArea).Count;
        }

        public static byte[] DummyAvatarData()
        {
            int DataIndex = 0;

            byte[] Avatar = new byte[128];
            byte[] TempData = null;

            // 캐릭터 종류       - [0] / 1
            Avatar[DataIndex++] = Convert.ToByte(7);

            // 아바타 이름       - [1] / 22
            TempData = Encoding.Default.GetBytes("캐릭터를");

            for (int i = 0; i < TempData.Length; i++)
                Avatar[DataIndex++] = TempData[i];

            // 미분석            - [23] / 5
            DataIndex = 28;

            // 캐릭터            - [28] / 32
            // 머리(2)
            //TempData = BitConverter.GetBytes(487);
            //Avatar[DataIndex++] = TempData[0];
            //Avatar[DataIndex++] = TempData[1];
            // 머리 악세사리(2)
            // 상의1 (2)
            TempData = BitConverter.GetBytes(1004);
            Avatar[DataIndex++] = TempData[0];
            Avatar[DataIndex++] = TempData[1];
            // 상의2 (2)
            // 상의3 (2)
            // 바지1 (2)
            TempData = BitConverter.GetBytes(1005);
            Avatar[DataIndex++] = TempData[0];
            Avatar[DataIndex++] = TempData[1];
            // 바지2 (2)
            // 바지3 (2)
            // 신발 (2)
            TempData = BitConverter.GetBytes(1006);
            Avatar[DataIndex++] = TempData[0];
            Avatar[DataIndex++] = TempData[1];
            // 오른손 (2)
            // 왼손 (2)
            // 악세사리1 (2)
            // 악세사리2 (2)
            // 악세사리3 (2)
            // 악세사리4 (2)
            // 악세사리5 (2)

            // 미분석            - [60] / 24
            DataIndex = 84;

            // 기사단            - [84] / 24
            TempData = Encoding.Default.GetBytes("생성해주세요");

            for (int i = 0; i < TempData.Length; i++)
                Avatar[DataIndex++] = TempData[i];

            DataIndex = 108;

            // 보유 GP           - [108] / 4
            TempData = BitConverter.GetBytes(0);
            Avatar[DataIndex++] = TempData[0];
            Avatar[DataIndex++] = TempData[1];
            Avatar[DataIndex++] = TempData[2];
            Avatar[DataIndex++] = TempData[3];

            // 보유 FP           - [112] / 4
            TempData = BitConverter.GetBytes(0);
            Avatar[DataIndex++] = TempData[0];
            Avatar[DataIndex++] = TempData[1];
            Avatar[DataIndex++] = TempData[2];
            Avatar[DataIndex++] = TempData[3];

            // 미분석            - [116] / 12
            DataIndex = 128;

            return Avatar;
        }

        public static string AreaWeather(string inArea)
        {
            if (AreaConvertEng(inArea).Contains("Snow"))
                return "Snow";
            else if (AreaConvertEng(inArea).Contains("Plain"))
                return "Plain";
            else if (AreaConvertEng(inArea).Contains("Sea"))
                return "Sea";
            else
                return "None";
        }

        /// <summary>
        /// 지역이름 Convert [한 -> 영]
        /// </summary>
        /// <param name="inArea"></param>
        /// <returns></returns>
        public static string AreaConvertEng(string inArea)
        {
            /*
             * •/WorldMap ; 아노마라드 상공
             * ◦/MainStreet ; 켈티카의 거리 
             * ■/Office ; 네냐플 마법학원
             * ■/DressShop ; 댄디캣 클래식
             * ■/DressShop2 ; 댄디캣
             * ■/CardShop ; 매직 카덴
             * ■/AccessoryShop ; 캐즈팝
             * ■/HairShop ; 실키필
             * ■/EventHall ; 프레쉬센트 
             * ■/SpeechHall ; 와글와글스피치
             * ■/SeminarHall ; 세미나실
             * ◦/ChatRegion ; 북 하이아칸
             * ■/CT_Snow01 ; 실버 호라이즌
             * ■/CT_Snow02 ; 화이트 크리스탈
             * ■/CT_Snow03 ; 퓨어 시린
             * ■/CT_Snow04 ; 윈트리 아이스
             * ■/CT_Snow05 ; 스노우 풀
             * ■/CT_Plain01 ; 샤이닝 브리즈
             * ■/CT_Plain02 ; 스위트 쟈스민
             * ■/CT_Plain03 ; 그린 에메랄드
             * ◦/ChatRegion2 ; 남 하이아칸 
             * ■/CT_Sea01 ; 블루 사파이어
             * ■/CT_Sea02 ; 헤이즐리 웨이브
             * ■/CT_Sea03 ; 아쿠아 코럴
             * ■/CT_Sea04 ; 블레싱 마린
             * ■/CT_Sea05 ; 미스틱 머메이드
             * ■/CT_Plain04 ; 매쉬 메리골드
             * ■/CT_Plain05 ; 엘핀 포레스트
             * ■/CT_Plain06 ; 블랜드 제피르
             * ◦/D1Region ; 주사위의 잔영(각 채널은 5개씩 있음, 1채널 외 생략)
             * ■/D1_Ispin_1 ; 이스핀 1채널
             * ■/D1_Nayatrei_1 ; 나야트레이 1채널
             * ■/D1_Cloe_1 ; 클로에 1채널
             * ■/D1_Mila_1 ; 밀라 1채널
             * ■/D1_Tichiel_1 ; 티치엘 1채널
             * ■/D1_Anais_1 ; 아나이스 1채널
             * ■/D1_Benya_1 ; 벤야 1채널
             * ◦/KnightsRegion ; 레코르다블
             * ■/KT_Sea01 ; 모험의 바다
             * ■/KT_Plain01 ; 영광의 대지
             * ■/KT_Snow01 ; 침묵의 설원
             * ■/KT_Sea02 ; 도전의 바다
             * ■/KT_Sea03 ; 황혼의 바다
             * ■/KT_Plain02 ; 패왕의 대지
             */

            string world_name = null;

            switch (inArea)
            {
                case "아노마라드 상공":
                    world_name = "WorldMap";
                    break;
                case "켈티카의 거리":
                    world_name = "MainStreet";
                    break;
                case "네냐플 마법학원":
                    world_name = "Office";
                    break;
                case "댄디캣 클래식":
                    world_name = "DressShop";
                    break;
                case "댄디캣":
                    world_name = "DressShop2";
                    break;
                case "매직 카덴":
                    world_name = "CardShop";
                    break;
                case "캐즈팝":
                    world_name = "AccessoryShop";
                    break;
                case "실키필":
                    world_name = "HairShop";
                    break;
                case "프레쉬센트":
                    world_name = "EventHall";
                    break;
                case "와글와글 스피치":
                    world_name = "SpeechHall";
                    break;
                case "세미나실":
                    world_name = "SeminarHall";
                    break;
                case "북 하이아칸":
                    world_name = "ChatRegion";
                    break;
                case "실버 호라이즌":
                    world_name = "CT_Snow01";
                    break;
                case "화이트 크리스탈":
                    world_name = "CT_Snow02";
                    break;
                case "퓨어 시린":
                    world_name = "CT_Snow03";
                    break;
                case "윈트리 아이스":
                    world_name = "CT_Snow04";
                    break;
                case "스노우 풀":
                    world_name = "CT_Snow05";
                    break;
                case "샤이닝 브리즈":
                    world_name = "CT_Plain01";
                    break;
                case "스위트 쟈스민":
                    world_name = "CT_Plain02";
                    break;
                case "그린 에메랄드":
                    world_name = "CT_Plain03";
                    break;
                case "남 하이아칸":
                    world_name = "ChatRegion2";
                    break;
                case "블루 사파이어":
                    world_name = "CT_Sea01";
                    break;
                case "헤이즐리 웨이브":
                    world_name = "CT_Sea02";
                    break;
                case "아쿠아 코럴":
                    world_name = "CT_Sea03";
                    break;
                case "블래싱 마린":
                    world_name = "CT_Sea04";
                    break;
                case "미스틱 머메이드":
                    world_name = "CT_Sea05";
                    break;
                case "매쉬 메리골드":
                    world_name = "CT_Plain04";
                    break;
                case "엘핀 포레스트":
                    world_name = "CT_Plain05";
                    break;
                case "블랜드 제피르":
                    world_name = "CT_Plain06";
                    break;
                case "주사위의 잔영":
                    world_name = "D1Region";
                    break;
                case "이스핀 1채널":
                    world_name = "D1_Ispin_1";
                    break;
                case "이스핀 2채널":
                    world_name = "D1_Ispin_2";
                    break;
                case "이스핀 3채널":
                    world_name = "D1_Ispin_3";
                    break;
                case "이스핀 4채널":
                    world_name = "D1_Ispin_4";
                    break;
                case "이스핀 5채널":
                    world_name = "D1_Ispin_5";
                    break;
                case "나야트레이 1채널":
                    world_name = "D1_Nayatrei_1";
                    break;
                case "나야트레이 2채널":
                    world_name = "D1_Nayatrei_2";
                    break;
                case "나야트레이 3채널":
                    world_name = "D1_Nayatrei_3";
                    break;
                case "나야트레이 4채널":
                    world_name = "D1_Nayatrei_4";
                    break;
                case "나야트레이 5채널":
                    world_name = "D1_Nayatrei_5";
                    break;
                case "클로에 1채널":
                    world_name = "D1_Cloe_1";
                    break;
                case "클로에 2채널":
                    world_name = "D1_Cloe_2";
                    break;
                case "클로에 3채널":
                    world_name = "D1_Cloe_3";
                    break;
                case "클로에 4채널":
                    world_name = "D1_Cloe_4";
                    break;
                case "클로에 5채널":
                    world_name = "D1_Cloe_5";
                    break;
                case "밀라 1채널":
                    world_name = "D1_Mila_1";
                    break;
                case "밀라 2채널":
                    world_name = "D1_Mila_2";
                    break;
                case "밀라 3채널":
                    world_name = "D1_Mila_3";
                    break;
                case "밀라 4채널":
                    world_name = "D1_Mila_4";
                    break;
                case "밀라 5채널":
                    world_name = "D1_Mila_5";
                    break;
                case "티치엘 1채널":
                    world_name = "D1_Tichiel_1";
                    break;
                case "티치엘 2채널":
                    world_name = "D1_Tichiel_2";
                    break;
                case "티치엘 3채널":
                    world_name = "D1_Tichiel_3";
                    break;
                case "티치엘 4채널":
                    world_name = "D1_Tichiel_4";
                    break;
                case "티치엘 5채널":
                    world_name = "D1_Tichiel_5";
                    break;
                case "아나이스 1채널":
                    world_name = "D1_Anais_1";
                    break;
                case "아나이스 2채널":
                    world_name = "D1_Anais_2";
                    break;
                case "아나이스 3채널":
                    world_name = "D1_Anais_3";
                    break;
                case "아나이스 4채널":
                    world_name = "D1_Anais_4";
                    break;
                case "아나이스 5채널":
                    world_name = "D1_Anais_5";
                    break;
                case "벤야 1채널":
                    world_name = "D1_Benya_1";
                    break;
                case "벤야 2채널":
                    world_name = "D1_Benya_2";
                    break;
                case "벤야 3채널":
                    world_name = "D1_Benya_3";
                    break;
                case "벤야 4채널":
                    world_name = "D1_Benya_4";
                    break;
                case "벤야 5채널":
                    world_name = "D1_Benya_5";
                    break;
                case "레코르다블":
                    world_name = "KnightsRegion";
                    break;
                case "모험의 바다":
                    world_name = "KT_Sea01";
                    break;
                case "도전의 바다":
                    world_name = "KT_Sea02";
                    break;
                case "황혼의 바다":
                    world_name = "KT_Sea03";
                    break;
                case "영광의 대지":
                    world_name = "KT_Plain01";
                    break;
                case "패왕의 대지":
                    world_name = "KT_Plain02";
                    break;
                case "침묵의 설원":
                    world_name = "KT_Snow01";
                    break;
                default:
                    world_name = "예상치 못한 장소";
                    break;
            }
            return world_name;
        }

        /// <summary>
        /// 지역이름 Convert [영 -> 한]
        /// </summary>
        /// <param name="inArea"></param>
        /// <returns></returns>
        public static string AreaConvertKor(string inArea)
        {
            /*
             * •/WorldMap ; 아노마라드 상공
             * ◦/MainStreet ; 켈티카의 거리 
             * ■/Office ; 네냐플 마법학원
             * ■/DressShop ; 댄디캣 클래식
             * ■/DressShop2 ; 댄디캣
             * ■/CardShop ; 매직 카덴
             * ■/AccessoryShop ; 캐즈팝
             * ■/HairShop ; 실키필
             * ■/EventHall ; 프레쉬센트 
             * ■/SpeechHall ; 와글와글스피치
             * ■/SeminarHall ; 세미나실
             * ◦/ChatRegion ; 북 하이아칸
             * ■/CT_Snow01 ; 실버 호라이즌
             * ■/CT_Snow02 ; 화이트 크리스탈
             * ■/CT_Snow03 ; 퓨어 시린
             * ■/CT_Snow04 ; 윈트리 아이스
             * ■/CT_Snow05 ; 스노우 풀
             * ■/CT_Plain01 ; 샤이닝 브리즈
             * ■/CT_Plain02 ; 스위트 쟈스민
             * ■/CT_Plain03 ; 그린 에메랄드
             * ◦/ChatRegion2 ; 남 하이아칸 
             * ■/CT_Sea01 ; 블루 사파이어
             * ■/CT_Sea02 ; 헤이즐리 웨이브
             * ■/CT_Sea03 ; 아쿠아 코럴
             * ■/CT_Sea04 ; 블레싱 마린
             * ■/CT_Sea05 ; 미스틱 머메이드
             * ■/CT_Plain04 ; 매쉬 메리골드
             * ■/CT_Plain05 ; 엘핀 포레스트
             * ■/CT_Plain06 ; 블랜드 제피르
             * ◦/D1Region ; 주사위의 잔영(각 채널은 5개씩 있음, 1채널 외 생략)
             * ■/D1_Ispin_1 ; 이스핀 1채널
             * ■/D1_Nayatrei_1 ; 나야트레이 1채널
             * ■/D1_Cloe_1 ; 클로에 1채널
             * ■/D1_Mila_1 ; 밀라 1채널
             * ■/D1_Tichiel_1 ; 티치엘 1채널
             * ■/D1_Anais_1 ; 아나이스 1채널
             * ■/D1_Benya_1 ; 벤야 1채널
             * ◦/KnightsRegion ; 레코르다블
             * ■/KT_Sea01 ; 모험의 바다
             * ■/KT_Plain01 ; 영광의 대지
             * ■/KT_Snow01 ; 침묵의 설원
             * ■/KT_Sea02 ; 도전의 바다
             * ■/KT_Sea03 ; 황혼의 바다
             * ■/KT_Plain02 ; 패왕의 대지
             */

            string world_name = null;

            switch (inArea)
            {
                case "WorldMap":
                    world_name = "아노마라드 상공";
                    break;
                case "MainStreet":
                    world_name = "켈티카의 거리";
                    break;
                case "Office":
                    world_name = "네냐플 마법학원";
                    break;
                case "DressShop":
                    world_name = "댄디캣 클래식";
                    break;
                case "DressShop2":
                    world_name = "댄디캣";
                    break;
                case "CardShop":
                    world_name = "매직 카덴";
                    break;
                case "AccessoryShop":
                    world_name = "캐즈팝";
                    break;
                case "HairShop":
                    world_name = "실키필";
                    break;
                case "EventHall":
                    world_name = "프레쉬센트";
                    break;
                case "SpeechHall":
                    world_name = "와글와글 스피치";
                    break;
                case "SeminarHall":
                    world_name = "세미나실";
                    break;
                case "ChatRegion":
                    world_name = "북 하이아칸";
                    break;
                case "CT_Snow01":
                    world_name = "실버 호라이즌";
                    break;
                case "CT_Snow02":
                    world_name = "화이트 크리스탈";
                    break;
                case "CT_Snow03":
                    world_name = "퓨어 시린";
                    break;
                case "CT_Snow04":
                    world_name = "윈트리 아이스";
                    break;
                case "CT_Snow05":
                    world_name = "스노우 풀";
                    break;
                case "CT_Plain01":
                    world_name = "샤이닝 브리즈";
                    break;
                case "CT_Plain02":
                    world_name = "스위트 쟈스민";
                    break;
                case "CT_Plain03":
                    world_name = "그린 에메랄드";
                    break;
                case "ChatRegion2":
                    world_name = "남 하이아칸";
                    break;
                case "CT_Sea01":
                    world_name = "블루 사파이어";
                    break;
                case "CT_Sea02":
                    world_name = "헤이즐리 웨이브";
                    break;
                case "CT_Sea03":
                    world_name = "아쿠아 코럴";
                    break;
                case "CT_Sea04":
                    world_name = "블래싱 마린";
                    break;
                case "CT_Sea05":
                    world_name = "미스틱 머메이드";
                    break;
                case "CT_Plain04":
                    world_name = "매쉬 메리골드";
                    break;
                case "CT_Plain05":
                    world_name = "엘핀 포레스트";
                    break;
                case "CT_Plain06":
                    world_name = "블랜드 제피르";
                    break;
                case "D1Region":
                    world_name = "주사위의 잔영";
                    break;
                case "D1_Ispin_1":
                    world_name = "이스핀 1채널";
                    break;
                case "D1_Ispin_2":
                    world_name = "이스핀 2채널";
                    break;
                case "D1_Ispin_3":
                    world_name = "이스핀 3채널";
                    break;
                case "D1_Ispin_4":
                    world_name = "이스핀 4채널";
                    break;
                case "D1_Ispin_5":
                    world_name = "이스핀 5채널";
                    break;
                case "D1_Nayatrei_1":
                    world_name = "나야트레이 1채널";
                    break;
                case "D1_Nayatrei_2":
                    world_name = "나야트레이 2채널";
                    break;
                case "D1_Nayatrei_3":
                    world_name = "나야트레이 3채널";
                    break;
                case "D1_Nayatrei_4":
                    world_name = "나야트레이 4채널";
                    break;
                case "D1_Nayatrei_5":
                    world_name = "나야트레이 5채널";
                    break;
                case "D1_Cloe_1":
                    world_name = "클로에 1채널";
                    break;
                case "D1_Cloe_2":
                    world_name = "클로에 2채널";
                    break;
                case "D1_Cloe_3":
                    world_name = "클로에 3채널";
                    break;
                case "D1_Cloe_4":
                    world_name = "클로에 4채널";
                    break;
                case "D1_Cloe_5":
                    world_name = "클로에 5채널";
                    break;
                case "D1_Mila_1":
                    world_name = "밀라 1채널";
                    break;
                case "D1_Mila_2":
                    world_name = "밀라 2채널";
                    break;
                case "D1_Mila_3":
                    world_name = "밀라 3채널";
                    break;
                case "D1_Mila_4":
                    world_name = "밀라 4채널";
                    break;
                case "D1_Mila_5":
                    world_name = "밀라 5채널";
                    break;
                case "D1_Tichiel_1":
                    world_name = "티치엘 1채널";
                    break;
                case "D1_Tichiel_2":
                    world_name = "티치엘 2채널";
                    break;
                case "D1_Tichiel_3":
                    world_name = "티치엘 3채널";
                    break;
                case "D1_Tichiel_4":
                    world_name = "티치엘 4채널";
                    break;
                case "D1_Tichiel_5":
                    world_name = "티치엘 5채널";
                    break;
                case "D1_Anais_1":
                    world_name = "아나이스 1채널";
                    break;
                case "D1_Anais_2":
                    world_name = "아나이스 2채널";
                    break;
                case "D1_Anais_3":
                    world_name = "아나이스 3채널";
                    break;
                case "D1_Anais_4":
                    world_name = "아나이스 4채널";
                    break;
                case "D1_Anais_5":
                    world_name = "아나이스 5채널";
                    break;
                case "D1_Benya_1":
                    world_name = "벤야 1채널";
                    break;
                case "D1_Benya_2":
                    world_name = "벤야 2채널";
                    break;
                case "D1_Benya_3":
                    world_name = "벤야 3채널";
                    break;
                case "D1_Benya_4":
                    world_name = "벤야 4채널";
                    break;
                case "D1_Benya_5":
                    world_name = "벤야 5채널";
                    break;
                case "KnightsRegion":
                    world_name = "레코르다블";
                    break;
                case "KT_Sea01":
                    world_name = "모험의 바다";
                    break;
                case "KT_Sea02":
                    world_name = "도전의 바다";
                    break;
                case "KT_Sea03":
                    world_name = "황혼의 바다";
                    break;
                case "KT_Plain01":
                    world_name = "영광의 대지";
                    break;
                case "KT_Plain02":
                    world_name = "패왕의 대지";
                    break;
                case "KT_Snow01":
                    world_name = "침묵의 설원";
                    break;
                default:
                    world_name = "예상치 못한 장소";
                    break;
            }
            return world_name;
        }
    }
}
