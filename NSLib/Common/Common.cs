using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Reflection;

namespace NSLib
{
    public static class Common
    {
        private static readonly Dictionary<int, string> _dbOutput = new Dictionary<int, string>()
        {
            /// Account
            { 101, "입력 인자가 올바르지 않습니다." },
            { 102, "이미 존재하는 계정 입니다."},
            { 103, "존재하지 않는 계정 입니다." },
            { 104, "Password가 올바르지 않습니다."},

            { 200, "예상치 못한 오류가 발생 하였습니다. 관리자에게 문의 바랍니다."},
            { 1000, "Success"}
        };

        public static string DBResult(int resCode)
        {
            if (_dbOutput.ContainsKey(resCode))
                return _dbOutput[resCode];
            else
                return string.Empty;
        }

        public static bool IsSuccess(int resCode)
        {
            if (resCode == (int)DBErrorCode.SUCCESS)
                return true;
            else
                return false;
        }

        public static string EnumDesc(this Enum value)
        {
            FieldInfo field = value.GetType().GetField(value.ToString());

            DescriptionAttribute attribute = Attribute.GetCustomAttribute(field, typeof(DescriptionAttribute)) as DescriptionAttribute;

            return attribute == null ? value.ToString() : attribute.Description;
        }
    }
}
