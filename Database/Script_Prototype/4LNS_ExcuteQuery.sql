SELECT TOP(1)
AVT.aid, AVT.uid, AVT.aorder, AVT.character, AVT.nick, AVT.knight, AVT.gp, AVT.fp,
AVT.bodyback, AVT.bodyfront, AVT.hair, AVT.hairacc, AVT.clothes, AVT.clothes_2, AVT.clothes_3,
trousers, AVT.trousers_2, AVT.trousers_3, AVT.shoes, AVT.weapon, AVT.weapon_2,
accessory1, AVT.accessory2, AVT.accessory3, AVT.accessory4, AVT.accessory5,
accessory6, AVT.accessory7, AVT.accessory8, AVT.accessory9, AVT.accessory10,
access_time, AVT.l_acc_time
FROM avatar AVT, account ACC
WHERE
	ACC.sid = 'admin' AND
	ACC.uid = AVT.uid;
	
	
INSERT INTO avatar(uid, aorder, character, nick, access_time, l_acc_time) VALUES(1, 1, 3, 'NightStorm00', GETDATE())
SELECT aid FROM avatar WHERE nick='NightStorm00';

INSERT INTO inventory(aid, itemidx, itemtype, gettime) values(1, 1085, (SELECT TOP(1) mount_number FROM item WHERE i_index=1085), GETDATE())

SELECT * FROM item WHERE i_index = 988;


TRUNCATE TABLE account
TRUNCATE TABLE avatar
TRUNCATE TABLE inventory
TRUNCATE TABLE avatar_costume
