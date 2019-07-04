I found interesting behavior of GPEnhance library during my execution of part 2:
in case if I receive an error with code 2 (invalid arguments), that GPEnhancer object can't be used in next execution (and produce "threading conflict"). 
Please include that in your description for future candidates. 
I don't see any problem with reuse after error with code 1.

p.s.
possible improvements:
- additional test related to multithreading;
- architecture changes (MVVC);
- add UI elements in source instead of Storyboards;
- UI improvements;
- an async request of `execute` method.