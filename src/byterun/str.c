
mlsize_t caml_string_length(val_t s)
{
  mlsize_t temp;
  temp = Bosize_val(s) - 1;
  /* CAMLassert (Byte (s, temp - Byte (s, temp)) == 0); */
  return temp  - StringField(s, temp);
}

val_t caml_string_equal(val_t s1, val_t s2){
  mlsize_t sz1, sz2;
  val_t * p1, * p2;
  if (s1 == s2) return Val_true;
  sz1 = Wosize_val(s1);
  sz2 = Wosize_val(s2);
  if (sz1 != sz2) return Val_false;
  for(p1 = &Field(s1,0), p2 = &Field(s2,0); sz1 > 0; sz1--, p1++, p2++)
    if (*p1 != *p2) return Val_false;
  return Val_true;
}
