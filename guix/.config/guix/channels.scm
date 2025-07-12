;;(list (channel
;;        (name 'guix)
;;        (url "https://git.guix.gnu.org/guix.git")
;;        (branch "master")
;;        (commit
;;          "7abc8869f50ea5f480d7838c359e2e0e7d8e9671")
;;        (introduction
;;          (make-channel-introduction
;;            "9edb3f66fd807b096b48283debdcddccfea34bad"
;;            (openpgp-fingerprint
;;              "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA")))))

(append
  (list (channel
          (name 'guix-hpc)
          (url "https://gitlab.inria.fr/guix-hpc/guix-hpc.git")
          (branch "master")))
  %default-channels)
