package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.service.MemberService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Member;

@Controller
public class UsrMemberController {

	@Autowired
	private MemberService memberService;

	@RequestMapping("/usr/member/doJoin")
	@ResponseBody
	public Object doJoin(String loginId, String loginPw, String name, String nickname, String cellphoneNum,
			String email) {

		if (Ut.isEmptyOrNull(loginId)) {
			return "아이디를 입력해";
		}
		if (Ut.isEmptyOrNull(loginPw)) {
			return "비밀번호를 입력해";
		}
		if (Ut.isEmptyOrNull(name)) {
			return "이름을 입력해";
		}
		if (Ut.isEmptyOrNull(nickname)) {
			return "닉네임을 입력해";
		}
		if (Ut.isEmptyOrNull(cellphoneNum)) {
			return "전화번호를 입력해";
		}
		if (Ut.isEmptyOrNull(email)) {
			return "이메일을 입력해";
		}

		int id = memberService.doJoin(loginId, loginPw, name, nickname, cellphoneNum, email);

		if (id == -1) {
			return Ut.f("이미 사용중인 아이디(%s)입니다", loginId);
		}

		if (id == -2) {
			return Ut.f("이미 사용중인 이름(%s)과 이메일(%s)입니다", name, email);
		}

		Member member = memberService.getMemberById(id);

		return member;
	}

}
