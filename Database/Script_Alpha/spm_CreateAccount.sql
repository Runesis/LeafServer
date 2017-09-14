SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NS
-- Create date: 2013-03-06
-- Description:	계정 생성
-- =============================================
ALTER PROCEDURE spm_CreateAccount
@v_ID VARCHAR(30),
@v_Password VARCHAR(20),
@v_Sex INT,
@v_Name VARCHAR(10),
@v_PrivateNum VARCHAR(20),
@v_BirthDay DATE,
@v_ZoneCode INT,
@v_Address1 VARCHAR(40),
@v_Address2 VARCHAR(30),
@v_Email VARCHAR(40),
@v_JobMain INT,
@v_JobSub INT,
@v_FavorGame INT,
@v_Hobby VARCHAR(20),
@v_Introduce VARCHAR(70),
@v_PwdSubKey VARCHAR(50),
@v_PwdSubAS VARCHAR(20),
@RetVal INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN TRAN
			INSERT INTO tblm_Account(f_ID, f_Password, f_Sex, f_RegDate)
			VALUES(@v_ID, PWDENCRYPT(@v_Password), @v_Sex, GETDATE())
			
			INSERT INTO tblm_UserDetail(f_Name, f_PrivateNum, f_BirthDay, f_ZoneCode, f_Address1, f_Address2,
			f_Email, f_JobMain, f_JobSub, f_FavorGame, f_Hobby, f_Introduce, f_PwdSubKey, f_PwdSubKeyAS)
			VALUES(@v_Name, @v_PrivateNum, @v_BirthDay, @v_ZoneCode, @v_Address1, @v_Address2,
			@v_Email, @v_JobMain, @v_JobSub, @v_FavorGame, @v_Hobby, @v_Introduce, @v_PwdSubKey, @v_PwdSubAS)
		COMMIT TRAN
		
		SET @RetVal = 0

	END TRY
	BEGIN CATCH
		SET @RetVal = 100001
		EXEC sps_ErrorMessage -1, 'spm_CreateAccount', 100001, '', '', '', ''
	END CATCH

	RETURN
END
GO
