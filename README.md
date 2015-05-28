# mi-parallel-portlet

This portlet contains what you need to develop your own one to submit and run special jobs.

You can choose the kind of parallel job you would like to run from a list containing the following elements:

Job Collection: is a simple parallel application that spawns N sub-jobs; when all these are successfully  completed the whole collection becomes DONE.
Workflow N1: is a parallel application that spawns N sub-jobs, waits until all these are correcly completed and then submits a new job whose input files are the outputs of the N sub-jobs. When also this "final job" is successfully executed, the whole Workflow N1 becomes DONE.
Job Parametric: is a parallel application that spawns N sub-jobs with the same executable and with different arguments (i.e., input parametrers); when all these are successfully completed the whole parametric job becomes DONE.
The following instructions show how to deploy this exemplar portlet, how to use it to submit the above mentioned parallel jobs and how to customize the code to reuse it to develop your own portlets.
