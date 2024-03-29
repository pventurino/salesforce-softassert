/**
 * Provides an interface to assertion similiar to those in System.Assert class.
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

  private static final SoftAssert INSTANCE = new SoftAssert();
  public static SoftAssert getInstance() {
    return INSTANCE;
  }

  // Contains all assertions that failed so far
  private class Failure {
    String message;
    String stackTraceString;
  }
  private List<Failure> failures = new List<Failure>();

  // =====================
  // SYSTEM.ASSERT METHODS
  // =====================

  /**
   * Asserts that the first two arguments are the same.
   */
  public Boolean areEqual(Object expected, Object actual) {
    return areEqual(expected, actual, null);
  }

  /**
   * Asserts that the first two arguments are the same.
   */
  public Boolean areEqual(Object expected, Object actual, String msg) {
    return compareObjects(expected, actual) == true ||
      fail((msg != null ? msg + ': ': '')
        + 'Expected: ' + expected
        + ', Actual: ' + actual);
  }

  /**
   * Asserts that the first two arguments aren’t the same.
   */
  public Boolean areNotEqual(Object expected, Object actual) {
    return assertNotEquals(expected, actual, null);
  }

  /**
   * Asserts that the first two arguments aren’t the same.
   */
  public Boolean areNotEqual(Object expected, Object actual, String msg) {
    return compareObjects(expected, actual) == false ||
      fail((msg != null ? msg + ': ' : '')
        + 'Same value: ' + actual);
  }

  /**
   * Adds the specified message as a failure to the list.
   */
  public Boolean fail() {
    return fail(null);
  }

  /**
   * Adds the specified message as a failure to the list.
   */
  public Boolean fail(String msg) {
    Failure f = new Failure();
    f.message = (msg != null ? msg : 'Assertion Failed');
    f.stackTraceString = getStackTraceString();
    failures.add(f);
    System.debug(LoggingLevel.ERROR, 'Assertion Failed: ' + msg);
    return false;
  }

  /**
   * Asserts that the specified condition is `false`.
   */
  public Boolean isFalse(Boolean condition) {
    return isFalse(condition, null);
  }

  /**
   * Asserts that the specified condition is `false`.
   */
  public Boolean isFalse(Boolean condition, String msg) {
    return condition == false ||
      fail('Value is not False' + (msg != null ? ': ' + msg : ''));
  }

  /**
   * Asserts that the value isn’t null.
   */
  public Boolean isNotNull(Object value) {
    return isNotNull(value, null);
  }

  /**
   * Asserts that the value isn’t null.
   */
  public Boolean isNotNull(Object value, String msg) {
    return value != null ||
      fail('Instance expected to be a non null value'
        + (msg != null ? ': ' + msg : ''));
  }

  /**
   * Asserts that the value is null.
   */
  public Boolean isNull(Object value) {
    return isNull(value, null);
  }

  /**
   * Asserts that the value is null.
   */
  public Boolean isNull(Object value, String msg) {
    return value == null ||
      fail('Nullable object asserted with non null value'
        + (msg != null ? ': ' + msg : ''));
  }

  /**
   * Asserts that the specified condition is `true`.
   */
  public Boolean isTrue(Boolean condition) {
    return isTrue(condition, null);
  }

  /**
   * Asserts that the specified condition is `true`.
   */
  public Boolean isTrue(Boolean condition, String msg) {
    return condition == true ||
      fail('Value is not True' + (msg != null ? ': ' + msg : ''));
  }

  // =========================
  // OLD SYSTEM.ASSERT METHODS
  // =========================

  /**
   * Asserts that the specified condition is true.
   * If not, a failure is added to the list, to be reported on assertAll.
   * @param condition Specifies the condition to test.
   */
  public Boolean assert(Boolean condition) {
    return isTrue(condition);
  }

  /**
   * Asserts that the specified condition is true.
   * If not, a failure is added to the list, to be reported on assertAll.
   * @param condition Specifies the condition to test.
   * @param msg       Custom message returned as part of the error message.
   */
  public Boolean assert(Boolean condition, String msg) {
    return isTrue(condition, msg);
  }

  /**
   * Asserts that the first two arguments are the same.
   * If not, a failure is added to the list, to be reported on assertAll.
   * @param expected Specifies the expected value.
   * @param actual   Specifies the actual value.
   */
  public Boolean assertEquals(Object expected, Object actual) {
    return areEqual(expected, actual);
  }

  /**
   * Asserts that the first two arguments are the same.
   * If not, a failure is added to the list, to be reported on assertAll.
   * @param expected Specifies the expected value.
   * @param actual   Specifies the actual value.
   * @param msg      Custom message returned as part of the error message.
   */
  public Boolean assertEquals(Object expected, Object actual, String msg) {
    return areEqual(expected, actual, msg);
  }

  /**
   * Asserts that the first two arguments are not the same.
   * If they are, a failure is added to the list, to be reported on assertAll.
   * @param expected Specifies the expected value.
   * @param actual   Specifies the actual value.
   */
  public Boolean assertNotEquals(Object expected, Object actual) {
    return areNotEqual(expected, actual);
  }

  /**
   * Asserts that the first two arguments are not the same.
   * If they are, a failure is added to the list, to be reported on assertAll.
   * @param expected Specifies the expected value.
   * @param actual   Specifies the actual value.
   * @param msg      Custom message returned as part of the error message.
   */
  public Boolean assertNotEquals(Object expected, Object actual, String msg) {
    return areNotEqual(expected, actual, msg);
  }

  /**
   * Compare two objects, the way that Salesforce would compare them
   * if calling `Assert.areEqual()`.
   * Otherwise, comparing two objects that happen to be strings would
   * result in a case-insensitive comparison, which is not the way
   * Salesforce assertion behaves.
   */
  private Boolean compareObjects(Object expected, Object actual) {
    if (expected == null && actual == null) { return true; }
    if (expected == null || actual == null) { return false; }
    if (expected instanceof String && actual instanceof String) {
      // Convert to String, so that equals is case sensitive
      String expectedString = (String) expected;
      String actualString   = (String) actual;
      return expectedString.equals(actualString);
    }
    return expected.equals(actual);
  }

  /**
   * Will cause an exception to be thrown if at least one assertion failed.
   */
  public void assertAll() {
    all();
  }

  /**
   * Will cause an exception to be thrown if at least one assertion failed.
   */
  public void all() {
    String msg = getFailureMessage();
    if (msg != null) {
      System.assert(false, msg);
      // Using `System.assert(false, msg)` because message is shorter than
      // `Assert.fail(msg)` (which repeats the 'Assertion Failed: ' string)
    }
  }

  /**
   * Returns exception message that would be thrown by calling `all()`
   */
  public String getFailureMessage() {
    if (!failures.isEmpty()) {
      List<String> out = new List<String>{failures.size() + ' failures'};
      Integer i = 0;
      for (Failure f : failures) {
        out.add((++i) + '. ' + f.message + getLocation(f.stackTraceString));
      }
      return String.join(out, '\n');
    }
    return null;
  }

  /**
   * Returns the stack trace up to calling the assertion method.
   * @return a string containing each call on the stack trace in a separate line.
   */
  private String getStackTraceString() {
    Exception ex = new DummyException();
    return ex.getStackTraceString()
      .replaceFirst('^(Class\\.SoftAssert\\..*\n)+', '');
  }

  /**
   * Formats the stack trace before output. 
   */
  private String getLocation(String stackTraceString) {
    // TODO: Make this a strategy pattern with different outputs
    // For now, output is outermost "[{ln}:{col}]" with no line break
    return ' (' + stackTraceString
      .substringAfterLast(': ')
      .replaceAll('[^0-9,]','')
      .replace(',', ':')
      + ')';
  }

  /**
   * Dummy class, for getting current stack trace
   */
  private class DummyException extends Exception {}
}