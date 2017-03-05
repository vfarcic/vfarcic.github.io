# The Ten Commandments Of Continuous Delivery

Everyone wants to implement continuous delivery. After all, the benefits are too big to be ignored. Increase the speed of delivery, increase the quality, decrease the costs, free people to dedicate time on what brings value, and so on and so forth. Those improvements are like music to any decision maker. Especially if that person has a business background. If a tech geek can articulate the benefits continuous delivery brings to the table, when he asks a business representative for a budget, the response is almost always "Yes! Do it."

A continuous delivery project will start. Tests will be written. Builds will be scripted. Deployments will be automated. Everything will be tied into an automated pipeline and triggered on every commit. Everyone will enter a state of nirvana as soon as all that is done. There will be a huge inauguration party with a vice president having the honor to be the first one to press the button that will deploy the first release to production. Isn't that a glorious plan everyone should be proud of?

The project starts and, shortly afterward, you hit the first obstacle. But, since you are brave and do not give up that easily, you pass it. Then, not long afterward, another obstacle comes along. And another one after that. And on and on it goes. Half a year later you feel that you are not getting far. You spent your budget. You need to show results even though you cannot see the light at the end of the tunnel. CTO demands results. Business wants value for the investment. You decide to do the only sensible thing and declare that the project is finished. You are *continuous delivery certified* even though there is nothing continuous nor you are delivering. Continuous delivery joins other failed projects that are declared a big success. Not only that you are doing agile, but you also practice CD. Veni, vidi, vici. You joined the club of glorified failures. Well done!

Why did your attempt to implement continuous delivery fail? There cannot be one answer that fits all scenarios. However, some prerequisites and steps should be taken in almost all cases. The chances are that you missed some, if not all, of the commandments that follow.

## Thou Shalt Be Agile

Your organization must be agile before starting the journey towards continuous delivery.

