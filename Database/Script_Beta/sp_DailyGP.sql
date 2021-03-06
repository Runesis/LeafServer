DROP PROCEDURE IF EXISTS sp_DailyGP;

DELIMITER //
CREATE PROCEDURE sp_DailyGP(
	inAccountID VARCHAR(30),
	inAvatarOrder INT,
	inGetGP INT,
	OUT RetVal BOOL)
BEGIN
	SET RetVal = false;

	UPDATE tbl_Avatar SET f_GP = f_GP + inGetGP
	WHERE f_UID = (SELECT f_UID FROM tbl_User WHERE f_ID = inAccountID)
		AND f_Order = inAvatarOrder;
	
	SET RetVal = true;
END; //
DELIMITER ;