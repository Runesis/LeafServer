SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

ALTER  Proc dbo.spb_BbsAuthGroupProcess
/*
////////////////////////////////////////////////////////////////////////
//
// 프로시져명 : 게시판 권한그룹 / 추가, 수정, 삭제
// 작 성 자 : 장승필(jjadoll@softmax.co.kr)
// 작 성 일 : 2011-11-21 PM 12:20
// 최종수정자 : 
// 수 정 일 : 
// 파 일 명 : 
// N O T E :
//
////////////////////////////////////////////////////////////////////////
*/ 
(
@v_ProMethod VARCHAR(15), 		-- ADD/EDIT/DELETE : 추가/수정/삭제
@v_BbsAgIdx INT,				-- 권한그룹 고유번호
@v_BbsAgName VARCHAR(20),		-- 권한명
@v_BbsAgDesc VARCHAR(500),		-- 권한 설명
@v_RetVal INT OUTPUT		-- 0/99 : 정상/DB 오류
)
AS

SET NOCOUNT ON 
SET XACT_ABORT ON 

IF @v_ProMethod = 'ADD'
BEGIN
	INSERT INTO tblb_BbsAuthGroup(f_agname, f_agdesc, f_regdate, f_chgdate) VALUES(@v_BbsAgName, @v_BbsAgDesc, GETDATE(), GETDATE())
	IF @@ERROR <> 0 GOTO errorHandler 
END
ELSE IF @v_ProMethod = 'EDIT'
BEGIN
	UPDATE tblb_BbsAuthGroup SET f_agname = @v_BbsAgName, f_agdesc = @v_BbsAgDesc, f_chgdate = GETDATE() WHERE f_bbsagidx = @v_BbsAgIdx
	IF @@ERROR <> 0 GOTO errorHandler 
END
ELSE IF @v_ProMethod = 'DELETE'
BEGIN
	DELETE FROM tblb_AuthBbsMenuGroup WHERE f_bbsagidx = @v_BbsAgIdx	-- 외래키를 잡고 있는 테이블의 데이터 먼저 삭제
	IF @@ERROR <> 0 GOTO errorHandler 

	DELETE FROM tblb_BbsAuthGroup WHERE f_bbsagidx = @v_BbsAgIdx
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

