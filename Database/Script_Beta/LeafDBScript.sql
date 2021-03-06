-- --------------------------------------------------------
-- 호스트:                          127.0.0.1
-- 서버 버전:                        10.2.8-MariaDB - mariadb.org binary distribution
-- 서버 OS:                        Win64
-- HeidiSQL 버전:                  9.4.0.5125
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- 함수 4leaf.fnc_AddItem 구조 내보내기
DROP FUNCTION IF EXISTS `fnc_AddItem`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `fnc_AddItem`(
	inAccountID VARCHAR(30),
	inOrder INT,
	inIndex INT,
	inShopType INT) RETURNS tinyint(1)
BEGIN

	SELECT f_UID INTO @UID
	FROM tbl_User
	WHERE f_ID = inAccountID;

	INSERT INTO tbl_Inven(f_UID, f_Order, f_Index, f_Type)
	VALUES(@UID, inOrder, inIndex, inShopType);

	IF EXISTS (SELECT 1 FROM tbl_Inven WHERE f_UID = @UID) THEN
		/*IF inShopType = 3 THEN
			UPDATE tbl_CardInfo SET f_Quantity = f_Quantity - 1
			WHERE f_Index = inIndex;
		END IF;*/

		RETURN true;
	END IF;

	RETURN false;
END//
DELIMITER ;

-- 함수 4leaf.fnc_SubItem 구조 내보내기
DROP FUNCTION IF EXISTS `fnc_SubItem`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `fnc_SubItem`(
	inAccountID VARCHAR(30),
	inOrder INT,
	inIndex INT
) RETURNS tinyint(1)
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
END//
DELIMITER ;

