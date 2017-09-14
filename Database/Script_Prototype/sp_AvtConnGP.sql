USE [4Leaf]
GO
/****** Object:  StoredProcedure [dbo].[sp_AvtConnGP]    Script Date: 04/10/2012 09:16:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NightStorm
-- Create date: 2012-03-13 16:00
-- Description:	접속 지속시간 수당 지급
-- =============================================
ALTER PROCEDURE [dbo].[sp_AvtConnGP]
@v_Uid INT,
@v_Aid INT,
@v_IncomeGP INT,
@retVal int OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE avatar set gp = gp + @v_IncomeGP WHERE uid = @v_Uid AND aid = @v_Aid
	SET @retVal = 0
	
END
