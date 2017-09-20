using NSLib;
using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using System.Threading;

namespace LeafServer
{
    public class NTClient : DisposeClass
    {
        private Thread _mainThread = null;
        private LeafProtocol _protocol = null;
        private Dictionary<int, string> _areaPath = null;

        public int AreaIndex = -1;
        public byte ChatRoomIndex;
        public bool EnterRoom = false;
        public string IPAddr = string.Empty;
        public string CurrentArea = string.Empty;

        public UserModel UserInfo = null;

        public Socket ClientSocket = null;

        public NTClient(Socket Client)
        {
            ClientSocket = Client;
            CurrentArea = CommonLib.WorldMap_Kor;
            IPAddr = ((IPEndPoint)Client.RemoteEndPoint).Address.ToString();

            _areaPath = new Dictionary<int, string>();
            _protocol = new LeafProtocol();
            _mainThread = new Thread(new ThreadStart(Receiver)) { IsBackground = true };
            _mainThread.Start();
        }

        private void Receiver()
        {
            byte[] _recvData = null;
            try
            {
                while (ClientSocket != null && ClientSocket.Connected)
                {
                    byte[] RecvData = NetworkManager.ReceiveData(ClientSocket);
                    _recvData = RecvData;

                    if (RecvData != null && RecvData.Length > 0)
                    {
                        switch (RecvData[0])
                        {
                            #region 0 : BaseLevel
                            case 0:
                                switch (RecvData[4])
                                {
                                    case 1:
                                        byte[] SendData = _protocol.SubCode(RecvData);
                                        ClientSocket.Send(SendData);
                                        if (SendData[4] == 2)
                                        {
                                            if (CurrentArea != CommonLib.WorldMap_Kor)
                                            {
                                                // 방 목록
                                                if (SendData[6] == 10 && CommonLib.CheckChatRegion(CommonLib.AreaConvertEng(CurrentArea)))
                                                    ClientSocket.Send(_protocol.ChatRoomList());
                                                // 지역 기후 설정
                                                else if (SendData[6] == 11 && CommonLib.CheckChatRegion(CommonLib.AreaConvertEng(CurrentArea)))
                                                {
                                                    ClientSocket.Send(_protocol.AreaWeather(CommonLib.AreaWeather(CurrentArea)));
                                                    _protocol.EnterAreaUserList(RecvData, CurrentArea);
                                                }
                                                else
                                                    _protocol.EnterAreaUserList(RecvData, CurrentArea);

                                                Thread.Sleep(5);
                                            }
                                        }
                                        break;
                                    case 4: // Client DisConnect
                                        ClientSocket.Send(_protocol.ConnClose());
                                        ClientSocket.Disconnect(false);
                                        ClientSocket.Dispose();
                                        ClientSocket = null;
                                        break;
                                }
                                break;

                            #endregion

                            #region 1 : Connection Level
                            case 1:
                                switch (RecvData[8])
                                {
                                    case 0: // 공지요청
                                        ClientSocket.Send(_protocol.Notice(RecvData));
                                        break;
                                    case 1: // 로그인
                                        ClientSocket.Send(_protocol.Login(RecvData, out UserInfo));
                                        break;
                                    case 3: // 가입요청
                                        ClientSocket.Send(_protocol.SignUp(RecvData));
                                        break;
                                    case 4: // ID 검사
                                        ClientSocket.Send(_protocol.CheckID(RecvData));
                                        break;
                                    case 5: // 회원등록
                                        ClientSocket.Send(_protocol.Register(RecvData));
                                        break;
                                    case 6: // 캐릭터 생성
                                        // 캐릭터 정보
                                        ClientSocket.Send(_protocol.CreateCharacter(RecvData, UserInfo.AccountID));
                                        break;

                                    #region 7 : 월드 접속
                                    case 7:
                                        if (UserInfo.AvatarList.Count < 1 || UserInfo.AvatarList.Exists(r => r.Order == Convert.ToInt32(RecvData[12])) == false)
                                            ClientSocket.Send(_protocol.Error(RecvData, 6));
                                        else
                                        {
                                            int AvatarOrder = Convert.ToInt32(RecvData[12]);
                                            UserInfo.AvatarOrder = AvatarOrder;
                                            UserInfo.LoginTime = DateTime.Now;

                                            // 인벤토리 정보 읽어오기
                                            UserInfo.AvatarList.Find(r => r.Order == AvatarOrder).Inven = AccountManager.GetInvenList(UserInfo.AccountID, AvatarOrder);

                                            // 일일 접속 보상
                                            TimeSpan SpanLogin = UserInfo.LastLogin - DateTime.Now;
                                            if (SpanLogin.TotalDays > 1)
                                            {
                                                ClientSocket.Send(_protocol.DayGP(RecvData, UserInfo));
                                                Thread.Sleep(5);
                                            }

                                            // 월드 접속
                                            ClientSocket.Send(_protocol.EnterWorld(RecvData, UserInfo));
                                        }

                                        break;

                                    #endregion

                                    #region 9 : 접속 종료
                                    case 9: // 접속 종료
                                        TimeSpan tSpan = DateTime.Now - UserInfo.LoginTime;
                                        int ConnRewardGP = Convert.ToInt32(tSpan.Minutes / 5);
                                        // 접속시간 GP 보상
                                        if (ConnRewardGP > 0)
                                        { }

                                        // 접속 종료
                                        ClientSocket.Send(_protocol.Disconnection(RecvData, Convert.ToInt32(tSpan.TotalSeconds), ConnRewardGP));

                                        ClientSocket.Send(_protocol.ConnClose());
                                        ClientSocket.Disconnect(false);
                                        ClientSocket.Dispose();
                                        ClientSocket = null;

                                        break;

                                        #endregion
                                }
                                break;

                            #endregion

                            #region 2 : 지역 이동
                            case 2:
                                if (_areaPath.Count > 1)
                                {
                                    CurrentArea = _areaPath[_areaPath.Count - 1];
                                    _protocol.LeaveAreaUserList(UserInfo.AvatarList[UserInfo.AvatarOrder].CharacterName, CurrentArea);
                                }

                                ClientSocket.Send(_protocol.MoveArea(RecvData, ref _areaPath));
                                CurrentArea = _areaPath[_areaPath.Count - 1];
                                AreaIndex = CommonLib.GetAreaIndex(CurrentArea);
                                break;

                            #endregion

                            case 3:
                                switch (RecvData[8])
                                {
                                    #region 6 : 1:1 채팅 // 미구현
                                    case 6:
                                        break;

                                    #endregion

                                    #region 7 : 인벤토리 설정
                                    case 7:
                                        ClientSocket.Send(_protocol.SetCostume(RecvData, UserInfo));
                                        break;

                                        #endregion
                                }
                                break;

                            case 10:
                                switch (RecvData[4])
                                {
                                    #region 0 : 채팅 메세지
                                    case 0:
                                        _protocol.SendChatMessage(RecvData, CurrentArea);
                                        break;

                                    #endregion

                                    #region 1 : 상점목록
                                    case 1:
                                        int MountType = -1;
                                        if (RecvData.Length > 9)
                                            MountType = RecvData[9];

                                        ClientSocket.Send(_protocol.ShopList(CurrentArea, RecvData[8], MountType, UserInfo.Gender));

                                        break;

                                    #endregion

                                    #region 2 : 아이템 선택
                                    case 2:
                                        if (CurrentArea == "매직 카덴")
                                            ClientSocket.Send(_protocol.ShopACItemInfo(RecvData, true));
                                        else if (CurrentArea == "캐즈팝")
                                            ClientSocket.Send(_protocol.ShopACItemInfo(RecvData));
                                        else
                                            ClientSocket.Send(_protocol.ShopItemInfo(RecvData));
                                        break;

                                    #endregion

                                    #region 3, 4 : 아이템 구매, 판매
                                    case 3:
                                        if (CurrentArea == "매직 카덴")
                                            ClientSocket.Send(_protocol.BuyACItem(RecvData, UserInfo, true));
                                        else if (CurrentArea == "캐즈팝")
                                            ClientSocket.Send(_protocol.BuyACItem(RecvData, UserInfo));
                                        break;

                                    case 4:
                                        if (CurrentArea == "매직 카덴")
                                            ClientSocket.Send(_protocol.SellACItem(RecvData, UserInfo, true));
                                        else if (CurrentArea == "캐즈팝")
                                            ClientSocket.Send(_protocol.SellACItem(RecvData, UserInfo));
                                        else
                                            ClientSocket.Send(_protocol.BuyItem(RecvData, UserInfo));
                                        break;

                                    #endregion

                                    #region 5 : 아이템 판매
                                    case 5:
                                        if (CurrentArea == "매직 카덴")
                                            ClientSocket.Send(_protocol.ShopItemInfo(RecvData, true));
                                        else
                                            ClientSocket.Send(_protocol.SellItem(RecvData, UserInfo));
                                        break;

                                    #endregion

                                    case 201:   // 주잔 방 생성
                                        break;
                                }

                                break;

                            case 11:
                                switch (RecvData[4])
                                {
                                    #region 0 : 채팅방 입장 요청
                                    case 0:
                                        _protocol.LeaveAreaUserList(UserInfo.AvatarList.Find(r => r.Order == UserInfo.AvatarOrder).CharacterName, CurrentArea);
                                        ChatRoomIndex = RecvData[8];
                                        EnterRoom = true;
                                        ClientSocket.Send(_protocol.EnterRoom(UserInfo, ChatRoomIndex));
                                        break;

                                    #endregion

                                    #region 1 : 채팅방 생성 요청
                                    case 1:
                                        _protocol.CreateChatRoom(RecvData, UserInfo, CurrentArea, AreaIndex);
                                        break;

                                    #endregion

                                    #region 2 : 방 생성 취소
                                    case 2:
                                        _protocol.CancelRoomCreate(RecvData, CurrentArea, ChatRoomIndex);
                                        ChatRoomIndex = 0;
                                        break;

                                    #endregion

                                    #region 3 : 채팅방 생성
                                    case 3:
                                        _protocol.BuildChatRoom(RecvData, CurrentArea, ChatRoomIndex, this);
                                        Thread.Sleep(5);
                                        // 채팅방 입장
                                        EnterRoom = true;
                                        ClientSocket.Send(_protocol.EnterRoom(UserInfo, ChatRoomIndex));

                                        break;

                                    #endregion

                                    #region 4 : 채팅 메세지
                                    case 4:
                                        _protocol.SendChatMessage(RecvData, CurrentArea);
                                        break;

                                        #endregion
                                }
                                break;
                            default:
                                break;
                        }
                    }
                }

                if (ClientSocket == null)
                    Dispose();
            }
            catch
            { throw; }
        }

        ~NTClient()
        { Dispose(); }
    }
}