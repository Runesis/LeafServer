using System.Collections.Generic;
using System.Net.Sockets;

namespace _4LeafServer
{
    public static class LeafConnection
    {
        public static List<NTClient> ConnUserList;

        public static NTClient FindClient(Socket inClient)
        { return ConnUserList.Find(r => r.ClientSocket == inClient); }

        public static NTClient FindClient(string inIPAddress)
        {
            return ConnUserList.Find(r => r.IPAddr == inIPAddress);
        }
    }
}
