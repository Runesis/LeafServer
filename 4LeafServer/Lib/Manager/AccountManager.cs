using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text;

namespace LeafServer
{
    public static class AccountManager
    {
        public static bool CheckID(string inAccountID)
        {
            using (var conn = new SqlConnection(CommonLib.DBConnConfig))
            {
                conn.Open();
                var param = new DynamicParameters();

                param.Add("@inAccountID", inAccountID);
                //param.Add("@outCheck", boCheckValue, direction: ParameterDirection.Output);
                conn.Query("dbo.sp_CheckAccountID", param, commandType: CommandType.StoredProcedure);

                // TODO : SP에서 true/false 결과 반환 처리 필요
            }
            return false;
        }

        public static bool Login(string inAccountID, string inPassword, out UserModel outUserInfo)
        {
            outUserInfo = null;

            using (var conn = new SqlConnection(CommonLib.DBConnConfig))
            {
                conn.Open();
                var param = new DynamicParameters();
                param.Add("@inAccountID", inAccountID);
                param.Add("@inPassword", inPassword);
                param.Add("@EncryptKey", CommonLib.DBEncryptKey);
                param.Add("RetVal", direction: ParameterDirection.ReturnValue);

                var result = conn.Query("dbo.sp_Login", param, commandType: CommandType.StoredProcedure);

                if (CommonLib.IsSuccess(param.Get<int>("RetVal")))
                {
                    // TODO : 유저정보 바인딩 처리
                    //outUserInfo = new User();
                    //outUserInfo.Gender = Convert.ToInt32(UserInfoData.Tables[0].Rows[0]["Gender"]);
                    //outUserInfo.LastLogin = Convert.ToDateTime(UserInfoData.Tables[0].Rows[0]["LastLogin"]);

                    //if (UserInfoData.Tables.Count > 1)
                    //    outUserInfo.AvatarList = GetAvatarList(UserInfoData.Tables[1]);
                    //else
                    //    outUserInfo.AvatarList = new List<Avatar>();

                    return true;
                }
            }

            return false;
        }

        public static bool DayGP(string AccountID, int AvatarOrder, int GetGP)
        {
            using (var conn = new SqlConnection(CommonLib.DBConnConfig))
            {
                conn.Open();
                var param = new DynamicParameters();
                param.Add("@inAccountID", AccountID);
                param.Add("@inAvatarOrder", AvatarOrder);
                param.Add("@inGetGP", GetGP);
                param.Add("RetVal", direction: ParameterDirection.ReturnValue);

                conn.Query("dbo.sp_DailyGP", param, commandType: CommandType.StoredProcedure);

                return CommonLib.IsSuccess(param.Get<int>("RetVal"));
            }
        }

        public static bool CreateAccount(byte[] RecvData)
        {
            string AccountID = string.Empty;
            string Password = string.Empty;
            int Gender = -1;

            byte[] Data = new byte[16];

            for (int i = 0; i < 16; i++)
                Data[i] = RecvData[12 + i];
            AccountID = Encoding.Default.GetString(Data).Split('\0')[0];
            if (AccountID.Length < 1)
                return false;

            Data = new byte[16];
            for (int i = 0; i < 16; i++)
                Data[i] = RecvData[48 + i];
            Password = Encoding.Default.GetString(Data).Split('\0')[0];
            if (Password.Length < 1)
                return false;

            Data = new byte[8];
            for (int i = 0; i < 8; i++)
            {
                Data[i] = RecvData[40 + i];
                if (i == 7)
                    Gender = Data[i];
            }

            using (var conn = new SqlConnection(CommonLib.DBConnConfig))
            {
                conn.Open();
                var param = new DynamicParameters();
                param.Add("@AccountID", AccountID);
                param.Add("@Password", Password);
                param.Add("@Gender", Gender);
                param.Add("EncryptKey", CommonLib.DBEncryptKey);
                param.Add("RetVal", direction: ParameterDirection.ReturnValue);
                conn.Query("dbo.sp_CreateAccount", param, commandType: CommandType.StoredProcedure);

                return CommonLib.IsSuccess(param.Get<int>("RetVal"));
            }
        }

