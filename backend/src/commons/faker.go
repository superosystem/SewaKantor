package commons

import "github.com/go-faker/faker/v4"

func CreateFaker[T any]() (T, error) {
	var fakerData = new(T)

	err := faker.FakeData(fakerData)

	if err != nil {
		return *fakerData, err
	}

	return *fakerData, nil
}
