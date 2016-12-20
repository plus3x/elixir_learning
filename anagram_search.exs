defmodule AnagramSearch do
  def decremental(source: source, search_word: search_word) do
    search_word_chars = String.codepoints(search_word)
    search_word_length = String.length(search_word)

    Enum.filter source, fn(line) ->
      word = String.replace(line, "\n", "")

      String.length(word) == search_word_length &&
        Enum.all? search_word_chars, fn(char) ->
          original_length = String.length(word)

          word = String.replace(word, char, "", global: false)

          String.length(word) != original_length
        end
    end
  end
end

defmodule AnagramSearchTest do
  def process!(source: source, search_word: search_word, expected_result: expected_result, method: method) do
    result = apply(AnagramSearch, method, [[source: source, search_word: search_word]])

    if result != expected_result, do: IO.puts "Result doesn't match, expected #{expected_result} but actual #{result}"
  end
end

defmodule Benchmark do
  def realtime(fun) do
    start_time = :os.system_time(:nano_seconds)

    fun.()

    (:os.system_time(:nano_seconds) - start_time) / 1_000_000_000
  end
end

source = File.stream!("/usr/share/dict/words")
iterations = 1

word = "team"
expected_result = ["mate\n", "meat\n", "meta\n", "tame\n", "team\n"]

IO.puts "### Short word(#{word}) ###"

time = Benchmark.realtime fn ->
  for _ <- 1..iterations do
    AnagramSearchTest.process!(source: source, search_word: word, expected_result: expected_result, method: :decremental)
  end
end
IO.puts "Decremental: #{Float.to_string(time, decimals: 6)}"

"""
### Short word(team) ###
Decremental: 0.871180
"""
