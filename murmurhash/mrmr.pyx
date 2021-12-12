from libc.stdint cimport uint64_t, int64_t, uint32_t, int32_t


cdef extern from "murmurhash/MurmurHash3.h":
    void MurmurHash3_x86_32(void * key, uint64_t len, uint64_t seed, void* out) nogil
    void MurmurHash3_x86_128(void * key, int len, uint32_t seed, void* out) nogil
    void MurmurHash3_x64_128(void * key, int len, uint32_t seed, void* out) nogil

cdef extern from "murmurhash/MurmurHash2.h":
    uint64_t MurmurHash64A(void * key, int length, uint32_t seed) nogil
    uint64_t MurmurHash64B(void * key, int length, uint32_t seed) nogil
    uint32_t MurmurHash2(void * key, int length, uint32_t seed) nogil


cdef uint32_t hash32(void* key, int length, uint32_t seed, int version) nogil:
    cdef int32_t out
    if version==3:
        MurmurHash3_x86_32(key, length, seed, &out)
    else:
        out = MurmurHash2(key, length, seed)
    return out


cdef uint64_t hash64(void* key, int length, uint64_t seed) nogil:
    return MurmurHash64A(key, length, seed)

cdef uint64_t real_hash64(void* key, int length, uint64_t seed) nogil:
    cdef uint64_t[2] out
    MurmurHash3_x86_128(key, length, seed, &out)
    return out[1]


cdef void hash128_x86(const void* key, int length, uint32_t seed, void* out) nogil:
    MurmurHash3_x86_128(key, length, seed, out)


cdef void hash128_x64(const void* key, int length, uint32_t seed, void* out) nogil:
    MurmurHash3_x64_128(key, length, seed, out)


cpdef int32_t hash(value, uint32_t seed=0, murmur_version=3):
    if isinstance(value, unicode):
        return hash_unicode(value, seed=seed, murmur_version=murmur_version)
    else:
        return hash_bytes(value, seed=seed, murmur_version=murmur_version)


cpdef int32_t hash_unicode(unicode value, uint32_t seed=0, murmur_version=3):
    return hash_bytes(value.encode('utf8'), seed=seed, murmur_version=murmur_version)


cpdef int32_t hash_bytes(bytes value, uint32_t seed=0, murmur_version=3):
    cdef char* chars = <char*>value
    return hash32(chars, len(value), seed, murmur_version)
