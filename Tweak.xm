#import <Foundation/Foundation.h>
#import <substrate.h>
#import <mach-o/dyld.h>
#include "IL2CPP_Resolver.hpp"

static const char* CLASS_NAMES[] = {
    "BunnyHopController",
    "BunnyHop",
    "Aimbot",
    "AimbotController",
    "Cheat",
    "CheatMenu",
    "Menu",
    "MainMenu",
    "UIManager",
    "Panel",
    NULL
};

static const char* METHOD_NAMES[] = {
    "ShowMenu",
    "Show",
    "Open",
    "Init",
    "Awake",
    "Start",
    "OnGUI",
    "Update",
    NULL
};

__attribute__((constructor))
static void initPatch(void) {
    NSLog(@"[antisocial_patch] Initializing IL2CPP Resolver...");
    NSLog(@"[antisocial_patch] Searching for GUI classes...");

    sleep(10);

    for (int i = 0; CLASS_NAMES[i] != NULL; i++) {
        void* pClass = IL2CPP::Class::Find(CLASS_NAMES[i]);

        if (pClass == NULL) {
            NSLog(@"[antisocial_patch] Class NOT found: %s", CLASS_NAMES[i]);
            continue;
        }

        NSLog(@"[antisocial_patch] Class FOUND: %s @ %p", CLASS_NAMES[i], pClass);

        for (int j = 0; METHOD_NAMES[j] != NULL; j++) {
            void* pMethod = IL2CPP::Class::Utils::GetMethodPointer(
                CLASS_NAMES[i], METHOD_NAMES[j]);

            if (pMethod == NULL) {
                continue;
            }

            NSLog(@"[antisocial_patch] Method FOUND: %s::%s @ %p",
                  CLASS_NAMES[i], METHOD_NAMES[j], pMethod);

            typedef void (*FuncPtr)(void*);
            FuncPtr func = (FuncPtr)pMethod;
            @try {
                func(NULL);
                NSLog(@"[antisocial_patch] Called %s::%s(NULL)",
                      CLASS_NAMES[i], METHOD_NAMES[j]);
            } @catch (NSException *e) {
                NSLog(@"[antisocial_patch] Exception: %@", e);
            }
        }
    }

    NSLog(@"[antisocial_patch] Search complete.");
}
