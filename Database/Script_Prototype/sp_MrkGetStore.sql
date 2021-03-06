USE [4Leaf]
GO
/****** Object:  StoredProcedure [dbo].[sp_MrkGetStore]    Script Date: 12/15/2011 18:59:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NightStorm
-- Create date: 2011-12-14 17:50
-- Description:	상점 아이템 목록 얻기
-- =============================================
ALTER PROCEDURE [dbo].[sp_MrkGetStore]
@v_Store VARCHAR(50),
@v_Sex Int
AS
BEGIN
	SET NOCOUNT ON;
	IF( @v_Store = 'HairShop' )
	BEGIN
		SELECT i_index, type, series, sex, buy_price, sell_price FROM item
		WHERE mount_number = 3 AND sex = @v_Sex AND store = @v_Store;
	END
	ELSE
	BEGIN
		SELECT i_index, type, series, sex, buy_price, sell_price FROM item
		WHERE sex = @v_Sex AND store = @v_Store;
	END
END
