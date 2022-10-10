local types = require(script.Parent.types)

local function newObservable<T>(subscribe): types.Observable<T>
	return table.freeze({
		-- We could marginally optimize the memory footprint of observables via metatables.
		subscribe = function(observerLike: types.ObserverLike<T>)
			local observer: types.Observer<T> = if typeof(observerLike) == "function"
				then { next = observerLike }
				else observerLike
			return subscribe(observer)
		end,
	})
end

return newObservable
