using System;
using System.Collections.Generic;

namespace _4LeafServer
{
    public class User : BaseClass
    {
        ~User()
        { Dispose(); }

        public string AccountID { get; set; }

        public List<Avatar> AvatarList = null;

        public int AvatarOrder { get; set; }
        public int Gender { get; set; }
        public DateTime LastLogin;
        public DateTime LoginTime;
    }
}
