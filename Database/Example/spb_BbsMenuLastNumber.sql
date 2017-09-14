SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

ALTER  Proc dbo.spb_BbsMenuLastNumber
/*
////////////////////////////////////////////////////////////////////////
//
// 프로시져명 : 게시판 최종번호 얻기
// 작 성 자 : 장승필(jjadoll@softmax.co.kr)
// 작 성 일 : 2011-12-02 AM 10:40
// 최종수정자 : 
// 수 정 일 : 
// 파 일 명 : 
//	- /Gda/BbsCategory/GetBbsLastNumberXML.aspx.cs
// N O T E :
//
////////////////////////////////////////////////////////////////////////
*/ 
(
@v_BbsType VARCHAR(10),	-- SmBbs/SmTsg : 일반게시판/TSG게시판
@v_MenuId VARCHAR(50),	-- 메뉴 이름
@v_BbsLstIdx INT OUTPUT,	-- 반환 값
@v_RetVal INT OUTPUT		-- 반환 값
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

