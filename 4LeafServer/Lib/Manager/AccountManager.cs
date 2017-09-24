using Dapper;
using MySql.Data.MySqlClient;
using NSLib;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace LeafServer
{
    public static class AccountManager
    {
        public static bool CheckID(string AccountID)
        {
            using (var conn = new MySqlConnection(CommonLib.DBConnConfig))
            {
                conn.Open();
                var param = new DynamicParameters();

                param.Add("@AccountID", AccountID);
                param.Add("@outCheck", direction: ParameterDirection.Output);
                conn.Query("sp_CheckAccountID", param, commandType: CommandType.StoredProcedure);

                return param.Get<bool>("@outCheck");
                // TODO : SP에서 true/false 결과 반환 처리 필요
            }
        }

        public static bool Login(string AccountID, string inPassword, out UserModel outUserInfo)
        {
            outUserInfo = null;

            using (var conn = new MySqlConnection(CommonLib.DBConnConfig))
            {
                conn.Open();
                var param = new DynamicParameters();
                param.Add("@AccountID", AccountID);
                param.Add("@Password", inPassword);
                param.Add("@EncryptKey", CommonLib.DBEncryptKey);

                var result = conn.Query("sp_Login", param, commandType: CommandType.StoredProcedure);

                if (Common.IsSuccess(result))
                {
                    // TODO : 유저정보 바인딩 처리
                    outUserInfo = new UserModel();
                    //outUserInfo.Gender = Convert.ToBoolean(result.Tables[0].Rows[0]["Gender"]);
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

        public static void DayGP(string AccountID, int AvatarOrder, int GetGP)
        {
            using (var conn = new MySqlConnection(CommonLib.DBConnConfig))
            {
                conn.Open();
                var param = new DynamicParameters();
                param.Add("@AccountID", AccountID);
                param.Add("@AvatarOrder", AvatarOrder);
                param.Add("@GetGP", GetGP);

                conn.Query("sp_DailyGP", param, commandType: CommandType.StoredProcedure);
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

            using (var conn = new MySqlConnection(CommonLib.DBConnConfig))
            {
                conn.Open();
                var param = new DynamicParameters();
                param.Add("@AccountID", AccountID);
                param.Add("@Password", Password);
                param.Add("@Gender", Gender);
                param.Add("@EncryptKey", CommonLib.DBEncryptKey);
                param.Add("RetVal", direction: ParameterDirection.ReturnValue);
                conn.Query("sp_CreateAccount", param, commandType: CommandType.StoredProcedure);

                return Common.IsSuccess(param.Get<int>("RetVal"));
            }
        }

        public static int GetAvatarCount(string AccountID)
        {
            using (var conn = new MySqlConnection(CommonLib.DBConnConfig))
            {
                conn.Open();
                var param = new DynamicParameters();
                param.Add("@AccountID", AccountID);
                param.Add("RetVal", direction: ParameterDirection.ReturnValue);
                conn.Query("sp_GetAvatarCount", param, commandType: CommandType.StoredProcedure);

                return param.Get<int>("RetVal");
            }
        }

        public static bool UpdateCostume(string AccountID, AvatarModel Avatar)
        {
            using (var conn = new MySqlConnection(CommonLib.DBConnConfig))
            {
                conn.Open();
                var param = new DynamicParameters();

                param.Add("@AccountID", AccountID);
                param.Add("@Order", Avatar.Order);
                param.Add("@Hair", Avatar.Hair);
                param.Add("@HairAcc", Avatar.HairAcc);

                if (Avatar.Clothes.Count == 0)
                {
                    param.Add("@Clothes", 0);
                    param.Add("@Clothes2", 0);
                    param.Add("@Clothes3", 0);
                }
                else
                {
                    if (Avatar.Clothes.Count >= 1)
                    {
                        param.Add("@Clothes", Avatar.Clothes[0]);
                        if (Avatar.Clothes.Count >= 2)
                        {
                            param.Add("@Clothes2", Avatar.Clothes[1]);
                            if (Avatar.Clothes.Count >= 3)
                                param.Add("@Clothes3", Avatar.Clothes[2]);
                        }
                    }
                }

                if (Avatar.Pants.Count == 0)
                {
                    param.Add("@Pants", 0);
                    param.Add("@Pants2", 0);
                    param.Add("@Pants3", 0);
                }
                else
                {
                    if (Avatar.Pants.Count >= 1)
                    {
                        param.Add("@Pants", Avatar.Pants[0]);
                        if (Avatar.Pants.Count >= 2)
                        {
                            param.Add("@Pants2", Avatar.Pants[1]);
                            if (Avatar.Pants.Count >= 3)
                                param.Add("@Pants3", Avatar.Pants[2]);
                        }
                    }
                }

                param.Add("@Shoes", Avatar.Shoes);

                if (Avatar.Weapone.Count == 0)
                {
                    param.Add("@Weapone", 0);
                    param.Add("@Weapone2", 0);
                    param.Add("@Weapone3", 0);
                }
                else
                {
                    if (Avatar.Weapone.Count >= 1)
                    {
                        param.Add("@Weapone", Avatar.Weapone[0]);
                        if (Avatar.Weapone.Count >= 2)
                        {
                            param.Add("@Weapone2", Avatar.Weapone[1]);
                            if (Avatar.Weapone.Count >= 3)
                                param.Add("@Weapone3", Avatar.Weapone[2]);
                        }
                    }
                }

                if (Avatar.Accessory.Count == 0)
                {
                    param.Add("@Acc1", 0);
                    param.Add("@Acc2", 0);
                    param.Add("@Acc3", 0);
                    param.Add("@Acc4", 0);
                    param.Add("@Acc5", 0);
                    param.Add("@Acc6", 0);
                }
                else
                {
                    if (Avatar.Accessory.Count >= 1)
                    {
                        param.Add("@Acc1", Avatar.Accessory[0]);
                        if (Avatar.Accessory.Count >= 2)
                        {
                            param.Add("@Acc2", Avatar.Accessory[1]);
                            if (Avatar.Accessory.Count >= 3)
                            {
                                param.Add("@Acc3", Avatar.Accessory[2]);
                                if (Avatar.Accessory.Count >= 4)
                                {
                                    param.Add("@Acc4", Avatar.Accessory[3]);
                                    if (Avatar.Accessory.Count >= 5)
                                    {
                                        param.Add("@Acc5", Avatar.Accessory[4]);
                                        if (Avatar.Accessory.Count >= 6)
                                            param.Add("@Acc6", Avatar.Accessory[5]);
                                    }
                                }
                            }
                        }
                    }
                }

                param.Add("RetVal", direction: ParameterDirection.ReturnValue);
                conn.Query("sp_UpdateCostume", param, commandType: CommandType.StoredProcedure);

                return Common.IsSuccess(param.Get<int>("RetVal"));
            }
        }

        public static bool BuyItem(string AccountID, int Order, int ItemIndex)
        {
            using (var conn = new MySqlConnection(CommonLib.DBConnConfig))
            {
                conn.Open();
                var param = new DynamicParameters();
                param.Add("@AccountID", AccountID);
                param.Add("@Order", Order);
                param.Add("@ItemIndex", ItemIndex);
                param.Add("RetVal", direction: ParameterDirection.ReturnValue);
                conn.Query("sp_BuyItem", param);

                return Common.IsSuccess(param.Get<int>("RetVal"));
            }
        }

        public static bool SellItem(string AccountID, int Order, int ItemIndex)
        {
            using (var conn = new MySqlConnection(CommonLib.DBConnConfig))
            {
                conn.Open();
                var param = new DynamicParameters();
                param.Add("@AccountID", AccountID);
                param.Add("@Order", Order);
                param.Add("@ItemIndex", ItemIndex);
                param.Add("RetVal", direction: ParameterDirection.ReturnValue);
                conn.Query("sp_SellItem", param, commandType: CommandType.StoredProcedure);

                return Common.IsSuccess(param.Get<int>("RetVal"));
            }
        }

        public static List<InvenModel> GetInvenList(string AccountID, int inAvatarOrder)
        {
            using (var conn = new MySqlConnection(CommonLib.DBConnConfig))
            {
                conn.Open();
                var param = new DynamicParameters();
                param.Add("@AccountID", AccountID);
                param.Add("@Order", inAvatarOrder);

                var result = conn.QueryMultiple("sp_GetInven", param, commandType: CommandType.StoredProcedure);
                // TODO : 인벤토리 구성내용 구현
                /*
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
                 */
                return null;
            }
        }

        public static AvatarModel CreateAvatar(byte[] inRecvData, string AccountID)
        {
            int Character = inRecvData[12];
            string CharName = string.Empty;

            byte[] Data = new byte[22];
            for (int i = 0; i < 22; i++)
                Data[i] = inRecvData[13 + i];
            CharName = Encoding.Default.GetString(Data).Split('\0')[0];

            using (var conn = new MySqlConnection(CommonLib.DBConnConfig))
            {
                conn.Open();
                var param = new DynamicParameters();
                param.Add("AccountID", AccountID);
                param.Add("CharacterType", Character);
                param.Add("CharacterName", CharName);
                var result = conn.QuerySingle<AvatarModel>("sp_CreateAvatar", param, commandType: CommandType.StoredProcedure);
                return result;
            }
        }
    }
}