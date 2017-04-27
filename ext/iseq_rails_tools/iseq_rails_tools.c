#include <iseq_rails_tools.h>

static int whitelisted(char ch)
{
  return (ch >= 'a' && ch <= 'z') ||
         (ch >= 'A' && ch <= 'Z') ||
         (ch >= '0' && ch <= '9') ||
         (ch == '.' || ch == '_' || ch == '-');
}

static VALUE iseq_path_for(VALUE self, VALUE ruby_source_path)
{ 
  char *source_path = rb_string_value_cstr(&ruby_source_path);
  char iseq_path[strlen(source_path) * 2 + 1];

  int source_idx = 0;
  int iseq_idx = 0;

  while(source_path[source_idx] != '\0') {
    if (whitelisted(source_path[source_idx])) {
      memcpy(iseq_path + iseq_idx, source_path + source_idx, 1);
      source_idx++;
      iseq_idx++;
    } else {
      sprintf(iseq_path + iseq_idx, "%02x", source_path[source_idx]);
      source_idx++;
      iseq_idx += 2;
    }
  }
  iseq_path[iseq_idx] = '\0';

  return rb_str_new(iseq_path, iseq_idx);
}

void Init_iseq_rails_tools()
{
  VALUE IseqRailsTools = rb_define_module("IseqRailsTools");
  rb_define_singleton_method(IseqRailsTools, "iseq_path_for", iseq_path_for, 1);
}
