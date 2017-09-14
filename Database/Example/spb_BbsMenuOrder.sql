SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

ALTER  Proc dbo.spb_BbsMenuOrder
/*
////////////////////////////////////////////////////////////////////////
//
// ���ν����� : �Խ��ǰ�����/�޴� ����
// �� �� �� : �����(jjadoll@softmax.co.kr)
// �� �� �� : 2011-11-28 PM 06:43
// ���������� : 
// �� �� �� : 
// �� �� �� : 
//	- /Gda/BbsCategory/Move.aspx.cs
// N O T E :
//
////////////////////////////////////////////////////////////////////////
*/ 
(
@v_IsCat INT,				-- 1/2 : �޴�1/�޴�2
@v_Mode VARCHAR(1),			-- 1/2 : UP/DOWN
@v_MenuName VARCHAR(50),		-- @v_IsCat = 1 �϶� ������ �ٲٱ� ���� ������ ������	
@v_BbsName VARCHAR(50),		-- @v_IsCat = 2 �϶� ������ �ٲٱ� ���� ������ ������	
@v_DestMenuName VARCHAR(50),	-- ������ �����͸� �ٲ� ��ġ
@v_RetVal INT OUTPUT		-- 0/99 : ����/DB ����
)
AS

SET NOCOUNT ON 
SET XACT_ABORT ON 

IF @v_IsCat = 1
BEGIN
	IF @v_Mode = 1
	BEGIN
		BEGIN TRAN

		UPDATE tblb_BbsMenu SET f_menuorder = f_menuorder - 1 WHERE f_menuname = @v_MenuName
		IF @@ERROR <> 0 GOTO errorHandler 
			
		UPDATE tblb_BbsMenu SET f_menuorder = f_menuorder + 1 WHERE f_menuname = @v_DestMenuName
		IF @@ERROR <> 0 GOTO errorHandler 

		COMMIT TRAN
	END
	ELSE IF @v_Mode = 2
	BEGIN
		BEGIN TRAN

		UPDATE tblb_BbsMenu SET f_menuorder = f_menuorder + 1 WHERE f_menuname = @v_MenuName
		IF @@ERROR <> 0 GOTO errorHandler 
			
		UPDATE tblb_BbsMenu SET f_menuorder = f_menuorder - 1 WHERE f_menuname = @v_DestMenuName
		IF @@ERROR <> 0 GOTO errorHandler 

		COMMIT TRAN
	END
END
ELSE IF @v_IsCat = 2
BEGIN
	IF @v_Mode = 1
	BEGIN
		BEGIN TRAN

		UPDATE tblb_BbsMenu SET f_bbsorder = f_bbsorder - 1 WHERE f_menuid = @v_MenuName AND f_bbsname = @v_BbsName
		IF @@ERROR <> 0 GOTO errorHandler 
			
		UPDATE tblb_BbsMenu SET f_bbsorder = f_bbsorder + 1 WHERE f_menuid = @v_MenuName AND f_bbsname = @v_DestMenuName
		IF @@ERROR <> 0 GOTO errorHandler 

		COMMIT TRAN
	END
	ELSE IF @v_Mode = 2
	BEGIN
		BEGIN TRAN

		UPDATE tblb_BbsMenu SET f_bbsorder = f_bbsorder + 1 WHERE f_menuid = @v_MenuName AND f_bbsname = @v_BbsName
		IF @@ERROR <> 0 GOTO errorHandler 
			
		UPDATE tblb_BbsMenu SET f_bbsorder = f_bbsorder - 1 WHERE f_menuid = @v_MenuName AND f_bbsname = @v_DestMenuName
		IF @@ERROR <> 0 GOTO errorHandler 

		COMMIT TRAN
	END
END

SET @v_RetVal = 0
RETURN

errorHandler:
	ROLLBACK TRAN

	SET @v_retVal = 99
	RETURN
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

