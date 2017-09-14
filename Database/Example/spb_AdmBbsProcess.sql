SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO





ALTER       Proc dbo.spb_AdmBbsProcess
/*
////////////////////////////////////////////////////////////////////////
//
// ���ν����� : �Խ��� �� �з� / �߰�, ����, ����
// �� �� �� : �����(jjadoll@softmax.co.kr)
// �� �� �� : 2011-11-18 AM 11:00
// ���������� : 
// �� �� �� : 
// �� �� �� : 
	--
// N O T E :
//
////////////////////////////////////////////////////////////////////////
*/ 
(
@v_ProType int,					-- ���� ���� ( 1/2 : CATEGORY/BBS)
@v_ProMethod VARCHAR(15), 			-- ���� ���� ( ADD/EDIT/DELETE)
@v_MenuId VARCHAR(50),				-- �޴� ID
@v_MenuName VARCHAR(50),			-- �޴� �̸�
@v_ChgMenuName VARCHAR(50),			-- ���� �޴� �̸�
@v_BbsIdx VARCHAR(50),				-- �Խ��� ID
@v_BbsName VARCHAR(50),			-- �Խ��� �̸�
@v_ChgBbsName VARCHAR(50),			-- ���� �Խ��� �̸�
@v_BbsClass INT,				-- 1/2 : �Ϲ�/TSG
@v_ApplyFileType VARCHAR(100),			-- ���Ǵ� ���� ����
@v_MaxFilesize INT,				-- �ִ� ���� ũ��
@v_Link VARCHAR(512),
@v_RetVal INT OUTPUT				-- 0/1/2 : ����/�Խ��� ����/�Խ��� ����
)
AS

SET NOCOUNT ON 
SET XACT_ABORT ON

SET @v_RetVal = 0

DECLARE @v_LastMOrder INT
DECLARE @v_LastBId INT
DECLARE @v_LastBOrder INT

IF @v_ProType = '1'
BEGIN
	IF @v_ProMethod = 'ADD'
	BEGIN
		IF EXISTS(SELECT 1 FROM tblb_BbsMenu WHERE f_menuname = @v_MenuName)
		BEGIN
			SET @v_RetVal = 1
			RETURN
		END
		ELSE
		BEGIN
			SET @v_LastMOrder = (SELECT MAX(f_menuorder)+1 FROM tblb_BbsMenu)
			SET @v_LastMOrder = ISNULL(@v_LastMOrder, 1)

			INSERT INTO tblb_BbsMenu (f_menuid, f_menuname, f_bbsidx, f_bbsname, f_bbsclass, f_applyattfileext, f_maxattfilesize, f_link, f_menuorder, f_bbsorder, f_regdate)
			VALUES (@v_MenuId, @v_MenuName, 1, '�⺻�Խ���', @v_BbsClass, null, 0, null, @v_LastMOrder, 1, getdate())
			IF @@ERROR <> 0 GOTO errorHandler

			IF @v_BbsClass = 1
				EXEC spb_GenBbsTableCreate @v_MenuId, @v_RetVal OUTPUT
			ELSE IF @v_BbsClass = 2
				EXEC spb_TsgBbsTableCreate @v_MenuId, @v_RetVal OUTPUT
		END
	END
	ELSE IF @v_ProMethod = 'EDIT'
	BEGIN
		UPDATE tblb_BbsMenu
		SET f_menuname = @v_MenuName, f_bbsclass = @v_BbsClass
		WHERE f_menuid = @v_MenuId
	END
	ELSE IF @v_ProMethod = 'DELETE'
	BEGIN
		DECLARE @v_TempMenuOrder INT
		SELECT @v_TempMenuOrder = f_menuorder FROM tblb_BbsMenu WHERE f_menuid = @v_MenuId

		DELETE FROM tblb_BbsMenu WHERE f_menuid = @v_MenuId
		IF @@ERROR <> 0 GOTO errorHandler
		
		UPDATE tblb_BbsMenu
		SET f_menuorder = f_menuorder - 1
		WHERE f_menuorder > @v_TempMenuOrder
		IF @@ERROR <> 0 GOTO errorHandler
	
	END
END
ELSE IF @v_ProType = '2'
BEGIN
	IF @v_ProMethod = 'ADD'
	BEGIN
		IF EXISTS(SELECT 1 FROM tblb_BbsMenu WHERE f_menuid = @v_MenuId AND f_bbsname = @v_BbsName)
		BEGIN
			SET @v_RetVal = 1
			RETURN
		END
		ELSE
		BEGIN
			SET @v_LastMOrder = (SELECT TOP 1 f_menuorder FROM tblb_BbsMenu WHERE f_menuid = @v_MenuId)
			SET @v_LastMOrder = ISNULL(@v_LastMOrder, 1)
			SET @v_LastBid = (SELECT MAX(f_bbsidx)+1 FROM tblb_BbsMenu WHERE f_menuid = @v_MenuId)
			SET @v_LastBid = ISNULL(@v_LastBid, 1)
			SET @v_LastBOrder = (SELECT MAX(f_bbsorder)+1 FROM tblb_BbsMenu WHERE f_menuid = @v_MenuId)
			SET @v_LastBOrder =  ISNULL(@v_LastBOrder, 1)
	
			INSERT INTO tblb_BbsMenu (f_menuid, f_menuname, f_bbsidx, f_bbsname, f_bbsclass, f_applyattfileext, f_maxattfilesize, f_link, f_menuorder, f_bbsorder, f_regdate)
			VALUES (@v_MenuId, @v_MenuName, @v_LastBid, @v_BbsName, @v_BbsClass, @v_ApplyFileType, @v_MaxFilesize, @v_Link, @v_LastMOrder,@v_LastBOrder, getdate())
			IF @@ERROR <> 0 GOTO errorHandler
		END
	END
	ELSE IF @v_ProMethod = 'EDIT'
	BEGIN
		UPDATE tblb_BbsMenu
		SET f_bbsname = @v_BbsName, f_applyattfileext = @v_ApplyFileType, f_maxattfilesize = @v_MaxFilesize, f_link = @v_Link
		WHERE f_menuid = @v_MenuId AND f_bbsidx = @v_BbsIdx
	END
	ELSE IF @v_ProMethod = 'DELETE'
	BEGIN
		DECLARE @v_TempBbsOrder INT
		SELECT @v_TempBbsOrder = f_bbsorder FROM tblb_BbsMenu WHERE f_menuid = @v_MenuId AND f_bbsidx = @v_BbsIdx


		DELETE FROM tblb_BbsMenu WHERE f_menuid = @v_MenuId AND f_bbsidx = @v_BbsIdx
		IF @@ERROR <> 0 GOTO errorHandler

		UPDATE tblb_BbsMenu
		SET f_bbsorder = f_bbsorder - 1
		WHERE f_bbsorder > @v_TempBbsOrder
		IF @@ERROR <> 0 GOTO errorHandler

	END
END

SET @v_RetVal = 0
RETURN

errorHandler:

	SET @v_retVal = 99
	RETURN




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

