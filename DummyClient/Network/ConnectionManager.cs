using NSLib;
using System;
using System.Net;
using System.Net.Sockets;
using System.Threading;

namespace DummyClient.Network
{
    public class ConnectionManager : DisposeClass
    {
        ~ConnectionManager()
        { Dispose(); }

        private Socket _server = null;
        private Thread _connThread = null;

        public bool IsConnect
        {
            get
            {
                if (_server == null)
                    return false;

                return _server.Connected;
            }
        }

        public void Connection(string inIPAddress, UInt16 inPort)
        {
            try
            {
                IPEndPoint ipep = new IPEndPoint(IPAddress.Parse(inIPAddress), inPort);
                _server = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
                _server.Connect(ipep);

                _connThread = new Thread(new ThreadStart(Receiver)) { IsBackground = true };
                _connThread.Start();
            }
            catch { throw; }
        }

        public void Disconnect()
        {
            try
            {

            }
            catch { throw; }
        }

        public void Send()
        {

        }

        public void Receiver()
        {
            byte[] _recvData = null;
            try
            {
                while (_server != null && _server.Connected)
                {
                    byte[] RecvData = NetworkManager.ReceiveData(_server);
                    _recvData = RecvData;

                    if (RecvData != null && RecvData.Length > 0)
                    {

                    }
                }

                if (_server == null || !_server.Connected)
                {
                    _server.Disconnect(true);
                    Dispose();
                }
            }
            catch
            { throw; }
        }
    }
}
