SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NS
-- Create date: 2013-03-06
-- Description:	계정 체크
-- =============================================
ALTER PROCEDURE spm_CheckID
@v_ID VARCHAR(30),
@RetVal INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	IF EXISTS (SELECT 1 FROM tblm_Account WHERE f_ID = @v_ID)
		SET @RetVal = 1
	ELSE
		SET @RetVal = 0

	RETURN
END
GO
