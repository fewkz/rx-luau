local types = require("src/types")
local newObservable = require("src/newObservable")

local function operate<I, O>(
	callback: (source: types.Observable<I>) -> (types.Observable<O>)
): types.Operator<I, O>
	return { operate = callback }
end

--[=[
	Returns an operator that maps values emitted from the
	observable with the given `project` function.

	@param project (I) -> (O)
	@return (source: Observable<I>) -> Observable<O>
]=]
local function map<I, O>(project: (value: I, index: number) -> (O))
	local index = 1 -- We're in lua, which is one-indexed ;)
	return operate(function(source: types.Observable<I>): types.Observable<O>
		local observable = newObservable(function(sub)
			local unsubscribe = source.subscribeNext(function(value)
				sub.next(project(value, index))
				index += 1
			end)
			return unsubscribe
		end)
		return observable
	end)
end

return map
