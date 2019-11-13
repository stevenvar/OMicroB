open Pic32

let _ =
  let r = PIN78 in
  let p = PIN82 in
  pin_mode r OUTPUT;
  pin_mode p OUTPUT;
  digital_write r HIGH;
  digital_write p HIGH;
delay 2500;
digital_write r LOW;
digital_write p LOW;
  (*   delay 2500;
 *     digital_write r LOW;
 *     digital_write p LOW;
 *     delay 2500;
 * done *)
  (*  while true do
   *   lchip_digital_write_lled HIGH;
   *   lchip_digital_write_rled HIGH;
   *   delay 2500;
   *   lchip_digital_write_lled LOW;
   *   lchip_digital_write_rled LOW;
   *   delay 2500;
   * done *)
