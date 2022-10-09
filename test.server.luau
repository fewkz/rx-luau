--!strict
local newObservable = require(script.Rx.newObservable)
local pipe = require(script.Rx.pipe)

local greeter = newObservable(function(subscriber)
	subscriber.next("hello")
	subscriber.next("goodbye")
end)

local function nameAdder(name)
	return function(i: string)
		return i .. " " .. name
	end
end

local nameGreet = pipe(greeter, nameAdder("fox"))

nameGreet.subscribe(function(greeting)
	print("The greeting is " .. greeting)
end)

local letterCount = pipe(nameGreet, string.len)

letterCount.subscribe(function(count)
	print("The letter count of the greeting is " .. count)
end)
