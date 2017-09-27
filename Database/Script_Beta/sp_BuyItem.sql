DROP PROCEDURE IF EXISTS sp_BuyItem;

DELIMITER //
CREATE PROCEDURE sp_BuyItem(
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

	SELECT f_BuyPrice INTO @BuyPrice
	FROM tbl_ItemInfo
	WHERE f_Index = inItemIndex;

	IF (SELECT f_GP FROM tbl_Avatar WHERE f_UID = @UID AND f_Order = inOrder) >= @BuyPrice THEN
	BEGIN
		IF fnc_AddItem(inAccountID, inOrder, inItemIndex) = true THEN
		BEGIN
			UPDATE tbl_Avatar SET f_GP = f_GP - @BuyPrice
			WHERE f_UID = @UID AND f_Order = inOrder;

			SET RetVal = true;
		END; END IF;
	END; END IF;
END; //
DELIMITER ;