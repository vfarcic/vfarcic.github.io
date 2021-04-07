# Developers do not need Kubernetes

Since the emergence of Kubernetes, we hoped that developers will adopt it. That did not happen, and it will likely never happen. Developers do not need Kubernetes. They need to write code and they need an easy way to build, test, and deploy their applications. It is unrealistic to expect developers to spend years learning Kubernetes.

On the other hand, operators and sys admins need Kubernetes. It gives them all they need to run systems at scale. Nevertheless, oeprators also need to empower developers to deploy their own applications. They need to empower developers by providing services, rather then doing actual deployments.

So, we have conflicting needs. Kubernetes is necessary to some and burden to others. Can we satisfy all? Can we have a system that is based on Kubernetes yet easy to operate? Can we make Kubernetes dissapear and become an implementation detail running in the background?

Let's discuss where Kubernetes is going and how it might look like in the future.