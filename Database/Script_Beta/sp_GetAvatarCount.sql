DROP PROCEDURE IF EXISTS sp_GetAvatarCount;

DELIMITER //
CREATE PROCEDURE sp_GetAvatarCount(
	inAccountID VARCHAR(30),
	OUT outAvatarCount INT
)
BEGIN
	SET outAvatarCount = 0;

	SELECT COUNT(F_UID) INTO outAvatarCount
	FROM tbl_Avatar
	WHERE f_UID = (SELECT f_UID FROM tbl_User WHERE f_ID = inAccountID);
END; //
DELIMITER ;


/*
CALL sp_GetAvatarCount('j1598', @Count);
SELECT @Count;
*/