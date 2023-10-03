package offices

import (
	"fmt"
	"github.com/superosystem/SewaKantor/backend/src/domains/offices"
	"sort"
	"strconv"
	"strings"

	"gorm.io/gorm"
)

type officeRepository struct {
	conn *gorm.DB
}

func NewMySQLRepository(conn *gorm.DB) offices.Repository {
	return &officeRepository{
		conn: conn,
	}
}

type imgs struct {
	Id     string
	Images string
}

type facilities struct {
	Id     string
	F_id   string
	F_desc string
	F_slug string
}

type distance struct {
	Id       string
	Distance float64
}

type totalBooked struct {
	OfficeId    string
	TotalBooked int64
}

type rateScore struct {
	OfficeId string
	Score    float64
}

func (or *officeRepository) GetAll() []offices.Domain {
	var images []imgs
	var officeFacilities []facilities
	var totalBooked []totalBooked
	var rateScore []rateScore
	var rec []Office

	or.conn.Find(&rec)

	queryGetTotalBooked := "SELECT `office_id`, COUNT(*) AS total_booked FROM `transactions` WHERE `status` NOT IN ('rejected', 'cancelled') GROUP BY `office_id`"
	or.conn.Raw(queryGetTotalBooked).Scan(&totalBooked)

	queryGetRateScore := "SELECT `office_id`, ROUND(AVG(`score`), 1) AS score FROM `reviews` GROUP BY `office_id`;"
	or.conn.Raw(queryGetRateScore).Scan(&rateScore)

	officeDomain := []offices.Domain{}

	// get office images
	or.conn.Table("office_images").
		Select("office_id AS id, GROUP_CONCAT(office_images.url ORDER BY office_images.id SEPARATOR ' , ') AS images").
		Group("office_id").
		Scan(&images)

	// get office facilities
	groupConcatFacId := "GROUP_CONCAT(office_facilities.facilities_id ORDER BY office_facilities.facilities_id SEPARATOR ' , ') AS f_id"
	groupConcatFacDesc := "GROUP_CONCAT(facilities.description ORDER BY office_facilities.facilities_id SEPARATOR ' , ') AS f_desc"
	groupConcatFacSlug := "GROUP_CONCAT(facilities.slug ORDER BY office_facilities.facilities_id SEPARATOR ' , ') AS f_slug"
	querySelect := fmt.Sprintf("offices.id, %s, %s, %s", groupConcatFacId, groupConcatFacDesc, groupConcatFacSlug)

	or.conn.Table("offices").
		Select(querySelect).
		Joins("INNER JOIN office_facilities ON offices.id=office_facilities.office_id").
		Joins("INNER JOIN facilities ON office_facilities.facilities_id=facilities.id").
		Group("offices.id").
		Scan(&officeFacilities)

	// total_booked counter
	or.conn.Table("transactions").
		Not(map[string]interface{}{"status": []string{"rejected", "cancelled"}}).
		Select("office_id, COUNT(*) AS total_booked").
		Group("office_id").
		Scan(&totalBooked)

	// average rating counter
	or.conn.Table("reviews").
		Select("office_id as OfficeId, round(avg(score), 1) as Score").
		Group("office_id").
		Scan(&rateScore)

	for _, office := range rec {
		for _, v := range images {
			if strconv.Itoa(int(office.ID)) == v.Id {
				url := v.Images
				img := strings.Split(url, " , ")
				office.Images = img
				break
			}
		}

		for _, fac := range officeFacilities {
			if strconv.Itoa(int(office.ID)) == fac.Id {
				facilitesId := strings.Split(fac.F_id, " , ")
				facilitesDesc := strings.Split(fac.F_desc, " , ")
				facilitiesSlug := strings.Split(fac.F_slug, " , ")

				office.FacilitiesId = facilitesId
				office.FacilitiesDesc = facilitesDesc
				office.FacilitesSlug = facilitiesSlug
				break
			}
		}

		for _, b := range totalBooked {
			if strconv.Itoa(int(office.ID)) == b.OfficeId {
				office.TotalBooked = b.TotalBooked
				break
			}
		}

		for _, r := range rateScore {
			if strconv.Itoa(int(office.ID)) == r.OfficeId {
				office.Rate = r.Score
				break
			}
		}

		officeDomain = append(officeDomain, office.ToDomain())
	}

	return officeDomain
}

