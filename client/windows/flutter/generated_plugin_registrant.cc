//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <audioplayers/audioplayers_plugin.h>
#include <libwinmedia/libwinmedia_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  AudioplayersPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("AudioplayersPlugin"));
  LibwinmediaPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("LibwinmediaPlugin"));
}
