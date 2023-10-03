package response

type user struct {
	UserID   uint   `json:"user_id"`
	FullName string `json:"full_name"`
	Email    string `json:"email"`
}

type office struct {
	OfficeID   uint   `json:"office_id"`
	OfficeName string `json:"office_name"`
	OfficeType string `json:"office_type"`
}

type checkIn struct {
	Date string `json:"date"`
	Time string `json:"time"`
}
type checkOut struct {
	Date string `json:"date"`
	Time string `json:"time"`
}
