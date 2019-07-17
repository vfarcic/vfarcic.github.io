# Flip the Continuous Delivery Switch

The chances are that the first time you flip the continuous delivery switch, it will be a failure. You might have thought that it is about designing an automated CD pipeline but the reality is that it requires changes on many different levels.

Your whole organization needs to **be agile**. Otherwise, silos and handovers will prevent you from being continuous.

You will probably have to **refactor your applications**. They need to be designed to be testable, or it will be too expensive to write tests, and they will be too slow to run.

You will have to **educate everyone**. CD is not something done by a separate department but a way of developing applications.

Form **small self-sufficient teams (4 to 10 people)**. Microservices are a good fit. Big applications and big teams are too slow.

**Tests will need to be written before a commit**. Otherwise, CD pipeline will not test new features and report everything as green. Adopt TDD.

**CD pipeline needs to be fast**. Otherwise, a developer will start working on a new feature before receiving a notification of a failure. Context switching is very time demanding.

