using NSLib;
using System;

namespace LeafServer
{
    public class DBResultModels : DisposeClass
    {
        ~DBResultModels()
        { Dispose(); }
    }

    public class LoginResultModel : DisposeClass
    {
        ~LoginResultModel()
        { Dispose(); }

        public bool Gender { get; set; }

        public DateTime LastLogin { get; set; }
    }
}