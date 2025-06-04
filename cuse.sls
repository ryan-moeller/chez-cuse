(library (cuse)
  (export cuse-init
          cuse-uninit
          cuse-alloc-unit-number
          cuse-alloc-unit-number-by-id
          cuse-free-unit-number
          cuse-free-unit-number-by-id
          cuse-vmalloc
          cuse-is-vmalloc-addr
          cuse-vmfree
          cuse-vmoffset
          cuse-dev*
          cuse-open
          cuse-close
          cuse-read
          cuse-write
          cuse-ioctl
          cuse-poll
          cuse-methods
          uid_t
          gid_t
          make-cuse-methods
          cuse-dev-create
          cuse-dev-destroy
          cuse-dev-get-priv0
          cuse-dev-set-priv0
          cuse-dev-get-priv1
          cuse-dev-set-priv1
          cuse-wait-and-process
          cuse-dev-get-per-file-handle
          cuse-dev-set-per-file-handle
          cuse-dev-set-local
          cuse-dev-get-local
          cuse-copy-out
          cuse-copy-in
          cuse-got-peer-signal
          cuse-dev-get-current
          cuse-poll-wakeup
          CUSE_VERSION
          CUSE_ERR_NONE
          CUSE_ERR_BUSY
          CUSE_ERR_WOULDBLOCK
          CUSE_ERR_INVALID
          CUSE_ERR_NO_MEMORY
          CUSE_ERR_FAULT
          CUSE_ERR_SIGNAL
          CUSE_ERR_OTHER
          CUSE_ERR_NOT_LOADED
          CUSE_ERR_NO_DEVICE
          CUSE_POLL_NONE
          CUSE_POLL_READ
          CUSE_POLL_WRITE
          CUSE_POLL_ERROR
          CUSE_FFLAG_NONE
          CUSE_FFLAG_READ
          CUSE_FFLAG_WRITE
          CUSE_FFLAG_NONBLOCK
          CUSE_FFLAG_COMPAT32
          CUSE_DBG_NONE
          CUSE_DBG_FULL
          CUSE_LENGTH_MAX
          CUSE_CMD_NONE
          CUSE_CMD_OPEN
          CUSE_CMD_CLOSE
          CUSE_CMD_READ
          CUSE_CMD_WRITE
          CUSE_CMD_IOCTL
          CUSE_CMD_POLL
          CUSE_CMD_SIGNAL
          CUSE_CMD_SYNC
          CUSE_CMD_MAX
          cuse-make-id
          CUSE_ID_MASK
          cuse-id-default
          cuse-id-webcamd
          cuse-id-sundtek
          cuse-id-cx88
          cuse-id-uhidd)
  (import (chezscheme))

  (define init (load-shared-object "libcuse.so"))

  (define cuse-init
    (foreign-procedure "cuse_init" () int))

  (define cuse-uninit
    (foreign-procedure "cuse_uninit" () int))

  (define cuse-alloc-unit-number
    (foreign-procedure "cuse_alloc_unit_number" ((* int)) int))

  (define cuse-alloc-unit-number-by-id
    (foreign-procedure "cuse_alloc_unit_number_by_id" ((* int) int) int))

  (define cuse-free-unit-number
    (foreign-procedure "cuse_free_unit_number" (int) int))

  (define cuse-free-unit-number-by-id
    (foreign-procedure "cuse_free_unit_number_by_id" (int int) int))

  (define cuse-vmalloc
    (foreign-procedure "cuse_vmalloc" (unsigned) void*))

  (define cuse-is-vmalloc-addr
    (foreign-procedure "cuse_is_vmalloc_addr" (void*) int))

  (define cuse-vmfree
    (foreign-procedure "cuse_vmfree" (void*) void))

  (define cuse-vmoffset
    (foreign-procedure "cuse_vmoffset" (void*) unsigned-long))

  (define-ftype cuse-dev* void*)
  (define-ftype
    [cuse-open (function (cuse-dev* int) int)]
    [cuse-close (function (cuse-dev* int) int)]
    [cuse-read (function (cuse-dev* int void* int) int)]
    [cuse-write (function (cuse-dev* int void* int) int)]
    [cuse-ioctl (function (cuse-dev* int unsigned-long void*) int)]
    [cuse-poll (function (cuse-dev* int int) int)]
    [cuse-methods
      (struct
        [open (* cuse-open)]
        [close (* cuse-close)]
        [read (* cuse-read)]
        [write (* cuse-write)]
        [ioctl (* cuse-ioctl)]
        [poll (* cuse-poll)])]
    [uid_t unsigned-32]
    [gid_t unsigned-32])

  (define make-cuse-methods
    (lambda (open close read write ioctl poll)
      (let ([methods (make-ftype-pointer
                      cuse-methods
                      (foreign-alloc (ftype-sizeof cuse-methods)))])
        (ftype-set! cuse-methods (open)
                    methods (make-ftype-pointer cuse-open open))
        (ftype-set! cuse-methods (close)
                    methods (make-ftype-pointer cuse-close close))
        (ftype-set! cuse-methods (read)
                    methods (make-ftype-pointer cuse-read read))
        (ftype-set! cuse-methods (write)
                    methods (make-ftype-pointer cuse-write write))
        (ftype-set! cuse-methods (ioctl)
                    methods (make-ftype-pointer cuse-ioctl ioctl))
        (ftype-set! cuse-methods (poll)
                    methods (make-ftype-pointer cuse-poll poll))
        methods)))

  (define-syntax cuse-dev-create
    (syntax-rules ()
      [(_ methods priv0 priv1 uid gid permission fmt)
       (cuse-dev-create methods priv0 priv1 uid gid permission fmt ())]
      [(_ methods priv0 priv1 uid gid permission fmt (t ...) e ...)
       ((foreign-procedure (__varargs_after 7)
                           "cuse_dev_create"
                           ((* cuse-methods) void* void* uid_t gid_t int string t ...) cuse-dev*)
        methods priv0 priv1 uid gid permission fmt e ...)]))

  (define cuse-dev-destroy
    (foreign-procedure "cuse_dev_destroy" (cuse-dev*) void))

  (define cuse-dev-get-priv0
    (foreign-procedure "cuse_dev_get_priv0" (cuse-dev*) void*))

  (define cuse-dev-set-priv0
    (foreign-procedure "cuse_dev_set_priv0" (cuse-dev* void*) void))

  (define cuse-dev-get-priv1
    (foreign-procedure "cuse_dev_get_priv1" (cuse-dev*) void*))

  (define cuse-dev-set-priv1
    (foreign-procedure "cuse_dev_set_priv1" (cuse-dev* void*) void))

  (define cuse-wait-and-process
    (foreign-procedure "cuse_wait_and_process" () int))

  (define cuse-dev-get-per-file-handle
    (foreign-procedure "cuse_dev_get_per_file_handle" (cuse-dev*) void*))

  (define cuse-dev-set-per-file-handle
    (foreign-procedure "cuse_dev_set_per_file_handle" (cuse-dev* void*) void))

  (define cuse-dev-set-local
    (foreign-procedure "cuse_set_local" (int) void))

  (define cuse-dev-get-local
    (foreign-procedure "cuse_get_local" () int))

  (define cuse-copy-out
    (foreign-procedure "cuse_copy_out" (void* void* int) int))

  (define cuse-copy-in
    (foreign-procedure "cuse_copy_in" (void* void* int) int))

  (define cuse-got-peer-signal
    (foreign-procedure "cuse_got_peer_signal" () int))

  (define cuse-dev-get-current
    (foreign-procedure "cuse_dev_get_current" ((* int)) cuse-dev*))

  (define cuse-poll-wakeup
    (foreign-procedure "cuse_poll_wakeup" () void))

  (define CUSE_VERSION #x125)

  (define CUSE_ERR_NONE 0)
  (define CUSE_ERR_BUSY -1)
  (define CUSE_ERR_WOULDBLOCK -2)
  (define CUSE_ERR_INVALID -3)
  (define CUSE_ERR_NO_MEMORY -4)
  (define CUSE_ERR_FAULT -5)
  (define CUSE_ERR_SIGNAL -6)
  (define CUSE_ERR_OTHER -7)
  (define CUSE_ERR_NOT_LOADED -8)
  (define CUSE_ERR_NO_DEVICE -9)

  (define CUSE_POLL_NONE 0)
  (define CUSE_POLL_READ 1)
  (define CUSE_POLL_WRITE 2)
  (define CUSE_POLL_ERROR 3)

  (define CUSE_FFLAG_NONE 0)
  (define CUSE_FFLAG_READ 1)
  (define CUSE_FFLAG_WRITE 2)
  (define CUSE_FFLAG_NONBLOCK 4)
  (define CUSE_FFLAG_COMPAT32 8)

  (define CUSE_DBG_NONE 0)
  (define CUSE_DBG_FULL 1)

  (define CUSE_LENGTH_MAX #x7FFFFFFF)

  (define CUSE_CMD_NONE 0)
  (define CUSE_CMD_OPEN 1)
  (define CUSE_CMD_CLOSE 2)
  (define CUSE_CMD_READ 3)
  (define CUSE_CMD_WRITE 4)
  (define CUSE_CMD_IOCTL 5)
  (define CUSE_CMD_POLL 6)
  (define CUSE_CMD_SIGNAL 7)
  (define CUSE_CMD_SYNC 8)
  (define CUSE_CMD_MAX 9)

  (define cuse-make-id
    (lambda (a b c u)
      (logor
        (ash (logand a #x7F) 24)
        (ash (logand b #xFF) 16)
        (ash (logand c #xFF) 8)
        (logand u #xFF))))

  (define CUSE_ID_MASK #x7FFFFF00)

  (define cuse-id-default
    (lambda (what)
      (cuse-make-id 0 0 what 0)))

  (define cuse-id-webcamd
    (lambda (what)
      (cuse-make-id (char->integer #\W) (char->integer #\C) what 0)))

  (define cuse-id-sundtek
    (lambda (what)
      (cuse-make-id (char->integer #\S) (char->integer #\K) what 0)))

  (define cuse-id-cx88
    (lambda (what)
      (cuse-make-id (char->integer #\C) (char->integer #\X) what 0)))

  (define cuse-id-uhidd
    (lambda (what)
      (cuse-make-id (char->integer #\U) (char->integer #\D) what 0)))
  )
