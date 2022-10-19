local types = require("src/types")

local noop = function() end

local function newObservable<T>(subscribe: (types.Observer<T>) -> (() -> ())?): types.Observable<T>
	return table.freeze({
		subscribe = function(observer: types.PartialObserver<T>)
			return subscribe({
				next = observer.next or noop,
				error = observer.error or noop,
				complete = observer.complete or noop,
			}) or noop
		end,
		subscribeNext = function(nextObserver: (T) -> ())
			return subscribe({
				next = nextObserver,
				error = noop,
				complete = noop,
			}) or noop
		end,
	})
end

return newObservable
