SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

ALTER  Proc dbo.spb_AdmBbsAuthGroupMbListGet
/*
////////////////////////////////////////////////////////////////////////
//
// 프로시져명 : 게시판 관리/해당 권한의 사원 목록 얻기
// 작 성 자 : 장승필(jjadoll@softmax.co.kr)
// 작 성 일 : 2011-11-29 AM 11:50
// 최종수정자 : 
// 수 정 일 : 
// 파 일 명 : 
//	- /Gda/SetBbsAdmin/MngBbsAdmin.aspx.cs
// N O T E :
//
////////////////////////////////////////////////////////////////////////
*/ 
(
@v_BbsAgIdx INT,		-- 게시판 권한그룹 고유번호
@v_GrpIdx1 INT,		-- 검색할 그룹1 고유번호
@v_GrpIdx2 INT,		-- 검색할 그룹2 고유번호
@v_GrpIdx3 INT,		-- 검색할 그룹3 고유번호
@v_GrpIdx4 INT,		-- 검색할 그룹4 고유번호
@v_GrpIdx5 INT		-- 검색할 그룹5 고유번호
)
AS

SET NOCOUNT ON 
SET XACT_ABORT ON 

SELECT tbl1.f_mbidx, tbl1.f_kname, tbl2.f_bbsagidx, (SELECT f_agname FROM tblb_BbsAuthGroup WHERE f_bbsagidx = tbl2.f_bbsagidx) AS f_agname
FROM vw_GetGroupMb AS tbl1, 
(SELECT a.f_mbidx, a.f_class, a.f_bbsagidx FROM tblm_Member AS a) AS tbl2 
WHERE tbl1.f_mbidx = tbl2.f_mbidx AND
	CASE WHEN @v_GrpIdx1 = 0 THEN @v_GrpIdx1 ELSE tbl1.f_grpidx1 END = @v_GrpIdx1 AND
	CASE WHEN @v_GrpIdx2 = 0 THEN @v_GrpIdx2 ELSE tbl1.f_grpidx2 END = @v_GrpIdx2 AND
	CASE WHEN @v_GrpIdx3 = 0 THEN @v_GrpIdx3 ELSE tbl1.f_grpidx3 END = @v_GrpIdx3 AND
	CASE WHEN @v_GrpIdx4 = 0 THEN @v_GrpIdx4 ELSE tbl1.f_grpidx4 END = @v_GrpIdx4 AND
	CASE WHEN @v_GrpIdx5 = 0 THEN @v_GrpIdx5 ELSE tbl1.f_grpidx5 END = @v_GrpIdx5 AND
	tbl2.f_bbsagidx <> @v_BbsAgIdx
GROUP BY tbl1.f_mbidx, tbl1.f_kname, tbl2.f_bbsagidx
ORDER BY tbl1.f_kname

SELECT f_mbidx, f_kname, (SELECT f_agname FROM tblb_BbsAuthGroup WHERE f_bbsagidx = a.f_bbsagidx) AS f_bbsagname FROM tblm_Member AS a WHERE a.f_bbsagidx = @v_BbsAgIdx
ORDER BY f_kname ASC
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

