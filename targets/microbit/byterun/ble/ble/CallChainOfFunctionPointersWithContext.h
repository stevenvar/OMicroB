/* mbed Microcontroller Library
 * Copyright (c) 2006-2013 ARM Limited
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#ifndef MBED_CALLCHAIN_OF_FUNCTION_POINTERS_WITH_CONTEXT_H
#define MBED_CALLCHAIN_OF_FUNCTION_POINTERS_WITH_CONTEXT_H

#include <string.h>
#include "FunctionPointerWithContext.h"
#include "SafeBool.h"


/** Group one or more functions in an instance of a CallChainOfFunctionPointersWithContext, then call them in
 * sequence using CallChainOfFunctionPointersWithContext::call(). Used mostly by the interrupt chaining code,
 * but can be used for other purposes.
 *
 * Example:
 * @code
 *
 * CallChainOfFunctionPointersWithContext<void *> chain;
 *
 * void first(void *context) {
 *     printf("'first' function.\n");
 * }
 *
 * void second(void *context) {
 *     printf("'second' function.\n");
 * }
 *
 * class Test {
 * public:
 *     void f(void *context) {
 *         printf("A::f (class member).\n");
 *     }
 * };
 *
 * int main() {
 *     Test test;
 *
 *     chain.add(second);
 *     chain.add_front(first);
 *     chain.add(&test, &Test::f);
 *     chain.call();
 * }
 * @endcode
 */

template <typename ContextType>
class CallChainOfFunctionPointersWithContext : public SafeBool<CallChainOfFunctionPointersWithContext<ContextType> > {
public:
    typedef FunctionPointerWithContext<ContextType> *pFunctionPointerWithContext_t;

public:
    /** Create an empty chain.
     *
     *  @param size (optional) Initial size of the chain.
     */
    CallChainOfFunctionPointersWithContext() : chainHead(NULL) {
        /* empty */
    }

    virtual ~CallChainOfFunctionPointersWithContext() {
        clear();
    }

    /** Add a function at the front of the chain.
     *
     *  @param function A pointer to a void function.
     *
     *  @returns
     *  The function object created for 'function'.
     */
    pFunctionPointerWithContext_t add(void (*function)(ContextType context)) {
        return common_add(new FunctionPointerWithContext<ContextType>(function));
    }

    /** Add a function at the front of the chain.
     *
     *  @param tptr Pointer to the object to call the member function on.
     *  @param mptr Pointer to the member function to be called.
     *
     *  @returns
     *  The function object created for 'tptr' and 'mptr'.
     */
    template<typename T>
    pFunctionPointerWithContext_t add(T *tptr, void (T::*mptr)(ContextType context)) {
        return common_add(new FunctionPointerWithContext<ContextType>(tptr, mptr));
    }

    /** Add a function at the front of the chain.
     *
     *  @param func The FunctionPointerWithContext to add.
     */
    pFunctionPointerWithContext_t add(const FunctionPointerWithContext<ContextType>& func) {
        return common_add(new FunctionPointerWithContext<ContextType>(func));
    }

    /** 
     * Detach a function pointer from a callchain
     * 
     * @oaram toDetach FunctionPointerWithContext to detach from this callchain
     * 
     * @return true if a function pointer has been detached and false otherwise
     */ 
    bool detach(const FunctionPointerWithContext<ContextType>& toDetach) { 
        pFunctionPointerWithContext_t current = chainHead;
        pFunctionPointerWithContext_t previous = NULL;

        while (current) {
            if(*current == toDetach) { 
                if(previous == NULL) {
                    if(currentCalled == current) { 
                        currentCalled = NULL;
                    }
                    chainHead = current->getNext();
                } else {
                    if(currentCalled == current) { 
                        currentCalled = previous;
                    }
                    previous->chainAsNext(current->getNext());
                }
                delete current;
                return true;
            }

            previous = current;
            current = current->getNext();
        }

        return false;
    }

    /** Clear the call chain (remove all functions in the chain).
     */
    void clear(void) {
        pFunctionPointerWithContext_t fptr = chainHead;
        while (fptr) {
            pFunctionPointerWithContext_t deadPtr = fptr;
            fptr = deadPtr->getNext();
            delete deadPtr;
        }

        chainHead = NULL;
    }

    bool hasCallbacksAttached(void) const {
        return (chainHead != NULL);
    }

    /** Call all the functions in the chain in sequence
     */
    void call(ContextType context) {
        ((const CallChainOfFunctionPointersWithContext*) this)->call(context);
    }

    /**
     * @brief same as above but const 
     */
    void call(ContextType context) const {
        currentCalled = chainHead;

        while(currentCalled) { 
            currentCalled->call(context);
            // if this was the head and the call removed the head
            if(currentCalled == NULL) { 
                currentCalled = chainHead;
            } else {
                currentCalled = currentCalled->getNext();
            }
        }
    }

    /**
     * @brief same as above but with function call operator
     * \code
     * 
     * void first(bool);
     * void second(bool);
     * 
     * CallChainOfFunctionPointerWithContext<bool> foo;
     * 
     * foo.attach(first);
     * foo.attach(second);
     * 
     * // call the callchain like a function
     * foo(true);
     * 
     * \endcode
     */
    void operator()(ContextType context) const {
        call(context);
    }

    /**
     * @brief bool conversion operation
     */
    bool toBool() const {
        return chainHead != NULL;
    }

private:
    pFunctionPointerWithContext_t common_add(pFunctionPointerWithContext_t pf) {
        if (chainHead == NULL) {
            chainHead = pf;
        } else {
            pf->chainAsNext(chainHead);
            chainHead = pf;
        }

        return chainHead;
    }

private:
    pFunctionPointerWithContext_t chainHead;
    // iterator during a function call, this has to be mutable because the call function is const.
    // Note: mutable is the correct behaviour here, the iterator never leak outside the object.
    // So the object can still be seen as logically const even if it change its internal state
    mutable pFunctionPointerWithContext_t currentCalled;


    /* Disallow copy constructor and assignment operators. */
private:
    CallChainOfFunctionPointersWithContext(const CallChainOfFunctionPointersWithContext &);
    CallChainOfFunctionPointersWithContext & operator = (const CallChainOfFunctionPointersWithContext &);
};

#endif
