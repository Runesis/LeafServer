using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;

namespace LeafServer
{
    public class _LeafProtocol
    {
        public byte[] Dummy()
        { return new byte[6]; }

        public byte[] SubCode(byte[] inRecvData)
        {
            byte[] SendData = null;
            byte[] DataLength = null;

            int SendDataLength = 8;

            DataLength = ConvertLengthtoByte(SendDataLength);

            SendData = new byte[SendDataLength];

            SendData[0] = inRecvData[0];
            SendData[1] = inRecvData[1];
            SendData[2] = DataLength[0];
            SendData[3] = DataLength[1];

            SendData[4] = Convert.ToByte(inRecvData[4] + 1);
            SendData[6] = inRecvData[6];

            return SendData;
        }

        public byte[] Error(byte[] inRecvData, int inErrorType)
        {
            byte[] SendData = null;
            byte[] DataLength = null;
            int SendDataLength = 16;
            DataLength = ConvertLengthtoByte(SendDataLength);

            SendData = new byte[SendDataLength];

            //SendData[0] = Convert.ToByte(1);
            SendData[0] = inRecvData[0];
            SendData[1] = inRecvData[1];
            SendData[2] = DataLength[0];
            SendData[3] = DataLength[1];

            SendData[4] = inRecvData[4];
            SendData[5] = inRecvData[5];
            SendData[6] = inRecvData[6];
            SendData[7] = inRecvData[7];

            SendData[8] = Convert.ToByte(1);
            SendData[12] = Convert.ToByte(inErrorType);

            return SendData;
        }

        public byte[] Notice(byte[] inRecvData)
        {
            byte[] SendData = null;
            byte[] DataLength = null;
            int SendDataLength = 0;

            byte[] MessageData = Encoding.Default.GetBytes(CommonLib.NoticeMessae);

            SendDataLength = 14 + MessageData.Length;
            DataLength = ConvertLengthtoByte(SendDataLength);

            SendData = new byte[SendDataLength];

            SendData[0] = inRecvData[0];
            SendData[1] = inRecvData[1];
            SendData[2] = DataLength[0];
            SendData[3] = DataLength[1];

            SendData[4] = inRecvData[4];
            SendData[5] = inRecvData[5];
            SendData[6] = inRecvData[6];
            SendData[7] = inRecvData[7];

            for (int i = 0; i < MessageData.Length; i++)
                SendData[14 + i] = MessageData[i];

            SendData[SendData.Length - 1] = Convert.ToByte(0);

            return SendData;
        }

        public byte[] SignUp(byte[] inRecvData)
        {
            byte[] SendData = null;
            byte[] DataLength = null;
            int SendDataLength = 0;

            byte[] MessageData = null;
            int MessageLength = 0;

            MessageData = Encoding.Default.GetBytes(CommonLib.RegisterMessage);
            MessageLength = MessageData.Length;

            SendDataLength = 12 + MessageLength + 1;
            DataLength = ConvertLengthtoByte(SendDataLength);

            SendData = new byte[SendDataLength];
            SendData[0] = Convert.ToByte(1);
            SendData[1] = Convert.ToByte(0);

            SendData[2] = DataLength[0];
            SendData[3] = DataLength[1];

            SendData[4] = inRecvData[4];
            SendData[5] = inRecvData[5];
            SendData[6] = inRecvData[6];
            SendData[7] = inRecvData[7];

            for (int i = 0; i < MessageLength; i++)
            {
                SendData[12 + i] = MessageData[i];
            }
            SendData[SendData.Length - 1] = Convert.ToByte(0);
            return SendData;
        }

        public byte[] CheckID(byte[] inRecvData)
        {
            byte[] SendData = null;
            byte[] DataLength = null;
            int SendDataLength = 0;

            byte[] BuffCheckID = new byte[inRecvData.Length - 12];
            string CheckID = string.Empty;

            for (int i = 0; i < inRecvData.Length - 12; i++)
            {
                BuffCheckID[i] = inRecvData[12 + i];
            }

            CheckID = Encoding.Default.GetString(BuffCheckID).Split('\0')[0];

            SendDataLength = 16;
            DataLength = ConvertLengthtoByte(SendDataLength);

            SendData = new byte[SendDataLength];
            SendData[0] = Convert.ToByte(1);
            SendData[1] = Convert.ToByte(0);

            SendData[2] = DataLength[0];
            SendData[3] = DataLength[1];

            SendData[4] = inRecvData[4];
            SendData[5] = inRecvData[5];
            SendData[6] = inRecvData[6];
            SendData[7] = inRecvData[7];

            SendData[8] = Convert.ToByte(1);

            if (AccountManager.CheckID(CheckID) == true)
                SendData[12] = Convert.ToByte(12);
            else
                SendData[12] = Convert.ToByte(0);

            return SendData;
        }

        public byte[] Register(byte[] inRecvData)
        {
            byte[] SendData = null;
            byte[] DataLength = null;
            int SendDataLength = 0;

            byte[] MessageData = null;
            int MessageLength = 0;

            MessageData = Encoding.Default.GetBytes("Error");
            MessageLength = MessageData.Length;

            SendDataLength = 12 + MessageData.Length + 1;
            DataLength = ConvertLengthtoByte(SendDataLength);

            SendData = new byte[SendDataLength];

            SendData[0] = Convert.ToByte(1);
            SendData[1] = Convert.ToByte(0);

            SendData[2] = DataLength[0];
            SendData[3] = DataLength[1];

            SendData[4] = inRecvData[4];
            SendData[5] = inRecvData[5];
            SendData[6] = inRecvData[6];
            SendData[7] = inRecvData[7];

            if (AccountManager.CreateAccount(inRecvData))
                SendData[8] = Convert.ToByte(1);
            else
            {
                SendData[8] = Convert.ToByte(3);
                for (int i = 0; i < MessageLength; i++)
                {
                    SendData[12 + i] = MessageData[i];
                }
            }

            return SendData;
        }

        public byte[] Login(byte[] inRecvData, out UserModel outUserInfo)
        {
            byte[] SendData = null;
            byte[] DataLength = null;
            int SendDataLength = 0;

            byte[] Data = null;
            string AccountID = string.Empty;
            string Password = string.Empty;

            outUserInfo = new UserModel();

            Data = new byte[inRecvData.Length - 12];
            for (int i = 0; i < inRecvData[12]; i++)
                Data[i] = inRecvData[13 + i];
            AccountID = Encoding.Default.GetString(Data).Split('\0')[0];

            Data = new byte[16];
            for (int i = 0; i < 16; i++)
                Data[i] = inRecvData[13 + inRecvData[12] + i];
            Password = Encoding.Default.GetString(Data).Split('\0')[0];

            // 계정정보 유효성 체크
            // 로그인 성공
            if (AccountManager.Login(AccountID, Password, out outUserInfo))
            {
                outUserInfo.AccountID = AccountID;
                SendDataLength = 298;
                DataLength = ConvertLengthtoByte(SendDataLength);

                SendData = new byte[SendDataLength];
                SendData[0] = inRecvData[0];
                SendData[1] = inRecvData[1];

                SendData[2] = DataLength[0];
                SendData[3] = DataLength[1];

                SendData[4] = inRecvData[4];
                SendData[5] = inRecvData[5];
                SendData[6] = inRecvData[6];
                SendData[7] = inRecvData[7];

                //  8 ~ 11  = 에러처리
                // 12 ~ 13  = 에러코드

                // 아이디          - [12] / 16
                Data = Encoding.Default.GetBytes(AccountID);
                for (int i = 0; i < Data.Length; i++)
                    SendData[12 + i] = Data[i];

                // 이름            - [28] / 12
                Data = Encoding.Default.GetBytes("포립");
                for (int i = 0; i < Data.Length; i++)
                    SendData[28 + i] = Data[i];

                // 성별            - [40] / 2
                SendData[40] = Convert.ToByte(0);

                // 보유 아바타     - [42] / 2
                SendData[42] = Convert.ToByte(1);

                // 인벤토리        - [44] / 120

                // 아바타 정보     - [166] / 121
                if (outUserInfo.AvatarList.Count < 1)
                    Data = CommonLib.DummyAvatarData();
                else
                    Data = Avatar_Data(outUserInfo.AvatarList[0]);

                for (int i = 0; i < Data.Length; i++)
                    SendData[165 + i] = Data[i];

                // 푸터            - [550] / 4
                SendData[294] = Convert.ToByte(55);
                SendData[295] = Convert.ToByte(203);
                SendData[296] = Convert.ToByte(206);
                SendData[297] = Convert.ToByte(63);

                return SendData;
            }

            #region 로그인 실패
            else
            {
                outUserInfo = null;

                /// 로그인 실패
                /// <error type>
                /// 01 : 예기치 못한 오류
                /// 02 : 서버 작업 처리도중 오류
                /// 03 : 이전 작업 처리중 오류
                /// 04 : 버전이 맞지 않음
                /// 05 : 작업이 진행중
                /// 06 : 작업이 거부됨
                /// 07 : 작업이 취소됨
                /// 08 : 서버 과부하
                /// 0a : 잘못된 사용자
                /// 0b : 잘못된 그룹
                /// 0c : 잘못된 ID
                /// 0d : 잘못된 데이터
                /// 0e : ID또는 패스워드가 잘못됨
                /// 0f : 패스워드가 잘못됨
                SendData = new byte[16];
                SendData[0] = inRecvData[0];
                SendData[1] = inRecvData[1];

                SendData[2] = DataLength[0];
                SendData[3] = DataLength[1];

                SendData[4] = inRecvData[4];
                SendData[5] = inRecvData[5];
                SendData[6] = inRecvData[6];
                SendData[7] = inRecvData[7];

                SendData[8] = Convert.ToByte(1);
                SendData[12] = Convert.ToByte(14);
                return SendData;
            }

            #endregion
        }

