@isTest
public class SoftAssertTest {

  static SoftAssert assert = SoftAssert.getInstance();

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