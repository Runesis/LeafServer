DROP PROCEDURE IF EXISTS sp_GetLeafData;

DELIMITER //
CREATE PROCEDURE sp_GetLeafData()
BEGIN

	SELECT f_TID, f_Index, f_Type, f_Series, f_Name, f_Mount, f_Sex,
	f_BuyPrice, f_SellPrice, f_Store
	FROM tbl_ItemInfo
	WHERE f_Store != 'None';

	SELECT f_CID, f_Index, f_Type, f_Rank, f_Name, f_Skill, f_Ability,
	f_BuyPrice, f_SellPrice, f_Quantity
	FROM tbl_CardInfo;
	
END; //
DELIMITER ;