        public byte[] UserData(byte[] inRecvData, UserModel UserInfo)
        {
            byte[] SendData = null;
            byte[] DataLength = null;
            int SendDataLength = 0;

            byte[] Data = null;

            SendDataLength = 298;
            DataLength = ConvertLengthtoByte(SendDataLength);

            SendData = new byte[SendDataLength];
            SendData[0] = inRecvData[0];
            SendData[1] = inRecvData[1];

            SendData[2] = DataLength[0];
            SendData[3] = DataLength[1];

            SendData[4] = inRecvData[4];
            SendData[5] = inRecvData[5];
            SendData[6] = inRecvData[6];
            SendData[7] = inRecvData[7];

            //  8 ~ 11  = 에러처리
            // 12 ~ 13  = 에러코드

            // 아이디          - [12] / 16
            Data = Encoding.Default.GetBytes(UserInfo.AccountID);
            for (int i = 0; i < Data.Length; i++)
                SendData[12 + i] = Data[i];

            // 이름            - [28] / 12
            Data = Encoding.Default.GetBytes("포립");
            for (int i = 0; i < Data.Length; i++)
                SendData[28 + i] = Data[i];

            // 성별            - [40] / 2
            SendData[40] = Convert.ToByte(0);

            // 보유 아바타     - [42] / 2
            SendData[42] = Convert.ToByte(1);

            // 인벤토리        - [44] / 120

            // 아바타 정보     - [166] / 121
            if (UserInfo.AvatarList.Count < 1)
                Data = CommonLib.DummyAvatarData();
            else
                Data = Avatar_Data(UserInfo.AvatarList.Find(r => r.Order == UserInfo.AvatarOrder));

            for (int i = 0; i < Data.Length; i++)
                SendData[165 + i] = Data[i];

            // 푸터            - [550] / 4
            SendData[294] = Convert.ToByte(55);
            SendData[295] = Convert.ToByte(203);
            SendData[296] = Convert.ToByte(206);
            SendData[297] = Convert.ToByte(63);

            return SendData;
        }

        public byte[] EnterWorld(byte[] inRecvData, UserModel UserInfo)
        {
            byte[] SendData = null;
            byte[] DataLength = null;
            int SendDataLength = 0;

            byte[] AvatarData = Avatar_Full(UserInfo.AvatarList.Find(r => r.Order == UserInfo.AvatarOrder));
            SendDataLength = 12 + AvatarData.Length;
            DataLength = ConvertLengthtoByte(SendDataLength);

            SendData = new byte[SendDataLength];

            SendData[0] = inRecvData[0];
            SendData[1] = inRecvData[1];
            SendData[2] = DataLength[0];
            SendData[3] = DataLength[1];

            SendData[4] = inRecvData[4];
            SendData[5] = inRecvData[5];
            SendData[6] = inRecvData[6];
            SendData[7] = inRecvData[7];

            SendData[8] = Convert.ToByte(UserInfo.AvatarOrder);

            for (int i = 0; i < AvatarData.Length; i++)
                SendData[12 + i] = AvatarData[i];

            return SendData;
        }

        public byte[] CreateCharacter(byte[] inRecvData, string inAccountID)
        {
            byte[] SendData = null;
            byte[] DataLength = null;
            int SendDataLength = 142;

            byte[] Data = null;

            DataLength = ConvertLengthtoByte(SendDataLength);

            SendData = new byte[SendDataLength];
            SendData[0] = inRecvData[0];
            SendData[1] = inRecvData[1];

            SendData[2] = DataLength[0];
            SendData[3] = DataLength[1];

            SendData[4] = inRecvData[4];
            SendData[5] = inRecvData[5];
            SendData[6] = inRecvData[6];
            SendData[7] = inRecvData[7];

            //  8 ~ 11  = 에러처리
            // 12       = 에러코드
            if (AccountManager.GetAvatarCount(inAccountID) >= CommonLib.MAX_AVATAR_COUNT)
            {
                SendData[8] = Convert.ToByte(1);
                SendData[12] = Convert.ToByte(6);
                return SendData;
            }

            SendData[12] = Convert.ToByte(1);

            // 캐릭터 생성 처리
            // RecvData[12]                   - 캐릭터 구분 ( 1 byte)
            // RecvData[13] ~ inRecvData[35]  - 캐릭터 이름 (22 byte)
            // 아바타 정보     - [13] / 128
            AvatarModel CreateAvater = AccountManager.CreateAvatar(inRecvData, inAccountID);
            if (CreateAvater == null)
            {
                SendData[8] = Convert.ToByte(1);
                SendData[12] = Convert.ToByte(2);
                return SendData;
            }

            Data = Avatar_Data(CreateAvater);
            for (int i = 0; i < Data.Length; i++)
                SendData[13 + i] = Data[i];

            return SendData;
        }

        public byte[] DayGP(byte[] inRecvData, UserModel UserInfo)
        {
            byte[] SendData = null;
            byte[] DataLength = null;
            int SendDataLength = 20;

            TimeSpan SpanLogin = UserInfo.LastLogin - DateTime.Now;
            int GetGP = Convert.ToInt32(SpanLogin.TotalDays);
            if (GetGP > 5)
                GetGP = 5;

            GetGP *= 100;

            AccountManager.DayGP(UserInfo.AccountID, 0, GetGP);

            byte[] GiveGPData = BitConverter.GetBytes(GetGP);

            DataLength = ConvertLengthtoByte(SendDataLength);

            SendData = new byte[SendDataLength];

            SendData[0] = inRecvData[0];
            SendData[1] = inRecvData[1];
            SendData[2] = DataLength[0];
            SendData[3] = DataLength[1];

            SendData[4] = inRecvData[4];
            SendData[5] = inRecvData[5];
            SendData[6] = inRecvData[6];
            SendData[7] = inRecvData[7];

            SendData[8] = Convert.ToByte(6);

            for (int i = 0; i < GiveGPData.Length && i < 4; i++)
                SendData[16 + i] = GiveGPData[i];

            return SendData;
        }

