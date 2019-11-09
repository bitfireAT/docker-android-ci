
Docker image for testing Android apps with the Android emulator
===============================================================


Requirements
------------

The used Android emulator uses hardware accelation and thus requires root access,
i.e. a privileged Docker container. Unfortunately, **it won't run with a shared
runner from gitlab.com**.

It's recommended to install [gitlab-ci-runner](https://docs.gitlab.com/runner/)
on a root server and run your project's CI based on this Docker image
in a privileged container:

```
# /etc/gitlab-runner/config.toml

[[runners]]
  name = "runner1"
  [runners.docker]
    privileged = true
```

For DAVx⁵ and related components, the runner must have the `privileged` tag, 
because Android tests will requires this Docker tag.


How to use with Gitlab CI
-------------------------

Sample `.gitlab-ci.yml`:

```
image: registry.gitlab.com/bitfireat/docker-android-emulator:latest

…

test:
  script:
   - start-emulator.sh
   - ./gradlew app:check app:connectedCheck

  artifacts:
    paths:
      - app/build/outputs/lint-results-debug.html
      - app/build/reports
      - build/reports

…

```
