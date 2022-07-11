(** on allume/éteint si on appuie en même temps sur + et - **)
let%node thermo_on (p,m) ~return:(b) =
  b = (true >>> if p && m then not b else b)

(** modification de la température désirée selon le bouton appuyé **)
let%node set_wanted_temp (p,m) ~return:(w) =
  w = (325 >>> if p then w+5 else if m then w-5 else w)

(** noeud principal : calcul de la température désirée et de l'état de la résistance **)
(** Les températures sont en dixièmes de degrés C **)
let%node thermo (plus,minus,real_temp) ~return:(on,wanted,real,resistor) =
  on = thermo_on (plus,minus);
  wanted = set_wanted_temp (plus[@when on], minus[@when on]);
  real = real_temp [@when on];
  heat = (real < wanted);
  resistor = merge on heat false
