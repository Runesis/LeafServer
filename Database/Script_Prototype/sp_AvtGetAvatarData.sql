USE [4Leaf]
GO
/****** Object:  StoredProcedure [dbo].[sp_AvtGetAvatarData]    Script Date: 04/09/2012 17:06:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NightStorm
-- Create date: 2011-11-24 16:10
-- Description:	아바타 정보 얻기
-- =============================================
ALTER PROCEDURE [dbo].[sp_AvtGetAvatarData]
@v_Sid VARCHAR(16)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT TOP(1)
		AVT.aid, AVT.uid, AVT.aorder, AVT.character, AVT.nick, AVT.knight, AVT.gp, AVT.fp, AVT.access_time,
		COSTUME.bodyback, COSTUME.bodyfront, COSTUME.hair, COSTUME.hairacc, COSTUME.clothes, COSTUME.clothes_2, COSTUME.clothes_3,
		COSTUME.trousers, COSTUME.trousers_2, COSTUME.trousers_3, COSTUME.shoes, COSTUME.weapon, COSTUME.weapon_2, 
		COSTUME.accessory1, COSTUME.accessory2, COSTUME.accessory3, COSTUME.accessory4, COSTUME.accessory5, COSTUME.accessory6,
		COSTUME.accessory7, COSTUME.accessory8, COSTUME.accessory9, COSTUME.accessory10
	FROM
		avatar AS AVT,
		avatar_costume AS COSTUME,
		account AS ACC
	WHERE
		ACC.sid = @v_Sid AND
		ACC.uid = AVT.uid AND
		COSTUME.aid = AVT.aid
	
END
