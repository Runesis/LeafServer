SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

ALTER  Proc dbo.spb_AdmBbsAuthGroupMenu
/*
////////////////////////////////////////////////////////////////////////
//
// ���ν����� : �Խ��� ���� �׷��� �޴� ���� ����
// �� �� �� : �����(jjadoll@softmax.co.kr)
// �� �� �� : 2011-11-21 PM 12:40
// ���������� : 
// �� �� �� : 
// �� �� �� : 
// 	-
// N O T E :
//
////////////////////////////////////////////////////////////////////////
*/ 
(
@v_BbsAgIdx INT				-- ���ѱ׷� ������ȣ
)
AS

SET NOCOUNT ON 
SET XACT_ABORT ON 

SELECT * FROM tblb_AuthBbsMenuGroup WHERE f_bbsagidx = @v_BbsAgIdx
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

