package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repository.BoardRepository;
import com.example.demo.repository.ReactionPointRepository;
import com.example.demo.vo.Board;
import com.example.demo.vo.ResultData;

@Service
public class ReactionPointService {
	@Autowired
	private ReactionPointRepository reactionPointRepository;

	@Autowired
	private ArticleService articleService;

	public ReactionPointService(ReactionPointRepository reactionPointRepository) {
		this.reactionPointRepository = reactionPointRepository;
	}

	public int usersReaction(int loginedMemberId, String relTypeCode, int relId) {

		// 로그인 안했어
		if (loginedMemberId == 0) {
			return -2;
		}

		return reactionPointRepository.getSumReactionPoint(loginedMemberId, relTypeCode, relId);
	}

	public ResultData increaseReactionPoint(int loginedMemberId, String relTypeCode, int relId) {

		int affectedRow = reactionPointRepository.increaseReactionPoint(loginedMemberId, relTypeCode, relId);

		if (affectedRow != 1) {
			return ResultData.from("F-2", "좋아요 실패");
		}

		switch (relTypeCode) {
		case "article":
			articleService.increaseGoodReactionPoint(relId);
			break;
		}

		return ResultData.from("S-1", "좋아요!");
	}

}
