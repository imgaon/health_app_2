enum StatusType {
  success(200, '성공적으로 완료되었습니다.'),
  internalSeverError(500, '알 수 없는 에러가 발생했습니다.'),
  unauthorized(401, '아이디 또는 비밀번호를 확인해주세요'),
  alreadyExists(400, '해당 아이디가 이미 존재합니다.'),
  invalidEmailFormat(402, '이메일 형식이 잘못되었습니다.'),
  missingHeightOrWeight(405, '첫 회원 수정시 키와 몸무게를 입력하셔야합니다.'),
  expiredToken(403, '토큰이 만료되었습니다.');

  const StatusType(this.statusCode, this.message);

  final int statusCode;
  final String message;

  static StatusType fromStatusCode(int statusCode) {
    return StatusType.values.firstWhere(
      (type) => type.statusCode == statusCode,
      orElse: () => StatusType.internalSeverError,
    );
  }
}
