using NSLib;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using System.Threading;

namespace LeafServer
{
    public class ServConn : DisposeClass
    {
        ~ServConn()
        { Dispose(); }

        private Socket _clientSocket = null;
        private Thread _connThread = null;

        public ServConn()
        {
            if (LeafConnection.ConnUserList == null)
                LeafConnection.ConnUserList = new List<NTClient>();
            if (ServChat.ChatRoomList == null)
                ServChat.ChatRoomList = new List<ChatRoomModel>();
        }

        public void ConnServerStart()
        {
            _connThread = new Thread(new ThreadStart(AcceptClient)) { IsBackground = true };
            _connThread.Start();
        }

        public void ConnServerStop()
        {
            try
            {
                if (_connThread.IsAlive == false)
                {
                    if (_clientSocket != null)
                    {
                        if (_clientSocket.Connected == true)
                            _clientSocket.Disconnect(false);

                        _clientSocket.Dispose();

                        if (_clientSocket != null)
                            _clientSocket = null;
                    }
                }

                LeafConnection.ConnUserList.Clear();
            }
            catch (ThreadAbortException)
            { return; }
            catch
            { throw; }
        }

        private void AcceptClient()
        {
            try
            {
                IPEndPoint ipep = new IPEndPoint(IPAddress.Any, CommonLib.SERVER_PORT);
                _clientSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
                _clientSocket.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.ReuseAddress, true);
                _clientSocket.Bind(ipep);
                _clientSocket.Listen(10);

                while (CommonLib.IsON)
                {
                    Socket Client = _clientSocket.Accept();
                    string targetAddress = ((IPEndPoint)Client.RemoteEndPoint).Address.ToString();

                    if (Client.Connected)
                    {
                        // TODO : 동일 IP에서 접근한 클라이언트 차단 및 기존 접속정보 제거
                        if (LeafConnection.ConnUserList.Exists(r => r.IPAddr == targetAddress))
                        { }

                        LeafConnection.ConnUserList.Add(new NTClient(Client));
                    }
                    else
                    {
                        var target = LeafConnection.ConnUserList.Find(r => r.IPAddr == targetAddress);
                        if (target != null)
                            LeafConnection.ConnUserList.Remove(target);
                    }
                }

                if (!CommonLib.IsON)
                    ConnServerStop();
            }
            catch (ThreadInterruptedException)
            { return; }
            catch
            { throw; }
        }
    }
}
