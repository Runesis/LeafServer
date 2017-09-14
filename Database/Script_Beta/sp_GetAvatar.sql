DROP PROCEDURE IF EXISTS sp_GetAvatar;

DELIMITER //
CREATE PROCEDURE sp_GetAvatar(inAccountID VARCHAR(30))
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
END; //
DELIMITER ;