//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_leaf/flutter_leaf_plugin_c_api.h>
#include <flutter_window_close/flutter_window_close_plugin.h>
#include <system_tray/system_tray_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FlutterLeafPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterLeafPluginCApi"));
  FlutterWindowClosePluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterWindowClosePlugin"));
  SystemTrayPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SystemTrayPlugin"));
}