        public static int GetAvatarCount(string AccountID)
        {
            using (var conn = new SqlConnection(CommonLib.DBConnConfig))
            {
                conn.Open();
                var param = new DynamicParameters();
                param.Add("@AccountID", AccountID);
                param.Add("RetVal", direction: ParameterDirection.ReturnValue);
                conn.Query("dbo.sp_GetAvatarCount", param, commandType: CommandType.StoredProcedure);

                return param.Get<int>("RetVal");
            }
        }

        public static bool UpdateCostume(string inAccountID, AvatarModel inAvatar)
        {
            try
            {
                using (DBTool_MySQL dbTool = new DBTool_MySQL(CommonLib.DBConnConfig))
                {
                    dbTool.Connect();
                    MySqlParamArray ParamList = new MySqlParamArray();
                    ParamList.Add("inAccountID", inAccountID);
                    ParamList.Add("inOrder", inAvatar.Order);
                    ParamList.Add("inHair", inAvatar.Hair);
                    ParamList.Add("inHairAcc", inAvatar.HairAcc);
                    ParamList.Add("inClothes", inAvatar.Clothes);
                    ParamList.Add("inClothes2", inAvatar.Clothes2);
                    ParamList.Add("inClothes3", inAvatar.Clothes3);
                    ParamList.Add("inPants", inAvatar.Pants);
                    ParamList.Add("inPants2", inAvatar.Pants2);
                    ParamList.Add("inPants3", inAvatar.Pants3);
                    ParamList.Add("inShoes", inAvatar.Shoes);
                    ParamList.Add("inWeapone", inAvatar.Weapone);
                    ParamList.Add("inWeapone2", inAvatar.Weapone2);
                    ParamList.Add("inWeapone3", inAvatar.Weapone3);
                    ParamList.Add("inAcc1", inAvatar.Acc1);
                    ParamList.Add("inAcc2", inAvatar.Acc2);
                    ParamList.Add("inAcc3", inAvatar.Acc3);
                    ParamList.Add("inAcc4", inAvatar.Acc4);
                    ParamList.Add("inAcc5", inAvatar.Acc5);
                    ParamList.Add("inAcc6", inAvatar.Acc6);
                    dbTool.ExcuteNonQuery("sp_UpdateCostume", ParamList);
                }

                return true;
            }
            catch
            { return false; }
        }

        public static bool BuyItem(string inAccountID, int inOrder, int inItemIndex)
        {
            try
            {
                using (DBTool_MySQL dbTool = new DBTool_MySQL(CommonLib.DBConnConfig))
                {
                    dbTool.Connect();
                    MySqlParamArray ParamList = new MySqlParamArray();
                    ParamList.Add("inAccountID", inAccountID);
                    ParamList.Add("inOrder", inOrder);
                    ParamList.Add("inItemIndex", inItemIndex);
                    dbTool.ExcuteNonQuery("sp_BuyItem", ParamList);
                }

                return true;
            }
            catch
            { return false; }
        }

        public static bool SellItem(string inAccountID, int inOrder, int inItemIndex)
        {
            try
            {
                using (DBTool_MySQL dbTool = new DBTool_MySQL(CommonLib.DBConnConfig))
                {
                    dbTool.Connect();
                    MySqlParamArray ParamList = new MySqlParamArray();
                    ParamList.Add("inAccountID", inAccountID);
                    ParamList.Add("inOrder", inOrder);
                    ParamList.Add("inItemIndex", inItemIndex);
                    dbTool.ExcuteNonQuery("sp_SellItem", ParamList);
                }

                return true;
            }
            catch
            { return false; }
        }

