using System.Data;
using System;
using System.Linq.Expressions;
using System.Reflection;

namespace _4LeafServer
{
    public class ItemInfo
    {
        public int TID { get; set; }
        public int Index { get; set; }
        public int Type { get; set; }
        public string Series { get; set; }
        public string Name { get; set; }
        public int Mount { get; set; }
        public int Sex { get; set; }
        public int BuyPrice { get; set; }
        public int SellPrice { get; set; }
        public string Store { get; set; }
    }

    public class CardInfo
    {
        public int CID { get; set; }
        public int Index { get; set; }
        public int Type { get; set; }
        public string Rank { get; set; }
        public string Name { get; set; }
        public string Skill { get; set; }
        public string Ability { get; set; }
        public int BuyPrice { get; set; }
        public int SellPrice { get; set; }
        public int Quantity { get; set; }
    }
}
