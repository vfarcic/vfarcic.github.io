## Software engineering should be...

Note:
Would you like to know what software engineering should be?


<iframe width="840" height="630" src="https://www.youtube.com/embed/jv2WJMVPQi8" data-autoplay></iframe>

Note:
Listen to this.


# That!

Note:
That is software engineering.
Or, to be more precise, that's what it should be.
There are instruments, there are notes, there are musicians,
  and there is a conductor.
Everything is in harmony, as long as we understand who should
  do what.
Unfortunately, more often than not, we do something very
  different.


## When I started my career I learned...

* ...Pascal
* ...to write code
* ...how to test it myself
* ...how to package it and deploy it myself
* ...how to install it and manage DBs
* ...fix my own mistakes

Note:
When I started my career, everything was very simple when
  compared with what we do today.
I learned Pascal.
I wrote code.
I learned how to test it myself.
I learned how to package it and deploy it myself.
When I needed a database, I learned how to install it and
  manage it myself.
When something went wrong, I learned how to fix it myself.


<!-- .slide: data-background-image="img/db-schema-git/one-man-band.png" data-background-size="cover" -->

Note:
I was a one-man-band.
I did it all.


<!-- .slide: data-background-image="img/db-schema-git/commodore.jpeg" data-background-size="cover" -->

Note:
That was over thirty years ago.
The world changed since then.
It changed a lot.


# Today?

* Backend developers
* Frontend developers
* Networking experts
* Virtualization experts
* Database admins
* Security experts
* ...

Note:
The systems got bigger and more complex.
As a matter of fact, soon after my humble beginnings, the
  systems became so complex that no single person could know
  everything there is to know to manage everything.
As a result, we started specializing.
Some of us became backend developers, while others specialized
  in frontend development.
Some became networking experts, while others learned everything
  there is to learn about virtualization.
We got security experts and we got database administrators.
You can think of those specializations being similar to those
  in an orchestra.
If we exclude Goofy, no single person can play all
  instruments at the same time.
We need a group of people, each playing a different instrument.


# (Almost) useless in isolation...

Note:
None of those instruments sound particularly good in isolation.

# ... but wonderful when played together

Note:
But, when all of them are played together in harmony, we get
  something wonderful.
We have a concert.


<!-- .slide: data-background-image="img/db-schema-git/concert.jpg" data-background-size="cover" -->

Note:
I always saw myself something of an orchestra conductor in
  software engineering.
Or, at least, that's what I wanted to be, but I couldn't.
There was often no orchestra.
You see, unlike music, software industry thought that each
  specialy should operate in isolation.
We would form a group of security experts and assign them a
  manager that would oversee their activities and define
  goals that are tightly related to security.
We did the same with testers, with infrastructure, with
  networking, with virtualization, with databases, and so on
  and so forth.
If I would continue with the analogy of an orchestra, there
  would be a conductor for violines, another one for drums,
  yet another one for thrombones, and so on and so forth.
Each of them would practice their own part, in isolation.
Then, when the night of the concert comes along, when they are
  supposed to deliver a symphony to those who paid tickets to
  listen to the concert...
... well, the end result would be a complete disaster.
An orchestra that does not perform together but, rather, has
  a bunch of smaller groups that play in isolation, can sound
  good only to deaf people.


<!-- .slide: data-background-image="img/db-schema-git/wall.png" data-background-size="cover" -->

Note:
Yet, that is percisely what we expect from software.
We expect different experts to work in isolation, and then to
  stich it all together at the very last moment, and hope for
  the best; hope that our customers will like it.
Think about that for a moment.


<!-- .slide: data-background-image="img/db-schema-git/anatomy.png" data-background-size="cover" -->

Note:
Try to forget everything you know and do, and think about that
  orchestra.
They need to work together, as one big organism, with each
  of them being an organ.
Just as a human body has specialized organs that fulfil their
  functions only within the context of the whole body, an
  orchestra is good only when all individuals perform in tendem
  with all others.
It's all about making music, and not random sounds coming from
  a instruments.


## Example:
# Database Administrators

Note:
Why don't we do the same in the software industry.
Do we need, for example, database administrators?
Yes we do.
Do we need them outside of application development teams?
Sometimes we do, but, more often than not, we don't.
So... Both yes and no.
They should be teams on their own, yet also integral parts of
  application teams.
I know...
That's confusing, so I'll explain that in a moment.
For now, let me stress that I will be using databases as an
  example which can be applied to any other specialized
  discipline in software engineering.


<!-- .slide: data-background-image="img/db-schema-git/violinist.jpg" data-background-size="cover" -->

Note:
Database administrator, or DBA, working alone or as a part of
  a specialized team is similar to a violinist that never
  practices with the rest of the band.
He's great.
He's the best.
He sounds great.
But he's not in tune with the rest of the band.
His music does not contibute to the music of the band.
He's a solo artist.
DBAs are similar when they work in isolation.
You can open a JIRA ticket asking for a database server, and
  you'll get it, eventually.
