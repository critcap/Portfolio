class_name Int2Word

static func friendly_integer(n: int, left_digits: String = "", k: int = 0) -> String:
	# * Cannot have static member vars so I will make my own 

	var s: Array = ["", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"]
	var t: Array = ["Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen"]
	var d: Array = ["Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"]
	var m: Array = ["", " Thousand", " Million", " Billion", " Trillion" ]

	if left_digits.length() > 0:
		left_digits += " "

	if n == 0:
		return left_digits
	if n < 10:
		left_digits += s[n]
	elif n < 20:
		left_digits += t[n - 10]
	elif n < 100:
		left_digits += friendly_integer(n % 10, d[n / 10 - 2])
	elif n < 1000:
		left_digits += friendly_integer(n % 100, (s[n/100] + " Hundred"))
	else:
		left_digits += friendly_integer(n % 1000, friendly_integer(n / 1000, "", k +1))
		if n % 1000 == 0:
			return left_digits
	return left_digits + m[k]

static func to_word(n: int) -> String:
	var zero = "Zero"
	var negativ = "-"

	if n == 0:
		return zero
	elif n < 0:
		return negativ + to_word(n * -1)

	return friendly_integer(n)

