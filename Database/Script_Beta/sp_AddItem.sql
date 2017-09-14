DROP PROCEDURE IF EXISTS sp_AddItem;

DELIMITER //
CREATE PROCEDURE  sp_AddItem (IN inAccountID VARCHAR(30), IN inOrder INT, IN inIndex INT, inShopType INT)
BEGIN

	SELECT f_UID INTO @UID
	FROM tbl_User
	WHERE f_ID = inAccountID;

	INSERT INTO tbl_Inven(f_UID, f_Order, f_Index, f_Type)
	VALUES(@UID, inOrder, inIndex, inShopType);

	IF inShopType = 3 THEN
		UPDATE tbl_CardInfo SET f_Quantity = f_Quantity - 1
		WHERE f_Index = inIndex;
	END IF;

END; //
DELIMITER ;