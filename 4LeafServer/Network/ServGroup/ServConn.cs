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
                IPEndPoint ipep = new IPEndPoint(IPAddress.Parse("127.0.0.1"), CommonLib.SERVER_PORT);
                _clientSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
                _clientSocket.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.ReuseAddress, true);
                _clientSocket.Bind(ipep);
                _clientSocket.Listen(10);

                while (CommonLib.IsON)
                {
                    Socket Client = _clientSocket.Accept();

                    if (Client.Connected)
                        LeafConnection.ConnUserList.Add(new NTClient(Client));
                }

                if (!CommonLib.IsON)
                {
                    _clientSocket.Disconnect(true);
                    _clientSocket.Dispose();
                    if (_clientSocket != null)
                        _clientSocket = null;
                }
            }
            catch (ThreadInterruptedException)
            { return; }
            catch
            { throw; }
        }
    }
}