You might need a silly change to the database schema, and
  you'll get it, eventually.
You might need changes to the schema to be part of the delivery
  pipeline, but that might not happen since the pipeline
  is in the application repo and the schema is somewhere else.
You might need to go through hoops to get a similar database
  server and schema working in your local environment because
  ... it's somewhere else.
Management of the database is done by a different team
  and that team prefers keeping their stuff separate from your
  stuff.
Those are different bands, practicing in different rooms.


<!-- .slide: data-background-image="img/db-schema-git/concert.jpg" data-background-size="cover" -->

Note:
There is no harmony.
That is not the team.


<!-- .slide: data-background-image="img/db-schema-git/a-team.webp" data-background-size="cover" -->

Note:
That is not A-Team.
It's just a bunch of teams working in isolation and hoping
  that harmony will appear automagically.
A database belongs to an application.
That application cannot work without that database.
The team MUST include that database in everything it does.


# The team MUST own..

* ... app
* ... DB
* ... servers
* ... pipelines
* ... repo
* ...

Note:
The team MUST own the database, and the schema, and everything
  else related to that application.
Now, many will not agree with what I said.
There are many reasons why I'm wrong.
The complexities of managing databases are so big that only
  a dedicated team can handle it.
It's like a divine music that cannot be interrupted by other
  instruments.
That's wrong.
That's terribly wrong.
Great orchestras are about harmony that can be accomplished
  only through constant joined practice of the whole team.


# What is this?

```bash
cat silly-demo/app.yaml
```

Note:
Take a look at this.
Does that look like a user-facing definition of an application?
If you say yes, I believe you're wrong.
I believe that you, just as me, are in the Kubernetes bubble.
I think that you probably understand what all those things
  mean, but that very few in your company share the same
  understanding.


<!-- .slide: data-background-image="img/db-schema-git/material.jpg" data-background-size="cover" -->

Note:
That is not a definition of an application but, rather, a
  number of low-level resources that very few understand, and
  even fewer care about.
Let's get back to the orchestra.
Here's an important fact.
Musicians need instruments.
Without instruments, there is no orchestra.
Only specialized people can make instruments.
They are not made during orchestra's rehearsals.
They are made somewhere else and the process of making them
  does not depend on the music the orchestra is planning to
  play.
Instruments need to fullfil specific function.
They need to produce specific sounds through specific actions.
They need to fullfil the needs of their users, the musicians.
You can think of me as the one making those instruments.


# What is this?

```bash
gh repo view vfarcic/crossplane-sql --web
```


<!-- .slide: data-background-image="img/db-schema-git/material-2.jpg" data-background-size="cover" -->

Note:
Here's one that enables people to create and manage databases
  in AWS, Azure, and Google Cloud.
I'm using Crossplane Compositions for that but the story would
  be the same with other similar tools.
The important part is that those resources are not the
  instruments.
There is a VPC, a few subnets, a subnet group, a gateway,
  a route table, a route, route associations, security groups,
  RDS which is the database server itself, some configuration,
  the database that should be created in the server, another
  configuration, and a secret with the credentials.
That is not an instrument.
Those are raw materials.
Those are the things that most musicians do not care about.
They become instruments when they are assembled together which,
  in my case, happens when those resources wrapped into
  Compositions are packaged into Crossplane configurations and
  deployed to a cluster.


# What is this?

```bash
kubectl get compositions
```


<!-- .slide: data-background-image="img/db-schema-git/instruments.jpg" data-background-size="cover" -->

Note:
Those are the instruments.
Those are the violins.
One can choose the one that works the best in a given venue
  where the concert will be performed.
No matter which tools you choose, what matters is that you
  have to convert low-level resources into something meaningful
  to the end-users.
You need something similar to instruments and not material used
  to make them.
Now, every musician will tell you that instruments are not
  good out of the box.
They need to be fine-tuned to produce just the sound we want.


# What is this?

```bash
cat crossplane/sql-claim.yaml
```


<!-- .slide: data-background-image="img/db-schema-git/instrument-tuning.jpg" data-background-size="cover" -->

Note:
Over here, I'm declaring that I do not want just any database
  server.
I want it to be in AWS and I want it to be PostgreSQL.
It should be a specific version and the size should be
  bigger than small and smaller than big.
This is me being a musician and preparing for the concert.
This is me fine-tuning an instrument made by someone else.
This is me being a developer and using the service created by
  a database administrator.
This is me, a person who does not know nor care about all the
  gritty nitty details required to run a database, yet a person
  who wants to run a database.
This is how collaboration between different teams work.
Members of one team create services consumed by members of
  other teams.
In our world, making instruments is equivalent to making
  services.
It's the low-level work that ends up in the hands of the
  end-users.
Now we can truly separate one group from another.
Every team should provide a service to its customers.
If you're the team of DBAs, your service can be a way to
  manage databases, and database schemas, and whatever else
  you can provide.
