SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

ALTER  Proc dbo.spb_BbsAuthGroupGet
/*
////////////////////////////////////////////////////////////////////////
//
// ���ν����� : ���ѵ�� ���� ���
// �� �� �� : �����(jjadoll@softmax.co.kr)
// �� �� �� : 2011-11-30 PM 03:00
// ���������� : 
// �� �� �� : 
// �� �� �� : 
//	- /Gda/BbsAuthGroup/ProcessDataXML.aspx.cs
// N O T E :
//
////////////////////////////////////////////////////////////////////////
*/ 
(
@v_BbsAgIdx INT		-- ���ѱ׷� ������ȣ
)
AS

SET NOCOUNT ON 
SET XACT_ABORT ON 

SELECT f_bbsagidx, f_agname, f_agdesc, f_regdate, f_chgdate FROM tblb_BbsAuthGroup WHERE f_bbsagidx = @v_BbsAgIdx
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

