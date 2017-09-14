using System;
using System.Collections.Generic;
using System.Reflection;
using SmLibrary.DBTool;
using System.Data;

namespace _4LeafServer
{
    public static class DataContainer
    {
        private static Dictionary<int, ItemInfo> _itemInfoList = new Dictionary<int, ItemInfo>();
        private static Dictionary<int, CardInfo> _cardInfoList = new Dictionary<int, CardInfo>();

        static DataContainer()
        { LoadContainer(); }

        public static bool LoadContainer()
        {
            try
            {
                using (DBTool_MySQL dbTool = new DBTool_MySQL("server=192.168.56.101;uid=root;pwd=runedb;database=4Leaf"))
                {
                    dbTool.Connect();
                    DataSet dtDataSet = dbTool.ExcuteDataSet("GetLeafData");
                    ToDictionary(ref _itemInfoList, GetItemInfo(dtDataSet.Tables[0]), "Index");
                    ToDictionary(ref _cardInfoList, GetCardInfo(dtDataSet.Tables[1]), "Index");
                }
                if (_itemInfoList.Count > 0 && _cardInfoList.Count > 0)
                    return true;
                else
                    return false;
            }
            catch
            { throw; }
        }

        private static List<ItemInfo> GetItemInfo(DataTable inTable)
        {
            List<ItemInfo> InfoList = new List<ItemInfo>();
            foreach (DataRow objRow in inTable.Rows)
            {
                ItemInfo objItem = new ItemInfo();
                objItem.TID = Convert.ToInt32(objRow["f_TID"]);
                objItem.Index = Convert.ToInt32(objRow["f_Index"]);
                objItem.Type = Convert.ToInt32(objRow["f_Type"]);
                objItem.Series = Convert.ToString(objRow["f_Series"]);
                objItem.Name = Convert.ToString(objRow["f_Name"]);
                objItem.Mount = Convert.ToInt32(objRow["f_Mount"]);
                objItem.Sex = Convert.ToInt32(objRow["f_Sex"]);
                objItem.BuyPrice = Convert.ToInt32(objRow["f_BuyPrice"]);
                objItem.SellPrice = Convert.ToInt32(objRow["f_SellPrice"]);
                objItem.Store = Convert.ToString(objRow["f_Store"]);
                InfoList.Add(objItem);
            }
            return InfoList;
        }
        private static List<CardInfo> GetCardInfo(DataTable inTable)
        {
            List<CardInfo> InfoList = new List<CardInfo>();
            foreach (DataRow objRow in inTable.Rows)
            {
                CardInfo objCard = new CardInfo();
                objCard.CID = Convert.ToInt32(objRow["f_CID"]);
                objCard.Index = Convert.ToInt32(objRow["f_Index"]);
                objCard.Type = Convert.ToInt32(objRow["f_Type"]);
                objCard.Rank = Convert.ToString(objRow["f_Rank"]);
                objCard.Name = Convert.ToString(objRow["f_Name"]);
                objCard.Skill = Convert.ToString(objRow["f_Skill"]);
                objCard.Ability = Convert.ToString(objRow["f_Ability"]);
                objCard.BuyPrice = Convert.ToInt32(objRow["f_BuyPrice"]);
                objCard.SellPrice = Convert.ToInt32(objRow["f_SellPrice"]);
                objCard.Quantity = Convert.ToInt32(objRow["f_Quantity"]);
                InfoList.Add(objCard);
            }
            return InfoList;
        }

        private static void ToDictionary<T>(ref Dictionary<Int32, T> destination, IList<T> sources, string keyPropertyName)
        {
            if (destination == null)
            {
                destination = new Dictionary<Int32, T>();
            }
            else
            {
                destination.Clear();
            }

            if (sources == null)
            {
                return;
            }

            PropertyInfo pi = typeof(T).GetProperty(keyPropertyName);
            foreach (var source in sources)
            {
                int key = (int)pi.GetValue(source, null);
                destination.Add(key, source);
            }
        }

        public static List<ItemInfo> GetItemList()
        {
            if (_itemInfoList.Count < 1)
                LoadContainer();

            return new List<ItemInfo>(_itemInfoList.Values);
        }
        public static List<CardInfo> GetCardList()
        {
            if (_cardInfoList.Count < 1)
                LoadContainer();

            return new List<CardInfo>(_cardInfoList.Values);
        }

        public static ItemInfo FindItem(int inIndex)
        {
            if (_itemInfoList.Count < 1)
                LoadContainer();

            return _itemInfoList[inIndex];
        }
        public static CardInfo FindCard(int inIndex)
        {
            if (_itemInfoList.Count < 1)
                LoadContainer();

            return _cardInfoList[inIndex];
        }

        public static List<ItemInfo> GetShopGoods(string inShop)
        {
            if (_itemInfoList.Count < 1)
                LoadContainer();

            return new List<ItemInfo>(_itemInfoList.Values).FindAll(r => r.Store == inShop);
        }
    }
}
