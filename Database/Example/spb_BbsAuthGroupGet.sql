SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

ALTER  Proc dbo.spb_BbsAuthGroupGet
/*
////////////////////////////////////////////////////////////////////////
//
// 프로시져명 : 권한등급 정보 얻기
// 작 성 자 : 장승필(jjadoll@softmax.co.kr)
// 작 성 일 : 2011-11-30 PM 03:00
// 최종수정자 : 
// 수 정 일 : 
// 파 일 명 : 
//	- /Gda/BbsAuthGroup/ProcessDataXML.aspx.cs
// N O T E :
//
////////////////////////////////////////////////////////////////////////
*/ 
(
@v_BbsAgIdx INT		-- 권한그룹 고유번호
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

