package dev.marshi.gcpsample

import org.springframework.boot.CommandLineRunner
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.stereotype.Component

@SpringBootApplication
class GcpsampleApplication

fun main(args: Array<String>) {
  runApplication<GcpsampleApplication>(*args)
}

@Component
class Runner : CommandLineRunner {
  override fun run(vararg args: String?) {
    println("hello GCP CI!!")
  }
}
