SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NightStorm
-- Create date: 2012-03-20
-- Description:	아바타 코스튬 정보 업데이트
-- =============================================
ALTER PROCEDURE sp_AvtUpdateCostume
@v_Aid INT,
@v_Hair INT,
@v_HairAcc INT,
@v_Clothes INT,
@v_Clothes2 INT,
@v_Clothes3 INT,
@v_Pants INT,
@v_Pants2 INT,
@v_Pants3 INT,
@v_Shoes INT,
@v_Weapon INT,
@v_Weapon2 INT,
@v_Acc1 INT,
@v_Acc2 INT,
@v_Acc3 INT,
@v_Acc4 INT,
@v_Acc5 INT,
@v_Acc6 INT,
@v_Acc7 INT,
@v_Acc8 INT,
@v_Acc9 INT,
@v_Acc10 INT,
@retVal INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE avatar_costume
	SET
		hair = @v_Hair, hairacc = @v_HairAcc, clothes = @v_Clothes, clothes_2 = @v_Clothes2, clothes_3 = @v_Clothes3,
		trousers = @v_Pants, trousers_2 = @v_Pants2, trousers_3 = @v_Pants3, shoes = @v_Shoes, weapon = @v_Weapon, weapon_2 = @v_Weapon2,
		accessory1 = @v_Acc1, accessory2 = @v_Acc2, accessory3 = @v_Acc3, accessory4 = @v_Acc4, accessory5 = @v_Acc5, accessory6 = @v_Acc6,
		accessory7 = @v_Acc7, accessory8 = @v_Acc8, accessory9 = @v_Acc9, accessory10 = @v_Acc10
	WHERE
		aid = @v_Aid
	
	SET @retVal = 0
END
GO
