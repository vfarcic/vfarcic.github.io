**Q:** As DevOps teams mature, how will they change and evolve over time?

**A:** Generally speaking, there are two types of DevOps teams.

The first group is teams that are usually in charge of operations or continuous delivery. They are currently the majority. They renamed themselves from "operations department" to "DevOps department". They renamed their job titles from "sysadmin" to "DevOps engineer". They are deploying services developed by other teams. They are writing continuous delivery pipelines that will be used by other teams. They are experimenting with schedulers like Docker Swarm and Kubernetes. Most importantly, they are riding the popular wave and, at the same time, they misunderstood the ideas behind DevOps. They are faking it by doing, more or less, the same as they did before, but with a DevOps sticker attached to it.

The other group is relatively small. Those are often agile teams that decided to bring operations knowledge inside. The scope of what they do increased and now they are capable of performing the whole process; from gathering requirements all the way until deploying to production and monitoring. Those are small (up to 10 people) and multi-functional teams. They understood well what DevOps means and embraced it. Everyone in those teams is a coder, and most have very broad knowledge even if they are highly specialized in a certain area. Percentage-wise, they are the minority. Most companies did not go down that route. Most companies misunderstood the message behind DevOps.

I hope that the true DevOps message will get through and that the second group will prevail. However, I'm afraid that DevOps commercialization will continue in the same direction, and that DevOps will face a similar fate like EBS. We had to invent a new name for it (microservices) because the message behind EBS got so perverted that it went into a completely different direction. I'm afraid that DevOps might face a similar fate and that the first group might become dominant.

**Q:** What will be the next trend for job titles, roles and responsibilities on DevOps teams? (For example, will the title DevOps Engineer continue or be refined?)

**A:** The "DevOps engineer" title will continue being popular for as long as DevOps is popular. The problem is that it is a complete misunderstanding of the principles behind DevOps. It forgets that the change is cultural, not technological. It allows (mostly consulting) companies to reinvent themselves without changing anything and, at the same time, to increase their earnings. Being a DevOps engineer is the same as being an Agile engineer. Neither of those should exist with the difference that Agile processes like Scrum prescribed names for different roles, so no one came up with something like "Agile engineer". Since DevOps is less prescriptive, it produced more confusion about its nature and resulted in invented and meaningful job titles as DevOps engineer.

DevOps is a cultural change where everyone is a coder no matter their specialty (including operations). It is an attempt to bring operations knowledge into small and multi-functional teams. It is about enabling those teams to be in charge of the whole process, from requirement all the way until deployment to production. It is about a single team being in full control of a service they're in charge of (including deployment to production and pager duty).

**Q:** What will be new/evolving/next in terms of processes and methodologies?

**A:** There haven't been much, if any, movement in that direction. There are no prescribed DevOps processes nor methodologies. The movement did not go towards that direction. There is no Scrum or eXtreme Programming equivalent with DevOps. It's all about bringing operations knowledge to multi-functional development teams. It is an attempt to make those teams self-sufficient. It's an acknowledgment that there is no space in our industry for people who are not coders.

**Q:** What will be new/next in terms of tooling and technology?

**A:** Containers already become mainstream but proved not to be enough by themselves. Schedulers (e.g., Docker Swarm, Kubernetes, etc.) will continue evolving. They will continue dominating the scene in 2018.

We will soon see the rise of Unikernels as replacements for traditional operating systems and, maybe, even replacement for containers as well.

The industry will start accepting that configuration management and provisioning tools like Chef, Puppet, and Ansible are obsolete and based on pre-cloud era. The next generation of processes based on immutable infrastructure will become mainstream with Packer and Terraform continuing to dominate that space.

Serverless will start moving away from the solutions designed with vendor-locking as the primary objective. We'll see more and more solutions that are hosting-vendor agnostic. Most of them will probably be based on containers like OpenFaaS.

Many widely accepted solutions will disappear overnight or be replaced with cloud-first services capable of working in highly dynamic environments.
