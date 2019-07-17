# The Ten Commandments Of Continuous Delivery

The chances are that you already had a "continuous deliver project" and that it failed. It does not matter that you announced to the world that it was a big success. You failed and you do not want to admit it. I might be wrong. If I am, you should be proud since you are a minority.

Why did your attempt to implement continuous delivery fail? Some prerequisites and steps should be taken in almost all cases. The chances are that you missed some, if not all, of the commandments that follow.

## Thou Shalt Be Agile

Your organization must be agile before starting the journey towards continuous delivery. Doing Agile for the sake of having one more sticker that can be placed right next to your PMI certificate is not the way to go. You need to adopt it truly. Otherwise, handovers between different departments will convert continuous into eventual delivery.

## Thou Shalt Refactor

You'll discover that tests are flaky and fail for random reasons. You'll also find that tests execution lasts for hours instead of minutes. If an application is to pass through continuous delivery pipeline every time someone makes a commit, that application needs to be designed with that in mind. Refactor your applications. Make them build-friendly, test-friendly, and deploy-friendly. (Re)design them with CD in mind.

## Thou Shalt Educate Everyone

Letting other people take care of your continuous delivery pipeline is wrong. They don't know what you're developing. You do. More importantly, if you cannot write the delivery pipeline yourself, you will not be able to design your application in a way that it is CD friendly. If you are responsible for the code of your application, you should be responsible for writing the CD pipeline as well. It belongs to the team responsible for the application. Instead of creating the Uber pipeline, spend your time educating the organization you work in.

## Thou Shalt Be Small

There is nothing continuous about big teams. Hoping that you will be able to continuously deliver code maintained by a huge number of people is optimistic at best. It cannot be done. You have to have a small teams. How big should a team be? It depends on a use case but, as a rule of thumb, no less than four and no more than ten people. Anything more than that is not a software development team but a school reunion.

## Thou Shalt Practice TDD

Excluding exploratory tests, everything must be automated if you want to apply continuous delivery.But, that is not enough. You will need to start writing tests before the code. If tests are not present by the time you make a commit, execution of your CD pipeline will (almost) always be successful. Adopt test-driven development!

## Thou Shalt Define Your CD Pipeline As Code

Define your CD pipelines as code. Code is easy to version, easy to put to Git, it can be easily reviewed, deployed, and so on and so forth. Most importantly, pipeline defined as code can reside together with the rest of the code is testing, building, and deploying. Get a grip on yourself and learn how to code.

## Thou Shalt Have a Fast Pipeline

CD pipeline must be fast. How fast, you might ask. Well, that depends on how much time a developer needs to get out of his chair, go to the kitchen, grab a coffee, and get back to his desk to start working on a new feature. Our work requires concentration, and we cannot be focused on the task at hand if we are interrupted by notifications of a failed build. Pipeline execution needs to finish before we move onto a new task.

## Thou Shalt Consider Fixing a Failed Pipeline As Highest Priority

There should be nothing more important than fixing a failed CD pipeline. When a build fails, you need to stop doing what you're doing and fix the problem. It will not go away, so better get to it while it's still fresh in your mind. You'll find the problem fast. A failed test needs to be fixed no matter whether that requires a modification of the code under test or the test itself.

## Thou Shalt Run The CD Pipeline Locally

CD pipeline is the last line of defense, not a system that allows you to push code that you are not confident with. Run most of the pipeline locally before committing your code. Execute unit tests, build your artifacts, run (parts) of integration tests. We have the technology to do that and, if you followed the commandments, the pipeline is very fast, so you won't lose much time. Committing code that is not likely going to work is a sign of disrespect to your coworkers. They might pull that code and work on top of it.

## Thou Shalt Commit Only To The Master Branch (Or Use Short-Lived Feature Branches)

One of the main ideas behind CD (and CI for that matter) is to continuously validate that our code is working as expected. If you are using branches and you are merging them into `master` less frequently that once a day, you are postponing CD. You can just as well call it _eventual delivery_. The more time it takes for you to merge your branch, the more time you are in the dark.

## What Now?

You should be proud if you managed to follow all ten commandments. While most companies claim that they are doing continuous delivery, the truth is that most are faking it. Like with any other popular practices, companies jump into it, try to apply it, fail to do it, and, finally, change the rules and the objectives so that they can put the sticker and inform the CTO that it's done. If you did manage to do it, you could say that you are a member of a very small and exclusive club. Welcome to the advanced software development.