        public byte[] MoveArea(byte[] inRecvData, ref Dictionary<int, string> refAreaPath)
        {
            byte[] SendData = null;
            byte[] DataLength = null;
            int SendDataLength = 0;

            string[] FullPath = null;
            int PathRootCount = 0;

            byte[] PathData = null;
            byte[] TargetPathData = null;
            byte[] ParentPathData = null;
            byte[] AreaNameData = null;
            string ArenaName_Kor = string.Empty;
            string ArenaName_Eng = string.Empty;

            if (inRecvData[12] != 47)
            {
                if (refAreaPath.Count > 1)
                {
                    ArenaName_Eng = CommonLib.AreaConvertEng(refAreaPath[refAreaPath.Count - 2]);
                    ArenaName_Kor = refAreaPath[refAreaPath.Count - 2];
                }
                else
                {
                    ArenaName_Kor = CommonLib.WorldMap_Kor;
                    ArenaName_Eng = CommonLib.WorldMap_Eng;
                }

                refAreaPath.Remove(refAreaPath.Count - 1);

                AreaNameData = Encoding.Default.GetBytes(ArenaName_Kor);
                ParentPathData = Encoding.Default.GetBytes(ArenaName_Eng);
                TargetPathData = Encoding.Default.GetBytes(ArenaName_Eng);
            }
            else
            {
                PathData = TargetPath(inRecvData);
                FullPath = Encoding.Default.GetString(PathData).Split('\0')[0].Split('/');
                foreach (string objArea in FullPath)
                {
                    if (objArea.Length > 1)
                        PathRootCount++;
                }

                ArenaName_Kor = CommonLib.AreaConvertKor(FullPath[PathRootCount]);
                ArenaName_Eng = FullPath[PathRootCount];
                AreaNameData = Encoding.Default.GetBytes(ArenaName_Kor);

                if (PathRootCount == 1)
                {
                    ParentPathData = Encoding.Default.GetBytes(ArenaName_Eng);
                    TargetPathData = Encoding.Default.GetBytes(ArenaName_Eng);
                    refAreaPath.Clear();
                    refAreaPath.Add(0, ArenaName_Kor);
                }
                else
                {
                    ParentPathData = Encoding.Default.GetBytes(FullPath[PathRootCount - 1]);
                    TargetPathData = Encoding.Default.GetBytes(ArenaName_Eng);
                    if (refAreaPath.ContainsValue(ArenaName_Kor) == true)
                        refAreaPath.Remove(refAreaPath.Count - 1);
                    else
                        refAreaPath.Add(refAreaPath.Count, CommonLib.AreaConvertKor(FullPath[PathRootCount]));
                }
            }

            SendDataLength = 120;
            DataLength = ConvertLengthtoByte(SendDataLength);

            SendData = new byte[SendDataLength];

            SendData[0] = Convert.ToByte(2);

            SendData[2] = DataLength[0];
            SendData[3] = DataLength[1];

            // 대상 지역
            for (int i = 0; i < TargetPathData.Length; i++)
                SendData[12 + i] = TargetPathData[i];
            // 지역 이름
            for (int i = 0; i < AreaNameData.Length; i++)
                SendData[44 + i] = AreaNameData[i];
            // 상위 지역
            for (int i = 0; i < ParentPathData.Length; i++)
                SendData[85 + i] = ParentPathData[i];

            return SendData;
        }

        public byte[] ShopList(string inAreaName_Kor, int inSeries = -1, int inMountType = -1, int inSex = -1)
        {
            byte[] SendData = null;
            byte[] DataLength = null;
            int SendDataLength = 0;

            byte[] Data = null;

            bool SeriesCheck = false;
            int SeriesIndex = -1;
            string Series = string.Empty;
            string AreaName_Eng = CommonLib.AreaConvertEng(inAreaName_Kor);

            List<object> ShopItemList = null;
            List<ItemModel> ItemShopList = null;
            List<CardModel> CardShopList = null;

            switch (inAreaName_Kor)
            {
                #region 매직 카덴 - 카드상점 / CardShop
                case "매직 카덴":
                    SeriesIndex = 7;
                    SeriesCheck = true;
                    bool CardRank = Convert.ToBoolean(inSeries);
                    if (CardRank)
                        CardShopList = DataContainer.GetCardList().FindAll(r => r.Rank == "Valuable");
                    else
                        CardShopList = DataContainer.GetCardList().FindAll(r => r.Rank == "Normal");

                    ShopItemList = new List<object>(CardShopList);

                    break;

                #endregion

                #region 캐즈팝 - 악세사리 / AccessoryShop
                case "캐즈팝":

                    SeriesIndex = 7;
                    SeriesCheck = true;

                    switch (inSeries)
                    {
                        case 11:
                            Series = "Event";
                            break;
                        case 13:
                            Series = "Life";
                            break;
                        case 14:
                            Series = "Student";
                            break;
                        case 15:
                            Series = "Sport";
                            break;
                        case 16:
                            Series = "Accessories";
                            break;
                        case 17:
                            Series = "Weapone";
                            break;
                        default:
                            Series = "None";
                            break;
                    }

                    ItemShopList = DataContainer.GetShopGoods(AreaName_Eng).FindAll(r => r.Sex == inSex && r.Series == Series);
                    ShopItemList = new List<object>(ItemShopList);
                    break;

                #endregion

                #region 실키필 - 가발 / HairShop
                case "실키필":

                    SeriesIndex = 7;
                    SeriesCheck = true;

                    switch (inSeries)
                    {
                        case 0:
                        case 1:
                            ItemShopList = DataContainer.GetShopGoods(AreaName_Eng).FindAll(r => r.Sex == inSex
                                && (r.Series == "Shivan" || r.Series == "Genesis" || r.Series == "Apocalyse" || r.Series == "Crimson"));
                            break;
                        case 7:
                            Series = "Fantasy";
                            break;
                        case 8:
                            Series = "Original";
                            break;
                        case 9:
                            Series = "Morden";
                            break;
                        case 12:
                            Series = "Magnacarta";
                            break;
                        case 11:
                            Series = "Event";
                            break;
                        default:
                            Series = "None";
                            break;
                    }

                    if (inSeries > 1)
                        ItemShopList = DataContainer.GetShopGoods(AreaName_Eng).FindAll(r => r.Sex == inSex && r.Mount == inMountType && r.Series == Series);

                    ShopItemList = new List<object>(ItemShopList);

                    break;

                #endregion

                #region 댄디캣 클래식 - 의상 / DressShop
                case "댄디캣 클래식":

                    SeriesIndex = 6;

                    switch (inSeries)
                    {
                        case 1:
                            Series = "Gray";
                            break;
                        case 2:
                            Series = "WestWind";
                            break;
                        case 3:
                            Series = "Tempest";
                            break;
                        case 4:
                            Series = "Shivan";
                            break;
                        case 5:
                            Series = "Crimson";
                            break;
                        case 6:
                            Series = "Apocalyse";
                            break;
                        case 10:
                            Series = "G3P2";
                            break;
                        case 12:
                            Series = "Magnacarta";
                            break;
                        default:
                            Series = "None";
                            break;
                    }

                    ItemShopList = DataContainer.GetShopGoods(AreaName_Eng).FindAll(r => r.Sex == inSex && r.Series == Series && r.Mount == inMountType);
                    ShopItemList = new List<object>(ItemShopList);

                    break;

                #endregion

                #region 댄디캣 - 의상 / DressShop2
                case "댄디캣":

                    SeriesIndex = 6;

                    switch (inSeries)
                    {
                        case 7:
                            Series = "Fantasy";
                            break;
                        case 8:
                            Series = "Original";
                            break;
                        case 9:
                            Series = "Morden";
                            break;
                        case 11:
                            Series = "Event";
                            break;
                    }

                    ItemShopList = DataContainer.GetShopGoods(AreaName_Eng).FindAll(r => r.Sex == inSex && r.Mount == inMountType && r.Series == Series);
                    ShopItemList = new List<object>(ItemShopList);

                    break;

                #endregion
            }

            SendDataLength = 9 + (ShopItemList.Count * 4);

            DataLength = ConvertLengthtoByte(SendDataLength);

            SendData = new byte[SendDataLength];
            SendData[0] = Convert.ToByte(10);
            SendData[2] = DataLength[0];
            SendData[3] = DataLength[1];
            SendData[4] = Convert.ToByte(SeriesIndex);

            int DataIndex = 8;

            if (SeriesCheck)
                SendData[DataIndex++] = Convert.ToByte(ShopItemList.Count);

            foreach (ShopBaseModel Item in ShopItemList)
            {
                Data = BitConverter.GetBytes(Item.Index);
                SendData[DataIndex++] = Data[0];
                SendData[DataIndex++] = Data[1];
                Data = BitConverter.GetBytes(Item.Type);
                SendData[DataIndex++] = Data[0];
                SendData[DataIndex++] = Data[1];
            }

            return SendData;
        }

        public byte[] ShopItemInfo(byte[] inRecvData, bool UsedPrice = false)
        {
            byte[] SendData = null;
            byte[] DataLength = null;
            int SendDataLength = 16;

            byte[] Data = new byte[4];
            Data[0] = inRecvData[8];
            Data[1] = inRecvData[9];

            int ItemIndex = BitConverter.ToInt32(Data, 0);

            DataLength = ConvertLengthtoByte(SendDataLength);

            SendData = new byte[SendDataLength];

            SendData[0] = inRecvData[0];
            SendData[1] = inRecvData[1];
            SendData[2] = DataLength[0];
            SendData[3] = DataLength[1];

            if (UsedPrice)
                SendData[4] = Convert.ToByte(11);
            else
                SendData[4] = Convert.ToByte(7);

            ShopBaseModel SelectItem = null;
            if (UsedPrice)
                SelectItem = DataContainer.FindCard(ItemIndex);
            else
                SelectItem = DataContainer.FindItem(ItemIndex);

            // 아이템 인덱스
            Data = BitConverter.GetBytes(SelectItem.Index);
            SendData[8] = Data[0];
            SendData[9] = Data[1];
            // 아이템 타입
            Data = BitConverter.GetBytes(SelectItem.Type);
            SendData[10] = Data[0];
            SendData[11] = Data[1];

            // 아이템 가격
            if (UsedPrice)
                Data = BitConverter.GetBytes(SelectItem.SellPrice);
            else
                Data = BitConverter.GetBytes(SelectItem.BuyPrice);
            for (int i = 0; i < 4; i++)
                SendData[12 + i] = Data[i];

            return SendData;
        }

