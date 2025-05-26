package com.example.demo.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.vo.Reply;

@Mapper
public interface ReplyRepository {

	public List<Reply> getForPrintReplies(String relTypeCode, int relId);
}
