DROP PROCEDURE IF EXISTS sp_BuyCard;

DELIMITER //
CREATE PROCEDURE sp_BuyCard(inAccountID VARCHAR(30), inOrder INT, inItemIndex INT)
BEGIN
	SELECT f_UID INTO @UID
	FROM tbl_User
	WHERE f_ID = inAccountID;

	SELECT f_BuyPrice INTO @BuyPrice
	FROM tbl_CardInfo
	WHERE f_Index = inItemIndex;

	IF (SELECT f_GP FROM tbl_Avatar WHERE f_UID = @UID AND f_Order = inOrder) >= @BuyPrice THEN
		CALL sp_AddItem(inAccountID, inOrder, inItemIndex, 3);
		UPDATE tbl_Avatar SET f_GP = f_GP - @BuyPrice
		WHERE f_UID = @UID AND f_Order = inOrder;
	END IF;
END; //
DELIMITER ;