        public byte[] ShopACItemInfo(byte[] inRecvData, bool CardShop = false)
        {
            byte[] SendData = null;
            byte[] DataLength = null;
            int SendDataLength = 18;

            byte[] Data = new byte[4];
            Data[0] = inRecvData[8];
            Data[1] = inRecvData[9];

            int ItemIndex = BitConverter.ToInt32(Data, 0);

            DataLength = ConvertLengthtoByte(SendDataLength);

            SendData = new byte[SendDataLength];

            SendData[0] = inRecvData[0];
            SendData[1] = inRecvData[1];
            SendData[2] = DataLength[0];
            SendData[3] = DataLength[1];

            SendData[4] = Convert.ToByte(8);

            ShopBaseModel SelectItem = null;
            if (inRecvData.Length > 9)
                SelectItem = DataContainer.FindCard(ItemIndex);
            else
                SelectItem = DataContainer.FindItem(ItemIndex);

            // 아이템 인덱스
            Data = BitConverter.GetBytes(SelectItem.Index);
            SendData[8] = Data[0];
            SendData[9] = Data[1];
            // 아이템 타입
            Data = BitConverter.GetBytes(SelectItem.Type);
            SendData[10] = Data[0];
            SendData[11] = Data[1];

            // 아이템 가격
            Data = BitConverter.GetBytes(SelectItem.BuyPrice);
            for (int i = 0; i < 2; i++)
                SendData[12 + i] = Data[i];

            // 수량
            Data = BitConverter.GetBytes(SelectItem.Quantity);
            SendData[16] = Data[0];
            SendData[17] = Data[1];

            return SendData;
        }

        public byte[] BuyItem(byte[] inRecvData, UserModel UserInfo)
        {
            byte[] SendData = null;
            byte[] DataLength = null;
            int SendDataLength = 0;

            byte[] Data = new byte[4];
            Data[0] = inRecvData[8];
            Data[1] = inRecvData[9];

            int ItemIndex = BitConverter.ToInt32(Data, 0);
            ItemModel SelectItem = DataContainer.FindItem(ItemIndex);
            AvatarModel AvatarInfo = UserInfo.AvatarList.Find(r => r.Order == UserInfo.AvatarOrder);

            SendDataLength = 12;
            DataLength = ConvertLengthtoByte(SendDataLength);

            SendData = new byte[SendDataLength];

            SendData[0] = inRecvData[0];
            SendData[1] = inRecvData[1];
            SendData[2] = DataLength[0];
            SendData[3] = DataLength[1];

            if (AvatarInfo.GP < SelectItem.BuyPrice)
            {
                SendData[4] = Convert.ToByte(0);
                SendData[8] = Convert.ToByte(2);
                return SendData;
            }

            if (AccountManager.BuyItem(UserInfo.AccountID, UserInfo.AvatarOrder, ItemIndex) == false)
            {
                SendData[4] = Convert.ToByte(0);
                SendData[8] = Convert.ToByte(1);
                return SendData;
            }

            SendDataLength = 16;
            DataLength = ConvertLengthtoByte(SendDataLength);

            SendData = new byte[SendDataLength];

            SendData[0] = inRecvData[0];
            SendData[1] = inRecvData[1];
            SendData[2] = DataLength[0];
            SendData[3] = DataLength[1];

            SendData[4] = Convert.ToByte(9);

            // 아이템 인덱스
            Data = BitConverter.GetBytes(SelectItem.Index);
            SendData[8] = Data[0];
            SendData[9] = Data[1];
            // 아이템 타입
            Data = BitConverter.GetBytes(SelectItem.Type);
            SendData[10] = Data[0];
            SendData[11] = Data[1];

            // 잔액
            AvatarInfo.GP -= SelectItem.BuyPrice;
            if (AvatarInfo.GP < 0)
                AvatarInfo.GP = 0;

            Data = BitConverter.GetBytes(AvatarInfo.GP);
            for (int i = 0; i < 4; i++)
                SendData[12 + i] = Data[i];

            return SendData;
        }

        public byte[] BuyACItem(byte[] inRecvData, UserModel UserInfo, bool CardShop = false)
        {
            byte[] SendData = null;
            byte[] DataLength = null;
            int SendDataLength = 0;

            byte[] Data = new byte[4];
            Data[0] = inRecvData[8];
            Data[1] = inRecvData[9];

            int ItemIndex = BitConverter.ToInt32(Data, 0);
            AvatarModel AvatarInfo = UserInfo.AvatarList.Find(r => r.Order == UserInfo.AvatarOrder);

            ShopBaseModel SelectItem = null;
            if (CardShop)
            {
                DataContainer.FindCard(ItemIndex).Quantity--;
                SelectItem = DataContainer.FindCard(ItemIndex);
            }
            else
                SelectItem = DataContainer.FindItem(ItemIndex);

            SendDataLength = 12;
            DataLength = ConvertLengthtoByte(SendDataLength);

            SendData = new byte[SendDataLength];

            SendData[0] = inRecvData[0];
            SendData[1] = inRecvData[1];
            SendData[2] = DataLength[0];
            SendData[3] = DataLength[1];

            if (AvatarInfo.GP < SelectItem.BuyPrice)
            {
                SendData[4] = Convert.ToByte(0);
                SendData[8] = Convert.ToByte(2);
                return SendData;
            }

            if (AccountManager.BuyItem(UserInfo.AccountID, UserInfo.AvatarOrder, ItemIndex) == false)
            {
                SendData[4] = Convert.ToByte(0);
                SendData[8] = Convert.ToByte(1);
                return SendData;
            }

            SendDataLength = 20;
            DataLength = ConvertLengthtoByte(SendDataLength);

            SendData = new byte[SendDataLength];

            SendData[0] = inRecvData[0];
            SendData[1] = inRecvData[1];
            SendData[2] = DataLength[0];
            SendData[3] = DataLength[1];

            SendData[4] = Convert.ToByte(10);

            // 잔액
            AvatarInfo.GP -= SelectItem.BuyPrice;
            if (AvatarInfo.GP < 0)
                AvatarInfo.GP = 0;
            Data = BitConverter.GetBytes(AvatarInfo.GP);
            for (int i = 0; i < 4; i++)
                SendData[8 + i] = Data[i];

            // 아이템 인덱스
            Data = BitConverter.GetBytes(SelectItem.Index);
            SendData[12] = Data[0];
            SendData[13] = Data[1];
            // 아이템 타입
            Data = BitConverter.GetBytes(SelectItem.Type);
            SendData[14] = Data[0];
            SendData[15] = Data[1];

            // 구매 가격
            Data = BitConverter.GetBytes(SelectItem.BuyPrice);
            for (int i = 0; i < 4; i++)
                SendData[16 + i] = Data[i];

            return SendData;
        }

