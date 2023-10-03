class ReviewModels {
  late String reviewComment;
  late double reviewRating;
  late int reviewedOfficeId;
  int? reviewId;
  int? userId;
  DateTime? createdAt;
  ReviewModels(
      {required this.reviewComment,
      required this.reviewRating,
      required this.reviewedOfficeId,
      this.reviewId,
      this.userId,
      this.createdAt});
}
