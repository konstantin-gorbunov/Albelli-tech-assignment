//
//  GPEnhance.h
//  GPEnhance
//
//  Created by Gerard Putter on 31-08-13.
//  Copyright (c) 2013 Albumprinter BV. All rights reserved.
//

/*
 * This header file is part of the exercise "integrate 3rd party enhancement library".
 */

#ifndef GPEnhance_GPEnhance_h
#define GPEnhance_GPEnhance_h

#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif
    typedef void *GPEnhancer;    // Opaque object

    /*
     * Initialize the object to be used for enhancement processing. Returns NULL on failure.
     * Note that creating this object is resource-intensive. It allocates memory, checks licenses,
     * reads configuration files, and might even access online resources (if the computer is connected
     * to the internet). Therefore the recommended usage pattern is to create the enhancer once, and 
     * use it for subsequent calls to gp_enhance_execute.
     */
    GPEnhancer gp_enhance_create(void);
    
    /*
     * Frees the resources allocated in gp_enhance_create.
     * enhancer is allowed to be NULL, in which case nothing happens.
     */
    void gp_enhance_dispose(GPEnhancer enhancer);
    
    /*
     * Performs the enhancement.
     * enhancer     : the enhancer object, created before with gp_enhance_create. It can be used in
     *                only one thread at the same time.
     * s_in         : input ASCII string, terminated by a null-character
     * s_out        : the buffer where the null-terminated result string is stored.
     * max_length   : the length available in s_out, including the terminating null-character.
     * return value : 0 = operation successful
     *                1 = max_length is too small to hold the result
     *                2 = invalid arguments
     *
     * NOTE: In the context of this exercise, the function returns the input string reverted. So 
     *       for example, "abc" becomes "cba".
     */
    int gp_enhance_execute(GPEnhancer enhancer, const char *s_in, char *s_out, size_t max_length);
    
#ifdef __cplusplus
}
#endif

#endif  /* If not included */
