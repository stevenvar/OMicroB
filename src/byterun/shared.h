/*************************************************************************/
/*                                                                       */
/*                                OCaPIC                                 */
/*                                                                       */
/*                             Benoit Vaugon                             */
/*                                                                       */
/*    This file is distributed under the terms of the CeCILL license.    */
/*    See file ../../LICENSE-en.                                         */
/*                                                                       */
/*************************************************************************/

#ifndef SHARED_H
#define SHARED_H

int  create_sem(int init);
void destroy_sem(int sem);
void *alloc_shm(size_t size);
void P(int sem);
void V(int sem);

#endif
