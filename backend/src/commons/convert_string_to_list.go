package commons

import (
	"regexp"
	"strings"
)

func StringToList(str string) []string {
	withoutWhitespace := strings.ReplaceAll(str, " ", "")
	commaSeparated := strings.Split(withoutWhitespace, ",")

	return commaSeparated
}

func IsIdListStringAllowed(str string) error {
	var err error
	var regex, _ = regexp.Compile(`^\d+(,\d+)*$`)

	var isMatch = regex.MatchString(str)

	if !isMatch {
		return &stringOfIntSliceError{}
	}

	return err
}
