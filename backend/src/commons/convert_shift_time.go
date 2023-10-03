package commons

import (
	"fmt"
	"time"
)

type Shift struct {
	StartTime  string
	FinishTime string
}

func ConvertShiftClockToShiftTime(StartTime string, FinishTime string) (startTime time.Time, endTime time.Time) {
	// convert the time to a string so can easily add the clock
	timeLayout := "2006-01-02T15:04"

	loc, err := time.LoadLocation("Asia/Jakarta")

	if err != nil {
		fmt.Println(err)
	}

	startDateStr := "2010-01-01" + "T" + StartTime
	startTime, _ = time.ParseInLocation(timeLayout, startDateStr, loc)

	endDateStr := "2010-01-01" + "T" + FinishTime
	endTime, _ = time.ParseInLocation(timeLayout, endDateStr, loc)

	if startTime.After(endTime) {
		// plus 1 day to the endTime if the endTime < startTime
		endTime = endTime.AddDate(0, 0, 1)
	}

	return startTime, endTime
}

func ConvertStringToShiftTime(dateInput string, hourInput string) time.Time {
	// convert the time to a string so can easily add the clock
	timeLayout := "2006-01-02T15:04"

	loc, err := time.LoadLocation("Asia/Jakarta")

	if err != nil {
		fmt.Println(err)
	}

	date, _ := time.Parse("02/01/2006", dateInput)
	startDateStr := date.Format("2006-01-02") + "T" + hourInput
	result, _ := time.ParseInLocation(timeLayout, startDateStr, loc)

	return result
}
