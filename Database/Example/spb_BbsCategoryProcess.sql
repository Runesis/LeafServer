SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

ALTER  Proc dbo.spb_BbsCategoryProcess
/*
////////////////////////////////////////////////////////////////////////
//
// ���ν����� : �Խ��� ī�װ� �߰�, ����, ����
// �� �� �� : �����(jjadoll@softmax.co.kr)
// �� �� �� : 2011-11-25 PM 02:00
// ���������� : 
// �� �� �� : 
// �� �� �� : 
//	- /Gda/BbsAuthAdmin/ProcessCategoryXML.apsx.cs
// N O T E :
//
////////////////////////////////////////////////////////////////////////
*/ 
(
@v_ProMethod VARCHAR(15), 		-- ADD/EDIT/DELETE : �߰�/����/����
@v_CtgIdx int,				-- ī�װ� �ε���
@v_MenuId VARCHAR(20),			-- �޴� ID
@v_BbsIdx int,				-- �Խ��� �ε���
@v_Category VARCHAR(50),		-- ī�װ� ��
@v_RetVal INT OUTPUT			-- 0/99 : ����/DB ����
)
AS

SET NOCOUNT ON 
SET XACT_ABORT ON 

IF @v_ProMethod = 'ADD'
BEGIN
	INSERT INTO tblb_Category(f_menuid, f_bbsidx, f_category) VALUES(@v_MenuId, @v_BbsIdx, @v_Category)
	IF @@ERROR <> 0 GOTO errorHandler 
END
ELSE IF @v_ProMethod = 'EDIT'
BEGIN
	UPDATE tblb_Category SET f_category = @v_Category WHERE f_catidx = @v_CtgIdx
	IF @@ERROR <> 0 GOTO errorHandler 
END
ELSE IF @v_ProMethod = 'DELETE'
BEGIN
	DELETE FROM tblb_Category WHERE f_catidx = @v_CtgIdx
	IF @@ERROR <> 0 GOTO errorHandler 
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

