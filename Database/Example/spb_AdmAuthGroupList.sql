SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

ALTER  Proc dbo.spb_AdmAuthGroupList
/*
////////////////////////////////////////////////////////////////////////
//
// ���ν����� : ���۰�����/�Խ��� ���ѱ׷� ���
// �� �� �� : �����(jjadoll@softmax.co.kr)
// �� �� �� : 2011-11-18 PM 06:30
// ���������� : 
// �� �� �� : 
// �� �� �� : 
// N O T E :
//
////////////////////////////////////////////////////////////////////////
*/ 
AS

SET NOCOUNT ON 
SET XACT_ABORT ON 

SELECT * FROM tblb_BbsAuthGroup WHERE f_bbsagidx > -1 ORDER BY f_bbsagidx
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

