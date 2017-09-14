using System;
using System.Windows.Forms;

namespace LeafServer
{
    public delegate void add_msg();                          // 디버깅 정보 출력 

    public partial class frmMain : Form
    {
        private ServConn ConnectionServer = null;
        private string LogMessage = null;

        public frmMain()
        {
            InitializeComponent();

            if (DataContainer.LoadContainer())
            { Add_MSG("Data Loading Complete."); }
            else
            { Add_MSG("Data Load Error."); }
        }

        #region Log Message Print

        /// <summary>
        /// 디버깅창에 메시지 출력
        /// </summary>
        /// <param name="msg">출력할 메시지</param>		
        public void Add_MSG(string strMsg)
        {
            this.LogMessage = strMsg;
            if (txtboxLog.InvokeRequired)
            {
                add_msg addmsg = new add_msg(AddMSG);
                this.Invoke(addmsg);
            }
            else
            {
                lock (this.txtboxLog)
                {
                    this.txtboxLog.AppendText("[" + DateTime.Now + "]" + " : " + this.LogMessage + "\r\n");
                    this.txtboxLog.ScrollToCaret();
                }
            }
        }

        /// <summary>
        /// 디버깅 창 Invoke함수
        /// </summary>
        private void AddMSG()
        {
            lock (this.txtboxLog)
            {
                this.txtboxLog.AppendText("[" + DateTime.Now + "]" + " : " + this.LogMessage + "\r\n");
                this.txtboxLog.ScrollToCaret();
            }
        }

        #endregion

        /// <summary>
        /// 서버 스위치
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnServerSwitch_Click(object sender, System.EventArgs e)
        {
            try
            {
                if (CommonLib.ServerStatus == false)
                {
                    int Port = -1;
                    if (txtboxPort.Text.Length < 1)
                    {
                        this.Add_MSG("포트가 올바르지 않습니다.");
                        return;
                    }
                    else
                    {
                        Port = Convert.ToInt32(txtboxPort.Text);
                        if (Port > 65535 || Port < 1)
                        {
                            this.Add_MSG("포트가 올바르지 않습니다.");
                            return;
                        }
                    }

                    if (ConnectionServer != null)
                    {
                        ConnectionServer.Dispose();
                        ConnectionServer = null;
                    }

                    ConnectionServer = new ServConn(Port);
                    ConnectionServer.ConnServerStart();

                    CommonLib.ServerStatus = true;

                    btnServerSwitch.Text = "Closed";
                    txtboxPort.Enabled = false;
                    tmrConnUserCount.Enabled = true;

                    this.Add_MSG("Server Open. // Port = " + Port.ToString());
                }
                else
                {
                    CommonLib.ServerStatus = false;

                    ConnectionServer.ConnServerStop();
                    //ConnectionServer.Dispose();
                    if (ConnectionServer != null)
                        ConnectionServer = null;

                    btnServerSwitch.Text = "Open";
                    txtboxPort.Enabled = true;

                    tmrConnUserCount.Enabled = false;
                    txtboxConnUserCount.Text = "0";

                    this.Add_MSG("Server Closed");
                }
            }
            catch (Exception ex)
            { this.Add_MSG("Exception Error!! - " + ex.Message.ToString() + " // " + ex.StackTrace.ToString()); }
        }

        private void tmrConnUserCount_Tick(object sender, EventArgs e)
        {
            LeafConnection.ConnUserList.RemoveAll(r => r.ClientSocket == null);
            LeafConnection.ConnUserList.RemoveAll(r => r.ClientSocket.Connected == false);

            txtboxConnUserCount.Text = LeafConnection.ConnUserList.Count.ToString();
        }
    }
}
