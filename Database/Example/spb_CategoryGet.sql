SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
ALTER  PROC spb_CategoryGet
/*
////////////////////////////////////////////////////////////////////////
//
// ���ν����� : ī�װ� ���� ���
// ��  ��  �� : �����(jjadoll@softmax.co.kr)
// ��  ��  �� : 2011-11-25 PM 03:49
// ���������� : 
// ��  ��  �� : 
// ��  ��  �� : 
//	- /Gda/BbsAuthAdmin/ProcessCategory.aspx.cs
// N O T E   :   
//
////////////////////////////////////////////////////////////////////////
*/
(
@v_Ctgidx int
)
AS
SET NOCOUNT ON

SELECT f_catidx, f_category FROM tblb_Category WHERE f_catidx = @v_Ctgidx

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

