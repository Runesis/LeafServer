SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

ALTER  Proc dbo.spb_AdmAuthGroupList
/*
////////////////////////////////////////////////////////////////////////
//
// 프로시져명 : 슈퍼관리자/게시판 권한그룹 목록
// 작 성 자 : 장승필(jjadoll@softmax.co.kr)
// 작 성 일 : 2011-11-18 PM 06:30
// 최종수정자 : 
// 수 정 일 : 
// 파 일 명 : 
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

