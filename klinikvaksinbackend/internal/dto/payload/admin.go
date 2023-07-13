package payload

type AdminPayload struct {
	IdHealthFacilities string `json:"id_health_facilities"`
	Email              string `json:"email"`
	Password           string `json:"password"`
}
