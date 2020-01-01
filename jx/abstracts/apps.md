# Strategies For Managing Third-Party Applications (In Kubernetes And With Jenkins X)

## Short Abstract

We'll explore different types of third-party applications (e.g., exclusive and non-exclusive dependencies, system-wide apps, testable and non-testable components, etc.). Once we understand different kinds of apps, we'll realize that the approaches how to manage them will differ. As a result, the strategies for installing and maintaining such applications might vary as well.

Should we install third-party applications using commands or store their definitions in a declarative format? If we choose the latter, where should those definitions reside? What should trigger a change of any of them, and which process should converge the actual into the desired state? Those are only a few questions we'll try to answer in the hope of defining a set of guidelines that anyone can use when deciding on a strategy for installing and managing a third-party application.

## Abstract

Your Kubernetes cluster is bound to have quite a few third-party applications. The applications you're developing need a database. Your monitoring solution might rely on Prometheus. Your networking might be based on Istio. You might need Knative to make your applications serverless. The question that arises is how to manage all those and many other third-party applications.

We'll explore different types of third-party applications (e.g., exclusive and non-exclusive dependencies, system-wide apps, testable and non-testable components, etc.). Once we understand different kinds of apps, we'll realize that the approaches how to manage them will differ. As a result, the strategies for installing and maintaining such applications might vary as well.

Should we install third-party applications using commands or store their definitions in a declarative format? If we choose the latter, where should those definitions reside? What should trigger a change of any of them, and which process should converge the actual into the desired state? Those are only a few questions we'll try to answer in the hope of defining a set of guidelines that anyone can use when deciding on a strategy for installing and managing a third-party application.