All non-agile organizations I worked with are organized in silos that prevent continuous flow. Silos foment handovers. Business analysts pass requirements to developers. Developers give a release candidate to testers. Testers are sending it back to developers until they are happy with the release. From there it goes to the operations department. And so on and so forth. Handovers prevent things from being continuous because they create a state of limbo where things are waiting for something to happen. They are often tied to objectives that tend to benefit only an individual department, not the project as a whole. Not only that those objectives prevent continuous flow, but they are often conflicting. Goals given to developers can keep them from giving their code to testers as soon as it is done. Testers objectives might prevent them from trying to add quality from the start and focus on the number of bugs they find. Operations objectives often give incentives that could be best fulfilled if there is never a release (that's when a system is most stable). Most importantly, silos prevent teams from feeling each other pain. Without truly understanding the challenges others are facing, your solutions will be suboptimal at best.

The only way to implement continuous delivery is to remove those silos. Transform handovers into a continuous flow of bytes towards production (their final destination). Only when the organization as a whole is dedicated to removing obstacles and enabling a continuous flow of everything (information, people, and ideas) we can start thinking about technical aspects that need to be solved. Agile is the key.

"But I am agile", you might say. Maybe you are, more likely you're not. Most organizations are not agile, so the chances are that you are neither. Now, that sentence sounds like an exaggeration. Isn't almost everyone agile these days?

Not long ago there was "agile craziness." Everyone spoke about it and it became so big that it reached the level that even your CTO could not ignore it. We know that's true since even Gartner on their annual meetings (those that make CTOs being proud to be invited) said: "it's time, go agile." So, CTOs went back to their companies and told their underlings two historical sentences. "I made a decision. We will be agile." The problem is that in most cases that meant that everyone who is at least five levels below CTO should become agile. It does not work that way. Either the whole organization is agile, or no one is. Otherwise, sooner or later, you'll hit the ceiling that will prevent you from doing what needs to be done. When that happens, it will not matter that you renamed all your managers into scrum masters and that your business analysts are now product owners. Having daily standups does not make an organization agile. Changing the culture of the whole company does, and that is often not the case. So, you end up with a waterfall approach from the top of the pyramid that transforms itself into "agile" only at the very bottom. It's like taking an umbrella and walking towards the bottom of Niagara Falls muttering to yourself "So far so good. I just need to continue for awhile longer." It'll hit you hard.

Doing Agile for the sake of having one more sticker that can be placed right next to your PMI certificate is not the way to go. You need to adopt it truly.

## Thou Shalt Refactor

Are you ready to refactor your code? If you're not, continuous delivery will not work. You will spend endless hours trying to automate tests of an application that is not designed to be testable. Then, once you're finally finished, you'll discover that tests are flaky and fail for random reasons. You'll also find that tests execution lasts for hours instead of minutes. If an application is to pass through continuous delivery pipeline every time someone makes a commit, that application needs to be designed with that in mind.

Then you will start wondering why you didn't already refactor your application. Why did you let it rot for so long? While you might not know it, the answer is simple. Applications that do not have a good test coverage are too expensive to refactor. The risk is too high when any change to the code can have unforeseeable consequences. Applications without tests are by definition legacy applications. Lack of tests prevents us from improving our applications, and they soon become legacy. They become something that should not be touched unless a new feature is to be added.

Even if you do gather the courage to write tests for your application and refactor your code during the process, you will soon discover that it is not worth it. Didn't your parents teach you not to touch rotten food? The same can be said for applications. Leave them be or rewrite them. Making something old behave like its young is a waste of time. That would be like putting lipstick on my grandmother. You might slightly improve her looks, but you will not make her young again.

What you should have done from the very start is adopt continuous refactoring. We cannot allow ourselves to spend most of our time adding new features. No matter how much business likes getting new features, such approach leads to unmaintainable code that will result in ever increasing costs and time required to develop something.

I will go as far as to say that if you are not spending at least one-third of your coding time refactoring, you are not doing a good job.

## Thou Shalt Educate Everyone

You decided to create a continuous delivery department. I can see fireworks through my window and hear you celebrating such a decision. What will that department do? Create CD pipelines for all the teams to use? Create an Uber pipeline that will work with any project in your company? Free the developers from having to learn how Jenkins works? You should get a medal for being such a good sport. You are helping others by freeing them from learning how to do all that and letting them continue coding their applications.

Even though the sentence that follows will sound politically incorrect (you might even say offensive), I'm going to say it anyways. The existence of continuous delivery department is an abomination unless its goal is to create a proof of concept and educate others. Anything else is a misunderstanding at best.

Letting other people take care of your continuous delivery pipeline is wrong. They don't know what you're developing. You do. More importantly, if you cannot write the delivery pipeline yourself, you will not be able to design your application in a way that it is CD friendly. If you are responsible for the code of your application, you should be responsible for writing the CD pipeline as well. It is code as anything else, and it belongs to the team responsible for the application.

Instead of creating the Uber pipeline, spend your time educating the organization you work in. Don't give them fish. Teach them how to fish.

## Thou Shalt Be Small

There is nothing continuous about big teams. Hoping that you will be able to continuously deliver code maintained by a huge number of people is optimistic at best. It cannot be done. You have to have a small teams. That's one of the reasons why microservices are becoming so popular. A big team produces big code base. A lot of people sitting on top of a large application is equivalent to a huge container ship. It floats and, given enough time, it reaches its destination. But, we do not have time. We want things to be delivered as soon as possible. The only reasonable way to accomplish that speed is by forming small teams that are fully in charge of a service (or two). Only then we can have the speed we aim for. Each team can deliver features as soon as they are done without waiting for the rest of the company to wake up. Those teams are vertical. They are not formed from one department (e.g. testers) but consist of people that together possess all the skills required to deliver a service to production and ensure that it is always up and running.

How big should a team be? It depends on a use case but, as a rule of thumb, no less than four and no more than ten people. Anything more than that is not a software development team but a school reunion.

## Thou Shalt Practice TDD

I won't even enter into a discussion whether there should be any manual testing. Excluding exploratory tests, everything must be automated if you want to apply continuous delivery. It's OK if you have manual tests (actually it's not, but I'll pretend it is). The problem is that, if that's the case, you need to stop pretending that you can do continuous deployment. You can't. So, I'll assume that all your tests are automated (excluding exploratory testing).

You wrote a lot of tests and somehow managed to make them work all the time. Your coverage is high, and you do not have flaky tests. They are robust, and you can rely on them. You're my hero, and that's why it pains me to say that it is not good enough for continuous delivery. It is admirable that you managed to convert your legacy application into something that is testable and can be refactored (tests remove the fear of what will happen if when we change something). But, you need to go further.

Now you need to start writing tests before the code. If tests are not present by the time you make a commit, execution of your CD pipeline will (almost) always be successful. After all, if there is no validation of your changes, there's very little that could go wrong unless you managed to mess up with an old functionality.

If tests need to be part of a commit, then the question is when do you write them. As soon as you finish your code and before the commit? If that's what you do, the chances are that tests will be worthless. They will probably replicate the code you wrote. Instead, tests should drive your development. They should act as a requirement that you code against as well as a validation of the implementation.

Adopt test-driven development!

It will be hard at the beginning. First, you will think that it cannot be applied to your existing code and you will be right. Then you'll start designing your code better, and things will become easier. After a while, you will be able to do TDD, but the cost will be too high. You will notice that you are much slower with TDD than without. Do not despair. It gets easier, and it gets faster. Given enough practice, you will be faster with TDD than without. Much faster. You will be confident to refactor your code. You will be able to focus on the task at hand knowing that your tests cover you from most (not to say all) side effects. You will start wondering how did you ever develop something without TDD. The only problem is that it takes time to master it. The good news is that there is a pot of gold at the end of this rainbow. You just need to be persistent.

The important thing to understand about TDD is that the primary objective are not tests, but the approach to design software. Tests are a precious side-product of the process.

You might not agree on the value of TDD. That's OK. I won't start the war. But, no matter which approach you take, tests need to be part of every commit unless you are refactoring your code. In that case, your service did not change functionality so the existing tests might be all you need.

## Thou Shalt Define Your CD Pipeline As Code

Isn't it convenient that you can create a new job in Jenkins with a few clicks and by setting values to a few fields? Maybe it's not a few, but it's still worth it. It allows you to create a CD pipeline without having to learn how to code. Isn't that great?

It's not!

Software industry gave up on the click-click-click type of tools for developers. Frameworks that allow you to specify everything through an UI are a failure. ESBs (at least those based on UIs) are gone. Editors that allow you to drag & drop elements that automagically turn into HTML disappeared. Cluster administration through UI is the thing of the past. Code is the only thing that stayed. UIs are for users, code is for developers.

I'll use this opportunity to tell you a secret. It doesn't matter what your specialty is. If you work on software, you're a coder. Or, at least, you should be. If you are a tester, you should code your tests. If you're an operator, you should code your operations. If you're in charge of CD pipelines (ignoring the fact that such a role should not exist), you should write them as code.

The everything-as-code trend is evident with CD tools. Most (at least those worth using) were either built around pipelines defined as code or had them added later. If you are a Jenkins user, use Jenkins Pipeline. Forget that FreeStyle jobs ever existed. If you prefer some other tool, the advice is the same. CD pipelines should be defined as code.

You might be asking yourself "why should we define CD pipeline as code?" The answer lies in development practices we adopted. Code is easy to version, easy to put to Git (or whichever VCS you might be unfortunate to use), it can be easily reviewed, deployed, and so on and so forth. Most importantly, pipeline defined as code can reside together with the rest of the code is testing, building, and deploying. It should be in the same repository. If you do not see value in versioning, code reviews, pull requests, and other goodies developers use, you have a big problem. You are in the wrong industry. You don't belong in a software company. They say that it is never too late to switch a profession. You can become a doctor or a lawyer. What do you say? Is it too late? It takes too much time to become a doctor or a lawyer? Indeed it does. The same holds true for a good software engineer. So, get a grip on yourself and learn how to code.

## Thou Shalt Have a Fast Pipeline

CD pipeline must be fast. How fast, you might ask. Well, that depends on how much time a developer needs to get out of his chair, go to the kitchen, grab a coffee, and get back to his desk to start working on a new feature. He might meet someone on the way and have a short chat. Or, maybe, you don't have a coffee machine in your office, and he'll need to go to the closest bar to get it. As you can see, the time might differ from one case to another. I would estimate it to around fifteen minutes on average. That's how fast your pipeline should be.

You want to be focused on the task at hand. That task is finished only when it's truly done, and that includes validations through the CD pipeline. Only when you're done with one task, you can move to the next. Otherwise, you might need to do a lot of context switching. Start working on a new feature, receive a notification of a failure of a build, go back to the feature you worked on before you started the new one, try to remember what you did, fix it, push the change, go back to the new feature, work for a while, receive another notification of a failure, try to figure out what went wrong, and so on, and so forth. That is not the way to be productive. Our work requires concentration, and we cannot be focused on the task at hand if we are interrupted by notifications of a failed build.

"We cannot make our CD pipeline run in under fifteen minutes," you might say. First of all, I need to clarify that the-time-to-fetch-a-coffee is the time most of the pipeline should run. Load testing is an exception. It alone can take more than the-time-to-fetch-a-coffee. Put it to the end of the pipeline or run it in parallel. Everything else should be fast. We need that feedback ASAP.

Going back to complaint that your CD pipeline executes longer than the-time-to-fetch-a-coffee... If that's the case, re-read the *Thou Shalt Refactor* commandment. Find out how to design testable applications. Learn how to write mocks and stubs. Use Docker to speed up deployments. Run pipeline steps in parallel. I never said it'll be easy. I said that you'll fail. If you got this far, there is hope. Don't give up now.

## Thou Shalt Consider Fixing a Failed Pipeline As Highest Priority

What happens when a CD pipeline fails? If it is slow (see the *Thou Shalt Have a Fast Pipeline* commandment), you'll probably try to stay focused and continue working on that new feature. The problem will be fixed later. If that's the case, let me tell you that your behavior is unacceptable. There should be nothing more important than fixing a failed CD pipeline. A few notable exceptions are evacuation in case your office start burning and a call from your mom who wants to tell you about the latest development in the soap opera she's watching. In all other cases, you need to stop doing what you're doing and fix the problem. It will not go away, so better get to it while it's still fresh in your mind. You'll find the problem fast. After all, how difficult it is to discover the root cause of something you just pushed to the repository a few minutes ago. That's why the pipeline must be fast. You are not supposed to work on anything else until it's finished (load testing excluded).

One of the problems you might experience with this commandment is that your tests might be flaky. They might fail for reasons beyond bugs in your code. I've seen it many times before. A test failed, and you went through it only to discover that it works most of the time and is not a sign of a bug. The third time that happens, you'll probably ignore it. "Oh, it's' that test again. Just rerun the pipeline, and it will work." After a while, you'll even stop re-running the pipeline and just ignore notifications of a failure. When that happens, trust in the system is lost, and you can just as well uninstall your Jenkins instance and free its resources for something more useful.

A failed test needs to be fixed no matter whether that requires a modification of the code under test or the test itself. It's as simple as that (to explain, not necessarily to do).

## Thou Shalt Run The CD Pipeline Locally

There is no excuse for committing code that is not likely to work. CD pipeline is the last line of defense, not a system that allows you to push code that you are not confident with. The fact that you have a CD pipeline running on some server does not mean that you should not execute part of it locally before committing your code. I'm not suggesting that you should run performance tests on your laptop nor that you should deploy to production manually. You shouldn't. But what you should do is run most of the pipeline locally before committing your code. Execute unit tests, build your artifacts, run (parts) of integration tests. We have the technology to do that and, if you followed the commandments, the pipeline is very fast, so you won't lose much time.

Committing code that is not likely going to work is a sign of disrespect to your coworkers. They might pull that code and work on top of it. If you use pull requests that is avoided but then you are wasting time others need to spend reviewing the code that does not work.

## Thou Shalt Commit Only To The Master Branch (Or Use Short-Lived Feature Branches)

You got far. You are agile. You refactored your code so that it is testable and you adopted continuous refactoring as a way to keep your service from becoming legacy I-cannot-work-on-this-anymore type of code. Everyone is educated on the benefits of continuous delivery, and everyone adopted its practices. Your teams are small, and everyone is developing using TDD principles. Your CD pipeline is defined as code, and it is lightning fast. When a pipeline fails, fixing is the highest priority.

What else should be done? Surely you did everything in your power to be a shining example of continuous delivery.

Your teams are working with branches, and once a feature is done, it is merged to the `master` and delivered to production. Everything is peachy. The only problem is that you are not continuous. You adopted some of the best practices, but you are still only doing the delivery part of CD.

One of the main ideas behind CD (and CI for that matter) is to continuously validate that our code is working as expected. If you are using branches and you are merging them into `master` less frequently that once a day, you are postponing CD. You can just as well call it _eventual delivery_. The more time it takes for you to merge your branch, the more time you are in the dark. Remember, it's not only about validating the code you wrote but verifying whether it integrates with the code others are working on. That integration is often the cause of some of the most problematic bugs.

Ideally, you would not even have branches but commit directly to `master`. If your CD pipeline is trustworthy, the risk of such an approach is indeed very low and the benefits are great.

I can imagine that, at this moment, you are muttering to yourself something like "it cannot be done," or "it is too risky." It can certainly be done, and it is done by quite a few of the advanced software companies. Whether it is too risky depends on your ability to truly adopt the CD approach to software development. You might have to use feature toggles, and each member of your teams will have to take responsibility for what they do.

You might still think that committing to the `master` branch is too much of a stretch for you. That's OK. You can use branches. What you cannot do is wait too long before they are merged back to `master`. Once a day, if not more frequently, should be the limit. Spend six hours coding, merge it to the `master` branch and wait for a few minutes in case the pipeline fails. If it does, you still have two hours to fix the problem before leaving the office. Given that all other commandments are fulfilled, this one should be a piece of cake. The problem is more in the mental adjustment than anything else. We've been used to long-living branches for so long that it seems as if that are the only way to work.

## What Now?

You should be proud if you managed to follow all ten commandments. While most companies claim that they are doing continuous delivery, the truth is that most are faking it. Like with any other popular practices, companies jump into it, try to apply it, fail to do it, and, finally, change the rules and the objectives so that they can put the sticker and inform the CTO that it's done. If you did manage to do it, you could say that you are a member of a very small and exclusive club. Welcome to the advanced software development.

There's only one thing missing. Remove that button that deploys your services to production. Remove the only manual action left in your process and convert your pipeline from continuously delivering to continuously deploying to production. The process is the same. The only difference is a single button.
