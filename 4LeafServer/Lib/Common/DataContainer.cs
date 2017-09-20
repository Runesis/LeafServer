using Dapper;
using MySql.Data.MySqlClient;
using NSLib;
using System.Collections.Generic;
using System.Data;

namespace LeafServer
{
    public class DataContainer : DisposeClass
    {
        ~DataContainer()
        { Dispose(); }

        private static List<ItemModel> _itemInfoList = new List<ItemModel>();
        private static List<CardModel> _cardInfoList = new List<CardModel>();

        public static bool LoadContainer()
        {
            if (_itemInfoList.Count > 0 && _cardInfoList.Count > 0)
                return true;

            try
            {
                using (var conn = new MySqlConnection(CommonLib.DBConnConfig))
                {
                    conn.Open();
                    var dbResult = conn.QueryMultiple("sp_GetLeafData", commandType: CommandType.StoredProcedure);

                    if (dbResult != null)
                    {
                        _itemInfoList = dbResult.Read<ItemModel>().AsList();
                        _cardInfoList = dbResult.Read<CardModel>().AsList();

                        if (_itemInfoList.Count > 0 && _cardInfoList.Count > 0)
                            return true;
                    }
                }
            }
            catch { return false; }

            return false;
        }

        public static List<ItemModel> GetItemList
        {
            get
            {
                if (_itemInfoList == null || _itemInfoList.Count < 1)
                {
                    LoadContainer();

                    if (_itemInfoList == null || _itemInfoList.Count < 1)
                        return null;
                }

                return _itemInfoList;
            }
        }
        public static List<CardModel> GetCardList
        {
            get
            {
                if (_cardInfoList == null || _cardInfoList.Count < 1)
                {
                    LoadContainer();

                    if (_cardInfoList == null || _cardInfoList.Count < 1)
                        return null;
                }

                return _cardInfoList;
            }
        }

        public static ItemModel FindItem(int inIndex)
        {
            if (_itemInfoList == null || _itemInfoList.Count < 1)
                LoadContainer();

            return GetItemList.Find(r => r.Index == inIndex);
        }
        public static CardModel FindCard(int inIndex)
        {
            if (_itemInfoList == null || _itemInfoList.Count < 1)
                LoadContainer();

            return _cardInfoList[inIndex];
        }

        public static List<ItemModel> GetShopGoods(string inShop)
        {
            if (_itemInfoList == null || _itemInfoList.Count < 1)
            {
                LoadContainer();

                if (_itemInfoList == null || _itemInfoList.Count < 1)
                    return null;
            }

            return _itemInfoList.FindAll(r => r.Store == inShop);
        }

        public static bool IsDataLoad
        {
            get
            {
                if (_itemInfoList.Count > 0 && _cardInfoList.Count > 0)
                    return true;
                else
                    return false;
            }
        }
    }
}
