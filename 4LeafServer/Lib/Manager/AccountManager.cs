using Dapper;
using MySql.Data.MySqlClient;
using NSLib;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
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

                param.Add("inAccountID", AccountID);
                param.Add("outCheck", direction: ParameterDirection.Output);
                conn.Query("sp_CheckAccountID", param, commandType: CommandType.StoredProcedure);

                return param.Get<bool>("outCheck");
            }
        }

        public static bool Login(string AccountID, string inPassword, out UserModel outUserInfo)
        {
            outUserInfo = null;

            using (var conn = new MySqlConnection(CommonLib.DBConnConfig))
            {
                conn.Open();
                var param = new DynamicParameters();
                param.Add("inAccountID", AccountID);
                param.Add("inPassword", inPassword);
                param.Add("EncryptKey", CommonLib.DBEncryptKey);
                param.Add("RetVal", direction: ParameterDirection.Output);

                var result = conn.QueryMultiple("sp_Login", param, commandType: CommandType.StoredProcedure);

                var loginResult = result.Read<LoginResultModel>().FirstOrDefault();
                var avatarList = result.Read<AvatarModel>().ToList();
                var equipList = result.Read<EquipmentModel>().ToList();
                if (loginResult == null)
                    return false;

                if (Common.IsSuccess(loginResult))
                {
                    outUserInfo = new UserModel
                    {
                        Gender = loginResult.Gender,
                        LastLogin = loginResult.LastLogin
                    };

                    if (avatarList == null)
                        outUserInfo.AvatarList = new List<AvatarModel>();
                    else
                    {
                        foreach (var objAvatar in avatarList)
                            objAvatar.SetEquipment(equipList);

                        outUserInfo.AvatarList = avatarList;
                    }

                    return true;
                }
            }

            return false;
        }

        public static bool DayGP(string AccountID, byte AvatarOrder, UInt32 GetGP)
        {
            if (AvatarOrder < 0 || AvatarOrder > 3 || GetGP < 1)
                return false;

            using (var conn = new MySqlConnection(CommonLib.DBConnConfig))
            {
                conn.Open();
                var param = new DynamicParameters();
                param.Add("inAccountID", AccountID);
                param.Add("inAvatarOrder", AvatarOrder);
                param.Add("inGetGP", GetGP);
                param.Add("RetVal", direction: ParameterDirection.Output);

                conn.Query("sp_DailyGP", param, commandType: CommandType.StoredProcedure);

                return Common.IsSuccess(param.Get<bool>("RetVal"));
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
                param.Add("inAccountID", AccountID);
                param.Add("inPassword", Password);
                param.Add("inGender", Gender);
                param.Add("EncryptKey", CommonLib.DBEncryptKey);
                param.Add("RetVal", direction: ParameterDirection.Output);
                conn.Query("sp_CreateAccount", param, commandType: CommandType.StoredProcedure);

                return Common.IsSuccess(param.Get<bool>("RetVal"));
            }
        }

        public static int GetAvatarCount(string AccountID)
        {
            using (var conn = new MySqlConnection(CommonLib.DBConnConfig))
            {
                conn.Open();
                var param = new DynamicParameters();
                param.Add("AccountID", AccountID);
                param.Add("outAvatarCount", direction: ParameterDirection.Output);
                conn.Query("sp_GetAvatarCount", param, commandType: CommandType.StoredProcedure);

                return param.Get<int>("outAvatarCount");
            }
        }

        public static bool UpdateCostume(string AccountID, AvatarModel Avatar)
        {
            if (Avatar == null)
                return false;

            using (var conn = new MySqlConnection(CommonLib.DBConnConfig))
            {
                conn.Open();
                var param = new DynamicParameters();

                param.Add("inAccountID", AccountID);
                param.Add("inOrder", Avatar.Order);
                param.Add("inHair", Avatar.Hair);
                param.Add("inHairAcc", Avatar.HairAcc);

                if (Avatar.Clothes.Count == 0)
                {
                    param.Add("inClothes", 0);
                    param.Add("inClothes2", 0);
                    param.Add("inClothes3", 0);
                }
                else
                {
                    if (Avatar.Clothes.Count >= 1)
                    {
                        param.Add("inClothes", Avatar.Clothes[0]);
                        if (Avatar.Clothes.Count >= 2)
                        {
                            param.Add("inClothes2", Avatar.Clothes[1]);
                            if (Avatar.Clothes.Count >= 3)
                                param.Add("inClothes3", Avatar.Clothes[2]);
                        }
                    }
                }

                if (Avatar.Pants.Count == 0)
                {
                    param.Add("inPants", 0);
                    param.Add("inPants2", 0);
                    param.Add("inPants3", 0);
                }
                else
                {
                    if (Avatar.Pants.Count >= 1)
                    {
                        param.Add("inPants", Avatar.Pants[0]);
                        if (Avatar.Pants.Count >= 2)
                        {
                            param.Add("inPants2", Avatar.Pants[1]);
                            if (Avatar.Pants.Count >= 3)
                                param.Add("inPants3", Avatar.Pants[2]);
                        }
                    }
                }

                param.Add("inShoes", Avatar.Shoes);

                if (Avatar.Weapone.Count == 0)
                {
                    param.Add("inWeapone", 0);
                    param.Add("inWeapone2", 0);
                    param.Add("inWeapone3", 0);
                }
                else
                {
                    if (Avatar.Weapone.Count >= 1)
                    {
                        param.Add("inWeapone", Avatar.Weapone[0]);
                        if (Avatar.Weapone.Count >= 2)
                        {
                            param.Add("inWeapone2", Avatar.Weapone[1]);
                            if (Avatar.Weapone.Count >= 3)
                                param.Add("inWeapone3", Avatar.Weapone[2]);
                        }
                    }
                }

                if (Avatar.Accessory.Count == 0)
                {
                    param.Add("inAcc1", 0);
                    param.Add("inAcc2", 0);
                    param.Add("inAcc3", 0);
                    param.Add("inAcc4", 0);
                    param.Add("inAcc5", 0);
                    param.Add("inAcc6", 0);
                    param.Add("inAcc7", 0);
                    param.Add("inAcc8", 0);
                }
                else
                {
                    if (Avatar.Accessory.Count >= 1)
                    {
                        param.Add("inAcc1", Avatar.Accessory[0]);
                        if (Avatar.Accessory.Count >= 2)
                        {
                            param.Add("inAcc2", Avatar.Accessory[1]);
                            if (Avatar.Accessory.Count >= 3)
                            {
                                param.Add("inAcc3", Avatar.Accessory[2]);
                                if (Avatar.Accessory.Count >= 4)
                                {
                                    param.Add("inAcc4", Avatar.Accessory[3]);
                                    if (Avatar.Accessory.Count >= 5)
                                    {
                                        param.Add("inAcc5", Avatar.Accessory[4]);
                                        if (Avatar.Accessory.Count >= 6)
                                        {
                                            param.Add("inAcc6", Avatar.Accessory[5]);
                                            if (Avatar.Accessory.Count >= 7)
                                            {
                                                param.Add("inAcc7", Avatar.Accessory[6]);
                                                if (Avatar.Accessory.Count >= 8)
                                                    param.Add("inAcc8", Avatar.Accessory[7]);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                param.Add("RetVal", direction: ParameterDirection.Output);
                conn.Query("sp_UpdateCostume", param, commandType: CommandType.StoredProcedure);

                return Common.IsSuccess(param.Get<bool>("RetVal"));
            }
        }

        public static bool BuyItem(string AccountID, int Order, int ItemIndex)
        {
            using (var conn = new MySqlConnection(CommonLib.DBConnConfig))
            {
                conn.Open();
                var param = new DynamicParameters();
                param.Add("inAccountID", AccountID);
                param.Add("inOrder", Order);
                param.Add("inItemIndex", ItemIndex);
                param.Add("RetVal", direction: ParameterDirection.Output);
                conn.Query("sp_BuyItem", param, commandType: CommandType.StoredProcedure);

                return Common.IsSuccess(param.Get<bool>("RetVal"));
            }
        }

        public static bool SellItem(string AccountID, int Order, int ItemIndex)
        {
            using (var conn = new MySqlConnection(CommonLib.DBConnConfig))
            {
                conn.Open();
                var param = new DynamicParameters();
                param.Add("inAccountID", AccountID);
                param.Add("inOrder", Order);
                param.Add("inItemIndex", ItemIndex);
                param.Add("RetVal", direction: ParameterDirection.Output);
                conn.Query("sp_SellItem", param, commandType: CommandType.StoredProcedure);

                return Common.IsSuccess(param.Get<bool>("RetVal"));
            }
        }

        public static List<InvenModel> GetInvenList(string AccountID, int inAvatarOrder)
        {
            using (var conn = new MySqlConnection(CommonLib.DBConnConfig))
            {
                conn.Open();
                var param = new DynamicParameters();
                param.Add("inAccountID", AccountID);
                param.Add("inOrder", inAvatarOrder);

                var result = conn.Query<InvenModel>("sp_GetInven", param, commandType: CommandType.StoredProcedure);

                if (result != null)
                    return result.ToList();
            }

            return new List<InvenModel>();
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
                param.Add("inAccountID", AccountID);
                param.Add("inCharacterType", Character);
                param.Add("inCharacterName", CharName);
                var result = conn.QuerySingle<AvatarModel>("sp_CreateAvatar", param, commandType: CommandType.StoredProcedure);
                return result;
            }
        }
    }
}