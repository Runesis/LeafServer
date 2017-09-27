DROP FUNCTION IF EXISTS fnc_SubItem;

DELIMITER //
CREATE FUNCTION fnc_SubItem(
	inAccountID VARCHAR(30),
	inOrder INT,
	inIndex INT
)
RETURNS BOOL
BEGIN
	IF EXISTS (SELECT f_UID FROM tbl_User WHERE f_ID = inAccountID) THEN
	BEGIN
		DELETE FROM tbl_Inven
		WHERE f_UID = (SELECT f_UID FROM tbl_User WHERE f_ID = inAccountID)
			AND f_Order = inOrder
			AND f_Index = inIndex;
	
		RETURN true;
	END; END IF;

	RETURN false;
END; //
DELIMITER ;