# salesforce-softassert

## Purpose

The intention of this library is to allow developers to write tests that can
perform several assertions without failing on the first one. At the end of the
test, if any assertion failed, the test will fail with a System.AssertException
and all failed assertions will be reported with their stack traces.

## Usage

The SoftAssert class provides the same interface as assertion methods in
Salesforce's System class. So, instead of using

```java
Assert.isTrue(condition, msg);
Assert.areEqual(expected, actual, msg);
Assert.areNotEqual(expected, actual, msg);
```

Developers can use the same methods from the SoftAssert class. Failed
assertions will not make the test fail on the spot. At the end of the test
method, developers call the `all()` method to make the test fail if any other
assertion failed.

```java
SoftAssert assert = SoftAssert.getInstance();

// Assert all you need - failed assertions will not stop execution
assert.isTrue(condition, msg);
assert.areEqual(expected, actual, msg);
assert.areNotEqual(expected, actual, msg);

// Close your assertions - if any asertion failed, the test will fail
assert.all();
```

If any assertion failed, the entire test will fail with a
`System.AssertException`. The exception message will contain the number of
assertions that failed, and list the message and stack trace for each of them.

## Examples

### Assert several unrelated values for the same output

Let's say you have a method or process that creates an object. You want to
assert that the values of the object fields are the expected values. The fact
that one of those values is not as expected doesn't mean you cannot also test
the rest of the values (you may even find a common pattern that's causing all
the failures).

Instead of writing:

```java
@IsTest
static void testGeneratedObject() {
	MyObject__c obj = MyClass.generateObject();
	Assert.areEqual('one', obj.fieldOne);
	Assert.areEqual('two', obj.fieldTwo);
	Assert.areEqual('three', obj.fieldThree);
}
```

You can write:

```java
static SoftAssert assert = SoftAssert.getInstance();

@IsTest
static void testGeneratedObject() {
	MyObject__c obj = MyClass.generateObject();
	assert.areEqual('one', obj.fieldOne);
	assert.areEqual('two', obj.fieldTwo);
	assert.areEqual('three', obj.fieldThree);
	assert.all();
}
```

### Conditional assertions
Since each SoftAssert assertion not only doesn't stop execution, but also
returns whether the assertion has passed or failed, you can use them in
conditionals so that you test won't crash because of a precondition.

```java
static SoftAssert assert = SoftAssert.getInstance();

@IsTest
static void testMyOpportunityCreation() {
	Opportunty opp = myCreateOpportunityProcess();
	if ( assert.isNotNull(opp, 'The opportunuity was not created') ) {
		assert.areEqual('Great Sale', opp.Name, 'Opportunity Name');
		assert.areEqual('New Customer', opp.Type, 'Opportunity Type');
	}
	assert.all();
}
```

### Unify expensive precondition setup

> Note: in most situations, the correct way to do this is [Using Test Setup
> Methods](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_testing_testsetup_using.htm).
> You might still encounter some situations in which you setup your base data
> for all tests but still need each test to setup some specific data that
> might also be expensive.

In some cases, you need to test several different use cases that start with the
same precondition. If these tests don't write data, or they do but would not
affect each other otherwise, you can unify the different cases into a single
test method that sets the preconditions one, then runs each separate test, and
doesn't stop running at the first failure.

Instead of writing:

```java
@IsTest
static void testCaseOne() {
	setupExpensivePrecondition();
	Assert.areEqual('one', execute('one'));
}

// ...

@IsTest
static void testCaseTwelve() {
	setupExpensivePrecondition();
	Assert.areEqual('twelve', execute('twelve'));
}
```

You can write:

```java
static SoftAssert assert = SoftAssert.getInstance();

@IsTest
static void testCases() {
	setupExpensivePrecondition();

	assert.areEqual('one', execute('one'));
	// ...
	assert.areEqual('twelve', execute('twelve'));

	assert.all();
}
```
