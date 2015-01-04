from libc.stdint cimport uint64_t, int64_t, uint32_t

cdef extern from "murmurhash/MurmurHash3.h":
    void MurmurHash3_x86_32(void * key, uint64_t len, uint64_t seed, void* out) nogil
    void MurmurHash3_x86_128(void * key, uint64_t len, uint64_t seed, void* out) nogil

cdef extern from "murmurhash/MurmurHash2.h":
    uint64_t MurmurHash64A(void * key, int length, uint32_t seed) nogil
    uint64_t MurmurHash64B(void * key, int length, uint32_t seed) nogil


cdef uint32_t hash32(void* key, int length, uint32_t seed) nogil
cdef uint64_t hash64(void* key, int length, uint64_t seed) nogil
cdef uint64_t real_hash64(void* key, int length, uint64_t seed) nogil