func (or *officeRepository) GetByID(id string) offices.Domain {
	var office Office
	var images string
	var count int64
	var rate_score float64

	or.conn.First(&office, "id = ?", id)

	// get office images
	or.conn.Table("office_images").
		Where("office_id = ?", id).
		Select("GROUP_CONCAT(office_images.url ORDER BY office_images.id SEPARATOR ' , ')").
		Scan(&images)

	img := strings.Split(images, " , ")
	office.Images = img

	var officeFacilities facilities

	// get office facilities
	groupConcatFacId := "GROUP_CONCAT(office_facilities.facilities_id ORDER BY office_facilities.facilities_id SEPARATOR ' , ') AS f_id"
	groupConcatFacDesc := "GROUP_CONCAT(facilities.description ORDER BY office_facilities.facilities_id SEPARATOR ' , ') AS f_desc"
	groupConcatFacSlug := "GROUP_CONCAT(facilities.slug ORDER BY office_facilities.facilities_id SEPARATOR ' , ') AS f_slug"
	querySelect := fmt.Sprintf("%s, %s, %s", groupConcatFacId, groupConcatFacDesc, groupConcatFacSlug)

	or.conn.Table("offices").
		Select(querySelect).
		Joins("INNER JOIN office_facilities ON offices.id=office_facilities.office_id").
		Joins("INNER JOIN facilities ON office_facilities.facilities_id=facilities.id WHERE office_id = ?", office.ID).
		Scan(&officeFacilities)

	facilitesId := strings.Split(officeFacilities.F_id, " , ")
	facilitesDesc := strings.Split(officeFacilities.F_desc, " , ")
	facilitiesSlug := strings.Split(officeFacilities.F_slug, " , ")

	office.FacilitiesId = facilitesId
	office.FacilitiesDesc = facilitesDesc
	office.FacilitesSlug = facilitiesSlug

	or.conn.Table("transactions").
		Not(map[string]interface{}{"status": []string{"rejected", "cancelled"}}).
		Where("office_id = ?", office.ID).
		Count(&count)

	or.conn.Table("reviews").Where("office_id = ?", office.ID).Select("round(avg(score), 1)").Scan(&rate_score)

	office.TotalBooked = count
	office.Rate = rate_score

	return office.ToDomain()
}

func (or *officeRepository) Create(officeDomain *offices.Domain) offices.Domain {
	var result *gorm.DB

	rec := FromDomain(officeDomain)

	facilitiesIdList := []int{}

	for _, v := range rec.FacilitiesId {
		id, _ := strconv.Atoi(v)
		facilitiesIdList = append(facilitiesIdList, id)
	}

	sort.Sort(sort.Reverse(sort.IntSlice(facilitiesIdList)))

	for _, v := range facilitiesIdList {
		if err := or.conn.Exec(fmt.Sprintf("SELECT * FROM facilities WHERE id = %d", v)).Error; err != nil {
			return rec.ToDomain()
		}
	}

	err := or.conn.Transaction(func(tx *gorm.DB) error {
		result = tx.Create(&rec)
		result.Last(&rec)

		// insert to pivot table office_images
		for _, v := range rec.Images {
			querySQL := fmt.Sprintf("INSERT INTO office_images(url, office_id) VALUES ('%s', '%s')", v, strconv.Itoa(int(rec.ID)))

			if err := tx.Table("office_images").Exec(querySQL).Error; err != nil {
				return err
			}
		}

		// insert to pivot table office_facilities
		for _, v := range facilitiesIdList {
			querySQL := fmt.Sprintf("INSERT INTO office_facilities(facilities_id, office_id) VALUES ('%d','%d')", v, rec.ID)
			if err := tx.Table("office_facilities").Exec(querySQL).Error; err != nil {
				return err
			}
		}

		return nil
	})

	if err != nil {
		rec.ID = 0
		return rec.ToDomain()
	}

	return rec.ToDomain()
}

