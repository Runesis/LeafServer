USE [4Leaf]
GO
/****** Object:  StoredProcedure [dbo].[sp_AccSearchID]    Script Date: 11/24/2011 16:04:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NightStorm
-- Create date: 2011-11-24 15:00
-- Description:	ID 검색
-- =============================================
ALTER PROCEDURE [dbo].[sp_AccSearchID]
@v_Sid varchar(16),
@retVal int output
AS
BEGIN
	SET NOCOUNT ON;
	
	if( EXISTS(SELECT COUNT(1) FROM account WHERE sid = @v_Sid) )
		SET @retVal = 0
	ELSE
		SET @retVal = -1
END
