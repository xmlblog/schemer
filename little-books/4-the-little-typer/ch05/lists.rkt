;; -*- mode: racket -*-
#lang pie

;; =length=

(claim length-step
  (Π ((E U))
     (-> E (List E) Nat
         Nat)))

(define length-step
  (λ (E)
    (lambda (e es len-es)
      (add1 len-es))))

(claim length
  (Π ((E U))
     (-> (List E)
         Nat)))

(define length
  (λ (E)
    (λ (l)
      (rec-List l
        zero
        (length-step E)))))

(check-same
 Nat
 zero
 (length Atom nil))

(check-same
 Nat
 3
 (length Atom (:: 'foo (:: 'bar (:: 'baz nil)))))

(check-same
 Nat
 6
 (length Nat (:: 0 (:: 1 (:: 1 (:: 2 (:: 3 (:: 5 nil))))))))

;; =sum=

(claim +
  (-> Nat Nat
      Nat))

(define +
  (λ (x y)
    (rec-Nat x
      y
      (λ (x-1 sum)
        (add1 sum)))))

(claim sum
  (-> (List Nat)
      Nat))

(define sum
  (λ (n)
    (rec-List n
      0
      (λ (h t sum-tail)
        (+ h sum-tail)))))

(check-same
 Nat
 12
 (sum (:: 1 (:: 5 (:: 6 nil)))))

;; =append=

(claim append-step
  (Π ((E U))
     (-> E (List E) (List E)
         (List E))))

(define append-step
  (λ (E)
    (λ (e es appended-es)
      (:: e appended-es))))

(claim append
  (Π ((E U))
     (-> (List E) (List E)
         (List E))))

(define append
  (λ (E)
    (λ (l m)
      (rec-List l
        m
        (append-step E)))))

(check-same
 (List Nat)
 (:: 0 (:: 1 (:: 2 (:: 3 nil))))
 (append
  Nat
  (:: 0 (:: 1 nil))
  (:: 2 (:: 3 nil))))

;; =snoc=

(claim step-snoc
  (Π ((E U))
     (-> E (List E) (List E)
         (List E))))

(define step-snoc
  (λ (E)
    (λ (e es so-far)
      (:: e so-far))))

(claim snoc
  (Π ((E U))
     (-> (List E) E
         (List E))))

(define snoc
  (λ (E)
    (λ (es e)
      (rec-List es
        (:: e nil)
        (step-snoc E)))))

(check-same
 (List Atom)
 (:: 'potato (:: 'butter (:: 'rye-bread nil)))
 (snoc Atom (:: 'potato (:: 'butter nil)) 'rye-bread))

;; =concat=

(claim step-concat
  (Π ((E U))
     (-> E (List E) (List E)
         (List E))))

(define step-concat
  (λ (E)
    (λ (e es so-far)
      (snoc E so-far e))))

(claim concat
  (Π ((E U))
     (-> (List E) (List E)
         (List E))))

(define concat
  (λ (E)
    (λ (l m)
      (rec-List m
        l
        (step-concat E)))))

(check-same
 (List Nat)
 (:: 0 (:: 1 (:: 2 nil)))
 (concat
  Nat
  (:: 0 (:: 1 nil))
  (:: 2 nil)))

;; =reverse=

(claim step-reverse
  (Π ((E U))
     (-> E (List E) (List E)
         (List E))))

(define step-reverse
  (λ (E)
    (λ (e es so-far)
      (snoc E so-far e))))

(claim reverse
  (Π ((E U))
     (-> (List E)
         (List E))))

(define reverse
  (λ (E)
    (λ (l)
      (rec-List l
        (the (List E) nil)
        (step-reverse E)))))

(check-same
 (List Nat)
 (:: 2 (:: 1 (:: 0 nil)))
 (reverse Nat (:: 0 (:: 1 (:: 2 nil)))))