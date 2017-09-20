using Newtonsoft.Json;

namespace NSLib
{
    public enum DBErrorCode
    {
        WrongPameter = 101,
        AlreadyExistsAccount = 102,
        NotExistsAccount = 103,
        WrongPassword = 104,

        Exception = 200,

        SUCCESS = 1000,
    }

    public class ResultModel : DisposeClass
    {
        private int resultCode;
        private string resultMessage;
        private string resultObject;

        public ResultModel()
        {
            resultCode = -1;
            resultMessage = string.Empty;
            resultObject = string.Empty;
        }

        public object Result
        {
            set
            {
                resultObject = JsonConvert.SerializeObject(value);
                if (resultObject != null)
                    resultCode = (int)DBErrorCode.SUCCESS;
            }
            get { return resultObject; }
        }

        public int Code
        {
            set
            {
                resultCode = value;
                resultMessage = Common.DBResult(resultCode);
            }
            get { return resultCode; }
        }

        public string Message
        {
            get { return resultMessage; }
        }

        public bool IsSuccess
        {
            get
            {
                if (resultCode == (int)DBErrorCode.SUCCESS)
                    return true;
                else
                    return false;
            }
        }

        public void SetMessage(string message)
        { resultMessage = message; }
    }
}