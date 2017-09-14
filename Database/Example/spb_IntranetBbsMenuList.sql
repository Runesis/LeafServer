SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

ALTER  Proc dbo.spb_IntranetBbsMenuList
/*
////////////////////////////////////////////////////////////////////////
//
// ���ν����� : ��Ʈ��� �Խ��� / �޴� ���
// �� �� �� : �����(jjadoll@softmax.co.kr)
// �� �� �� : 2011-11-21 PM 02:00
// ���������� : 
// �� �� �� : 
// �� �� �� : 
	-
// N O T E :
//
////////////////////////////////////////////////////////////////////////
*/ 
(
@v_Mode VARCHAR(10),			-- ��� �� / CATEGORY,BBS
@v_MenuName VARCHAR(50),		-- �˻��� �޴���
@v_BbsName VARCHAR(50)		-- �˻��� �Խ��Ǹ�
)
AS

SET NOCOUNT ON 
SET XACT_ABORT ON 

IF LEN(@v_MenuName) > 0 AND LEN(@v_BbsName) > 0
	SELECT * FROM tblb_BbsMenu WHERE f_menuname = @v_MenuName AND f_bbsname = @v_BbsName ORDER BY f_menuorder ASC
ELSE IF LEN(@v_MenuName) > 0 AND LEN(@v_BbsName) < 1
	SELECT * FROM tblb_BbsMenu WHERE f_menuname = @v_MenuName AND f_bbsorder >= 0 ORDER BY f_menuorder ASC, f_bbsorder ASC
ELSE IF LEN(@v_MenuName) < 1 AND LEN(@v_BbsName) > 0
	SELECT * FROM tblb_BbsMenu WHERE f_bbsname = @v_BbsName ORDER BY f_menuorder ASC
ELSE
BEGIN
	IF( @v_Mode = 'CATEGORY' )
		SELECT f_menuid, f_menuname, f_menuorder, f_bbsclass FROM tblb_BbsMenu GROUP BY f_menuid, f_menuname, f_menuorder, f_bbsclass
		ORDER BY f_bbsclass ASC, f_menuorder ASC
	ELSE
		SELECT * FROM tblb_BbsMenu WHERE f_menuname = @v_MenuName
		ORDER BY f_bbsclass ASC, f_menuorder ASC
END
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

