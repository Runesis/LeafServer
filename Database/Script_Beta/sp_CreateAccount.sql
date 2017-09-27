DROP PROCEDURE IF EXISTS sp_CreateAccount;

DELIMITER //
CREATE PROCEDURE sp_CreateAccount(
	IN `inAccountID` varchar(30),
	IN `inPassword` VARCHAR(30),
	IN `inGender` int,
	IN `EncryptKey` VARCHAR(20),
	OUT RetVal BOOL
)
BEGIN
	SET RetVal = false;
	SET @EncryptPass = HEX(AES_ENCRYPT(inPassword, SHA2(EncryptKey, 512)));

	INSERT INTO tbl_User(f_ID, f_Password, f_Gender, f_LoginTime, f_LastLogin)
	VALUES(inAccountID, @EncryptPass, inGender, 0, NOW());
	
	SET RetVal = true;
END; //
DELIMITER ;