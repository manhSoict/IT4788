class UserSearch {
  final String accountId;
  final String firstName;
  final String lastName;
  final String email;

  UserSearch({
    required this.accountId,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory UserSearch.fromJson(Map<String, dynamic> json) {
    return UserSearch(
      accountId: json['account_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
    );
  }
}
