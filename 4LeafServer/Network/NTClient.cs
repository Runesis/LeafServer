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

        public Socket ClientSocket = null;
        public UserModel UserInfo = null;

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
                    _recvData = NetworkManager.ReceiveData(ClientSocket);

                    if (_recvData != null && _recvData.Length > 0)
                    {
                        switch (_recvData[0])
                        {
                            #region 0 : BaseLevel
                            case 0:
                                switch (_recvData[4])
                                {
                                    case 1:
                                        byte[] SendData = _protocol.SubCode(_recvData);
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
                                                    _protocol.EnterAreaUserList(_recvData, CurrentArea);
                                                }
                                                else
                                                    _protocol.EnterAreaUserList(_recvData, CurrentArea);

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
                                switch (_recvData[8])
                                {
                                    case 0: // 공지요청
                                        ClientSocket.Send(_protocol.Notice(_recvData));
                                        break;
                                    case 1: // 로그인
                                        ClientSocket.Send(_protocol.Login(_recvData, out UserInfo));
                                        break;
                                    case 3: // 가입요청
                                        ClientSocket.Send(_protocol.SignUp(_recvData));
                                        break;
                                    case 4: // ID 검사
                                        ClientSocket.Send(_protocol.CheckID(_recvData));
                                        break;
                                    case 5: // 회원등록
                                        ClientSocket.Send(_protocol.Register(_recvData));
                                        break;
                                    case 6: // 캐릭터 생성
                                        // 캐릭터 정보
                                        ClientSocket.Send(_protocol.CreateCharacter(_recvData, UserInfo.AccountID));
                                        break;

                                    #region 7 : 월드 접속
                                    case 7:
                                        if (UserInfo.AvatarList.Count < 1 || UserInfo.AvatarList.Exists(r => r.Order == Convert.ToInt32(_recvData[12])) == false)
                                            ClientSocket.Send(_protocol.Error(_recvData, 6));
                                        else
                                        {
                                            int AvatarOrder = Convert.ToInt32(_recvData[12]);
                                            UserInfo.AvatarOrder = AvatarOrder;
                                            UserInfo.LoginTime = DateTime.Now;

                                            // 인벤토리 정보 읽어오기
                                            UserInfo.AvatarList.Find(r => r.Order == AvatarOrder).Inven = AccountManager.GetInvenList(UserInfo.AccountID, AvatarOrder);

                                            // 일일 접속 보상
                                            TimeSpan SpanLogin = UserInfo.LastLogin - DateTime.Now;
                                            if (SpanLogin.TotalDays > 1)
                                            {
                                                ClientSocket.Send(_protocol.DayGP(_recvData, UserInfo));
                                                Thread.Sleep(5);
                                            }

                                            // 월드 접속
                                            ClientSocket.Send(_protocol.EnterWorld(_recvData, UserInfo));
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
                                        ClientSocket.Send(_protocol.Disconnection(_recvData, Convert.ToInt32(tSpan.TotalSeconds), ConnRewardGP));

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

                                ClientSocket.Send(_protocol.MoveArea(_recvData, ref _areaPath));
                                CurrentArea = _areaPath[_areaPath.Count - 1];
                                AreaIndex = CommonLib.GetAreaIndex(CurrentArea);
                                break;

                            #endregion

                            case 3:
                                switch (_recvData[8])
                                {
                                    // TODO : 1:1 채팅 구현 필요
                                    #region 6 : 1:1 채팅
                                    case 6:
                                        break;

                                    #endregion

                                    #region 7 : 인벤토리 설정
                                    case 7:
                                        ClientSocket.Send(_protocol.SetCostume(_recvData, UserInfo));
                                        break;

                                        #endregion
                                }
                                break;

                            case 10:
                                switch (_recvData[4])
                                {
                                    #region 0 : 채팅 메세지
                                    case 0:
                                        _protocol.SendChatMessage(_recvData, CurrentArea);
                                        break;

                                    #endregion

                                    #region 1 : 상점목록
                                    case 1:
                                        int MountType = -1;
                                        if (_recvData.Length > 9)
                                            MountType = _recvData[9];

                                        ClientSocket.Send(_protocol.ShopList(CurrentArea, _recvData[8], MountType, UserInfo.Gender));

                                        break;

                                    #endregion

                                    #region 2 : 아이템 선택
                                    case 2:
                                        if (CurrentArea == "매직 카덴")
                                            ClientSocket.Send(_protocol.ShopACItemInfo(_recvData, true));
                                        else if (CurrentArea == "캐즈팝")
                                            ClientSocket.Send(_protocol.ShopACItemInfo(_recvData));
                                        else
                                            ClientSocket.Send(_protocol.ShopItemInfo(_recvData));
                                        break;

                                    #endregion

                                    #region 3, 4 : 아이템 구매, 판매
                                    case 3:
                                        // 아이템 구매
                                        if (CurrentArea == "매직 카덴")
                                            ClientSocket.Send(_protocol.BuyACItem(_recvData, UserInfo, true));
                                        else if (CurrentArea == "캐즈팝")
                                            ClientSocket.Send(_protocol.BuyACItem(_recvData, UserInfo));
                                        break;

                                    case 4:
                                        // 아이템 판매
                                        if (CurrentArea == "매직 카덴")
                                            ClientSocket.Send(_protocol.SellACItem(_recvData, UserInfo, true));
                                        else if (CurrentArea == "캐즈팝")
                                            ClientSocket.Send(_protocol.SellACItem(_recvData, UserInfo));
                                        else
                                            ClientSocket.Send(_protocol.BuyItem(_recvData, UserInfo));
                                        break;

                                    #endregion

                                    #region 5 : 아이템 판매
                                    case 5:
                                        if (CurrentArea == "매직 카덴")
                                            ClientSocket.Send(_protocol.ShopItemInfo(_recvData, true));
                                        else
                                            ClientSocket.Send(_protocol.SellItem(_recvData, UserInfo));
                                        break;

                                    #endregion

                                    case 201:   // 주잔 방 생성
                                        break;
                                }

                                break;

                            case 11:
                                switch (_recvData[4])
                                {
                                    #region 0 : 채팅방 입장 요청
                                    case 0:
                                        _protocol.LeaveAreaUserList(UserInfo.AvatarList.Find(r => r.Order == UserInfo.AvatarOrder).CharacterName, CurrentArea);
                                        ChatRoomIndex = _recvData[8];
                                        EnterRoom = true;
                                        ClientSocket.Send(_protocol.EnterRoom(UserInfo, ChatRoomIndex));
                                        break;

                                    #endregion

                                    #region 1 : 채팅방 생성 요청
                                    case 1:
                                        _protocol.CreateChatRoom(_recvData, UserInfo, CurrentArea, AreaIndex);
                                        break;

                                    #endregion

                                    #region 2 : 방 생성 취소
                                    case 2:
                                        _protocol.CancelRoomCreate(_recvData, CurrentArea, ChatRoomIndex);
                                        ChatRoomIndex = 0;
                                        break;

                                    #endregion

                                    #region 3 : 채팅방 생성
                                    case 3:
                                        _protocol.BuildChatRoom(_recvData, CurrentArea, ChatRoomIndex, this);
                                        Thread.Sleep(5);
                                        // 채팅방 입장
                                        EnterRoom = true;
                                        ClientSocket.Send(_protocol.EnterRoom(UserInfo, ChatRoomIndex));

                                        break;

                                    #endregion

                                    #region 4 : 채팅 메세지
                                    case 4:
                                        _protocol.SendChatMessage(_recvData, CurrentArea);
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
            catch { throw; }
        }

        ~NTClient()
        { Dispose(); }
    }
}