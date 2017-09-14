SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

ALTER  Proc dbo.spb_BbsMenuLastNumber
/*
////////////////////////////////////////////////////////////////////////
//
// ���ν����� : �Խ��� ������ȣ ���
// �� �� �� : �����(jjadoll@softmax.co.kr)
// �� �� �� : 2011-12-02 AM 10:40
// ���������� : 
// �� �� �� : 
// �� �� �� : 
//	- /Gda/BbsCategory/GetBbsLastNumberXML.aspx.cs
// N O T E :
//
////////////////////////////////////////////////////////////////////////
*/ 
(
@v_BbsType VARCHAR(10),	-- SmBbs/SmTsg : �ϹݰԽ���/TSG�Խ���
@v_MenuId VARCHAR(50),	-- �޴� �̸�
@v_BbsLstIdx INT OUTPUT,	-- ��ȯ ��
@v_RetVal INT OUTPUT		-- ��ȯ ��
)
AS

SET NOCOUNT ON 
SET XACT_ABORT ON 

DECLARE @NumLen INT

SELECT @NumLen = MAX(LEN(f_menuid)-LEN(Left(f_menuid,5))) FROM tblb_BbsMenu WHERE Left(f_menuid,5) = @v_BbsType
SELECT @v_RetVal = MAX(Right(f_menuid, @NumLen)) + 1 FROM tblb_BbsMenu WHERE Left(f_menuid,5) = @v_BbsType

SET @v_MenuId = ISNULL(@v_MenuId, '')
SET @v_BbsLstIdx = (SELECT MAX(f_bbsidx)+1 FROM tblb_BbsMenu WHERE f_menuid = @v_MenuId)
SET @v_BbsLstIdx = ISNULL(@v_BbsLstIdx, 1)

RETURN

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

