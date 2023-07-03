@isTest
public class SoftAssertTest {

  static SoftAssert assert = SoftAssert.getInstance();

  @isTest
  static void testAreAndNotEqual() {
    Date todayDate = System.today();
    DateTime todayDateTime = Datetime.newInstance(todayDate, Time.newInstance(0, 0, 0, 0));

    Object[][] cases = new Object[][]{
      new Object[]{null, null, true, 'null vs null'},
      new Object[]{'aa', null, false, 'string vs null'},
      new Object[]{null, 'aa', false, 'null vs string'},
      new Object[]{'aa','aa', true, 'same string'},
      new Object[]{'aa','AA', false, 'different cases'},
      new Object[]{1,1, true, 'same integer'},
      new Object[]{1,2, false, 'different integers'},
      new Object[]{1,1.0, true, 'integer vs decimal'}, // System.Assert compares their values, not types
      new Object[]{1,'1', false, 'integer vs string representation'},
      new Object[]{todayDate,System.today(), true, 'two instances of the same date'},
      new Object[]{todayDate,todayDateTime, false, 'date vs beggining of same date'}
    };

    String results = '';
    Boolean allPass = true;

    for (Object[] c : cases) {
      Object expected = c[0];
      Object actual = c[1];
      Boolean shouldBeEqual = (Boolean) c[2];
      String msg = (String) c[3];

      Boolean areEqualResult = assert.areEqual(expected, actual, msg);
      Boolean areNotEqualResult = assert.areNotEqual(expected, actual, msg);

      Boolean passes = (areEqualResult == shouldBeEqual) && (areNotEqualResult != shouldBeEqual);
      if (!passes) {
        allPass = false;
        results +=
          '\n  fails' +
          (areEqualResult == shouldBeEqual ? '' : ' eq') +
          (areNotEqualResult != shouldBeEqual ? '' : ' neq') +
          + ': ' + msg;
      }
    }

    System.Assert.isTrue(allPass, results);
  }

  @isTest
  static void testIsAndNotNull() {
    Object[][] cases = new Object[][]{
      new Object[]{true, assert.isNull(null, 'msg'), 'isNull(null)'},
      new Object[]{false, assert.isNull(2, 'msg'), 'isNull(2)'},
      new Object[]{false, assert.isNotNull(null, 'msg'), 'isNotNull(null)'},
      new Object[]{true, assert.isNotNull(2, 'msg'), 'isNotNull(2)'}
    };

    String result = '';
    for (Object[] c : cases) {
      if (c[0] != c[1]) {
        result += '\n  ' + c[2] + ': Expected: ' + c[0] + ', Actual: ' + c[1];
      }
    }

    System.Assert.isTrue(result == '', result);
  }

  @isTest
  static void testIsTrueAndIsFalse() {
    Object[][] cases = new Object[][]{
      new Object[]{true, assert.isTrue(true, 'msg'), 'isTrue(true)'},
      new Object[]{false, assert.isTrue(false, 'msg'), 'isTrue(false)'},
      new Object[]{false, assert.isTrue(null, 'msg'), 'isTrue(null)'},
      new Object[]{false, assert.isFalse(true, 'msg'), 'isFalse(true)'},
      new Object[]{true, assert.isFalse(false, 'msg'), 'isFalse(false)'},
      new Object[]{false, assert.isFalse(null, 'msg'), 'isFalse(null)'}
    };

    String result = '';
    for (Object[] c : cases) {
      if (c[0] != c[1]) {
        result += '\n  ' + c[2] + ': Expected: ' + c[0] + ', Actual: ' + c[1];
      }
    }

    System.Assert.isTrue(result == '', result);
  }

  @IsTest
  static void testMessages() {
    assert.areEqual(1, 2);
    assert.areEqual(1, 2, 'message');
    assert.areNotEqual(1, 1);
    assert.areNotEqual(1, 1, 'message');
    assert.fail();
    assert.fail('message');
    assert.isFalse(true);
    assert.isFalse(true, 'message');
    assert.isNotNull(null);
    assert.isNotNull(null, 'message');
    assert.isNull(1);
    assert.isNull(1, 'message');
    assert.isTrue(false);
    assert.isTrue(false, 'message');
    
    final Integer FIRST_LINE = 93;
    Integer line = FIRST_LINE; 
    String[] expected = new String[]{
      '14 failures',
      '1. Expected: 1, Actual: 2 (' + (line++) + ':1)',
      '2. message: Expected: 1, Actual: 2 (' + (line++) + ':1)',
      '3. Same value: 1 (' + (line++) + ':1)',
      '4. message: Same value: 1 (' + (line++) + ':1)',
      '5. Assertion Failed (' + (line++) + ':1)',
      '6. message (' + (line++) + ':1)',
      '7. Value is not False (' + (line++) + ':1)',
      '8. Value is not False: message (' + (line++) + ':1)',
      '9. Instance expected to be a non null value (' + (line++) + ':1)',
      '10. Instance expected to be a non null value: message (' + (line++) + ':1)',
      '11. Nullable object asserted with non null value (' + (line++) + ':1)',
      '12. Nullable object asserted with non null value: message (' + (line++) + ':1)',
      '13. Value is not True (' + (line++) + ':1)',
      '14. Value is not True: message (' + (line++) + ':1)'
    };
    String[] actual = assert.getFailureMessage().split('\n');
    for(Integer i=0; i<expected.size(); i++) {
      System.Assert.areEqual(expected[i], actual[i], 'Line ' + i);
    }
  }

  //-------
  // Assert
  //-------

  @isTest static void assertTrue() {
    System.assertEquals(true, assert.assert(true));
  }

  @isTest static void assertFalse() {
    System.assertEquals(false, assert.assert(false));
  }

  //-------------
  // AssertEquals
  //-------------

  @isTest static void nullEqualsNull() {
    System.assertEquals(true, assert.assertEquals(null, null));
  }

  @isTest static void nullEqualsString() {
    System.assertEquals(false, assert.assertEquals(null, 'string'));
  }

  @isTest static void integerEqualsInteger() {
    System.assertEquals(true, assert.assertEquals(1, 1));
  }

  @isTest static void integerEqualsDecimal() {
    System.assertEquals(true, assert.assertEquals(1, 1.0));
  }

  @isTest static void decimalEqualsInteger() {
    System.assertEquals(true, assert.assertEquals(1.0, 1));
  }

  @isTest static void decimalEqualsDecimal() {
    System.assertEquals(true, assert.assertEquals(1.2, 1.20000));
  }

  @isTest static void stringEqualsNull() {
    System.assertEquals(false, assert.assertEquals('string', null));
  }

  @isTest static void stringEqualsDifferentCase() {
    System.assertEquals(false, assert.assertEquals('string', 'STRING'));
  }

  @isTest static void stringEqualsSameCase() {
    System.assertEquals(true, assert.assertEquals('string', 'string'));
  }

  //----------------
  // AssertNotEquals
  //----------------

  @isTest static void nullNotEqualsNull() {
    System.assertEquals(false, assert.assertNotEquals(null, null));
  }

  @isTest static void nullNotEqualsString() {
    System.assertEquals(true, assert.assertNotEquals(null, 'string'));
  }

  @isTest static void stringNotEqualsNull() {
    System.assertEquals(true, assert.assertNotEquals('string', null));
  }

  @isTest static void stringNotEqualsDifferentCase() {
    System.assertEquals(true, assert.assertNotEquals('string', 'STRING'));
  }

  @isTest static void stringNotEqualsSame() {
    System.assertEquals(false, assert.assertNotEquals('string', 'string'));
  }

}