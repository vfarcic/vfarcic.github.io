# Flip The Switch: The Road to Continuous Delivery

Everyone wants to implement continuous delivery. After all, the benefits are too big to be ignored. Increase the speed of delivery, increase the quality, decrease the costs, free people to dedicate time on what brings value, and so on and so forth. Those improvements are like music to any decision maker. Even more so if that person has a business background. When a tech savy geek comes to business asking for a budget to implement continuous delivery the response is almost always "Yes! Do it."

What most do not understand is that their continuous delivery will fail.

A continuous delivery project will be made. Tests will be written. Builds will be scripted. Deployments will be automated. Everything will be tied into an automated pipeline and triggered on every commit. Everyone will enter a state of nirvana as soon as all that is done. There will be a huge inauguration party with a vice president having the honor to be the first one to press the button that will deploy the first release to production. Isn't that a glorious plan everyone should be proud of?

The project starts and, shortly afterwards, you hit the first obstacle. But, since you are brave and do not give up that easily, you pass it. Then, not long afterwards, another obstacle comes along. And another one after that. And on and on it goes. Half a year later you feel that you are not getting far. You spent you budget. You need to show results even though you cannot see the light at the end of the tunnel. CTO demands results. Business wants value for the investment. You decide to do the only sensible thing and declare that the project is finished. You are continuous delivery certified even though there is nothing continuous nor you are delivering. Continuous delivery joins other failed projects that are glorified as a big success. Not only that you are doing agile but you also practice CD. Veni, vidi, vici. You joined the club of glorified failures. Well done!

## Prerequisites and Steps Towards Continuous Delivery

Why did you attempt to implement continuous delivery fail? There cannot be one answer that fits all scenarios. However, there are some prerequisites and steps that should be taken in almost all cases.

### Thou Shalt Be Agile

Your organization MUST be agile before starting the journey towards continuous delivery.

All non-agile organizations I worked with are organized in silos that prevent continuous flow. Silos foment handovers. Business analysts pass requirements to developers. Developers pass a release candidate totesters. Testers pass it back to developers until they are happy with the release. From there it goes to operations department. And so on and so forth. Handovers prevent things from being continuous because they create a state of a limbo when things are waiting for something to happen. They are often tied to objectives that tend to benefit only certain department, not the project as a whole. Those objectives not only that tend to prevent continuous flow but are often conflicting. Objectives given to testers can prevent them from giving their code to testers as soon as it is done. Testers objective might prevent them from trying to add quality from the start and focus on the number of bugs they find. Operations objectives often give incentives that could be best fulfilled if there is never a release (that's when a system is most stable). Most importantly, silos prevent teams from feeling each others pain.

The only way to implement continuous delivery is to remove those silos. Transform handovers into a continuous flow of bytes towards production (their final destination). Only when the organization as a whole is dedicated on removing obstacles and enabling continuous flow of everything (information, people, and ideas) we can start thinking about technical aspects that need to be solved. Agile is the key.

"But I am agile", you might say. Maybe you are, most likely you're not. Most organizations are not agile so the chances are that you are neither.

Not long ago there was "agile craziness". Everyone spoke about it and it became so big that it reached the level that even your CTO could not ignore it. Even Gartner on their annual meetings (those that make CTOs being proud to be invited) said "it's time, go agile". So, CTO came back to their companies and told their underlings, "I made a decision. We will be agile." The problem is that in most cases what that meant is that everyone who is at least five level below CTO should become agile. The problem is that it does not work that way. Either the whole organization is agile or none is. Otherwise, sooner or later you'll hit the ceiling that will prevent you from doing what needs to be done. When that happens, it will not matter that you renamed all your managers into scrum masters, and that your business analysts are now product owners. Having daily standups does not make an organization agile. Changing the culture of the whole company makes it agile and that often does not happen. So, you end up with a waterfall approach from the top of the pyramid that transforms itself into "agile" only at the very bottom. It's like taking an umbrella and walking towards the bottom of Niagara Falls muttering to yourself "So far so good. I just need to continue for awhile longer." It'll hit you hard.

Doing agile for the sake of having one more sticker that can be placed right next to your PMI certificate is not the way to go.

But, I'll assume that you are indeed agile and move on.

### Thou Shalt Refactor

Are you ready to refactor your code? If you're not, continuous delivery will not work. You will spend endless hours trying to automate tests of an application that is not designed to be testable. Then, once you're finally finished, you'll discover that tests are flaky and fail for random reasons. You'll also discover that tests execution lasts for hours instead minutes. If an application is to pass through continuous delivery pipeline every time someone makes a commit, that application needs to be designed with that in mind.

Then you start asking yourself why didn't you already refactor you application? Why did you let it rot for so long? While you might not know it, the answer is simple. Applications that do not have a good test coverage are too expensive to refactor. The risk is too high when any change to the code can have unforeseeable consequences. Applications with tests are by definition legacy applications. Lack of tests prevents us to improve our applications and they soon become legacy. The become something that should not be touched unless a new feature is to be added.

Even if you do gather courage to write tests for your application and then refactor it, you will soon discover that it is not worth it. Didn't you parents teach you not to touch rotten food? The same can be said for applications. Leave them be or rewrite them. Making something old behave like its young is a waste of time. That would be like putting lipstick on my grandmother. You might slightly improve her looks but you will not make her young again.

What you should have done from the very start is adopt continuous refactoring. We cannot allow ourselves to spend most of our time adding new features. No matter how much business like getting new features, such approach leads to unmaintainable code that will result in ever increasing costs and time required to develop something.

I will go as far as to say that if you are not spending at least one third of your coding time with refactoring, you are not doing a good job.

But, I'll assume that your code is modern, fast, and easy to maintain. I will assume that you already refactor it so that it is easy to build and test. Let's move on.

### Thou Shalt Educate Everyone

You decided to create a continuous delivery department. I can see fireworks through my window and hear you celebrating such a decision. What will that department do? Create CD pipelines for all the teams to use? Create an Uber pipeline that will work with any project in your company? Free the developers from having to learn how Jenkins works? You should get a medal for being such a good sport. You are helping other by freeing them from learning how to do all that and letting them continue coding their applications.

You probably learned the pattern. I write a paragraph explaining what many are doing only to conclude that it is wrong. Even though it's obvious I'm going to say it anyways. The existance of continuous delivery department is an abomination unless its goal is to create PoCs and educate others.

Letting others take care of your continuous delivery pipeline is wrong. They don't know what you're developing. You do. More importantly, if you cannot write the delivery pipeline yourself, you will not be able to design your application so that it is easy to write the pipeline. If you are responsible for the code of your application, you should be responsible for writing CD pipeline as well. It is code just as anything else and it belongs to the team responsible for the application.

Instead creating the Uber pipeline, spend your time educating the organization. Don't give them fish. Teach them how to fish.

### Thou Shalt Be Small

The is nothing continuous about big teams. Hoping that you will be able to continuously deliver code maintained by a huge number of people is optimistic at best. It cannot be done. You have to have a small team. That's one of the reasons why microservices are becoming so popular. A big team produces big code base. A lot of people sitting on top of a huge application is equivalent to a huge container ship. It floats and, given enough time, it reaches its destination. But, we do not have time. We want things to be delivered as soon as possible. The only reasonable way to accomplish that speed is by forming small teams that are fully in charge of a service (or two). Only then, we can have the speed. Each team can deliver features as soon as they are done without waiting for the rest of the company to wake up.

How big should the team be? It depends on a use case but, as a rule of thumb, no less then four and no more then ten people. Anything more than that is not a team anymore but a school reunion.

### Thou Shalt Practice TDD

TODO: Continue
