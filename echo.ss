(import (cuse))

;;
;; Device Methods
;;

(define echo-open
  (lambda (dev fflags)
    CUSE_ERR_NONE))

(define echo-close
  (lambda (dev fflags)
    CUSE_ERR_NONE))

(define echo-read
  (lambda (dev fflags peer-ptr len)
    CUSE_ERR_NONE))

(define echo-write
  (lambda (dev fflags peer-ptr len)
    CUSE_ERR_NONE))

(define echo-ioctl
  (lambda (dev fflags cmd peer-data)
    CUSE_ERR_NONE))

(define echo-poll
  (lambda (dev fflags events)
    CUSE_POLL_NONE))

(define echo-methods
  (make-ftype-pointer cuse-methods
		      (foreign-alloc (ftype-sizeof cuse-methods))))

(ftype-set! cuse-methods (open)
	    echo-methods (make-ftype-pointer cuse-open echo-open))
(ftype-set! cuse-methods (close)
	    echo-methods (make-ftype-pointer cuse-close echo-close))
(ftype-set! cuse-methods (read)
	    echo-methods (make-ftype-pointer cuse-read echo-read))
(ftype-set! cuse-methods (write)
	    echo-methods (make-ftype-pointer cuse-write echo-write))
(ftype-set! cuse-methods (ioctl)
	    echo-methods (make-ftype-pointer cuse-ioctl echo-ioctl))
(ftype-set! cuse-methods (poll)
	    echo-methods (make-ftype-pointer cuse-poll echo-poll))

;;
;; Instantiation
;;

(cuse-init)

(define unit
  (let ([unit-ptr (make-ftype-pointer int (foreign-alloc (ftype-sizeof int)))])
    (assert (= CUSE_ERR_NONE (cuse-alloc-unit-number unit-ptr)))
    (let ([val (ftype-ref int ()  unit-ptr)])
      (foreign-free (ftype-pointer-address unit-ptr))
      val)))

(define dev-ptr
  (cuse-dev-create echo-methods 0 0 0 0 #o660 "echo%d" (int) unit))

((rec loop
   (lambda ()
     (if (= CUSE_ERR_NONE (cuse-wait-and-process))
	 (loop)))))

(cuse-dev-destroy dev-ptr)

(assert (= CUSE_ERR_NONE (cuse-free-unit-number unit)))

(cuse-uninit)
