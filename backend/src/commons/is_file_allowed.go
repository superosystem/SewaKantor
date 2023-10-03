package commons

import (
	"mime/multipart"
	"strings"
)

func IsFileAllowed(fileInput *multipart.FileHeader) (bool, string) {
	fileName := fileInput.Filename
	fileSize := fileInput.Size
	fileExtension := fileName[len(fileName)-5:]

	var isFileAllowed bool
	var msg string

	// list of allowed extension file to upload
	allowedExtension := []string{".jpeg", ".jpg"}

	for _, v := range allowedExtension {
		if strings.Contains(fileExtension, v) {
			isFileAllowed = true
			break
		} else {
			isFileAllowed = false
			msg = "file extension is not allowed, please upload in .jpeg or .jpg format"
		}
	}

	//allowedSize = (allowed size for uploading = 2.1 MB) * (1 KB = 1024 bytes) * (1024 bytes)
	allowedSize := 2.2 * 1024 * 1024

	if fileSize > int64(allowedSize) {
		isFileAllowed = false
		msg = "file size is not allowed, please upload file under 2 MB"
	}

	return isFileAllowed, msg
}

func IsFilesAllowed(files []*multipart.FileHeader) (bool, string) {
	var isFilesAllowed bool
	var msg string

	if len(files) != 4 {
		isFilesAllowed = false
		msg := "please input four images only"
		return isFilesAllowed, msg
	}

	for _, file := range files {
		fileName := file.Filename
		fileSize := file.Size
		fileExtension := fileName[len(fileName)-5:]

		// list of allowed extension file to upload
		allowedExtension := []string{".jpeg", ".jpg"}

		for _, v := range allowedExtension {
			if strings.Contains(fileExtension, v) {
				isFilesAllowed = true
				break
			} else {
				isFilesAllowed = false
				msg = "file extension is not allowed, please upload in .jpeg or .jpg format"
			}
		}

		if !isFilesAllowed {
			return isFilesAllowed, msg
		}

		//allowedSize = (allowed size for uploading = 2.1 MB) * (1 KB = 1024 bytes) * (1024 bytes)
		allowedSize := 2.2 * 1024 * 1024

		if fileSize > int64(allowedSize) {
			isFilesAllowed = false
			msg = "file size is not allowed, please upload files under 2 MB"

			return isFilesAllowed, msg
		}
	}

	return isFilesAllowed, msg
}
