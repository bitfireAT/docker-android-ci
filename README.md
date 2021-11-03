
Docker image for testing Android apps with the Android emulator
===============================================================


Requirements
------------

The used Android emulator uses hardware accelation and thus requires root access,
i.e. a privileged Docker container. Unfortunately, **it won't run with a shared
runner from gitlab.com**.

It's recommended to install a self-hosted runner on a root server and run your
project's CI based on this Docker image in a privileged container.


How to use with Github
----------------------

When using with a self-hosted Github runner, specify the workflow like this:

```
  test_on_emulator:
    name: Tests with emulator
    runs-on: privileged
    container:
      image: ghcr.io/bitfireat/docker-android-ci:main
      options: --privileged
      env:
        ANDROID_HOME: /sdk
        ANDROID_AVD_HOME: /root/.android/avd
    steps:
	  # …

      - name: Start emulator
        run: start-emulator.sh
      - name: Run connected tests
        run: ./gradlew app:connectedStandardDebugAndroidTest
```



How to use with Gitlab
----------------------

[gitlab-ci-runner](https://docs.gitlab.com/runner/):

```
# /etc/gitlab-runner/config.toml

[[runners]]
  name = "runner1"
  [runners.docker]
    privileged = true
```

For DAVx⁵ and related components, the runner must have the `privileged` tag, 
because Android tests will require this tag.


Sample `.gitlab-ci.yml`:

```
image: ghcr.io/bitfireat/docker-android-ci:main

# …

test:
  tags:
    # require the privileged tag if the emulator is needed
    - privileged
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
