namespace LeafServer
{
    partial class frmMain
    {
        /// <summary>
        /// 필수 디자이너 변수입니다.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 사용 중인 모든 리소스를 정리합니다.
        /// </summary>
        /// <param name="disposing">관리되는 리소스를 삭제해야 하면 true이고, 그렇지 않으면 false입니다.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form 디자이너에서 생성한 코드

        /// <summary>
        /// 디자이너 지원에 필요한 메서드입니다.
        /// 이 메서드의 내용을 코드 편집기로 수정하지 마십시오.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(frmMain));
            this.btnServerSwitch = new System.Windows.Forms.Button();
            this.txtLog = new System.Windows.Forms.TextBox();
            this.tmrConnUserCount = new System.Windows.Forms.Timer(this.components);
            this.lblConnUserCount = new System.Windows.Forms.Label();
            this.txtboxConnUserCount = new System.Windows.Forms.TextBox();
            this.grboxInfo = new System.Windows.Forms.GroupBox();
            this.grboxInfo.SuspendLayout();
            this.SuspendLayout();
            // 
            // btnServerSwitch
            // 
            this.btnServerSwitch.Location = new System.Drawing.Point(497, 12);
            this.btnServerSwitch.Name = "btnServerSwitch";
            this.btnServerSwitch.Size = new System.Drawing.Size(75, 23);
            this.btnServerSwitch.TabIndex = 0;
            this.btnServerSwitch.Text = "Open";
            this.btnServerSwitch.UseVisualStyleBackColor = true;
            this.btnServerSwitch.Click += new System.EventHandler(this.btnServerSwitch_Click);
            // 
            // txtLog
            // 
            this.txtLog.BackColor = System.Drawing.Color.White;
            this.txtLog.Cursor = System.Windows.Forms.Cursors.Arrow;
            this.txtLog.Location = new System.Drawing.Point(12, 96);
            this.txtLog.MaxLength = 65535;
            this.txtLog.Multiline = true;
            this.txtLog.Name = "txtLog";
            this.txtLog.ReadOnly = true;
            this.txtLog.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.txtLog.ShortcutsEnabled = false;
            this.txtLog.Size = new System.Drawing.Size(560, 254);
            this.txtLog.TabIndex = 3;
            this.txtLog.TabStop = false;
            // 
            // tmrConnUserCount
            // 
            this.tmrConnUserCount.Interval = 300;
            this.tmrConnUserCount.Tick += new System.EventHandler(this.tmrConnUserCount_Tick);
            // 
            // lblConnUserCount
            // 
            this.lblConnUserCount.AutoSize = true;
            this.lblConnUserCount.Location = new System.Drawing.Point(6, 17);
            this.lblConnUserCount.Name = "lblConnUserCount";
            this.lblConnUserCount.Size = new System.Drawing.Size(41, 12);
            this.lblConnUserCount.TabIndex = 0;
            this.lblConnUserCount.Text = "접속자";
            // 
            // txtboxConnUserCount
            // 
            this.txtboxConnUserCount.BackColor = System.Drawing.Color.White;
            this.txtboxConnUserCount.Cursor = System.Windows.Forms.Cursors.Arrow;
            this.txtboxConnUserCount.Location = new System.Drawing.Point(53, 14);
            this.txtboxConnUserCount.MaxLength = 8;
            this.txtboxConnUserCount.Name = "txtboxConnUserCount";
            this.txtboxConnUserCount.ReadOnly = true;
            this.txtboxConnUserCount.Size = new System.Drawing.Size(65, 21);
            this.txtboxConnUserCount.TabIndex = 1;
            this.txtboxConnUserCount.TabStop = false;
            this.txtboxConnUserCount.Text = "0";
            this.txtboxConnUserCount.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            // 
            // grboxInfo
            // 
            this.grboxInfo.Controls.Add(this.txtboxConnUserCount);
            this.grboxInfo.Controls.Add(this.lblConnUserCount);
            this.grboxInfo.Location = new System.Drawing.Point(12, 12);
            this.grboxInfo.Name = "grboxInfo";
            this.grboxInfo.Size = new System.Drawing.Size(131, 78);
            this.grboxInfo.TabIndex = 4;
            this.grboxInfo.TabStop = false;
            this.grboxInfo.Text = "정보";
            // 
            // frmMain
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(584, 362);
            this.Controls.Add(this.grboxInfo);
            this.Controls.Add(this.txtLog);
            this.Controls.Add(this.btnServerSwitch);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmMain";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "4Leaf FreeServer by NS";
            this.grboxInfo.ResumeLayout(false);
            this.grboxInfo.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button btnServerSwitch;
        private System.Windows.Forms.TextBox txtLog;
        private System.Windows.Forms.Timer tmrConnUserCount;
        private System.Windows.Forms.Label lblConnUserCount;
        private System.Windows.Forms.TextBox txtboxConnUserCount;
        private System.Windows.Forms.GroupBox grboxInfo;
    }
}

