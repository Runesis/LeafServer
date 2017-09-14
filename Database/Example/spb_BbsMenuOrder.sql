SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

ALTER  Proc dbo.spb_BbsMenuOrder
/*
////////////////////////////////////////////////////////////////////////
//
// 프로시져명 : 게시판관리자/메뉴 정렬
// 작 성 자 : 장승필(jjadoll@softmax.co.kr)
// 작 성 일 : 2011-11-28 PM 06:43
// 최종수정자 : 
// 수 정 일 : 
// 파 일 명 : 
//	- /Gda/BbsCategory/Move.aspx.cs
// N O T E :
//
////////////////////////////////////////////////////////////////////////
*/ 
(
@v_IsCat INT,				-- 1/2 : 메뉴1/메뉴2
@v_Mode VARCHAR(1),			-- 1/2 : UP/DOWN
@v_MenuName VARCHAR(50),		-- @v_IsCat = 1 일때 순서를 바꾸기 위해 선택한 데이터	
@v_BbsName VARCHAR(50),		-- @v_IsCat = 2 일때 순서를 바꾸기 위해 선택한 데이터	
@v_DestMenuName VARCHAR(50),	-- 선택한 데이터를 바꿀 위치
@v_RetVal INT OUTPUT		-- 0/99 : 정상/DB 오류
)
AS

SET NOCOUNT ON 
SET XACT_ABORT ON 

IF @v_IsCat = 1
BEGIN
	IF @v_Mode = 1
	BEGIN
		BEGIN TRAN

		UPDATE tblb_BbsMenu SET f_menuorder = f_menuorder - 1 WHERE f_menuname = @v_MenuName
		IF @@ERROR <> 0 GOTO errorHandler 
			
		UPDATE tblb_BbsMenu SET f_menuorder = f_menuorder + 1 WHERE f_menuname = @v_DestMenuName
		IF @@ERROR <> 0 GOTO errorHandler 

		COMMIT TRAN
	END
	ELSE IF @v_Mode = 2
	BEGIN
		BEGIN TRAN

		UPDATE tblb_BbsMenu SET f_menuorder = f_menuorder + 1 WHERE f_menuname = @v_MenuName
		IF @@ERROR <> 0 GOTO errorHandler 
			
		UPDATE tblb_BbsMenu SET f_menuorder = f_menuorder - 1 WHERE f_menuname = @v_DestMenuName
		IF @@ERROR <> 0 GOTO errorHandler 

		COMMIT TRAN
	END
END
ELSE IF @v_IsCat = 2
BEGIN
	IF @v_Mode = 1
	BEGIN
		BEGIN TRAN

		UPDATE tblb_BbsMenu SET f_bbsorder = f_bbsorder - 1 WHERE f_menuid = @v_MenuName AND f_bbsname = @v_BbsName
		IF @@ERROR <> 0 GOTO errorHandler 
			
		UPDATE tblb_BbsMenu SET f_bbsorder = f_bbsorder + 1 WHERE f_menuid = @v_MenuName AND f_bbsname = @v_DestMenuName
		IF @@ERROR <> 0 GOTO errorHandler 

		COMMIT TRAN
	END
	ELSE IF @v_Mode = 2
	BEGIN
		BEGIN TRAN

		UPDATE tblb_BbsMenu SET f_bbsorder = f_bbsorder + 1 WHERE f_menuid = @v_MenuName AND f_bbsname = @v_BbsName
		IF @@ERROR <> 0 GOTO errorHandler 
			
		UPDATE tblb_BbsMenu SET f_bbsorder = f_bbsorder - 1 WHERE f_menuid = @v_MenuName AND f_bbsname = @v_DestMenuName
		IF @@ERROR <> 0 GOTO errorHandler 

		COMMIT TRAN
	END
END

SET @v_RetVal = 0
RETURN

errorHandler:
	ROLLBACK TRAN

	SET @v_retVal = 99
	RETURN
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

