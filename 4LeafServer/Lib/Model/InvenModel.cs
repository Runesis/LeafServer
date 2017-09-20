using NSLib;
using System;

namespace LeafServer
{
    public class InvenModel : DisposeClass
    {
        ~InvenModel()
        { Dispose(); }

        public UInt64 UID { get; set; }
        public UInt16 ItemIndex { get; set; }
        public byte Type { get; set; }
    }
}