func (or *officeRepository) Update(id string, officeDomain *offices.Domain) offices.Domain {
	var office = or.GetByID(id)

	if office.ID == 0 {
		return office
	}

	updatedOffice := FromDomain(&office)

	facilitiesIdList := []int{}

	for _, v := range officeDomain.FacilitiesId {
		id, _ := strconv.Atoi(v)
		facilitiesIdList = append(facilitiesIdList, id)
	}

	sort.Sort(sort.Reverse(sort.IntSlice(facilitiesIdList)))

	for _, v := range facilitiesIdList {
		if err := or.conn.Exec(fmt.Sprintf("SELECT * FROM facilities WHERE id = %d", v)).Error; err != nil {
			office.ID = 0
			return office
		}
	}

	err := or.conn.Transaction(func(tx *gorm.DB) error {
		if len(officeDomain.Images) != 0 {
			queryDeleteImgs := fmt.Sprintf("DELETE FROM office_images WHERE office_id = %d", office.ID)

			or.conn.Table("office_images").Exec(queryDeleteImgs)

			// insert to pivot table office_images
			for _, v := range officeDomain.Images {
				querySQL := fmt.Sprintf("INSERT INTO office_images(url, office_id) VALUES ('%s', '%d')", v, office.ID)

				if err := or.conn.Table("office_images").Exec(querySQL).Error; err != nil {
					return err
				}
			}
		}

		queryDeleteFacs := fmt.Sprintf("DELETE FROM office_facilities WHERE office_id = %d", office.ID)

		if err := or.conn.Table("office_images").Exec(queryDeleteFacs).Error; err != nil {
			return err
		}

		// insert to pivot table office_facilities
		for _, v := range facilitiesIdList {
			querySQL := fmt.Sprintf("INSERT INTO office_facilities(facilities_id, office_id) VALUES ('%d','%d')", v, office.ID)
			if err := tx.Table("office_facilities").Exec(querySQL).Error; err != nil {
				return err
			}
		}

		updatedOffice.Title = officeDomain.Title
		updatedOffice.Description = officeDomain.Description
		updatedOffice.OfficeType = officeDomain.OfficeType
		updatedOffice.OfficeLength = officeDomain.OfficeLength
		updatedOffice.Price = officeDomain.Price
		updatedOffice.OpenHour = officeDomain.OpenHour
		updatedOffice.CloseHour = officeDomain.CloseHour
		updatedOffice.Lat = officeDomain.Lat
		updatedOffice.Lng = officeDomain.Lng
		updatedOffice.Accommodate = officeDomain.Accommodate
		updatedOffice.WorkingDesk = officeDomain.WorkingDesk
		updatedOffice.MeetingRoom = officeDomain.MeetingRoom
		updatedOffice.PrivateRoom = officeDomain.PrivateRoom
		updatedOffice.City = officeDomain.City
		updatedOffice.District = officeDomain.District
		updatedOffice.Address = officeDomain.Address

		tx.Save(&updatedOffice)

		return nil
	})

	if err != nil {
		updatedOffice.ID = 0
		return updatedOffice.ToDomain()
	}

	return updatedOffice.ToDomain()
}

func (or *officeRepository) Delete(id string) bool {
	var office = or.GetByID(id)

	if office.ID == 0 {
		return false
	}

	deletedOffice := FromDomain(&office)
	result := or.conn.Delete(&deletedOffice)

	if result.RowsAffected == 0 {
		return false
	}

	queryDeleteImgs := fmt.Sprintf("DELETE FROM office_images WHERE office_id = '%d'", deletedOffice.ID)
	or.conn.Table("office_images").Exec(queryDeleteImgs)

	queryDeleteFac := fmt.Sprintf("DELETE FROM office_facilities WHERE office_id = '%d'", deletedOffice.ID)
	or.conn.Table("office_facilities").Exec(queryDeleteFac)

	return true
}

func (or *officeRepository) GetNearest(lat string, long string) []offices.Domain {
	var dist []distance
	rec := or.GetAll()

	powLat := fmt.Sprintf("POW(69.1 * (offices.lat - '%s'), 2)", lat)
	powLng := fmt.Sprintf("POW(69.1 * ('%s' - offices.lng) * COS(offices.lng / 57.3), 2)", long)
	sqrt := fmt.Sprintf("SQRT(%s + %s) * 1.60934", powLat, powLng)
	cast := fmt.Sprintf("offices.id as id, CAST(%s AS DECIMAL (16,2)) as distance", sqrt)
	or.conn.Table("offices").Select(cast).Scan(&dist)

	officeDomain := []offices.Domain{}

	for _, office := range rec {
		for _, d := range dist {
			if strconv.Itoa(int(office.ID)) == d.Id {
				office.Distance = d.Distance
				break
			}
		}

		officeDomain = append(officeDomain, office)
	}

	return officeDomain
}
