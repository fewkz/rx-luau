export type Observer<T> = {
	next: (T) -> (),
	error: (msg: any) -> (),
	complete: () -> (),
}

export type Subscriber<T> = Observer<T>

export type Observable<T> = {
	-- Due to a bug in Luau, subscribe and subscribeNext must be seperate functions
	-- otherwise it will break the type of the pipe() function.
	-- We also can't implement PartialObserver because it breaks the type of next().
	subscribe: (Observer<T>) -> (() -> ()),
	subscribeNext: ((T) -> ()) -> (() -> ()),
}

export type Operator<I, O> = { operate: (Observable<I>) -> Observable<O> }

return {} -- Modules must return a table or function in luau
