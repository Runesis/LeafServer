namespace LeafServer
{
    public class ShopBaseModel : DisposeClass
    {
        ~ShopBaseModel()
        { Dispose(); }

        public int Index { get; set; }
        public int Type { get; set; }
        public string Name { get; set; }
        public int BuyPrice { get; set; }
        public int SellPrice { get; set; }
        public int Quantity { get; set; }
    }

    public class ItemModel : ShopBaseModel
    {
        public int TID { get; set; }
        public string Series { get; set; }
        public int Mount { get; set; }
        public int Sex { get; set; }
        public string Store { get; set; }
    }

    public class CardModel : ShopBaseModel
    {
        public int CID { get; set; }
        public string Rank { get; set; }
        public string Skill { get; set; }
        public string Ability { get; set; }
    }
}
