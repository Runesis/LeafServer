using System;
using System.Collections.Generic;

namespace LeafServer
{
    public class UserModel : DisposeClass
    {
        ~UserModel()
        { Dispose(); }

        public string AccountID { get; set; }

        public List<AvatarModel> AvatarList = null;

        public int AvatarOrder { get; set; }
        public bool Gender { get; set; }
        public DateTime LastLogin;
        public DateTime LoginTime;
    }
}
