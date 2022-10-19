export type Observer<T> = {
	next: (T) -> (),
	error: () -> ()?,
	complete: () -> ()?,
}

export type Observable<T> = {
	-- Due to a bug in Luau, subscribe and subscribeNext must be seperate functions
	-- otherwise it will break the type of the pipe() function.
	subscribe: (Observer<T>) -> (() -> ()),
	subscribeNext: ((T) -> ()) -> (() -> ()),
}

export type Operator<I, O> = (I) -> O

return nil
