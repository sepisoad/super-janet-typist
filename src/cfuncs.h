#include <raylib.h>
#include "janet.h"

//==============================================================================

JanetAbstractType jt_image = // TODO: handle image memory deletion
    {"jt/image", NULL, NULL, NULL, NULL, NULL, NULL, NULL};

JanetAbstractType jt_texture2d = // TODO: handle texture memory deletion
    {"jt/texture2d", NULL, NULL, NULL, NULL, NULL, NULL, NULL};

JanetAbstractType jt_font = // TODO: handle font memory deletion
    {"jt/font", NULL, NULL, NULL, NULL, NULL, NULL, NULL};

//==============================================================================

static Janet c_screen_start(int32_t argc, Janet *argv) {
  janet_fixarity(argc, 1);

  JanetTable *config = janet_gettable(argv, 0);
  int window_width =
    janet_unwrap_integer(
      janet_table_get(config, 
        janet_ckeywordv("window-width")));
  
  int window_height =
    janet_unwrap_integer(
      janet_table_get(config, 
        janet_ckeywordv("window-height")));

  int frames_per_second =
    janet_unwrap_integer(
      janet_table_get(config, 
        janet_ckeywordv("frames-per-second")));        

  const uint8_t *window_title = 
    janet_unwrap_string(
      janet_table_get(config, 
        janet_ckeywordv("window-title")));                
  
  bool is_fullscreen = 
    janet_unwrap_boolean(
      janet_table_get(config, 
        janet_ckeywordv("is-fullscreen?")));
  
  InitWindow(window_width, window_height, (const char *)window_title);
  
  if (is_fullscreen) {
    ToggleFullscreen(); 
  }

  SetTargetFPS(frames_per_second);
  SetExitKey(KEY_F10);  

  return janet_wrap_true();
}

//==============================================================================

static Janet c_screen_end(int32_t argc, Janet *argv) {  
  janet_fixarity(argc, 0);
  CloseWindow();
  return janet_wrap_true();
}

//==============================================================================

static Janet c_begin_draw(int32_t argc, Janet *argv) {  
  janet_fixarity(argc, 0);
  BeginDrawing();
  ClearBackground(BLACK); // TODO: harcoded!!!
  // DrawFPS(10, 10);
  return janet_wrap_nil();
}

//==============================================================================

static Janet c_end_draw(int32_t argc, Janet *argv) {  
  janet_fixarity(argc, 0);
  EndDrawing();     
  return janet_wrap_nil();
}

//==============================================================================

static Janet c_get_time(int32_t argc, Janet *argv) {  
  janet_fixarity(argc, 0);  
  return janet_wrap_number(GetTime());
}

//==============================================================================

static Janet c_draw_text(int32_t argc, Janet *argv) {  
  janet_fixarity(argc, 7);
  
  Font *font = (Font *) janet_getabstract(argv, 0, &jt_font);
  const char *text = janet_getcstring(argv, 1);
  int x = janet_getinteger(argv, 2);
  int y = janet_getinteger(argv, 3);
  double size = janet_getnumber(argv, 4);
  double spacing = janet_getnumber(argv, 5);
  const JanetKV *color_kv = janet_getstruct(argv, 6);
  Color color = (Color) {
    .r = janet_unwrap_integer(janet_struct_get(color_kv, janet_ckeywordv("r"))),
    .g = janet_unwrap_integer(janet_struct_get(color_kv, janet_ckeywordv("g"))),
    .b = janet_unwrap_integer(janet_struct_get(color_kv, janet_ckeywordv("b"))),
    .a = janet_unwrap_integer(janet_struct_get(color_kv, janet_ckeywordv("a"))),
  };
  
  DrawTextEx(*font, text, (Vector2){.x=x,.y=y}, size, spacing, color);
  return janet_wrap_nil();
}

//==============================================================================

static Janet c_draw_texture(int32_t argc, Janet *argv) {  
  janet_fixarity(argc, 4);
  
  Texture2D *texture = (Texture2D*) janet_getabstract(argv, 0, &jt_texture2d);  
  int x = janet_getinteger(argv, 1);
  int y = janet_getinteger(argv, 2);  
  const JanetKV *color_kv = janet_getstruct(argv, 3);
  Color color = (Color) {
    .r = janet_unwrap_integer(janet_struct_get(color_kv, janet_ckeywordv("r"))),
    .g = janet_unwrap_integer(janet_struct_get(color_kv, janet_ckeywordv("g"))),
    .b = janet_unwrap_integer(janet_struct_get(color_kv, janet_ckeywordv("b"))),
    .a = janet_unwrap_integer(janet_struct_get(color_kv, janet_ckeywordv("a"))),
  };
  
  DrawTexture(
    *texture, 
    x,
    y,
    color);
  return janet_wrap_nil();
}