        public byte[] SellItem(byte[] inRecvData, UserModel UserInfo)
        {
            byte[] SendData = null;
            byte[] DataLength = null;
            int SendDataLength = 0;

            int SelectIndex = Convert.ToInt32(inRecvData[8]) - 10;

            AvatarModel AvatarInfo = UserInfo.AvatarList.Find(r => r.Order == UserInfo.AvatarOrder);

            SendDataLength = 12;
            DataLength = ConvertLengthtoByte(SendDataLength);

            SendData = new byte[SendDataLength];

            SendData[0] = inRecvData[0];
            SendData[1] = inRecvData[1];
            SendData[2] = DataLength[0];
            SendData[3] = DataLength[1];

            SendData[4] = Convert.ToByte(0);

            if (AvatarInfo.Inven.Exists(r => r.ItemIndex == SelectIndex) == false ||
                AvatarInfo.Inven.Count <= SelectIndex)
            {
                SendData[8] = Convert.ToByte(1);
                return SendData;
            }

            ItemModel SelectItem = DataContainer.FindItem(AvatarInfo.Inven[SelectIndex].ItemIndex);

            if (AccountManager.SellItem(UserInfo.AccountID, UserInfo.AvatarOrder, SelectItem.Index) == false)
            {
                SendData[8] = Convert.ToByte(1);
                return SendData;
            }

            SendDataLength = 16;
            DataLength = ConvertLengthtoByte(SendDataLength);

            SendData = new byte[SendDataLength];

            SendData[0] = inRecvData[0];
            SendData[1] = inRecvData[1];
            SendData[2] = DataLength[0];
            SendData[3] = DataLength[1];

            SendData[4] = Convert.ToByte(10);

            byte[] Data = null;

            // 아이템 인덱스
            Data = BitConverter.GetBytes(SelectItem.Index);
            SendData[8] = Data[0];
            SendData[9] = Data[1];
            // 아이템 타입
            Data = BitConverter.GetBytes(SelectItem.Type);
            SendData[10] = Data[0];
            SendData[11] = Data[1];

            //// 잔액
            AvatarInfo.GP += SelectItem.SellPrice;
            Data = BitConverter.GetBytes(AvatarInfo.GP);
            for (int i = 0; i < 4; i++)
                SendData[12 + i] = Data[i];

            return SendData;
        }

        public byte[] SellACItem(byte[] inRecvData, UserModel UserInfo, bool CardShop = false)
        {
            byte[] SendData = null;
            byte[] DataLength = null;
            int SendDataLength = 0;

            int SelectIndex = Convert.ToInt32(inRecvData[8]) - 10;

            AvatarModel AvatarInfo = UserInfo.AvatarList.Find(r => r.Order == UserInfo.AvatarOrder);

            SendDataLength = 12;
            DataLength = ConvertLengthtoByte(SendDataLength);

            SendData = new byte[SendDataLength];

            SendData[0] = inRecvData[0];
            SendData[1] = inRecvData[1];
            SendData[2] = DataLength[0];
            SendData[3] = DataLength[1];

            SendData[4] = Convert.ToByte(0);

            if (AvatarInfo.Inven.Exists(r => r.ItemIndex == SelectIndex) == false ||
                AvatarInfo.Inven.Count <= SelectIndex)
            {
                SendData[8] = Convert.ToByte(1);
                return SendData;
            }

            ShopBaseModel SelectItem = null;
            if (CardShop)
                SelectItem = DataContainer.FindCard(AvatarInfo.Inven[SelectIndex].ItemIndex);
            else
                SelectItem = DataContainer.FindItem(AvatarInfo.Inven[SelectIndex].ItemIndex);

            if (AccountManager.SellItem(UserInfo.AccountID, UserInfo.AvatarOrder, SelectItem.Index) == false)
            {
                SendData[8] = Convert.ToByte(1);
                return SendData;
            }

            SendDataLength = 16;
            DataLength = ConvertLengthtoByte(SendDataLength);

            SendData = new byte[SendDataLength];

            SendData[0] = inRecvData[0];
            SendData[1] = inRecvData[1];
            SendData[2] = DataLength[0];
            SendData[3] = DataLength[1];

            SendData[4] = Convert.ToByte(11);

            byte[] Data = null;

            // 아이템 인덱스
            Data = BitConverter.GetBytes(SelectItem.Index);
            SendData[8] = Data[0];
            SendData[9] = Data[1];
            // 아이템 타입
            Data = BitConverter.GetBytes(SelectItem.Type);
            SendData[10] = Data[0];
            SendData[11] = Data[1];

            // 잔액
            AvatarInfo.GP += SelectItem.SellPrice;
            Data = BitConverter.GetBytes(AvatarInfo.GP);
            for (int i = 0; i < 4; i++)
                SendData[12 + i] = Data[i];

            return SendData;
        }

        public byte[] SetCostume(byte[] inRecvData, UserModel UserInfo)
        {
            byte[] SendData = null;
            byte[] DataLength = null;
            int SendDataLength = 12;

            DataLength = ConvertLengthtoByte(SendDataLength);

            SendData = new byte[SendDataLength];

            SendData[0] = inRecvData[0];
            SendData[1] = inRecvData[1];
            SendData[2] = DataLength[0];
            SendData[3] = DataLength[1];

            SendData[4] = inRecvData[4];
            SendData[5] = inRecvData[5];
            SendData[6] = inRecvData[6];
            SendData[7] = inRecvData[7];

            UserInfo.AvatarList.Find(r => r.Order == UserInfo.AvatarOrder).SetCostume(this.CheckedInven(inRecvData, 13, 4));

            if (AccountManager.UpdateCostume(UserInfo.AccountID, UserInfo.AvatarList.Find(r => r.Order == UserInfo.AvatarOrder)))
                SendData[8] = Convert.ToByte(0);
            else
                SendData[8] = Convert.ToByte(2);

            return SendData;
        }

        public byte[] Disconnection(byte[] inRecvData, int inConnTime, int inGetGP)
        {
            byte[] SendData = null;
            byte[] DataLength = null;
            int SendDataLength = 0;

            byte[] Data = null;

            SendDataLength = 24;
            DataLength = ConvertLengthtoByte(SendDataLength);

            SendData = new byte[SendDataLength];

            SendData[0] = inRecvData[0];
            SendData[1] = inRecvData[1];

            SendData[2] = DataLength[0];
            SendData[3] = DataLength[1];

            SendData[4] = inRecvData[4];
            SendData[5] = inRecvData[5];
            SendData[6] = inRecvData[6];
            SendData[7] = inRecvData[7];

            SendData[8] = Convert.ToByte(7);

            Data = BitConverter.GetBytes(inConnTime);
            SendData[12] = Data[0];
            SendData[13] = Data[1];
            SendData[14] = Data[2];
            SendData[15] = Data[3];

            Data = BitConverter.GetBytes(inGetGP);
            SendData[20] = Data[0];
            SendData[21] = Data[1];
            SendData[22] = Data[2];
            SendData[23] = Data[3];

            return SendData;
        }

        public byte[] ConnClose()
        {
            byte[] SendData = null;
            byte[] DataLength = null;
            int SendDataLength = 8;

            DataLength = ConvertLengthtoByte(SendDataLength);
            SendData = new byte[SendDataLength];

            SendData[2] = DataLength[0];
            SendData[3] = DataLength[1];

            SendData[4] = Convert.ToByte(4);
            SendData[6] = Convert.ToByte(1);

            return SendData;
        }

        public byte[] ChatRoomList()
        {
            byte[] SendData = null;
            byte[] DataLength = null;
            int SendDataLength = 12;

            DataLength = ConvertLengthtoByte(SendDataLength);

            SendData = new byte[SendDataLength];

            SendData[0] = Convert.ToByte(10);
            SendData[2] = DataLength[0];
            SendData[3] = DataLength[1];

            SendData[4] = Convert.ToByte(4);

            return SendData;
        }

        public byte[] AreaWeather(string inWeather)
        {
            byte[] SendData = null;
            byte[] DataLength = null;
            int SendDataLength = 16;

            byte[] Data = null;

            DataLength = ConvertLengthtoByte(SendDataLength);
            SendData = new byte[SendDataLength];

            SendData[0] = Convert.ToByte(11);
            SendData[2] = DataLength[0];
            SendData[3] = DataLength[1];

            SendData[4] = Convert.ToByte(9);

            Data = Encoding.Default.GetBytes(inWeather);
            for (int i = 0; i < Data.Length; i++)
                SendData[8 + i] = Data[i];

            return SendData;
        }

