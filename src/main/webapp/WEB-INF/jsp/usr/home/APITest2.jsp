<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="API TEST2" />

<%@ include file="../common/head.jspf"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>지도 생성하기</title>

</head>
<body>
	<!-- 지도를 표시할 div 입니다 -->
	<div id="map" style="width: 100%; height: 350px;"></div>

	<p>
		<button onclick="setCenter()">지도 중심좌표 이동시키기</button>
		<button onclick="panTo()">지도 중심좌표 부드럽게 이동시키기</button>
	</p>

	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=3d142dc2e71f43ea49b37b4e18db1572"></script>

	<script>
		let lat;
		let lon;

		async function getAirData() {
			const API_KEY = '5zYfYDfTvp2jYBAPjGDRqydkg3axrJE9ZiTMwOMwm%2FZDohm8xLOGYFkmWhlJPSYaSu9RWjNl%2BQk3AmZkwZ3gWw%3D%3D'; // Encoding된 키
			const url = 'https://apis.data.go.kr/6300000/openapi2022/tasuInfo/gettasuInfo'
					+ '?serviceKey=' + API_KEY + '&pageNo=1&numOfRows=10';

			try {
				const response = await
				fetch(url);
				if (!response.ok) {
					throw new Error(`HTTP 오류! 상태 코드: ${response.status}`);
				}
				const data = await
				response.json();
				console.log("타슈 :", data);
				console.log("타슈 :", data.response);
				console.log("타슈 :", data.response.body);
				console.log("타슈 :", data.response.body.items);
				console.log("타슈 :", data.response.body.items[0]);
				console.log("타슈 :", data.response.body.items[0].laCrdnt);
				console.log("타슈 :", data.response.body.items[0].loCrdnt);

				lat = data.response.body.items[0].laCrdnt;
				lon = data.response.body.items[0].loCrdnt;

			} catch (e) {
				console.error("API 호출 실패:", e);
			}
		}
		getAirData();

		var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
		mapOption = {
			center : new kakao.maps.LatLng(33.452613, 126.570888), // 지도의 중심좌표
			level : 3
		// 지도의 확대 레벨
		};

		// 지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
		var map = new kakao.maps.Map(mapContainer, mapOption);

		function setCenter() {
			// 이동할 위도 경도 위치를 생성합니다 
			var moveLatLon = new kakao.maps.LatLng(33.452613, 126.570888);

			// 지도 중심을 이동 시킵니다
			map.setCenter(moveLatLon);
		}

		function panTo() {
			// 이동할 위도 경도 위치를 생성합니다 
			var moveLatLon = new kakao.maps.LatLng(lat, lon);

			// 지도 중심을 부드럽게 이동시킵니다
			// 만약 이동할 거리가 지도 화면보다 크면 부드러운 효과 없이 이동합니다
			map.panTo(moveLatLon);
		}
	</script>
</body>
</html>


<%@ include file="../common/foot.jspf"%>