-- 프로시저 4leaf.sp_BuyCard 구조 내보내기
DROP PROCEDURE IF EXISTS `sp_BuyCard`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_BuyCard`(inAccountID VARCHAR(30), inOrder INT, inItemIndex INT)
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
END//
DELIMITER ;

-- 프로시저 4leaf.sp_BuyItem 구조 내보내기
DROP PROCEDURE IF EXISTS `sp_BuyItem`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_BuyItem`(
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
END//
DELIMITER ;

-- 프로시저 4leaf.sp_CheckAccountID 구조 내보내기
DROP PROCEDURE IF EXISTS `sp_CheckAccountID`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_CheckAccountID`(
	IN `inAccountID` VARCHAR(30),
	OUT `outCheck` int
)
BEGIN
	SELECT IF(EXISTS(SELECT 1 FROM tbl_User WHERE f_ID = inAccountID), 1, 0) INTO outCheck;
END//
DELIMITER ;

-- 프로시저 4leaf.sp_CreateAccount 구조 내보내기
DROP PROCEDURE IF EXISTS `sp_CreateAccount`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_CreateAccount`(
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
END//
DELIMITER ;

-- 프로시저 4leaf.sp_CreateAvatar 구조 내보내기
DROP PROCEDURE IF EXISTS `sp_CreateAvatar`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_CreateAvatar`(
	IN inAccountID VARCHAR(30),
	IN inCharacterType INT,
	IN inCharacterName VARCHAR(30))
BEGIN
	IF inCharacterType = 0 THEN
		SET @BodyBack = 2;
		SET @BodyFront = 22;
		SET @Hair = 484;
		SET @Clothes = 1004;
		SET @Pants = 1005;
		SET @Shoes = 1006;
	ELSEIF inCharacterType = 1 THEN
		SET @BodyBack = 2;
		SET @BodyFront = 55;
		SET @Hair = 485;
		SET @Clothes = 1004;
		SET @Pants = 1005;
		SET @Shoes = 1006;
	ELSEIF inCharacterType = 2 THEN
		SET @BodyBack = 2;
		SET @BodyFront = 88;
		SET @Hair = 486;
		SET @Clothes = 1004;
		SET @Pants = 1005;
		SET @Shoes = 1006;
	ELSEIF inCharacterType = 3 THEN
		SET @BodyBack = 2;
		SET @BodyFront = 121;
		SET @Hair = 487;
		SET @Clothes = 1004;
		SET @Pants = 1005;
		SET @Shoes = 1006;
	ELSEIF inCharacterType = 4 THEN
		SET @BodyBack = 2;
		SET @BodyFront = 187;
		SET @Hair = 488;
		SET @Clothes = 1004;
		SET @Pants = 1005;
		SET @Shoes = 1006;
	ELSEIF inCharacterType = 5 THEN
		SET @BodyBack = 2;
		SET @BodyFront = 220;
		SET @Hair = 489;
		SET @Clothes = 1004;
		SET @Pants = 1005;
		SET @Shoes = 1006;
	ELSEIF inCharacterType = 6 THEN
		SET @BodyBack = 2;
		SET @BodyFront = 2;
		SET @Hair = 490;
		SET @Clothes = 1004;
		SET @Pants = 1005;
		SET @Shoes = 1006;
	ELSEIF inCharacterType = 128 THEN
		SET @BodyBack = 3;
		SET @BodyFront = 253;
		SET @Hair = 491;
		SET @Clothes = 1007;
		SET @Pants = 1008;
		SET @Shoes = 1009;
	ELSEIF inCharacterType = 129 THEN
		SET @BodyBack = 3;
		SET @BodyFront = 286;
		SET @Hair = 492;
		SET @Clothes = 1007;
		SET @Pants = 1008;
		SET @Shoes = 1009;
	ELSEIF inCharacterType = 130 THEN
		SET @BodyBack = 3;
		SET @BodyFront = 319;
		SET @Hair = 493;
		SET @Clothes = 1007;
		SET @Pants = 1008;
		SET @Shoes = 1009;
	ELSEIF inCharacterType = 131 THEN
		SET @BodyBack = 3;
		SET @BodyFront = 352;
		SET @Hair = 494;
		SET @Clothes = 1007;
		SET @Pants = 1008;
		SET @Shoes = 1009;
	ELSEIF inCharacterType = 132 THEN
		SET @BodyBack = 3;
		SET @BodyFront = 385;
		SET @Hair = 495;
		SET @Clothes = 1007;
		SET @Pants = 1008;
		SET @Shoes = 1009;
	ELSEIF inCharacterType = 133 THEN
		SET @BodyBack = 3;
		SET @BodyFront = 418;
		SET @Hair = 496;
		SET @Clothes = 1007;
		SET @Pants = 1008;
		SET @Shoes = 1009;
	ELSEIF inCharacterType = 134 THEN
		SET @BodyBack = 3;
		SET @BodyFront = 451;
		SET @Hair = 497;
		SET @Clothes = 1007;
		SET @Pants = 1008;
		SET @Shoes = 1009;
	END IF;

	SET @UID = 0;
	SET @AvatarCount = 0;

	SELECT f_UID INTO @UID
	FROM tbl_User
	WHERE f_ID = inAccountID;

	SELECT COUNT(f_UID) INTO @AvatarCount
	FROM tbl_Avatar
	WHERE f_UID = @UID;

	IF @UID > 0 THEN
	BEGIN
		INSERT INTO tbl_Avatar(f_UID, f_Order, f_CID, f_Name, f_BodyBack, f_BodyFront, f_Hair, f_Clothes, f_Pants, f_Shoes)
		VALUES(@UID, @AvatarCount, inCharacterType, inCharacterName, @BodyBack, @BodyFront, @Hair, @Clothes, @Pants, @Shoes);

		SELECT f_Order AS 'Order', f_CID AS CID, f_Name AS Name, f_Knight AS Knight,
			f_GP AS GP, f_FP AS FP,
			f_Hair AS Hair, f_HairAcc AS HairAcc,
			f_Clothes AS Clothes, f_Clothes2 AS Clothes2, f_Clothes3 AS Clothes3,
			f_Pants AS Pants, f_Pants2 AS Pants2, f_Pants3 AS Pants3,
			f_Weapone AS Weapone, f_Weapone2 AS Weapone2, f_Weapone3 AS Weapone3,
			f_Acc1 AS Acc1, f_Acc2 AS Acc2, f_Acc3 AS Acc3, f_Acc4 AS Acc4, f_Acc5 AS Acc5
		FROM tbl_Avatar
		WHERE f_UID = @UID;
	END; END IF;

END//
DELIMITER ;

-- 프로시저 4leaf.sp_DailyGP 구조 내보내기
DROP PROCEDURE IF EXISTS `sp_DailyGP`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_DailyGP`(
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
END//
DELIMITER ;

-- 프로시저 4leaf.sp_GetAvatar 구조 내보내기
DROP PROCEDURE IF EXISTS `sp_GetAvatar`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetAvatar`(inAccountID VARCHAR(30))
BEGIN
	SELECT f_Order AS 'Order', f_CID AS CID, f_Name AS Name, f_Knight AS Knight,
		f_GP AS GP, f_FP AS FP,
		f_Hair AS Hair, f_HairAcc AS HairAcc,
		f_Clothes AS Clothes, f_Clothes2 AS Clothes2, f_Clothes3 AS Clothes3,
		f_Pants AS Pants, f_Pants2 AS Pants2, f_Pants3 AS Pants3,
		f_Weapone AS Weapone, f_Weapone2 AS Weapone2, f_Weapone3 AS Weapone3,
		f_Acc1 AS Acc1, f_Acc2 AS Acc2, f_Acc3 AS Acc3, f_Acc4 AS Acc4, f_Acc5 AS Acc5
	FROM tbl_Avatar
	WHERE f_UID = (SELECT f_UID FROM tbl_User	WHERE f_ID = inAccountID);
END//
DELIMITER ;

-- 프로시저 4leaf.sp_GetAvatarCount 구조 내보내기
DROP PROCEDURE IF EXISTS `sp_GetAvatarCount`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetAvatarCount`(
	inAccountID VARCHAR(30),
	OUT outAvatarCount INT
)
BEGIN
	SET outAvatarCount = 0;

	SELECT COUNT(F_UID) INTO outAvatarCount
	FROM tbl_Avatar
	WHERE f_UID = (SELECT f_UID FROM tbl_User WHERE f_ID = inAccountID);
END//
DELIMITER ;

-- 프로시저 4leaf.sp_GetInven 구조 내보내기
DROP PROCEDURE IF EXISTS `sp_GetInven`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetInven`(
	IN `inAccountID` VARCHAR(30),
	IN `inOrder` INT
)
BEGIN
	SELECT f_UID AS 'UID', f_Index AS 'ItemIndex', f_Type AS 'Type'
	FROM tbl_Inven
	WHERE f_UID = (SELECT f_UID FROM tbl_User WHERE f_ID = inAccountID);
END//
DELIMITER ;

-- 프로시저 4leaf.sp_GetLeafData 구조 내보내기
DROP PROCEDURE IF EXISTS `sp_GetLeafData`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetLeafData`()
BEGIN

	SELECT f_TID, f_Index, f_Type, f_Series, f_Name, f_Mount, f_Sex,
	f_BuyPrice, f_SellPrice, f_Store
	FROM tbl_ItemInfo
	WHERE f_Store != 'None';

	SELECT f_CID, f_Index, f_Type, f_Rank, f_Name, f_Skill, f_Ability,
	f_BuyPrice, f_SellPrice, f_Quantity
	FROM tbl_CardInfo;
	
END//
DELIMITER ;

-- 프로시저 4leaf.sp_Login 구조 내보내기
DROP PROCEDURE IF EXISTS `sp_Login`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Login`(
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

		SELECT f_Order AS 'Order', f_CID AS CID, f_Name AS Name, f_Knight AS Knight,
			f_GP AS GP, f_FP AS FP,
			f_Hair AS Hair, f_HairAcc AS HairAcc,
			f_Clothes AS Clothes, f_Clothes2 AS Clothes2, f_Clothes3 AS Clothes3,
			f_Pants AS Pants, f_Pants2 AS Pants2, f_Pants3 AS Pants3,
			f_Weapone AS Weapone, f_Weapone2 AS Weapone2, f_Weapone3 AS Weapone3,
			f_Acc1 AS Acc1, f_Acc2 AS Acc2, f_Acc3 AS Acc3, f_Acc4 AS Acc4,
			f_Acc5 AS Acc5, f_Acc6 AS Acc6, f_Acc7 AS Acc7, f_Acc8 AS Acc8
		FROM tbl_Avatar
		WHERE f_UID = @UID;
	END IF;
END//
DELIMITER ;

-- 프로시저 4leaf.sp_SellItem 구조 내보내기
DROP PROCEDURE IF EXISTS `sp_SellItem`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_SellItem`(
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

	SELECT f_SellPrice INTO @SellPrice
	FROM tbl_ItemInfo
	WHERE f_Index = inItemIndex;

	IF fnc_SubItem(inAccountID, inOrder, inItemIndex) = true THEN
	BEGIN
		UPDATE tbl_Avatar SET f_GP = f_GP + @SellPrice
		WHERE f_UID = @UID AND f_Order = inOrder;

		SET RetVal = true;
	END; END IF;
END//
DELIMITER ;

-- 프로시저 4leaf.sp_UpdateCostume 구조 내보내기
DROP PROCEDURE IF EXISTS `sp_UpdateCostume`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_UpdateCostume`(
	IN `inAccountID` VARCHAR(30),
	IN `inOrder` INT,
	IN `inHair` INT,
	IN `inHairAcc` INT,
	IN `inClothes` INT,
	IN `inClothes2` INT,
	IN `inClothes3` INT,
	IN `inPants` INT,
	IN `inPants2` INT,
	IN `inPants3` INT,
	IN `inShoes` INT,
	IN `inWeapone` INT,
	IN `inWeapone2` INT,
	IN `inWeapone3` INT,
	IN `inAcc1` INT,
	IN `inAcc2` INT,
	IN `inAcc3` INT,
	IN `inAcc4` INT,
	IN `inAcc5` INT,
	IN `inAcc6` INT,
	IN `inAcc7` INT,
	IN `inAcc8` INT,
	OUT RetVal BOOL
)
BEGIN

	SET @RetVal = false;

	UPDATE tbl_Avatar SET f_Hair = inHair, f_HairAcc = inHairAcc,
		f_Clothes = inClothes, f_Clothes2 = inClothes2, f_Clothes3 = inClothes3,
		f_Pants = inPants, f_Pants2 = inPants2, f_Pants3 = inPants3, 
		f_Shoes = inShoes, f_Weapone = inWeapone, f_Weapone2 = inWeapone2, f_Weapone3 = inWeapone3,
		f_Acc1 = inAcc1, f_Acc2 = inAcc2, f_Acc3 = inAcc3, f_Acc4 = inAcc4,
		f_Acc5 = inAcc5, f_Acc6 = inAcc6, f_Acc7 = inAcc7, f_Acc8 = inAcc8
	WHERE f_UID = (SELECT f_UID FROM tbl_User	WHERE f_ID = inAccountID)
		AND f_Order = inOrder;

	SET @RetVal = true;
	
END//
DELIMITER ;

-- 테이블 4leaf.tbl_avatar 구조 내보내기
DROP TABLE IF EXISTS `tbl_avatar`;
CREATE TABLE IF NOT EXISTS `tbl_avatar` (
  `f_UID` bigint(20) unsigned NOT NULL,
  `f_Order` tinyint(4) NOT NULL,
  `f_CID` int(11) unsigned NOT NULL,
  `f_Name` varchar(30) COLLATE utf8_bin NOT NULL,
  `f_Knight` varchar(30) COLLATE utf8_bin NOT NULL DEFAULT '_',
  `f_GP` int(11) unsigned NOT NULL DEFAULT 0,
  `f_FP` int(11) unsigned NOT NULL DEFAULT 0,
  `f_BodyBack` smallint(6) unsigned NOT NULL DEFAULT 0,
  `f_BodyFront` smallint(6) unsigned NOT NULL DEFAULT 0,
  `f_Hair` smallint(6) unsigned NOT NULL DEFAULT 0,
  `f_HairAcc` smallint(6) unsigned NOT NULL DEFAULT 0,
  `f_Clothes` smallint(6) unsigned NOT NULL DEFAULT 0,
  `f_Clothes2` smallint(6) unsigned NOT NULL DEFAULT 0,
  `f_Clothes3` smallint(6) unsigned NOT NULL DEFAULT 0,
  `f_Pants` smallint(6) unsigned NOT NULL DEFAULT 0,
  `f_Pants2` smallint(6) unsigned NOT NULL DEFAULT 0,
  `f_Pants3` smallint(6) unsigned NOT NULL DEFAULT 0,
  `f_Shoes` smallint(6) unsigned NOT NULL DEFAULT 0,
  `f_Weapone` smallint(6) unsigned NOT NULL DEFAULT 0,
  `f_Weapone2` smallint(6) unsigned NOT NULL DEFAULT 0,
  `f_Weapone3` smallint(6) unsigned NOT NULL DEFAULT 0,
  `f_Acc1` smallint(6) unsigned NOT NULL DEFAULT 0,
  `f_Acc2` smallint(6) unsigned NOT NULL DEFAULT 0,
  `f_Acc3` smallint(6) unsigned NOT NULL DEFAULT 0,
  `f_Acc4` smallint(6) unsigned NOT NULL DEFAULT 0,
  `f_Acc5` smallint(6) unsigned NOT NULL DEFAULT 0,
  `f_Acc6` smallint(6) unsigned NOT NULL DEFAULT 0,
  `f_Acc7` smallint(6) unsigned NOT NULL DEFAULT 0,
  `f_Acc8` smallint(6) unsigned NOT NULL DEFAULT 0,
  UNIQUE KEY `NameUnique` (`f_Name`),
  KEY `UIDIndex` (`f_UID`,`f_Order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- 테이블 데이터 4leaf.tbl_avatar:~0 rows (대략적) 내보내기
DELETE FROM `tbl_avatar`;
/*!40000 ALTER TABLE `tbl_avatar` DISABLE KEYS */;
INSERT INTO `tbl_avatar` (`f_UID`, `f_Order`, `f_CID`, `f_Name`, `f_Knight`, `f_GP`, `f_FP`, `f_BodyBack`, `f_BodyFront`, `f_Hair`, `f_HairAcc`, `f_Clothes`, `f_Clothes2`, `f_Clothes3`, `f_Pants`, `f_Pants2`, `f_Pants3`, `f_Shoes`, `f_Weapone`, `f_Weapone2`, `f_Weapone3`, `f_Acc1`, `f_Acc2`, `f_Acc3`, `f_Acc4`, `f_Acc5`, `f_Acc6`, `f_Acc7`, `f_Acc8`) VALUES
	(1, 0, 3, 'NightStorm00', '_', 12150, 850, 2, 121, 1179, 0, 1108, 1110, 0, 1109, 0, 0, 1116, 1118, 1185, 1189, 1111, 1112, 1113, 1114, 1115, 921, 0, 0);
/*!40000 ALTER TABLE `tbl_avatar` ENABLE KEYS */;

-- 테이블 4leaf.tbl_cardinfo 구조 내보내기
DROP TABLE IF EXISTS `tbl_cardinfo`;
CREATE TABLE IF NOT EXISTS `tbl_cardinfo` (
  `f_CID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `f_Index` int(11) unsigned NOT NULL,
  `f_Type` tinyint(3) unsigned NOT NULL,
  `f_Rank` varchar(20) COLLATE utf8_bin NOT NULL,
  `f_Name` varchar(50) COLLATE utf8_bin NOT NULL,
  `f_Skill` varchar(20) COLLATE utf8_bin NOT NULL,
  `f_Ability` varchar(50) COLLATE utf8_bin NOT NULL,
  `f_BuyPrice` int(10) unsigned NOT NULL DEFAULT 0,
  `f_SellPrice` int(10) unsigned NOT NULL DEFAULT 0,
  `f_Quantity` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`f_CID`),
  KEY `CardIndex` (`f_Index`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- 테이블 데이터 4leaf.tbl_cardinfo:~98 rows (대략적) 내보내기
DELETE FROM `tbl_cardinfo`;
/*!40000 ALTER TABLE `tbl_cardinfo` DISABLE KEYS */;
INSERT INTO `tbl_cardinfo` (`f_CID`, `f_Index`, `f_Type`, `f_Rank`, `f_Name`, `f_Skill`, `f_Ability`, `f_BuyPrice`, `f_SellPrice`, `f_Quantity`) VALUES
	(1, 1, 3, 'Valuable', '기파랑', '지력 A', '1턴간 Int+4', 4100, 2050, 100),
	(2, 2, 3, 'Normal', '노포크', '이동 C', '3턴간 Move+4', 980, 490, 100),
	(4, 3, 3, 'Normal', '닐라', '공격 C', '3턴간 Attack+4', 1250, 625, 100),
	(5, 4, 3, 'Normal', '라쉬카', '지력 C', '3턴간 Int+2', 980, 490, 100),
	(6, 5, 3, 'Valuable', '록슬리', '공격 A', '1턴간 공격 주사위 +2개', 4000, 2000, 100),
	(7, 6, 3, 'Normal', '롤랑', '방어 B', '2턴간 방어 주사위 +1개', 1500, 750, 100),
	(8, 7, 3, 'Normal', '리슐리외', '공격 B', '2턴간 공격 주사위 +1개', 2100, 1050, 100),
	(9, 8, 3, 'Normal', '마르자나', '공격 B', '2턴간 공격 주사위 +1개', 3800, 1900, 100),
	(10, 9, 3, 'Normal', '마리아애슬린', '이동 B', '2턴간 이동 주사위 +1개', 1580, 790, 100),
	(11, 10, 3, 'Normal', '마법사', '이동 D', '1턴간 Move+4', 80, 40, 100),
	(12, 11, 3, 'Normal', '말콤', '이동 C', '3턴간 Move+4', 1320, 660, 100),
	(13, 12, 3, 'Normal', '무슬림', '이동 D', '1턴간 Move+4', 80, 40, 100),
	(14, 13, 3, 'Normal', '무카파', '방어 B', '2턴간 방어 주사위 +1개', 2230, 1115, 100),
	(15, 14, 3, 'Normal', '바시바조크', '이동 D', '1턴간 Move+4', 50, 25, 100),
	(16, 15, 3, 'Normal', '바이올라', '방어 B', '2턴간 방어 주사위 +1개', 1550, 775, 100),
	(17, 16, 3, 'Normal', '바자', '이동 C', '3턴간 Move+4', 980, 490, 100),
	(18, 17, 3, 'Normal', '발라', '이동 B', '2턴간 이동 주사위 +1개', 2700, 1350, 100),
	(19, 18, 3, 'Valuable', '버몬트', 'Keeper', '2턴간 자신을 몬스터화', 14900, 7450, 100),
	(20, 19, 3, 'Valuable', '벨제부르', '공격 A', '1턴간 공격 주사위 +2개', 7150, 3575, 100),
	(21, 20, 3, 'Normal', '보르스', '공격 C', '3턴간 Attack+4', 1270, 635, 100),
	(22, 21, 3, 'Normal', '사피알딘', '공격 C', '3턴간 Attack+4', 1400, 700, 100),
	(23, 22, 3, 'Valuable', '살라딘', '순간이동', '1~15칸 사이를 랜덤하게 워프', 21500, 10750, 100),
	(24, 23, 3, 'Normal', '샤프리아르', '지력 B', '2턴간 Int+3', 1350, 675, 100),
	(25, 24, 3, 'Normal', '세시', '이동 C', '3턴간 Move+4', 950, 475, 100),
	(26, 25, 3, 'Valuable', '셰라자드', '팀지력+', '팀원들의 지력을 2턴간 +3', 21000, 10500, 100),
	(27, 26, 3, 'Normal', '솔져', '이동 D', '1턴간 Move+4', 50, 25, 100),
	(28, 27, 3, 'Valuable', '시안', '방어 A', '1턴간 방어 주사위 +2개', 6300, 3150, 100),
	(29, 28, 3, 'Normal', '시즈', '이동 B', '2턴간 이동 주사위 +1개', 1900, 950, 100),
	(30, 29, 3, 'Normal', '심넬램버트', '공격 B', '2턴간 공격 주사위 +1개', 1720, 860, 100),
	(31, 30, 3, 'Normal', '아델라이데', '지력 B', '2턴간 Int+3', 1330, 665, 100),
	(32, 31, 3, 'Normal', '아두스베이', '이동 B', '2턴간 이동 주사위 +1개', 1800, 900, 100),
	(33, 32, 3, 'Normal', '알무파샤', '지력 B', '2턴간 Int+3', 2180, 1090, 100),
	(34, 33, 3, 'Normal', '알아샤', '지력 B', '2턴간 Int+3', 1600, 800, 100),
	(35, 34, 3, 'Normal', '알이스파니히', '방어 C', '3턴간 Defend+4', 660, 330, 100),
	(36, 35, 3, 'Normal', '알파라비', '이동 B', '2턴간 이동 주사위 +1개', 1580, 790, 100),
	(37, 36, 3, 'Normal', '알가지', '이동 D', '1턴간 Move+4', 50, 25, 100),
	(38, 37, 3, 'Valuable', '알바티니', '방어 A', '1턴간 방어 주사위 +2개', 5000, 2500, 100),
	(39, 38, 3, 'Valuable', '얀지슈카', '공격 A', '1턴간 공격 주사위 +2개', 3650, 1825, 100),
	(40, 39, 3, 'Normal', '엘핀스톤', '공격 B', '2턴간 공격 주사위 +1개', 2100, 1050, 100),
	(41, 40, 3, 'Normal', '오스만누리파샤', '방어 B', '2턴간 방어 주사위 +1개', 2280, 1140, 100),
	(42, 41, 3, 'Normal', '올리비에', '지력 B', '2턴간 Int+3', 1950, 975, 100),
	(43, 42, 3, 'Normal', '워락', '이동 D', '1턴간 Move+4', 80, 40, 100),
	(44, 43, 3, 'Normal', '이븐사이드', '방어 B', '2턴간 방어 주사위 +1개', 1550, 775, 100),
	(45, 44, 3, 'Normal', '이븐시나', '공격 B', '2턴간 공격 주사위 +1개', 2100, 1050, 100),
	(46, 45, 3, 'Normal', '이슈탈', '방어 C', '3턴간 Defend+4', 750, 375, 100),
	(47, 46, 3, 'Normal', '자바카스', '방어 C', '3턴간 Defend+4', 830, 415, 100),
	(48, 47, 3, 'Normal', '제국나이트', '이동 D', '1턴간 Move+4', 50, 25, 100),
	(49, 48, 3, 'Valuable', '죠안', '이동 A', '1턴간 이동 주사위 +2개', 5100, 2550, 100),
	(50, 49, 3, 'Normal', '죠엘', '공격 B', '2턴간 공격 주사위 +1개', 4400, 2200, 100),
	(51, 50, 3, 'Valuable', '지그문트', '이동 A', '1턴간 이동 주사위 +2개', 5200, 2600, 100),
	(52, 51, 3, 'Valuable', '철가면', 'Destroy', '2턴간 공격 주사위 최대값', 18500, 9250, 100),
	(53, 52, 3, 'Normal', '케이트호크', '지력 C', '3턴간 Int+2', 1200, 600, 100),
	(54, 53, 3, 'Normal', '크리스티나', '공격 B', '2턴간 공격 주사위 +1개', 1550, 775, 100),
	(55, 54, 3, 'Valuable', '크리스티앙', 'FreeWarp', '1턴간 1~4칸 자유이동', 18000, 9000, 100),
	(56, 55, 3, 'Normal', '파일럿', '이동 D', '1턴간 Move+4', 50, 25, 100),
	(57, 56, 3, 'Normal', '팬드래건나이트', '이동 D', '1턴간 Move+4', 50, 25, 100),
	(58, 57, 3, 'Valuable', '플랑드르', '이동 A', '1턴간 이동 주사위 +2개', 4400, 2200, 100),
	(59, 58, 3, 'Normal', '헤럴드깁슨', '이동 B', '2턴간 이동 주사위 +1개', 1510, 755, 100),
	(60, 59, 3, 'Normal', '헤이스팅스', '지력 B', '2턴간 Int+3', 2300, 1150, 100),
	(61, 60, 3, 'Valuable', '고렘', 'Raider', '이동중에 마주치는 적과 전투', 10500, 5250, 100),
	(62, 61, 3, 'Valuable', '아지다하카', '오리발', '2턴간 오리발 사용 가능', 7210, 3605, 100),
	(63, 62, 3, 'Normal', '좀비', '짝수저주', '3턴간 짝수 저주', 6800, 3400, 100),
	(64, 63, 3, 'Normal', '해골 병사', '홀수저주', '3턴간 홀수 저주', 6800, 3400, 100),
	(65, 101, 3, 'Normal', '나탈리', '이동 B', '2턴간 이동 주사위 +1개', 3300, 1650, 100),
	(66, 102, 3, 'Normal', '네리샤', '이동 C', '3턴간 Move+4', 1100, 550, 100),
	(67, 103, 3, 'Valuable', '데미안', 'Block', '2턴간 방어 주사위 최대값', 23300, 11650, 100),
	(68, 104, 3, 'Normal', '디에네', '지력 C', '3턴간 Int+2', 900, 450, 100),
	(69, 105, 3, 'Normal', '란', '공격 B', '2턴간 공격 주사위 +1개', 3700, 1850, 100),
	(70, 106, 3, 'Normal', '레드헤드', '방어 B', '2턴간 방어 주사위 +1개', 2000, 1000, 100),
	(71, 107, 3, 'Normal', '루시엔', '지력 B', '2턴간 Int+3', 2100, 1050, 100),
	(72, 108, 3, 'Normal', '루크랜서드', '방어 C', '3턴간 Defend+4', 1400, 700, 100),
	(73, 109, 3, 'Normal', '리엔', '방어 B', '2턴간 방어 주사위 +1개', 2150, 1075, 100),
	(74, 110, 3, 'Valuable', '리차드', '지력 A', '1턴간 Int+4', 2880, 1440, 100),
	(75, 111, 3, 'Normal', '마리아', '방어 B', '2턴간 방어 주사위 +1개', 2300, 1150, 100),
	(76, 112, 3, 'Valuable', '베라모드', '이동 A', '1턴간 이동 주사위 +2개', 7300, 3650, 100),
	(77, 113, 3, 'Valuable', '살라딘2', '순간이동', '1~15칸 사이를 랜덤하게 워프', 28500, 14250, 100),
	(78, 114, 3, 'Normal', '손나딘', '방어 B', '2턴간 방어 주사위 +1개', 1850, 925, 100),
	(79, 115, 3, 'Normal', '아만딘', '방어 C', '3턴간 Defend+4', 1150, 575, 100),
	(80, 116, 3, 'Normal', '아셀라스', '지력 B', '2턴간 Int+3', 1720, 860, 100),
	(81, 117, 3, 'Valuable', '아슈레이', '공격 A', '1턴간 공격 주사위 +2개', 8200, 4100, 100),
	(82, 118, 3, 'Valuable', '엠블라', '방어 A', '1턴간 방어 주사위 +2개', 5500, 2750, 100),
	(83, 119, 3, 'Valuable', '죠안2', '지력 A', '1턴간 Int+4', 6850, 3425, 100),
	(84, 120, 3, 'Normal', '쥬디', '공격 B', '2턴간 공격 주사위 +1개', 3800, 1900, 100),
	(85, 121, 3, 'Normal', '슈', '이동 C', '3턴간 Move+4', 1600, 800, 100),
	(86, 122, 3, 'Valuable', '카를로스', '이동 A', '1턴간 이동 주사위 +2개', 6100, 3050, 100),
	(87, 123, 3, 'Valuable', '크리스티앙2', 'Free Warp', '1턴간 1~4칸 자유이동', 20200, 10100, 100),
	(88, 124, 3, 'Normal', '프라이오스', '방어 B', '2턴간 방어 주사위 +1개', 9750, 4875, 100),
	(89, 125, 3, 'Valuable', '강화병', '자폭', '상대방과 함께 자폭', 5000, 2500, 100),
	(90, 126, 3, 'Valuable', '루칼드', '체인지', '2턴간 체인지 사용 가능', 6120, 3060, 100),
	(91, 127, 3, 'Valuable', '바룬', '어빌리티 -50', '어빌리티 50% 감소', 6150, 3075, 100),
	(92, 128, 3, 'Valuable', '엘더마스터', '자폭', '상대방과 함께 자폭', 6650, 3325, 100),
	(93, 129, 3, 'Valuable', '제이슨', '발키리', '2턴간 발키리의 창 사용 가능', 8730, 4365, 100),
	(94, 130, 3, 'Valuable', '켄', '아마게돈', '모든 체스맨의 능력치 1/2', 7400, 3700, 100),
	(95, 131, 3, 'Valuable', '팬텀 데미안', 'Peace', '3턴간 플레이어와 전투 회피', 28500, 14250, 100),
	(96, 132, 3, 'Valuable', '팬텀 마리아', '신의 저주', '저주 타일로 만듬', 22850, 11425, 100),
	(97, 133, 3, 'Valuable', '팬텀 유진', '키퍼 C', 'C급 몬스터 소환', 21300, 10650, 100),
	(98, 134, 3, 'Valuable', '하이델룬', 'ExWarp', '1턴간 1~6칸 자유이동', 24500, 12250, 100),
	(99, 135, 3, 'Valuable', '흑태자', 'GS', '2턴/1턴, 공격/방어 최대값', 250000, 125000, 100);
/*!40000 ALTER TABLE `tbl_cardinfo` ENABLE KEYS */;

-- 테이블 4leaf.tbl_equipment 구조 내보내기
DROP TABLE IF EXISTS `tbl_equipment`;
CREATE TABLE IF NOT EXISTS `tbl_equipment` (
  `f_UID` bigint(20) DEFAULT NULL,
  `f_Order` tinyint(4) unsigned NOT NULL,
  `f_equipId` smallint(6) unsigned NOT NULL,
  `f_Mount` tinyint(3) unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- 테이블 데이터 4leaf.tbl_equipment:~0 rows (대략적) 내보내기
DELETE FROM `tbl_equipment`;
/*!40000 ALTER TABLE `tbl_equipment` DISABLE KEYS */;
INSERT INTO `tbl_equipment` (`f_UID`, `f_Order`, `f_equipId`, `f_Mount`) VALUES
	(1, 0, 2, 1),
	(1, 0, 121, 2),
	(1, 0, 921, 9),
	(1, 0, 1108, 5),
	(1, 0, 1109, 6),
	(1, 0, 1110, 5),
	(1, 0, 1111, 9),
	(1, 0, 1112, 9),
	(1, 0, 1113, 9),
	(1, 0, 1114, 9),
	(1, 0, 1115, 9),
	(1, 0, 1116, 7),
	(1, 0, 1118, 8),
	(1, 0, 1179, 3),
	(1, 0, 1185, 8),
	(1, 0, 1189, 8);
/*!40000 ALTER TABLE `tbl_equipment` ENABLE KEYS */;

-- 테이블 4leaf.tbl_inven 구조 내보내기
DROP TABLE IF EXISTS `tbl_inven`;
CREATE TABLE IF NOT EXISTS `tbl_inven` (
  `f_UID` bigint(20) unsigned NOT NULL,
  `f_Order` tinyint(3) unsigned NOT NULL,
  `f_Index` int(10) unsigned NOT NULL,
  `f_Type` tinyint(3) unsigned NOT NULL,
  KEY `UID` (`f_UID`,`f_Order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- 테이블 데이터 4leaf.tbl_inven:~19 rows (대략적) 내보내기
DELETE FROM `tbl_inven`;
/*!40000 ALTER TABLE `tbl_inven` DISABLE KEYS */;
INSERT INTO `tbl_inven` (`f_UID`, `f_Order`, `f_Index`, `f_Type`) VALUES
	(1, 0, 1004, 1),
	(1, 0, 1005, 1),
	(1, 0, 1006, 1),
	(1, 0, 1108, 1),
	(1, 0, 1109, 1),
	(1, 0, 1110, 1),
	(1, 0, 1111, 1),
	(1, 0, 1112, 1),
	(1, 0, 1113, 1),
	(1, 0, 1114, 1),
	(1, 0, 1115, 1),
	(1, 0, 1116, 1),
	(1, 0, 1117, 1),
	(1, 0, 1118, 1),
	(1, 0, 1179, 1),
	(1, 0, 1185, 1),
	(1, 0, 1189, 1),
	(1, 0, 921, 1),
	(1, 0, 1026, 1);
/*!40000 ALTER TABLE `tbl_inven` ENABLE KEYS */;

-- 테이블 4leaf.tbl_iteminfo 구조 내보내기
DROP TABLE IF EXISTS `tbl_iteminfo`;
CREATE TABLE IF NOT EXISTS `tbl_iteminfo` (
  `f_TID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `f_Index` int(11) unsigned NOT NULL,
  `f_Type` int(11) unsigned NOT NULL,
  `f_Series` varchar(50) COLLATE utf8_bin NOT NULL,
  `f_Name` varchar(50) COLLATE utf8_bin NOT NULL,
  `f_Mount` tinyint(4) unsigned NOT NULL,
  `f_Sex` tinyint(4) unsigned NOT NULL,
  `f_BuyPrice` int(11) unsigned NOT NULL DEFAULT 0,
  `f_SellPrice` int(11) unsigned NOT NULL DEFAULT 0,
  `f_Store` varchar(50) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`f_TID`),
  KEY `ItemIndex` (`f_Index`)
) ENGINE=InnoDB AUTO_INCREMENT=984 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- 테이블 데이터 4leaf.tbl_iteminfo:~983 rows (대략적) 내보내기
DELETE FROM `tbl_iteminfo`;
/*!40000 ALTER TABLE `tbl_iteminfo` DISABLE KEYS */;
INSERT INTO `tbl_iteminfo` (`f_TID`, `f_Index`, `f_Type`, `f_Series`, `f_Name`, `f_Mount`, `f_Sex`, `f_BuyPrice`, `f_SellPrice`, `f_Store`) VALUES
	(1, 1, 1, 'None', '그림자', 1, 0, 0, 0, 'None'),
	(2, 2, 1, 'None', '남자 몸', 1, 1, 0, 0, 'None'),
	(3, 3, 1, 'None', '여자 몸', 1, 2, 0, 0, 'None'),
	(4, 4, 1, 'None', '레이 몸', 1, 0, 0, 0, 'None'),
	(5, 5, 1, 'None', '마네킨 남', 1, 1, 0, 0, 'None'),
	(6, 6, 1, 'None', '마네킨 여', 1, 2, 0, 0, 'None'),
	(7, 7, 1, 'None', '남자 몸 썬텐', 1, 1, 0, 0, 'None'),
	(8, 8, 1, 'None', '여자 몸 썬텐', 1, 2, 0, 0, 'None'),
	(9, 9, 1, 'None', '레이 몸 썬텐', 1, 0, 0, 0, 'None'),
	(10, 10, 1, 'None', '무효 아이템', 1, 0, 0, 0, 'None'),
	(11, 11, 1, 'None', '무효 아이템', 1, 0, 0, 0, 'None'),
	(12, 12, 1, 'None', '무효 아이템', 1, 0, 0, 0, 'None'),
	(13, 13, 1, 'None', '무효 아이템', 1, 0, 0, 0, 'None'),
	(14, 14, 1, 'None', '무효 아이템', 1, 0, 0, 0, 'None'),
	(15, 15, 1, 'None', '무효 아이템', 1, 0, 0, 0, 'None'),
	(16, 16, 1, 'None', '무효 아이템', 1, 0, 0, 0, 'None'),
	(17, 17, 1, 'None', '무효 아이템', 1, 0, 0, 0, 'None'),
	(18, 18, 1, 'None', '무효 아이템', 1, 0, 0, 0, 'None'),
	(19, 19, 1, 'None', '무효 아이템', 1, 0, 0, 0, 'None'),
	(20, 20, 1, 'None', '무효 아이템', 1, 0, 0, 0, 'None'),
	(21, 21, 1, 'None', '무효 아이템', 1, 0, 0, 0, 'None'),
	(22, 22, 1, 'None', '루시안 그냥', 2, 1, 0, 0, 'None'),
	(23, 55, 1, 'None', '조슈아 그냥', 2, 1, 0, 0, 'None'),
	(24, 88, 1, 'None', '막시민 그냥', 2, 1, 0, 0, 'None'),
	(25, 121, 1, 'None', '보리스 그냥', 2, 1, 0, 0, 'None'),
	(26, 154, 1, 'None', '란지에 그냥', 2, 1, 0, 0, 'None'),
	(27, 187, 1, 'None', '시벨린 그냥', 2, 1, 0, 0, 'None'),
	(28, 220, 1, 'None', '이자크 그냥', 2, 1, 0, 0, 'None'),
	(29, 253, 1, 'None', '이스핀 그냥', 2, 2, 0, 0, 'None'),
	(30, 286, 1, 'None', '티치엘 그냥', 2, 2, 0, 0, 'None'),
	(31, 319, 1, 'None', '클로에 그냥', 2, 2, 0, 0, 'None'),
	(32, 352, 1, 'None', '레이 그냥', 2, 2, 0, 0, 'None'),
	(33, 385, 1, 'None', '아나이스 그냥', 2, 2, 0, 0, 'None'),
	(34, 418, 1, 'None', '밀라 그냥', 2, 2, 0, 0, 'None'),
	(35, 451, 1, 'None', '벤야 그냥', 2, 2, 0, 0, 'None'),
	(36, 483, 1, 'None', '벤야 기타3', 2, 2, 0, 0, 'None'),
	(37, 484, 1, 'Original', '루시안 머리', 3, 1, 30000, 15000, 'HairShop'),
	(38, 485, 1, 'Original', '조슈아 머리', 3, 1, 30000, 15000, 'HairShop'),
	(39, 486, 1, 'Original', '막시민 머리', 3, 1, 30000, 15000, 'HairShop'),
	(40, 487, 1, 'Original', '보리스 머리', 3, 1, 30000, 15000, 'HairShop'),
	(41, 488, 1, 'Original', '란지에 머리', 3, 1, 30000, 15000, 'HairShop'),
	(42, 489, 1, 'Original', '시벨린 머리', 3, 1, 30000, 15000, 'HairShop'),
	(43, 490, 1, 'Original', '이자크 머리', 3, 1, 30000, 15000, 'HairShop'),
	(44, 491, 1, 'Original', '이스핀 머리', 3, 2, 30000, 15000, 'HairShop'),
	(45, 492, 1, 'Original', '티치엘 머리', 3, 2, 30000, 15000, 'HairShop'),
	(46, 493, 1, 'Original', '클로에 머리', 3, 2, 30000, 15000, 'HairShop'),
	(47, 494, 1, 'Original', '레이 머리', 3, 2, 30000, 15000, 'HairShop'),
	(48, 495, 1, 'Original', '아나이스 머리', 3, 2, 30000, 15000, 'HairShop'),
	(49, 496, 1, 'Original', '밀라 머리', 3, 2, 30000, 15000, 'HairShop'),
	(50, 497, 1, 'Original', '벤야 머리', 3, 2, 30000, 15000, 'HairShop'),
	(51, 498, 1, 'None', '교복(동) 와이셔츠', 5, 1, 0, 0, 'None'),
	(52, 499, 1, 'None', '교복(동) 바지', 6, 1, 0, 0, 'None'),
	(53, 500, 1, 'None', '교복(동) 조끼', 5, 1, 0, 0, 'None'),
	(54, 501, 1, 'None', '교복(동) 구두', 7, 1, 0, 0, 'None'),
	(55, 502, 1, 'None', '교복(동) 재킷', 5, 1, 0, 0, 'None'),
	(56, 503, 1, 'None', '교복(동) 블라우스', 5, 2, 0, 0, 'None'),
	(57, 504, 1, 'None', '교복(동) 치마', 6, 2, 0, 0, 'None'),
	(58, 505, 1, 'None', '교복(동) 재킷', 5, 2, 0, 0, 'None'),
	(59, 506, 1, 'None', '교복(동) 양말', 6, 2, 0, 0, 'None'),
	(60, 507, 1, 'None', '교복(동) 구두', 7, 2, 0, 0, 'None'),
	(61, 508, 1, 'None', '교복(동) 조끼', 5, 2, 0, 0, 'None'),
	(62, 509, 1, 'Gray', '드라우프닐 흰수염', 9, 1, 0, 0, 'DressShop'),
	(63, 510, 1, 'Gray', '드라우프닐 옷', 5, 1, 0, 0, 'DressShop'),
	(64, 511, 1, 'Gray', '드라우프닐 가디건', 5, 1, 0, 0, 'DressShop'),
	(65, 512, 1, 'Gray', '드라우프닐 슬리퍼', 7, 1, 0, 0, 'DressShop'),
	(66, 513, 1, 'Gray', '드라우프닐 지팡이', 8, 1, 0, 0, 'DressShop'),
	(67, 514, 1, 'Gray', '드라우프닐 엘프귀', 9, 1, 0, 0, 'DressShop'),
	(68, 515, 1, 'Gray', '카자 윗도리', 5, 2, 0, 0, 'DressShop'),
	(69, 516, 1, 'Gray', '카자 바지', 6, 2, 0, 0, 'DressShop'),
	(70, 517, 1, 'Gray', '카자 신발', 7, 2, 0, 0, 'DressShop'),
	(71, 518, 1, 'Gray', '카자 두건', 4, 2, 0, 0, 'DressShop'),
	(72, 519, 1, 'Gray', '카자 팔찌', 9, 2, 0, 0, 'DressShop'),
	(73, 520, 1, 'Gray', '카자 칼', 8, 2, 0, 0, 'DressShop'),
	(74, 521, 1, 'Gray', '카자 손장식', 9, 2, 0, 0, 'DressShop'),
	(75, 522, 1, 'Gray', '로빈 머리띠', 4, 2, 0, 0, 'DressShop'),
	(76, 523, 1, 'Gray', '로빈 망토', 5, 2, 0, 0, 'DressShop'),
	(77, 524, 1, 'Gray', '로빈 옷', 5, 2, 0, 0, 'DressShop'),
	(78, 525, 1, 'Gray', '로빈 가죽신발', 7, 2, 0, 0, 'DressShop'),
	(79, 526, 1, 'Gray', '로빈 팔찌', 9, 2, 0, 0, 'DressShop'),
	(80, 527, 1, 'Gray', '로빈 칼', 8, 2, 0, 0, 'DressShop'),
	(81, 528, 1, 'Gray', '기쉬네 로브', 5, 1, 0, 0, 'DressShop'),
	(82, 529, 1, 'Gray', '기쉬네 망토', 5, 1, 0, 0, 'DressShop'),
	(83, 530, 1, 'Gray', '기쉬네 지팡이', 8, 1, 0, 0, 'DressShop'),
	(84, 531, 1, 'Gray', '기쉬네 슬리퍼', 7, 1, 0, 0, 'DressShop'),
	(85, 532, 1, 'Gray', '기쉬네 머리띠', 4, 1, 0, 0, 'DressShop'),
	(86, 533, 1, 'Gray', '흑태자 갑옷', 5, 1, 0, 0, 'DressShop'),
	(87, 534, 1, 'Gray', '흑태자 망토', 5, 1, 0, 0, 'DressShop'),
	(88, 535, 1, 'Gray', '흑태자 신발', 7, 1, 0, 0, 'DressShop'),
	(89, 536, 1, 'Gray', '흑태자 장갑', 9, 1, 0, 0, 'DressShop'),
	(90, 537, 1, 'Gray', '흑태자 투구', 4, 1, 0, 0, 'DressShop'),
	(91, 538, 1, 'WestWind', '시라노 망토', 5, 1, 0, 0, 'DressShop'),
	(92, 539, 1, 'WestWind', '시라노 윗도리', 5, 1, 0, 0, 'DressShop'),
	(93, 540, 1, 'WestWind', '시라노 바지', 6, 1, 0, 0, 'DressShop'),
	(94, 541, 1, 'WestWind', '시라노 신발', 7, 1, 0, 0, 'DressShop'),
	(95, 542, 1, 'WestWind', '시라노 바지장식', 9, 1, 0, 0, 'DressShop'),
	(96, 543, 1, 'WestWind', '시라노 장갑', 9, 1, 0, 0, 'DressShop'),
	(97, 544, 1, 'WestWind', '카나 망토', 5, 2, 0, 0, 'DressShop'),
	(98, 545, 1, 'WestWind', '카나 윗도리', 5, 2, 0, 0, 'DressShop'),
	(99, 546, 1, 'WestWind', '카나 치마', 6, 2, 0, 0, 'DressShop'),
	(100, 547, 1, 'WestWind', '카나 칼', 8, 2, 0, 0, 'DressShop'),
	(101, 548, 1, 'WestWind', '카나 손목보호대', 9, 2, 0, 0, 'DressShop'),
	(102, 549, 1, 'WestWind', '카나 신발', 7, 2, 0, 0, 'DressShop'),
	(103, 550, 1, 'WestWind', '체사레 모자', 4, 1, 0, 0, 'DressShop'),
	(104, 551, 1, 'WestWind', '체사레 원피스', 5, 1, 0, 0, 'DressShop'),
	(105, 552, 1, 'WestWind', '체사레 망토', 5, 1, 0, 0, 'DressShop'),
	(106, 553, 1, 'WestWind', '체사레 바지', 9, 1, 0, 0, 'DressShop'),
	(107, 554, 1, 'Tempest', '샤른호스트 외투', 5, 1, 0, 0, 'DressShop'),
	(108, 555, 1, 'Tempest', '샤른호스트 바지', 6, 1, 0, 0, 'DressShop'),
	(109, 556, 1, 'Tempest', '샤른호스트 신발', 7, 1, 0, 0, 'DressShop'),
	(110, 557, 1, 'Tempest', '샤른호스트 장갑', 9, 1, 0, 0, 'DressShop'),
	(111, 558, 1, 'Tempest', '에밀리오 청룡포', 5, 1, 0, 0, 'DressShop'),
	(112, 559, 1, 'Tempest', '에밀리오 깜장고무신', 7, 1, 0, 0, 'DressShop'),
	(113, 560, 1, 'Tempest', '메리 슈츠', 5, 2, 0, 0, 'DressShop'),
	(114, 561, 1, 'Tempest', '메리 망토', 5, 2, 0, 0, 'DressShop'),
	(115, 562, 1, 'Tempest', '메리 머리장식', 4, 2, 0, 0, 'DressShop'),
	(116, 563, 1, 'Tempest', '메리 채찍', 8, 2, 0, 0, 'DressShop'),
	(117, 564, 1, 'Tempest', '메리 부츠', 7, 2, 0, 0, 'DressShop'),
	(118, 565, 1, 'Tempest', '메리 장갑', 9, 2, 0, 0, 'DressShop'),
	(119, 566, 1, 'Tempest', '엘리자베스 분홍드레스', 5, 2, 0, 0, 'DressShop'),
	(120, 567, 1, 'Tempest', '엘리자베스 백구두', 7, 2, 0, 0, 'DressShop'),
	(121, 568, 1, 'Tempest', '엘리자베스 흰장갑', 9, 2, 0, 0, 'DressShop'),
	(122, 569, 1, 'Tempest', '엘리자베스 귀걸이', 9, 2, 0, 0, 'DressShop'),
	(123, 570, 1, 'Tempest', '리나 모자', 4, 2, 0, 0, 'DressShop'),
	(124, 571, 1, 'Tempest', '리나 수녀복', 5, 2, 0, 0, 'DressShop'),
	(125, 572, 1, 'Tempest', '리나 신발', 7, 2, 0, 0, 'DressShop'),
	(126, 573, 1, 'Tempest', '리나 안경', 9, 2, 0, 0, 'DressShop'),
	(127, 574, 1, 'Shivan', '사피알딘 터번', 4, 1, 0, 0, 'DressShop'),
	(128, 575, 1, 'Shivan', '사피알딘 제의(내)', 5, 1, 0, 0, 'DressShop'),
	(129, 576, 1, 'Shivan', '사피알딘 제의(외)', 5, 1, 0, 0, 'DressShop'),
	(130, 577, 1, 'Shivan', '사피알딘 구두', 7, 1, 0, 0, 'DressShop'),
	(131, 578, 1, 'Shivan', '사피알딘 귀걸이', 9, 1, 0, 0, 'DressShop'),
	(132, 579, 1, 'Shivan', '얀지슈카 슈츠', 5, 2, 0, 0, 'DressShop'),
	(133, 580, 1, 'Shivan', '얀지슈카 어깨보호대', 9, 2, 0, 0, 'DressShop'),
	(134, 581, 1, 'Shivan', '얀지슈카 타이즈', 6, 2, 0, 0, 'DressShop'),
	(135, 582, 1, 'Shivan', '얀지슈카 신발', 7, 2, 0, 0, 'DressShop'),
	(136, 583, 1, 'Shivan', '얀지슈카 손목보호대', 9, 2, 0, 0, 'DressShop'),
	(137, 584, 1, 'Shivan', '알아샤 윗도리', 5, 2, 0, 0, 'DressShop'),
	(138, 585, 1, 'Shivan', '알아샤 쫄바지', 6, 2, 0, 0, 'DressShop'),
	(139, 586, 1, 'Shivan', '알아샤 신발', 7, 2, 0, 0, 'DressShop'),
	(140, 587, 1, 'Shivan', '알아샤 손목보호대', 9, 2, 0, 0, 'DressShop'),
	(141, 588, 1, 'Crimson', '롤랑 티셔츠', 5, 1, 0, 0, 'DressShop'),
	(142, 589, 1, 'Crimson', '롤랑 반바지', 6, 1, 0, 0, 'DressShop'),
	(143, 590, 1, 'Crimson', '롤랑 구두', 7, 1, 0, 0, 'DressShop'),
	(144, 591, 1, 'Crimson', '롤랑 머플러', 9, 1, 0, 0, 'DressShop'),
	(145, 592, 1, 'Crimson', '롤랑 팔장식', 9, 1, 0, 0, 'DressShop'),
	(146, 593, 1, 'Crimson', '롤랑 양말', 6, 1, 0, 0, 'DressShop'),
	(147, 594, 1, 'Crimson', '버몬트 재킷', 5, 1, 0, 0, 'DressShop'),
	(148, 595, 1, 'Crimson', '버몬트 바지', 6, 1, 0, 0, 'DressShop'),
	(149, 596, 1, 'Crimson', '버몬트 신발', 7, 1, 0, 0, 'DressShop'),
	(150, 597, 1, 'Crimson', '버몬트 장갑', 9, 1, 0, 0, 'DressShop'),
	(151, 598, 1, 'Crimson', '엘핀스톤 윗도리', 5, 1, 0, 0, 'DressShop'),
	(152, 599, 1, 'Crimson', '엘핀스톤 치마', 6, 1, 0, 0, 'DressShop'),
	(153, 600, 1, 'Crimson', '엘핀스톤 조끼', 5, 1, 0, 0, 'DressShop'),
	(154, 601, 1, 'Crimson', '엘핀스톤 외투', 5, 1, 0, 0, 'DressShop'),
	(155, 602, 1, 'Crimson', '엘핀스톤 신발', 7, 1, 0, 0, 'DressShop'),
	(156, 603, 1, 'Crimson', '엘핀스톤 귀걸이', 9, 1, 0, 0, 'DressShop'),
	(157, 604, 1, 'Crimson', '엘핀스톤 머플러', 9, 1, 0, 0, 'DressShop'),
	(158, 605, 1, 'Crimson', '바이올라 블라우스', 5, 2, 0, 0, 'DressShop'),
	(159, 606, 1, 'Crimson', '바이올라 치마', 6, 2, 0, 0, 'DressShop'),
	(160, 607, 1, 'Crimson', '바이올라 타이즈', 6, 2, 0, 0, 'DressShop'),
	(161, 608, 1, 'Crimson', '바이올라 루즈박스', 6, 2, 0, 0, 'DressShop'),
	(162, 609, 1, 'Crimson', '바이올라 장갑', 9, 2, 0, 0, 'DressShop'),
	(163, 610, 1, 'Crimson', '바이올라 망토', 5, 2, 0, 0, 'DressShop'),
	(164, 611, 1, 'Crimson', '바이올라 구두', 7, 2, 0, 0, 'DressShop'),
	(165, 612, 1, 'Apocalyse', '크리스티앙 윗도리', 5, 1, 0, 0, 'DressShop'),
	(166, 613, 1, 'Apocalyse', '크리스티앙 코드', 5, 1, 0, 0, 'DressShop'),
	(167, 614, 1, 'Apocalyse', '크리스티앙 신발', 7, 1, 0, 0, 'DressShop'),
	(168, 615, 1, 'Apocalyse', '크리스티나 모자', 4, 2, 0, 0, 'DressShop'),
	(169, 616, 1, 'Apocalyse', '크리스티나 블라우스', 5, 2, 0, 0, 'DressShop'),
	(170, 617, 1, 'Apocalyse', '크리스티나 치마', 6, 2, 0, 0, 'DressShop'),
	(171, 618, 1, 'Apocalyse', '크리스티나 망토', 5, 2, 0, 0, 'DressShop'),
	(172, 619, 1, 'Apocalyse', '크리스티나 귀걸이', 9, 2, 0, 0, 'DressShop'),
	(173, 620, 1, 'Apocalyse', '크리스티나 장갑', 9, 2, 0, 0, 'DressShop'),
	(174, 621, 1, 'Apocalyse', '크리스티나 신발', 7, 2, 0, 0, 'DressShop'),
	(175, 622, 1, 'Apocalyse', '알바티니 윗도리', 5, 1, 0, 0, 'DressShop'),
	(176, 623, 1, 'Apocalyse', '알바티니 바지', 6, 1, 0, 0, 'DressShop'),
	(177, 624, 1, 'Apocalyse', '알바티니 스커트', 6, 1, 0, 0, 'DressShop'),
	(178, 625, 1, 'Apocalyse', '알바티니 신발', 7, 1, 0, 0, 'DressShop'),
	(179, 626, 1, 'Apocalyse', '알바티니 어깨보호대', 9, 1, 0, 0, 'DressShop'),
	(180, 627, 1, 'Apocalyse', '알바티니 손목보호대', 9, 1, 0, 0, 'DressShop'),
	(181, 628, 1, 'Apocalyse', '철가면 윗도리', 5, 1, 0, 0, 'DressShop'),
	(182, 629, 1, 'Apocalyse', '철가면 바지', 6, 1, 0, 0, 'DressShop'),
	(183, 630, 1, 'Apocalyse', '철가면 신발', 7, 1, 0, 0, 'DressShop'),
	(184, 631, 1, 'Apocalyse', '철가면 조끼', 5, 1, 0, 0, 'DressShop'),
	(185, 632, 1, 'Apocalyse', '철가면 장갑', 9, 1, 0, 0, 'DressShop'),
	(186, 633, 1, 'Apocalyse', '철가면 망토', 5, 1, 0, 0, 'DressShop'),
	(187, 634, 1, 'Apocalyse', '철가면 허리띠', 9, 1, 0, 0, 'DressShop'),
	(188, 635, 1, 'Fantasy', '전사 쫄티(남)', 5, 1, 0, 0, 'DressShop2'),
	(189, 636, 1, 'Fantasy', '전사 팔찌(남)', 9, 1, 0, 0, 'DressShop2'),
	(190, 637, 1, 'Fantasy', '전사 바지(남)', 6, 1, 0, 0, 'DressShop2'),
	(191, 638, 1, 'Fantasy', '전사 신발(남)', 7, 1, 0, 0, 'DressShop2'),
	(192, 639, 1, 'Fantasy', '전사 머플러(남)', 9, 1, 0, 0, 'DressShop2'),
	(193, 640, 1, 'Fantasy', '전사 쫄티(여)', 5, 2, 0, 0, 'DressShop2'),
	(194, 641, 1, 'Fantasy', '전사 팔찌(여)', 9, 2, 0, 0, 'DressShop2'),
	(195, 642, 1, 'Fantasy', '전사 바지(여)', 6, 2, 0, 0, 'DressShop2'),
	(196, 643, 1, 'Fantasy', '전사 신발(여)', 7, 2, 0, 0, 'DressShop2'),
	(197, 644, 1, 'Fantasy', '전사 팔찌(여)', 9, 2, 0, 0, 'DressShop2'),
	(198, 645, 1, 'Fantasy', '마법사 모자(남)', 4, 1, 0, 0, 'DressShop2'),
	(199, 646, 1, 'Fantasy', '마법사 윗도리(남)', 5, 1, 0, 0, 'DressShop2'),
	(200, 647, 1, 'Fantasy', '마법사 바지(남)', 6, 1, 0, 0, 'DressShop2'),
	(201, 648, 1, 'Fantasy', '마법사 외투(남)', 5, 1, 0, 0, 'DressShop2'),
	(202, 649, 1, 'Fantasy', '마법사 신발(남)', 7, 1, 0, 0, 'DressShop2'),
	(203, 650, 1, 'Fantasy', '마법사 손목보호대(남)', 9, 1, 0, 0, 'DressShop2'),
	(204, 651, 1, 'Fantasy', '마법사 모자(여)', 4, 2, 0, 0, 'DressShop2'),
	(205, 652, 1, 'Fantasy', '마법사 외투(여)', 5, 2, 0, 0, 'DressShop2'),
	(206, 653, 1, 'Fantasy', '마법사 반바지(여)', 6, 2, 0, 0, 'DressShop2'),
	(207, 654, 1, 'Fantasy', '마법사 신발(여)', 7, 2, 0, 0, 'DressShop2'),
	(208, 655, 1, 'Fantasy', '마법사 손목보호대(여)', 9, 2, 0, 0, 'DressShop2'),
	(209, 656, 1, 'Fantasy', '사냥꾼 모자(남)', 4, 1, 0, 0, 'DressShop2'),
	(210, 657, 1, 'Fantasy', '사냥꾼 외투(남)', 5, 1, 0, 0, 'DressShop2'),
	(211, 658, 1, 'Fantasy', '사냥꾼 윗도리(남)', 5, 1, 0, 0, 'DressShop2'),
	(212, 659, 1, 'Fantasy', '사냥꾼 바지(남)', 6, 1, 0, 0, 'DressShop2'),
	(213, 660, 1, 'Fantasy', '사냥꾼 신발(남)', 7, 1, 0, 0, 'DressShop2'),
	(214, 661, 1, 'Fantasy', '사냥꾼 장갑(남)', 9, 1, 0, 0, 'DressShop2'),
	(215, 662, 1, 'Fantasy', '사냥꾼 활과 활통(남)', 8, 1, 0, 0, 'DressShop2'),
	(216, 663, 1, 'Fantasy', '사냥꾼 모자(여)', 4, 2, 0, 0, 'DressShop2'),
	(217, 664, 1, 'Fantasy', '사냥꾼 외투(여)', 5, 2, 0, 0, 'DressShop2'),
	(218, 665, 1, 'Fantasy', '사냥꾼 치마(여)', 6, 2, 0, 0, 'DressShop2'),
	(219, 666, 1, 'Fantasy', '사냥꾼 신발(여)', 7, 2, 0, 0, 'DressShop2'),
	(220, 667, 1, 'Fantasy', '사냥꾼 장갑(여)', 9, 2, 0, 0, 'DressShop2'),
	(221, 668, 1, 'Fantasy', '사냥꾼 활과 활통(여)', 8, 2, 0, 0, 'DressShop2'),
	(222, 669, 1, 'Fantasy', '수도사 수도복(남)', 5, 1, 0, 0, 'DressShop2'),
	(223, 670, 1, 'Fantasy', '수도사 신발(남)', 7, 1, 0, 0, 'DressShop2'),
	(224, 671, 1, 'Fantasy', '수도사 수도복(여)', 5, 2, 0, 0, 'DressShop2'),
	(225, 672, 1, 'Fantasy', '수도사 신발(여)', 7, 2, 0, 0, 'DressShop2'),
	(226, 673, 1, 'Fantasy', '근위기사 목티(남)', 5, 1, 0, 0, 'DressShop2'),
	(227, 674, 1, 'Fantasy', '근위기사 롱코트(남)', 5, 1, 0, 0, 'DressShop2'),
	(228, 675, 1, 'Fantasy', '근위기사 장갑(남)', 9, 1, 0, 0, 'DressShop2'),
	(229, 676, 1, 'Fantasy', '근위기사 신발(남)', 7, 1, 0, 0, 'DressShop2'),
	(230, 677, 1, 'Fantasy', '근위기사 목티(여)', 5, 2, 0, 0, 'DressShop2'),
	(231, 678, 1, 'Fantasy', '근위기사 롱코트(여)', 5, 2, 0, 0, 'DressShop2'),
	(232, 679, 1, 'Fantasy', '근위기사 장갑(여)', 9, 2, 0, 0, 'DressShop2'),
	(233, 680, 1, 'Fantasy', '근위기사 신발(여)', 7, 2, 0, 0, 'DressShop2'),
	(234, 681, 1, 'Morden', '흰괭이 모자', 4, 2, 0, 0, 'DressShop2'),
	(235, 682, 1, 'Morden', '흰괭이 마스크', 9, 2, 0, 0, 'DressShop2'),
	(236, 683, 1, 'Morden', '흰괭이 장갑', 9, 2, 0, 0, 'DressShop2'),
	(237, 684, 1, 'Morden', '흰괭이 원피스', 5, 2, 0, 0, 'DressShop2'),
	(238, 685, 1, 'Morden', '흰괭이 신발', 7, 2, 0, 0, 'DressShop2'),
	(239, 686, 1, 'Apocalyse', '철가면 가면', 9, 1, 0, 0, 'DressShop'),
	(240, 687, 1, 'Gray', 'GS 갑옷', 5, 1, 0, 0, 'DressShop'),
	(241, 688, 1, 'Gray', 'GS 장갑', 9, 1, 0, 0, 'DressShop'),
	(242, 689, 1, 'Gray', 'GS 신발', 7, 1, 0, 0, 'DressShop'),
	(243, 690, 1, 'Gray', 'GS 바지', 6, 1, 0, 0, 'DressShop'),
	(244, 691, 1, 'Gray', 'GS 윗도리', 5, 1, 0, 0, 'DressShop'),
	(245, 692, 1, 'Gray', 'GS 망토', 5, 1, 0, 0, 'DressShop'),
	(246, 693, 1, 'WestWind', '메디치 망토', 5, 1, 0, 0, 'DressShop'),
	(247, 694, 1, 'WestWind', '메디치 신발', 7, 1, 0, 0, 'DressShop'),
	(248, 695, 1, 'WestWind', '메디치 바지장식', 9, 1, 0, 0, 'DressShop'),
	(249, 696, 1, 'WestWind', '메디치 갑옷', 5, 1, 0, 0, 'DressShop'),
	(250, 697, 1, 'WestWind', '메디치 바지', 6, 1, 0, 0, 'DressShop'),
	(251, 698, 1, 'WestWind', '메디치 장갑', 9, 1, 0, 0, 'DressShop'),
	(252, 699, 1, 'WestWind', '메디치 윗도리', 5, 1, 0, 0, 'DressShop'),
	(253, 700, 1, 'WestWind', '메르세데스 드레스', 5, 2, 0, 0, 'DressShop'),
	(254, 701, 1, 'WestWind', '메르세데스 숄', 9, 2, 0, 0, 'DressShop'),
	(255, 702, 1, 'WestWind', '괴도샤른 모자', 4, 1, 0, 0, 'DressShop'),
	(256, 703, 1, 'WestWind', '괴도샤른 가면', 9, 1, 0, 0, 'DressShop'),
	(257, 704, 1, 'WestWind', '괴도샤른 망토', 5, 1, 0, 0, 'DressShop'),
	(258, 705, 1, 'WestWind', '괴도샤른 장갑', 9, 1, 0, 0, 'DressShop'),
	(259, 706, 1, 'WestWind', '괴도샤른 윗도리', 5, 1, 0, 0, 'DressShop'),
	(260, 707, 1, 'WestWind', '괴도샤른 신발', 7, 1, 0, 0, 'DressShop'),
	(261, 708, 1, 'WestWind', '괴도샤른 바지', 6, 1, 0, 0, 'DressShop'),
	(262, 709, 1, 'Tempest', '제인쇼어 검은드레스', 5, 2, 0, 0, 'DressShop'),
	(263, 710, 1, 'Tempest', '제인쇼어 깃털장식', 9, 2, 0, 0, 'DressShop'),
	(264, 711, 1, 'Tempest', '제인쇼어 검은구두', 7, 2, 0, 0, 'DressShop'),
	(265, 712, 1, 'Tempest', '제인쇼어 담뱃대', 9, 2, 0, 0, 'DressShop'),
	(266, 713, 1, 'Tempest', '제인쇼어 검은장갑', 9, 2, 0, 0, 'DressShop'),
	(267, 714, 1, 'Tempest', '오필리아 망토', 5, 2, 0, 0, 'DressShop'),
	(268, 715, 1, 'Tempest', '오필리아 원피스', 5, 2, 0, 0, 'DressShop'),
	(269, 716, 1, 'Tempest', '오필리아 신발', 7, 2, 0, 0, 'DressShop'),
	(270, 717, 1, 'Tempest', '오필리아 장갑', 9, 2, 0, 0, 'DressShop'),
	(271, 718, 1, 'Tempest', '코델리아 원피스', 5, 2, 0, 0, 'DressShop'),
	(272, 719, 1, 'Tempest', '코델리아 구두', 7, 2, 0, 0, 'DressShop'),
	(273, 720, 1, 'Tempest', '코델리아 가방', 9, 2, 0, 0, 'DressShop'),
	(274, 721, 1, 'Shivan', '무카파 스커트', 6, 1, 0, 0, 'DressShop'),
	(275, 722, 1, 'Shivan', '무카파 바지장식', 9, 1, 0, 0, 'DressShop'),
	(276, 723, 1, 'Shivan', '무카파 신발', 7, 1, 0, 0, 'DressShop'),
	(277, 724, 1, 'Shivan', '무카파 근육옷', 5, 1, 0, 0, 'DressShop'),
	(278, 725, 1, 'Shivan', '마르자나 슈트', 5, 2, 0, 0, 'DressShop'),
	(279, 726, 1, 'Shivan', '마르자나 양말', 6, 2, 0, 0, 'DressShop'),
	(280, 727, 1, 'Shivan', '마르자나 토시', 9, 2, 0, 0, 'DressShop'),
	(281, 728, 1, 'Shivan', '마르자나 신발', 7, 2, 0, 0, 'DressShop'),
	(282, 729, 1, 'Shivan', '마르자나 팔장식', 9, 2, 0, 0, 'DressShop'),
	(283, 730, 1, 'Shivan', '마르자나 망토', 5, 2, 0, 0, 'DressShop'),
	(284, 731, 1, 'Shivan', '마르자나 시미터', 8, 2, 0, 0, 'DressShop'),
	(285, 732, 1, 'Apocalyse', '죠안 귀걸이', 9, 2, 0, 0, 'DressShop'),
	(286, 733, 1, 'Apocalyse', '죠안 빨간구두', 7, 2, 0, 0, 'DressShop'),
	(287, 734, 1, 'Apocalyse', '죠안 빨간드레스', 5, 2, 0, 0, 'DressShop'),
	(288, 735, 1, 'Apocalyse', '죠안 빨간장갑', 9, 2, 0, 0, 'DressShop'),
	(289, 736, 1, 'Apocalyse', '죠안 스타킹', 6, 2, 0, 0, 'DressShop'),
	(290, 737, 1, 'Apocalyse', '죠안 검L Type-l', 8, 2, 0, 0, 'DressShop'),
	(291, 738, 1, 'Apocalyse', '죠안 왕리본', 9, 2, 0, 0, 'DressShop'),
	(292, 739, 1, 'Fantasy', '엘프 귀', 9, 1, 0, 0, 'DressShop2'),
	(293, 740, 1, 'Tempest', '샤른호스트 살색쫄티', 5, 1, 0, 0, 'DressShop'),
	(294, 741, 1, 'Shivan', '아기다하카(남) 깃털옷', 5, 1, 0, 0, 'DressShop'),
	(295, 742, 1, 'Shivan', '아기다하카(남) 발', 7, 1, 0, 0, 'DressShop'),
	(296, 743, 1, 'Shivan', '아기다하카(여) 깃털옷', 5, 2, 0, 0, 'DressShop'),
	(297, 744, 1, 'Shivan', '아기다하카(여) 발', 7, 2, 0, 0, 'DressShop'),
	(298, 745, 1, 'Shivan', '아기다하카(남) 가죽옷', 5, 1, 0, 0, 'DressShop'),
	(299, 746, 1, 'Shivan', '아기다하카(남) 발', 7, 1, 0, 0, 'DressShop'),
	(300, 747, 1, 'Shivan', '아기다하카(여) 가죽옷', 5, 2, 0, 0, 'DressShop'),
	(301, 748, 1, 'Shivan', '아기다하카(여) 발', 7, 2, 0, 0, 'DressShop'),
	(302, 749, 1, 'Accessories', '여자애 인형(남)', 9, 1, 5000, 2500, 'AccessoryShop'),
	(303, 750, 1, 'Accessories', '여자애 인형(여)', 9, 2, 5000, 2500, 'AccessoryShop'),
	(304, 751, 1, 'Gray', '라시드 상의', 5, 1, 0, 0, 'DressShop'),
	(305, 752, 1, 'Gray', '라시드 검', 8, 1, 0, 0, 'DressShop'),
	(306, 753, 1, 'Gray', '라시드 신발', 7, 1, 0, 0, 'DressShop'),
	(307, 754, 1, 'Gray', '라시드 갑옷', 5, 1, 0, 0, 'DressShop'),
	(308, 755, 1, 'Gray', '라시드 팔찌', 9, 1, 0, 0, 'DressShop'),
	(309, 756, 1, 'Gray', '라시드 망토', 5, 1, 0, 0, 'DressShop'),
	(310, 757, 1, 'Gray', '이올린 머리띠', 4, 2, 0, 0, 'DressShop'),
	(311, 758, 1, 'Gray', '이올린 망토', 5, 2, 0, 0, 'DressShop'),
	(312, 759, 1, 'Gray', '이올린 갑옷(하의)', 6, 2, 0, 0, 'DressShop'),
	(313, 760, 1, 'Gray', '이올린 신발', 7, 2, 0, 0, 'DressShop'),
	(314, 761, 1, 'Gray', '이올린 바지', 6, 2, 0, 0, 'DressShop'),
	(315, 762, 1, 'Gray', '이올린 장갑', 9, 2, 0, 0, 'DressShop'),
	(316, 763, 1, 'Gray', '이올린 갑옷(상의)', 5, 2, 0, 0, 'DressShop'),
	(317, 764, 1, 'Tempest', '클라우제비츠 머리띠', 4, 1, 0, 0, 'DressShop'),
	(318, 765, 1, 'Tempest', '클라우제비츠 어깨장식', 9, 1, 0, 0, 'DressShop'),
	(319, 766, 1, 'Tempest', '클라우제비츠 부츠', 7, 1, 0, 0, 'DressShop'),
	(320, 767, 1, 'Tempest', '클라우제비츠 망토', 5, 1, 0, 0, 'DressShop'),
	(321, 768, 1, 'Tempest', '클라우제비츠 바지', 6, 1, 0, 0, 'DressShop'),
	(322, 769, 1, 'Tempest', '클라우제비츠 장갑', 9, 1, 0, 0, 'DressShop'),
	(323, 770, 1, 'Tempest', '클라우제비츠 외투', 5, 1, 0, 0, 'DressShop'),
	(324, 771, 1, 'Tempest', '앤 부츠', 7, 2, 0, 0, 'DressShop'),
	(325, 772, 1, 'Tempest', '앤 제복 상의', 5, 2, 0, 0, 'DressShop'),
	(326, 773, 1, 'Tempest', '앤 제복 바지', 6, 2, 0, 0, 'DressShop'),
	(327, 774, 1, 'Tempest', '앤 장갑', 9, 2, 0, 0, 'DressShop'),
	(328, 775, 1, 'Tempest', '앤 권총', 8, 2, 0, 0, 'DressShop'),
	(329, 776, 1, 'Shivan', '살라딘 신발', 7, 1, 0, 0, 'DressShop'),
	(330, 777, 1, 'Shivan', '살라딘 두건', 4, 1, 0, 0, 'DressShop'),
	(331, 778, 1, 'Shivan', '살라딘 귀걸이', 9, 1, 0, 0, 'DressShop'),
	(332, 779, 1, 'Shivan', '살라딘 망토', 5, 1, 0, 0, 'DressShop'),
	(333, 780, 1, 'Shivan', '살라딘 바지', 6, 1, 0, 0, 'DressShop'),
	(334, 781, 1, 'Shivan', '살라딘 상의', 5, 1, 0, 0, 'DressShop'),
	(335, 782, 1, 'Shivan', '살라딘 팔찌', 9, 1, 0, 0, 'DressShop'),
	(336, 783, 1, 'Shivan', '셰라자드 원피스', 5, 2, 0, 0, 'DressShop'),
	(337, 784, 1, 'Shivan', '셰라자드 외투', 5, 2, 0, 0, 'DressShop'),
	(338, 785, 1, 'Shivan', '셰라자드 팔찌', 9, 2, 0, 0, 'DressShop'),
	(339, 786, 1, 'Shivan', '오스만 외투', 5, 1, 0, 0, 'DressShop'),
	(340, 787, 1, 'Shivan', '오스만 신발', 7, 1, 0, 0, 'DressShop'),
	(341, 788, 1, 'Shivan', '오스만 어깨장식', 9, 1, 0, 0, 'DressShop'),
	(342, 789, 1, 'Shivan', '오스만 바지', 6, 1, 0, 0, 'DressShop'),
	(343, 790, 1, 'Shivan', '오스만 상의', 5, 1, 0, 0, 'DressShop'),
	(344, 791, 1, 'Shivan', '아두스베이 복면', 9, 1, 0, 0, 'DressShop'),
	(345, 792, 1, 'Shivan', '아두스베이 장갑', 9, 1, 0, 0, 'DressShop'),
	(346, 793, 1, 'Shivan', '아두스베이 망토', 5, 1, 0, 0, 'DressShop'),
	(347, 794, 1, 'Shivan', '아두스베이 바지', 6, 1, 0, 0, 'DressShop'),
	(348, 795, 1, 'Shivan', '아두스베이 신발', 7, 1, 0, 0, 'DressShop'),
	(349, 796, 1, 'Shivan', '아두스베이 상의', 5, 1, 0, 0, 'DressShop'),
	(350, 797, 1, 'Shivan', '아두스베이 단도', 8, 1, 0, 0, 'DressShop'),
	(351, 798, 1, 'Crimson', '아델라이데 머리띠', 4, 2, 0, 0, 'DressShop'),
	(352, 799, 1, 'Crimson', '아델라이데 드레스', 5, 2, 0, 0, 'DressShop'),
	(353, 800, 1, 'Crimson', '아델라이데 장갑', 9, 2, 0, 0, 'DressShop'),
	(354, 801, 1, 'Apocalyse', '시안 수염', 9, 1, 0, 0, 'DressShop'),
	(355, 802, 1, 'Apocalyse', '시안 지팡이', 8, 1, 0, 0, 'DressShop'),
	(356, 803, 1, 'Apocalyse', '시안 망토', 5, 1, 0, 0, 'DressShop'),
	(357, 804, 1, 'Apocalyse', '시안 로브', 5, 1, 0, 0, 'DressShop'),
	(358, 805, 1, 'Gray', '신비의전대(남) 망토', 5, 1, 0, 0, 'DressShop'),
	(359, 806, 1, 'Gray', '신비의전대(남) 마스크', 9, 1, 0, 0, 'DressShop'),
	(360, 807, 1, 'Gray', '신비의전대(남) 투구', 4, 1, 0, 0, 'DressShop'),
	(361, 808, 1, 'Gray', '신비의전대(여) 망토', 5, 2, 0, 0, 'DressShop'),
	(362, 809, 1, 'Gray', '신비의전대(여) 마스크', 9, 2, 0, 0, 'DressShop'),
	(363, 810, 1, 'Gray', '신비의전대(여) 투구', 4, 2, 0, 0, 'DressShop'),
	(364, 811, 1, 'Crimson', '버몬트 바리사다', 8, 1, 0, 0, 'DressShop'),
	(365, 812, 1, 'Tempest', '오필리아 마법사 지팡이', 8, 2, 0, 0, 'DressShop'),
	(366, 813, 1, 'Apocalyse', '알바티니 검', 8, 1, 0, 0, 'DressShop'),
	(367, 814, 1, 'Apocalyse', '크리스티앙 리볼버', 8, 1, 0, 0, 'DressShop'),
	(368, 815, 1, 'Gray', '흑태자 아수라검', 8, 1, 0, 0, 'DressShop'),
	(369, 816, 1, 'Original', '루시안 외투', 5, 1, 0, 0, 'DressShop2'),
	(370, 817, 1, 'Original', '루시안 부츠', 7, 1, 0, 0, 'DressShop2'),
	(371, 818, 1, 'Original', '루시안 바지', 6, 1, 0, 0, 'DressShop2'),
	(372, 819, 1, 'Original', '루시안 장갑', 9, 1, 0, 0, 'DressShop2'),
	(373, 820, 1, 'Original', '루시안 상의', 5, 1, 0, 0, 'DressShop2'),
	(374, 821, 1, 'Original', '조슈아 구두', 7, 1, 0, 0, 'DressShop2'),
	(375, 822, 1, 'Original', '조슈아 바지', 6, 1, 0, 0, 'DressShop2'),
	(376, 823, 1, 'Original', '조슈아 셔츠', 5, 1, 0, 0, 'DressShop2'),
	(377, 824, 1, 'Original', '조슈아 점퍼', 5, 1, 0, 0, 'DressShop2'),
	(378, 825, 1, 'Original', '막시민 외투', 5, 1, 0, 0, 'DressShop2'),
	(379, 826, 1, 'Original', '막시민 구두', 7, 1, 0, 0, 'DressShop2'),
	(380, 827, 1, 'Original', '막시민 셔츠', 5, 1, 0, 0, 'DressShop2'),
	(381, 828, 1, 'Original', '막시민 바지', 6, 1, 0, 0, 'DressShop2'),
	(382, 829, 1, 'Original', '막시민 안경', 9, 1, 0, 0, 'DressShop2'),
	(383, 830, 1, 'Original', '보리스 망토', 5, 1, 0, 0, 'DressShop2'),
	(384, 831, 1, 'Original', '보리스 상의', 5, 1, 0, 0, 'DressShop2'),
	(385, 832, 1, 'Original', '보리스 바지', 6, 1, 0, 0, 'DressShop2'),
	(386, 833, 1, 'Original', '보리스 장갑', 9, 1, 0, 0, 'DressShop2'),
	(387, 834, 1, 'Original', '보리스 구두', 7, 1, 0, 0, 'DressShop2'),
	(388, 835, 1, 'Original', '란지에 구두', 7, 1, 0, 0, 'DressShop2'),
	(389, 836, 1, 'Original', '란지에 조끼', 5, 1, 0, 0, 'DressShop2'),
	(390, 837, 1, 'Original', '란지에 바지', 6, 1, 0, 0, 'DressShop2'),
	(391, 838, 1, 'Original', '란지에 셔츠', 5, 1, 0, 0, 'DressShop2'),
	(392, 839, 1, 'Original', '란지에 외투', 5, 1, 0, 0, 'DressShop2'),
	(393, 840, 1, 'Original', '시벨린 부츠', 7, 1, 0, 0, 'DressShop2'),
	(394, 841, 1, 'Original', '시벨린 상의', 5, 1, 0, 0, 'DressShop2'),
	(395, 842, 1, 'Original', '시벨린 장갑', 9, 1, 0, 0, 'DressShop2'),
	(396, 843, 1, 'Original', '시벨린 바지', 6, 1, 0, 0, 'DressShop2'),
	(397, 844, 1, 'Original', '이자크 고무신', 7, 1, 0, 0, 'DressShop2'),
	(398, 845, 1, 'Original', '이자크 바지', 6, 1, 0, 0, 'DressShop2'),
	(399, 846, 1, 'Original', '이자크 상의', 5, 1, 0, 0, 'DressShop2'),
	(400, 847, 1, 'Original', '이자크 팔찌', 9, 1, 0, 0, 'DressShop2'),
	(401, 848, 1, 'Original', '이스핀 모자', 4, 2, 0, 0, 'DressShop2'),
	(402, 849, 1, 'Original', '이스핀 긴양말', 6, 2, 0, 0, 'DressShop2'),
	(403, 850, 1, 'Original', '이스핀 반바지', 6, 2, 0, 0, 'DressShop2'),
	(404, 851, 1, 'Original', '이스핀 상의', 5, 2, 0, 0, 'DressShop2'),
	(405, 852, 1, 'Original', '이스핀 조끼', 5, 2, 0, 0, 'DressShop2'),
	(406, 853, 1, 'Original', '이스핀 팔지', 9, 2, 0, 0, 'DressShop2'),
	(407, 854, 1, 'Original', '이스핀 구두', 7, 2, 0, 0, 'DressShop2'),
	(408, 855, 1, 'Original', '티치엘 흰양말', 6, 2, 0, 0, 'DressShop2'),
	(409, 856, 1, 'Original', '티치엘 구두', 7, 2, 0, 0, 'DressShop2'),
	(410, 857, 1, 'Original', '티치엘 원피스', 5, 2, 0, 0, 'DressShop2'),
	(411, 858, 1, 'Original', '클로에 드레스', 5, 2, 0, 0, 'DressShop2'),
	(412, 859, 1, 'Original', '클로에 머리띠', 9, 2, 0, 0, 'DressShop2'),
	(413, 860, 1, 'Original', '레이 두건', 4, 2, 0, 0, 'DressShop2'),
	(414, 861, 1, 'Original', '레이 외투', 5, 2, 0, 0, 'DressShop2'),
	(415, 862, 1, 'Original', '레이 슈츠', 5, 2, 0, 0, 'DressShop2'),
	(416, 863, 1, 'Original', '레이 팔토시', 9, 2, 0, 0, 'DressShop2'),
	(417, 864, 1, 'Original', '레이 신발', 7, 2, 0, 0, 'DressShop2'),
	(418, 865, 1, 'Original', '아나이스 외투', 5, 2, 0, 0, 'DressShop2'),
	(419, 866, 1, 'Original', '아나이스 리본', 9, 2, 0, 0, 'DressShop2'),
	(420, 867, 1, 'Original', '아나이스 신발', 7, 2, 0, 0, 'DressShop2'),
	(421, 868, 1, 'Original', '아나이스 원피스', 5, 2, 0, 0, 'DressShop2'),
	(422, 869, 1, 'Original', '밀라 롱부츠', 7, 2, 0, 0, 'DressShop2'),
	(423, 870, 1, 'Original', '밀라 해골귀걸이', 9, 2, 0, 0, 'DressShop2'),
	(424, 871, 1, 'Original', '밀라 해골티', 5, 2, 0, 0, 'DressShop2'),
	(425, 872, 1, 'Original', '밀라 반바지', 6, 2, 0, 0, 'DressShop2'),
	(426, 873, 1, 'Original', '밀라 바지장식', 9, 2, 0, 0, 'DressShop2'),
	(427, 874, 1, 'Original', '밀라 팔토시', 9, 2, 0, 0, 'DressShop2'),
	(428, 875, 1, 'Original', '벤야 잠옷', 5, 2, 0, 0, 'DressShop2'),
	(429, 876, 1, 'Morden', '한조 복면', 4, 1, 0, 0, 'DressShop2'),
	(430, 877, 1, 'Morden', '한조 붉은머플러', 9, 1, 0, 0, 'DressShop2'),
	(431, 878, 1, 'Morden', '한조 신발', 7, 1, 0, 0, 'DressShop2'),
	(432, 879, 1, 'Morden', '한조 바지', 6, 1, 0, 0, 'DressShop2'),
	(433, 880, 1, 'Morden', '한조 그물옷', 5, 1, 0, 0, 'DressShop2'),
	(434, 881, 1, 'Morden', '한조 장갑', 9, 1, 0, 0, 'DressShop2'),
	(435, 882, 1, 'Morden', '한복 저고리(남)', 5, 1, 0, 0, 'DressShop2'),
	(436, 883, 1, 'Morden', '한복 바지(남)', 6, 1, 0, 0, 'DressShop2'),
	(437, 884, 1, 'Morden', '한복 조끼(남)', 5, 1, 0, 0, 'DressShop2'),
	(438, 885, 1, 'Morden', '한복 고무신(남)', 7, 1, 0, 0, 'DressShop2'),
	(439, 886, 1, 'Morden', '한복 노랑저고리(여)', 5, 2, 0, 0, 'DressShop2'),
	(440, 887, 1, 'Morden', '한복 빨강치마(여)', 6, 2, 0, 0, 'DressShop2'),
	(441, 888, 1, 'Morden', '한복 버선(여)', 6, 2, 0, 0, 'DressShop2'),
	(442, 889, 1, 'Morden', '한복 고무신(여)', 7, 2, 0, 0, 'DressShop2'),
	(443, 890, 1, 'Morden', '에스키모 방한복(남)', 5, 1, 0, 0, 'DressShop2'),
	(444, 891, 1, 'Morden', '에스키모 신발(남)', 7, 1, 0, 0, 'DressShop2'),
	(445, 892, 1, 'Morden', '에스키모 방한복(여)', 5, 2, 0, 0, 'DressShop2'),
	(446, 893, 1, 'Morden', '에스키모 신발(여)', 7, 2, 0, 0, 'DressShop2'),
	(447, 894, 1, 'Morden', '산타 빨간모자(남)', 4, 1, 0, 0, 'DressShop2'),
	(448, 895, 1, 'Morden', '산타 수염(남)', 9, 1, 0, 0, 'DressShop2'),
	(449, 896, 1, 'Morden', '산타 빨간외투(남)', 5, 1, 0, 0, 'DressShop2'),
	(450, 897, 1, 'Morden', '산타 빨간장갑(남)', 9, 1, 0, 0, 'DressShop2'),
	(451, 898, 1, 'Morden', '산타 선물보따리(남)', 9, 1, 0, 0, 'DressShop2'),
	(452, 899, 1, 'Morden', '산타 장화(남)', 7, 1, 0, 0, 'DressShop2'),
	(453, 900, 1, 'Morden', '산타 빨간모자(여)', 4, 2, 0, 0, 'DressShop2'),
	(454, 901, 1, 'Morden', '산타 수염(여)', 9, 2, 0, 0, 'DressShop2'),
	(455, 902, 1, 'Morden', '산타 빨간외투(여)', 5, 2, 0, 0, 'DressShop2'),
	(456, 903, 1, 'Morden', '산타 빨간장갑(여)', 9, 2, 0, 0, 'DressShop2'),
	(457, 904, 1, 'Morden', '산타 선물보따리(여)', 9, 2, 0, 0, 'DressShop2'),
	(458, 905, 1, 'Morden', '산타 빨간바지(여)', 6, 2, 0, 0, 'DressShop2'),
	(459, 906, 1, 'Morden', '산타 장화(여)', 7, 2, 0, 0, 'DressShop2'),
	(460, 907, 1, 'Morden', '루돌프 모자(남)', 4, 1, 0, 0, 'DressShop2'),
	(461, 908, 1, 'Morden', '루돌프 빨간코(남)', 9, 1, 0, 0, 'DressShop2'),
	(462, 909, 1, 'Morden', '루돌프 방울(남)', 9, 1, 0, 0, 'DressShop2'),
	(463, 910, 1, 'Morden', '루돌프 털옷(남)', 5, 1, 0, 0, 'DressShop2'),
	(464, 911, 1, 'Morden', '루돌프 신발(남)', 7, 1, 0, 0, 'DressShop2'),
	(465, 912, 1, 'Morden', '루돌프 모자(여)', 4, 2, 0, 0, 'DressShop2'),
	(466, 913, 1, 'Morden', '루돌프 빨간코(여)', 9, 2, 0, 0, 'DressShop2'),
	(467, 914, 1, 'Morden', '루돌프 방울(여)', 9, 2, 0, 0, 'DressShop2'),
	(468, 915, 1, 'Morden', '루돌프 털옷(여)', 5, 2, 0, 0, 'DressShop2'),
	(469, 916, 1, 'Morden', '루돌프 신발(여)', 7, 2, 0, 0, 'DressShop2'),
	(470, 917, 1, 'Morden', '눈사람 눈송이외투(남)', 5, 1, 0, 0, 'DressShop2'),
	(471, 918, 1, 'Morden', '눈사람 당근코(남)', 9, 1, 0, 0, 'DressShop2'),
	(472, 919, 1, 'Morden', '눈사람 눈송이외투(여)', 5, 2, 0, 0, 'DressShop2'),
	(473, 920, 1, 'Morden', '눈사람 당근코(여)', 9, 2, 0, 0, 'DressShop2'),
	(474, 921, 1, 'Accessories', '하얀깃털날개(남)', 9, 1, 2850, 1425, 'AccessoryShop'),
	(475, 922, 1, 'Accessories', '하얀깃털날개(여)', 9, 2, 2850, 1425, 'AccessoryShop'),
	(476, 923, 1, 'Accessories', '검은깃털날개(남)', 9, 1, 2850, 1425, 'AccessoryShop'),
	(477, 924, 1, 'Accessories', '검은깃털날개(여)', 9, 2, 2850, 1425, 'AccessoryShop'),
	(478, 925, 1, 'G3P2', '살라딘II 바지', 6, 1, 0, 0, 'DressShop'),
	(479, 926, 1, 'G3P2', '살라딘II 상의', 5, 1, 0, 0, 'DressShop'),
	(480, 927, 1, 'G3P2', '살라딘II 외투', 5, 1, 0, 0, 'DressShop'),
	(481, 928, 1, 'G3P2', '살라딘II 장갑', 9, 1, 0, 0, 'DressShop'),
	(482, 929, 1, 'G3P2', '살라딘II 신발', 7, 1, 0, 0, 'DressShop'),
	(483, 930, 1, 'G3P2', '살라딘II B슬라이서', 8, 1, 0, 0, 'DressShop'),
	(484, 931, 1, 'G3P2', '죠안II 모자', 4, 2, 0, 0, 'DressShop'),
	(485, 932, 1, 'G3P2', '죠안II 상의', 5, 2, 0, 0, 'DressShop'),
	(486, 933, 1, 'G3P2', '죠안II 신발', 7, 2, 0, 0, 'DressShop'),
	(487, 934, 1, 'G3P2', '죠안II 치마', 6, 2, 0, 0, 'DressShop'),
	(488, 935, 1, 'G3P2', '죠안II 치마 덧옷', 6, 2, 0, 0, 'DressShop'),
	(489, 936, 1, 'G3P2', '죠안II 장갑', 9, 2, 0, 0, 'DressShop'),
	(490, 937, 1, 'G3P2', '죠안II 검', 8, 2, 0, 0, 'DressShop'),
	(491, 938, 1, 'G3P2', '베라모드(남) 장갑', 9, 1, 0, 0, 'DressShop'),
	(492, 939, 1, 'G3P2', '베라모드(남) 바지', 6, 1, 0, 0, 'DressShop'),
	(493, 940, 1, 'G3P2', '베라모드(남) 외투', 5, 1, 0, 0, 'DressShop'),
	(494, 941, 1, 'G3P2', '베라모드(남) 허리장식', 9, 1, 0, 0, 'DressShop'),
	(495, 942, 1, 'G3P2', '베라모드(남) 신발', 7, 1, 0, 0, 'DressShop'),
	(496, 943, 1, 'G3P2', '베라모드(여) 장갑', 9, 2, 0, 0, 'DressShop'),
	(497, 944, 1, 'G3P2', '베라모드(여) 바지', 6, 2, 0, 0, 'DressShop'),
	(498, 945, 1, 'G3P2', '베라모드(여) 외투', 5, 2, 0, 0, 'DressShop'),
	(499, 946, 1, 'G3P2', '베라모드(여) 허리장식', 9, 2, 0, 0, 'DressShop'),
	(500, 947, 1, 'G3P2', '베라모드(여) 신발', 7, 2, 0, 0, 'DressShop'),
	(501, 948, 1, 'G3P2', '란 장갑', 9, 1, 0, 0, 'DressShop'),
	(502, 949, 1, 'G3P2', '란 검', 8, 1, 0, 0, 'DressShop'),
	(503, 950, 1, 'G3P2', '란 상의', 5, 1, 0, 0, 'DressShop'),
	(504, 951, 1, 'G3P2', '란 바지', 6, 1, 0, 0, 'DressShop'),
	(505, 952, 1, 'G3P2', '란 신발', 7, 1, 0, 0, 'DressShop'),
	(506, 953, 1, 'G3P2', '루시엔 플레어스커트', 6, 2, 0, 0, 'DressShop'),
	(507, 954, 1, 'G3P2', '루시엔 니삭스', 6, 2, 0, 0, 'DressShop'),
	(508, 955, 1, 'G3P2', '루시엔 터틀넥티', 5, 2, 0, 0, 'DressShop'),
	(509, 956, 1, 'G3P2', '루시엔 스트랩슈즈', 7, 2, 0, 0, 'DressShop'),
	(510, 957, 1, 'G3P2', '루시엔 사진기가방', 9, 2, 0, 0, 'DressShop'),
	(511, 958, 1, 'G3P2', '루시엔 손목보호대', 9, 2, 0, 0, 'DressShop'),
	(512, 959, 1, 'G3P2', '크리스티앙II 쫄티', 5, 1, 0, 0, 'DressShop'),
	(513, 960, 1, 'G3P2', '크리스티앙II 장갑', 9, 1, 0, 0, 'DressShop'),
	(514, 961, 1, 'G3P2', '크리스티앙II 신발', 7, 1, 0, 0, 'DressShop'),
	(515, 962, 1, 'G3P2', '크리스티앙II 허리띠', 9, 1, 0, 0, 'DressShop'),
	(516, 963, 1, 'G3P2', '크리스티앙II 바지', 6, 1, 0, 0, 'DressShop'),
	(517, 964, 1, 'Crimson', '올리비에 니삭스', 6, 2, 0, 0, 'DressShop'),
	(518, 965, 1, 'Crimson', '올리비에 신발', 7, 2, 0, 0, 'DressShop'),
	(519, 966, 1, 'Crimson', '올리비에 상의', 5, 2, 0, 0, 'DressShop'),
	(520, 967, 1, 'Crimson', '올리비에 하의', 6, 2, 0, 0, 'DressShop'),
	(521, 968, 1, 'Crimson', '올리비에 외투', 5, 2, 0, 0, 'DressShop'),
	(522, 969, 1, 'Crimson', '올리비에 손목보호대', 9, 2, 0, 0, 'DressShop'),
	(523, 970, 1, 'Crimson', '올리비에 귀걸이', 9, 2, 0, 0, 'DressShop'),
	(524, 971, 1, 'Crimson', '벨제부르 바지', 6, 1, 0, 0, 'DressShop'),
	(525, 972, 1, 'Crimson', '벨제부르 투구', 4, 1, 0, 0, 'DressShop'),
	(526, 973, 1, 'Crimson', '벨제부르 망토', 5, 1, 0, 0, 'DressShop'),
	(527, 974, 1, 'Crimson', '벨제부르 갑주(상)', 5, 1, 0, 0, 'DressShop'),
	(528, 975, 1, 'Crimson', '벨제부르 마스크', 9, 1, 0, 0, 'DressShop'),
	(529, 976, 1, 'Crimson', '벨제부르 신발', 7, 1, 0, 0, 'DressShop'),
	(530, 977, 1, 'Crimson', '벨제부르 갑주(하)', 6, 1, 0, 0, 'DressShop'),
	(531, 978, 1, 'Shivan', '발라 머리띠', 4, 1, 0, 0, 'DressShop'),
	(532, 979, 1, 'Shivan', '발라 귀걸이', 9, 1, 0, 0, 'DressShop'),
	(533, 980, 1, 'Shivan', '발라 허리띠', 9, 1, 0, 0, 'DressShop'),
	(534, 981, 1, 'Shivan', '발라 스커트', 6, 1, 0, 0, 'DressShop'),
	(535, 982, 1, 'Shivan', '발라 시미터', 8, 1, 0, 0, 'DressShop'),
	(536, 983, 1, 'Shivan', '발라 마스크', 9, 1, 0, 0, 'DressShop'),
	(537, 984, 1, 'Shivan', '발라 쫄티', 5, 1, 0, 0, 'DressShop'),
	(538, 985, 1, 'Shivan', '발라 신발', 7, 1, 0, 0, 'DressShop'),
	(539, 986, 1, 'Accessories', '4LEAF 귀걸이 블루(여)', 9, 2, 8000, 4000, 'AccessoryShop'),
	(540, 987, 1, 'Accessories', '4LEAF 귀걸이 블루(남)', 9, 1, 8000, 4000, 'AccessoryShop'),
	(541, 988, 1, 'Apocalyse', '버몬트 가발', 3, 1, 20000, 10000, 'HairShop'),
	(542, 989, 1, 'Gray', '드라우프닐 가발', 3, 1, 3700, 1850, 'HairShop'),
	(543, 990, 1, 'WestWind', '시라노 가발', 3, 1, 15000, 7500, 'HairShop'),
	(544, 991, 1, 'Shivan', '살라딘 가발', 3, 1, 20000, 10000, 'HairShop'),
	(545, 992, 1, 'Tempest', '샤른호스트 가발', 3, 1, 13500, 6750, 'HairShop'),
	(546, 993, 1, 'Tempest', '클라우제비츠 가발', 3, 1, 22000, 11000, 'HairShop'),
	(547, 994, 1, 'Shivan', '얀지슈카 가발', 3, 2, 7000, 3500, 'HairShop'),
	(548, 995, 1, 'Tempest', '리나 가발', 3, 2, 3500, 1750, 'HairShop'),
	(549, 996, 1, 'Tempest', '메리 가발', 3, 2, 17000, 8500, 'HairShop'),
	(550, 997, 1, 'Gray', '로빈 가발', 3, 2, 3200, 1600, 'HairShop'),
	(551, 998, 1, 'Tempest', '오필리아 가발', 3, 2, 5100, 2550, 'HairShop'),
	(552, 999, 1, 'WestWind', '메르세데스 가발', 3, 2, 4550, 2275, 'HairShop'),
	(553, 1000, 1, 'Shivan', '셰라자드 가발', 3, 2, 13500, 6750, 'HairShop'),
	(554, 1001, 1, 'Tempest', '에밀리오 가발', 3, 1, 10000, 5000, 'HairShop'),
	(555, 1002, 1, 'Accessories', '4LEAF 귀걸이 그린(여)', 9, 2, 8000, 4000, 'AccessoryShop'),
	(556, 1003, 1, 'Accessories', '4LEAF 귀걸이 그린(남)', 9, 1, 8000, 4000, 'AccessoryShop'),
	(557, 1004, 1, 'None', '교복(하) 와이셔츠', 5, 1, 0, 0, 'None'),
	(558, 1005, 1, 'None', '교복(하) 반바지', 6, 1, 0, 0, 'None'),
	(559, 1006, 1, 'None', '교복(하) 신발', 7, 1, 0, 0, 'None'),
	(560, 1007, 1, 'None', '교복(하) 블라우스', 5, 1, 0, 0, 'None'),
	(561, 1008, 1, 'None', '교복(하) 치마', 6, 1, 0, 0, 'None'),
	(562, 1009, 1, 'None', '교복(하) 신발', 7, 1, 0, 0, 'None'),
	(563, 1010, 1, 'Sport', '물안경(남)', 4, 1, 250, 125, 'AccessoryShop'),
	(564, 1011, 1, 'Sport', '튜브(남)', 9, 1, 250, 125, 'AccessoryShop'),
	(565, 1012, 1, 'Sport', '오리발(남)', 7, 1, 250, 125, 'AccessoryShop'),
	(566, 1013, 1, 'Sport', '물안경(여)', 4, 2, 250, 125, 'AccessoryShop'),
	(567, 1014, 1, 'Sport', '튜브(여)', 9, 2, 250, 125, 'AccessoryShop'),
	(568, 1015, 1, 'Sport', '오리발(여)', 7, 2, 250, 125, 'AccessoryShop'),
	(569, 1016, 1, 'Life', '여름남방(남)', 5, 1, 250, 125, 'AccessoryShop'),
	(570, 1017, 1, 'Life', '여름남방(여)', 5, 2, 250, 125, 'AccessoryShop'),
	(571, 1018, 1, 'Life', '포리프면티(남)', 5, 1, 250, 125, 'AccessoryShop'),
	(572, 1019, 1, 'Life', '포리프면티(여)', 5, 2, 250, 125, 'AccessoryShop'),
	(573, 1020, 1, 'Sport', '수영복바지(남)', 6, 1, 250, 125, 'AccessoryShop'),
	(574, 1021, 1, 'Sport', '수영복(여)', 5, 2, 250, 125, 'AccessoryShop'),
	(575, 1022, 1, 'Life', '민소매티(남)', 5, 1, 250, 125, 'AccessoryShop'),
	(576, 1023, 1, 'Life', '민소매티(여)', 5, 2, 250, 125, 'AccessoryShop'),
	(577, 1024, 1, 'Life', '청반바지(남)', 6, 1, 250, 125, 'AccessoryShop'),
	(578, 1025, 1, 'Life', '청반바지(여)', 6, 2, 250, 125, 'AccessoryShop'),
	(579, 1026, 1, 'Accessories', '선그라스(남)', 9, 1, 250, 125, 'AccessoryShop'),
	(580, 1027, 1, 'Life', '여름슬리퍼(남)', 7, 1, 250, 125, 'AccessoryShop'),
	(581, 1028, 1, 'Accessories', '선그라스(여)', 9, 2, 250, 125, 'AccessoryShop'),
	(582, 1029, 1, 'Life', '여름슬리퍼(여)', 7, 2, 250, 125, 'AccessoryShop'),
	(583, 1030, 1, 'Sport', '스포츠백(남)', 9, 1, 250, 125, 'AccessoryShop'),
	(584, 1031, 1, 'Sport', '스포츠백(여)', 9, 2, 250, 125, 'AccessoryShop'),
	(585, 1032, 1, 'Morden', '경찰 모자(남)', 4, 1, 0, 0, 'DressShop2'),
	(586, 1033, 1, 'Morden', '경찰 제복남방(남)', 5, 1, 0, 0, 'DressShop2'),
	(587, 1034, 1, 'Morden', '경찰 제복바지(남)', 6, 1, 0, 0, 'DressShop2'),
	(588, 1035, 1, 'Morden', '경찰 제복구두(남)', 7, 1, 0, 0, 'DressShop2'),
	(589, 1036, 1, 'Morden', '경찰 모자(여)', 4, 2, 0, 0, 'DressShop2'),
	(590, 1037, 1, 'Morden', '경찰 제복남방(여)', 5, 2, 0, 0, 'DressShop2'),
	(591, 1038, 1, 'Morden', '경찰 제복바지(여)', 6, 2, 0, 0, 'DressShop2'),
	(592, 1039, 1, 'Morden', '경찰 제복구두(여)', 7, 2, 0, 0, 'DressShop2'),
	(593, 1040, 1, 'Morden', '군인 철모(남)', 4, 1, 0, 0, 'DressShop2'),
	(594, 1041, 1, 'Morden', '군인 군복상의(남)', 5, 1, 0, 0, 'DressShop2'),
	(595, 1042, 1, 'Morden', '군인 군복하의(남)', 6, 1, 0, 0, 'DressShop2'),
	(596, 1043, 1, 'Morden', '군인 군용멜빵(남)', 9, 1, 0, 0, 'DressShop2'),
	(597, 1044, 1, 'Morden', '군인 군화(남)', 7, 1, 0, 0, 'DressShop2'),
	(598, 1045, 1, 'Morden', '군인 철모(여)', 4, 2, 0, 0, 'DressShop2'),
	(599, 1046, 1, 'Morden', '군인 군복상의(여)', 5, 2, 0, 0, 'DressShop2'),
	(600, 1047, 1, 'Morden', '군인 군복하의(여)', 6, 2, 0, 0, 'DressShop2'),
	(601, 1048, 1, 'Morden', '군인 군복멜빵(여)', 9, 2, 0, 0, 'DressShop2'),
	(602, 1049, 1, 'Morden', '군인 군화(여)', 7, 2, 0, 0, 'DressShop2'),
	(603, 1050, 1, 'Morden', '경찰 방독면(남)', 9, 1, 0, 0, 'DressShop2'),
	(604, 1051, 1, 'Morden', '군인 K2소총(남)', 8, 1, 0, 0, 'DressShop2'),
	(605, 1052, 1, 'Morden', '군인 모자(남)', 4, 1, 0, 0, 'DressShop2'),
	(606, 1053, 1, 'Morden', '경찰 방탄조끼(남)', 5, 1, 0, 0, 'DressShop2'),
	(607, 1054, 1, 'Morden', '경찰 방독면(여)', 9, 2, 0, 0, 'DressShop2'),
	(608, 1055, 1, 'Morden', '군인 K2소총(여)', 8, 2, 0, 0, 'DressShop2'),
	(609, 1056, 1, 'Morden', '군인 모자(여)', 4, 2, 0, 0, 'DressShop2'),
	(610, 1057, 1, 'Morden', '경찰 방탄조끼(여)', 5, 2, 0, 0, 'DressShop2'),
	(611, 1058, 1, 'Morden', '뺑덕어멈 저고리', 5, 2, 0, 0, 'DressShop2'),
	(612, 1059, 1, 'Morden', '뺑덕어멈 치마', 6, 2, 0, 0, 'DressShop2'),
	(613, 1060, 1, 'Morden', '뺑덕어멈 곰방대', 9, 2, 0, 0, 'DressShop2'),
	(614, 1061, 1, 'Morden', '민속의상 고무신', 7, 2, 0, 0, 'DressShop2'),
	(615, 1062, 1, 'Morden', '상궁 당의', 5, 2, 0, 0, 'DressShop2'),
	(616, 1063, 1, 'Morden', '상궁 치마', 6, 2, 0, 0, 'DressShop2'),
	(617, 1064, 1, 'Morden', '중전 당의', 5, 2, 0, 0, 'DressShop2'),
	(618, 1065, 1, 'Morden', '중전 치마', 6, 2, 0, 0, 'DressShop2'),
	(619, 1066, 1, 'Morden', '임금 면류관', 4, 1, 0, 0, 'DressShop2'),
	(620, 1067, 1, 'Morden', '임금 황룡포', 5, 1, 0, 0, 'DressShop2'),
	(621, 1068, 1, 'Morden', '민속의상 신발', 7, 1, 0, 0, 'DressShop2'),
	(622, 1069, 1, 'Morden', '대감 저고리', 5, 1, 0, 0, 'DressShop2'),
	(623, 1070, 1, 'Morden', '대감 바지', 6, 1, 0, 0, 'DressShop2'),
	(624, 1071, 1, 'Morden', '대감 관모', 4, 1, 0, 0, 'DressShop2'),
	(625, 1072, 1, 'Morden', '대감 관복(청)', 5, 1, 0, 0, 'DressShop2'),
	(626, 1073, 1, 'Morden', '포도대장 모자', 4, 1, 0, 0, 'DressShop2'),
	(627, 1074, 1, 'Morden', '포도대장 도포', 5, 1, 0, 0, 'DressShop2'),
	(628, 1075, 1, 'Morden', '포도대장 지휘채', 8, 1, 0, 0, 'DressShop2'),
	(629, 1076, 1, 'Morden', '중전 가발', 3, 2, 2000, 1000, 'HairShop'),
	(630, 1077, 1, 'Morden', '상궁 가발', 3, 2, 1500, 750, 'HairShop'),
	(631, 1078, 1, 'G3P2', '데미안 폴라민소매티', 5, 1, 0, 0, 'DressShop'),
	(632, 1079, 1, 'G3P2', '데미안 바지', 6, 1, 0, 0, 'DressShop'),
	(633, 1080, 1, 'G3P2', '데미안 겉치마', 6, 1, 0, 0, 'DressShop'),
	(634, 1081, 1, 'G3P2', '데미안 신발', 7, 1, 0, 0, 'DressShop'),
	(635, 1082, 1, 'G3P2', '데미안 장갑', 9, 1, 0, 0, 'DressShop'),
	(636, 1083, 1, 'G3P2', '데미안 목장식', 9, 1, 0, 0, 'DressShop'),
	(637, 1084, 1, 'G3P2', '데미안 십자목걸이', 9, 1, 0, 0, 'DressShop'),
	(638, 1085, 1, 'G3P2', '데미안 멸살지옥검', 8, 1, 0, 0, 'DressShop'),
	(639, 1086, 1, 'G3P2', '네리사 상의', 5, 2, 0, 0, 'DressShop'),
	(640, 1087, 1, 'G3P2', '네리사 치마', 6, 2, 0, 0, 'DressShop'),
	(641, 1088, 1, 'G3P2', '네리사 신발', 7, 2, 0, 0, 'DressShop'),
	(642, 1089, 1, 'G3P2', '네리사 리본', 9, 2, 0, 0, 'DressShop'),
	(643, 1090, 1, 'G3P2', '네리사 밍밍인형', 9, 2, 0, 0, 'DressShop'),
	(644, 1091, 1, 'G3P2', '카를로스 구룡포', 5, 1, 0, 0, 'DressShop'),
	(645, 1092, 1, 'G3P2', '카를로스 바지', 6, 1, 0, 0, 'DressShop'),
	(646, 1093, 1, 'G3P2', '카를로스 겉치마', 6, 1, 0, 0, 'DressShop'),
	(647, 1094, 1, 'G3P2', '카를로스 신발', 7, 1, 0, 0, 'DressShop'),
	(648, 1095, 1, 'G3P2', '카를로스 팔찌', 9, 1, 0, 0, 'DressShop'),
	(649, 1096, 1, 'G3P2', '카를로스 장갑', 9, 1, 0, 0, 'DressShop'),
	(650, 1097, 1, 'G3P2', '카를로스 더블시더', 8, 1, 0, 0, 'DressShop'),
	(651, 1098, 1, 'G3P2', '리엔 차이나드레스N', 5, 2, 0, 0, 'DressShop'),
	(652, 1099, 1, 'G3P2', '리엔 손목장식', 9, 2, 0, 0, 'DressShop'),
	(653, 1100, 1, 'G3P2', '리엔 신발', 7, 2, 0, 0, 'DressShop'),
	(654, 1101, 1, 'G3P2', '리엔 요리칼', 8, 2, 0, 0, 'DressShop'),
	(655, 1102, 1, 'Morden', '대감 관복(적)', 5, 1, 0, 0, 'DressShop2'),
	(656, 1103, 1, 'Shivan', '살라딘 시미터', 8, 1, 0, 0, 'DressShop'),
	(657, 1104, 1, 'Accessories', '칼린츠 인형(남)', 9, 1, 500, 250, 'AccessoryShop'),
	(658, 1105, 1, 'Accessories', '아도라 인형(남)', 9, 1, 500, 250, 'AccessoryShop'),
	(659, 1106, 1, 'Accessories', '칼린츠 인형(여)', 9, 2, 500, 250, 'AccessoryShop'),
	(660, 1107, 1, 'Accessories', '아도라 인형(여)', 9, 2, 500, 250, 'AccessoryShop'),
	(661, 1108, 1, 'Magnacarta', '칼린츠 상의', 5, 1, 0, 0, 'DressShop'),
	(662, 1109, 1, 'Magnacarta', '칼린츠 바지', 6, 1, 0, 0, 'DressShop'),
	(663, 1110, 1, 'Magnacarta', '칼린츠 외투', 5, 1, 0, 0, 'DressShop'),
	(664, 1111, 1, 'Magnacarta', '칼린츠 장갑', 9, 1, 0, 0, 'DressShop'),
	(665, 1112, 1, 'Magnacarta', '칼린츠 손목장식', 9, 1, 0, 0, 'DressShop'),
	(666, 1113, 1, 'Magnacarta', '칼린츠 허리장식', 9, 1, 0, 0, 'DressShop'),
	(667, 1114, 1, 'Magnacarta', '칼린츠 귀걸이', 9, 1, 0, 0, 'DressShop'),
	(668, 1115, 1, 'Magnacarta', '칼린츠 버선', 9, 1, 0, 0, 'DressShop'),
	(669, 1116, 1, 'Magnacarta', '칼린츠 신발', 7, 1, 0, 0, 'DressShop'),
	(670, 1117, 1, 'Magnacarta', '칼린츠 목걸이', 9, 1, 0, 0, 'DressShop'),
	(671, 1118, 1, 'Magnacarta', '칼린츠 소울블레이드L', 8, 1, 0, 0, 'DressShop'),
	(672, 1119, 1, 'Magnacarta', '페르난 상의', 5, 1, 0, 0, 'DressShop'),
	(673, 1120, 1, 'Magnacarta', '페르난 하의', 6, 1, 0, 0, 'DressShop'),
	(674, 1121, 1, 'Magnacarta', '페르난 가슴보호대', 5, 1, 0, 0, 'DressShop'),
	(675, 1122, 1, 'Magnacarta', '페르난 어깨보호대', 9, 1, 0, 0, 'DressShop'),
	(676, 1123, 1, 'Magnacarta', '페르난 허리보호대', 9, 1, 0, 0, 'DressShop'),
	(677, 1124, 1, 'Magnacarta', '페르난 장갑', 9, 1, 0, 0, 'DressShop'),
	(678, 1125, 1, 'Magnacarta', '페르난 손목보호대', 9, 1, 0, 0, 'DressShop'),
	(679, 1126, 1, 'Magnacarta', '페르난 신발', 7, 1, 0, 0, 'DressShop'),
	(680, 1127, 1, 'Magnacarta', '페르난 망토', 5, 1, 0, 0, 'DressShop'),
	(681, 1128, 1, 'Magnacarta', '페르난 참철검', 8, 1, 0, 0, 'DressShop'),
	(682, 1129, 1, 'Magnacarta', '로프마 머슬보디', 5, 1, 0, 0, 'DressShop'),
	(683, 1130, 1, 'Magnacarta', '로프마 바지', 6, 1, 0, 0, 'DressShop'),
	(684, 1131, 1, 'Magnacarta', '로프마 장갑', 9, 1, 0, 0, 'DressShop'),
	(685, 1132, 1, 'Magnacarta', '로프마 신발', 7, 1, 0, 0, 'DressShop'),
	(686, 1133, 1, 'Magnacarta', '로프마 귀걸이', 9, 1, 0, 0, 'DressShop'),
	(687, 1134, 1, 'Magnacarta', '로프마 핸드캐논', 8, 1, 0, 0, 'DressShop'),
	(688, 1135, 1, 'Magnacarta', '아도라 상의(노랑)', 5, 2, 0, 0, 'DressShop'),
	(689, 1136, 1, 'Magnacarta', '아도라 상의(주황)', 5, 2, 0, 0, 'DressShop'),
	(690, 1137, 1, 'Magnacarta', '아도라 치마(노랑)', 6, 2, 0, 0, 'DressShop'),
	(691, 1138, 1, 'Magnacarta', '아도라 치마(주황)', 6, 2, 0, 0, 'DressShop'),
	(692, 1139, 1, 'Magnacarta', '아도라 목장식(노랑)', 9, 2, 0, 0, 'DressShop'),
	(693, 1140, 1, 'Magnacarta', '아도라 목장식(주황)', 9, 2, 0, 0, 'DressShop'),
	(694, 1141, 1, 'Magnacarta', '아도라 손목장식', 9, 2, 0, 0, 'DressShop'),
	(695, 1142, 1, 'Magnacarta', '아도라 한쪽타이즈', 9, 2, 0, 0, 'DressShop'),
	(696, 1143, 1, 'Magnacarta', '아도라 신발(노랑)', 7, 2, 0, 0, 'DressShop'),
	(697, 1144, 1, 'Magnacarta', '아도라 신발(주황)', 7, 2, 0, 0, 'DressShop'),
	(698, 1145, 1, 'Magnacarta', '아도라 소울블레이드', 8, 2, 0, 0, 'DressShop'),
	(699, 1146, 1, 'Magnacarta', '쥬클레시아 원피스', 5, 2, 0, 0, 'DressShop'),
	(700, 1147, 1, 'Magnacarta', '쥬클레시아 손목장식', 9, 2, 0, 0, 'DressShop'),
	(701, 1148, 1, 'Magnacarta', '쥬클레시아 신발', 7, 2, 0, 0, 'DressShop'),
	(702, 1149, 1, 'Magnacarta', '쥬클레시아 노리개', 9, 2, 0, 0, 'DressShop'),
	(703, 1150, 1, 'Magnacarta', '첼시 상의', 5, 2, 0, 0, 'DressShop'),
	(704, 1151, 1, 'Magnacarta', '첼시 호박바지', 6, 2, 0, 0, 'DressShop'),
	(705, 1152, 1, 'Magnacarta', '첼시 장갑', 9, 2, 0, 0, 'DressShop'),
	(706, 1153, 1, 'Magnacarta', '첼시 신발', 7, 2, 0, 0, 'DressShop'),
	(707, 1154, 1, 'Magnacarta', '첼시 스태프', 8, 2, 0, 0, 'DressShop'),
	(708, 1155, 1, 'Fantasy', '성기사 상의(남)', 5, 1, 0, 0, 'DressShop2'),
	(709, 1156, 1, 'Fantasy', '성기사 갑옷(남)', 5, 1, 0, 0, 'DressShop2'),
	(710, 1157, 1, 'Fantasy', '성기사 장갑(남)', 9, 1, 0, 0, 'DressShop2'),
	(711, 1158, 1, 'Fantasy', '성기사 신발(남)', 7, 1, 0, 0, 'DressShop2'),
	(712, 1159, 1, 'Fantasy', '성기사 크로스소드', 8, 1, 0, 0, 'DressShop2'),
	(713, 1160, 1, 'Fantasy', '성기사 상의(여)', 5, 2, 0, 0, 'DressShop2'),
	(714, 1161, 1, 'Fantasy', '성기사 가슴보호대(여)', 5, 2, 0, 0, 'DressShop2'),
	(715, 1162, 1, 'Fantasy', '성기사 장갑(여)', 9, 2, 0, 0, 'DressShop2'),
	(716, 1163, 1, 'Fantasy', '성기사 신발(여)', 7, 2, 0, 0, 'DressShop2'),
	(717, 1164, 1, 'Fantasy', '성기사 쯔바이핸더', 8, 1, 0, 0, 'DressShop2'),
	(718, 1165, 1, 'Fantasy', '성기사 서고트(남)', 6, 1, 0, 0, 'DressShop2'),
	(719, 1166, 1, 'Fantasy', '성기사 서고트A(남)', 6, 1, 0, 0, 'DressShop2'),
	(720, 1167, 1, 'Fantasy', '성기사 서고트B(남)', 6, 1, 0, 0, 'DressShop2'),
	(721, 1168, 1, 'Fantasy', '성기사 서고트C(남)', 6, 1, 0, 0, 'DressShop2'),
	(722, 1169, 1, 'Fantasy', '성기사 서고트D(남)', 6, 1, 0, 0, 'DressShop2'),
	(723, 1170, 1, 'Fantasy', '성기사 서고트E(남)', 6, 1, 0, 0, 'DressShop2'),
	(724, 1171, 1, 'Fantasy', '성기사 서고트F(남)', 6, 1, 0, 0, 'DressShop2'),
	(725, 1172, 1, 'Fantasy', '성기사 서고트(여)', 6, 1, 0, 0, 'DressShop2'),
	(726, 1173, 1, 'Fantasy', '성기사 서고트A(여)', 6, 1, 0, 0, 'DressShop2'),
	(727, 1174, 1, 'Fantasy', '성기사 서고트B(여)', 6, 1, 0, 0, 'DressShop2'),
	(728, 1175, 1, 'Fantasy', '성기사 서고트C(여)', 6, 1, 0, 0, 'DressShop2'),
	(729, 1176, 1, 'Fantasy', '성기사 서고트D(여)', 6, 1, 0, 0, 'DressShop2'),
	(730, 1177, 1, 'Fantasy', '성기사 서고트E(여)', 6, 1, 0, 0, 'DressShop2'),
	(731, 1178, 1, 'Fantasy', '성기사 서고트F(여)', 6, 1, 0, 0, 'DressShop2'),
	(732, 1179, 1, 'Magnacarta', '칼린츠 가발', 3, 1, 23000, 11500, 'HairShop'),
	(733, 1180, 1, 'Magnacarta', '페르난 가발', 3, 1, 19500, 9750, 'HairShop'),
	(734, 1181, 1, 'Magnacarta', '로프마 가발', 3, 1, 17300, 8650, 'HairShop'),
	(735, 1182, 1, 'Magnacarta', '아도라 가발', 3, 2, 22000, 11000, 'HairShop'),
	(736, 1183, 1, 'Magnacarta', '쥬클레시아 가발', 3, 2, 21200, 10600, 'HairShop'),
	(737, 1184, 1, 'Magnacarta', '첼시 가발', 3, 2, 18000, 9000, 'HairShop'),
	(738, 1185, 1, 'Magnacarta', '칼린츠 소울블레이드R', 8, 1, 0, 0, 'DressShop'),
	(739, 1186, 1, 'G3P2', '리엔 차이나드레스A', 5, 2, 0, 0, 'DressShop'),
	(740, 1187, 1, 'Magnacarta', '카를로스 가발', 3, 1, 21850, 10925, 'HairShop'),
	(741, 1188, 1, 'G3P2', '리엔 가발', 3, 2, 17500, 8750, 'HairShop'),
	(742, 1189, 1, 'Magnacarta', '칼린츠 소울블레이드B', 8, 1, 0, 0, 'DressShop'),
	(743, 1190, 1, 'Apocalyse', '크리스티앙 가발', 3, 1, 16850, 8425, 'HairShop'),
	(744, 1191, 1, 'Apocalyse', '죠안 가발', 3, 2, 19230, 9615, 'HairShop'),
	(745, 1192, 1, 'Apocalyse', '크리스티앙 바지', 6, 1, 0, 0, 'DressShop'),
	(746, 1193, 1, 'Apocalyse', '크리스티앙 신발W', 7, 1, 0, 0, 'DressShop'),
	(747, 1194, 1, 'Apocalyse', '죠안 빨간귀걸이', 9, 2, 0, 0, 'DressShop'),
	(748, 1195, 1, 'Apocalyse', '죠안 검R Type-II', 8, 2, 0, 0, 'DressShop'),
	(749, 1196, 1, 'Accessories', '나른한 푸우모자', 4, 1, 450, 225, 'AccessoryShop'),
	(750, 1197, 1, 'Accessories', '만사태평 푸우모자', 4, 1, 450, 225, 'AccessoryShop'),
	(751, 1198, 1, 'Accessories', '말똥말똥 푸우모자', 4, 1, 450, 225, 'AccessoryShop'),
	(752, 1199, 1, 'Accessories', '못말리는 푸우모자', 4, 1, 450, 225, 'AccessoryShop'),
	(753, 1200, 1, 'Accessories', '나른한 푸우모자', 4, 2, 450, 225, 'AccessoryShop'),
	(754, 1201, 1, 'Accessories', '만사태평 푸우모자', 4, 2, 450, 225, 'AccessoryShop'),
	(755, 1202, 1, 'Accessories', '말똥말똥 푸우모자', 4, 2, 450, 225, 'AccessoryShop'),
	(756, 1203, 1, 'Accessories', '못말리는 푸우모자', 4, 2, 450, 225, 'AccessoryShop'),
	(757, 1204, 1, 'Life', '털모자(남)', 4, 1, 320, 160, 'AccessoryShop'),
	(758, 1205, 1, 'Life', '털모자(여)', 4, 2, 320, 160, 'AccessoryShop'),
	(759, 1206, 1, 'Morden', '카우보이모자(남)', 4, 1, 0, 0, 'DressShop2'),
	(760, 1207, 1, 'Weapone', '장창(남)', 8, 1, 1800, 900, 'AccessoryShop'),
	(761, 1208, 1, 'Weapone', '데쓰사이즈(여)', 8, 2, 1920, 960, 'AccessoryShop'),
	(762, 1209, 1, 'Weapone', '크로스보우(남)', 8, 1, 1750, 875, 'AccessoryShop'),
	(763, 1210, 1, 'Weapone', '크로스보우(여)', 8, 2, 1750, 875, 'AccessoryShop'),
	(764, 1211, 1, 'Accessories', '악마날개(남)', 9, 1, 3400, 1700, 'AccessoryShop'),
	(765, 1212, 1, 'Accessories', '악마날개(여)', 9, 2, 3400, 1700, 'AccessoryShop'),
	(766, 1213, 1, 'Fantasy', '하프엘프귀(남)', 9, 1, 0, 0, 'DressShop2'),
	(767, 1214, 1, 'Fantasy', '하프엘프귀(여)', 9, 2, 0, 0, 'DressShop2'),
	(768, 1215, 1, 'Fantasy', '하프엘프귀(나야)', 9, 2, 0, 0, 'DressShop2'),
	(769, 1216, 1, 'Fantasy', '미노타의뿔(여)', 9, 2, 0, 0, 'DressShop2'),
	(770, 1217, 1, 'Fantasy', '마녀의빗자루(여)', 9, 2, 0, 0, 'DressShop2'),
	(771, 1218, 1, 'Student', '기초원소학(남)', 9, 1, 2800, 1400, 'AccessoryShop'),
	(772, 1219, 1, 'Student', '기초원소학(여)', 9, 2, 2800, 1400, 'AccessoryShop'),
	(773, 1220, 1, 'Accessories', '곰돌이귀마개(남)', 9, 1, 2200, 1100, 'AccessoryShop'),
	(774, 1221, 1, 'Accessories', '토끼귀마개(여)', 9, 2, 2200, 1100, 'AccessoryShop'),
	(775, 1222, 1, 'Accessories', '날개귀(남)', 9, 1, 2400, 1200, 'AccessoryShop'),
	(776, 1223, 1, 'Accessories', '날개귀(여)', 9, 2, 2400, 1200, 'AccessoryShop'),
	(777, 1224, 1, 'Accessories', '발키리날개귀(여)', 9, 2, 2750, 1375, 'AccessoryShop'),
	(778, 1225, 1, 'Accessories', '토끼귀(여)', 9, 2, 2750, 1375, 'AccessoryShop'),
	(779, 1226, 1, 'Accessories', '라운드이어링(여)', 9, 2, 800, 400, 'AccessoryShop'),
	(780, 1227, 1, 'Accessories', '주사위귀걸이(여)', 9, 2, 800, 400, 'AccessoryShop'),
	(781, 1228, 1, 'Life', '바이올린(남)', 9, 1, 1900, 950, 'AccessoryShop'),
	(782, 1229, 1, 'Life', '바이올린(여)', 9, 2, 1900, 950, 'AccessoryShop'),
	(783, 1230, 1, 'Life', '일렉트릭기타(남)', 9, 1, 2200, 1100, 'AccessoryShop'),
	(784, 1231, 1, 'Morden', '복주머니(남)', 9, 1, 0, 0, 'DressShop2'),
	(785, 1232, 1, 'Morden', '복주머니(여)', 9, 2, 0, 0, 'DressShop2'),
	(786, 1233, 1, 'Morden', '포도대장 돌격검(남)', 8, 1, 0, 0, 'DressShop2'),
	(787, 1234, 1, 'Morden', '부채(여)', 9, 2, 0, 0, 'DressShop2'),
	(788, 1235, 1, 'Morden', '민속화관(여)', 4, 2, 0, 0, 'DressShop2'),
	(789, 1236, 1, 'Accessories', '민속귀걸이(여)', 9, 2, 800, 400, 'AccessoryShop'),
	(790, 1237, 1, 'Morden', '빨간머플러(남)', 9, 1, 0, 0, 'DressShop2'),
	(791, 1238, 1, 'Event', 'm4leaf토끼인형(남)', 9, 1, 0, 0, 'DressShop2'),
	(792, 1239, 1, 'Event', 'm4leaf토끼인형(여)', 9, 2, 0, 0, 'DressShop2'),
	(793, 1240, 1, 'Accessories', '루시안 인형(남)', 9, 1, 4500, 2250, 'AccessoryShop'),
	(794, 1241, 1, 'Accessories', '루시안 인형(여)', 9, 2, 4500, 2250, 'AccessoryShop'),
	(795, 1242, 1, 'Accessories', '막시민 인형(남)', 9, 1, 4500, 2250, 'AccessoryShop'),
	(796, 1243, 1, 'Accessories', '막시민 인형(여)', 9, 2, 4500, 2250, 'AccessoryShop'),
	(797, 1244, 1, 'Accessories', '조슈아 인형(남)', 9, 1, 4500, 2250, 'AccessoryShop'),
	(798, 1245, 1, 'Accessories', '조슈아 인형(여)', 9, 2, 4500, 2250, 'AccessoryShop'),
	(799, 1246, 1, 'Accessories', '보리스 인형(남)', 9, 1, 4500, 2250, 'AccessoryShop'),
	(800, 1247, 1, 'Accessories', '보리스 인형(여)', 9, 2, 4500, 2250, 'AccessoryShop'),
	(801, 1248, 1, 'Accessories', '란지에 인형(남)', 9, 1, 4500, 2250, 'AccessoryShop'),
	(802, 1249, 1, 'Accessories', '란지에 인형(여)', 9, 2, 4500, 2250, 'AccessoryShop'),
	(803, 1250, 1, 'Accessories', '시벨린 인형(남)', 9, 1, 4500, 2250, 'AccessoryShop'),
	(804, 1251, 1, 'Accessories', '시벨린 인형(여)', 9, 2, 4500, 2250, 'AccessoryShop'),
	(805, 1252, 1, 'Accessories', '이자크 인형(남)', 9, 1, 4500, 2250, 'AccessoryShop'),
	(806, 1253, 1, 'Accessories', '이자크 인형(여)', 9, 2, 4500, 2250, 'AccessoryShop'),
	(807, 1254, 1, 'Accessories', '이스핀 인형(남)', 9, 1, 4500, 2250, 'AccessoryShop'),
	(808, 1255, 1, 'Accessories', '이스핀 인형(여)', 9, 2, 4500, 2250, 'AccessoryShop'),
	(809, 1256, 1, 'Accessories', '티치엘 인형(남)', 9, 1, 4500, 2250, 'AccessoryShop'),
	(810, 1257, 1, 'Accessories', '티치엘 인형(여)', 9, 2, 4500, 2250, 'AccessoryShop'),
	(811, 1258, 1, 'Accessories', '클로에 인형(남)', 9, 1, 4500, 2250, 'AccessoryShop'),
	(812, 1259, 1, 'Accessories', '클로에 인형(여)', 9, 2, 4500, 2250, 'AccessoryShop'),
	(813, 1260, 1, 'Accessories', '아나벨 인형(남)', 9, 1, 4500, 2250, 'AccessoryShop'),
	(814, 1261, 1, 'Accessories', '아나벨 인형(여)', 9, 2, 4500, 2250, 'AccessoryShop'),
	(815, 1262, 1, 'Accessories', '나야 인형(남)', 9, 1, 4500, 2250, 'AccessoryShop'),
	(816, 1263, 1, 'Accessories', '나야 인형(여)', 9, 2, 4500, 2250, 'AccessoryShop'),
	(817, 1264, 1, 'Accessories', '밀라 인형(남)', 9, 1, 4500, 2250, 'AccessoryShop'),
	(818, 1265, 1, 'Accessories', '밀라 인형(여)', 9, 2, 4500, 2250, 'AccessoryShop'),
	(819, 1266, 1, 'Accessories', '벤야 인형(남)', 9, 1, 4500, 2250, 'AccessoryShop'),
	(820, 1267, 1, 'Accessories', '벤야 인형(여)', 9, 2, 4500, 2250, 'AccessoryShop'),
	(821, 1268, 1, 'Accessories', '산타 인형(남)', 9, 1, 1000, 500, 'AccessoryShop'),
	(822, 1269, 1, 'Accessories', '산타 인형(여)', 9, 2, 1000, 500, 'AccessoryShop'),
	(823, 1270, 1, 'Accessories', '루돌프 인형(남)', 9, 1, 800, 400, 'AccessoryShop'),
	(824, 1271, 1, 'Accessories', '루돌프 인형(여)', 9, 2, 800, 400, 'AccessoryShop'),
	(825, 1272, 1, 'Accessories', '루시안 성탄인형(남)', 9, 1, 5200, 2600, 'AccessoryShop'),
	(826, 1273, 1, 'Accessories', '루시안 성탄인형(여)', 9, 2, 5200, 2600, 'AccessoryShop'),
	(827, 1274, 1, 'Accessories', '조슈아 성탄인형(남)', 9, 1, 5200, 2600, 'AccessoryShop'),
	(828, 1275, 1, 'Accessories', '조슈아 성탄인형(여)', 9, 2, 5200, 2600, 'AccessoryShop'),
	(829, 1276, 1, 'Accessories', '시벨린 성탄인형(남)', 9, 1, 5200, 2600, 'AccessoryShop'),
	(830, 1277, 1, 'Accessories', '시벨린 성탄인형(여)', 9, 2, 5200, 2600, 'AccessoryShop'),
	(831, 1278, 1, 'Accessories', '클로에 성탄인형(남)', 9, 1, 5200, 2600, 'AccessoryShop'),
	(832, 1279, 1, 'Accessories', '클로에 성탄인형(여)', 9, 2, 5200, 2600, 'AccessoryShop'),
	(833, 1280, 1, 'Accessories', '아나벨 성탄인형(남)', 9, 1, 5200, 2600, 'AccessoryShop'),
	(834, 1281, 1, 'Accessories', '아나벨 성탄인형(여)', 9, 2, 5200, 2600, 'AccessoryShop'),
	(835, 1282, 1, 'Accessories', '밀라 성탄인형(남)', 9, 1, 5200, 2600, 'AccessoryShop'),
	(836, 1283, 1, 'Accessories', '밀라 성탄인형(여)', 9, 2, 5200, 2600, 'AccessoryShop'),
	(837, 1284, 1, 'Event', '성년축하 꽃송이(남)', 9, 1, 0, 0, 'DressShop2'),
	(838, 1285, 1, 'Event', '성년축하 꽃송이(여)', 9, 2, 0, 0, 'DressShop2'),
	(839, 1286, 1, 'Event', '석가탄신일 연등(남)', 9, 1, 0, 0, 'DressShop2'),
	(840, 1287, 1, 'Event', '석가탄신일 연등(여)', 9, 2, 0, 0, 'DressShop2'),
	(841, 1288, 1, 'Morden', '동자승 가발(남)', 3, 1, 8000, 4000, 'HairShop'),
	(842, 1289, 1, 'Morden', '동자승 가발(여)', 3, 2, 8000, 4000, 'HairShop'),
	(843, 1290, 1, 'Sport', '축구유니폼 셔츠(남)', 5, 1, 800, 400, 'AccessoryShop'),
	(844, 1291, 1, 'Sport', '축구유니폼 바지(남)', 6, 1, 800, 400, 'AccessoryShop'),
	(845, 1292, 1, 'Sport', '축구유니폼 셔츠(남)', 5, 1, 800, 400, 'AccessoryShop'),
	(846, 1293, 1, 'Sport', '축구유니폼 바지(여)', 6, 2, 800, 400, 'AccessoryShop'),
	(847, 1294, 1, 'Sport', '축구양말(남)', 9, 1, 500, 250, 'AccessoryShop'),
	(848, 1295, 1, 'Sport', '축구양말(여)', 9, 2, 500, 250, 'AccessoryShop'),
	(849, 1296, 1, 'Sport', '축구화(남)', 7, 1, 600, 300, 'AccessoryShop'),
	(850, 1297, 1, 'Sport', '축구화(여)', 7, 2, 600, 300, 'AccessoryShop'),
	(851, 1298, 1, 'Sport', '축구공 포립노바(남)', 9, 1, 930, 465, 'AccessoryShop'),
	(852, 1299, 1, 'Sport', '축구공 포립노바(여)', 9, 2, 930, 465, 'AccessoryShop'),
	(853, 1300, 1, 'Sport', '응원용 태극기(남)', 9, 1, 300, 150, 'AccessoryShop'),
	(854, 1301, 1, 'Sport', '응원용 태극기(여)', 9, 2, 300, 150, 'AccessoryShop'),
	(855, 1302, 1, 'Event', '4LEAF 귀걸이 골드(여)', 9, 2, 0, 0, 'DressShop2'),
	(856, 1303, 1, 'Event', '4LEAF 귀걸이 골드(남)', 9, 1, 0, 0, 'DressShop2'),
	(857, 1304, 1, 'Event', '4LEAF 귀걸이 하늘(여)', 9, 2, 0, 0, 'DressShop2'),
	(858, 1305, 1, 'Event', '4LEAF 귀걸이 하늘(남)', 9, 1, 0, 0, 'DressShop2'),
	(859, 1306, 1, 'Event', '4LEAF 귀걸이 핑크(여)', 9, 2, 0, 0, 'DressShop2'),
	(860, 1307, 1, 'Event', '4LEAF 귀걸이 핑크(남)', 9, 1, 0, 0, 'DressShop2'),
	(861, 1308, 1, 'Life', '의사 모자', 4, 1, 300, 150, 'AccessoryShop'),
	(862, 1309, 1, 'Life', '의사 상의', 5, 1, 500, 250, 'AccessoryShop'),
	(863, 1310, 1, 'Life', '의사 하의', 6, 1, 400, 200, 'AccessoryShop'),
	(864, 1311, 1, 'Life', '의사 구두', 7, 1, 450, 225, 'AccessoryShop'),
	(865, 1312, 1, 'Life', '의사 마스크', 9, 1, 500, 250, 'AccessoryShop'),
	(866, 1313, 1, 'Life', '의사 흰가운', 5, 1, 450, 225, 'AccessoryShop'),
	(867, 1314, 1, 'Life', '의사 메스', 8, 1, 300, 150, 'AccessoryShop'),
	(868, 1315, 1, 'Life', '간호사 모자', 4, 2, 300, 150, 'AccessoryShop'),
	(869, 1316, 1, 'Life', '간호사 상의', 5, 2, 500, 250, 'AccessoryShop'),
	(870, 1317, 1, 'Life', '간호사 치마', 6, 2, 400, 200, 'AccessoryShop'),
	(871, 1318, 1, 'Life', '간호사 스타킹', 6, 2, 350, 175, 'AccessoryShop'),
	(872, 1319, 1, 'Life', '간호사 가운', 5, 2, 450, 225, 'AccessoryShop'),
	(873, 1320, 1, 'Life', '간호사 슬리퍼', 7, 2, 450, 225, 'AccessoryShop'),
	(874, 1321, 1, 'Life', '간호사 진찰일지', 8, 2, 320, 160, 'AccessoryShop'),
	(875, 1322, 1, 'Life', '간호사 주사', 8, 2, 370, 185, 'AccessoryShop'),
	(876, 1323, 1, 'Life', '신부 상의', 5, 1, 600, 300, 'AccessoryShop'),
	(877, 1324, 1, 'Life', '신부 바지', 6, 1, 540, 270, 'AccessoryShop'),
	(878, 1325, 1, 'Life', '신부 제의', 5, 1, 620, 310, 'AccessoryShop'),
	(879, 1326, 1, 'Life', '신부 구두', 7, 1, 500, 250, 'AccessoryShop'),
	(880, 1327, 1, 'Life', '신부 십자가', 8, 1, 450, 225, 'AccessoryShop'),
	(881, 1328, 1, 'Life', '신부 성경책', 8, 1, 420, 210, 'AccessoryShop'),
	(882, 1329, 1, 'Life', '수녀 상의', 5, 2, 600, 300, 'AccessoryShop'),
	(883, 1330, 1, 'Life', '수녀 치마', 6, 2, 540, 270, 'AccessoryShop'),
	(884, 1331, 1, 'Life', '수녀 두건', 4, 2, 370, 185, 'AccessoryShop'),
	(885, 1332, 1, 'Life', '수녀 구두', 7, 2, 480, 240, 'AccessoryShop'),
	(886, 1333, 1, 'Life', '수녀 성경책', 8, 2, 420, 210, 'AccessoryShop'),
	(887, 1334, 1, 'Life', '수녀 묵주', 8, 2, 410, 205, 'AccessoryShop'),
	(888, 1335, 1, 'Life', '요리사 상의(남)', 5, 1, 580, 290, 'AccessoryShop'),
	(889, 1336, 1, 'Life', '요리사 바지(남)', 6, 1, 530, 265, 'AccessoryShop'),
	(890, 1337, 1, 'Life', '요리사 앞치마(남)', 6, 1, 520, 260, 'AccessoryShop'),
	(891, 1338, 1, 'Life', '요리사 구두(남)', 7, 1, 500, 250, 'AccessoryShop'),
	(892, 1339, 1, 'Life', '요리사 모자(남)', 4, 1, 450, 225, 'AccessoryShop'),
	(893, 1340, 1, 'Life', '요리사 요리칼(남)L', 8, 1, 600, 300, 'AccessoryShop'),
	(894, 1341, 1, 'Life', '요리사 요리칼(남)S', 8, 1, 600, 300, 'AccessoryShop'),
	(895, 1342, 1, 'Life', '요리사 상의(여)', 5, 2, 580, 290, 'AccessoryShop'),
	(896, 1343, 1, 'Life', '요리사 바지(여)', 6, 2, 530, 265, 'AccessoryShop'),
	(897, 1344, 1, 'Life', '요리사 앞치마(여)', 6, 2, 520, 260, 'AccessoryShop'),
	(898, 1345, 1, 'Life', '요리사 구두(여)', 7, 2, 500, 250, 'AccessoryShop'),
	(899, 1346, 1, 'Life', '요리사 모자(여)', 4, 2, 450, 225, 'AccessoryShop'),
	(900, 1347, 1, 'Life', '요리사 왕포크(여)', 8, 2, 600, 300, 'AccessoryShop'),
	(901, 1348, 1, 'Life', '요리사 프라이팬(여)', 8, 2, 620, 310, 'AccessoryShop'),
	(902, 1349, 1, 'Morden', '감모자(남)', 4, 1, 0, 0, 'DressShop2'),
	(903, 1350, 1, 'Morden', '배모자(남)', 4, 1, 0, 0, 'DressShop2'),
	(904, 1351, 1, 'Morden', '사과모자(남)', 4, 1, 0, 0, 'DressShop2'),
	(905, 1352, 1, 'Morden', '밤모자(남)', 4, 1, 0, 0, 'DressShop2'),
	(906, 1353, 1, 'Morden', '감모자(여)', 4, 2, 0, 0, 'DressShop2'),
	(907, 1354, 1, 'Morden', '배모자(여)', 4, 2, 0, 0, 'DressShop2'),
	(908, 1355, 1, 'Morden', '사과모자(여)', 4, 2, 0, 0, 'DressShop2'),
	(909, 1356, 1, 'Morden', '밤모자(여)', 4, 2, 0, 0, 'DressShop2'),
	(910, 1357, 1, 'Morden', '윷가락(남)', 9, 1, 0, 0, 'DressShop2'),
	(911, 1358, 1, 'Morden', '윷가락(여)', 9, 2, 0, 0, 'DressShop2'),
	(912, 1359, 1, 'Morden', '제가(남)', 9, 1, 0, 0, 'DressShop2'),
	(913, 1360, 1, 'Morden', '제가(여)', 9, 2, 0, 0, 'DressShop2'),
	(914, 1361, 1, 'Event', '특선목도리(빨강)', 9, 1, 0, 0, 'DressShop2'),
	(915, 1362, 1, 'Event', '특선목도리(빨강)', 9, 2, 0, 0, 'DressShop2'),
	(916, 1363, 1, 'Event', '특선목도리(주황)', 9, 1, 0, 0, 'DressShop2'),
	(917, 1364, 1, 'Event', '특선목도리(주황)', 9, 2, 0, 0, 'DressShop2'),
	(918, 1365, 1, 'Event', '특선목도리(노랑)', 9, 1, 0, 0, 'DressShop2'),
	(919, 1366, 1, 'Event', '특선목도리(노랑)', 9, 2, 0, 0, 'DressShop2'),
	(920, 1367, 1, 'Event', '특선목도리(초록)', 9, 1, 0, 0, 'DressShop2'),
	(921, 1368, 1, 'Event', '특선목도리(초록)', 9, 2, 0, 0, 'DressShop2'),
	(922, 1369, 1, 'Event', '특선목도리(파랑)', 9, 1, 0, 0, 'DressShop2'),
	(923, 1370, 1, 'Event', '특선목도리(파랑)', 9, 2, 0, 0, 'DressShop2'),
	(924, 1371, 1, 'Event', '특선목도리(남색)', 9, 1, 0, 0, 'DressShop2'),
	(925, 1372, 1, 'Event', '특선목도리(남색)', 9, 2, 0, 0, 'DressShop2'),
	(926, 1373, 1, 'Event', '특선목도리(보라)', 9, 1, 0, 0, 'DressShop2'),
	(927, 1374, 1, 'Event', '특선목도리(보라)', 9, 2, 0, 0, 'DressShop2'),
	(928, 1375, 1, 'Student', '화가의 대붓(남)', 9, 1, 650, 325, 'AccessoryShop'),
	(929, 1376, 1, 'Student', '화가의 대붓(여)', 9, 2, 650, 325, 'AccessoryShop'),
	(930, 1377, 1, 'Student', '화가의 소붓(남)', 9, 1, 520, 260, 'AccessoryShop'),
	(931, 1378, 1, 'Student', '화가의 소붓(여)', 9, 2, 520, 260, 'AccessoryShop'),
	(932, 1379, 1, 'Student', '화가의 물감(남)', 9, 1, 500, 250, 'AccessoryShop'),
	(933, 1380, 1, 'Student', '화가의 물감(여)', 9, 2, 500, 250, 'AccessoryShop'),
	(934, 1381, 1, 'Student', '작가의 대펜(남)', 9, 1, 650, 325, 'AccessoryShop'),
	(935, 1382, 1, 'Student', '작가의 대펜(여)', 9, 2, 650, 325, 'AccessoryShop'),
	(936, 1383, 1, 'Student', '작가의 잉크(남)', 9, 1, 500, 250, 'AccessoryShop'),
	(937, 1384, 1, 'Student', '작가의 잉크(여)', 9, 2, 500, 250, 'AccessoryShop'),
	(938, 1385, 1, 'Accessories', '월계관(남)', 4, 1, 950, 475, 'AccessoryShop'),
	(939, 1386, 1, 'Accessories', '월계관(여)', 4, 2, 950, 475, 'AccessoryShop'),
	(940, 1387, 1, 'Event', '4LEAF풍선(빨강)', 8, 1, 3500, 1750, 'AccessoryShop'),
	(941, 1388, 1, 'Event', '4LEAF풍선(빨강)', 8, 2, 3500, 1750, 'AccessoryShop'),
	(942, 1389, 1, 'Event', '4LEAF풍선(주황)', 8, 1, 3500, 1750, 'AccessoryShop'),
	(943, 1390, 1, 'Event', '4LEAF풍선(주황)', 8, 2, 3500, 1750, 'AccessoryShop'),
	(944, 1391, 1, 'Event', '4LEAF풍선(노랑)', 8, 1, 3500, 1750, 'AccessoryShop'),
	(945, 1392, 1, 'Event', '4LEAF풍선(노랑)', 8, 2, 3500, 1750, 'AccessoryShop'),
	(946, 1393, 1, 'Event', '4LEAF풍선(초록)', 8, 1, 3500, 1750, 'AccessoryShop'),
	(947, 1394, 1, 'Event', '4LEAF풍선(초록)', 8, 2, 3500, 1750, 'AccessoryShop'),
	(948, 1395, 1, 'Event', '4LEAF풍선(파랑)', 8, 1, 3500, 1750, 'AccessoryShop'),
	(949, 1396, 1, 'Event', '4LEAF풍선(파랑)', 8, 2, 3500, 1750, 'AccessoryShop'),
	(950, 1397, 1, 'Event', '4LEAF풍선(남색)', 8, 1, 3500, 1750, 'AccessoryShop'),
	(951, 1398, 1, 'Event', '4LEAF풍선(남색)', 8, 2, 3500, 1750, 'AccessoryShop'),
	(952, 1399, 1, 'Event', '4LEAF풍선(보라)', 8, 1, 3500, 1750, 'AccessoryShop'),
	(953, 1400, 1, 'Event', '4LEAF풍선(보라)', 8, 2, 3500, 1750, 'AccessoryShop'),
	(954, 1401, 1, 'Morden', '장미꽃바구니(남)', 8, 1, 0, 0, 'DressShop2'),
	(955, 1402, 1, 'Morden', '장미꽃바구니(여)', 8, 2, 0, 0, 'DressShop2'),
	(956, 1403, 1, 'Accessories', '왕하트머리핀(남)', 9, 1, 7500, 3750, 'AccessoryShop'),
	(957, 1404, 1, 'Accessories', '왕하트머리핀(여)', 9, 2, 7500, 3750, 'AccessoryShop'),
	(958, 1405, 1, 'Accessories', '작은하트머리핀(남)', 9, 1, 6800, 3400, 'AccessoryShop'),
	(959, 1406, 1, 'Accessories', '작은하트머리핀(여)', 9, 2, 6800, 3400, 'AccessoryShop'),
	(960, 1407, 1, 'Accessories', '왕하트목걸이(남)', 9, 1, 6300, 3150, 'AccessoryShop'),
	(961, 1408, 1, 'Accessories', '왕하트목걸이(여)', 9, 2, 6300, 3150, 'AccessoryShop'),
	(962, 1409, 1, 'Accessories', '작은하트목걸이(남)', 9, 1, 6500, 3250, 'AccessoryShop'),
	(963, 1410, 1, 'Accessories', '작은하트목걸이(여)', 9, 2, 6500, 3250, 'AccessoryShop'),
	(964, 1411, 1, 'Accessories', '왕사랑리본(남)', 9, 1, 7200, 3600, 'AccessoryShop'),
	(965, 1412, 1, 'Accessories', '왕사랑리본(여)', 9, 2, 7200, 3600, 'AccessoryShop'),
	(966, 1413, 1, 'Accessories', '사랑리본(남)', 9, 1, 6000, 3000, 'AccessoryShop'),
	(967, 1414, 1, 'Accessories', '사랑리본(여)', 9, 2, 6000, 3000, 'AccessoryShop'),
	(968, 1415, 1, 'Event', '페스티발걸 상의(노랑)', 5, 2, 0, 0, 'DressShop2'),
	(969, 1416, 1, 'Event', '페스티발걸 상의(주황)', 5, 2, 0, 0, 'DressShop2'),
	(970, 1417, 1, 'Event', '페스티발걸 치마', 6, 2, 0, 0, 'DressShop2'),
	(971, 1418, 1, 'Event', '페스티발걸 장갑', 9, 2, 0, 0, 'DressShop2'),
	(972, 1419, 1, 'Event', '페스티발걸 부츠(노랑)', 7, 2, 0, 0, 'DressShop2'),
	(973, 1420, 1, 'Event', '페스티발걸 부츠(주황)', 7, 2, 0, 0, 'DressShop2'),
	(974, 1421, 1, 'Event', '페스티발걸 덧옷(노랑)', 6, 2, 0, 0, 'DressShop2'),
	(975, 1422, 1, 'Event', '페스티발걸 덧옷(주황)', 6, 2, 0, 0, 'DressShop2'),
	(976, 1423, 1, 'Event', '페스티발 티셔츠(노랑)', 5, 1, 0, 0, 'DressShop2'),
	(977, 1424, 1, 'Event', '페스티발 티셔츠(노랑)', 5, 2, 0, 0, 'DressShop2'),
	(978, 1425, 1, 'Event', '페스티발 티셔츠(검정)', 5, 1, 0, 0, 'DressShop2'),
	(979, 1426, 1, 'Event', '페스티발 티셔츠(검정)', 5, 2, 0, 0, 'DressShop2'),
	(980, 1427, 1, 'Event', '페스티발걸 가발', 3, 2, 33200, 16600, 'HairShop'),
	(981, 1428, 1, 'Event', '이벤트 핸드폰(남)', 9, 1, 0, 0, 'DressShop2'),
	(982, 1429, 1, 'Event', '이벤트 핸드폰(여)', 9, 2, 0, 0, 'DressShop2'),
	(983, 1430, 1, 'Event', '이벤트 핸드폰(나야)', 9, 2, 0, 0, 'DressShop2');
/*!40000 ALTER TABLE `tbl_iteminfo` ENABLE KEYS */;

-- 테이블 4leaf.tbl_user 구조 내보내기
DROP TABLE IF EXISTS `tbl_user`;
CREATE TABLE IF NOT EXISTS `tbl_user` (
  `f_UID` bigint(20) NOT NULL AUTO_INCREMENT,
  `f_ID` varchar(30) COLLATE utf8_bin NOT NULL,
  `f_Password` varchar(255) COLLATE utf8_bin NOT NULL,
  `f_Gender` tinyint(3) unsigned NOT NULL,
  `f_LoginTime` int(11) NOT NULL,
  `f_LastLogin` datetime NOT NULL,
  PRIMARY KEY (`f_UID`),
  KEY `IDSearch` (`f_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- 테이블 데이터 4leaf.tbl_user:~0 rows (대략적) 내보내기
DELETE FROM `tbl_user`;
/*!40000 ALTER TABLE `tbl_user` DISABLE KEYS */;
INSERT INTO `tbl_user` (`f_UID`, `f_ID`, `f_Password`, `f_Gender`, `f_LoginTime`, `f_LastLogin`) VALUES
	(1, 'j1598', '0911C993B9B031810949BBDF69D8D688', 1, 0, '2017-10-06 15:17:49');
/*!40000 ALTER TABLE `tbl_user` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
