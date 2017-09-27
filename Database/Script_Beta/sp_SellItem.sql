DROP PROCEDURE IF EXISTS sp_SellItem;

DELIMITER //
CREATE PROCEDURE sp_SellItem(
	IN inAccountID VARCHAR(30),
	IN inOrder INT,
	IN inItemIndex INT,
	OUT RetVal BOOL
)
BEGIN
	SET RetVal = false;
	
	SELECT f_UID INTO @UID
	FROM tbl_User
	WHERE f_ID = inAccountID;

	SELECT f_SellPrice INTO @SellPrice
	FROM tbl_ItemInfo
	WHERE f_Index = inItemIndex;

	IF fnc_SubItem(inAccountID, inOrder, inItemIndex) = true THEN
	BEGIN
		UPDATE tbl_Avatar SET f_GP = f_GP + @SellPrice
		WHERE f_UID = @UID AND f_Order = inOrder;

		SET RetVal = true;
	END; END IF;
END; //