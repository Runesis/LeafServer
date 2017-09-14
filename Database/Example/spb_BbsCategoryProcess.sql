SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

ALTER  Proc dbo.spb_BbsCategoryProcess
/*
////////////////////////////////////////////////////////////////////////
//
// 프로시져명 : 게시판 카테고리 추가, 수정, 삭제
// 작 성 자 : 장승필(jjadoll@softmax.co.kr)
// 작 성 일 : 2011-11-25 PM 02:00
// 최종수정자 : 
// 수 정 일 : 
// 파 일 명 : 
//	- /Gda/BbsAuthAdmin/ProcessCategoryXML.apsx.cs
// N O T E :
//
////////////////////////////////////////////////////////////////////////
*/ 
(
@v_ProMethod VARCHAR(15), 		-- ADD/EDIT/DELETE : 추가/수정/삭제
@v_CtgIdx int,				-- 카테고리 인덱스
@v_MenuId VARCHAR(20),			-- 메뉴 ID
@v_BbsIdx int,				-- 게시판 인덱스
@v_Category VARCHAR(50),		-- 카테고리 명
@v_RetVal INT OUTPUT			-- 0/99 : 정상/DB 오류
)
AS

SET NOCOUNT ON 
SET XACT_ABORT ON 

IF @v_ProMethod = 'ADD'
BEGIN
	INSERT INTO tblb_Category(f_menuid, f_bbsidx, f_category) VALUES(@v_MenuId, @v_BbsIdx, @v_Category)
	IF @@ERROR <> 0 GOTO errorHandler 
END
ELSE IF @v_ProMethod = 'EDIT'
BEGIN
	UPDATE tblb_Category SET f_category = @v_Category WHERE f_catidx = @v_CtgIdx
	IF @@ERROR <> 0 GOTO errorHandler 
END
ELSE IF @v_ProMethod = 'DELETE'
BEGIN
	DELETE FROM tblb_Category WHERE f_catidx = @v_CtgIdx
	IF @@ERROR <> 0 GOTO errorHandler 
END

SET @v_RetVal = 0
RETURN

errorHandler:
	SET @v_retVal = 99
	RETURN
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

