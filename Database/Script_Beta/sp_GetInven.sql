DROP PROCEDURE IF EXISTS sp_GetInven;

DELIMITER //
CREATE PROCEDURE sp_GetInven(
	IN `inAccountID` VARCHAR(30),
	IN `inOrder` INT
)
BEGIN
	SELECT f_UID AS 'UID', f_Index AS 'ItemIndex', f_Type AS 'Type'
	FROM tbl_Inven
	WHERE f_UID = (SELECT f_UID FROM tbl_User WHERE f_ID = inAccountID);
END; //
DELIMITER ;