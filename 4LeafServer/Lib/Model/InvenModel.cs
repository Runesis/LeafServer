namespace LeafServer
{
    public class InvenModel : DisposeClass
    {
        ~InvenModel()
        { Dispose(); }

        public ulong UID { get; set; }
        public int ItemIndex { get; set; }
        public int Type { get; set; }
    }
}
