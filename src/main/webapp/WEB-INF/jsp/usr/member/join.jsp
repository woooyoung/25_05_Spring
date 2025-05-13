<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="MEMBER JOIN"></c:set>
<%@ include file="../common/head.jspf"%>


<section class="mt-8 text-xl px-4">
	<div class="mx-auto">
		<form action="../member/doJoin" method="POST">
			<table class="table"  border="1" cellspacing="0" cellpadding="5" style="width: 100%; border-collapse: collapse;">
				<tbody>
					<tr>
						<th>아이디</th>
						<td style="text-align: center;">
							<input class="input input-primary" name="loginId" autocomplete="off" type="text" placeholder="아이디 입력" />
						</td>
					</tr>
					<tr>
						<th>비밀번호</th>
						<td style="text-align: center;">
							<input class="input input-primary" name="loginPw" autocomplete="off" type="text" placeholder="비밀번호 입력" />
						</td>
					</tr>
					<tr>
						<th>이름</th>
						<td style="text-align: center;">
							<input class="input input-primary" name="name" autocomplete="off" type="text" placeholder="이름 입력" />
						</td>
					</tr>
					<tr>
						<th>닉네임</th>
						<td style="text-align: center;">
							<input class="input input-primary" name="nickname" autocomplete="off" type="text" placeholder="닉네임 입력" />
						</td>
					</tr>
					<tr>
						<th>전화번호</th>
						<td style="text-align: center;">
							<input class="input input-primary" name=cellphoneNum autocomplete="off" type="text" placeholder="전화번호 입력" />
						</td>
					</tr>
					<tr>
						<th>이메일</th>
						<td style="text-align: center;">
							<input class="input input-primary" name="email" autocomplete="off" type="text" placeholder="이메일 입력" />
						</td>
					</tr>


					<tr>
						<th></th>
						<td style="text-align: center;">
							<button class="btn btn-ghost">가입</button>
						</td>
					</tr>

				</tbody>
			</table>
		</form>
		<div class="btns">
			<button class="btn btn-ghost" type="button" onclick="history.back();">뒤로가기</button>

		</div>
	</div>
</section>



<%@ include file="../common/foot.jspf"%>