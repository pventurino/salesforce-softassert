# salesforce-softassert

## Purpose
The intention of this library is to allow developers to write tests that can
perform several assertions without failing on the first one. At the end of the
test, if any assertion failed, the test will fail with a System.AssertException
and all failed assertions will be reported with their stack traces.

## Usage
The SoftAssert class provides the same interface as assertion methods in
Salesforce's System class. So, instead of using

	System.assert(condition, opt_msg);
	System.assertEquals(expected, actual, opt_msg);
	System.assertNotEquals(expected, actual, opt_msg);

Developers can use the same methods from the SoftAssert class:

	SoftAssert.assert(condition, opt_msg);
	SoftAssert.assertEquals(expected, actual, opt_msg);
	SoftAssert.assertNotEquals(expected, actual, opt_msg);

Failed assertions will not make the test fail on the spot. At the end of the
test method, developers should call

	SoftAssert.assertAll();

On that method, if any other assertion failed, the entire test will fail with
a System.AssertException. The exception message will contain the number of
assertions that failed, and list the message and stack trace for each of them.