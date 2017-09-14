SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

ALTER  Proc spb_AdmBbsGroupList
/*
////////////////////////////////////////////////////////////////////////
//
// ���ν����� : �Խ��� ���
// �� �� �� : �����(jjadoll@softmax.co.kr)
// �� �� �� : 2011-11-18 AM 11:20
// ���������� : 
// �� �� �� : 
// �� �� �� : 
// N O T E :
//
////////////////////////////////////////////////////////////////////////
*/ 
(
@v_GetType INT,	-- GetType
@v_MenuId VARCHAR(20)	-- �޴� ID
)
AS

SET NOCOUNT ON 
SET XACT_ABORT ON 

IF @v_GetType = 1
BEGIN
	SELECT DISTINCT f_menuid, f_menuname FROM tblb_BbsMenu ORDER BY f_menuid
END
ELSE IF @v_GetType = 2
BEGIN
	SELECT * FROM tblb_BbsMenu WHERE f_menuid = @v_MenuId
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

