SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NightStorm
-- Create date: 2011-12-15 18:20
-- Description:	아이템 구매
-- =============================================
ALTER PROCEDURE sp_AvtBuyItem
@v_Aid Int,
@v_Nick VARCHAR(22),
@v_ItemIdx Int,
@v_ItemType Int OUTPUT,
@v_ItemBuyPrice INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;
	
	SELECT @v_ItemType = mount_number FROM item;
	SELECT @v_ItemBuyPrice = buy_price FROM item WHERE i_index = @v_ItemIdx
	
	IF ( @v_ItemBuyPrice > (SELECT gp FROM avatar WHERE nick = @v_Nick) )
	BEGIN
		SET @v_ItemType = 0
		RETURN
	END

	INSERT INTO inventory(aid, itemidx, itemtype, gettime)
	VALUES(@v_Aid, @v_ItemIdx, @v_ItemType, GETDATE())
	IF @@ERROR <> 0 GOTO errorHandler
	
	UPDATE avatar SET gp = gp - @v_ItemBuyPrice WHERE nick = @v_Nick
	IF @@ERROR <> 0 GOTO errorHandler
	
	RETURN

errorHandler:

	SET @v_ItemType = -1
	RETURN
	
END
