using NSLib;
using System;

namespace LeafServer
{
    public class ShopBaseModel : DisposeClass
    {
        ~ShopBaseModel()
        { Dispose(); }

        public UInt16 Index { get; set; }
        public byte Type { get; set; }
        public string Name { get; set; }
        public UInt32 BuyPrice { get; set; }
        public UInt32 SellPrice { get; set; }
        public byte Quantity { get; set; }
    }

    public class ItemModel : ShopBaseModel
    {
        public UInt16 TID { get; set; }
        public string Series { get; set; }
        public byte Mount { get; set; }
        public bool Sex { get; set; }
        public string Store { get; set; }
    }

    public class CardModel : ShopBaseModel
    {
        public UInt16 CID { get; set; }
        public string Rank { get; set; }
        public string Skill { get; set; }
        public string Ability { get; set; }
    }
}
