###################################################################
proftest - playground for testing various profilers with googletest
###################################################################

In short this is just a setup that builds googletest with a hello world and then
have a couple of helper targets to run gprof, valgrind, callgrind etc.

Install and run
***************

.. code-block:: bash

    $ git clone --recurse-submodules git@github.com:jbech-linaro/proftest.git
    # Just compile and run it
    $ make && ./main
    # Compile and run it in valgrind using callgrind
    $ make callgrind && ./main
    # Compile and show result in kcachegrind
    $ make kcachegrind
    # Show a graphviz dot of the callstack
    $ make gprof2dot
    # Run gprof
    $ make gprof && ./main && gprof main gmon.out

