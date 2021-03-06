USE [4Leaf]
GO
/****** Object:  StoredProcedure [dbo].[sp_AccRegister]    Script Date: 03/20/2012 10:23:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NightStorm
-- Create date: 2011-11-24 15:30
-- Description:	계정 생성
-- =============================================
ALTER PROCEDURE [dbo].[sp_AccRegister]
@v_sid VARCHAR(16),
@v_password VARCHAR(32),
@v_name VARCHAR(12),
@v_sex int,
@v_avatarcount int,
@v_birth VARCHAR(10),
@v_privatenumber VARCHAR(14),
@v_domaincode int,
@v_address1 VARCHAR(50),
@v_address2 VARCHAR(100),
@v_email VARCHAR(50),
@v_profile VARCHAR(200),
@v_passwordquestion VARCHAR(50),
@v_passwordanswer VARCHAR(50),
@v_regdate DATETIME
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO account(sid, password, name, sex, avatarcount, birth, privatenumber,
	domaincode, address1, address2, email, profile, passwordquestion, passwordanswer, regdate)
	VALUES
	(@v_sid, @v_password, @v_name, @v_sex, @v_avatarcount, @v_birth, @v_privatenumber,
	@v_domaincode, @v_address1, @v_address2, @v_email, @v_profile, @v_passwordquestion,@v_passwordanswer, @v_regdate)
END
