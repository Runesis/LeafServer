USE [4Leaf]
GO
/****** Object:  StoredProcedure [dbo].[sp_AvtOnedayGP]    Script Date: 11/27/2011 13:42:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NightStorm
-- Create date: 2011-11-24 14:40
-- Description:	하루 접속수당 체크 / 지급
-- =============================================
ALTER PROCEDURE [dbo].[sp_AvtOnedayGP]
@v_Uid int,
@retVal int OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @dtLastDate Datetime
	SELECT @dtLastDate = access_time FROM avatar WHERE uid = @v_Uid
	IF( DATEDIFF(DAY, GETDATE(), @dtLastDate) < 0 )
	BEGIN
		UPDATE avatar set access_time = GETDATE(), gp = gp + 100 WHERE uid = @v_Uid
		SET @retVal = 1;
	END
	ELSE
	BEGIN
		UPDATE avatar set access_time = GETDATE() WHERE uid = @v_Uid
		SET @retVal = 0;
	END
	
END
