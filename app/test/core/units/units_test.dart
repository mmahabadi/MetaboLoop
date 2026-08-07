import 'package:flutter_test/flutter_test.dart';
import 'package:metaboloop/core/units/units.dart';

void main() {
  group('kg/lb conversion', () {
    test('kgToLb matches a known reference value', () {
      expect(kgToLb(100), closeTo(220.462, 0.01));
    });

    test('lbToKg is the inverse of kgToLb', () {
      final kg = 82.5;
      expect(lbToKg(kgToLb(kg)), closeTo(kg, 0.0001));
    });
  });

  group('cm/inches conversion', () {
    test('cmToInches matches a known reference value', () {
      expect(cmToInches(180), closeTo(70.866, 0.01));
    });

    test('inchesToCm is the inverse of cmToInches', () {
      final cm = 165.0;
      expect(inchesToCm(cmToInches(cm)), closeTo(cm, 0.0001));
    });
  });

  group('inchesToFeetAndInches', () {
    test('splits an exact number of feet with no remainder', () {
      final result = inchesToFeetAndInches(72);
      expect(result.feet, 6);
      expect(result.inches, 0);
    });

    test('splits feet and a remaining inches component', () {
      final result = inchesToFeetAndInches(70);
      expect(result.feet, 5);
      expect(result.inches, 10);
    });

    test('rounds to the nearest whole inch', () {
      final result = inchesToFeetAndInches(70.6);
      expect(result.feet, 5);
      expect(result.inches, 11);
    });
  });

  group('feetAndInchesToInches', () {
    test('combines feet and inches into a total', () {
      expect(feetAndInchesToInches(5, 10), 70);
    });

    test('round-trips through inchesToFeetAndInches', () {
      final result = inchesToFeetAndInches(feetAndInchesToInches(5, 9));
      expect(result.feet, 5);
      expect(result.inches, 9);
    });
  });
}
