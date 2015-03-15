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

	/**
	 * Asserts that the first two arguments are the same.
	 * If not, a failure is added to the list, to be reported on assertAll.
	 * @param expected Specifies the expected value.
	 * @param actual   Specifies the actual value.
	 */
	public static void assertEquals(Object expected, Object actual) {
		Boolean areEqual = compareObjects(expected, actual);
		if (!areEqual) {
			assertInternal(false, ASSERTION_FAILED + ': '
				+ String.format('Expected: {0}, Actual: {1}',
					new String[]{
						String.valueOf(expected),
						String.valueOf(actual)
					})
				);
		}
	}

	/**
	 * Asserts that the first two arguments are the same.
	 * If not, a failure is added to the list, to be reported on assertAll.
	 * @param expected Specifies the expected value.
	 * @param actual   Specifies the actual value.
	 * @param opt_msg  Custom message returned as part of the error message.
	 */
	public static void assertEquals(Object expected, Object actual, Object opt_msg) {
		Boolean areEqual = compareObjects(expected, actual);
		if (!areEqual) {
			assertInternal(false, ASSERTION_FAILED + ': '
				+ (opt_msg != null ? String.valueOf(opt_msg) + ': ' : '')
				+ String.format('Expected: {0}, Actual: {1}',
					new String[]{
						String.valueOf(expected),
						String.valueOf(actual)
					})
				);
		}
	}

	private static void assertInternal(Boolean condition, Object opt_msg) {
		if (!condition) {
			if (opt_msg == null) {
				opt_msg = ASSERTION_FAILED;
			}
			failures.add(String.valueOf(opt_msg) + '\n' + getStackTrace());
		}
	}

	private static Boolean compareObjects(Object expected, Object actual) {
		if (expected == null && actual == null) return true;
		if (expected == null || actual == null) return false;
		if (expected instanceof String && actual instanceof String) {
			// Convert to String, so that equals is case sensitive
			String expectedString = (String) expected;
			String actualString   = (String) actual;
			return expectedString.equals(actualString);
		}
		return expected.equals(actual);
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