//==============================================================================

static Janet c_draw_sprite(int32_t argc, Janet *argv) {  
  janet_fixarity(argc, 3);
  
  Texture2D *texture = (Texture2D*) janet_getabstract(argv, 0, &jt_texture2d);  
  const JanetKV *jrect = janet_getstruct(argv, 1);
  const JanetKV *jpos = janet_getstruct(argv, 2);

  Rectangle rect = (Rectangle) {
    .x = janet_unwrap_integer(janet_struct_get(jrect, janet_ckeywordv("x"))),
    .y = janet_unwrap_integer(janet_struct_get(jrect, janet_ckeywordv("y"))),
    .width = janet_unwrap_integer(janet_struct_get(jrect, janet_ckeywordv("w"))),
    .height = janet_unwrap_integer(janet_struct_get(jrect, janet_ckeywordv("h")))
  };

  Vector2 pos = (Vector2) {
    .x = janet_unwrap_integer(janet_struct_get(jpos, janet_ckeywordv("x"))),
    .y = janet_unwrap_integer(janet_struct_get(jpos, janet_ckeywordv("y"))),
  };
  
  DrawTextureRec(
    *texture, 
    rect,
    pos,
    LIGHTGRAY);
  return janet_wrap_nil();
}

//==============================================================================

static Janet c_draw_pixel(int32_t argc, Janet *argv) {
  janet_fixarity(argc, 2);

  int x = janet_getinteger(argv, 0);
  int y = janet_getinteger(argv, 1);

  DrawPixel(x, y, WHITE);
  return janet_wrap_nil();
}

//==============================================================================

static Janet c_draw_rect(int32_t argc, Janet *argv) {
  janet_fixarity(argc, 5);

  int x = janet_getinteger(argv, 0);
  int y = janet_getinteger(argv, 1);
  int w = janet_getinteger(argv, 2);
  int h = janet_getinteger(argv, 3);

  const JanetKV *color_kv = janet_getstruct(argv, 4);
  Color color = (Color) {
    .r = janet_unwrap_integer(janet_struct_get(color_kv, janet_ckeywordv("r"))),
    .g = janet_unwrap_integer(janet_struct_get(color_kv, janet_ckeywordv("g"))),
    .b = janet_unwrap_integer(janet_struct_get(color_kv, janet_ckeywordv("b"))),
    .a = janet_unwrap_integer(janet_struct_get(color_kv, janet_ckeywordv("a"))),
  };

  DrawRectangle(x, y, w, h, color);
  return janet_wrap_nil();
}

//==============================================================================

static Janet c_draw_rect_lines(int32_t argc, Janet *argv) {
  janet_fixarity(argc, 5);

  int x = janet_getinteger(argv, 0);
  int y = janet_getinteger(argv, 1);
  int w = janet_getinteger(argv, 2);
  int h = janet_getinteger(argv, 3);

  const JanetKV *color_kv = janet_getstruct(argv, 4);
  Color color = (Color) {
    .r = janet_unwrap_integer(janet_struct_get(color_kv, janet_ckeywordv("r"))),
    .g = janet_unwrap_integer(janet_struct_get(color_kv, janet_ckeywordv("g"))),
    .b = janet_unwrap_integer(janet_struct_get(color_kv, janet_ckeywordv("b"))),
    .a = janet_unwrap_integer(janet_struct_get(color_kv, janet_ckeywordv("a"))),
  };

  DrawRectangleLines(x, y, w, h, color);
  return janet_wrap_nil();
}

//==============================================================================

static Janet c_load_image(int32_t argc, Janet *argv) {    
  janet_fixarity(argc, 1);

  const char *path = janet_getcstring(argv, 0);
  Image *image = janet_abstract(&jt_image, sizeof(Image));
  *image = LoadImage(path);
  return janet_wrap_abstract(image);
}

//==============================================================================

static Janet c_load_texture(int32_t argc, Janet *argv) {    
  janet_fixarity(argc, 1);

  const char *path = janet_getcstring(argv, 0);
  Texture2D *texture = janet_abstract(&jt_texture2d, sizeof(Texture2D));
  *texture = LoadTexture(path);
  return janet_wrap_abstract(texture);
}

//==============================================================================

