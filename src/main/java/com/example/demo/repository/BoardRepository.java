package com.example.demo.repository;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.vo.Board;

@Mapper
public interface BoardRepository {

	public Board getBoardById(int id);

}
