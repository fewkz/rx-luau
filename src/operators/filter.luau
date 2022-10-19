local types = require("src/types")
local newObservable = require("src/newObservable")

local function operate<I, O>(
	callback: (source: types.Observable<I>) -> (types.Observable<O>)
): types.Operator<I, O>
	return { operate = callback }
end

--[=[
    Returns an operator that only emits values from the source
    observable that pass the given `predicate` function.

    @param predicate (value: I, index: number) -> (boolean)
    @return (source: Observable<I>) -> Observable<I>
]=]
function filter<I>(predicate: (value: I, index: number) -> (boolean))
	local index = 1 -- We're in lua, which is one-indexed ;)
	return operate(function(source: types.Observable<I>): types.Observable<I>
		local observable = newObservable(function(sub)
			local unsubscribe = source.subscribeNext(function(value)
				if predicate(value, index) then
					sub.next(value)
				end
				index += 1
			end)
			return unsubscribe
		end)
		return observable
	end)
end

return filter
