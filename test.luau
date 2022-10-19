local newObservable = require("src/newObservable")
local pipe = require("src/pipe")
local map = require("src/operators/map")
local filter = require("src/operators/filter")

local passedTests = {}
local failedTests = {}

local function test(name: string, body: () -> ())
	local suc = xpcall(body, function(msg)
		table.insert(failedTests, { name = name, msg = msg })
	end)
	if suc then
		table.insert(passedTests, name)
	end
end

test("Subscribing to observable that nexts 3 values", function()
	local observable = newObservable(function(subscriber)
		subscriber.next(1)
		subscriber.next(2)
		subscriber.next(3)
		return
	end)
	local values = {}
	observable.subscribeNext(function(value)
		table.insert(values, value)
	end)
	assert(#values == 3, "Expected 3 values, got " .. #values)
	assert(values[1] == 1, "Expected 1, got " .. values[1])
	assert(values[2] == 2, "Expected 2, got " .. values[2])
	assert(values[3] == 3, "Expected 3, got " .. values[3])
end)

test("Subscribing to observable that nexts 3 values then errors", function()
	local observable = newObservable(function(subscriber)
		subscriber.next(1)
		subscriber.next(2)
		subscriber.next(3)
		subscriber.error("Error!")
		return
	end)
	local values = {}
	local errors = {}
	observable.subscribe({
		next = function(value)
			table.insert(values, value)
		end,
		error = function(msg)
			table.insert(errors, msg)
		end,
		complete = function() end,
	})
	assert(#values == 3, "Expected 3 values, got " .. #values)
	assert(values[1] == 1, "Expected 1, got " .. values[1])
	assert(values[2] == 2, "Expected 2, got " .. values[2])
	assert(values[3] == 3, "Expected 3, got " .. values[3])
	assert(#errors == 1, "Expected 1 error, got " .. #errors)
	assert(errors[1] == "Error!", "Expected 'Error!', got " .. errors[1])
end)

test("Subscribing to observable that nexts 3 values then completes", function()
	local observable = newObservable(function(subscriber)
		subscriber.next(1)
		subscriber.next(2)
		subscriber.next(3)
		subscriber.complete()
		return
	end)
	local values = {}
	local completed = false
	observable.subscribe({
		next = function(value)
			table.insert(values, value)
		end,
		error = function(msg) end,
		complete = function()
			completed = true
		end,
	})
	assert(#values == 3, "Expected 3 values, got " .. #values)
	assert(values[1] == 1, "Expected 1, got " .. values[1])
	assert(values[2] == 2, "Expected 2, got " .. values[2])
	assert(values[3] == 3, "Expected 3, got " .. values[3])
	assert(completed, "Expected completed to be true")
end)

test("Piping an observable to map", function()
	local observable = newObservable(function(subscriber)
		subscriber.next(1)
		subscriber.next(2)
		subscriber.next(3)
		return
	end)
	local values = {}
	pipe(observable, map(function(value: number)
		return value * 2
	end)).subscribeNext(function(value)
		table.insert(values, value)
	end)
	assert(#values == 3, "Expected 3 values, got " .. #values)
	assert(values[1] == 2, "Expected 2, got " .. values[1])
	assert(values[2] == 4, "Expected 4, got " .. values[2])
	assert(values[3] == 6, "Expected 6, got " .. values[3])
end)

test("Piping an observable to filter", function()
	local observable = newObservable(function(subscriber)
		subscriber.next(1)
		subscriber.next(2)
		subscriber.next(3)
		return
	end)
	local values = {}
	pipe(observable, filter(function(value: number)
		return value % 2 == 0
	end)).subscribeNext(function(value)
		table.insert(values, value)
	end)
	assert(#values == 1, "Expected 1 value, got " .. #values)
	assert(values[1] == 2, "Expected 2, got " .. values[1])
end)

local red = "\27[31m"
local green = "\27[32m"
local bold = "\27[1m"
local reset = "\27[0m"
local underline = "\27[4m"

for _, passedTest in passedTests do
	print(`{green}{underline}{passedTest}{reset}`)
end
for _, failedTest in failedTests do
	print(`{red}{underline}{failedTest.name}{reset}`)
	print(failedTest.msg)
end
if #failedTests > 0 then
	error(`{red}{bold}{#failedTests} tests failed{reset}`, 0)
else
	print(`{green}{bold}All tests passed!{reset}`)
end