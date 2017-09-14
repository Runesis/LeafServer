SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

ALTER  Proc dbo.spb_AdmBbsAuthGroupMenu
/*
////////////////////////////////////////////////////////////////////////
//
// 프로시져명 : 게시판 권한 그룹의 메뉴 권한 정보
// 작 성 자 : 장승필(jjadoll@softmax.co.kr)
// 작 성 일 : 2011-11-21 PM 12:40
// 최종수정자 : 
// 수 정 일 : 
// 파 일 명 : 
// 	-
// N O T E :
//
////////////////////////////////////////////////////////////////////////
*/ 
(
@v_BbsAgIdx INT				-- 권한그룹 고유번호
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

