let _ =
  while true do
    lchip_digital_write_rled HIGH;
    lchip_digital_write_lled HIGH;
    delay(1000); 
    lchip_digital_write_rled LOW;
    lchip_digital_write_lled LOW;
    delay(1000);
  done
