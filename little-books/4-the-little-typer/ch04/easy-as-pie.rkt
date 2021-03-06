;; -*- mode: racket; -*-
#lang pie
;; This chapter introduces Π expressions. Π expressions let us parameterize type
;; definitions for λ expressions to achieve generality.

;; Using a Π expression lets elim-Pair be a general-puropose λ expression that
;; can be parameterized with the types of its input Pair and the type of its
;; output expression.
(claim elim-Pair
       (Π ((A U)
           (D U)
           (X U))
          (-> (Pair A D)
              (-> A D X)
              X)))

;; The output type need not be related to the input types in any way. For
;; example: (elim-Pair Nat Nat Atom (cons 1 2) (λ (a d) 'constant))
(define elim-Pair
  (λ (A D X)
    (λ (p f)
      (f (car p) (cdr p)))))

;; elim-Pair in action
(claim kar
       (-> (Pair Nat Nat)
           Nat))

(define kar
  (λ (p)
    (elim-Pair
     Nat Nat
     Nat
     p
     (λ (x y)
       x))))

(claim kdr
       (-> (Pair Nat Nat)
           Nat))

(define kdr
  (λ (p)
    (elim-Pair
     Nat Nat
     Nat
     p
     (λ (x y)
       y))))

;; We define swap in terms of exactly two types, because the output types are
;; related to the input types. We don't require the generality of elim-Pair.
(claim swap
       (Π ((A U)
           (D U))
          (-> (Pair A D)
              (Pair D A))))

(define swap
  (λ (A D)
    (λ (p)
      (cons (cdr p) (car p)))))

;; It is annoying to have to parameterize every expression, however.
;; Maybe there are more tricks to be discovered in later chapters?
(check-same
 (Pair Nat Nat)
 (cons 2 1)
 (swap Nat Nat (cons 1 2)))

;; One more exercise from chapter 4...
(claim twin
       (Π ((T U))
          (-> T
              (Pair T T))))

(define twin
  (λ (T)
    (λ (x)
      (cons x x))))

;; We can always define a specialized version of a generalized λ. The claims are
;; always tediously expressed, but the implementations can leverage currying by
;; supplying only the types to the general form.
(claim twin-Nat
       (-> Nat (Pair Nat Nat)))

(define twin-Nat
  (twin Nat))

(check-same
 (Pair Nat Nat)
 (cons 0 0)
 (twin-Nat 0))

(claim twin-Atom
  (-> Atom (Pair Atom Atom)))

(define twin-Atom
  (twin Atom))

(check-same
 (Pair Atom Atom)
 (cons 'pizza 'pizza)
 (twin-Atom 'pizza))
