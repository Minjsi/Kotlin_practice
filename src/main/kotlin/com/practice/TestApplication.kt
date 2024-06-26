package com.practice

import com.practice.example.chapter1.Chapter1
import kotlinx.coroutines.runBlocking
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.context.properties.ConfigurationPropertiesScan

@SpringBootApplication
@ConfigurationPropertiesScan("com.practice")
class TestApplication


fun main(args: Array<String>) = runBlocking<Unit> {
//	runApplication<TestApplication>(*args)

//	Chapter1().code1()
//	Chapter1().code2()
//	Chapter1().code3()
//	Chapter1().code4()

	flagLoop1@
	while(true) {
		println("종료하려면 '0'를 입력하세요.\n" +
				"실행할 코드를 선택하세요.\n" +
				"1. Chapter1 : 코틀린 기본 문법 \n")
		val input = readln().toInt()
		when(input) {
			0 -> {
				break@flagLoop1
			}
			1 -> {
				Chapter1().code1()
			}
		}
	}

}


