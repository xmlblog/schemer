#lang pie

(claim motive-peas
  (Π ((l Nat))
     U))

(define motive-peas
  (λ (l)
    (Vec Atom l)))

(claim step-peas
  (Π ((l-1 Nat))
     (-> (motive-peas l-1)
         (motive-peas (add1 l-1)))))

(define step-peas
  (λ (l-1)
    (λ (answer-l-1)
      (vec:: 'pea answer-l-1))))

(claim peas
  (Π ((l Nat))
     (Vec Atom l)))

(define peas
  (λ (l)
    (ind-Nat l
      motive-peas
      vecnil
      step-peas)))

(check-same
 (Vec Atom 5)
 (the (Vec Atom 5)
      (vec:: 'pea
             (vec:: 'pea
                    (vec:: 'pea
                           (vec:: 'pea
                                  (vec:: 'pea vecnil))))))
 (peas 5))

(claim motive-last
  (-> U Nat
      U))

(define motive-last
  (λ (E k)
    (-> (Vec E (add1 k))
        E)))

(claim base-last
  (Π ((E U))
     (-> (Vec E (add1 zero))
         E)))

(define base-last
  (λ (E)
    (λ (es)
      (head es))))

(claim step-last
  (Π ((E U)
      (k Nat))
     (-> (-> (Vec E (add1 k)) E)
         (-> (Vec E (add1 (add1 k)))
             E))))

(define step-last
  (λ (E)
    (λ (n-1 last-of-n-1)
      (λ (es)
        (last-of-n-1 (tail es))))))

(claim last
  (Π ((E U)
      (k Nat))
     (-> (Vec E (add1 k))
         E)))

(define last
  (λ (E k)
    (λ (es)
      ((ind-Nat k
         (motive-last E)
         (base-last E)
         (step-last E)) es))))

(check-same
 Atom
 'Done
 (last Atom 0 (vec:: 'Done vecnil)))