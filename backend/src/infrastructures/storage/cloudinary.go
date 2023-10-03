package storage

import (
	"context"
	"fmt"
	"github.com/cloudinary/cloudinary-go/v2"
	"github.com/cloudinary/cloudinary-go/v2/api/uploader"
	"github.com/superosystem/SewaKantor/backend/src/commons"
	"log"
	"mime/multipart"
)

type CloudinaryConfiguration struct {
	CLOUD_NAME string
	API_KEY    string
	SECRET_KEY string
}

func (config *CloudinaryConfiguration) CloudinaryUpload(ctx context.Context, source multipart.File, userId string) (string, error) {
	cld, _ := cloudinary.NewFromParams(config.CLOUD_NAME, config.API_KEY, config.SECRET_KEY)

	// Upload image and set the PublicID to userId.
	resp, err := cld.Upload.Upload(
		ctx,
		source,
		uploader.UploadParams{
			PublicID: fmt.Sprintf("user-%s", userId),
			Format:   "jpg",
			Folder:   "better-space/staging/photo",
		},
	)

	url := resp.SecureURL

	return url, err
}

func (config *CloudinaryConfiguration) CloudinaryUploadOfficeImgs(files []*multipart.FileHeader) ([]string, error) {
	ctx := context.Background()

	cld, _ := cloudinary.NewFromParams(config.CLOUD_NAME, config.API_KEY, config.SECRET_KEY)

	var imageURLs []string
	var err error

	for i := len(files) - 1; i >= 0; i-- {
		src, err := files[i].Open()

		if err != nil {
			log.Println(err)
			return imageURLs, err
		}

		fileName := commons.RandomString(25)

		// upload image and set the PublicID to fileName.
		resp, err := cld.Upload.Upload(
			ctx,
			src,
			uploader.UploadParams{
				PublicID: fileName,
				Format:   "jpg",
				Folder:   "better-space/staging/office-image",
			},
		)

		if err != nil {
			log.Println(err)
			return imageURLs, err
		}

		url := resp.SecureURL

		imageURLs = append(imageURLs, url)

		defer src.Close()
	}

	return imageURLs, err
}
