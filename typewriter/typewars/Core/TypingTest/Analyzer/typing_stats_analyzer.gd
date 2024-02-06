class_name TypingStatsAnalyzer
extends Node

signal stats_analyzed(results)


func analyze_typing_stats(typing_stats: Dictionary, time: int, words: int) -> void:
	var results = TypingStatsResult.new()
	var operators = CompareOperators.new()
	results.time = time
	results.words = words
	results._data = typing_stats

	for letter in typing_stats.keys():
		var letter_stats = typing_stats[letter]
		results.total_errors += letter_stats[ETypingStats.ERRORS]
		results.total_correct += letter_stats[ETypingStats.CORRECT]

		# get most accurate key
		if !results.most_accurate_key:
			results.most_accurate_key = letter
		else:
			results.most_accurate_key = compare_accuracy(
				typing_stats[letter], typing_stats[results.most_accurate_key]
			)
		# get most inaccurate key
		if !results.least_accurate_key:
			results.least_accurate_key = letter
		elif letter != results.most_accurate_key:
			results.least_accurate_key = compare_accuracy(
				typing_stats[letter], typing_stats[results.most_accurate_key], true
			)

		results.most_pressed_key = (
			letter
			if !results.most_pressed_key
			else compare_stat(
				letter_stats,
				typing_stats[results.most_pressed_key],
				ETypingStats.TOTAL_COUNT,
				funcref(operators, "is_greater")
			)
		)

		results.least_pressed_key = (
			letter
			if !results.least_pressed_key
			else compare_stat(
				letter_stats,
				typing_stats[results.least_pressed_key],
				ETypingStats.TOTAL_COUNT,
				funcref(operators, "is_lesser")
			)
		)
		if letter_stats[ETypingStats.FASTEST] != 0 && letter_stats[ETypingStats.CODE] != KEY_SPACE:
			results.fastest_key = (
				letter
				if !results.fastest_key
				else compare_stat(
					letter_stats,
					typing_stats[results.fastest_key],
					ETypingStats.FASTEST,
					funcref(operators, "is_lesser")
				)
			)

		results.slowest_key = (
			letter
			if !results.slowest_key
			else compare_stat(
				letter_stats,
				typing_stats[results.slowest_key],
				ETypingStats.FASTEST,
				funcref(operators, "is_greater")
			)
		)

		results.longest_key = (
			letter
			if !results.longest_key
			else compare_stat(
				letter_stats,
				typing_stats[results.longest_key],
				ETypingStats.LONGEST,
				funcref(operators, "is_greater")
			)
		)
		yield(get_tree(), "idle_frame")
	emit_signal("stats_analyzed", results)


func compare_accuracy(a: Dictionary, b: Dictionary, inverse: bool = false) -> int:
	var a_accuracy = get_accuracy(a[ETypingStats.CORRECT], a[ETypingStats.TOTAL_COUNT], inverse)
	var b_accuracy = get_accuracy(b[ETypingStats.CORRECT], b[ETypingStats.TOTAL_COUNT], inverse)
	if a_accuracy > b_accuracy:
		return a[ETypingStats.CODE]
	elif a_accuracy == b_accuracy:
		var a_count = a[ETypingStats.TOTAL_COUNT]
		var b_count = b[ETypingStats.TOTAL_COUNT]
		return a[ETypingStats.CODE] if a_count > b_count else b[ETypingStats.CODE]
	else:
		return b[ETypingStats.CODE]


func compare_stat(a: Dictionary, b: Dictionary, stat: int, operator: FuncRef) -> int:
	var a_stat = a[stat]
	var b_stat = b[stat]
	return a[ETypingStats.CODE] if operator.call_func(a_stat, b_stat) else b[ETypingStats.CODE]


func get_accuracy(correct, total, inverse) -> float:
	return correct / total if !inverse else (total - correct) / total
