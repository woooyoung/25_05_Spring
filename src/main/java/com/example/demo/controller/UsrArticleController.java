package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.service.ArticleService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Article;
import com.example.demo.vo.ResultData;

import jakarta.servlet.http.HttpSession;

@Controller
public class UsrArticleController {

	@Autowired
	private ArticleService articleService;

	// 로그인 체크 -> 유무 체크 -> 권한체크
	@RequestMapping("/usr/article/doModify")
	@ResponseBody
	public ResultData doModify(HttpSession session, int id, String title, String body) {

		boolean isLogined = false;
		int loginedMemberId = 0;

		if (session.getAttribute("loginedMemberId") != null) {
			isLogined = true;
			loginedMemberId = (int) session.getAttribute("loginedMemberId");
		}

		Article article = articleService.getArticleById(id);

		if (article == null) {
			return ResultData.from("F-1", Ut.f("%d번 게시글은 없습니다", id), "없는 글의 id", id);
		}

		ResultData loginedMemberCanModifyRd = articleService.loginedMemberCanModify(loginedMemberId, article);

		articleService.modifyArticle(id, title, body);

		article = articleService.getArticleById(id);

		return ResultData.from(loginedMemberCanModifyRd.getResultCode(), loginedMemberCanModifyRd.getMsg(), "수정된 글",
				article);
	}

	@RequestMapping("/usr/article/doDelete")
	@ResponseBody
	public ResultData doDelete(HttpSession session, int id) {

		boolean isLogined = false;
		int loginedMemberId = 0;

		if (session.getAttribute("loginedMemberId") != null) {
			isLogined = true;
			loginedMemberId = (int) session.getAttribute("loginedMemberId");
		}

		Article article = articleService.getArticleById(id);

		if (article == null) {
			return ResultData.from("F-1", Ut.f("%d번 게시글은 없습니다", id));
		}

		if (article.getMemberId() != loginedMemberId) {
			return ResultData.from("F-A", "권한없음");
		}

		articleService.deleteArticle(id);

		return ResultData.from("S-1", Ut.f("%d번 게시글이 삭제됨", id));
	}

	@RequestMapping("/usr/article/detail")
	public String showDetail(Model model, int id) {

		Article article = articleService.getArticleById(id);

//		if (article == null) {
//			return ResultData.from("F-1", Ut.f("%d번 게시글은 없습니다", id));
//		}

		model.addAttribute("article", article);

		return "usr/article/detail";
	}

	@RequestMapping("/usr/article/doWrite")
	@ResponseBody
	public ResultData<Article> doWrite(HttpSession session, String title, String body) {

		boolean isLogined = false;
		int loginedMemberId = 0;

		if (session.getAttribute("loginedMemberId") != null) {
			isLogined = true;
			loginedMemberId = (int) session.getAttribute("loginedMemberId");
		}

		if (isLogined == false) {
			return ResultData.from("F-A", "로그인 하고 써");
		}

		if (Ut.isEmptyOrNull(title)) {
			return ResultData.from("F-1", "제목을 입력하세요");
		}

		if (Ut.isEmptyOrNull(body)) {
			return ResultData.from("F-2", "내용을 입력하세요");
		}

		ResultData doWriteRd = articleService.writeArticle(loginedMemberId, title, body);

		int id = (int) doWriteRd.getData1();

		Article article = articleService.getArticleById(id);

		return ResultData.newData(doWriteRd, "새로 작성된 게시글", article);
	}

	@RequestMapping("/usr/article/list")
	public String showList(Model model) {

		List<Article> articles = articleService.getArticles();

		model.addAttribute("articles", articles);

		return "usr/article/list";
	}
}
