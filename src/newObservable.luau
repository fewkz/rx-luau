local types = require("src/types")

local noop = function() end

local function newObservable<T>(subscribe: (types.Observer<T>) -> (() -> ())?): types.Observable<T>
	return table.freeze({
		subscribe = function(observer: types.Observer<T>)
			return subscribe(observer) or noop
		end,
		subscribeNext = function(nextObserver: (T) -> ())
			return subscribe({ next = nextObserver }) or noop
		end,
	})
end

return newObservable