static Janet c_load_sprite(int32_t argc, Janet *argv) {    
  janet_fixarity(argc, 1);

  const char *path = janet_getcstring(argv, 0);

  Image image = LoadImage(path);
  Texture2D *texture = janet_abstract(&jt_texture2d, sizeof(Texture2D));
  *texture = LoadTextureFromImage(image);
  return janet_wrap_abstract(texture);
}

//==============================================================================

static Janet c_is_key_pressed(int32_t argc, Janet *argv) {    
  janet_fixarity(argc, 1);

  int key = janet_getinteger(argv, 0);
  return janet_wrap_boolean(IsKeyPressed(key));
}

//==============================================================================

static Janet c_is_key_down(int32_t argc, Janet *argv) {    
  janet_fixarity(argc, 1);

  int key = janet_getinteger(argv, 0);
  return janet_wrap_boolean(IsKeyDown(key));
}

//==============================================================================

static Janet c_is_key_released(int32_t argc, Janet *argv) {    
  janet_fixarity(argc, 1);

  int key = janet_getinteger(argv, 0);
  return janet_wrap_boolean(IsKeyReleased(key));
}

//==============================================================================

static Janet c_is_key_up(int32_t argc, Janet *argv) {    
  janet_fixarity(argc, 1);

  int key = janet_getinteger(argv, 0);
  return janet_wrap_boolean(IsKeyUp(key));
}

//==============================================================================

static Janet c_get_key_pressed(int32_t argc, Janet *argv) {    
  janet_fixarity(argc, 0);
  return janet_wrap_integer(GetKeyPressed());
}

//==============================================================================

static Janet c_load_font(int32_t argc, Janet *argv) {    
  janet_fixarity(argc, 2);

  const char *path = janet_getcstring(argv, 0);
  const int size = janet_getinteger(argv, 1);

  Font *font = janet_abstract(&jt_font, sizeof(Font));
  *font = LoadFontEx(path, size, 0, 0);
  return janet_wrap_abstract(font);
}   

//==============================================================================

static Janet c_text_size(int32_t argc, Janet *argv) {    
  janet_fixarity(argc, 4);

  Font *font = (Font *) janet_getabstract(argv, 0, &jt_font);
  const char *text = janet_getcstring(argv, 1);
  int size = janet_getinteger(argv, 2);
  int spacing = janet_getinteger(argv, 3);

  Vector2 vec = MeasureTextEx(*font, text, size, spacing);
  JanetKV *jvec = janet_struct_begin(2);
  janet_struct_put(jvec, janet_ckeywordv("x"), janet_wrap_integer(vec.x));
  janet_struct_put(jvec, janet_ckeywordv("y"), janet_wrap_integer(vec.y));

  return janet_wrap_struct(janet_struct_end(jvec));
}   

//==============================================================================

static Janet c_u_str_to_code(int32_t argc, Janet *argv) {    
  janet_fixarity(argc, 1);

  const char *strchar = janet_getcstring(argv, 0);
  return janet_wrap_integer((int8_t)strchar[0]);
}   

//==============================================================================

void inject_engine_symbols(JanetTable *jenv) {

  JanetReg cfuns[] = {
    {"c/screen-start", c_screen_start, ""},
    {"c/screen-end", c_screen_end, ""},
    {"c/get-time", c_get_time, ""},    
    {"c/begin-draw", c_begin_draw, ""},
    {"c/end-draw", c_end_draw, ""},
    {"c/draw-text", c_draw_text, ""},
    {"c/draw-texture", c_draw_texture, ""},    
    {"c/draw-sprite", c_draw_sprite, ""},    
    {"c/draw-pixel", c_draw_pixel, ""},
    {"c/draw-rect", c_draw_rect, ""},
    {"c/draw-rect-lines", c_draw_rect_lines, ""},    
    {"c/load-image", c_load_image, ""},
    {"c/load-sprite", c_load_sprite, ""},    
    {"c/load-texture", c_load_texture, ""},
    {"c/is-key-pressed", c_is_key_pressed, ""},
    {"c/is-key-down", c_is_key_down, ""},
    {"c/is-key-released", c_is_key_released, ""},
    {"c/is-key-up", c_is_key_up, ""},
    {"c/get-key-pressed", c_get_key_pressed, ""},
    {"c/load-font", c_load_font, ""},
    {"c/text-size", c_text_size, ""},

    {"c/u/str-to-code", c_u_str_to_code, ""},
    
    {NULL, NULL, NULL}
  };

  janet_cfuns(jenv, "c", cfuns);
}

