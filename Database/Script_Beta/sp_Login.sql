DROP PROCEDURE IF EXISTS sp_Login;

DELIMITER //

CREATE PROCEDURE sp_Login(
	IN inAccountID varchar(30),
	IN inPassword VARCHAR(30),
	IN EncryptKey VARCHAR(20),
	OUT RetVal BOOL
)
BEGIN

	SET RetVal = FALSE;
	SET @DecryptPass = HEX(AES_ENCRYPT(inPassword, SHA2(EncryptKey, 512)));

	SELECT f_Password INTO @GetPassword
	FROM tbl_User WHERE f_ID = inAccountID;
	
	IF @GetPassword = @DecryptPass THEN

		SET RetVal = TRUE;
		SET @UID = -1;
		SET @Gender = -1;

		SELECT f_UID, f_LastLogin, f_Gender INTO @UID, @LastLogin, @Gender
		FROM tbl_User
		WHERE f_ID = inAccountID;

		UPDATE tbl_User SET f_LastLogin = NOW()
		WHERE f_ID = inAccountID;

		SELECT @Gender AS 'Gender', @LastLogin AS 'LastLogin';

		SELECT f_Order AS 'Order', f_CID AS CID, f_Name AS Name, f_Knight AS Knight, f_GP AS GP, f_FP AS FP
		FROM tbl_Avatar
		WHERE f_UID = @UID;
		
		SELECT f_Order AS 'Order', f_equipId AS 'EquipId', f_Mount AS 'Mount'
		FROM tbl_equipment
		WHERE f_UID = @UID;
	END IF;
END; //

DELIMITER ;

/*
CALL sp_Login('nightstorm00', 'night197', 'NS#4@Leaf&');
CALL sp_Login('j1598', '1973', 'NS#4@Leaf&', @retval);
SELECT @retval;
*/