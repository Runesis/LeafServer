SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
ALTER  PROC spb_CategoryGet
/*
////////////////////////////////////////////////////////////////////////
//
// 프로시져명 : 카테고리 정보 얻기
// 작  성  자 : 장승필(jjadoll@softmax.co.kr)
// 작  성  일 : 2011-11-25 PM 03:49
// 최종수정자 : 
// 수  정  일 : 
// 파  일  명 : 
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

