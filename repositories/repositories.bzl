# Copyright 2016 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Once recursive workspace is implemented in Bazel, this file should cease
# to exist.

load(
    "@bazel_tools//tools/build_defs/repo:http.bzl",
    "http_archive",
    "http_file",
)
load(
    "//third_party/golang:revision.bzl",
    "GOLANG_REVISION",
    "GOLANG_SHA256",
)
load(
    "//third_party/clang:revision.bzl",
    "CLANG_REVISION",
    "DEBIAN8_CLANG_SHA256",
    "DEBIAN9_CLANG_SHA256",
    "UBUNTU16_04_CLANG_SHA256",
)
load(
    "//third_party/libcxx:revision.bzl",
    "DEBIAN8_LIBCXX_SHA256",
    "DEBIAN9_LIBCXX_SHA256",
    "LIBCXX_REVISION",
    "UBUNTU16_04_LIBCXX_SHA256",
)
load(
    "//third_party/openjdk:revision.bzl",
    "JDK_VERSION",
    "OPENJDK_SHA256",
    "OPENJDK_SRC_SHA256",
)
load(
    "//third_party/bazel:revision.bzl",
    "BAZEL_VERSION_SHA256S",
)

def repositories():
    """Download dependencies of bazel-toolchains."""
    excludes = native.existing_rules().keys()

   # ============================== Repositories ==============================
    if "io_bazel_rules_docker" not in excludes:
        http_archive(
            name = "io_bazel_rules_docker",
            sha256 = "d9ee70d2f763ce197e2691f12d69ee8e32b2245a48d53b4365fa239b66405c0c",
            strip_prefix = "rules_docker-7391b39ccad788524262e106d54adfdbfc3e44d5",
            urls = ["https://github.com/bazelbuild/rules_docker/archive/7391b39ccad788524262e106d54adfdbfc3e44d5.tar.gz"],
        )

    # io_bazel_rules_go is the dependency of container_test rules.
    if "io_bazel_rules_go" not in excludes:
        http_archive(
            name = "io_bazel_rules_go",
            urls = ["https://github.com/bazelbuild/rules_go/releases/download/0.16.0/rules_go-0.16.0.tar.gz"],
            sha256 = "ee5fe78fe417c685ecb77a0a725dc9f6040ae5beb44a0ba4ddb55453aad23a8a",
        )

    if "base_images_docker" not in excludes:
        http_archive(
            name = "base_images_docker",
            sha256 = "1355ba2f4509409f3f57a4a4a03200b9431f0e37924950b02cc6955b691aee23",
            strip_prefix = "base-images-docker-c4c3ff85458ce5dd3d93298559605d97fe948d17",
            urls = ["https://github.com/GoogleCloudPlatform/base-images-docker/archive/c4c3ff85458ce5dd3d93298559605d97fe948d17.tar.gz"],
        )

    if "distroless" not in excludes:
        http_archive(
            name = "distroless",
            sha256 = "daf9b18ca2d4ae11501846a311011ef2fa2c8db95529c5b5f6069977967712e0",
            strip_prefix = "distroless-10f0810b962145e4636282005226c4eb72519182",
            urls = ["https://github.com/GoogleCloudPlatform/distroless/archive/10f0810b962145e4636282005226c4eb72519182.tar.gz"],
        )

    # ================================ GPG Keys ================================
    # Bazel gpg key necessary to install Bazel in the containers.
    if "bazel_gpg" not in excludes:
        http_file(
            name = "bazel_gpg",
            sha256 = "30af2ca7abfb65987cd61802ca6e352aadc6129dfb5bfc9c81f16617bc3a4416",
            urls = ["https://bazel.build/bazel-release.pub.gpg"],
        )

    # Docker gpg key necessary to install Docker in the containers.
    if "xenial_docker_gpg" not in excludes:
        http_file(
            name = "xenial_docker_gpg",
            sha256 = "1500c1f56fa9e26b9b8f42452a553675796ade0807cdce11975eb98170b3a570",
            urls = ["https://download.docker.com/linux/ubuntu/gpg"],
        )

    # GCloud gpg key necessary to install GCloud in the containers.
    if "gcloud_gpg" not in excludes:
        http_file(
            name = "gcloud_gpg",
            sha256 = "226ba1072f20e4ff97ee4f94e87bf45538a900a6d9b25399a7ac3dc5a2f3af87",
            urls = ["https://packages.cloud.google.com/apt/doc/apt-key.gpg"],
        )

    # =============================== Toolchains ===============================
    # Golang
    if "golang_release" not in excludes:
        http_file(
            name = "golang_release",
            downloaded_file_path = "go" + GOLANG_REVISION + ".linux-amd64.tar.gz",
            sha256 = GOLANG_SHA256,
            urls = ["https://storage.googleapis.com/golang/go" + GOLANG_REVISION + ".linux-amd64.tar.gz"],
        )

    # Clang
    if "ubuntu16_04_clang_release" not in excludes:
        http_file(
            name = "ubuntu16_04_clang_release",
            downloaded_file_path = "clang_" + CLANG_REVISION + ".tar.gz",
            sha256 = UBUNTU16_04_CLANG_SHA256,
            urls = ["https://storage.googleapis.com/clang-builds-stable/clang-ubuntu16_04/clang_" + CLANG_REVISION + ".tar.gz"],
        )

    # libcxx
    if "ubuntu16_04_libcxx_release" not in excludes:
        http_file(
            name = "ubuntu16_04_libcxx_release",
            downloaded_file_path = "libcxx-msan_" + LIBCXX_REVISION + ".tar.gz",
            sha256 = UBUNTU16_04_LIBCXX_SHA256,
            urls = ["https://storage.googleapis.com/clang-builds-stable/clang-ubuntu16_04/libcxx-msan_" + LIBCXX_REVISION + ".tar.gz"],
        )

    # ============================ Bazel installers ============================
    # Official Bazel installer.sh for all supported versions.
    for bazel_version, bazel_sha256 in BAZEL_VERSION_SHA256S.items():
        name = "bazel_%s_installer" % (bazel_version.replace(".", ""))
        if name not in excludes:
            http_file(
                name = name,
                downloaded_file_path = "bazel-" + bazel_version + "-installer-linux-x86_64.sh",
                sha256 = bazel_sha256,
                urls = [
                    "https://releases.bazel.build/" + bazel_version + "/release/bazel-" + bazel_version + "-installer-linux-x86_64.sh",
                    "https://github.com/bazelbuild/bazel/releases/download/" + bazel_version + "/bazel-" + bazel_version + "-installer-linux-x86_64.sh",
                ],
            )

    # ============================ Azul OpenJDK packages ============================
    if "azul_open_jdk" not in excludes:
        http_file(
            name = "azul_open_jdk",
            downloaded_file_path = "zulu" + JDK_VERSION + "-linux_x64-allmodules.tar.gz",
            sha256 = OPENJDK_SHA256,
            urls = ["https://mirror.bazel.build/openjdk/azul-zulu" + JDK_VERSION + "/zulu" + JDK_VERSION + "-linux_x64-allmodules.tar.gz"],
        )

    if "azul_open_jdk_src" not in excludes:
        http_file(
            name = "azul_open_jdk_src",
            downloaded_file_path = "zsrc" + JDK_VERSION + ".zip",
            sha256 = OPENJDK_SRC_SHA256,
            urls = ["https://mirror.bazel.build/openjdk/azul-zulu" + JDK_VERSION + "/zsrc" + JDK_VERSION + ".zip"],
        )
