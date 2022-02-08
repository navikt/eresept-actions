# Jacoco report
This action makes badges out of jacoco coverage reports and uploads coverage report.
A branch named badges must exist.

In this workflow, we use a dedicated branch for storing the badges.
It assumes that the badges branch already exists. That branch can otherwise
be empty, as its only purpose is to store the coverage badges. Why? Well, if
our main branch has required checks or reviews, the default GITHUB_TOKEN won't
be able to push to it. By storing the badges in a dedicated branch, this is not
an issue (just don't put any required checks or required reviews on the badges
branch). Note that since we won't be storing anything else in the badges branch,
we just put them in the root of that branch.

IMPORTANT: Take note of the 2 checkout step that are necessary for this variation.
The first is the usual checkout step. The second checks out the dedicated badges branch
(see the ref input) nested inside of the other in the path badges (see the path input).
So locally within the rest of this workflow run, we'll have access to the badges branch
within a badges directory.