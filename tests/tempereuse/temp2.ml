
let%node min(a,b) ~return:c =
  c = if a < b then a else b

let%node max(a,b) ~return:c =
  c = if a > b then a else b

(** calcul de la proportion de chauffe (en %) **)
let%node update_prop (wtemp,ctemp) ~return:(prop) =
  delta = min (10,max (-10,wtemp-ctemp));
  delta2 = if delta < 0 then (-delta * delta) else (delta*delta);
  offset = min (10,delta2);
  pre_prop = (0 >>> prop);
  prop = min (100,max (0, (pre_prop+offset)))

let%node timer (number) ~return:(alarm) =
  time = (0 >>> (time + 10)) mod 100;
  alarm = if (time < number) then true else false

let%node heat (w,c) ~return:(h) =
  count = (0 >>> count + 1) mod 10;
  update = (count = 0);
  (* le rapport cyclique (prop) est mis à jour tous les 10 instants *)
  prop = merge update
            (update_prop (w [@when update],c [@when update]))
            ((0 >>> prop) [@whennot update]);
  h = timer (prop)

(** on allume/éteint si on appuie en même temps sur + et - **)
let%node thermo_on(p,m) ~return:(b) =
  b = (true >>> if p && m then (not b) else b)

(** modification de la température désirée selon le bouton appuyé **)
let%node set_wanted_temp (p,m) ~return:(w) =
  w = (325 >>> if p then w+5 else if m then w-5 else w)

(** noeud principal : calcul de la température désirée et de l'état de la résistance **)
(** Les températures sont en dixièmes de degrés celsius **)
let%node thermo (plus,minus,real_temp) ~return:(on,wanted,real,resistor) =
  on = thermo_on (plus,minus);
  wanted = set_wanted_temp (plus[@when on], minus[@when on]);
  real = real_temp [@when on];
  heat = heat (wanted,real);
  resistor = merge on heat false
