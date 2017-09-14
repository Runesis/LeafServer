SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

ALTER  Proc dbo.spb_BbsAuthMenuGroupProcess
/*
////////////////////////////////////////////////////////////////////////
//
// ���ν����� : �Խ��� ���� �׷캰 �޴� �� ���� ���� ����
// �� �� �� : �����(jjadoll@softmax.co.kr)
// �� �� �� : 2011-11-30 PM 06:10
// ���������� : 
// �� �� �� : 
// �� �� �� : 
//	- /Gda/BbsAuthGroup/SetBbsAuthGroup.aspx.cs
// N O T E :
//
////////////////////////////////////////////////////////////////////////
*/ 
(
@v_BbsAgIdx INT,				-- ���ѱ׷� ������ȣ
@v_Grant VARCHAR(1024) = '',		-- �޴���ȣ,���ѷ���; (ex. 1,2;2,1;3,5)  - ';' ����, ',' ���ڸ� �����ڷ� Split �Ͽ� �޴���ȣ�� ���ѷ����� ��´�.
@v_RetVal INT OUTPUT		-- 0/99 : ����/DB ����
)
AS

SET NOCOUNT ON 
SET XACT_ABORT ON 

DECLARE @v_menuid VARCHAR(20)
DECLARE @v_bbsidx INT
DECLARE @v_operation CHAR(1)

DECLARE @temp1 VARCHAR(256)

DECLARE @Position1 INT
DECLARE @End1 VARCHAR(32)
DECLARE @Substr1 NCHAR(32)

DECLARE @Position2 INT
DECLARE @End2 VARCHAR(16)
DECLARE @Substr2 NCHAR(16)

DECLARE @End3 VARCHAR(16)
DECLARE @Substr3 NCHAR(16)

BEGIN TRAN

DELETE FROM tblb_AuthBbsMenuGroup WHERE f_bbsagidx = @v_BbsAgIdx
IF @@ERROR <> 0 GOTO errorHandler

SET @Position1 = 1
SET @Substr1 = (SELECT dbo.udf_Char_SplitFnc(@v_Grant, ';', @Position1))
SET @End1 = ISNULL(@Substr1, '')

WHILE @End1 <> ''
BEGIN
	SET @Substr1 = (SELECT dbo.udf_Char_SplitFnc(@v_Grant, ';', @Position1))
	SET @End1 = ISNULL(@Substr1, '')

	IF @End1 <> ''
	BEGIN
		SET @temp1 = @Substr1
		SET @Position2 = 1
		SET @Substr2 = (SELECT dbo.udf_Char_SplitFnc(@temp1, ',', @Position2))
		SET @End2= ISNULL(@Substr2, '')
		SET @Substr3 = (SELECT dbo.udf_Char_SplitFnc(@temp1, ',', @Position2 + 1))
		SET @End3= ISNULL(@Substr3, '')

		IF ( @End2 <> '' AND @End3 <> '' )
		BEGIN
			SET @v_menuid = @Substr2
			SET @v_bbsidx = @Substr3

			SET @v_operation = (SELECT dbo.udf_Char_SplitFnc(@temp1, ',', 3))
			SET @v_operation = ISNULL(@v_operation, '')

			IF @v_operation <> ''
			BEGIN

				INSERT INTO tblb_AuthBbsMenuGroup(f_bbsagidx, f_menuid, f_bbsidx, f_operation) VALUES(@v_BbsAgIdx, @v_menuid, @v_bbsidx, @v_operation)
				IF @@ERROR <> 0 GOTO errorHandler
			END
		END	
			
		SET @Position1 = @Position1 + 1
	END
END

COMMIT TRAN

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

