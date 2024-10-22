// TODO
void default_start() {
  /* printf("External data : '%s'\n", eadk_external_data); */
  /* eadk_timing_msleep(3000); */
  /* draw_random_colorful_rectangles(); */
  /* draw_random_buffer(); */
  /* eadk_display_draw_string("Hello, world!", (eadk_point_t){0, 0}, true, eadk_color_black, eadk_color_white); */
  /* move_pointer(); */
}

void __start(void) __attribute((weak, alias("default_start")));
