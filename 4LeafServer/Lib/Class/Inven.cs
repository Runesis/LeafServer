namespace _4LeafServer
{
    public class Inven : BaseClass
    {
        ~Inven()
        { Dispose(); }

        public ulong UID { get; set; }
        public int ItemIndex { get; set; }
        public int Type { get; set; }
    }
}
