package commons

func IsGeolocationStringInputAllowed(lat string, lng string) error {
	var err error

	if len(lat) < 9 {
		return &latError{}
	}

	if len(lng) < 10 {
		return &lngError{}
	}

	return err
}
