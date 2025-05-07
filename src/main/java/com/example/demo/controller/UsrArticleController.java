package com.example.demo.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.vo.Article;

@Controller
public class UsrArticleController {

	int lastArticleId;
	List<Article> articles;

	// 생성자
	public UsrArticleController() {
		articles = new ArrayList<>();
		lastArticleId = 0;

		makeTestData();
	}

	// 서비스메서드
	private void makeTestData() {
		for (int i = 1; i <= 10; i++) {
			String title = "제목 " + i;
			String body = "내용" + i;

			writeArticle(title, body);
		}

	}

	private Article writeArticle(String title, String body) {
		int id = lastArticleId + 1;

		Article article = new Article(id, title, body);
		articles.add(article);

		lastArticleId++;

		return article;

	}

	private Article getArticleById(int id) {
		for (Article article : articles) {
			if (article.getId() == id) {
				return article;
			}
		}
		return null;
	}

	// 액션메서드

	@RequestMapping("/usr/article/doModify")
	@ResponseBody
	public Object doModify(int id, String title, String body) {

		Article article = getArticleById(id);

		if (article == null) {
			return id + "번 글은 없음";
		}

		article.setTitle(title);
		article.setBody(body);

//		return article + "글이 수정됨(" + id + ")";
		return article;
	}

	@RequestMapping("/usr/article/getArticle")
	@ResponseBody
	public Object getArticle(int id) {

		Article article = getArticleById(id);

		if (article == null) {
			return id + "번 글은 없음";
		}

		return article;
	}

	@RequestMapping("/usr/article/doDelete")
	@ResponseBody
	public String doDelete(int id) {

		Article article = getArticleById(id);

		if (article == null) {
			return id + "번 글은 없음";
		}

		articles.remove(article);

		return id + "번 글이 삭제되었습니다";
	}

	@RequestMapping("/usr/article/doAdd")
	@ResponseBody
	public Article doAdd(String title, String body) {
		Article article = writeArticle(title, body);
		return article;
	}

	@RequestMapping("/usr/article/getArticles")
	@ResponseBody
	public List<Article> getArticles() {

		return articles;
	}
}
