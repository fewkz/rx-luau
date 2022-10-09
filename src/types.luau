--!strict
export type Observer<T> = {
	next: (T) -> (),
	error: () -> ()?,
	complete: () -> ()?,
}

export type ObserverLike<T> = Observer<T> | ((T) -> ())

export type Observable<T> = {
	subscribe: (ObserverLike<T>) -> (),
}

export type Operator<I, O> = (I) -> O

return nil
