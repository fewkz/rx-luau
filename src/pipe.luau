local types = require("src/types")

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
	for _, operator in operators do
		observable = operator.operate(observable)
	end
	return observable
end

return (pipe :: any) :: Pipe -- Doesn't let me type it as Pipe directly for some reason.
