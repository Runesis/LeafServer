using System;
using System.Net;
using System.Net.Sockets;

namespace NSLib
{
    public class NetworkManager : DisposeClass
    {
        public static string GetLocalIPAddress
        {
            get
            {
                try
                {
                    var host = Dns.GetHostEntry(Dns.GetHostName());
                    foreach (var ip in host.AddressList)
                    {
                        if (ip.AddressFamily == AddressFamily.InterNetwork)
                        {
                            return ip.ToString();
                        }
                    }

                    return string.Empty;
                }
                catch
                {
                    throw new Exception("Local IP Address Not Found!");
                }
            }
        }

        public static byte[] ReceiveData(Socket inClient)
        {
            try
            {
                byte[] Buffer = new byte[1024];
                byte[] RecvData = null;
                int RecvDataLength = inClient.Receive(Buffer, 0, 1024, SocketFlags.None);
                RecvData = new byte[RecvDataLength];
                for (int i = 0; i < RecvDataLength; i++)
                { RecvData[i] = Buffer[i]; }

                return RecvData;
            }
            catch (SocketException)
            { return null; }
            catch
            { throw; }
        }
    }
}
