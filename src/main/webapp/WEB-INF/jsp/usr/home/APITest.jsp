<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="타슈" />

<script>
	const API_KEY = '5zYfYDfTvp2jYBAPjGDRqydkg3axrJE9ZiTMwOMwm%2FZDohm8xLOGYFkmWhlJPSYaSu9RWjNl%2BQk3AmZkwZ3gWw%3D%3D'; // Encoding된 키

	async function getAirData() {
		const url = 'https://apis.data.go.kr/6300000/openapi2022/tasuInfo/gettasuInfo'
			+ '?serviceKey=' + API_KEY
			+ '&pageNo=1&numOfRows=10';

		try {
			const response = await fetch(url);
			if (!response.ok) {
				throw new Error(`HTTP 오류! 상태 코드: ${response.status}`);
			}
			const data = await response.json();
			console.log("타슈 :", data);
			console.log("타슈 :", data.response);
			console.log("타슈 :", data.response.body);
			console.log("타슈 :", data.response.body.items);
			console.log("타슈 :", data.response.body.items[0]);
			console.log("타슈 :", data.response.body.items[0].laCrdnt);
			console.log("타슈 :", data.response.body.items[0].loCrdnt);
			
		} catch (e) {
			console.error("API 호출 실패:", e);
		}
	}
	getAirData();
</script>

<%@ include file="../common/head.jspf"%>
<%@ include file="../common/foot.jspf"%>
