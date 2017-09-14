DROP PROCEDURE IF EXISTS sp_SellItem;

DELIMITER //
CREATE PROCEDURE sp_SellItem(inAccountID VARCHAR(30), inOrder INT, inItemIndex INT)
BEGIN
	
	SELECT f_UID INTO @UID
	FROM tbl_User
	WHERE f_ID = inAccountID;

	SELECT f_SellPrice INTO @SellPrice
	FROM tbl_ItemInfo
	WHERE f_Index = inItemIndex;

	UPDATE tbl_Avatar SET f_GP = f_GP + @SellPrice
	WHERE f_UID = @UID AND f_Order = inOrder;

	CALL sp_SubItem(inAccountID, inOrder, inItemIndex);

END; //