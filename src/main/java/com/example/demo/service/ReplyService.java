package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repository.ReplyRepository;
import com.example.demo.util.Ut;
import com.example.demo.vo.Reply;
import com.example.demo.vo.ResultData;

@Service
public class ReplyService {

	@Autowired
	private ReplyRepository replyRepository;

	public ReplyService(ReplyRepository replyRepository) {
		this.replyRepository = replyRepository;
	}

	public List<Reply> getForPrintReplies(String relTypeCode, int id) {
		return replyRepository.getForPrintReplies(relTypeCode, id);
	}

	public ResultData writeReply(int loginedMemberId, String body, String relTypeCode, int relId) {
		replyRepository.writeReply(loginedMemberId, body, relTypeCode, relId);

		int id = replyRepository.getLastInsertId();

		return ResultData.from("S-1", Ut.f("%d번 댓글이 등록되었습니다", id), "등록 된 댓글의 id", id);
	}

}