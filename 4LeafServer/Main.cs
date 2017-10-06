using NSLib;
using System;
using System.Windows.Forms;

namespace LeafServer
{
    public partial class frmMain : Form
    {
        private ServConn ConnectionServer = null;

        public frmMain()
        {
            InitializeComponent();

            LoadData();
        }

        private void LoadData()
        {
            if (DataContainer.LoadContainer())
            {
                btnReloadData.Enabled = false;
                Log("Data Loading Complete.");
            }
            else
            {
                btnReloadData.Enabled = true;
                Log("Data Load Error.");
            }
        }

        #region Log Message Print

        public void Log(string logText)
        {
            if (String.IsNullOrEmpty(logText))
                return;

            LogAppendText(logText);
        }

        public void Log(string targetText, params object[] arg)
        {
            if (String.IsNullOrEmpty(targetText))
                return;

            LogAppendText(String.Format(targetText, arg));
        }

        private void LogAppendText(string logText)
        {
            if (txtLog.Text.Length >= UInt16.MaxValue)
                txtLog.Clear();

            string Log = String.Format("[" + DateTime.Now + "]" + " : " + logText + "\r\n");

            if (InvokeRequired)
                Invoke((MethodInvoker)delegate { txtLog.AppendText(Log); });
            else
                txtLog.AppendText(Log);
        }

        #endregion

        /// <summary>
        /// 서버 스위치
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnServerSwitch_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CommonLib.IsON)
                {
                    if (DataContainer.GetItemList == null || DataContainer.GetCardList == null)
                    {
                        MessageBox.Show("데이터가 올바르게 로딩되지 않았습니다.", "경고", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        return;
                    }

                    if (ConnectionServer != null)
                    {
                        ConnectionServer.Dispose();
                        ConnectionServer = null;
                    }

                    CommonLib.IsON = true;

                    ConnectionServer = new ServConn();
                    ConnectionServer.ConnServerStart();

                    btnServerSwitch.BackColor = System.Drawing.Color.SeaShell;
                    btnServerSwitch.Text = "Closed";
                    tmrConnUserCount.Enabled = true;

                    Log("Address : {0}", NetworkManager.GetLocalIPAddress);
                    Log("Port : {0}", CommonLib.SERVER_PORT);
                    Log("Server ON Complete.");
                }
                else
                {
                    CommonLib.IsON = false;

                    ConnectionServer.ConnServerStop();
                    if (ConnectionServer != null)
                        ConnectionServer = null;

                    btnServerSwitch.BackColor = System.Drawing.Color.Azure;
                    btnServerSwitch.Text = "Open";
                    tmrConnUserCount.Enabled = false;

                    txtboxConnUserCount.Text = "0";

                    Log("Server Closed.");
                }
            }
            catch (Exception ex)
            {
                Log("Exception Error!");
                Log("{0} //----// {1}", ex.StackTrace.ToString(), ex.Message.ToString());
            }
        }

        private void tmrConnUserCount_Tick(object sender, EventArgs e)
        {
            LeafConnection.ConnUserList.RemoveAll(r => r.ClientSocket == null || r.ClientSocket.Connected == false);

            txtboxConnUserCount.Text = LeafConnection.ConnUserList.Count.ToString();
        }

        private void btnReloadData_Click(object sender, EventArgs e)
        {
            if (!DataContainer.IsDataLoad)
                LoadData();
            else
                btnReloadData.Enabled = false;
        }
    }
}
