#pragma once
#include "VcsTag.h"
#include "common/Version.h"

constexpr bool SET_WINDOW_ICON          = true;
constexpr bool DEBUG                    = true;
constexpr bool X86                      = true;
constexpr bool BETA                     = false;
constexpr bool SNAPSHOT                 = false;
constexpr bool MOD                      = false;
constexpr bool NOHTTP                   = false;
constexpr bool LUACONSOLE               = true;
constexpr bool ALLOW_FAKE_NEWER_VERSION = true;
constexpr bool USE_UPDATESERVER         = false;
constexpr bool CAN_INSTALL              = true;
constexpr bool USE_BLUESCREEN           = false;
constexpr bool INSTALL_CHECK            = false;
constexpr bool IGNORE_UPDATES           = true;
constexpr bool ENFORCE_HTTPS            = true;
constexpr bool SECURE_CIPHERS_ONLY      = false;
constexpr bool PLATFORM_CLIPBOARD       = true;
constexpr bool USE_SYSTEM_CERT_PROVIDER = false;
constexpr bool FFTW_PLAN_MEASURE        = true;
constexpr bool ALLOW_QUIT               = true;
constexpr bool DEFAULT_TOUCH_UI         = false;
constexpr bool ALLOW_DATA_FOLDER        = true;
constexpr char PATH_SEP_CHAR            = '/';

enum ForceWindowFrameOps
{
	forceWindowFrameOpsNone, // usual behaviour
	forceWindowFrameOpsEmbedded, // e.g. into a webpage; this sweeps a few emscripten limitations under the rug
	forceWindowFrameOpsHandheld, // e.g. the system doesn't support windowed mode; includes odd setups like chromebooks
};
constexpr ForceWindowFrameOps FORCE_WINDOW_FRAME_OPS = forceWindowFrameOpsNone;

constexpr char SERVER[]         = "https://powdertoy.co.uk";
constexpr char STATICSERVER[]   = "https://static.powdertoy.co.uk";
constexpr char UPDATESERVER[]   = "";
constexpr char IDENT_PLATFORM[] = "LIN64";
constexpr char IDENT[]          = "X86_64-LINUX-GNU";
constexpr char APPNAME[]        = "The Powder Toy";
constexpr char APPCOMMENT[]     = "Physics sandbox game";
constexpr char APPEXE[]         = "powder";
constexpr char APPID[]          = "uk.co.powdertoy.tpt";
constexpr char APPDATA[]        = "The Powder Toy";
constexpr char APPVENDOR[]      = "powdertoy";

constexpr int MOD_ID               = 0;

struct DisplayVersionWithBuild
{
	Version<2> displayVersion;
	size_t build;
};
constexpr DisplayVersionWithBuild APP_VERSION = { { 98, 2 }, 372 };
constexpr DisplayVersionWithBuild UPSTREAM_VERSION = { { 98, 2 }, 372 };

constexpr auto DISPLAY_VERSION = APP_VERSION.displayVersion;

constexpr char IDENT_RELTYPE    = SNAPSHOT ? 'S' : (BETA ? 'B' : 'R');

constexpr char LOCAL_SAVE_DIR[] = "Saves";
constexpr char STAMPS_DIR[]     = "stamps";
constexpr char BRUSH_DIR[]      = "Brushes";

constexpr int httpMaxConcurrentStreams = 50;
constexpr int httpConnectTimeoutS      = 15;
