package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class UsrHomeController {

	private int count;

	public UsrHomeController() {
		count = 0;
	}

	@RequestMapping("/usr/home/setCountValue")
	@ResponseBody
	public String setCountValue(int value) {
		this.count = value;
		return "count 값 " + value + "(으)로 초기화";
	}

	@RequestMapping("/usr/home/setCount")
	@ResponseBody
	public String setCount() {
		count = 0;
		return "count 값 0으로 초기화";
	}

	@RequestMapping("/usr/home/getCount")
	@ResponseBody
	public int getCount() {
		return count++;
	}

	@RequestMapping("/usr/home/main2")
	@ResponseBody
	public String showMain2() {
		return "잘가";
	}

	@RequestMapping("/usr/home/main3")
	@ResponseBody
	public int showMain3() {
		int a = 1;
		int b = 2;

		return a + b;
	}
}