Services are a way to convert your expert knowledge into
  something that can be used by others.
You are not playing in the band.
You are making instruments.
Now, if you can also play those instruments...
... oh boy.
That would be awesome.
That would allow you to join the band.


<!-- .slide: data-background-image="img/db-schema-git/kraftwerk.webp" data-background-size="cover" -->

Note:
That would make your band similar to Kraftwerk.
Not only that their music was amazing, but they also
  constructed quite a few instruments they used to make that
  music.
I just realized that referencing Kraftwerk probably means
  nothing to you and that it only proves that I am very old.
Moving on...
Instruments are not enough either.
We need to play those instruments.
We need notes.
We need a score.
In our industry, notes are equivalent to code and when I say
  code, I mean "something that can be interpreted by a
  machine".
That's the code of our applications.
That's the schema in our databases.
That's everything we write that makes the system feel like a
  symnphony.


# What is this?

```bash
cat atlas/schema.yaml
```


<!-- .slide: data-background-image="img/db-schema-git/notes.jpg" data-background-size="cover" -->

Note:
That schema can be considered a score.
Those are the notes.
We are not playing them just yet.
As a matter of fact, we, humans, might never play them.
We'll get to it in a moment...
By the way, that manifest is an Atlas schema.
Now, other "experts" will come back to you and tell you to
  forget all that.


<!-- .slide: data-background-image="img/db-schema-git/lock.jpg" data-background-size="cover" -->

Note:
What's the point of having an orchestra when you cannot open the
  door of the venue where you're supposed to be playing.
Security won't let you in.
You will never be able to access the concert hall or, in case
  of software, the production environment.
Well...
We don't have to.
That's why we have GitOps.
There is no need to get the key to the concert hall.
There is no need to be there physically.
We're streaming the concert and that stream is pulled into
  the concert hall.
Make a PR, review it, merge it to the mainline, and you're
  done.
Or, in my case, because I'm brave, I'll just push it directly
  to the mainline.


# What is this?

```bash
cp silly-demo/app.yaml crossplane/sql-claim.yaml \
    atlas/schema.yaml apps/.

git add .

git commit -m "Not touching the system"

git push
```


<!-- .slide: data-background-image="img/db-schema-git/open-gitops.png" data-background-size="cover" -->

Note:
So, here it goes.
I'll copy the files we discussed to the `apps` directory.
That is the directory that Argo CD is monitoring.
Then I'll add, commit, and push the changes.
And that's it.


# The concert can start?

Note:
The concert can start.
Right?
We'll, we're missing one key persona.
We need a conductor.


<!-- .slide: data-background-image="img/db-schema-git/conductor.jpg" data-background-size="cover" -->

Note:
We need a person that will coordinate all the musicians.
We need someone, or something, that will make sure that the
  concert starts at the right time, that the right instruments
  are playing, that the tempo is just right, and so on and so
  forth.
Now we're getting back to the previous comment when I claimed
  that we "might never play the instruments".
That's the job of machines.
Our instruments are processes running on servers.
We, humans, construct the instruments.
We fine tune them, and we write the notes.
But the actual playing is done by machines.
Not only that, but the conductor is also a machine.
Today, that conductor is Kubernetes.


<!-- .slide: data-background-image="../img/products/kubernetes.png" data-background-size="contain" -->

Note:
It's job is to orchestrate everything.
It decides what to play and where to play it.
We call it orchestration.
It might decide to bring in more violins, and to remove some
  drums.
That's what we call scaling.
It's in charge of all the musicians...
...of all the processes.


<!-- .slide: data-background-image="img/db-schema-git/instruments.jpg" data-background-size="cover" -->
```bash
kubectl --namespace production \
    get deployments,sqlclaims,atlasschemas
```

Note:
Those are the instruments.


<!-- .slide: data-background-image="img/db-schema-git/material.jpg" data-background-size="cover" -->
```bash
kubectl --namespace production \
    get replicasets,pods,services,managed
```

Note:
Those are the components that constitute those instruments.


<!-- .slide: data-background-image="img/db-schema-git/conductor.jpg" data-background-size="cover" -->
```bash
kubectl version --output yaml
```

Note:
That's the conductor...


<!-- .slide: data-background-image="img/db-schema-git/concert-hall.jpg" data-background-size="cover" -->
```bash
kubectl get nodes
```

Note:
... and those are the rooms of the concert hall.


<!-- .slide: data-background-image="img/db-schema-git/concert.jpg" data-background-size="cover" -->

Note:
All in all, experts in different fields should construct
  instruments.
Those are the services that enable others to do their job.
They can be services that enable database management,
  application management, cluster management, or anything else.
Application developers are those who fine-tune instruments by
  defining instances of those services.
They are also the ones who compose symphonies by writing code,
  or schemas, or whatever else is needed to make the system
  behave in a certain way.
Machines are acting as musicians.
They are playing the notes on the instruments.
Finally, Kubernetes is the conductor.
It is making sure that everything is in harmony.
