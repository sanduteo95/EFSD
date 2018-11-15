type hlist
val create : unit -> hlist
val is_empty : hlist -> bool
val add : hlist -> 'a -> hlist
val add_unique : hlist -> 'a -> hlist
val union : hlist -> hlist -> hlist
val remove : hlist -> 'a -> hlist
val fold : ('a -> 'b -> 'a) -> 'a -> hlist -> 'a 
val iter : ('a -> unit) -> hlist -> unit
val length : hlist -> int
val append : hlist -> hlist -> hlist