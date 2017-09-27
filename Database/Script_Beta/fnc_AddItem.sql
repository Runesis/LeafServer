DROP FUNCTION IF EXISTS fnc_AddItem;

DELIMITER //
CREATE FUNCTION fnc_AddItem (
	inAccountID VARCHAR(30),
	inOrder INT,
	inIndex INT,
	inShopType INT)
RETURNS BOOL
BEGIN

	SELECT f_UID INTO @UID
	FROM tbl_User
	WHERE f_ID = inAccountID;

	INSERT INTO tbl_Inven(f_UID, f_Order, f_Index, f_Type)
	VALUES(@UID, inOrder, inIndex, inShopType);

	IF EXISTS (SELECT 1 FROM tbl_Inven WHERE f_UID = @UID) THEN
		/*IF inShopType = 3 THEN
			UPDATE tbl_CardInfo SET f_Quantity = f_Quantity - 1
			WHERE f_Index = inIndex;
		END IF;*/

		RETURN true;
	END IF;

	RETURN false;
END; //
DELIMITER ;