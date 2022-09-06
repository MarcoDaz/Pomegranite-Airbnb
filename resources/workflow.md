# Development workflow

1. Create a Github issue in the relevant repository relating to the user story or bug. (TRELLO STUFF)

2. When you are ready to work on the user story, create a branch for it, e.g. `dates-on-apply-page`.

``` Create branch & switch to it
git checkout -b <branch_name>
```

``` Switch to another branch
git checkout <branch_name>
```

``` Show all branches
git branch
```

3. Pair on implementing the user story.

4. When you are done, create a pull request from your branch to `main`.

https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/incorporating-changes-from-a-pull-request/merging-a-pull-request-with-a-merge-queue

5. Get another member of the team to review your PR.

6. Use the pull request comments section to discuss the code and make improvements until the code reviewing pair are satisfied.

7. When you get a thumbs up or other similarly appropriate emoji, merge your PR.

8. When you're happy, merge your changes on GitHub. You should then deploy immediately. If you have CI setup you can get it to do this for you automatically.

pending.. in backlog

9. Do some QA on your live site if you have it set up.

10. High-five someone/something.