DROP PROCEDURE IF EXISTS sp_SubItem;

DELIMITER //
CREATE PROCEDURE sp_SubItem(IN inAccountID VARCHAR(30), IN inOrder INT, IN inIndex INT)
BEGIN

	DELETE FROM tbl_Inven
	WHERE f_UID = (SELECT f_UID FROM tbl_User WHERE f_ID = inAccountID)
		AND f_Order = inOrder
		AND f_Index = inIndex;
END; //
DELIMITER ;