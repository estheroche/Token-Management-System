(define-map user-token-map
  { user: principal }
  { token-contract: principal }
)

(define-constant err-user-not-registered (err u100))
(define-constant err-already-registered (err u101))

;; Register a token contract for the user
;; #[allow(unchecked_data)]
(define-public (register-token (token-contract principal))
  (let (
      (sender tx-sender)
      (existing (map-get? user-token-map { user: sender }))
    )
    (if (is-some existing)
        err-already-registered
        (begin
          (map-set user-token-map { user: sender } { token-contract: token-contract })
          (ok true)
        )
    )
  )
)

;; Read user's token contract
(define-read-only (get-user-token (user principal))
  (let (
      (info (map-get? user-token-map { user: user }))
    )
    (if (is-none info)
        err-user-not-registered
        (ok (get token-contract (unwrap-panic info)))
    )
  )
)


;; Check if a user is registered
(define-read-only (is-user-registered (user principal))
  (ok (is-some (map-get? user-token-map { user: user })))
)