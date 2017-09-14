DROP PROCEDURE IF EXISTS sp_Login;

DELIMITER //
CREATE PROCEDURE sp_Login(inAccountID varchar(30), inPassword VARCHAR(30), EncryptKey VARCHAR(20))
BEGIN

	SET @DecryptPass = HEX(AES_ENCRYPT(inPassword, SHA2(EncryptKey, 512)));

	SELECT f_Password INTO @GetPassword
	FROM tbl_User WHERE f_ID = inAccountID;
	
	IF @GetPassword = @DecryptPass THEN
		SET @UID = -1;
		SET @AvatarCount = 0;

		SELECT f_LastLogin, f_UID INTO @LastLogin, @UID
		FROM tbl_User
		WHERE f_ID = inAccountID;

		SELECT COUNT(*) INTO @AvatarCount
		FROM tbl_Avatar
		WHERE f_UID = @UID;

		SELECT 1 AS RetVal, @LastLogin AS 'LastLogin';

		UPDATE tbl_User SET f_LastLogin = NOW()
		WHERE f_ID = inAccountID;
		
		IF @AvatarCount > 0 THEN
			SELECT f_Order AS 'Order', f_CID AS CID, f_Name AS Name, f_Knight AS Knight,
				f_GP AS GP, f_FP AS FP,
				f_Hair AS Hair, f_HairAcc AS HairAcc,
				f_Clothes AS Clothes, f_Clothes2 AS Clothes2, f_Clothes3 AS Clothes3,
				f_Pants AS Pants, f_Pants2 AS Pants2, f_Pants3 AS Pants3,
				f_Weapone AS Weapone, f_Weapone2 AS Weapone2, f_Weapone3 AS Weapone3,
				f_Acc1 AS Acc1, f_Acc2 AS Acc2, f_Acc3 AS Acc3, f_Acc4 AS Acc4, f_Acc5 AS Acc5
			FROM tbl_Avatar
			WHERE f_UID = @UID;
		END IF;

	ELSE
		SELECT 0 AS RetVal;
	END IF;
END; //
DELIMITER ;



CALL sp_Login('nightstorm00', 'night197', 'NS#4@Leaf&');