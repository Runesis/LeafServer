SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

ALTER  Proc spb_AdmBbsGroupList
/*
////////////////////////////////////////////////////////////////////////
//
// 프로시져명 : 게시판 목록
// 작 성 자 : 장승필(jjadoll@softmax.co.kr)
// 작 성 일 : 2011-11-18 AM 11:20
// 최종수정자 : 
// 수 정 일 : 
// 파 일 명 : 
// N O T E :
//
////////////////////////////////////////////////////////////////////////
*/ 
(
@v_GetType INT,	-- GetType
@v_MenuId VARCHAR(20)	-- 메뉴 ID
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

