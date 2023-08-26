//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_leaf/flutter_leaf_plugin.h>
#include <flutter_window_close/flutter_window_close_plugin.h>
#include <system_tray/system_tray_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) flutter_leaf_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FlutterLeafPlugin");
  flutter_leaf_plugin_register_with_registrar(flutter_leaf_registrar);
  g_autoptr(FlPluginRegistrar) flutter_window_close_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FlutterWindowClosePlugin");
  flutter_window_close_plugin_register_with_registrar(flutter_window_close_registrar);
  g_autoptr(FlPluginRegistrar) system_tray_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "SystemTrayPlugin");
  system_tray_plugin_register_with_registrar(system_tray_registrar);
}
