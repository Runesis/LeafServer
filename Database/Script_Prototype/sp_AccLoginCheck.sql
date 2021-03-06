USE [4Leaf]
GO
/****** Object:  StoredProcedure [dbo].[sp_AccLoginCheck]    Script Date: 03/20/2012 10:49:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NightStorm
-- Create date: 2011-11-24 15:50
-- Description:	로그인 체크
-- =============================================
ALTER PROCEDURE [dbo].[sp_AccLoginCheck]
@v_Sid varchar(16),
@v_Password varchar(32),
@retVal int output
AS
BEGIN
	SET NOCOUNT ON;
	
	if( EXISTS(SELECT 1 FROM account WHERE sid = @v_Sid AND password = @v_Password) )
		SET @retVal = 0
	ELSE
		SET @retVal = -1
END
