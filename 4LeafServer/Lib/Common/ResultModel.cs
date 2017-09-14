namespace LeafServer
{
    public class ResultModel : DisposeClass
    {
        private int resultCode;
        private string resultMessage;

        public ResultModel()
        {
            resultCode = -1;
            resultMessage = string.Empty;
        }

        public int Code
        {
            set
            {
                resultCode = value;
                resultMessage = CommonLib.DBResult(resultCode);
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