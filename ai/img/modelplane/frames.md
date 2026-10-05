# Diagram frame sources

The supplied videos are retained unchanged. The slide images are 1920x1080 PNGs
extracted at settled build states rather than adjacent animation frames.

| Image | Source | Time | State |
| --- | --- | --- | --- |
| diag-13-01.png | diag-13.mp4 | 0.85s | Control plane |
| diag-13-02.png | diag-13.mp4 | 1.65s | Hardware recipes |
| diag-13-03.png | diag-13.mp4 | 3.40s | Three clusters |
| diag-13-04.png | diag-13.mp4 | 3.85s | GPU pools and serving stacks |
| diag-13-05.png | diag-13.mp4 | 5.80s | Fleet status feedback |
| diag-14-01.png | diag-14.mp4 | 0.85s | Developer |
| diag-14-02.png | diag-14.mp4 | 3.00s | Scheduler and placed replicas |
| diag-14-03.png | diag-14.mp4 | 3.65s | Gateway and incoming request, no outgoing routes |
| diag-14-04.png | diag-14.mp4 | 4.45s | Complete outgoing routes, no response |
| diag-14-05.png | diag-14.mp4 | 6.20s | Complete response path |

Label corrections in the extracted images:

- "Zone 1/2/3" becomes "Cluster 1/2/3", matching the fleet-level architecture.
- "Control-plane gateway" becomes "Inference gateway". The current gateway runs
  on an InferenceCluster, not the local control cluster.

The fleet sequence (diag-13) appears immediately after model apply in
modelplane-demo.md, while the model starts. The placement/request/response
sequence (diag-14) follows curl as an explanation of the loop just demonstrated.
