package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repository.BoardRepository;
import com.example.demo.repository.ReactionPointRepository;
import com.example.demo.vo.Board;

@Service
public class ReactionPointService {
	@Autowired
	private ReactionPointRepository reactionPointRepository;

	public ReactionPointService(ReactionPointRepository reactionPointRepository) {
		this.reactionPointRepository = reactionPointRepository;
	}

	public int userCanReaction(int loginedMemberId, String relTypeCode, int relId) {

		// 로그인 안했어
		if (loginedMemberId == 0) {
			return -2;
		}

		return reactionPointRepository.getSumReactionPoint(loginedMemberId, relTypeCode, relId);
	}

}
