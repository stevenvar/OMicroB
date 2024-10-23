#include <stddef.h>
#include <stdint.h>

const char eadk_app_name[] __attribute__((section(".rodata.eadk_app_name"))) = "OMicroB";
const uint32_t eadk_api_level  __attribute__((section(".rodata.eadk_api_level"))) = 0;

extern int main(int, char**);

void default_start() {
  main(0, NULL); // Run the VM
  /* printf("External data : '%s'\n", eadk_external_data); */
  /* eadk_timing_msleep(3000); */
  /* draw_random_colorful_rectangles(); */
  /* draw_random_buffer(); */
  /* eadk_display_draw_string("Hello, world!", (eadk_point_t){0, 0}, true, eadk_color_black, eadk_color_white); */
  /* move_pointer(); */
}

void __start(void) __attribute((weak, alias("default_start")));
