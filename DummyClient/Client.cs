using DummyClient.Network;
using System;
using System.Net;
using System.Windows.Forms;

namespace DummyClient
{
    public partial class Client : Form
    {
        private bool _IsConnect = false;
        private ConnectionManager _connMng;

        public Client()
        {
            InitializeComponent();
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

        private void Connect()
        {
            try
            {
                if (_connMng != null)
                {
                    if (_connMng.IsConnect)
                        _connMng.Disconnect();

                    _connMng.Dispose();

                    if (_connMng != null)
                        _connMng = null;
                }

                if (IPAddress.TryParse(txtIPAddress.Text.Trim(), out IPAddress address)
                    && UInt16.TryParse(txtPort.Text.Trim(), out UInt16 port))
                {
                    if (_connMng == null)
                        _connMng = new ConnectionManager();

                    _IsConnect = true;
                    _connMng.Connection(address.ToString(), port);

                    Log("Server Connection Complete.");
                }
                else
                    MessageBox.Show("서버 정보가 올바르지 않습니다.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            catch { throw; }
        }

        private void Disconnect()
        {
            if (_connMng != null)
            {
                if (_connMng.IsConnect)
                    _connMng.Disconnect();

                _IsConnect = false;
                _connMng.Dispose();

                Log("Server Disconnection Complete.");

                if (_connMng != null)
                    _connMng = null;
            }
        }

        private void btnConnect_Click(object sender, EventArgs e)
        {
            try
            {
                if (_IsConnect)
                    Disconnect();
                else
                    Connect();
            }
            catch (Exception ex)
            {
                Log(ex.Message);
            }
        }
    }
}