using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using System.Threading;

namespace _4LeafServer
{
    public class ServConn : IDisposable
    {
        private Socket ClientSocket = null;
        public Thread ConnThread = null;

        /// <summary>
        /// 서버 포트
        /// </summary>
        private int ServerPort = -1;

        public ServConn(int inPort)
        {
            if (LeafConnection.ConnUserList == null)
                LeafConnection.ConnUserList = new List<NTClient>();
            if (ServChat.ChatRoomList == null)
                ServChat.ChatRoomList = new List<ChatRoom>();

            this.ServerPort = inPort;
        }

        ~ServConn()
        { Dispose(false); }

        public void Dispose()
        {
            try
            {
                if (this.ClientSocket != null)
                {
                    if (this.ClientSocket.Connected == true)
                        this.ClientSocket.Disconnect(false);
                    this.ClientSocket.Dispose();
                    this.ClientSocket = null;
                }
                if (this.ConnThread.IsAlive)
                    ConnThread.Abort();

                Dispose(true);

                GC.SuppressFinalize(this);
            }
            catch
            { throw; }
        }
        private bool _alreadyDisposed = false;
        protected virtual void Dispose(bool inDisposing)
        {
            if (_alreadyDisposed == true)
            {
                return;
            }

            if (inDisposing == true)
            {
                // managed resource
            }

            // unmanaged resource
            // disposed

            _alreadyDisposed = true;
        }

        public void ConnServerStart()
        {
            try
            {
                ConnThread = new Thread(new ThreadStart(AcceptClient));
                ConnThread.IsBackground = true;
                ConnThread.Start();
            }
            catch
            { throw; }
        }

        public void ConnServerStop()
        {
            try
            {
                if (ConnThread.IsAlive == false)
                {
                    if (this.ClientSocket != null)
                    {
                        if (this.ClientSocket.Connected == true)
                            this.ClientSocket.Disconnect(false);
                        this.ClientSocket.Dispose();
                        this.ClientSocket = null;
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
                IPEndPoint ipep = new IPEndPoint(IPAddress.Any, this.ServerPort);
                ClientSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
                ClientSocket.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.ReuseAddress, true);
                ClientSocket.Bind(ipep);
                ClientSocket.Listen(20);

                while (CommonLib.ServerStatus == true)
                {
                    Socket Client = ClientSocket.Accept();

                    if (Client.Connected)
                        LeafConnection.ConnUserList.Add(new NTClient(Client));
                }

                if (CommonLib.ServerStatus == false)
                {
                    ClientSocket.Disconnect(true);
                    ClientSocket.Dispose();
                    ClientSocket = null;
                }
            }
            catch (ThreadInterruptedException)
            { return; }
            catch
            { throw; }
        }
    }
}
