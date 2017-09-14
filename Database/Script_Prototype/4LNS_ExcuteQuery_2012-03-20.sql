
DECLARE @retVal INT
if( EXISTS(SELECT 1 FROM account WHERE sid = 'admin' AND password = 'test') )
	SET @retVal = 0
ELSE
	SET @retVal = -1
SELECT @retVal
	
INSERT INTO avatar(uid, aorder, character, nick, access_time, l_acc_time) VALUES(1, 1, 3, 'NightStorm00', GETDATE())
SELECT aid FROM avatar WHERE nick='NightStorm00';

INSERT INTO inventory(aid, itemidx, itemtype, gettime) values(1, 1085, (SELECT TOP(1) mount_number FROM item WHERE i_index=1085), GETDATE())

SELECT * FROM item WHERE i_index = 988;


SELECT TOP(1)
		AVT.aid, AVT.uid, AVT.aorder, AVT.character, AVT.nick, AVT.knight, AVT.gp, AVT.fp, AVT.access_time, AVT.l_acc_time,
		COSTUME.bodyback, COSTUME.bodyfront, COSTUME.hair, COSTUME.hairacc, COSTUME.clothes, COSTUME.clothes_2, COSTUME.clothes_3,
		COSTUME.trousers, COSTUME.trousers_2, COSTUME.trousers_3, COSTUME.shoes, COSTUME.weapon, COSTUME.weapon_2, 
		COSTUME.accessory1, COSTUME.accessory2, COSTUME.accessory3, COSTUME.accessory4, COSTUME.accessory5, COSTUME.accessory6,
		COSTUME.accessory7, COSTUME.accessory8, COSTUME.accessory9, COSTUME.accessory10
FROM
	avatar AS AVT,
	avatar_costume AS COSTUME,
	account AS ACC
WHERE
	ACC.sid = 'admin' AND
	ACC.uid = AVT.uid AND
	COSTUME.aid = AVT.aid
		


UPDATE avatar_costume
SET
	hair = @v_Hair, hairacc = @v_HairAcc, clothes = @v_Clothes, clothes_2 = @v_Clothes2, clothes_3 = @v_Clothes3,
	trousers = @v_Pants, trousers_2 = @v_Pants2, trousers_3 = @v_Pants3, shoes = @v_Shoes, weapon = @v_Weapon, weapon_2 = @v_Weapon2,
	accessory1 = @v_Acc1, accessory2 = @v_Acc2, accessory3 = @v_Acc3, accessory4 = @v_Acc4, accessory5 = @v_Acc5, accessory6 = @v_Acc6,
	accessory7 = @v_Acc7, accessory8 = @v_Acc8, accessory9 = @v_Acc9, accessory10 = @v_Acc10
WHERE
	aid = @v_Aid;







		
TRUNCATE TABLE account
TRUNCATE TABLE avatar
TRUNCATE TABLE inventory
TRUNCATE TABLE avatar_costume
