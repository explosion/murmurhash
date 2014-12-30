from libc.stdint cimport uint64_t, int64_t, int32_t


cdef uint32_t hash32(void* key, int length, uint32_t seed) nogil:
    cdef int32_t out
    MurmurHash3_x86_32(key, length, seed, &out)
    return out


cdef uint64_t hash64(void* key, int length, uint64_t seed) nogil:
    return MurmurHash64A(key, length, seed)

cdef uint64_t real_hash64(void* key, int length, uint64_t seed) nogil:
    cdef uint64_t[2] out
    MurmurHash3_x86_128(key, length, seed, &out)
    return out[1]
