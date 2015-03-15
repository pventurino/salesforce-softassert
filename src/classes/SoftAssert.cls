/**
 * Provides an interface to assertion similiar to those in System class.
 *
 * These assertions will not fail on the spot, and allow the developer to
 * perform several assertions in the same test method.
 *
 * As the last line of test methods, developers should use the line:
 *
 * > SoftAssert.assertAll();
 *
 * If any soft-assertion failed during the test, this will throw a
 * System.AssertException, causing the test method to fail and reporting each
 * soft-assertion that failed during the test.
 */
@isTest
public class SoftAssert {

	private static final String ASSERTION_FAILED = 'Assertion Failed';

	// Contains all assertions that failed so far
	private static List<String> failures = new List<String>();

	/**
	 * Asserts that the specified condition is true.
	 * If not, a failure is added to the list, to be reported on assertAll.
	 * @param condition Specifies the condition to test.
	 */
	public static void assert(Boolean condition) {
		assertInternal(condition, ASSERTION_FAILED);
	}

	/**
	 * Asserts that the specified condition is true.
	 * If not, a failure is added to the list, to be reported on assertAll.
	 * @param condition Specifies the condition to test.
	 * @param opt_msg   Custom message returned as part of the error message.
	 */
	public static void assert(Boolean condition, Object opt_msg) {
		assertInternal(condition, opt_msg);
	}

	private static void assertInternal(Boolean condition, Object opt_msg) {
		if (!condition) {
			if (opt_msg == null) {
				opt_msg = ASSERTION_FAILED;
			}
			failures.add(String.valueOf(opt_msg) + '\n' + getStackTrace());
		}
	}

	public static void assertAll() {
		if (!failures.isEmpty()) {
			System.assert(false,
				failures.size() + ' assertions failed:\n\n'
				+ String.join(failures, '\n\n')
			);
		}
	}

	/**
	 * Returns the stack trace up to calling the assertion method.
	 * @return a string containing each call on the stack trace in a separate line.
	 */
	private static String getStackTrace() {
		Exception ex = new DummyException();
		return ex.getStackTraceString()
			.subStringAfter('\n')
			.subStringAfter('\n')
			.subStringAfter('\n');
	}

	/**
	 * Dummy class, for getting current stack trace
	 */
	private class DummyException extends Exception {}
}