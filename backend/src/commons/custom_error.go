package commons

type timeError struct{}
type stringOfIntSliceError struct{}
type latError struct{}
type lngError struct{}
type statusError struct{}

func (e *timeError) Error() string {
	return "incorrect hour format, 'HH:MM' is the correct format"
}

func (e *stringOfIntSliceError) Error() string {
	return "wrong body request, please input number only"
}

func (e *latError) Error() string {
	return "incorrect latitude query parameter, " +
		"'-x.xxxxxxx' is the correct format, " +
		"the precision of the number after the decimal point is seven digits"
}

func (e *lngError) Error() string {
	return "error: incorrect longitude query parameter, " +
		"'xxx.xxxxxxx' is the correct format, " +
		"the precision of the number after the decimal point is seven digits"
}

func (e *statusError) Error() string {
	return "incorrect status input, status list ['pending','on process','accepted','cancelled','rejected']"
}
