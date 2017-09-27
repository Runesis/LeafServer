DROP PROCEDURE IF EXISTS sp_CreateAvatar;

DELIMITER //
CREATE PROCEDURE sp_CreateAvatar(
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

END; //
DELIMITER ;

/*
	SELECT COUNT(*) INTO @AvatarCount
	FROM tbl_Avatar
	WHERE f_UID = 1;
	SELECT @AvatarCount;

	SET @Temp = -1;
	#INSERT INTO tbl_Avatar(f_UID, f_Order, f_CID, f_Name, f_BodyBack, f_BodyFront, f_Hair, f_Clothes, f_Pants, f_Shoes)
	VALUES(@UID, @AvatarCount, 0, '', @Temp, @Temp, @Temp, @Temp, @Temp, @Temp);
*/