        public void EnterAreaUserList(byte[] inRecvData, string inAreaName_Kor)
        {
            byte[] SendData = null;
            byte[] DataLength = null;
            int SendDataLength = 0;

            byte[] Data = null;

            List<string> AreaCharacterList = new List<string>();
            List<NTClient> UserList = new List<NTClient>(LeafConnection.ConnUserList.FindAll(r => r.UserInfo.AvatarList[r.UserInfo.AvatarOrder].CharacterName != null
                && r.UserInfo.AvatarList[r.UserInfo.AvatarOrder].CharacterName.Length > 0
                && r.CurrentArea == inAreaName_Kor));

            lock (UserList)
            {
                foreach (NTClient Client in UserList)
                    AreaCharacterList.Add(Client.UserInfo.AvatarList[Client.UserInfo.AvatarOrder].CharacterName);

                foreach (NTClient Client in UserList)
                {
                    SendDataLength = 30;
                    DataLength = ConvertLengthtoByte(SendDataLength);

                    SendData = new byte[SendDataLength];

                    SendData[0] = inRecvData[6];

                    SendData[2] = DataLength[0];
                    SendData[3] = DataLength[1];

                    switch (inAreaName_Kor)
                    {
                        case "켈티카의 거리":
                            SendData[4] = Convert.ToByte(11);
                            break;
                        case "네냐플 마법학원":
                        case "매직 카덴":
                        case "댄디캣 클래식":
                        case "댄디캣":
                        case "캐즈팝":
                        case "실키필":
                            SendData[4] = Convert.ToByte(1);
                            break;
                        case "프레쉬센트":
                            SendData[4] = Convert.ToByte(3);
                            break;
                        case "북 하이아칸":
                        case "남 하이아칸":
                        case "레코르다블":
                        case "주사위의 잔영":
                            SendData[4] = Convert.ToByte(4);
                            break;
                        case "와글와글스피치":
                        case "세미나실":
                            if (SendData[0] == 10)
                                return; ;
                            SendData[4] = Convert.ToByte(3);
                            break;
                        case "실버 호라이즌":
                        case "화이트 크리스탈":
                        case "퓨어 시린":
                        case "윈트리 아이스":
                        case "스노우 풀":
                        case "샤이닝 브리즈":
                        case "스위트 쟈스민":
                        case "그린 에메랄드":
                        case "블루 사파이어":
                        case "헤이즐리 웨이브":
                        case "아쿠아 코럴":
                        case "블래싱 마린":
                        case "미스틱 머메이드":
                        case "매쉬 메리골드":
                        case "엘핀 포레스트":
                        case "블랜드 제피르":
                        default:
                            if (SendData[0] == 10)
                                return;
                            SendData[4] = Convert.ToByte(1);
                            break;
                    }

                    Data = BitConverter.GetBytes(Client.AreaIndex);
                    for (int i = 0; i < 4; i++)
                        SendData[8 + i] = Data[i];
                    Data = Encoding.Default.GetBytes(Client.UserInfo.AvatarList[Client.UserInfo.AvatarOrder].CharacterName);
                    for (int i = 0; i < Data.Length; i++)
                        SendData[12 + i] = Data[i];
                    Client.ClientSocket.Send(SendData);
                }
            }
        }

        public void LeaveAreaUserList(string inCharacterName, string inAreaName_Kor)
        {
            byte[] SendData = null;
            byte[] DataLength = null;
            int SendDataLength = 0;

            byte[] Data = null;

            List<string> AreaCharacterList = new List<string>();
            List<NTClient> UserList = new List<NTClient>(LeafConnection.ConnUserList.FindAll(r => r.UserInfo.AvatarList[r.UserInfo.AvatarOrder].CharacterName != null
                && r.UserInfo.AvatarList[r.UserInfo.AvatarOrder].CharacterName.Length > 0
                && r.UserInfo.AvatarList[r.UserInfo.AvatarOrder].CharacterName != inCharacterName
                && r.CurrentArea == inAreaName_Kor));

            if (UserList.Count < 1)
                return;

            lock (UserList)
            {
                foreach (NTClient Client in UserList)
                    AreaCharacterList.Add(Client.UserInfo.AvatarList[Client.UserInfo.AvatarOrder].CharacterName);

                foreach (NTClient Client in UserList)
                {
                    SendDataLength = 30;
                    DataLength = ConvertLengthtoByte(SendDataLength);

                    SendData = new byte[SendDataLength];

                    SendData[0] = Convert.ToByte(10);

                    SendData[2] = DataLength[0];
                    SendData[3] = DataLength[1];

                    switch (inAreaName_Kor)
                    {
                        case "켈티카의 거리":
                            SendData[4] = Convert.ToByte(12);
                            break;
                        case "네냐플 마법학원":
                        case "매직 카덴":
                        case "댄디캣 클래식":
                        case "댄디캣":
                        case "캐즈팝":
                        case "실키필":
                            SendData[4] = Convert.ToByte(2);
                            break;
                        case "프레쉬센트":
                            SendData[4] = Convert.ToByte(4);
                            break;
                        case "북 하이아칸":
                        case "남 하이아칸":
                        case "레코르다블":
                        case "주사위의 잔영":
                            SendData[4] = Convert.ToByte(5);
                            break;
                        case "와글와글스피치":
                        case "세미나실":
                            SendData[0] = Convert.ToByte(11);
                            SendData[4] = Convert.ToByte(4);
                            break;
                        case "실버 호라이즌":
                        case "화이트 크리스탈":
                        case "퓨어 시린":
                        case "윈트리 아이스":
                        case "스노우 풀":
                        case "샤이닝 브리즈":
                        case "스위트 쟈스민":
                        case "그린 에메랄드":
                        case "블루 사파이어":
                        case "헤이즐리 웨이브":
                        case "아쿠아 코럴":
                        case "블래싱 마린":
                        case "미스틱 머메이드":
                        case "매쉬 메리골드":
                        case "엘핀 포레스트":
                        case "블랜드 제피르":
                        default:
                            SendData[0] = Convert.ToByte(11);
                            SendData[4] = Convert.ToByte(2);
                            break;
                    }

                    Data = BitConverter.GetBytes(Client.AreaIndex);
                    for (int i = 0; i < 4; i++)
                        SendData[8 + i] = Data[i];
                    Data = Encoding.Default.GetBytes(Client.UserInfo.AvatarList[Client.UserInfo.AvatarOrder].CharacterName);
                    for (int i = 0; i < Data.Length; i++)
                        SendData[12 + i] = Data[i];
                    Client.ClientSocket.Send(SendData);
                }
            }
        }

        public void SendChatMessage(byte[] inRecvData, string inAreaName_Kor)
        {
            byte[] SendData = null;
            byte[] DataLength = null;
            int SendDataLength = 0;

            byte[] Data = null;
            string ChatMessge = GetMessage(inRecvData);

            List<string> AreaCharacterList = new List<string>();
            List<NTClient> UserList = new List<NTClient>(LeafConnection.ConnUserList.FindAll(r => r.UserInfo.AvatarList[r.UserInfo.AvatarOrder].CharacterName != null
                && r.UserInfo.AvatarList[r.UserInfo.AvatarOrder].CharacterName.Length > 0
                && r.CurrentArea == inAreaName_Kor
                && r.EnterRoom == false));

            lock (UserList)
            {
                foreach (NTClient Client in UserList)
                    AreaCharacterList.Add(Client.UserInfo.AvatarList[Client.UserInfo.AvatarOrder].CharacterName);

                foreach (NTClient Client in UserList)
                {
                    Data = Encoding.Default.GetBytes(ChatMessge);
                    SendDataLength = 12 + Data.Length + 1;
                    DataLength = ConvertLengthtoByte(SendDataLength);

                    SendData = new byte[SendDataLength];
                    SendData[0] = Convert.ToByte(10);

                    SendData[2] = DataLength[0];
                    SendData[3] = DataLength[1];

                    switch (inAreaName_Kor)
                    {
                        case "켈티카의 거리":
                        case "댄디캣 클래식":
                        case "댄디캣":
                        case "프레쉬센트":
                            SendData[4] = Convert.ToByte(5);
                            break;
                        case "네냐플 마법학원":
                            SendData[4] = Convert.ToByte(3);
                            break;
                        case "매직 카덴":
                        case "캐즈팝":
                        case "실키필":
                        case "북 하이아칸":
                        case "남 하이아칸":
                        case "레코르다블":
                            SendData[4] = Convert.ToByte(6);
                            break;
                        case "와글와글 스피치":
                        case "세미나실":
                            SendData[0] = Convert.ToByte(11);
                            SendData[4] = Convert.ToByte(3);
                            break;
                        case "실버 호라이즌":
                        case "화이트 크리스탈":
                        case "퓨어 시린":
                        case "윈트리 아이스":
                        case "스노우 풀":
                        case "샤이닝 브리즈":
                        case "스위트 쟈스민":
                        case "그린 에메랄드":
                        case "블루 사파이어":
                        case "헤이즐리 웨이브":
                        case "아쿠아 코럴":
                        case "블래싱 마린":
                        case "미스틱 머메이드":
                        case "매쉬 메리골드":
                        case "엘핀 포레스트":
                        case "블랜드 제피르":
                        default:
                            SendData[0] = Convert.ToByte(11);
                            SendData[4] = Convert.ToByte(8);
                            break;
                    }

                    Data = BitConverter.GetBytes(Client.AreaIndex);
                    for (int i = 0; i < 4; i++)
                        SendData[8 + i] = Data[i];

                    Data = Encoding.Default.GetBytes(ChatMessge);
                    for (int i = 0; i < Data.Length; i++)
                        SendData[12 + i] = Data[i];
                    Client.ClientSocket.Send(SendData);
                }
            }
        }

