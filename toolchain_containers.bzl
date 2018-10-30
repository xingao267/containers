def toolchain_container_sha256s():
    return {
        ###########################################################
        # Base images                                             #
        ###########################################################
        # gcr.io/cloud-marketplace/google/ubuntu16_04:latest
        "ubuntu16_04": "sha256:df51b5c52d71c9867cd9c1c88c81f67a85ff87f1defe7e9b7ac5fb7d652596bf",

        ###########################################################
        # Python3 images                                          #
        ###########################################################
        # gcr.io/google-appengine/python:latest
        "ubuntu16_04_python3": "sha256:f6955b2492f3ea481a50a9a9f0995b5f84a02d8dab357d2c9dae6b366988f074",
    }
