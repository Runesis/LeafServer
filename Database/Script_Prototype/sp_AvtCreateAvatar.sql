USE [4Leaf]
GO
/****** Object:  StoredProcedure [dbo].[sp_AvtCreateAvatar]    Script Date: 03/20/2012 10:31:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NightStorm
-- Create date: 2011-11-24 15:30
-- Description:	아바타 생성
-- =============================================
ALTER PROCEDURE [dbo].[sp_AvtCreateAvatar]
@v_uid int,
@v_aorder int,
@v_character int,
@v_nick varchar(22),
@v_clothes int,
@v_trousers int,
@v_shoes int,
@retVal int OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @nAid int
	SET @nAid = 0

	INSERT INTO avatar(uid, aorder, character, nick, access_time, l_acc_time)
	VALUES
	(@v_uid, @v_aorder, @v_character, @v_nick, GETDATE(), GETDATE())
	
	SELECT TOP(1) @nAid = aid from avatar WHERE uid = @v_uid ORDER BY aid DESC
	
	IF(@nAid > 0)
	BEGIN
		INSERT INTO inventory(aid, itemidx, itemtype, gettime)
		VALUES
		(@nAid, @v_clothes, (SELECT TOP(1) mount_number FROM item WHERE i_index = @v_clothes), GETDATE())
		INSERT INTO inventory(aid, itemidx, itemtype, gettime)
		VALUES
		(@nAid, @v_trousers, (SELECT TOP(1) mount_number FROM item WHERE i_index = @v_trousers), GETDATE())
		INSERT INTO inventory(aid, itemidx, itemtype, gettime)
		VALUES
		(@nAid, @v_shoes, (SELECT TOP(1) mount_number FROM item WHERE i_index = @v_shoes), GETDATE())
		
		INSERT INTO avatar_costume (aid, clothes, trousers, shoes) VALUES (@nAid, @v_clothes, @v_trousers, @v_shoes)
	END
	ELSE
	BEGIN
		SET @retVal = -1;
	END
	
END
