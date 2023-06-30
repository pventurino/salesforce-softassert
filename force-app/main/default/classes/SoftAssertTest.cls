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
  //-------
  // Assert
  //-------

  @isTest static void assert_true() {
    System.assertEquals(true, assert.assert(true));
  }

  @isTest static void assert_false() {
    System.assertEquals(false, assert.assert(false));
  }

  //-------------
  // AssertEquals
  //-------------

  @isTest static void null_equalsnull() {
    System.assertEquals(true, assert.assertEquals(null, null));
  }

  @isTest static void null_equalsstring() {
    System.assertEquals(false, assert.assertEquals(null, 'string'));
  }

  @isTest static void integer_equalsinteger() {
    System.assertEquals(true, assert.assertEquals(1, 1));
  }

  @isTest static void integer_equalsdecimal() {
    System.assertEquals(true, assert.assertEquals(1, 1.0));
  }

  @isTest static void decimal_equalsinteger() {
    System.assertEquals(true, assert.assertEquals(1.0, 1));
  }

  @isTest static void decimal_equalsdecimal() {
    System.assertEquals(true, assert.assertEquals(1.2, 1.20000));
  }

  @isTest static void string_equalsnull() {
    System.assertEquals(false, assert.assertEquals('string', null));
  }

  @isTest static void string_equalsdifferentcase() {
    System.assertEquals(false, assert.assertEquals('string', 'STRING'));
  }

  @isTest static void string_equalssame() {
    System.assertEquals(true, assert.assertEquals('string', 'string'));
  }

  //----------------
  // AssertNotEquals
  //----------------

  @isTest static void null_notequalsnull() {
    System.assertEquals(false, assert.assertNotEquals(null, null));
  }

  @isTest static void null_notequalsstring() {
    System.assertEquals(true, assert.assertNotEquals(null, 'string'));
  }

  @isTest static void string_notequalsnull() {
    System.assertEquals(true, assert.assertNotEquals('string', null));
  }

  @isTest static void string_notequalsdifferentcase() {
    System.assertEquals(true, assert.assertNotEquals('string', 'STRING'));
  }

  @isTest static void string_notequalssame() {
    System.assertEquals(false, assert.assertNotEquals('string', 'string'));
  }

}