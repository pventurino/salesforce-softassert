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

## Examples

### Assert several unrelated values for the same output

Let's say you have a method or process that creates an object. You want to
assert that the values of the object fields are the expected values. The fact
that one of those values is not as expected doesn't mean you cannot also test
the rest of the values (you may even find a common pattern that's causing all
the failures).

Instead of writing:

	@isTest
	static void testGeneratedObject() {
		MyObject__c obj = MyClass.generateObject();
		System.assertEquals('one', obj.fieldOne);
		System.assertEquals('two', obj.fieldTwo);
		System.assertEquals('three', obj.fieldThree);
	}

You can write:

	@isTest
	static void testGeneratedObject() {
		MyObject__c obj = MyClass.generateObject();
		SoftAssert.assertEquals('one', obj.fieldOne);
		SoftAssert.assertEquals('two', obj.fieldTwo);
		SoftAssert.assertEquals('three', obj.fieldThree);
		SoftAssert.assertAll();
	}


### Unify expensive precondition setup

In some cases, you need to test several different use cases that start with the
same precondition. If these tests don't write data, or they do but would not
affect each other otherwise, you can unify the different cases into a single
test method that sets the preconditions one, then runs each separate test, and
doesn't stop running at the first failure.

Instead of writing:

	@isTest
	static void testCaseOne() {
		setupExpensivePrecondition();
		System.assertEquals('one', execute('one'));
	}

	// ...

	@isTest
	static void testCaseTwelve() {
		setupExpensivePrecondition();
		System.assertEquals('twelve', execute('twelve'));
	}

You can write:

	@isTest
	static void testCases() {
		setupExpensivePrecondition();

		SoftAssert.assertEquals('one', execute('one'));
		// ...
		SoftAssert.assertEquals('twelve', execute('twelve'));

		SoftAssert.assertAll();
	}
