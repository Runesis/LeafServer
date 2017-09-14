using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Reflection;

namespace LeafServer
{
    public class DataContainer : DisposeClass
    {
        ~DataContainer()
        { Dispose(); }

        private static Dictionary<int, ItemModel> _itemInfoList = new Dictionary<int, ItemModel>();
        private static Dictionary<int, CardModel> _cardInfoList = new Dictionary<int, CardModel>();

        public static bool LoadContainer()
        {
            using (var conn = new SqlConnection(CommonLib.DBConnConfig))
            {
                conn.Open();

                var dbResult = conn.QueryMultiple("sp_GetLeafData", null, commandType: CommandType.StoredProcedure);

                // TODO : 데이터 바인딩 구현하기
                //ToDictionary(ref _itemInfoList, GetItemInfo(dtDataSet.Tables[0]), "Index");
                //ToDictionary(ref _cardInfoList, GetCardInfo(dtDataSet.Tables[1]), "Index");
            }

            if (_itemInfoList.Count > 0 && _cardInfoList.Count > 0)
                return true;

            return false;
        }

        /// <summary>
        /// 미사용
        /// </summary>
        /// <param name="inTable"></param>
        /// <returns></returns>
        private static List<ItemModel> _GetItemInfo(DataTable inTable)
        {
            List<ItemModel> InfoList = new List<ItemModel>();
            foreach (DataRow objRow in inTable.Rows)
            {
                ItemModel objItem = new ItemModel();
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
                objItem.Quantity = 9999;
                InfoList.Add(objItem);
            }
            return InfoList;
        }
        /// <summary>
        /// 미사용
        /// </summary>
        /// <param name="inTable"></param>
        /// <returns></returns>
        private static List<CardModel> _GetCardInfo(DataTable inTable)
        {
            List<CardModel> InfoList = new List<CardModel>();
            foreach (DataRow objRow in inTable.Rows)
            {
                CardModel objCard = new CardModel();
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

        /// <summary>
        /// 미사용
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="destination"></param>
        /// <param name="sources"></param>
        /// <param name="keyPropertyName"></param>
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

        public static List<ItemModel> GetItemList()
        {
            if (_itemInfoList == null || _itemInfoList.Count < 1)
                LoadContainer();

            return new List<ItemModel>(_itemInfoList.Values);
        }
        public static List<CardModel> GetCardList()
        {
            if (_cardInfoList == null || _cardInfoList.Count < 1)
                LoadContainer();

            return new List<CardModel>(_cardInfoList.Values);
        }

        public static ItemModel FindItem(int inIndex)
        {
            if (_itemInfoList == null || _itemInfoList.Count < 1)
                LoadContainer();

            return GetItemList().Find(r => r.Index == inIndex);
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
                LoadContainer();

            return new List<ItemModel>(_itemInfoList.Values).FindAll(r => r.Store == inShop);
        }
    }
}