        public static List<AvatarModel> GetAvatarList(DataTable AvatarTable)
        {
            List<AvatarModel> AvatarList = new List<AvatarModel>();

            foreach (DataRow DataRow in AvatarTable.Rows)
            {
                AvatarModel objAvatar = new AvatarModel();
                objAvatar.Order = Convert.ToInt32(DataRow["Order"]);
                objAvatar.CID = Convert.ToInt32(DataRow["CID"]);
                objAvatar.CharacterName = Convert.ToString(DataRow["Name"]);
                objAvatar.Knights = Convert.ToString(DataRow["Knight"]);
                objAvatar.GP = Convert.ToInt32(DataRow["GP"]);
                objAvatar.FP = Convert.ToInt32(DataRow["FP"]);
                objAvatar.Hair = Convert.ToInt32(DataRow["Hair"]);
                objAvatar.HairAcc = Convert.ToInt32(DataRow["HairAcc"]);
                objAvatar.Clothes = Convert.ToInt32(DataRow["Clothes"]);
                objAvatar.Clothes2 = Convert.ToInt32(DataRow["Clothes2"]);
                objAvatar.Clothes3 = Convert.ToInt32(DataRow["Clothes3"]);
                objAvatar.Pants = Convert.ToInt32(DataRow["Pants"]);
                objAvatar.Pants2 = Convert.ToInt32(DataRow["Pants2"]);
                objAvatar.Pants3 = Convert.ToInt32(DataRow["Pants3"]);
                objAvatar.Shoes = Convert.ToInt32(DataRow["Shoes"]);
                objAvatar.Weapone = Convert.ToInt32(DataRow["Weapone"]);
                objAvatar.Weapone2 = Convert.ToInt32(DataRow["Weapone2"]);
                objAvatar.Weapone3 = Convert.ToInt32(DataRow["Weapone3"]);
                objAvatar.Acc1 = Convert.ToInt32(DataRow["Acc1"]);
                objAvatar.Acc2 = Convert.ToInt32(DataRow["Acc2"]);
                objAvatar.Acc3 = Convert.ToInt32(DataRow["Acc3"]);
                objAvatar.Acc4 = Convert.ToInt32(DataRow["Acc4"]);
                objAvatar.Acc5 = Convert.ToInt32(DataRow["Acc5"]);
                objAvatar.Acc6 = Convert.ToInt32(DataRow["Acc6"]);
                objAvatar.Acc7 = Convert.ToInt32(DataRow["Acc7"]);
                objAvatar.Acc8 = Convert.ToInt32(DataRow["Acc8"]);
                AvatarList.Add(objAvatar);
            }

            return AvatarList;
        }

        public static List<InvenModel> GetInvenList(string inAccountID, int inAvatarOrder)
        {
            try
            {
                DataSet DataSet = null;
                using (DBTool_MySQL dbTool = new DBTool_MySQL(CommonLib.DBConnConfig))
                {
                    dbTool.Connect();
                    MySqlParamArray ParamList = new MySqlParamArray();
                    ParamList.Add("inAccountID", inAccountID);
                    ParamList.Add("inOrder", inAvatarOrder);
                    DataSet = dbTool.ExcuteDataSet("sp_GetInven", ParamList);
                }

                List<InvenModel> InvenList = new List<InvenModel>();

                foreach (DataRow DataRow in DataSet.Tables[0].Rows)
                {
                    InvenModel objInven = new InvenModel();
                    objInven.UID = Convert.ToUInt64(DataRow["UID"]);
                    objInven.ItemIndex = Convert.ToInt32(DataRow["ItemIndex"]);
                    objInven.Type = Convert.ToInt32(DataRow["Type"]);
                    InvenList.Add(objInven);
                    if (InvenList.Count == 25)
                        break;
                }
                return InvenList;
            }
            catch
            { throw; }
        }

        public static AvatarModel CreateAvatar(byte[] inRecvData, string inAccountID)
        {
            try
            {
                int Character = inRecvData[12];
                string CharName = string.Empty;

                byte[] Data = new byte[22];
                for (int i = 0; i < 22; i++)
                    Data[i] = inRecvData[13 + i];
                CharName = Encoding.Default.GetString(Data).Split('\0')[0];

                DataSet AvatarData = null;
                using (DBTool_MySQL dbTool = new DBTool_MySQL(CommonLib.DBConnConfig))
                {
                    dbTool.Connect();
                    MySqlParamArray ParamList = new MySqlParamArray();
                    ParamList.Add("inAccountID", inAccountID);
                    ParamList.Add("inCharacterType", Character);
                    ParamList.Add("inCharacterName", CharName);
                    AvatarData = dbTool.ExcuteDataSet("sp_CreateAvatar", ParamList);
                }

                if (AvatarData.Tables.Count > 0)
                    return AccountManager.GetAvatarList(AvatarData.Tables[0])[0];
            }
            catch (Exception ex)
            {
                if (ex.Source.Contains("MySql.Data") == false)
                    throw;
            }

            return null;
        }
    }
}
