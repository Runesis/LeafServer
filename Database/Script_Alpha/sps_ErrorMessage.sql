SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NS
-- Create date: 2013-03-06
-- Description:	계정 체크
-- =============================================
ALTER PROCEDURE sps_ErrorMessage
@v_AIdx INT,
@v_SP VARCHAR(50),
@v_ErrorCode INT,
@v_ErrorMsg VARCHAR(20),
@v_Param1 VARCHAR(50),
@v_Param2 VARCHAR(50),
@v_Param3 VARCHAR(50),
@v_Param4 VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO tblg_ErrorLog(f_aidx, f_SP, f_ErrorCode, f_ErrorMsg, f_Param1, f_Param2, f_Param3, f_Param4, f_LogDate)
	VALUES(@v_AIdx, @v_SP, @v_ErrorCode, @v_ErrorMsg, @v_Param1, @v_Param2, @v_Param3, @v_Param4, GETDATE())

	RETURN
END
GO
