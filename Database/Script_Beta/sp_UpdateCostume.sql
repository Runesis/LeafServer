DROP PROCEDURE IF EXISTS sp_UpdateCostume;

DELIMITER //
CREATE PROCEDURE sp_UpdateCostume(
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
	
END; //
DELIMITER ;