import {makeScene2D, Rect, Txt, Line, Icon, Node} from '@motion-canvas/2d';
import {all, createRef, waitFor} from '@motion-canvas/core';

export default makeScene2D(function* (view) {
  view.fill('#000000'); // black from frame 0

  const YELLOW = '#fbbf24';
  const lbl = (text: string, size = 30, color = '#ffffff', weight = 600) => (
    <Txt text={text} fill={color} fontSize={size} fontWeight={weight} fontFamily="sans-serif" />
  );

  // ---------- coordinates ----------
  const MROW = -30;
  const YOU = [-870, MROW];
  const AGENTS = [-660, MROW];
  const GIT = [-450, MROW];
  const CLOUD = [820, MROW];
  const GPU = [820, 200];
  const BOX_X = 150, BOX_Y = 20, BOX_W = 720, BOX_H = 560;
  const ARGO = [-70, MROW];
  const KYV = [150, MROW];
  const XP = [370, MROW];
  const MODEL = [370, 200];

  // ---------- refs ----------
  const you = createRef<Node>(), agents = createRef<Node>(), git = createRef<Node>();
  const cloud = createRef<Node>(), gpu = createRef<Node>();
  const cluster = createRef<Rect>();
  const xp = createRef<Node>(), argo = createRef<Node>(), kyverno = createRef<Node>(), model = createRef<Node>();

  const aYouCloud = createRef<Line>(), aYouAgents = createRef<Line>();
  const aAgentsCloud = createRef<Line>(), aAgentsXP = createRef<Line>();
  const aAgentsGit = createRef<Line>(), aGitArgo = createRef<Line>();
  const aArgoXP = createRef<Line>(), aArgoKyv = createRef<Line>(), aKyvXP = createRef<Line>();
  const aXPCloud = createRef<Line>(), aXPModel = createRef<Line>(), aModelGpu = createRef<Line>();

  const arrow = (ref: any, pts: number[][]) =>
    view.add(<Line ref={ref} points={pts} stroke={YELLOW} lineWidth={5} endArrow arrowSize={16} opacity={0} />);

  // ---------- Control Plane box (bottom layer) ----------
  view.add(
    <Rect ref={cluster} x={BOX_X} y={BOX_Y} width={BOX_W} height={BOX_H} fill="#1a1a2e" stroke="#3b82f6" lineWidth={4} radius={20} opacity={0}>
      <Node y={-230}>{lbl('Control Plane', 34, '#ffffff', 700)}</Node>
    </Rect>
  );

  // ---------- arrows (on top of box fill, behind nodes) ----------
  arrow(aYouCloud, [[-790, MROW], [730, MROW]]);
  arrow(aYouAgents, [[-790, MROW], [-750, MROW]]);
  arrow(aAgentsCloud, [[-570, MROW], [730, MROW]]);
  arrow(aAgentsXP, [[-570, MROW], [300, MROW]]);
  arrow(aAgentsGit, [[-570, MROW], [-520, MROW]]);
  arrow(aGitArgo, [[-140, MROW], [-380, MROW]]); // Argo CD -> Git (pull)
  arrow(aArgoXP, [[-5, MROW], [300, MROW]]);
  arrow(aArgoKyv, [[-5, MROW], [90, MROW]]);
  arrow(aKyvXP, [[210, MROW], [300, MROW]]);
  arrow(aXPCloud, [[440, MROW], [730, MROW]]);
  arrow(aXPModel, [[XP[0], 62], [MODEL[0], 112]]);
  arrow(aModelGpu, [[440, MODEL[1]], [750, GPU[1]]]);

  // ---------- nodes (top layer) ----------
  view.add(
    <Node ref={you} x={YOU[0]} y={YOU[1]} opacity={0}>
      <Icon icon="mdi:account" size={110} color="#22c55e" y={-34} />
      <Node y={62}>{lbl('You', 32)}</Node>
    </Node>
  );
  view.add(
    <Node ref={agents} x={AGENTS[0]} y={AGENTS[1]} opacity={0}>
      <Icon icon="mdi:robot" size={80} color="#a78bfa" x={-44} y={-50} />
      <Icon icon="mdi:robot" size={80} color="#a78bfa" x={40} y={-58} />
      <Icon icon="mdi:robot" size={80} color="#a78bfa" x={-4} y={-18} />
      <Node y={62}>{lbl('Agents', 32)}</Node>
    </Node>
  );
  view.add(
    <Node ref={git} x={GIT[0]} y={GIT[1]} opacity={0}>
      <Icon icon="mdi:git" size={110} color="#f97316" y={-34} />
      <Node y={62}>{lbl('Git', 32)}</Node>
    </Node>
  );
  view.add(
    <Node ref={argo} x={ARGO[0]} y={ARGO[1]} opacity={0}>
      <Icon icon="devicon:argocd" size={100} y={-34} />
      <Node y={62}>{lbl('Argo CD', 30)}</Node>
    </Node>
  );
  view.add(
    <Node ref={kyverno} x={KYV[0]} y={KYV[1]} opacity={0}>
      <Icon icon="mdi:shield-check" size={100} color="#06b6d4" y={-34} />
      <Node y={62}>{lbl('Kyverno', 30)}</Node>
    </Node>
  );
  view.add(
    <Node ref={xp} x={XP[0]} y={XP[1]} opacity={0}>
      <Icon icon="logos:crossplane-icon" height={78} y={-34} />
      <Node y={62}>{lbl('Crossplane', 30)}</Node>
    </Node>
  );
  view.add(
    <Node ref={model} x={MODEL[0]} y={MODEL[1]} opacity={0}>
      <Icon icon="mdi:brain" size={100} color="#a78bfa" y={-34} />
      <Node y={62}>{lbl('Modelplane', 30)}</Node>
    </Node>
  );
  view.add(
    <Node ref={cloud} x={CLOUD[0]} y={CLOUD[1]} opacity={0}>
      <Icon icon="mdi:cloud" size={120} color="#06b6d4" y={-34} />
      <Node y={58}>{lbl('Cloud', 32)}</Node>
      <Node y={98}>{lbl('AWS / GCP / Azure', 20, '#9ca3af', 400)}</Node>
    </Node>
  );
  view.add(
    <Node ref={gpu} x={GPU[0]} y={GPU[1]} opacity={0}>
      <Icon icon="mdi:memory" size={100} color="#f97316" y={-34} />
      <Node y={62}>{lbl('GPU fleet', 30)}</Node>
    </Node>
  );

  // ================= beats =================

  // BEAT 1 — You -> Cloud
  yield* you().opacity(1, 0.5);
  yield* cloud().opacity(1, 0.5);
  yield* aYouCloud().opacity(1, 0.5);
  yield* waitFor(1.6);

  // BEAT 2 — insert Agents (swarm)
  yield* aYouCloud().opacity(0, 0.4);
  yield* agents().opacity(1, 0.5);
  yield* all(aYouAgents().opacity(1, 0.4), aAgentsCloud().opacity(1, 0.4));
  yield* waitFor(1.6);

  // BEAT 3 — Control Plane + Crossplane (Agents apply directly)
  yield* aAgentsCloud().opacity(0, 0.4);
  yield* cluster().opacity(1, 0.5);
  yield* xp().opacity(1, 0.5);
  yield* all(aAgentsXP().opacity(1, 0.4), aXPCloud().opacity(1, 0.4));
  yield* waitFor(1.6);

  // BEAT 4 — Git + Argo CD (Agents -> Git; Argo pulls Git; Argo -> Crossplane)
  yield* aAgentsXP().opacity(0, 0.4);
  yield* all(git().opacity(1, 0.5), argo().opacity(1, 0.5));
  yield* all(aAgentsGit().opacity(1, 0.4), aGitArgo().opacity(1, 0.4), aArgoXP().opacity(1, 0.4));
  yield* waitFor(1.6);

  // BEAT 5 — Kyverno (gate between Argo and Crossplane)
  yield* aArgoXP().opacity(0, 0.4);
  yield* kyverno().opacity(1, 0.5);
  yield* all(aArgoKyv().opacity(1, 0.4), aKyvXP().opacity(1, 0.4));
  yield* waitFor(1.6);

  // BEAT 6 — Modelplane + GPU fleet (inference)
  yield* all(model().opacity(1, 0.5), aXPModel().opacity(1, 0.4));
  yield* all(gpu().opacity(1, 0.5), aModelGpu().opacity(1, 0.4));
  yield* waitFor(2.2);
});
