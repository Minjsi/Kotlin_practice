import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
	id("org.springframework.boot") version "3.1.4"
	id("io.spring.dependency-management") version "1.1.3"
	kotlin("jvm") version "1.8.22"
	kotlin("plugin.spring") version "1.8.22"
}

group = "com.practice"
version = "0.0.1-SNAPSHOT"

java {
	sourceCompatibility = JavaVersion.VERSION_17
}

configurations {
	compileOnly {
		extendsFrom(configurations.annotationProcessor.get())
	}
}

repositories {
	mavenCentral()
}

dependencies {

	// spring security : 사용자 인증 및 권한 부여와 같은 보안 기능 제공
//	implementation("org.springframework.boot:spring-boot-starter-security")
	// JSON Serialization 코틀린 클래스의 데이터를 JSON 형식으로 변환 하는 작업
	implementation("com.fasterxml.jackson.module:jackson-module-kotlin")
	//WebFlux 개발 스타터 컨트롤러와 엔드포인트를 정의하고 라우팅을 구성하는데 사용
	implementation("org.springframework.boot:spring-boot-starter-webflux")
	//R2DBC를 사용하여 데이터베이스에 대한 리액티브 엑세스를 제공, 관계형 데이터베이스와 비동기적 통신
	implementation("org.springframework.boot:spring-boot-starter-data-r2dbc")
	// 데이터 유효성 검사 프레임워크 사용
	implementation("org.springframework.boot:spring-boot-starter-validation")

	// 리액티브 프로그래밍 확장
	// 코틀린 리액티브 스트림을 더 효과적으로 처리
	implementation("io.projectreactor.kotlin:reactor-kotlin-extensions")
	// 코틀린 클래스 및 객체의 메타 데이터에 접근하고 조작 할 수 있음
	implementation("org.jetbrains.kotlin:kotlin-reflect")
	//비동기 및 동시성 작업을 처리
	implementation("org.jetbrains.kotlinx:kotlinx-coroutines-reactor")

	// Slf4j 및 Logback 로깅 구현
	implementation ("org.springframework.boot:spring-boot-starter-logging")
	implementation ("ch.qos.logback:logback-classic")


	// JWT
	implementation("io.jsonwebtoken:jjwt-api:0.11.5")
	implementation("io.jsonwebtoken:jjwt-impl:0.11.5")
	implementation("io.jsonwebtoken:jjwt-jackson:0.11.5")
	implementation("io.asyncer:r2dbc-mysql:1.0.3")
	// Logger
	implementation("io.github.oshai:kotlin-logging:5.1.0")


	// OpenAPI Documentation
	implementation("org.springdoc:springdoc-openapi-starter-webflux-ui:2.0.4")


	testImplementation("org.springframework.boot:spring-boot-starter-test")
	testImplementation("io.projectreactor:reactor-test")
//	testImplementation("org.springframework.security:spring-security-test")
}

tasks.withType<KotlinCompile> {
	kotlinOptions {
		freeCompilerArgs += "-Xjsr305=strict"
		jvmTarget = "17"
	}
}

tasks.withType<Test> {
	useJUnitPlatform()
}
