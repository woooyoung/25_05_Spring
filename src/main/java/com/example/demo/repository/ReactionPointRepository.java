package com.example.demo.repository;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ReactionPointRepository {

	int getSumReactionPoint(int loginedMemberId, String relTypeCode, int relId);

}
