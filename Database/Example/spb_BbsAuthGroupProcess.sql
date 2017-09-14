SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

ALTER  Proc dbo.spb_BbsAuthGroupProcess
/*
////////////////////////////////////////////////////////////////////////
//
// ���ν����� : �Խ��� ���ѱ׷� / �߰�, ����, ����
// �� �� �� : �����(jjadoll@softmax.co.kr)
// �� �� �� : 2011-11-21 PM 12:20
// ���������� : 
// �� �� �� : 
// �� �� �� : 
// N O T E :
//
////////////////////////////////////////////////////////////////////////
*/ 
(
@v_ProMethod VARCHAR(15), 		-- ADD/EDIT/DELETE : �߰�/����/����
@v_BbsAgIdx INT,				-- ���ѱ׷� ������ȣ
@v_BbsAgName VARCHAR(20),		-- ���Ѹ�
@v_BbsAgDesc VARCHAR(500),		-- ���� ����
@v_RetVal INT OUTPUT		-- 0/99 : ����/DB ����
)
AS

SET NOCOUNT ON 
SET XACT_ABORT ON 

IF @v_ProMethod = 'ADD'
BEGIN
	INSERT INTO tblb_BbsAuthGroup(f_agname, f_agdesc, f_regdate, f_chgdate) VALUES(@v_BbsAgName, @v_BbsAgDesc, GETDATE(), GETDATE())
	IF @@ERROR <> 0 GOTO errorHandler 
END
ELSE IF @v_ProMethod = 'EDIT'
BEGIN
	UPDATE tblb_BbsAuthGroup SET f_agname = @v_BbsAgName, f_agdesc = @v_BbsAgDesc, f_chgdate = GETDATE() WHERE f_bbsagidx = @v_BbsAgIdx
	IF @@ERROR <> 0 GOTO errorHandler 
END
ELSE IF @v_ProMethod = 'DELETE'
BEGIN
	DELETE FROM tblb_AuthBbsMenuGroup WHERE f_bbsagidx = @v_BbsAgIdx	-- �ܷ�Ű�� ��� �ִ� ���̺��� ������ ���� ����
	IF @@ERROR <> 0 GOTO errorHandler 

	DELETE FROM tblb_BbsAuthGroup WHERE f_bbsagidx = @v_BbsAgIdx
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

