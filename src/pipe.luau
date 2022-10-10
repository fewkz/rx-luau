local types = require(script.Parent.types)
local newObservable = require(script.Parent.newObservable)

type Observable<T> = types.Observable<T>
type Operator<I, O> = types.Operator<I, O>

type Pipe =
	(<A>(self: Observable<A>) -> Observable<A>)
	& (<A, B>(self: Observable<A>, op1: Operator<A, B>) -> Observable<B>)
	& (<A, B, C>(self: Observable<A>, op1: Operator<A, B>, op2: Operator<B, C>) -> Observable<C>)
	& (<A, B, C>(
		self: Observable<A>,
		op1: Operator<A, B>,
		op2: Operator<B, C>,
		...Operator<any, any>
	) -> Observable<unknown>)

local pipe = function(observable: Observable<any>, ...: Operator<any, any>)
	local operators = { ... }
	return newObservable(function(subscription)
		return observable.subscribe({
			next = function(v)
				for _, operator in operators do
					v = operator(v)
				end
				subscription.next(v)
			end,
			error = subscription.error,
			complete = subscription.complete,
		})
	end)
end

return (pipe :: any) :: Pipe -- I don't know why it doesn't let me type it as Pipe
