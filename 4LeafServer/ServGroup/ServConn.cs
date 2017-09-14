using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using System.Threading;

namespace LeafServer
{
    public class ServConn : DisposeClass
    {
        private Socket _clientSocket = null;
        public Thread ConnThread = null;

        public ServConn()
        {
            if (LeafConnection.ConnUserList == null)
                LeafConnection.ConnUserList = new List<NTClient>();
            if (ServChat.ChatRoomList == null)
                ServChat.ChatRoomList = new List<ChatRoomModel>();
        }

        ~ServConn()
        { Dispose(); }

        public void ConnServerStart()
        {
            ConnThread = new Thread(new ThreadStart(AcceptClient)) { IsBackground = true };
            ConnThread.Start();
        }

        public void ConnServerStop()
        {
            try
            {
                if (ConnThread.IsAlive == false)
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
                IPEndPoint ipep = new IPEndPoint(IPAddress.Any, CommonLib.SERVER_PORT);
                _clientSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
                _clientSocket.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.ReuseAddress, true);
                _clientSocket.Bind(ipep);
                _clientSocket.Listen(20);

                while (CommonLib.IsON == true)
                {
                    Socket Client = _clientSocket.Accept();

                    if (Client.Connected)
                        LeafConnection.ConnUserList.Add(new NTClient(Client));
                }

                if (CommonLib.IsON == false)
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
