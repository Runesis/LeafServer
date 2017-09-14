SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NightStorm
-- Create date: 2011-11-24 16:00
-- Description:	계정정보 얻기
-- =============================================
ALTER PROCEDURE sp_AccGetAccountData
@v_Sid VARCHAR(16)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT * FROM account WHERE sid = @v_Sid
		
END
