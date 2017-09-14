SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NightStorm
-- Create date: 2011-11-24 16:30
-- Description:	아바타 개수 얻기(존재유무)
-- =============================================
ALTER PROCEDURE sp_AvtGetAvatarCount
@v_Sid VARCHAR(16),
@retVal int OUTPUT
AS
BEGIN
	SET NOCOUNT ON
	
	SELECT @retVal = COUNT(AVT.aid) FROM account AS ACC, avatar AS AVT WHERE ACC.uid = AVT.uid AND ACC.sid = @v_Sid

END
