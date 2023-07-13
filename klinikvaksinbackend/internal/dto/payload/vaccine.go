package payload

type VaccinePayload struct {
	Name  string `json:"name" validate:"required"`
	Dose  int    `json:"dose" validate:"required"`
	Stock int    `json:"stock"`
}

type VaccineUpdatePayload struct {
	Name  string `json:"name"`
	Dose  int    `json:"dose"`
	Stock int    `json:"stock"`
}
