@isTest
public class SoftAssertTest {

	//-------
	// Assert
	//-------

	@isTest static void assert_true() {
		System.assertEquals(true, SoftAssert.assert(true));
	}

	@isTest static void assert_false() {
		System.assertEquals(false, SoftAssert.assert(false));
	}

	//-------------
	// AssertEquals
	//-------------

	@isTest static void null_equalsnull() {
		System.assertEquals(true, SoftAssert.assertEquals(null, null));
	}

	@isTest static void null_equalsstring() {
		System.assertEquals(false, SoftAssert.assertEquals(null, 'string'));
	}

	@isTest static void integer_equalsinteger() {
		System.assertEquals(true, SoftAssert.assertEquals(1, 1));
	}

	@isTest static void integer_equalsdecimal() {
		System.assertEquals(true, SoftAssert.assertEquals(1, 1.0));
	}

	@isTest static void decimal_equalsinteger() {
		System.assertEquals(true, SoftAssert.assertEquals(1.0, 1));
	}

	@isTest static void decimal_equalsdecimal() {
		System.assertEquals(true, SoftAssert.assertEquals(1.2, 1.20000));
	}

	@isTest static void string_equalsnull() {
		System.assertEquals(false, SoftAssert.assertEquals('string', null));
	}

	@isTest static void string_equalsdifferentcase() {
		System.assertEquals(false, SoftAssert.assertEquals('string', 'STRING'));
	}

	@isTest static void string_equalssame() {
		System.assertEquals(true, SoftAssert.assertEquals('string', 'string'));
	}

	//----------------
	// AssertNotEquals
	//----------------

	@isTest static void null_notequalsnull() {
		System.assertEquals(false, SoftAssert.assertNotEquals(null, null));
	}

	@isTest static void null_notequalsstring() {
		System.assertEquals(true, SoftAssert.assertNotEquals(null, 'string'));
	}

	@isTest static void string_notequalsnull() {
		System.assertEquals(true, SoftAssert.assertNotEquals('string', null));
	}

	@isTest static void string_notequalsdifferentcase() {
		System.assertEquals(true, SoftAssert.assertNotEquals('string', 'STRING'));
	}

	@isTest static void string_notequalssame() {
		System.assertEquals(false, SoftAssert.assertNotEquals('string', 'string'));
	}

}