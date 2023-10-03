package commons

import (
	"regexp"
)

func IsValidTime(str string) error {
	var err error
	var regex, _ = regexp.Compile(`^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$`)

	var isMatch = regex.MatchString(str)

	if !isMatch {
		return &timeError{}
	}

	return err
}