        public void CreateChatRoom(byte[] inRecvData, UserModel UserInfo, string inAreaName_Kor, int inAreaIndex)
        {
            byte[] SendData = null;
            byte[] DataLength = null;
            int SendDataLength = 0;

            int RoomIndex = Convert.ToInt32(inRecvData[8]);
            string Creator = UserInfo.AvatarList.Find(r => r.Order == UserInfo.AvatarOrder).CharacterName;
            byte[] Data = Encoding.Default.GetBytes(Creator);

            List<NTClient> UserList = new List<NTClient>(LeafConnection.ConnUserList.FindAll(r => r.UserInfo.AvatarList[r.UserInfo.AvatarOrder].CharacterName != null
                && r.UserInfo.AvatarList[r.UserInfo.AvatarOrder].CharacterName.Length > 0
                && r.CurrentArea == inAreaName_Kor));

            lock (UserList)
            {
                foreach (NTClient Client in UserList)
                {
                    if (inAreaIndex == Client.AreaIndex)
                    {
                        Client.ChatRoomIndex = RoomIndex;

                        SendDataLength = 10;
                        DataLength = ConvertLengthtoByte(SendDataLength);

                        SendData = new byte[SendDataLength];
                        SendData[0] = Convert.ToByte(11);

                        SendData[2] = DataLength[0];
                        SendData[3] = DataLength[1];

                        SendData[4] = Convert.ToByte(4);
                        SendData[8] = Convert.ToByte(RoomIndex);
                    }
                    else
                    {
                        SendDataLength = 12 + Data.Length;
                        DataLength = ConvertLengthtoByte(SendDataLength);

                        SendData = new byte[SendDataLength];
                        SendData[0] = Convert.ToByte(11);

                        SendData[2] = DataLength[0];
                        SendData[3] = DataLength[1];

                        SendData[4] = Convert.ToByte(3);
                        SendData[8] = Convert.ToByte(RoomIndex);

                        for (int i = 0; i < Data.Length; i++)
                            SendData[12] = Data[i];
                    }

                    Client.ClientSocket.Send(SendData);
                }
            }
        }

        public void CancelRoomCreate(byte[] inRecvData, string inAreaName_Kor, int inRoomIndex)
        {
            byte[] SendData = null;
            byte[] DataLength = null;
            int SendDataLength = 0;

            List<NTClient> UserList = new List<NTClient>(LeafConnection.ConnUserList.FindAll(r => r.UserInfo.AvatarList[r.UserInfo.AvatarOrder].CharacterName != null
                && r.UserInfo.AvatarList[r.UserInfo.AvatarOrder].CharacterName.Length > 0
                && r.CurrentArea == inAreaName_Kor));

            lock (UserList)
            {
                foreach (NTClient Client in UserList)
                {
                    SendDataLength = 12;
                    DataLength = ConvertLengthtoByte(SendDataLength);

                    SendData = new byte[SendDataLength];
                    SendData[0] = Convert.ToByte(11);

                    SendData[2] = DataLength[0];
                    SendData[3] = DataLength[1];

                    SendData[4] = Convert.ToByte(5);
                    SendData[8] = Convert.ToByte(inRoomIndex);

                    SendData[11] = Convert.ToByte(0);

                    Client.ClientSocket.Send(SendData);
                }
            }
        }

        public void BuildChatRoom(byte[] inRecvData, string inAreaName_Kor, int inRoomIndex, NTClient Owner)
        {
            byte[] SendData = null;
            byte[] DataLength = null;
            int SendDataLength = 0;

            ChatRoomModel NewRoom = GetRoomInfo(inRecvData, inRoomIndex, Owner);
            ServChat.ChatRoomList.Add(NewRoom);

            byte[] Data = Encoding.Default.GetBytes(NewRoom.Title);

            List<NTClient> UserList = new List<NTClient>(LeafConnection.ConnUserList.FindAll(r => r.UserInfo.AvatarList[r.UserInfo.AvatarOrder].CharacterName != null
                && r.UserInfo.AvatarList[r.UserInfo.AvatarOrder].CharacterName.Length > 0
                && r.CurrentArea == inAreaName_Kor));

            lock (UserList)
            {
                SendDataLength = 16 + Data.Length + 1;
                DataLength = ConvertLengthtoByte(SendDataLength);

                SendData = new byte[SendDataLength];
                SendData[0] = Convert.ToByte(11);

                SendData[2] = DataLength[0];
                SendData[3] = DataLength[1];

                SendData[4] = Convert.ToByte(6);
                SendData[8] = Convert.ToByte(NewRoom.RoomIndex);

                SendData[10] = Convert.ToByte(255);
                SendData[11] = Convert.ToByte(3);

                SendData[12] = Convert.ToByte(2);
                SendData[13] = Convert.ToByte(NewRoom.Roof);

                // 최대 인원
                SendData[14] = Convert.ToByte(NewRoom.MaxUser);
                // 현재 인원
                SendData[15] = Convert.ToByte(NewRoom.UserList.Count);
                for (int i = 0; i < Data.Length; i++)
                    SendData[16 + i] = Data[i];

                foreach (NTClient Client in UserList)
                    Client.ClientSocket.Send(SendData);
            }
        }

        public byte[] EnterRoom(UserModel UserInfo, int inRoomIndex)
        {
            byte[] SendData = null;
            byte[] DataLength = null;
            int SendDataLength = 0;

            SendDataLength = 12;
            DataLength = ConvertLengthtoByte(SendDataLength);

            SendData = new byte[SendDataLength];
            SendData[0] = Convert.ToByte(11);

            SendData[2] = DataLength[0];
            SendData[3] = DataLength[1];

            SendData[4] = Convert.ToByte(7);
            SendData[8] = Convert.ToByte(inRoomIndex);

            return SendData;
        }

