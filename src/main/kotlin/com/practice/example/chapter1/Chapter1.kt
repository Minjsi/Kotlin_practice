package com.practice.example.chapter1


class Chapter1 {

    /**
     * 코틀린에는 변수 선언 방식이 두 가지가 있다.
     * val : 읽기 전용 변수 (자바의 final 변수와 비슷)
     * var : 읽기 쓰기 가능한 변수
     * println : 콘솔에 출력하는 함수
     * print : 콘솔에 출력하는 함수 (줄바꿈 없음)
     * $변수명 : 문자열 템플릿 (변수를 문자열에 포함시킬 때 사용)
     * 코틀린은 세미콜론 생략
     */
    fun code1() {
        val a = 1
        var b = 0
        b = 1234

//        a = 1234 // Val cannot be reassigned ide 에러 발생

        print("변경 된 b 값 $b   ")
        println("a는 값을 변경 할 수 없는 val 형태 : $a")
    }


    /**
     * 코틀린은 문자열 템플릿 기능을 제공한다.
     * $기호 뒤에 중괄호{}를 사용하여 변수나 식을 지정하면 변수나 식의 값을 문자열에 포함시킬 수 있다.
     *
     * 예시 자바 코드
     * int a = 2;
     * int b = 3;
     * System.out.println(a + " + " + b + " = " + (a + b));	// 2 + 3 = 5
     * System.out.println(a + "\t" + b);	// 2	3
     */
    fun code2() {
        val a = 2
        val b = 3
        println("$a + $b = ${a + b}")    // 2 + 3 = 5 쌍따옴표 안에서 식별자로 문자열처럼 사용 가능
        println("$a\t$b")    // 2	3

        // 문자열 템플릿을 사용하지 않은 경우 문자열과 변수를 +로 연결하여 출력 해야함
        // int로 선언된 변수는 toString() 메서드를 사용하여 문자열로 변환해야함
        println(a.toString() + " + " + b + " = " + (a + b))    // 2 + 3 = 5
    }


    /**
     * 동일성(Referential equality)과 동등성(Structural equality)
     * 자바에서는 기본 자료형과 참조자료형이 존재한다.
     * 자바 기본 자료형 :  int, long, float, double, char, boolean
     * 자바 참조 자료형 : Integer, Long, Float, Double, Character, Boolean
     * 코틀린은 기본 자료형과 참조 자료형을 구분하지 않고 모든 자료형이 참조 자료형이다.
     * 코틀린은 자바의 기본 자료형을 클래스로 제공한다.
     * 참조자료형 : 스택에 참조 주소 저장, null 초기화 가능, 참조 주소 위치에 해당하는 곳(힙)에 실제 값 저장
     * 자료형? > 참조자료형 래퍼 클래스로 박싱 됨
     * Int -> Int (Primitive type)
     * Int? -> Integer (Reference type)
     * 동일성 : 두 객체의 주소값이 같은지 비교 (===)
     * 동등성 : 두 객체의 내용이 같은지 비교 (==)
     */
    fun code3() {
        val str1 = "Hello"
        val str2 = "HELLO"
        // String 클래스의 생성자를 사용하여 문자열을 생성하면 새로운 문자열 객체가 생성된다. 주소값이 다르다.
        val str3 = String(StringBuilder("Hello"))
        // 문자열 리터럴을 사용하여 문자열을 생성하면 문자열 풀에 이미 같은 내용의 문자열이 존재하면 새로운 객체를 생성하지 않고 참조한다.
        val str4 = "Hello"

        // 문자열의 내용이 다르므로 false 출력
        println("str1 == str2 : ${str1 == str2}")
        // 대소문자를 무시하고 비교하여 true 출력
        println("str1.equals(str2, true) : ${str1.equals(str2, true)}")
        // 문자열의 주소값이 다르므로 false 출력
        println("str1 === str3 : ${str1 === str3}")
        // str1과 str4 는 같은 문자열 리터럴을 참조하므로 true 출력 문자열 리터럴이란 동일한 문자열을 참조하는 문자열
        println("str1 === str4 : ${str1 === str4}")
        // 내용을 비교하여 true 출력
        println("str1 == str3 : ${str1 == str3}")
    }

    /**
     * 코틀린의 collection Type
     * Array(배열) : 동일한 데이터 타입의 요소, 추가 삭제 수정 불가능
     * List(리스트) : 서로다른 데이터 타입의 요소 가능
     * Set(집합) : 중복된 요소를 허용하지 않음
     *
     * List, listOf : 순서가 있는 컬렉션, 중복 허용, 불변형 List 생성
     * Set, setOf : 순서가 없는 컬렉션, 중복 허용하지 않음, 불변형 Set 생성
     * Map, mapOf : 키와 값의 쌍으로 이루어진 컬렉션, 불변형 map 생성
     * MutableList, mutableListOf : List의 수정 가능한 버전, 가변형 List 생성
     * MutableSet, mutableSetOf : Set의 수정 가능한 버전, 가변형 Set 생성
     * MutableMap, mutableMapOf: Map의 수정 가능한 버전, 가변형 Map 생성
     *
     * arrayList, mutableList 둘다 동적으로 변경할 수 있고, 요소의 추가, 삭제, 수정 등이 가능하다.
     * arrayList : java.util.ArrayList 클래스의 인스턴스 생성, import java.util.ArrayList
     * mutableListOf : 코틀린 표준 라이브러리 함수, import 필요 없음 (hashSet과 mutableSet도 동일한 원리)
     * */
    fun code4() {
        val numbers: ArrayList<Int> = ArrayList<Int>().apply {
            add(1)
            add(2)
            add(3)
        }
        println("ArrayList numbers : $numbers")

        val numbers2 : MutableList<Int> = mutableListOf<Int>().apply {
            add(1)
            add(2)
            add(3)
        }
        println("MutableList numbers2 : $numbers2")

        val distinctNumbers: MutableSet<Int> = mutableSetOf(1,2,3)

        distinctNumbers.add(2)
        distinctNumbers.add(3)
        distinctNumbers.add(4)
        println("1,2,3 set에 2,3,4 추가함 MutableSet distinctNumbers : $distinctNumbers")

    }


    /**
     * Map, Pair, Triple
     * Map : 키와 값의 쌍으로 이루어진 컬렉션
     * Pair : 두 개의 값을 가지는 데이터 클래스
     * Triple : 세 개의 값을 가지는 데이터 클래스
     * 권장 : 데이터 클래스를 사용하여 데이터를 그룹화하고, Pair, Triple은 사용하지 않는 것이 좋다.
     *
     */

    fun code5() {
        val maps = mapOf(1 to "one",2 to "two",3 to "three")

    }


}