SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NightStorm
-- Create date: 2011-12-15 19:30
-- Description:	æ∆πŸ≈∏ GP
-- =============================================
ALTER PROCEDURE sp_AvtGetGP
@v_Nick VARCHAR(22),
@retVal INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;
	
	SELECT @retVal = gp FROM avatar WHERE nick = @v_Nick;
	
	RETURN

END