        public byte[] Avatar_Data(AvatarModel inAvatar)
        {
            int DataIndex = 0;

            byte[] Avatar = new byte[128];
            byte[] TempData = null;

            // 캐릭터 종류       - [0] / 1
            Avatar[DataIndex++] = Convert.ToByte(inAvatar.CID);

            // 아바타 이름       - [1] / 22
            TempData = Encoding.Default.GetBytes(inAvatar.CharacterName);

            for (int i = 0; i < TempData.Length; i++)
                Avatar[DataIndex++] = TempData[i];

            // 미분석            - [23] / 5
            DataIndex = 28;

            // 캐릭터            - [28] / 32
            // 머리(2)
            TempData = BitConverter.GetBytes(inAvatar.Hair);
            Avatar[DataIndex++] = TempData[0];
            Avatar[DataIndex++] = TempData[1];
            // 머리 악세사리(2)
            if (inAvatar.HairAcc > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.HairAcc);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }
            // 상의1 (2)
            TempData = BitConverter.GetBytes(inAvatar.Clothes);
            Avatar[DataIndex++] = TempData[0];
            Avatar[DataIndex++] = TempData[1];
            // 상의2 (2)
            if (inAvatar.Clothes2 > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.Clothes2);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }
            // 상의3 (2)
            if (inAvatar.Clothes3 > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.Clothes3);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }
            // 바지1 (2)
            TempData = BitConverter.GetBytes(inAvatar.Pants);
            Avatar[DataIndex++] = TempData[0];
            Avatar[DataIndex++] = TempData[1];
            // 바지2 (2)
            if (inAvatar.Pants2 > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.Pants2);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }
            // 바지3 (2)
            if (inAvatar.Pants3 > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.Pants3);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }
            // 신발 (2)
            if (inAvatar.Shoes > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.Shoes);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }
            // 무기1 (2)
            if (inAvatar.Weapone > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.Weapone);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }
            // 무기2 (2)
            if (inAvatar.Weapone2 > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.Weapone2);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }
            // 무기3 (2)
            if (inAvatar.Weapone3 > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.Weapone3);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }
            // 악세사리1 (2)
            if (inAvatar.Acc1 > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.Acc1);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }
            // 악세사리2 (2)
            if (inAvatar.Acc2 > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.Acc2);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }
            // 악세사리3 (2)
            if (inAvatar.Acc3 > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.Acc3);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }
            // 악세사리4 (2)
            if (inAvatar.Acc4 > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.Acc4);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }
            // 악세사리5 (2)
            if (inAvatar.Acc5 > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.Acc5);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }
            // 악세사리6 (2)
            if (inAvatar.Acc6 > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.Acc6);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }
            // 악세사리7 (2)
            if (inAvatar.Acc7 > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.Acc7);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }
            // 악세사리8 (2)
            if (inAvatar.Acc8 > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.Acc8);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }

            // 미분석            - [60] / 24
            DataIndex = 84;

            // 기사단            - [84] / 24
            TempData = Encoding.Default.GetBytes(inAvatar.Knights);

            for (int i = 0; i < TempData.Length; i++)
                Avatar[DataIndex++] = TempData[i];

            DataIndex = 108;

            // 보유 GP           - [108] / 4
            TempData = BitConverter.GetBytes(inAvatar.GP);
            Avatar[DataIndex++] = TempData[0];
            Avatar[DataIndex++] = TempData[1];
            Avatar[DataIndex++] = TempData[2];
            Avatar[DataIndex++] = TempData[3];

            // 보유 FP           - [112] / 4
            TempData = BitConverter.GetBytes(inAvatar.FP);
            Avatar[DataIndex++] = TempData[0];
            Avatar[DataIndex++] = TempData[1];
            Avatar[DataIndex++] = TempData[2];
            Avatar[DataIndex++] = TempData[3];

            // 미분석            - [116] / 12
            DataIndex = 128;

            return Avatar;
        }

        public byte[] Avatar_Full(AvatarModel inAvatar)
        {
            int DataIndex = 0;

            byte[] Avatar = new byte[272];
            byte[] TempData = null;

            // 캐릭터 종류       - [0] / 1
            Avatar[DataIndex++] = Convert.ToByte(inAvatar.CID);

            // 아바타 이름       - [1] / 22
            TempData = Encoding.Default.GetBytes(inAvatar.CharacterName);

            for (int i = 0; i < TempData.Length; i++)
                Avatar[DataIndex++] = TempData[i];

            // 미분석            - [23] / 5
            DataIndex = 28;

            // 캐릭터            - [28] / 32
            // 머리(2)
            TempData = BitConverter.GetBytes(inAvatar.Hair);
            Avatar[DataIndex++] = TempData[0];
            Avatar[DataIndex++] = TempData[1];
            // 머리 악세사리(2)
            if (inAvatar.HairAcc > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.HairAcc);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }
            // 상의1 (2)
            TempData = BitConverter.GetBytes(inAvatar.Clothes);
            Avatar[DataIndex++] = TempData[0];
            Avatar[DataIndex++] = TempData[1];
            // 상의2 (2)
            if (inAvatar.Clothes2 > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.Clothes2);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }
            // 상의3 (2)
            if (inAvatar.Clothes3 > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.Clothes3);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }
            // 바지1 (2)
            TempData = BitConverter.GetBytes(inAvatar.Pants);
            Avatar[DataIndex++] = TempData[0];
            Avatar[DataIndex++] = TempData[1];
            // 바지2 (2)
            if (inAvatar.Pants2 > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.Pants2);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }
            // 바지3 (2)
            if (inAvatar.Pants3 > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.Pants3);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }
            // 신발 (2)
            if (inAvatar.Shoes > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.Shoes);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }
            // 무기1 (2)
            if (inAvatar.Weapone > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.Weapone);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }
            // 무기2 (2)
            if (inAvatar.Weapone2 > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.Weapone2);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }
            // 무기3 (2)
            if (inAvatar.Weapone3 > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.Weapone3);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }
            // 악세사리1 (2)
            if (inAvatar.Acc1 > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.Acc1);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }
            // 악세사리2 (2)
            if (inAvatar.Acc2 > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.Acc2);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }
            // 악세사리3 (2)
            if (inAvatar.Acc3 > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.Acc3);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }
            // 악세사리4 (2)
            if (inAvatar.Acc4 > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.Acc4);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }
            // 악세사리5 (2)
            if (inAvatar.Acc5 > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.Acc5);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }
            // 악세사리6 (2)
            if (inAvatar.Acc6 > 0)
            {
                TempData = BitConverter.GetBytes(inAvatar.Acc6);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }

            // 미분석            - [60] / 24
            DataIndex = 84;

            // 기사단            - [84] / 24
            TempData = Encoding.Default.GetBytes(inAvatar.Knights);

            for (int i = 0; i < TempData.Length; i++)
                Avatar[DataIndex++] = TempData[i];

            DataIndex = 108;

            // 보유 GP           - [108] / 4
            TempData = BitConverter.GetBytes(inAvatar.GP);
            Avatar[DataIndex++] = TempData[0];
            Avatar[DataIndex++] = TempData[1];
            Avatar[DataIndex++] = TempData[2];
            Avatar[DataIndex++] = TempData[3];

            // 보유 FP           - [112] / 4
            TempData = BitConverter.GetBytes(inAvatar.FP);
            Avatar[DataIndex++] = TempData[0];
            Avatar[DataIndex++] = TempData[1];
            Avatar[DataIndex++] = TempData[2];
            Avatar[DataIndex++] = TempData[3];

            // 미분석            - [116] / 12
            DataIndex = 172;

            foreach (InvenModel objInven in inAvatar.Inven)
            {
                TempData = BitConverter.GetBytes(objInven.ItemIndex);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
                TempData = BitConverter.GetBytes(objInven.Type);
                Avatar[DataIndex++] = TempData[0];
                Avatar[DataIndex++] = TempData[1];
            }

            return Avatar;
        }

        public byte[] ConvertLengthtoByte(int inLength)
        {
            return BitConverter.GetBytes(inLength - 4);
        }

        public byte[] TargetPath(byte[] inRecvData)
        {
            int TargetPathLength = inRecvData.Length - 12;
            byte[] TargetPathData = new byte[TargetPathLength];
            for (int i = 0; i < TargetPathLength; i++)
                TargetPathData[i] = inRecvData[12 + i];

            return TargetPathData;
        }

        public bool[] CheckedInven(byte[] inRecvData, int inCheckPos, int inCheckLength)
        {
            bool[] CheckInven = new bool[32];
            for (int i = 0; i < inCheckLength; i++)
            {
                byte CheckValue = Convert.ToByte(inRecvData[inCheckPos + i]);
                BitArray CheckBit = new BitArray(new int[] { CheckValue });
                for (int j = 0; j < 8; j++)
                    CheckInven[i * 8 + j] = CheckBit[j];
            }
            return CheckInven;
        }

        public bool CheckChatMessage(string inCurrentArea)
        {
            switch (inCurrentArea)
            {
                case "캘티카의 거리":
                case "네냐플 마법학원":
                case "댄디캣 클래식":
                case "댄디캣":
                case "매직카덴":
                case "캐즈팝":
                case "실키필":
                case "프레쉬센트":
                case "북 하이아칸":
                case "남 하이아칸":
                case "레코르다블":
                case "주사위의 잔영":
                    return true;

                default:
                    return false;
            }
        }

        public string GetMessage(byte[] inRecvData)
        {
            byte[] Data = new byte[4];
            Data[0] = inRecvData[2];
            Data[1] = inRecvData[3];
            int RecvDataLength = BitConverter.ToInt32(Data, 0) - 5;
            Data = new byte[RecvDataLength];
            for (int i = 0; i < RecvDataLength; i++)
                Data[i] = inRecvData[8 + i];

            return Encoding.Default.GetString(Data);
        }

        public ChatRoomModel GetRoomInfo(byte[] inRecvData, int inRoomIndex, NTClient Owner)
        {
            Owner.ChatRoomIndex = inRoomIndex;

            int Interior = Convert.ToInt32(inRecvData[10]);
            if (Interior > 100)
                Interior -= 128;
            int Roof = Convert.ToInt32(inRecvData[8]);
            if (Roof > 100)
                Roof -= 128;
            int MaxCount = Convert.ToInt32(inRecvData[9]);

            int DateLength = Convert.ToInt32(inRecvData[11]);
            byte[] Data = new byte[DateLength];
            for (int i = 0; i < DateLength; i++)
                Data[i] = inRecvData[12 + i];
            string Title = Encoding.Default.GetString(Data).Split('\0')[0];
            string Password = string.Empty;
            if (inRecvData.Length > DateLength + 12)
            {
                Data = new byte[16];
                for (int i = 0; i < 16; i++)
                    Data[i] = inRecvData[DateLength + i];
                Password = Encoding.Default.GetString(Data);
            }

            return new ChatRoomModel(inRoomIndex, Title, Password, Roof, Interior, MaxCount, Owner);
        }

        //public byte[] _Temp(byte[] inRecvData)
        //{
        //    byte[] SendData = null;
        //    byte[] DataLength = null;
        //    int SendDataLength = 0;

        //    return SendData;
        //}
    }
}
