/// Represents a user in the Diksha Finance demo application.
///
/// All fields are demo/mock data. No real user information
/// is collected or stored.
class UserModel {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? dateOfBirth;
  final String? gender;
  final String? pan;
  final String? address;
  final String? city;
  final String? state;
  final String? pincode;
  final String? employmentType;
  final double? monthlyIncome;
  final String? profileImageUrl;
  final String selectedLanguage;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.dateOfBirth,
    this.gender,
    this.pan,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.employmentType,
    this.monthlyIncome,
    this.profileImageUrl,
    this.selectedLanguage = 'en',
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? dateOfBirth,
    String? gender,
    String? pan,
    String? address,
    String? city,
    String? state,
    String? pincode,
    String? employmentType,
    double? monthlyIncome,
    String? profileImageUrl,
    String? selectedLanguage,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      pan: pan ?? this.pan,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      employmentType: employmentType ?? this.employmentType,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }

  /// Mock user for demo purposes.
  static UserModel mock() {
    return const UserModel(
      id: 'DEMO-001',
      name: 'Rahul Sharma',
      phone: '9876543210',
      email: 'rahul.sharma@example.com',
      dateOfBirth: '15/03/1990',
      gender: 'Male',
      pan: 'ABCDE1234F',
      address: '123, Demo Street, Example Colony',
      city: 'Mumbai',
      state: 'Maharashtra',
      pincode: '400001',
      employmentType: 'Salaried',
      monthlyIncome: 65000,
    );
  }
}
