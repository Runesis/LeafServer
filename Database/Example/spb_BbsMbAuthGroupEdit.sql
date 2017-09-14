SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

ALTER  Proc dbo.spb_BbsMbAuthGroupEdit
/*
////////////////////////////////////////////////////////////////////////
//
// ���ν����� : �Խ��� ����/���� �������� ����
// �� �� �� : �����(jjadoll@softmax.co.kr)
// �� �� �� : 2011-11-30 AM 11:50
// ���������� : 
// �� �� �� : 
// �� �� �� : 
//	- /Gda/SetBbsAdmin/Process.aspx.cs
// N O T E :
//
////////////////////////////////////////////////////////////////////////
*/ 
(
@v_ProMethod VARCHAR(15), 	-- ADD/DELETE : �߰�/����
@v_MbIdx INT,			-- ��� ������ȣ
@v_BbsAgIdx INT,			-- ���ѱ׷� ������ȣ
@v_RetVal INT OUTPUT	-- 0/99 : ����/DB ����
)
AS

SET NOCOUNT ON 
SET XACT_ABORT ON 

IF @v_ProMethod = 'ADD'
BEGIN
	UPDATE tblm_Member SET f_bbsagidx = @v_BbsAgIdx WHERE f_mbidx = @v_MbIdx
	IF @@ERROR <> 0 GOTO errorHandler 
END
ELSE IF @v_ProMethod = 'DELETE'
BEGIN
	UPDATE tblm_Member SET f_bbsagidx = 0 WHERE f_mbidx = @v_MbIdx
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

