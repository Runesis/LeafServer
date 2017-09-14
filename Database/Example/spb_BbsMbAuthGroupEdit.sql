SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

ALTER  Proc dbo.spb_BbsMbAuthGroupEdit
/*
////////////////////////////////////////////////////////////////////////
//
// 프로시져명 : 게시판 접근/조작 권한조직 수정
// 작 성 자 : 장승필(jjadoll@softmax.co.kr)
// 작 성 일 : 2011-11-30 AM 11:50
// 최종수정자 : 
// 수 정 일 : 
// 파 일 명 : 
//	- /Gda/SetBbsAdmin/Process.aspx.cs
// N O T E :
//
////////////////////////////////////////////////////////////////////////
*/ 
(
@v_ProMethod VARCHAR(15), 	-- ADD/DELETE : 추가/삭제
@v_MbIdx INT,			-- 사원 고유번호
@v_BbsAgIdx INT,			-- 권한그룹 고유번호
@v_RetVal INT OUTPUT	-- 0/99 : 정상/DB 오류
)
AS

SET NOCOUNT ON 
SET XACT_ABORT ON 

IF @v_ProMethod = 'ADD'
BEGIN
	UPDATE tblm_Member SET f_bbsagidx = @v_BbsAgIdx WHERE f_mbidx = @v_MbIdx
	IF @@ERROR <> 0 GOTO errorHandler 
END
ELSE IF @v_ProMethod = 'DELETE'
BEGIN
	UPDATE tblm_Member SET f_bbsagidx = 0 WHERE f_mbidx = @v_MbIdx
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

